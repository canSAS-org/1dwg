#pragma rtGlobals=1		// Use modern global access method.
#pragma version=1.05

// file:	cansasXML.ipf
// author:	Pete R. Jemian <jemian@anl.gov>
// date:	2008-03-31
// purpose:  implement an IgorPro file reader to read the canSAS 1-D reduced SAS data in XML files
//			adheres to the cansas1d/1.0 standard
// URL:	http://www.smallangles.net/wgwiki/index.php/cansas1d_documentation
//
// requires:	IgorPro (http://www.wavemetrics.com/)
//				XMLutils - XOP (http://www.igorexchange.com/project/XMLutils)

FUNCTION CS_XmlReader(fileName)
	//
	// open a canSAS 1-D reduced SAS XML data file
	//	returns:
	//		0 : successful
	//		-1: XML file not found
	//		-2: root element is not <SASroot>
	//		-3: <SASroot> version  is not 1.0
	//		-4: no <SASentry> elements
	//
	STRING fileName
	STRING origFolder
	STRING workingFolder = "root:Packages:CS_XMLreader"
	VARIABLE returnCode

	//
	// set up a work folder within root:Packages
	// Clear out any progress/results from previous activities
	//
	origFolder = GetDataFolder(1)
	SetDataFolder root:					// start in the root data folder
	NewDataFolder/O  root:Packages		// good practice
	KillDataFolder/Z  $workingFolder		// clear out any previous work
	NewDataFolder/O/S  $workingFolder	// Do all our work in root:XMLreader

	//
	// Try to open the named XML file (clean-up and return if failure)
	//
	VARIABLE fileID
	STRING/G errorMsg, xmlFile
	MAKE/T/N=(0,3)/O metadata
	CS_appendMetaData("xmlFile", "", fileName)
	xmlFile = fileName
	fileID = XmlOpenFile(fileName)			// open and parse the XMLfile
	IF ( fileID < 0 )
		SWITCH(fileID)					// fileID holds the return code; check it
			CASE -1:
				errorMsg = fileName + ": failed to parse XML"
			BREAK
			CASE -2:
				errorMsg = fileName + " either not found or cannot be opened for reading"
			BREAK
		ENDSWITCH
		PRINT errorMsg
		SetDataFolder $origFolder
		RETURN(-1)						// could not find file
	ENDIF

	//
	// index the XML element list
	//
	XmlElemList(fileID)					// load the elementlist into W_ElementList
	WAVE/T 	W_ElementList				// This declaration comes _after_ XmlElemList() is called

	// qualify the XML file, don't allow just any ole XML.
	IF ( CmpStr(W_ElementList[0][3], "SASroot") != 0 )		// deftly avoid namespace
		errorMsg = fileName + ": root element is not <SASroot>"
		PRINT errorMsg
		XmlCloseFile(fileID,0)
		SetDataFolder $origFolder
		RETURN(-2)						// not a canSAS XML file
	ENDIF

	// make an index to speed up searching through column 0
	Make/O/T/N=(DimSize(W_ElementList, 0)) W_ElementList_Col0
	W_ElementList_Col0 = W_ElementList[p][0]
	STRING/G nsPre = "", nsStr = ""
	CS_registerNameSpaces(fileID)				// to assist XPath construction

	// identify supported versions of canSAS XML standard
	STRING version
	version = StringByKey("version", W_ElementList[0][2])
	CS_appendMetaData("cansas_version", CS_XPath_NS("/SASroot/@version"), version)
	STRSWITCH(version)	
	CASE "1.0":							// version 1.0 of the canSAS 1-D reduced SAS data standard
		PRINT fileName, "\t\t identified as: cansas1d/1.0 XML file"
		returnCode = CS_1i_parseXml(fileID)
		IF (returnCode != 0)
			IF (strlen(errorMsg) == 0)
				errorMsg = "error while parsing the XML"
			ENDIF
			PRINT errorMsg
			XmlCloseFile(fileID,0)
			SetDataFolder $origFolder
			RETURN(returnCode)			// error while parsing the XML
		ENDIF
		BREAK
	CASE "2.0a":						// unsupported
	DEFAULT:							// optional default expression executed
		errorMsg = fileName + ": <SASroot> version (" + version + ") is not supported"
		PRINT errorMsg
		XmlCloseFile(fileID,0)
		SetDataFolder $origFolder
		RETURN(-3)						// attribute list must include version="1.0"
	ENDSWITCH

	XmlCloseFile(fileID,0)					// now close the file, without saving
	fileID = -1

	SetDataFolder $origFolder
	RETURN(0)							// execution finished OK
END

// ==================================================================

FUNCTION CS_1i_parseXml(fileID)
	VARIABLE fileID
	WAVE/T W_ElementList
	SVAR errorMsg, xmlFile
	STRING/G Title
	STRING XPathStr, Title_folder, SASdata_folder
	STRING SASentryPath, SASdataPath, RunNum
	VARIABLE i, j, index, SASdata_index, returnCode = 0

	// locate all the SASentry elements
	CS_simpleXmlListXpath(fileID, "", "/SASroot//SASentry")
	WAVE/T 	W_listXPath
	// (safer to copy W_listxpath to a local variable and allow for other calls to XMLlistXpath)
	DUPLICATE/O/T   W_listXPath, SASentryList

	IF (numpnts(SASentryList) < 1)
		errorMsg = "could not find any SASentry elements in XML file"
		PRINT errorMsg
		RETURN(-4)						// no <SASentry> elements
	ENDIF

	// Should we test here for all required elements?  That could be tedious.  And possibly unnecessary.

	// process each SASentry element
	DUPLICATE/O/T metadata, metadata_file
	FOR (i = 0; i < numpnts(SASentryList); i += 1)
		index = CS_findElementIndex(SASentryList[i])
		DUPLICATE/O/T metadata_file, metadata
		Title = CS_1i_locateTitle(fileID, CS_correctedXpathStr(SASentryList[i]))		// look in several places or use default title
		Title_folder = CleanupName(Title, 0)
		IF ( CheckName(Title_folder, 11) != 0 )
			Title_folder = UniqueName(Title_folder, 11, 0)
		ENDIF
		NewDataFolder/O  $Title_folder
		STRING/G FolderList = ""
		FolderList = AddListItem(":"+Title_folder+":", FolderList, ";", Inf)
		//
		// CS_correctedXpathStr
		SASentryPath = CS_correctedXpathStr(SASentryList[i])
		CS_1i_collectMetadata(fileID, SASentryPath)
		//
		// next, extract each SASdata block into a subfolder
		CS_simpleXmlListXpath(fileID, SASentryPath, "//SASdata")	//output: W_listXPath
		DUPLICATE/O/T   W_listXPath, SASdataList
		IF (numpnts(SASdataList) == 1)
			// only one SASdata element, place data waves in Title folder
			SASdataPath = CS_correctedXpathStr(SASdataList[0])
			SASdata_folder = ":" + Title_folder + ":"
			RunNum = "/Run"
			CS_appendMetaData( "Run",				SASentryPath+CS_XPath_NS(RunNum), 				"")
			CS_appendMetaData( "Run_name",			SASentryPath+CS_XPath_NS(RunNum + "/@name"), 	"")
			CS_appendMetaData( "SASdata_name",	SASdataPath+CS_XPath_NS("/@name"), 				"")
			PRINT "\t\t dataFolder:", SASdata_folder
			CS_1i_fillMetadataTable(fileID)
			IF (CS_1i_extractSasData(fileID, SASdataPath, SASdata_folder))
				// non-zero return code means an error, message is in errorMsg
				// What to do now?
				//	Proceed with that knowledge or discard the data folder?
				//	Go with the discard for now.
				returnCode += 1				// for later
				PRINT "\t\t" + errorMsg
				KillDataFolder/Z $Title_folder		// only 1 SASdata
				// RETURN(1)				// Can't return now.  What about other SASentry elements?
				BREAK
			ENDIF
		ELSE
			// multiple SASdata elements, place data waves in subfolders
			DUPLICATE/O/T metadata, metadata_entry
			FOR (j = 0; j < numpnts(SASdataList); j += 1)
				DUPLICATE/O/T metadata_entry, metadata
				SASdata_index = CS_findElementIndex(SASdataList[j])
				SASdataPath = CS_correctedXpathStr(SASdataList[j])
				SASdata_folder = CleanupName(StringByKey("name", W_ElementList[SASdata_index][2]), 0)
				PRINT "\t\t dataFolder:", SASdata_folder
				RunNum = "/Run["+num2str(j+1)+"]"
				CS_appendMetaData( "Run"+num2str(j),				SASdataPath+"/.."+CS_XPath_NS(RunNum), 				"")
				CS_appendMetaData( "Run"+num2str(j)+"_name",		SASdataPath+"/.."+CS_XPath_NS(RunNum + "/@name"), 	"")
				CS_appendMetaData( "SASdata"+num2str(j)+"_name",	SASdataPath+CS_XPath_NS("/@name"), 					"")
				SetDataFolder $Title_folder
				IF ( CheckName(SASdata_folder, 11) != 0 )
					SASdata_folder = UniqueName(SASdata_folder, 11, 0)
				ENDIF
				NewDataFolder/O  $SASdata_folder
				SetDataFolder ::
				SASdata_folder =  ":" + Title_folder + ":" + SASdata_folder + ":"
				FolderList = AddListItem(SASdata_folder, FolderList, ";", Inf)
				//---
				CS_1i_fillMetadataTable(fileID)
				IF (CS_1i_extractSasData(fileID, SASdataPath, SASdata_folder))
					// non-zero return code means an error, message is in errorMsg
					// What to do now?
					//	Proceed with that knowledge or discard the data folder?
					//	Go with the discard for now.
					returnCode += 1						// for later
					PRINT "\t\t" + errorMsg
					KillDataFolder/Z $SASdata_folder		// just this SASdata
					// RETURN(1)						// Can't return now.  What about other SASentry elements?
					BREAK
				ENDIF
			ENDFOR	// many SASdata
		ENDIF			// 1 or many SASdata
		MAKE/O/T/N=(3,2) admin
		admin[0][0] = "xmlFile"
		admin[0][1] = xmlFile
		admin[1][0] = "FolderList"
		admin[1][1] = FolderList
		admin[2][0] = "numSASdata"
		admin[2][1] = num2str(numpnts(SASdataList))
		Title_folder = ":" + Title_folder + ":"
		MoveWave admin, $Title_folder
		MoveString FolderList, $Title_folder
	ENDFOR		// each SASentry

	RETURN(returnCode)
END

// ==================================================================

FUNCTION CS_1i_collectMetadata(fileID, sasEntryPath)
	VARIABLE fileID
	STRING sasEntryPath
	VARIABLE i
	WAVE/T metadata
	STRING suffix = ""
	STRING value, detailsPath, detectorPath, notePath
	// collect some metadata
	// first, fill a table with keywords, and XPath locations, 3rd column will be values

	// handle most <SASsample> fields
	CS_appendMetaData("sample_ID", 						sasEntryPath+CS_XPath_NS("/SASsample/ID"), "")
	CS_appendMetaData("sample_thickness", 				sasEntryPath+CS_XPath_NS("/SASsample/thickness"), "")
	CS_appendMetaData("sample_thickness_unit", 			sasEntryPath+CS_XPath_NS("/SASsample/thickness/@unit"), "")
	CS_appendMetaData("sample_transmission", 			sasEntryPath+CS_XPath_NS("/SASsample/transmission"), "")
	CS_appendMetaData("sample_temperature", 			sasEntryPath+CS_XPath_NS("/SASsample/temperature"), "")
	CS_appendMetaData("sample_temperature_unit", 		sasEntryPath+CS_XPath_NS("/SASsample/temperature/@unit"), "")
	CS_appendMetaData("sample_position_x", 				sasEntryPath+CS_XPath_NS("/SASsample/position/x"), "")
	CS_appendMetaData("sample_position_x_unit", 			sasEntryPath+CS_XPath_NS("/SASsample/position/x/@unit"), "")
	CS_appendMetaData("sample_position_y", 				sasEntryPath+CS_XPath_NS("/SASsample/position/y"), "")
	CS_appendMetaData("sample_position_y_unit", 			sasEntryPath+CS_XPath_NS("/SASsample/position/y/@unit"), "")
	CS_appendMetaData("sample_position_z", 				sasEntryPath+CS_XPath_NS("/SASsample/position/z"), "")
	CS_appendMetaData("sample_position_z_unit", 			sasEntryPath+CS_XPath_NS("/SASsample/position/z/@unit"), "")
	CS_appendMetaData("sample_orientation_roll", 			sasEntryPath+CS_XPath_NS("/SASsample/orientation/roll"), "")
	CS_appendMetaData("sample_orientation_roll_unit", 		sasEntryPath+CS_XPath_NS("/SASsample/orientation/roll/@unit"), "")
	CS_appendMetaData("sample_orientation_pitch", 		sasEntryPath+CS_XPath_NS("/SASsample/orientation/pitch"), "")
	CS_appendMetaData("sample_orientation_pitch_unit", 	sasEntryPath+CS_XPath_NS("/SASsample/orientation/pitch/@unit"), "")
	CS_appendMetaData("sample_orientation_yaw", 			sasEntryPath+CS_XPath_NS("/SASsample/orientation/yaw"), "")
	CS_appendMetaData("sample_orientation_yaw_unit", 	sasEntryPath+CS_XPath_NS("/SASsample/orientation/yaw/@unit"), "")
	// <SASsample><details> might appear multiple times, too!
	CS_simpleXmlListXpath(fileID, sasEntryPath, "/SASsample//details")	//output: W_listXPath
	DUPLICATE/O/T   W_listXPath, detailsList
	suffix = ""
	FOR (i = 0; i < numpnts(detailsList); i += 1)
		IF (numpnts(detailsList) > 1)
			suffix = num2str(i)
		ENDIF
		detailsPath = CS_correctedXpathStr(detailsList[i])
		CS_appendMetaData("sample_details"+suffix+"_name", 	detailsPath+CS_XPath_NS("/@name"), "")
		CS_appendMetaData("sample_details"+suffix,	 		detailsPath, "")
	ENDFOR


	// <SASinstrument>
	CS_appendMetaData("Instrument_name", sasEntryPath+CS_XPath_NS("/SASinstrument/name"), "")
	CS_appendMetaData("Instrument_attr_name", sasEntryPath+CS_XPath_NS("/SASinstrument/@name"), "")

	// <SASinstrument><SASsource>
	CS_appendMetaData("source_name", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/@name"), "")
	CS_appendMetaData("radiation", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/radiation"), "")
	CS_appendMetaData("beam_size_name", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/@name"), "")
	CS_appendMetaData("beam_size_x", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/x"), "")
	CS_appendMetaData("beam_size_x_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/x/@unit"), "")
	CS_appendMetaData("beam_size_y", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/y"), "")
	CS_appendMetaData("beam_size_y_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/y/@unit"), "")
	CS_appendMetaData("beam_size_z", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/z"), "")
	CS_appendMetaData("beam_size_z_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_size/z/@unit"), "")
	CS_appendMetaData("beam_shape", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/beam_shape"), "")
	CS_appendMetaData("wavelength", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength"), "")
	CS_appendMetaData("wavelength_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength/@unit"), "")
	CS_appendMetaData("wavelength_min", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength_min"), "")
	CS_appendMetaData("wavelength_min_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength_min/@unit"), "")
	CS_appendMetaData("wavelength_max", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength_max"), "")
	CS_appendMetaData("wavelength_max_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength_max/@unit"), "")
	CS_appendMetaData("wavelength_spread", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength_spread"), "")
	CS_appendMetaData("wavelength_spread_unit", sasEntryPath+CS_XPath_NS("/SASinstrument/SASsource/wavelength_spread/@unit"), "")

	// ignore <SASinstrument><SAScollimation> for now
	CS_simpleXmlListXpath(fileID, sasEntryPath, "/SASinstrument//SAScollimation")		//output: W_listXPath
	DUPLICATE/O/T   W_listXPath, SAScollimationList
	STRING collimationPath
	suffix = ""
	FOR (i = 0; i < numpnts(SAScollimationList); i += 1)
		IF (numpnts(SAScollimationList) > 1)
			suffix = num2str(i)
		ENDIF
		collimationPath = CS_correctedXpathStr(SAScollimationList[i])
		CS_appendMetaData("collimation_name"+suffix, 	collimationPath+CS_XPath_NS("/@name"), "")
		CS_appendMetaData("collimation_distance"+suffix, 	collimationPath+CS_XPath_NS("/distance"), "")
		CS_appendMetaData("collimation_distance_unit"+suffix, 	collimationPath+CS_XPath_NS("/distance/@unit"), "")
		CS_appendMetaData("collimation_aperture_name"+suffix, 	collimationPath+CS_XPath_NS("/aperture/@name"), "")
		CS_appendMetaData("collimation_aperture_type"+suffix, 	collimationPath+CS_XPath_NS("/aperture/type"), "")
		CS_appendMetaData("collimation_aperture_size_name"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/@name"), "")
		CS_appendMetaData("collimation_aperture_size_x"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/x"), "")
		CS_appendMetaData("collimation_aperture_size_x_unit"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/x/@unit"), "")
		CS_appendMetaData("collimation_aperture_size_y"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/y"), "")
		CS_appendMetaData("collimation_aperture_size_y_unit"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/y/@unit"), "")
		CS_appendMetaData("collimation_aperture_size_z"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/z"), "")
		CS_appendMetaData("collimation_aperture_size_z_unit"+suffix, 	collimationPath+CS_XPath_NS("/aperture/size/z/@unit"), "")
		CS_appendMetaData("collimation_aperture_distance"+suffix, 	collimationPath+CS_XPath_NS("/aperture/distance"), "")
		CS_appendMetaData("collimation_aperture_distance_unit"+suffix, 	collimationPath+CS_XPath_NS("/aperture/distance/@unit"), "")
	ENDFOR

	// <SASinstrument><SASdetector> might appear multiple times
	CS_simpleXmlListXpath(fileID, sasEntryPath, "/SASinstrument//SASdetector")	//output: W_listXPath
	DUPLICATE/O/T   W_listXPath, SASdetectorList
	suffix = ""
	FOR (i = 0; i < numpnts(SASdetectorList); i += 1)
		IF (numpnts(SASdetectorList) > 1)
			suffix = num2str(i)
		ENDIF
		detectorPath = CS_correctedXpathStr(SASdetectorList[i])
		CS_appendMetaData("detector_name"+suffix, 	detectorPath+CS_XPath_NS("/name"), "")
		CS_appendMetaData("SDD"+suffix, 			detectorPath+CS_XPath_NS("/SDD"), "")
		CS_appendMetaData("SDD"+suffix+"_unit", 		detectorPath+CS_XPath_NS("/SDD/@unit"), "")
		CS_appendMetaData("detector_offset_name"+suffix, 	detectorPath+CS_XPath_NS("/offset/@name"), "")
		CS_appendMetaData("detector_offset_x"+suffix, 		detectorPath+CS_XPath_NS("/offset/x"), "")
		CS_appendMetaData("detector_offset_x_unit"+suffix, 	detectorPath+CS_XPath_NS("/offset/x/@unit"), "")
		CS_appendMetaData("detector_offset_y"+suffix, 		detectorPath+CS_XPath_NS("/offset/y"), "")
		CS_appendMetaData("detector_offset_y_unit"+suffix, 	detectorPath+CS_XPath_NS("/offset/y/@unit"), "")
		CS_appendMetaData("detector_offset_z"+suffix, 		detectorPath+CS_XPath_NS("/offset/z"), "")
		CS_appendMetaData("detector_offset_z_unit"+suffix, 	detectorPath+CS_XPath_NS("/offset/z/@unit"), "")

		CS_appendMetaData("detector_orientation_name"+suffix, 		detectorPath+CS_XPath_NS("/orientation/@name"), "")
		CS_appendMetaData("detector_orientation_roll"+suffix, 		detectorPath+CS_XPath_NS("/orientation/roll"), "")
		CS_appendMetaData("detector_orientation_roll_unit"+suffix, 	detectorPath+CS_XPath_NS("/orientation/roll/@unit"), "")
		CS_appendMetaData("detector_orientation_pitch"+suffix, 		detectorPath+CS_XPath_NS("/orientation/pitch"), "")
		CS_appendMetaData("detector_orientation_pitch_unit"+suffix, 	detectorPath+CS_XPath_NS("/orientation/pitch/@unit"), "")
		CS_appendMetaData("detector_orientation_yaw"+suffix, 		detectorPath+CS_XPath_NS("/orientation/yaw"), "")
		CS_appendMetaData("detector_orientation_yaw_unit"+suffix, 	detectorPath+CS_XPath_NS("/orientation/yaw/@unit"), "")

		CS_appendMetaData("detector_beam_center_name"+suffix, 	detectorPath+CS_XPath_NS("/beam_center/@name"), "")
		CS_appendMetaData("detector_beam_center_x"+suffix, 		detectorPath+CS_XPath_NS("/beam_center/x"), "")
		CS_appendMetaData("detector_beam_center_x_unit"+suffix, 	detectorPath+CS_XPath_NS("/beam_center/x/@unit"), "")
		CS_appendMetaData("detector_beam_center_y"+suffix, 		detectorPath+CS_XPath_NS("/beam_center/y"), "")
		CS_appendMetaData("detector_beam_center_y_unit"+suffix, 	detectorPath+CS_XPath_NS("/beam_center/y/@unit"), "")
		CS_appendMetaData("detector_beam_center_z"+suffix, 		detectorPath+CS_XPath_NS("/beam_center/z"), "")
		CS_appendMetaData("detector_beam_center_z_unit"+suffix, 	detectorPath+CS_XPath_NS("/beam_center/z/@unit"), "")

		CS_appendMetaData("detector_pixel_size_name"+suffix, 	detectorPath+CS_XPath_NS("/pixel_size/@name"), "")
		CS_appendMetaData("detector_pixel_size_x"+suffix, 		detectorPath+CS_XPath_NS("/pixel_size/x"), "")
		CS_appendMetaData("detector_pixel_size_x_unit"+suffix, 	detectorPath+CS_XPath_NS("/pixel_size/x/@unit"), "")
		CS_appendMetaData("detector_pixel_size_y"+suffix, 		detectorPath+CS_XPath_NS("/pixel_size/y"), "")
		CS_appendMetaData("detector_pixel_size_y_unit"+suffix, 	detectorPath+CS_XPath_NS("/pixel_size/y/@unit"), "")
		CS_appendMetaData("detector_pixel_size_z"+suffix, 		detectorPath+CS_XPath_NS("/pixel_size/z"), "")
		CS_appendMetaData("detector_pixel_size_z_unit"+suffix, 	detectorPath+CS_XPath_NS("/pixel_size/z/@unit"), "")

		CS_appendMetaData("slit_length"+suffix, 		detectorPath+CS_XPath_NS("/slit_length"), "")
		CS_appendMetaData("slitLength"+suffix+"_unit", 	detectorPath+CS_XPath_NS("/slit_length/@unit"), "")
	ENDFOR

	// ignore <SASprocess> for now

	// <SASnote> might appear multiple times
	CS_simpleXmlListXpath(fileID, sasEntryPath, "//SASnote")	//output: W_listXPath
	DUPLICATE/O/T   W_listXPath, SASnoteList
	suffix = ""
	FOR (i = 0; i < numpnts(SASnoteList); i += 1)
		IF (numpnts(SASnoteList) > 1)
			suffix = num2str(i)
		ENDIF
		notePath = CS_correctedXpathStr(SASnoteList[i])
		CS_appendMetaData("SASnote"+suffix+"_name", 	notePath+CS_XPath_NS("/@name"), "")
		CS_appendMetaData("SASnote"+suffix,		 		notePath, "")
	ENDFOR
	//CS_1i_fillMetadataTable(fileID)
END

// ==================================================================

FUNCTION/S CS_1i_fillMetadataTable(fileID)
	VARIABLE fileID
	WAVE/T metadata
	VARIABLE i
	STRING value
	// +++++++++++++++++++++++++ 			// try to fill the value column from the XML data
	FOR (i = 0; i < DimSize(metadata, 0); i += 1)
		IF (strlen(metadata[i][1]) > 0)				// XPathStr for this entry?
			IF (strlen(metadata[i][2])  == 0)			// not defined yet?
				value = CS_XmlStrFmXpath(fileID, metadata[i][1], "")		// get it
				// What if the value string has a ";" embedded?
				//  This will complicate (?compromise?) the wavenote "key=value;" syntax.
				metadata[i][2] = ReplaceString(";", value, " :semicolon: ")
			ENDIF
		ENDIF
	ENDFOR
END

// ==================================================================

FUNCTION/S CS_1i_locateTitle(fileID, SASentryPath)
	VARIABLE fileID
	STRING SASentryPath
	WAVE/T metadata
	STRING TitlePath, Title
	// /SASroot/SASentry/Title is the expected location, but it could be empty
	TitlePath = SASentryPath+CS_XPath_NS("/Title")
	Title = CS_XmlStrFmXpath(fileID,  TitlePath, "")
	// search harder for a title
	IF (strlen(Title) == 0)
		TitlePath = SASentryPath+CS_XPath_NS("/@name")
		Title = CS_XmlStrFmXpath(fileID,  TitlePath, "")
	ENDIF
	IF (strlen(Title) == 0)
		TitlePath = SASentryPath+CS_XPath_NS("/SASsample/ID")
		Title = CS_XmlStrFmXpath(fileID,  TitlePath, "")
	ENDIF
	IF (strlen(Title) == 0)
		TitlePath = SASentryPath+CS_XPath_NS("/SASsample/@name")
		Title = CS_XmlStrFmXpath(fileID,  TitlePath, "")
	ENDIF
	IF (strlen(Title) == 0)
		// last resort: make up a title
		Title = "SASentry"
		TitlePath = ""
	ENDIF
	PRINT "\t Title:", Title
	CS_appendMetaData("title", TitlePath, Title)
	RETURN(Title)
END

// ==================================================================

FUNCTION CS_fileExists(fileName)
	// checks if a file can be found and opened
	// !!! not needed by 2008-03-13 change in XmlOpenFile()
	STRING fileName
	VARIABLE refNum
	Open/R/Z/P=home refNum as fileName
	IF (V_flag == 0)
		CLOSE refNum
	ENDIF
	RETURN( !V_flag )
END

// ==================================================================

FUNCTION CS_appendMetaData(key, xpath, value)
	STRING key, xpath, value
	WAVE/T metadata
	VARIABLE last
	last = DimSize(metadata, 0)
	Redimension/N=(last+1, 3) metadata
	metadata[last][0] = key
	metadata[last][1] = xpath
	metadata[last][2] = value
END

// ==================================================================

FUNCTION CS_findElementIndex(matchStr)
	STRING matchStr
	//
	// support the canSAS XML file reader
	// return index where   g[index][0] == matchStr
	// return -1 if not found
	//
	WAVE/T W_ElementList_Col0

	FindValue/TEXT=matchStr    W_ElementList_Col0
	RETURN(V_value)
END

// ==================================================================

FUNCTION CS_registerNameSpaces(fileID)
	VARIABLE fileID
	//
	// The canSAS 1-D namespace is defined in the <SASroot> element.
	// We can use our own namespace prefix without further concern.
	// Other namespaces may be used in the file but this does not 
	// look for foreign (non-canSAS) elements.
	//
	WAVE/T W_ElementList
	SVAR nsPre
	SVAR nsStr
	VARIABLE i, j, index, row
	STRING testStr
	MAKE/T/N=(1,2)/O nsRegistry
	//
	nsStr = W_ElementList[0][1]		// this is the one to use
	nsPre = ""
	IF (strlen(nsStr))
		nsPre = "cs:"
		nsStr = "cs=" + nsStr
	ENDIF
	// 2008-03-14,PRJ: Now, add a workaround for the libxml2 support that affects MacOS.
	//   When using namespaces 
	//		W_ElementList[][1] != "" (it shows a namespace for this node)
	//   and with default libxml2 (v2.2) on MacOS,
	//		W_ElementList[][0] != /SASroot/SASentry ...
	//  BUT, on PCs and on MacOS with user-proveded libxml2 (?version?)
	//		W_ElementList[][0] != /*/*[1]   or /*/* ...
	//
	// Need to handle either situation.
	//  Add another column to W_ElementList that shows the corrected absolute 
	//	XPath query,  complete with namespace prefix as needed.
	Redimension/N=(DimSize(W_ElementList,0),5) W_ElementList
	W_ElementList[0,Inf][4] = ""				// clear out the last column (useful only to developer)
	W_ElementList[0][4] = CS_XPath_NS("/"+W_ElementList[0][3])
	FOR (i = 1; i < DimSize(W_ElementList,0); i += 1)
		IF (strlen(W_ElementList[i][4]) == 0)		// if not already set, then find absolute XPath string
			// For now, only handle items in the default namespace.
			// Takes more work to build in the capability to handle more namespaces
			//
			index = CS_findElementIndex(  CS_findLast(W_ElementList[i][0], "/", 1  )  )
			testStr = W_ElementList[index][4] + CS_XPath_NS("/"+W_ElementList[i][3])
			XMLlistXpath(fileID,testStr,nsStr)
			IF ( !EXISTS("W_listXPath") )
				PRINT i, testStr, " empty result from XmlListXpath()"
				BREAK
			ENDIF
			WAVE/T W_listXPath
			SWITCH(numpnts(W_listXPath))
				CASE 0:			// What?  Can't find the node we just found?
					//PRINT numpnts(W_listXPath), testStr, " !!! WARNING:  <Can't find the node we just found> in CS_registerNameSpaces()"
					PRINT i, testStr, " Foreign element namespace detected and ignored"
					BREAK
				CASE 1:			// Only one node with this element
					W_ElementList[i][4] = testStr
					BREAK
				DEFAULT:			// Multiple elements match this node; need to use indices
					// PRINT numpnts(W_listXPath), testStr
					FOR (j = 0; j < numpnts(W_listXPath); j += 1)
						index = CS_findElementIndex(  W_listXPath[j]  )
						W_ElementList[index][4] = testStr + "[" + num2str(j+1) + "]"
					ENDFOR
					BREAK
			ENDSWITCH
		ENDIF
	ENDFOR
	// PRINT StringByKey("schemaLocation", W_ElementList[0][2])
	//
	// <code comes here>
	RETURN(0)
END

// ==================================================================

FUNCTION/S CS_findLast(src, matchStr, leftSide)
	STRING src
	STRING matchStr
	VARIABLE leftSide
	// given a source string such as:   /*/*/*[7]/*/*[39]/*[2]
	// return the part on the $leftSide if the $matchStr
	// Examples:
	//	 CS_findLast( "/*/*/*[7]/*/*[39]/*[2]"  , "/", 1)		  /*/*/*[7]/*/*[39]
	//	 CS_findLast( "/*/*/*[7]/*/*[39]/*[2]"  , "/", 0)		  /*[2]
	//	 CS_findLast( "/*/*/*[7]/*/*[39]/*[2]"  , "[", 1)		  /*/*/*[7]/*/*[39]/*
	//	 CS_findLast( "/*/*/*[7]/*/*[39]/*[2]"  , "[", 0)		  [2]
	VARIABLE i
	STRING result="", test
	FOR (i=strlen(src)-1; i >= 0; i -= 1)
		IF (stringmatch(src[i], matchStr ))
			IF (leftSide)
				result = src[0,i-1]
			ELSE
				result = src[i,Inf]
			ENDIF
			RETURN(result)
		ENDIF
	ENDFOR
	RETURN(result)
END

// ==================================================================

FUNCTION/S CS_XPath_NS(simpleStr)
	// namespaces complicate the XPath description
	// this function adds namespace info as necessary to simpleStr (an XPath)
	STRING simpleStr
	SVAR nsPre
	STRING result = "", thisChar, lastChar = ""
	VARIABLE i
	FOR (i = 0; i < strlen(simpleStr); i += 1)
		//PRINT simpleStr[i]
		thisChar = simpleStr[i]
		IF ( CmpStr(lastChar, "/") == 0 )
			STRSWITCH (thisChar)
				CASE "/":
				CASE ".":
				CASE "@":
					BREAK
				DEFAULT:
					result += nsPre
			ENDSWITCH
		ENDIF
		result += thisChar
		lastChar = thisChar
	ENDFOR
	RETURN(result)
END

// ==================================================================

FUNCTION/S CS_XmlStrFmXpath(fileID, prefix, value)
	VARIABLE fileID
	STRING prefix, value
	SVAR nsStr
	STRING result
	result = TrimWS(XmlStrFmXpath(fileID, prefix + CS_XPath_NS(value), nsStr, ""))
	RETURN( result )
END

// ==================================================================

FUNCTION CS_simpleXmlWaveFmXpath(fileID, prefix, value)
	VARIABLE fileID
	STRING prefix, value
	SVAR nsStr
	XMLwaveFmXpath(fileID, prefix + CS_XPath_NS(value), nsStr, " ")	
	// output: M_xmlContent  W_xmlContentNodes
END

// ==================================================================

FUNCTION/S CS_correctedXpathStr(indexPath)
	STRING indexPath
	VARIABLE index
	STRING absolutePath
	WAVE/T		W_ElementList
	index  =  CS_findElementIndex(indexPath)
	absolutePath = W_ElementList[index][4]	// use corrected XPath string
	RETURN(absolutePath)
END

// ==================================================================

FUNCTION CS_simpleXmlListXpath(fileID, prefix, value)
	VARIABLE fileID
	STRING prefix, value
	SVAR nsStr
	XMLlistXpath(fileID, prefix + CS_XPath_NS(value), nsStr)		// output: W_listXPath
END

// ==================================================================

Function/T   TrimWS(str)
    // TrimWhiteSpace (code from Jon Tischler)
    String str
    str = TrimWSL(str)
    str = TrimWSR(str)
    return str
End

// ==================================================================

Function/T   TrimWSL(str)
    // TrimWhiteSpaceLeft (code from Jon Tischler)
    String str
    Variable i, N=strlen(str)
    for (i=0;char2num(str[i])<=32 && i<N;i+=1)    // find first non-white space
    endfor
    return str[i,Inf]
End

// ==================================================================

Function/T   TrimWSR(str)
    // TrimWhiteSpaceRight (code from Jon Tischler)
    String str
    Variable i
    for (i=strlen(str)-1; char2num(str[i])<=32 && i>=0; i-=1)    // find last non-white space
    endfor
    return str[0,i]
End

// ==================================================================

FUNCTION CS_updateWaveNote(wavName, key, value)
	STRING wavName, key, value
	STRING wavenote
	wavenote = ReplaceStringByKey(key, note($wavName), value)
	Note /K $wavName, wavenote
END

// ==================================================================

FUNCTION CS_1i_extractIdataColumn2Wave(fileID, basePath, colName, wavName)
	//
	// this function pulls one column of data from each <Idata> element
	// easier to write this as a function than debug it all the times it is needed
	//
	VARIABLE fileID
	STRING basePath, colName, wavName
	STRING unit
	WAVE/T metadata
	VARIABLE i, numPts

	//	Q values come out in multiple columns. Different nodes means different columns in M_xmlcontent
	//	Multiple values in the SAME node (i.e. a vector) get put in different rows.
	//	We are therefore going to transpose the wave
	//	(Based on example from Andrew R.J. Nelson.)
	CS_simpleXmlWaveFmXpath(fileID, basePath, "//Idata/" + colName)
	WAVE/T  M_xmlcontent, W_xmlcontentnodes
	numPts = numpnts(M_XMLcontent)
	IF (numPts > 0)
		MatrixTranspose M_XMLcontent
		MAKE/O/D/N=(numpnts(M_XMLcontent)) $wavName = str2num(M_xmlcontent[p][0])
		// don't forget the units!  Assume that all rows have the same "unit" as in the first row.
		unit = CS_XmlStrFmXpath(fileID, basePath, "/Idata[1]/"+colName+"/@unit")
		SetScale d 0, 1, unit, $wavName				// update the wave's "UNITS" string
		SetScale x 0, 1, unit, $wavName				// put it here, too, for the Data Browser
		// put unit directly into wavenote of _this_ wave
		CS_updateWaveNote(wavName, "unit", unit)		// put UNIT in wavenote
		// store all the metadata in the wavenote (for now, at least)
		FOR (i = 0; i < DimSize(metadata, 0); i += 1)
			IF (strlen(metadata[i][2]) > 0)
				// only add defined metadata to the wavenote
				CS_updateWaveNote(wavName, metadata[i][0], metadata[i][2])
			ENDIF
		ENDFOR
	ELSE
		// did not find any data
		// no need to apply special handling here; do that in the caller
	ENDIF
	//IF (numPts)
	//	PRINT "\t\t\t\t" + wavName + ": found " + num2str(numPts) + " points"
	//ENDIF
	RETURN(numPts)
END

// ==================================================================

FUNCTION CS_1i_extractSasData(fileID, SASdataPath, SASdata_folder)
	//
	// extract data from the SASdata/Idata block in a canSAS1d/v1.0 XML file
	//  (1i in the function name signifies this is a function that supports INPUT from version 1.0 XML files)
	//
	//	returns:
	//		0	no error
	//		1	number of points in waves is not the same as Qsas wave
	//
	VARIABLE fileID
	STRING SASdataPath, SASdata_folder
	WAVE/T metadata
	VARIABLE numPts, numQ
	SVAR errorMsg

	// extract each Idata column into waves
	// ignore the return codes here, check below
	numQ	= CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "Q",			"Qsas")
	IF (numQ != CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "I",			"Isas"))
		errorMsg = "number of points in Qsas and Isas waves are not identical"
		RETURN(1)
	ENDIF
	numPts = CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "Idev",		"Idev")
	IF (numPts && (numQ != numPts) )
		errorMsg = "number of points in Qsas and Idev waves are not identical"
		RETURN(1)
	ENDIF
	numPts = CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "Qdev",		"Qdev")
	IF (numPts && (numQ != numPts) )
		errorMsg = "number of points in Qsas and Qdev waves are not identical"
		RETURN(1)
	ENDIF
	numPts = CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "dQw",		"dQw")
	IF (numPts && (numQ != numPts) )
		errorMsg = "number of points in Qsas and dQw waves are not identical"
		RETURN(1)
	ENDIF
	numPts = CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "dQl",			"dQl")
	IF (numPts && (numQ != numPts) )
		errorMsg = "number of points in Qsas and dQl waves are not identical"
		RETURN(1)
	ENDIF
	numPts = CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "Qmean",		"Qmean")
	IF (numPts && (numQ != numPts) )
		errorMsg = "number of points in Qsas and Qmean waves are not identical"
		RETURN(1)
	ENDIF
	numPts = CS_1i_extractIdataColumn2Wave(fileID, SASdataPath, "Shadowfactor",	"Shadowfactor")
	IF (numPts && (numQ != numPts) )
		errorMsg = "number of points in Qsas and Shadowfactor waves are not identical"
		RETURN(1)
	ENDIF

	PRINT "\t\t\t\t found " + num2str(numpnts(Qsas)) + " points"

	// move the waves to the sample folder
	// !!!!! Missing Qsas, Isas, Qdev, and/or Idev are a broken data set
	//		This should produce an exception.  Should have been trapped by numPts tests.
	//		Best to return an error code but the caller chain is not ready to pass that to the top level, yet.
	MoveWave Qsas, $SASdata_folder				// required wave
	MoveWave Isas, $SASdata_folder				// required wave
	IF (exists("Idev") == 1)
		MoveWave Idev, $SASdata_folder			// optional wave
	ENDIF
	IF (exists("Qdev") == 1)
		MoveWave Qdev, $SASdata_folder			// optional wave
	ENDIF
	IF (exists("dQw") == 1)
		MoveWave dQw, $SASdata_folder			// optional wave
	ENDIF
	IF (exists("dQl") == 1)
		MoveWave dQl, $SASdata_folder			// optional wave
	ENDIF
	IF (exists("Qmean") == 1)
		MoveWave Qmean, $SASdata_folder		// optional wave
	ENDIF
	IF (exists("ShadowFactor") == 1)
		MoveWave ShadowFactor, $SASdata_folder	// optional wave
	ENDIF
	IF (exists("metadata") == 1)
		Duplicate/O metadata, $SASdata_folder + "metadata"
	ENDIF
	RETURN(0)			// no error
END


// ==================================================================
// ==================================================================
// ==================================================================


FUNCTION prj_grabMyXmlData()
	STRING srcDir = "root:Packages:CS_XMLreader"
	STRING destDir = "root:PRJ_canSAS"
	STRING srcFolder, destFolder, theFolder
	Variable i
	NewDataFolder/O  $destDir		// for all my imported data
	FOR ( i = 0; i < CountObjects(srcDir, 4) ; i += 1 )
		theFolder = GetIndexedObjName(srcDir, 4, i)
		srcFolder = srcDir + ":" + theFolder
		destFolder = destDir + ":" + theFolder
		// PRINT srcFolder, destFolder
		IF (DataFolderExists(destFolder))
			// !!!!!!!!!!!!!!!!! NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			// need to find unique name for destination
			// Persons who implement this properly should be more elegant
			// For now, I will blast the existing and proceed blindly.
			KillDataFolder/Z  $destFolder		// clear out any previous work
			DuplicateDataFolder $srcFolder, $destFolder
		ELSE
			DuplicateDataFolder $srcFolder, $destFolder
		ENDIF
	ENDFOR
END

FUNCTION prjTest_cansas1d()
	// unit tests for the routines under prj-readXML.ipf
	STRING theFile
	STRING fList = ""
	VARIABLE i, result, timerID, seconds
	// build a table of test data sets
	fList = AddListItem("elmo.xml", 				fList, ";", Inf)		// non-existent file
	fList = AddListItem("cansasXML.ipf", 			fList, ";", Inf)		// this file (should fail on XML parsing)
	fList = AddListItem("book.xml", 				fList, ";", Inf)		// good XML example file but not canSAS, not even close
	fList = AddListItem("bimodal-test1.xml", 		fList, ";", Inf)		// simple dataset
	fList = AddListItem("bimodal-test2-vector.xml",	fList, ";", Inf)		// version 2.0 file (no standard yet)
	fList = AddListItem("test.xml",					fList, ";", Inf)		// cs_collagen.xml with no namespace
	fList = AddListItem("test2.xml", 				fList, ";", Inf)		// version 2.0 file (no standard yet)
	fList = AddListItem("ISIS_SANS_Example.xml", 	fList, ";", Inf)		// from S. King, 2008-03-17
	fList = AddListItem("W1W2.xml", 				fList, ";", Inf)		// from S. King, 2008-03-17
	fList = AddListItem("ill_sasxml_example.xml", 	fList, ";", Inf)		// from canSAS 2007 meeting, reformatted
	fList = AddListItem("isis_sasxml_example.xml", 	fList, ";", Inf)		// from canSAS 2007 meeting, reformatted
	fList = AddListItem("r586.xml", 					fList, ";", Inf)		// from canSAS 2007 meeting, reformatted
	fList = AddListItem("r597.xml", 					fList, ";", Inf)		// from canSAS 2007 meeting, reformatted
	fList = AddListItem("xg009036_001.xml", 		fList, ";", Inf)		// foreign elements with other namespaces
	fList = AddListItem("cs_collagen.xml", 			fList, ";", Inf)		// another simple dataset, bare minimum info
	fList = AddListItem("cs_collagen_full.xml", 		fList, ";", Inf)		// more Q range than previous
	fList = AddListItem("cs_af1410.xml", 			fList, ";", Inf)		// multiple SASentry and SASdata elements
	fList = AddListItem("cansas1d-template.xml", 	fList, ";", Inf)		// multiple SASentry and SASdata elements
	//fList = AddListItem("1998spheres.xml", 			fList, ";", Inf)		// 2 SASentry, few thousand data points each
	fList = AddListItem("does-not-exist-file.xml", 		fList, ";", Inf)		// non-existent file
	fList = AddListItem("cs_rr_polymers.xml", 		fList, ";", Inf)		// Round Robin polymer samples from John Barnes @ NIST
	// try to load each data set in the table
	FOR ( i = 0; i < ItemsInList(fList) ; i += 1 )
		theFile = StringFromList(i, fList)					// walk through all test files
		// PRINT "file: ", theFile
		pathInfo home 
		//IF (CS_XmlReader(theFile) == 0)					// did the XML reader return without an error code?
		timerID = StartMStimer
		result = CS_XmlReader(ParseFilePath(5,S_path,"*",0,0) + theFile)
		seconds = StopMSTimer(timerID) * 1.0e-6
		PRINT "\t Completed in ", seconds, " seconds"
		IF (result == 0)    // did the XML reader return without an error code?
			prj_grabMyXmlData()						// move the data to my directory
		ENDIF
	ENDFOR
END


FUNCTION prjTest_writer(xmlFile)
	STRING xmlFile
	VARIABLE fileID
	STRING nsStr = "cansas1d/1.0", prefixStr = ""
	fileID = XMLcreateFile(xmlFile,"SASroot",nsStr,prefixStr)
	XMLsetAttr(fileID,		"/SASroot", 				nsStr, "version", "1.0")
	XMLsetAttr(fileID,		"/SASroot", 				nsStr, "xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
	XMLsetAttr(fileID,		"/SASroot", 				nsStr, "xsi:schemaLocation", "cansas1d/1.0    http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd")
	XMLaddNode(fileID, 	"/SASroot", 				nsStr, "SASentry", "", 1)
	XMLsetAttr(fileID,		"/SASroot/SASentry", 	nsStr, "name", "something")
	XMLaddNode(fileID, 	"/SASroot/SASentry", 	nsStr, "Title", "my very first title", 1)
	XMLaddNode(fileID, 	"/SASroot/SASentry", 	nsStr, "Run", "2008-03-19", 1)
	XMLsetAttr(fileID,		"/SASroot/SASentry/Run", nsStr, "name", "actually is a date")
	XMLsaveFile(fileID)
	XMLcloseFile(fileID,0)
END
