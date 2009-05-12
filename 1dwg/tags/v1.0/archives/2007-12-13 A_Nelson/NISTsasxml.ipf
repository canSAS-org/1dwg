#pragma rtGlobals=1		// Use modern global access method.
	Structure NISTfile
	string filename
	string Run
	string title

	//<SASdata>
	Wave Q,I,Idev,Qdev,Qmean,Shadowfactor
	string unitsQ,unitsI,unitsIdev,unitsQdev,unitsQmean,unitsShadowfactor

	Variable flux_monitor
	string Q_resolution

	//<SASsample>
	variable sample_thickness
	string unitssample_thickness
	variable sample_transmission

	//SASinstrument
	string nameSASinstrument
	// SASinstrument/SASsource
	string radiation
	string beam_shape
	variable wavelength
	string unitswavelength
	variable wavelength_spread
	string unitswavelength_spread
 
	//<SAScollimation>
	variable distance_coll
	string unitsdistance_coll
	variable source_aperture
	string unitssource_aperture
	string typesource_aperture
	variable sample_aperture
	string unitssample_aperture
	string typesample_aperture

	//SASdetector         <SASdetector>
	variable offset_angle
	string unitsoffset_angle
	variable  distance_SD
	string unitsdistance_SD
	variable beam_centreX
	string unitsbeam_centreX
	variable beam_centreY
	string unitsbeam_centreY
	variable pixel_sizeX
	string unitspixel_sizeX
	variable pixel_sizeY
	string unitspixel_sizeY
	string detectortype 

	// <SASprocess name="NCNR-IGOR">
	string nameSASprocess
	string SASprocessdate
	string average_type
	string SAM_file
	string BKD_file
	string EMP_file
	string DIV_file
	string MASK_file
	string ABS_parameters
	variable TSTAND
	variable DSTAND
	string unitsDSTAND
	variable IZERO
	variable XSECT
	string unitsXSECT
	string SASnote
	Endstructure
	
Function TESTandWRITE(fileName)
String fileName
Struct NISTfile nf

nf.run = "SEP06064.SA3_AJJ_L205"
nf.title = "A1 9m"
nf.unitsQ = "/Angstrom"
nf.unitsI = "/cm"
nf.unitsIdev = "/cm"
nf.unitsQdev = "/Angstrom"
nf.unitsQmean = "/Angstrom"
nf.unitsshadowfactor = "none"

//synthesise data
make/d/o/n=100 qq,II,Idev,Qdev,qmean,shadowfactor
qq=0.003+p*0.002
II=100-p
Idev=sqrt(II)
Qdev = 0.01*qq
qmean = qq
shadowfactor = 1e-6

Wave nf.q = qq
Wave nf.I=II
Wave nf.Idev = Idev
wave nf.Qdev = Qdev
wave nf.Qmean = qmean
wave nf.shadowfactor = shadowfactor

nf.flux_monitor = 1.e8
nf.Q_resolution = "estimate"
nf.sample_thickness = 1
nf.sample_transmission = 0.33476
nf.unitssample_thickness = "mm"

nf.namesasinstrument = "NG3-SANS"
nf.radiation = "neutrons"
nf.beam_shape = "disc"
nf.wavelength = 6
nf.unitswavelength = "Angstrom"
nf.wavelength_spread = 14.3
nf.unitswavelength_spread="percent"

nf.distance_coll = 10.12
nf.unitsdistance_coll = "m"
nf.source_aperture = 50.00
nf.unitssource_aperture = "mm"
nf.typesource_aperture = "radius"
nf.unitssample_aperture = "mm"
nf.typesample_aperture = "radius"


nf.offset_angle = 0.00
nf.unitsoffset_angle = "deg"
nf.distance_SD = 9
nf.unitsdistance_SD="m"
nf.beam_centreX=68.46
nf.beam_centreY=64.30
nf.unitsbeam_centreX = "mm"
nf.unitsbeam_centreY = "mm"
nf.pixel_sizeX=5
nf.pixel_sizeY=5
nf.unitspixel_sizeX = "mm"
nf.unitspixel_sizeY = "mm"
nf.detectortype = "ORNL"

nf.nameSASprocess="NCNR-IGOR"
nf.SASprocessdate = "03-SEP-2006 11:42:47"
nf.average_type = "Circular"
nf.SAM_file = "SEP06064.SA3_AJJ_L205"
nf.BKD_file = "SEP06064.SA3_AJJ_L205"
nf.EMP_file = "SEP06064.SA3_AJJ_L205"
nf.DIV_file = "SEP06064.SA3_AJJ_L205"
nf.MASK_file = "SEP06064.SA3_AJJ_L205"

nf.TSTAND = 1.00
nf.DSTAND = 1.00
nf.unitsDSTAND = "mm"
nf.IZERO = 230.09
nf.XSECT = 1.00
nf.unitsXSECT = "mm"

nf.SASnote = "USER:MASK.COM"

writeNIST(fileName,nf)
End

Function writeNIST(fileName, NISTfileStruct)
	//the fileName for the XML file
	//TODO check that the filename is ok for the OS.
	String fileName
	Struct NISTfile &NISTfileStruct
	//where we are going to store the filereference
	variable fileID

	//create the sasXML file with SASroot
	//no namespace, no prefix
	fileID = xmlcreatefile(fileName,"SASroot","","")

	//create a version attribute for the root element
	xmlsetAttr(fileID,"/SASroot","","xml_output_version","12.07a")

	//create the SASentry node
	xmladdnode(fileID,"/SASroot","","SASentry","",1)
	
	//create the Run node
	xmladdnode(fileID,"/SASroot/SASentry","","Run",NISTfileStruct.Run,1)
	
	//create the Title node
	xmladdnode(fileID,"/SASroot/SASentry","","Title",NISTfileStruct.Title,1)
	
	//create the SASdata node
	xmladdnode(fileID,"/SASroot/SASentry","","SASdata","",1)
	
	//now for the hard part, write the data
	variable ii
	for(ii=0 ; ii<numpnts(NISTfileStruct.Q) ; ii+=1)
		xmladdnode(fileID,"/SASroot/SASentry/SASdata","","Idata","",1)
		xmladdnode(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]","","Q",num2str(NISTfileStruct.Q[ii]),1)
		xmlsetAttr(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]/Q","","units",NISTfileStruct.unitsQ)

		xmladdnode(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]","","I",num2str(NISTfileStruct.I[ii]),1)
		xmlsetAttr(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]/I","","units",NISTfileStruct.unitsI)

		xmladdnode(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]","","Idev",num2str(NISTfileStruct.Idev[ii]),1)
		xmlsetAttr(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]/Idev","","units",NISTfileStruct.unitsIdev)

		xmladdnode(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]","","Qdev",num2str(NISTfileStruct.Qdev[ii]),1)
		xmlsetAttr(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]/Qdev","","units",NISTfileStruct.unitsQdev)

		xmladdnode(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]","","Qmean",num2str(NISTfileStruct.Qmean[ii]),1)
		xmlsetAttr(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]/Qmean","","units",NISTfileStruct.unitsQmean)

		xmladdnode(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]","","shadowfactor",num2str(NISTfileStruct.shadowfactor[ii]),1)
		xmlsetAttr(fileID,"/SASroot/SASentry/SASdata/Idata["+num2istr(ii+1)+"]/shadowfactor","","units",NISTfileStruct.unitsshadowfactor)
	endfor
	
	//create the flux_monitor node
	xmladdnode(fileID,"/SASroot/SASentry","","flux_monitor",num2str(NISTfileStruct.flux_monitor),1)
	//Q_resolution node
	xmladdnode(fileID,"/SASroot/SASentry","","Q_resolution",NISTfileStruct.Q_resolution,1)
	
	//SASsample node
	xmladdnode(fileID,"/SASroot/SASentry","","SASsample","",1)
	
	//sample_thickness
	xmladdnode(fileID,"/SASroot/SASentry/SASsample","","sample_thickness",num2str(NISTfileStruct.sample_thickness),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASsample/sample_thickness","","units",NISTfileStruct.unitssample_thickness)

	//sample_transmission
	xmladdnode(fileID,"/SASroot/SASentry/SASsample","","sample_transmission",num2str(NISTfileStruct.sample_transmission),1)
	
	//SASinstrumtent
	xmladdnode(fileID,"/SASroot/SASentry","","SASinstrument","",1)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument","","name",NISTfileStruct.nameSASinstrument,1)
	
	//SASsource
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument","","SASsource","",1)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASsource","","radiation",NISTfileStruct.radiation,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASsource","","beam_shape",NISTfileStruct.beam_shape,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASsource","","wavelength",num2str(NISTfileStruct.wavelength),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASsource/wavelength","","units",NISTfileStruct.unitswavelength)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASsource","","wavelength_spread",num2str(NISTfileStruct.wavelength_spread),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASsource/wavelength_spread","","units",NISTfileStruct.unitswavelength_spread)

	//SAScollimation
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument","","SAScollimation","",1)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation","","distance_coll",num2str(NISTfileStruct.distance_coll),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation/distance_coll","","units",NISTfileStruct.unitsdistance_coll)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation","","source_aperture",num2str(NISTfileStruct.source_aperture),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation/source_aperture","","units",NISTfileStruct.unitssource_aperture)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation/source_aperture","","type",NISTfileStruct.typesource_aperture)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation","","sample_aperture",num2str(NISTfileStruct.sample_aperture),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation/sample_aperture","","units",NISTfileStruct.unitssample_aperture)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SAScollimation/sample_aperture","","type",NISTfileStruct.typesample_aperture)

	//SASdetector
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument","","SASdetector","",1)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","offset_angle",num2str(NISTfileStruct.offset_angle),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASdetector/offset_angle","","units",NISTfileStruct.unitsoffset_angle)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","distance_SD",num2str(NISTfileStruct.distance_SD),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASdetector/distance_SD","","units",NISTfileStruct.unitsdistance_SD)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","beam_centreX",num2str(NISTfileStruct.beam_centreX),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASdetector/beam_centreX","","units",NISTfileStruct.unitsbeam_centreX)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","beam_centreY",num2str(NISTfileStruct.beam_centreY),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASdetector/beam_centreY","","units",NISTfileStruct.unitsbeam_centreY)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","pixel_sizeX",num2str(NISTfileStruct.pixel_sizeX),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASdetector/pixel_sizeX","","units",NISTfileStruct.unitspixel_sizeX)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","pixel_sizeY",num2str(NISTfileStruct.pixel_sizeY),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASinstrument/SASdetector/pixel_sizeY","","units",NISTfileStruct.unitspixel_sizeY)
	xmladdnode(fileID,"/SASroot/SASentry/SASinstrument/SASdetector","","detectortype",NISTfileStruct.detectortype,1)

	//SASprocess
	xmladdnode(fileID,"/SASroot/SASentry","","SASprocess","",1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASprocess","","name",NISTfileStruct.nameSASprocess)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","date",NISTfileStruct.SASprocessdate,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","average_type",NISTfileStruct.average_type,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","SAM_file",NISTfileStruct.SAM_file,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","BKD_file",NISTfileStruct.BKD_file,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","EMP_file",NISTfileStruct.EMP_file,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","DIV_file",NISTfileStruct.DIV_file,1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","MASK_file",NISTfileStruct.MASK_file,1)

	//ABS_parameters
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","ABS_parameters","",1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess/ABS_parameters","","TSTAND",num2str(NISTfileStruct.TSTAND),1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess/ABS_parameters","","DSTAND",num2str(NISTfileStruct.DSTAND),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASprocess/ABS_parameters/DSTAND","","units",NISTfileStruct.unitsDSTAND)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess/ABS_parameters","","IZERO",num2str(NISTfileStruct.IZERO),1)
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess/ABS_parameters","","XSECT",num2str(NISTfileStruct.XSECT),1)
	xmlsetAttr(fileID,"/SASroot/SASentry/SASprocess/ABS_parameters/XSECT","","units",NISTfileStruct.unitsXSECT)
	
	//SASnote
	xmladdnode(fileID,"/SASroot/SASentry/SASprocess","","SASnote",NISTfileStruct.SASnote,1)

	//save and close the file
	xmlsavefile(fileID)
	xmlclosefile(fileID,0)

End