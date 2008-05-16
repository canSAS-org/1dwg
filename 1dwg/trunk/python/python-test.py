#!/usr/bin/env python
''' 
http://www.smallangles.net/wgwiki/index.php/cansas1d_binding_Python

Example use of Gnosis_utils to read cansas1d/1.0 file
'''

import sys
import gnosis.xml.objectify

print sys.argv[1]
sasxml = gnosis.xml.objectify.XML_Objectify(sys.argv[1]).make_instance()  
print 'title:', sasxml.SASentry.Title.PCDATA
print 'run:', sasxml.SASentry.Run.PCDATA
print 'instrument:', sasxml.SASentry.SASinstrument.name.PCDATA
print 'Q (', sasxml.SASentry.SASdata.Idata[0].Q.unit, ')  I (', sasxml.SASentry.SASdata.Idata[0].I.unit, ')'
print sasxml.SASentry.SASdata.Idata[0].Q.PCDATA,  sasxml.SASentry.SASdata.Idata[0].I.PCDATA,  sasxml.SASentry.SASdata.Idata[0].Idev.PCDATA


