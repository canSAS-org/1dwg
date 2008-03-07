#!/usr/bin/env python

# file:    cs_af1410.py
# author:  Pete R. Jemian
# date:    2008-02-25
#
# Case Study:
#
# read the AF1410 SANS data file archives and 
# build a single canSAS v1.0 reduced 1D SANS data file
#

import os
import string
import time
import types

reqDir = "/home/prjemian/af1410/"
reqDir = "historical/"
#cansasXMLFile = "./cs_af1410.xml"

aging = {}
aging["qu"] ="0.25" 
aging["hf"] ="0.5" 
aging["1h"] ="1" 
aging["2h"] ="2" 
aging["5h"] ="5" 
aging["8h"] ="8" 
aging["10"] ="10" 
aging["20"] ="20"    # a20 dataset not found!
aging["50"] ="50"
aging["cc"] ="100" 

sector = {
  "a": "nuclear sector", 
  "b": "nuclear+magnetic sector"
}


#-------------------------------------------------------------

def readVMHfile(dirName, fileName):
  '''return SANS data from file
   file contains three columns: Q, I, esd'''
  # prepare to return some information
  mylist = []
  #------------------
  # read the file into a buffer: guts
  cwd = os.getcwd()
  os.chdir(dirName)
  if (os.path.exists(fileName) != 1):
    os.chdir(cwd)
    return(mylist)
  file = open(fileName, 'r')
  guts = file.read()
  file.close()
  os.chdir(cwd)
  #------------------
  # interpret the file data
  lines = guts.split("\r")
  numLines = len(lines)
  #print numLines, " lines in the file: ", fileName
  index = 0
  while (index < numLines):
    line = lines[index].split()
    if (len(line)):
      # print line
      mylist.append(line)
    index = index + 1
  return(mylist)

#-------------------------------------------------------------

def makeXMLelement(fullTag, content='', indent=1):
  '''This is the new version of how to make XML elements'''
  #print "[%s] [%s] %d\n" % (fullTag, content, indent)
  #print type(content)
  if (type(content) == types.IntType):
    content = "%d" % (content)
  elif (type(content) == type(123.4)):
    content = "%g" % (content)
  parts = fullTag.split()
  shortTag = parts[0]
  tag = "<" + fullTag
  if (len(content)):
    tag = tag + ">"
    if (indent != 0):
      tag = tag + "\n"
      indentation = "  "
      for line in content.split("\n"):
        if (len(line) > 0):
          # indent each line of the content
          tag = tag + indentation + line + "\n"
    else:
      tag =  tag + content
    tag = tag + "</" + shortTag + ">"
  else:
    tag = tag + " />"
  return(tag + "\n")


#-------------------------------------------------------------

def makeSASentry(dirName, index, aging, sectors):
   title = "AF1410-" + index + " (AF1410 steel aged " + aging[index] + " h)"
   SASentry = ""
   SASentry = SASentry + makeXMLelement('Title', title, 0)
   # associate Run and SASdata using common "name" attribute based on sector&aging codes
   for alpha in sectors:
      SASentry = SASentry + makeXMLelement('Run name="AF1410-' + alpha + index + '"', sectors[alpha], 0)
   for alpha in sectors:
      SASentry = SASentry + makeSASdata(dirName, alpha + index + ".vmh", "AF1410-" + alpha + index)
   SASentry = SASentry + makeSASsample(title)
   SASentry = SASentry + makeSASinstrument()
   SASentry = SASentry + makeSASnote()
   return(makeXMLelement('SASentry name="' + "AF1410:" + index + '"', SASentry, 1))

def makeSASdata(dirName, fileName, name):
   Idata = ""
   Q_I_esd = readVMHfile(dirName, fileName)
   for Q, I, esd in Q_I_esd:
     str = ""
     str = str + makeXMLelement('Q unit="1/A"', Q, 0).strip() 
     str = str + makeXMLelement('I unit="1/cm"', I, 0).strip() 
     str = str + makeXMLelement('Qdev unit="1/A"', 0.001, 0).strip() 
     str = str + makeXMLelement('Idev unit="1/cm"', esd, 0).strip() 
     Idata = Idata + makeXMLelement('Idata', str, 0)
   SASdata = makeXMLelement('SASdata name="' + name + '"', Idata, 1)
   return( SASdata )

def makeSASsample(title):
  SASsample = ""
  SASsample = SASsample + makeXMLelement('ID', title, 0)
  details = "transverse saturation magnetic field (1.6 T) applied in horizontal direction to clear magnetic domain scattering"
  SASsample = SASsample + makeXMLelement('details', details, 1)
  makeXMLelement('SASsample', SASsample, 1)
  return( makeXMLelement('SASsample', SASsample, 1) )

def makeSASinstrument():
   SASinstrument = ""
   SASinstrument = SASinstrument + makeXMLelement('name', "NIST/CNRF SANS", 0)
   SASsource = ""
   SASsource = SASsource + makeXMLelement('radiation', "neutron", 0)
   SASsource = SASsource + makeXMLelement('wavelength unit="nm"', "0.85", 0)
   SASsource = SASsource + makeXMLelement('wavelength_spread unit="percent"', "25", 0)
   SASinstrument = SASinstrument + makeXMLelement('SASsource', SASsource, 1)
   SASinstrument = SASinstrument + makeXMLelement('SAScollimation',"", 0)
   SASinstrument = SASinstrument + makeXMLelement('SASdetector', makeXMLelement('name', "area", 0), 1)
   return( makeXMLelement('SASinstrument', SASinstrument, 1) )

def makeSASnote():
   authors = ""
   authors = authors + makeXMLelement('author', "A.J. Allen", 0)
   authors = authors + makeXMLelement('author', "D. Gavillet", 0)
   authors = authors + makeXMLelement('author', "J.R. Weertman", 0)
   atitle = makeXMLelement('title', "Small-Angle Neutron Scattering Studies of Carbide Precipitation in Ultrahigh-Strength Steels", 1)
   journal = makeXMLelement('journal', "Acta Metall", 0)
   volume = makeXMLelement('volume', "41", 0)
   year = makeXMLelement('year', "1993", 0)
   pages = makeXMLelement('pages', "1869-1884", 0)
   article = makeXMLelement('authors', authors, 1)
   SASnote = makeXMLelement('citation', article + atitle + journal + volume  + year + pages, 1)
   return( makeXMLelement('SASnote', SASnote, 1) )

# -------------------------------------------------------------

def makeSASroot(reqDir, aging, sector):
   xml = ""
   SASroot_tag = 'SASroot version="1.0"'
   SASroot_tag = SASroot_tag + '\n xmlns="http://www.smallangles.net/cansas1d"'
   SASroot_tag = SASroot_tag + '\n xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
   SASroot_tag = SASroot_tag + '\n xsi:schemaLocation="http://www.smallangles.net/cansas1d/ '
   SASroot_tag = SASroot_tag + '\n		       http://www.smallangles.net/cansas1d/1.0/cansas1d.xsd"'

   for index in aging:
       entry = makeSASentry(reqDir, index, aging, sector)
       #print len(entry)
       xml = xml + entry

   complete_xml = ""
   complete_xml = complete_xml + '<?xml version="1.0"?>\n'
   complete_xml = complete_xml + makeXMLelement(SASroot_tag, xml, 1)
   return( complete_xml )

# -------------------------------------------------------------

print makeSASroot(reqDir, aging, sector)
