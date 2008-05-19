#pragma rtGlobals=1		// Use modern global access method.
#pragma version=1.06

// file:	cansasXML.ipf
// author:	Pete R. Jemian <jemian@anl.gov>
// date:	2008-05-18
// purpose:  implement an IgorPro file reader to read the canSAS 1-D reduced SAS data in XML files
//			adheres to the cansas1d/1.0 standard
// readme:    http://www.smallangles.net/wgwiki/index.php/cansas1d_binding_IgorPro
// URL:	http://www.smallangles.net/wgwiki/index.php/cansas1d_documentation
//
// requires:	IgorPro (http://www.wavemetrics.com/)
//				XMLutils - XOP (http://www.igorexchange.com/project/XMLutils)

// ==================================================================
// CS_XmlReader("bimodal-test1.xml")
// CS_XmlReader("1998spheres.xml")
// CS_XmlReader("xg009036_001.xml")
// CS_XmlReader("s81-polyurea.xml")
// CS_XmlReader("cs_af1410.xml")
// ==================================================================


FUNCTION CS_XmlReader(fileName)
	//
	// open a canSAS 1-D reduced SAS XML data file
	//	returns:
	//		0 : successful
	//		-1: XML file not found
	//		-2: root element is not <SASroot> with valid canSAS namespace
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

	// check for canSAS namespace string, returns "" if not valid or not found
	STRING/G ns = CS_getDefaultNamespace(fileID)
	IF (strlen(ns) == 0 )
		errorMsg = "root element is not <SASroot> with valid canSAS namespace"
		PRINT errorMsg
		SetDataFolder $origFolder
		RETURN(-2)						// root element is not <SASroot> with valid canSAS namespace
	ENDIF
	STRING/G nsPre = "cs"
	STRING/G nsStr = nsPre + "=" + ns

	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr
	
	STRSWITCH(ns)	
	CASE "cansas1d/1.0":							// version 1.0 of the canSAS 1-D reduced SAS data standard
		PRINT fileName, "\t\t identified as: cansas1d/1.0 XML file"
		returnCode = CS_1i_parseXml(fileID)			//  This is where the action happens!
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
	CASE "cansas1d/2.0a":						// unsupported
	DEFAULT:							// optional default expression executed
		errorMsg = fileName + ": <SASroot>, namespace (" + ns + ") is not supported"
		PRINT errorMsg
		XmlCloseFile(fileID,0)
		SetDataFolder $origFolder
		RETURN(-3)						// attribute list must include version="1.0"
	ENDSWITCH

	XmlCloseFile(fileID,0)					// now close the file, without saving
	fileID = -1

	SetDataFolder root:Packages:CS_XMLreader
	KillWaves/Z M_listXPath, SASentryList
	SetDataFolder $origFolder
	RETURN(0)							// execution finished OK
END

FUNCTION/S CS_getDefaultNamespace(fileID)
	// Test here (by guessing) for the various known namespaces.
	// Return the one found in the "schemaLocation" attribute
	// since the XMLutils XOP does not provide any xmlns attributes.
	// It is possible to call XMLelemList and get the namespace directly
	// but that call can be expensive (time) when there are lots of elements.
	VARIABLE fileID
	STRING ns = "", thisNS
	STRING p = "cs"
	VARIABLE i, item
	MAKE/T/N=(1)/O nsList		// list of all possible namespaces
	nsList[0] = "cansas1d/1.0"		// first version of canSAS 1-D reduced SAS

	FOR (item = 0; item < DimSize(nsList, 0); item += 1)		// loop over all possible namespaces
		XMLlistAttr(fileID, "/cs:SASroot", p+"="+nsList[item])
		WAVE/T M_listAttr
		FOR (i = 0; i < DimSize(M_listAttr,0); i+=1)			// loop over all available attributes
			// Expect the required canSAS XML header (will fail if "schemalocation" is not found)
			IF ( CmpStr(  LowerStr(M_listAttr[i][1]),  LowerStr("schemaLocation") ) == 0 )
				thisNS = StringFromList( 0, M_listAttr[i][2], " " )	// get the first string
				IF ( strlen(thisNS) == strlen(M_listAttr[i][2]) )		// just in case tab-delimited
					thisNS = StringFromList( 0, M_listAttr[i][2], "\t" )	// get the first string
				ENDIF
				IF ( CmpStr(  TrimWS(thisNS),  nsList[item] ) == 0 )
					ns = nsList[item]
					BREAK		// found it!
				ENDIF
			ENDIF
		ENDFOR
		IF (strlen(ns))
			BREAK		// found it!
		ENDIF
	ENDFOR

	KillWaves/Z nsList, M_listAttr
	RETURN ns
END

// ==================================================================

FUNCTION CS_1i_parseXml(fileID)
	VARIABLE fileID
	SVAR errorMsg, xmlFile
	STRING/G Title, Title_folder
	VARIABLE i, j, index, SASdata_index, returnCode = 0

	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr

	// locate all the SASentry elements
	//	assume nsPre = "cs" otherwise
	// "/"+nsPre+":SASroot//"+nsPre+":SASentry"
	XmlListXpath(fileID, "/cs:SASroot//cs:SASentry", nsStr)
	WAVE/T 	M_listXPath
	STRING		SASentryPath
	DUPLICATE/O/T	M_listXPath, SASentryList

	FOR (i=0; i < DimSize(SASentryList, 0); i += 1)
		SASentryPath = SASentryList[i][0]
		SetDataFolder root:Packages:CS_XMLreader
		
		title =  CS_1i_locateTitle(fileID, SASentryPath)
		Title_folder = CS_cleanFolderName(Title)
		NewDataFolder/O/S  $Title_folder

		XmlListXpath(fileID, SASentryPath + "//cs:SASdata", nsStr)
		WAVE/T 	M_listXPath
		IF ( DimSize(M_listXPath, 0) == 1)
			CS_1i_getOneSASdata(fileID, Title, M_listXPath[0][0])
			CS_1i_collectMetadata(fileID, SASentryPath)
		ELSE
			FOR (j = 0; j < DimSize(M_listXPath, 0); j += 1)
				STRING SASdataFolder = CS_cleanFolderName("SASdata_" + num2str(j))
				NewDataFolder/O/S  $SASdataFolder
				CS_1i_getOneSASdata(fileID, Title, M_listXPath[j][0])
				CS_1i_collectMetadata(fileID, SASentryPath)
				SetDataFolder ::			// back up to parent directory
			ENDFOR
		ENDIF
		KillWaves/Z M_listXPath
	ENDFOR

	SetDataFolder root:Packages:CS_XMLreader
	KillWaves/Z M_listXPath, SASentryList
	RETURN(returnCode)
END

// ==================================================================

FUNCTION/S CS_cleanFolderName(proposal)
	STRING proposal
	STRING result
	result = CleanupName(proposal, 0)
	IF ( CheckName(result, 11) != 0 )
		result = UniqueName(result, 11, 0)
	ENDIF
	RETURN result
END

// ==================================================================

FUNCTION CS_1i_getOneSASdata(fileID, Title, SASdataPath)
	VARIABLE fileID
	STRING Title, SASdataPath
	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr
	VARIABLE i
	STRING SASdata_name, suffix = ""

	//grab the data and put it in the working data folder
	CS_1i_GetReducedSASdata(fileID, SASdataPath)

	//start the metadata
	MAKE/O/T/N=(0,2) metadata

	SVAR xmlFile = root:Packages:CS_XMLreader:xmlFile
	CS_appendMetaData(fileID, "xmlFile", "", xmlFile)

	SVAR ns = root:Packages:CS_XMLreader:ns
	CS_appendMetaData(fileID, "namespace", "", ns)
	CS_appendMetaData(fileID, "title", "", Title)
	
	XmlListXpath(fileID, SASdataPath + "/..//cs:Run", nsStr)
	WAVE/T 	M_listXPath
	FOR (i=0; i < DimSize(M_listXPath, 0); i += 1)
		IF ( DimSize(M_listXPath, 0) > 1 )
			suffix = "_" + num2str(i)
		ENDIF
		CS_appendMetaData(fileID, "Run" + suffix,  M_listXPath[i][0], "")
		CS_appendMetaData(fileID, "Run/@name" + suffix,  M_listXPath[i][0] + "/@name", "")
	ENDFOR

	SASdata_name = TrimWS(XMLstrFmXpath(fileID,  SASdataPath + "/@name", nsStr, ""))
	CS_appendMetaData(fileID, "SASdata/@name", "", SASdata_name)

	KillWaves/Z M_listXPath
END

// ==================================================================

FUNCTION CS_1i_getOneVector(file,prefix,XML_name,Igor_name)
	VARIABLE file
	STRING prefix,XML_name,Igor_name
	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr

	XmlWaveFmXpath(file,prefix+XML_name,nsStr,"")	//this loads ALL the vector's nodes at the same time
	WAVE/T M_xmlcontent
	WAVE/T W_xmlContentNodes
	IF (DimSize(M_xmlcontent, 0))	//this is a test to see if the nodes exist.  this isn't strictly necessary if you know they're there
		IF (DimSize(M_xmlcontent,1)>DimSize(M_xmlcontent,0))	//if you're not in vector mode
			MatrixTranspose M_xmlcontent
		ENDIF
		MAKE/O/D/N=(DimSize(M_xmlcontent, 0)) $Igor_name
		WAVE vect = $Igor_name
		vect=str2num(M_xmlcontent)
	ENDIF
	KILLWAVES/Z M_xmlcontent, W_xmlContentNodes
END

// ==================================================================

FUNCTION CS_1i_GetReducedSASdata(fileID, SASdataPath)
	VARIABLE fileID
	STRING SASdataPath
	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr
	STRING prefix = ""
	VARIABLE pos

	VARIABLE cansasStrict = 1		// !!!software developer's choice!!!
	IF (cansasStrict)		// only get known canSAS data vectors
		prefix = SASdataPath + "//cs:"
		// load ALL nodes of each vector (if exists) at tthe same time
		CS_1i_getOneVector(fileID, prefix, "Q", 		"Qsas")
		CS_1i_getOneVector(fileID, prefix, "I", 		"Isas")
		CS_1i_getOneVector(fileID, prefix, "Idev", 		"Idev")
		CS_1i_getOneVector(fileID, prefix, "Qdev",		"Qdev")
		CS_1i_getOneVector(fileID, prefix, "dQw", 	"dQw")
		CS_1i_getOneVector(fileID, prefix, "dQl", 		"Qsas")
		CS_1i_getOneVector(fileID, prefix, "Qmean",	"Qmean")
		CS_1i_getOneVector(fileID, prefix, "Shadowfactor", 	"Shadowfactor")
		// check them for common length
	ELSE				// search for _ANY_ data vectors
		// find the names of all the data columns and load them as vectors
	 	// this gets tricky if we want to avoid namespace references
//		XmlListXpath(fileID, "//"+nsPre+":SASentry["+num2istr(i)+"]//"+nsPre+":Idata[1]/*", nsStr)
		XmlListXpath(fileID, SASdataPath+"//cs:Idata[1]/*", nsStr)
		WAVE/T M_listXPath
		STRING xmlElement, xPathStr
		STRING igorWave
		VARIABLE j
		FOR (j = 0; j < DimSize(M_listXPath, 0); j += 1)
			xmlElement = M_listXPath[j][1]
			STRSWITCH(xmlElement)
				CASE "Q":		// IgorPro does not allow a variable named Q
				CASE "I":			// or I
					igorWave = xmlElement + "sas"
					BREAK
				DEFAULT:
					igorWave = xmlElement		// can we trust this one?
			ENDSWITCH
			xPathStr = M_listXPath[j][0]							// clear name reference
			pos = strsearch(xPathStr, "/", Inf, 3)					// peel off the tail of the string and reform
			xmlElement = xPathStr[pos,Inf]						// find last element on the path
			prefix = xPathStr[0, pos-1-4]+"/*"						// ALL Idata elements
			CS_1i_getOneVector(fileID,prefix, xmlElement, igorWave)		// loads ALL rows (Idata) of the column at the same time
		ENDFOR
		// check them for common length
	ENDIF
 
	//get rid of any mess
	KILLWAVES/z M_listXPath
END

// ==================================================================

FUNCTION CS_1i_collectMetadata(fileID, sasEntryPath)
	VARIABLE fileID
	STRING sasEntryPath
	VARIABLE i, j
	WAVE/T metadata
	STRING suffix = ""
	STRING value, detailsPath, detectorPath, notePath

	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr

	// collect some metadata
	// first, fill a table with keywords, and XPath locations, 3rd column will be values

	// handle most <SASsample> fields
	CS_appendMetaData(fileID, "sample/ID",  					sasEntryPath + "/cs:SASsample/cs:ID", "")
	CS_appendMetaData(fileID, "sample/thickness",				sasEntryPath + "/cs:SASsample/cs:thickness", "")
	CS_appendMetaData(fileID, "sample/thickness/@unit",		sasEntryPath + "/cs:SASsample/cs:thickness/@unit", "")
	CS_appendMetaData(fileID, "sample/transmission",			sasEntryPath + "/cs:SASsample/cs:transmission", "")
	CS_appendMetaData(fileID, "sample/temperature", 			sasEntryPath + "/cs:SASsample/cs:temperature", "")
	CS_appendMetaData(fileID, "sample/temperature/@unit",		sasEntryPath + "/cs:SASsample/cs:temperature/@unit", "")
	CS_appendMetaData(fileID, "sample/position/x",  			sasEntryPath + "/cs:SASsample/cs:position/cs:x", "")
	CS_appendMetaData(fileID, "sample/position/x/@unit",		sasEntryPath + "/cs:SASsample/cs:position/cs:x/@unit", "")
	CS_appendMetaData(fileID, "sample/position/y",  			sasEntryPath + "/cs:SASsample/cs:position/cs:y", "")
	CS_appendMetaData(fileID, "sample/position/y/@unit",		sasEntryPath + "/cs:SASsample/cs:position/cs:y/@unit", "")
	CS_appendMetaData(fileID, "sample/position/z",  			sasEntryPath + "/cs:SASsample/cs:position/cs:z", "")
	CS_appendMetaData(fileID, "sample/position/z/@unit",		sasEntryPath + "/cs:SASsample/cs:position/cs:z/@unit", "")
	CS_appendMetaData(fileID, "sample/orientation/roll",			sasEntryPath + "/cs:SASsample/cs:orientation/cs:roll", "")
	CS_appendMetaData(fileID, "sample/orientation/roll/@unit",	sasEntryPath + "/cs:SASsample/cs:orientation/cs:roll/@unit", "")
	CS_appendMetaData(fileID, "sample/orientation/pitch",		sasEntryPath + "/cs:SASsample/cs:orientation/cs:pitch", "")
	CS_appendMetaData(fileID, "sample/orientation/pitch/@unit",	sasEntryPath + "/cs:SASsample/cs:orientation/cs:pitch/@unit", "")
	CS_appendMetaData(fileID, "sample/orientation/yaw",			sasEntryPath + "/cs:SASsample/cs:orientation/cs:yaw", "")
	CS_appendMetaData(fileID, "sample/orientation/yaw/@unit",	sasEntryPath + "/cs:SASsample/cs:orientation/cs:yaw/@unit", "")
	// <SASsample><details> might appear multiple times, too!
	XmlListXpath(fileID, sasEntryPath+"/cs:SASsample//cs:details", nsStr)	//output: M_listXPath
	WAVE/T 	M_listXPath
	DUPLICATE/O/T   M_listXPath, detailsList
	suffix = ""
	FOR (i = 0; i < DimSize(detailsList, 0); i += 1)
		IF (DimSize(detailsList, 0) > 1)
			suffix = "_" + num2str(i)
		ENDIF
		detailsPath = detailsList[i][0]
		CS_appendMetaData(fileID, "sample/details"+suffix+"/@name", 	detailsPath + "/@name", "")
		CS_appendMetaData(fileID, "sample/details"+suffix,	 	detailsPath, "")
	ENDFOR


	// <SASinstrument>
	CS_appendMetaData(fileID, "Instrument/name",		sasEntryPath + "/cs:SASinstrument/cs:name", "")
	CS_appendMetaData(fileID, "Instrument/@name",	sasEntryPath + "/cs:SASinstrument/@name", "")

	// <SASinstrument><SASsource>
	CS_appendMetaData(fileID, "source/@name", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/@name", "")
	CS_appendMetaData(fileID, "radiation", 			sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:radiation", "")
	CS_appendMetaData(fileID, "beam/size/@name", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/@name", "")
	CS_appendMetaData(fileID, "beam/size/x", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/cs:x", "")
	CS_appendMetaData(fileID, "beam/size/x@unit", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/cs:x/@unit", "")
	CS_appendMetaData(fileID, "beam/size/y", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/cs:y", "")
	CS_appendMetaData(fileID, "beam/size/y@unit", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/cs:y/@unit", "")
	CS_appendMetaData(fileID, "beam/size/z", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/cs:z", "")
	CS_appendMetaData(fileID, "beam/size/z@unit", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_size/cs:z/@unit", "")
	CS_appendMetaData(fileID, "beam/shape", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:beam_shape", "")
	CS_appendMetaData(fileID, "wavelength", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength", "")
	CS_appendMetaData(fileID, "wavelength/@unit", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength/@unit", "")
	CS_appendMetaData(fileID, "wavelength_min", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength_min", "")
	CS_appendMetaData(fileID, "wavelength_min/@unit",	sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength_min/@unit", "")
	CS_appendMetaData(fileID, "wavelength_max", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength_max", "")
	CS_appendMetaData(fileID, "wavelength_max/@unit", 	sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength_max/@unit", "")
	CS_appendMetaData(fileID, "wavelength_spread", 		sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength_spread", "")
	CS_appendMetaData(fileID, "wavelength_spread/@unit", 	sasEntryPath + "/cs:SASinstrument/cs:SASsource/cs:wavelength_spread/@unit", "")

	// <SASinstrument><SAScollimation> might appear multiple times
	XmlListXpath(fileID, sasEntryPath+"/cs:SASinstrument//cs:SAScollimation", nsStr)	//output: M_listXPath
	WAVE/T 	M_listXPath
	DUPLICATE/O/T   M_listXPath, SAScollimationList
	STRING collimationPath
	suffix = ""
	FOR (i = 0; i < DimSize(SAScollimationList, 0); i += 1)
		IF (DimSize(SAScollimationList, 0) > 1)
			suffix = "_" + num2str(i)
		ENDIF
		collimationPath = SAScollimationList[i][0]
		CS_appendMetaData(fileID, "collimation/@name"+suffix,			collimationPath + "/@name", "")
		CS_appendMetaData(fileID, "collimation/length"+suffix,			collimationPath + "/cs:length", "")
		CS_appendMetaData(fileID, "collimation/length_unit"+suffix,		collimationPath + "/cs:length/@unit", "")
		CS_appendMetaData(fileID, "collimation/aperture/@name"+suffix,		collimationPath + "/cs:aperture/@name", "")
		CS_appendMetaData(fileID, "collimation/aperture/type"+suffix,		collimationPath + "/cs:aperture/cs:type", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/@name"+suffix,	collimationPath + "/cs:aperture/cs:size/@name", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/x"+suffix, 	collimationPath + "/cs:aperture/cs:size/cs:x", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/x/@unit"+suffix,	collimationPath + "/cs:aperture/cs:size/cs:x/@unit", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/y"+suffix, 	collimationPath + "/cs:aperture/cs:size/cs:y", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/y/@unit"+suffix,	collimationPath + "/cs:aperture/cs:size/cs:y/@unit", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/z"+suffix, 	collimationPath + "/cs:aperture/cs:size/cs:z", "")
		CS_appendMetaData(fileID, "collimation/aperture/size/z/@unit"+suffix,	collimationPath + "/cs:aperture/cs:size/cs:z/@unit", "")
		CS_appendMetaData(fileID, "collimation/aperture/distance"+suffix,	collimationPath + "/cs:aperture/cs:distance", "")
		CS_appendMetaData(fileID, "collimation/aperture/distance/@unit"+suffix, collimationPath + "/cs:aperture/cs:distance/@unit", "")
	ENDFOR

	// <SASinstrument><SASdetector> might appear multiple times
	XmlListXpath(fileID, sasEntryPath+"/cs:SASinstrument//cs:SASdetector", nsStr)	//output: M_listXPath
	WAVE/T 	M_listXPath
	DUPLICATE/O/T   M_listXPath, SASdetectorList
	suffix = ""
	FOR (i = 0; i < DimSize(SASdetectorList, 0); i += 1)
		IF (DimSize(SASdetectorList, 0) > 1)
			suffix = "_" + num2str(i)
		ENDIF
		detectorPath = SASdetectorList[i][0]
		CS_appendMetaData(fileID, "detector/@name"+suffix,			detectorPath + "/cs:name", "")
		CS_appendMetaData(fileID, "SDD"+suffix, 				detectorPath + "/cs:SDD", "")
		CS_appendMetaData(fileID, "SDD"+suffix+"/@unit",			detectorPath + "/cs:SDD/@unit", "")
		CS_appendMetaData(fileID, "detector/offset/@name"+suffix,		detectorPath + "/cs:offset/@name", "")
		CS_appendMetaData(fileID, "detector/offset/x"+suffix,			detectorPath + "/cs:offset/cs:x", "")
		CS_appendMetaData(fileID, "detector/offset/x/@unit"+suffix,		detectorPath + "/cs:offset/cs:x/@unit", "")
		CS_appendMetaData(fileID, "detector/offset/y"+suffix,			detectorPath + "/cs:offset/cs:y", "")
		CS_appendMetaData(fileID, "detector/offset/y/@unit"+suffix,		detectorPath + "/cs:offset/cs:y/@unit", "")
		CS_appendMetaData(fileID, "detector/offset/z"+suffix,			detectorPath + "/cs:offset/cs:z", "")
		CS_appendMetaData(fileID, "detector/offset/z/@unit"+suffix,		detectorPath + "/cs:offset/cs:z/@unit", "")

		CS_appendMetaData(fileID, "detector/orientation/@name"+suffix,		detectorPath + "/cs:orientation/@name", "")
		CS_appendMetaData(fileID, "detector/orientation/roll"+suffix,		detectorPath + "/cs:orientation/cs:roll", "")
		CS_appendMetaData(fileID, "detector/orientation/roll/@unit"+suffix,	detectorPath + "/cs:orientation/cs:roll/@unit", "")
		CS_appendMetaData(fileID, "detector/orientation/pitch"+suffix,  	detectorPath + "/cs:orientation/cs:pitch", "")
		CS_appendMetaData(fileID, "detector/orientation/pitch/@unit"+suffix,	detectorPath + "/cs:orientation/cs:pitch/@unit", "")
		CS_appendMetaData(fileID, "detector/orientation/yaw"+suffix,		detectorPath + "/cs:orientation/cs:yaw", "")
		CS_appendMetaData(fileID, "detector/orientation/yaw/@unit"+suffix,	detectorPath + "/cs:orientation/cs:yaw/@unit", "")

		CS_appendMetaData(fileID, "detector/beam_center/@name"+suffix,		detectorPath + "/cs:beam_center/@name", "")
		CS_appendMetaData(fileID, "detector/beam_center/x"+suffix,		detectorPath + "/cs:beam_center/cs:x", "")
		CS_appendMetaData(fileID, "detector/beam_center/x/@unit"+suffix,	detectorPath + "/cs:beam_center/cs:x/@unit", "")
		CS_appendMetaData(fileID, "detector/beam_center/y"+suffix,		detectorPath + "/cs:beam_center/cs:y", "")
		CS_appendMetaData(fileID, "detector/beam_center/y/@unit"+suffix,	detectorPath + "/cs:beam_center/cs:y/@unit", "")
		CS_appendMetaData(fileID, "detector/beam_center/z"+suffix,		detectorPath + "/cs:beam_center/cs:z", "")
		CS_appendMetaData(fileID, "detector/beam_center/z/@unit"+suffix,	detectorPath + "/cs:beam_center/cs:z/@unit", "")

		CS_appendMetaData(fileID, "detector/pixel_size/@name"+suffix,		detectorPath + "/cs:pixel_size/@name", "")
		CS_appendMetaData(fileID, "detector/pixel_size/x"+suffix,		detectorPath + "/cs:pixel_size/cs:x", "")
		CS_appendMetaData(fileID, "detector/pixel_size/x/@unit"+suffix,  	detectorPath + "/cs:pixel_size/cs:x/@unit", "")
		CS_appendMetaData(fileID, "detector/pixel_size/y"+suffix,		detectorPath + "/cs:pixel_size/cs:y", "")
		CS_appendMetaData(fileID, "detector/pixel_size/y/@unit"+suffix,  	detectorPath + "/cs:pixel_size/cs:y/@unit", "")
		CS_appendMetaData(fileID, "detector/pixel_size/z"+suffix,		detectorPath + "/cs:pixel_size/cs:z", "")
		CS_appendMetaData(fileID, "detector/pixel_size/z/@unit"+suffix,  	detectorPath + "/cs:pixel_size/cs:z/@unit", "")

		CS_appendMetaData(fileID, "slit_length"+suffix, 			detectorPath + "/cs:slit_length", "")
		CS_appendMetaData(fileID, "slit_length"+suffix+"/@unit", 		detectorPath + "/cs:slit_length/@unit", "")
	ENDFOR

	// <SASprocess> might appear multiple times
	XmlListXpath(fileID, sasEntryPath+"//cs:SASprocess", nsStr)	//output: M_listXPath
	WAVE/T 	M_listXPath
	DUPLICATE/O/T   M_listXPath, SASprocessList
	STRING SASprocessPath
	suffix = ""
	FOR (i = 0; i < DimSize(SASprocessList, 0); i += 1)
		IF (DimSize(SASprocessList, 0) > 1)
			suffix = "_" + num2str(i)
		ENDIF
		SASprocessPath = SASprocessList[i][0]
		CS_appendMetaData(fileID, "process"+suffix+"/@name",		SASprocessPath + "/@name", "")
		CS_appendMetaData(fileID, "process"+suffix+"/name",		SASprocessPath + "/cs:name", "")
		CS_appendMetaData(fileID, "process"+suffix+"/date",			SASprocessPath + "/cs:date", "")
		CS_appendMetaData(fileID, "process"+suffix+"/description",	SASprocessPath + "/cs:description", "")
		XmlListXpath(fileID, SASprocessList[i][0]+"//cs:term", nsStr)
		FOR (j = 0; j < DimSize(M_listXPath, 0); j += 1)
			CS_appendMetaData(fileID, "process"+suffix+"/term_"+num2str(j)+"/@name",	M_listXPath[j][0] + "/@name", "")
			CS_appendMetaData(fileID, "process"+suffix+"/term_"+num2str(j)+"/@unit",		M_listXPath[j][0] + "/@unit", "")
			CS_appendMetaData(fileID, "process"+suffix+"/term_"+num2str(j),				M_listXPath[j][0], "")
		ENDFOR
	ENDFOR

	// <SASnote> might appear multiple times
	XmlListXpath(fileID, sasEntryPath+"//cs:SASnote", nsStr)	//output: M_listXPath
	WAVE/T 	M_listXPath
	DUPLICATE/O/T   M_listXPath, SASnoteList
	suffix = ""
	FOR (i = 0; i < DimSize(SASnoteList, 0); i += 1)
		IF (DimSize(SASnoteList, 0) > 1)
			suffix = "_" + num2str(i)
		ENDIF
		notePath = SASnoteList[i][0]
		CS_appendMetaData(fileID, "SASnote"+suffix+"/@name", 	notePath + "/@name", "")
		CS_appendMetaData(fileID, "SASnote"+suffix,		notePath, "")
	ENDFOR

	KillWaves/Z M_listXPath, detailsList, SAScollimationList, SASdetectorList, SASprocessList, SASnoteList
END

// ==================================================================

FUNCTION/S CS_1i_locateTitle(fileID, SASentryPath)
	VARIABLE fileID
	STRING SASentryPath
	STRING TitlePath, Title
	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr

	// /cs:SASroot/cs:SASentry/cs:Title is the expected location, but it could be empty
	TitlePath = SASentryPath + "/cs:Title"
	Title = XMLstrFmXpath(fileID,  TitlePath, nsStr, "")
	// search harder for a title
	IF (strlen(Title) == 0)
		TitlePath = SASentryPath + "/@name"
		Title = XMLstrFmXpath(fileID,  TitlePath, nsStr, "")
	ENDIF
	IF (strlen(Title) == 0)
		TitlePath = SASentryPath + "/cs:SASsample/cs:ID"
		Title = XMLstrFmXpath(fileID,  TitlePath, nsStr, "")
	ENDIF
	IF (strlen(Title) == 0)
		TitlePath = SASentryPath + "/cs:SASsample/@name"
		Title = XMLstrFmXpath(fileID,  TitlePath, nsStr, "")
	ENDIF
	IF (strlen(Title) == 0)
		// last resort: make up a title
		Title = "SASentry"
		TitlePath = ""
	ENDIF
	PRINT "\t Title:", Title
	RETURN(Title)
END

// ==================================================================

FUNCTION CS_appendMetaData(fileID, key, xpath, value)
	VARIABLE fileID
	STRING key, xpath, value
	WAVE/T metadata
	STRING k, v

	SVAR nsPre = root:Packages:CS_XMLreader:nsPre
	SVAR nsStr = root:Packages:CS_XMLreader:nsStr

	k = TrimWS(key)
	IF (  strlen(k) > 0 )
		IF ( strlen(xpath) > 0 )
			value = XMLstrFmXpath(fileID,  xpath, nsStr, "")
		ENDIF
		// What if the value string has a ";" embedded?
		//  This could complicate (?compromise?) the wavenote "key=value;" syntax.
		//  But let the caller deal with it.
		v = TrimWS(ReplaceString(";", value, " :semicolon: "))
		IF ( strlen(v) > 0 )
			VARIABLE last
			last = DimSize(metadata, 0)
			Redimension/N=(last+1, 2) metadata
			metadata[last][0] = k
			metadata[last][1] = v
		ENDIF
	ENDIF
END

// ==================================================================

Function/T   TrimWS(str)
    // TrimWhiteSpace (code from Jon Tischler)
    String str
    return TrimWSL(TrimWSR(str))
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
	fList = AddListItem("1998spheres.xml", 			fList, ";", Inf)		// 2 SASentry, few thousand data points each
	fList = AddListItem("does-not-exist-file.xml", 		fList, ";", Inf)		// non-existent file
	fList = AddListItem("cs_rr_polymers.xml", 		fList, ";", Inf)		// Round Robin polymer samples from John Barnes @ NIST
	fList = AddListItem("s81-polyurea.xml", 			fList, ";", Inf)		// Round Robin polymer samples from John Barnes @ NIST
	
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


FUNCTION testCollette()

// suggestions from ISIS users
	// 3.	Loading actual data from LOQ caused some problems. Data created by Colette names files with run number. When entering full path to load the data if you use "…\example\31531.X" Igor will read \3 as a character. A simple fix which has worked for this is to use / instead of \ e.g. "…\example/31531.X".
	// I assume this will not be an issue once a proper pull down menu has been created.
	
	//4.	Once data is loaded in Igor it is relatively easy to work with but would be nicer if the SASdata was loaded into root directory (named using run number rather than generically as it is at the moment) rather than another folder.
	//This becomes more problematic when two samples are being loaded for comparison. Although still relatively easy to work with, changing the folders can lead to mistakes being made.

	//Say, for Run=31531, then Qsas_31531

	CS_XmlReader("W1W2.XML")
	STRING srcDir = "root:Packages:CS_XMLreader"
	STRING destDir = "root", importFolder, target
	Variable i, j
	FOR ( i = 0; i < CountObjects(srcDir, 4) ; i += 1 )
		SetDataFolder $srcDir
		importFolder = GetIndexedObjName(srcDir, 4, i)
		SetDataFolder $importFolder
		IF ( exists( "metadata" ) == 1 )
			// looks like a SAS data folder
			WAVE/T metadata
			STRING Run = ""
			FOR (j = 0; j < DimSize(metadata, 0); j += 1)
				IF ( CmpStr( "Run", metadata[j][0]) == 0 )
					// get the Run number and "clean" it up a bit
					Run = TrimWS(  ReplaceString("\\", metadata[j][1], "/")  )
					// !!!!!!!!!!!!!!!!! NOTE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					// need to find unique name for destination waves        
					//          THIS IS JUST AN EXAMPLE
					// Persons who implement this properly should be more elegant
					// For now, I will blast any existing and proceed blindly.
					target = "root:Qsas_" + Run
					Duplicate/O Qsas, $target
					target = "root:Isas_" + Run
					Duplicate/O Isas, $target
					IF ( exists( "Idev" ) == 1 )
						target = "root:Idev_" + Run
						Duplicate/O Idev, $target
					ENDIF
					IF ( exists( "Qdev" ) == 1 )
						target = "root:Qdev_" + Run
						Duplicate/O Qdev, $target
					ENDIF
					IF ( exists( "dQw" ) == 1 )
						target = "root:QdQw_" + Run
						Duplicate/O dQw, $target
					ENDIF
					IF ( exists( "dQl" ) == 1 )
						target = "root:dQl_" + Run
						Duplicate/O dQl, $target
					ENDIF
					IF ( exists( "Qmean" ) == 1 )
						target = "root:Qmean_" + Run
						Duplicate/O Qmean, $target
					ENDIF
					IF ( exists( "Shadowfactor" ) == 1 )
						target = "root:Shadowfactor_" + Run
						Duplicate/O Shadowfactor, $target
					ENDIF
					target = "root:metadata_" + Run
					Duplicate/O/T metadata, $target
					BREAK
				ENDIF
			ENDFOR
		ENDIF
	ENDFOR

	SetDataFolder root:
END
