#pragma rtGlobals=1		// Use modern global access method.
Function loadsasXML(filename)
String filename
variable fileID

fileID = xmlopenfile(filename)

xmlwavefmxpath(fileID, "//Q","","")
wave/t M_xmlcontent

//if you are tabular instead of vector
if(dimsize(M_xmlcontent,1) > dimsize(M_xmlcontent,0))
	matrixtranspose M_xmlcontent
endif

make/o/d/n=(dimsize(M_xmlcontent,0)) qq,II,Idev,Qdev,Qmean,shadowfactor

qq = str2num(M_xmlcontent[p][0])

xmlwavefmxpath(fileID, "//I","","")
if(dimsize(M_xmlcontent,1) > dimsize(M_xmlcontent,0))
	matrixtranspose M_xmlcontent
endif
II = str2num(M_xmlcontent)

xmlwavefmxpath(fileID, "//Idev","","")
if(dimsize(M_xmlcontent,1) > dimsize(M_xmlcontent,0))
	matrixtranspose M_xmlcontent
endif
Idev = str2num(M_xmlcontent)

xmlwavefmxpath(fileID, "//Qdev","","")
if(dimsize(M_xmlcontent,1) > dimsize(M_xmlcontent,0))
	matrixtranspose M_xmlcontent
endif
Qdev = str2num(M_xmlcontent)

xmlwavefmxpath(fileID, "//Qmean","","")
if(dimsize(M_xmlcontent,1) > dimsize(M_xmlcontent,0))
	matrixtranspose M_xmlcontent
endif
Qmean = str2num(M_xmlcontent)

xmlwavefmxpath(fileID, "//shadowfactor","","")
if(dimsize(M_xmlcontent,1) > dimsize(M_xmlcontent,0))
	matrixtranspose M_xmlcontent
endif
shadowfactor = str2num(M_xmlcontent)

killwaves/z M_xmlcontent,W_xmlcontentnodes

End