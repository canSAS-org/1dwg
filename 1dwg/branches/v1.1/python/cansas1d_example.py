#!/usr/bin/env python
''' 
Example use of Gnosis_utils to read cansas1d:1.1 file
'''


########### SVN repository information ###################
# $Date$
# $Author$
# $Revision$
# $URL$
# $Id$
########### SVN repository information ###################


import os
import sys
import gnosis.xml.objectify     # easy_install -U gnosis


def indra_metadata(SASentry):
    '''print metadata from APS/USAXS Indra package'''
    if 'metadata' in SASentry.__dict__:
        for metadata in SASentry.metadata:
            '''loop through the USAXS metadata'''
            print metadata.xmlns
            for index in metadata.usaxs:
                '''multiple invocations of the usaxs element'''
                for item in dir(index):
                    '''discover the element names'''
                    if item[0] == '_':    # sift out data structure management terms
                        continue
                    if item in ('PCDATA', 'name', 'xmlns'):  # sift this out
                        continue
                    s = ''
                    s += '('+index.xmlns+') '
                    s += '('+index.name+') '
                    s += item + ': '
                    s += index.__dict__[item].PCDATA
                    print s


def print_SASdata(sd):
    '''print the contents of the SASdata element'''
    numPts = len(sd.Idata)
    if 'name' in sd.__dict__:
        print 'SASdata name:', sd.name
    print '# points:', numPts
    s  = 'Q ('+sd.Idata[0].Q.unit+')'
    s += '  I ('+sd.Idata[0].I.unit+')'
    s += '  Idev ('+sd.Idata[0].Idev.unit+')'
    print s
    for Idata in sd.Idata:
        print Idata.Q.PCDATA,  Idata.I.PCDATA,  Idata.Idev.PCDATA


def print_optional_item(title, parent, item):
    ''' this item is optional and may not be present'''
    if item in parent.__dict__:
        #print item, item in parent.__dict__
        obj = parent.__dict__[item]
        s = title+':\t'
        s += obj.PCDATA
        if 'unit' in obj.__dict__:
            s += ' (' + obj.unit + ')'
        print s


def demo(xmlFile):
    print '#---------------------------------------------------'
    print 'XML:', xmlFile
    # read in the XML file
    sasxml = gnosis.xml.objectify.XML_Objectify(xmlFile).make_instance()
    # support reading v1.0 and v1.1 data files
    # v1.1 schema is backwards compatible, mostly
    if sasxml.xmlns not in ('urn:cansas1d:1.1', 'cansas1d/1.0'):
        print "Not cansas1d:1.1 file (found: %s)" % sasxml.xmlns
        return
    print 'namespace:', sasxml.xmlns
    if sasxml.version not in ('1.1', '1.0'):
        print "Not v1.1 file (found: %s)" % sasxml.version
        return
    print 'version:', sasxml.version
    SASentry = sasxml.SASentry                  # just the first one
    print 'title:', SASentry.Title.PCDATA
    print 'run:', SASentry.Run.PCDATA
    print_optional_item('instrument', SASentry.SASinstrument, 'name')
    indra_metadata(SASentry)        # foreign XML elements from APS/USAXS
    print_optional_item('sample ID', SASentry.SASsample, 'ID')
    print_optional_item('sample thickness', SASentry.SASsample, 'thickness')
    print_optional_item('sample transmission', SASentry.SASsample, 'transmission')
    if 'position' in SASentry.SASsample.__dict__:
        print_optional_item('sample X', SASentry.SASsample.position, 'x')
        print_optional_item('sample Y', SASentry.SASsample.position, 'y')
    print_SASdata(SASentry.SASdata)


if __name__ == "__main__":
    if len(sys.argv) == 2:
        demo(sys.argv[1])
    else:
        demo(os.path.join('..', 'examples', 'bimodal-test1.xml'))
        demo(os.path.join('..', 'examples', 's81-polyurea.xml'))
