
Java (JAXB 2.1) binding for canSAS1d/1.0 XML standard 
for reduced small-angle scattering data.

$Id$

TODO

* need to update to v1.1 canSAS standard
* need to change to http://www.cansas.org
* need to relearn *and document* how to build the java files with JAXB from the XSD Schema
  http://docs.oracle.com/cd/E17802_01/webservices/webservices/docs/2.0/tutorial/doc/JAXBUsing.html
  
  ::

    [jemian@gov,250,v1.1]$ mkdir -p java/ant-eclipse/src/org/cansas
    [jemian@gov,251,v1.1]$ xjc -d java/ant-eclipse/src/org/cansas cansas1d.xsd
    [jemian@gov,262,_1]$ mv *.java ..
    [jemian@gov,263,_1]$ cd ../
    [jemian@gov,264,cansas1d]$ rmdir _1
    edit package line in *.java to read::

      package org.cansas.cansas1d;


LICENSES

See LICENSES folder.


USE

To use the Java (JAXB 2.1) binding, all you need are 
the JAR files in the releases directory.
	http://svn.smallangles.net/svn/canSAS/1dwg/tags/v1.0/java

These are the files to download:
	cansas1d-1.0.jar
	cansas1d-1.0-javadoc.jar (optional)
	cansas1d-1.0-sources.jar (optional)


DOCUMENTATION

This is the Java binding for the cansas1d/1.0 XML 
standard for small-angle scattering data.

The code has been auto-generated using the JAXB v2.1
reference implementation from the cansas1d/1.0 XML schema.

The documentation for the code is available either:
* JAVADOC in JAR:  see above
* JAVADOC in HTML: 
**  The complete HTML is contained within the cansas1d-1.0-javadoc.jar above.  It can be extracted with any program that can extract a ZIP file.


DEVELOPMENT

To participate in the development of this code, checkout the ant-eclipse 
directory from this level. No further instructions are provided so you may
need to contact someone on the development team who understands this code.

svn co http://svn.smallangles.net/svn/canSAS/1dwg/trunk/java/ant-eclipse ./cansas1d-JAXB-ant-eclipse


REFERENCES

canSAS: 
http://www.smallangles.net/wgwiki/index.php/1D_Data_Formats_Working_Group

cansas1d/1.0 documentation:
http://svn.smallangles.net/trac/canSAS/browser/1dwg/tags/v1.0/doc/cansas-1d-1_0-manual.pdf?format=raw

cansas1d/1.0 Java binding:
http://svn.smallangles.net/svn/canSAS/1dwg/tags/v1.0/java/

JAXB reference implementation is version 2.1
See the README.txt file in the LICENSES/JAXB folder.


DEPRECATED

The code from previous versions of the packaging and distribution
(both cansas1d and maven-eclipse branches) is now deprecated and 
has been removed from the SVN repository as of about revision 179.
The last useful version of the maven build was revision 171.
