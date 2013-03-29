.. $Id$

.. index:: ! binding; Java JAXB

.. _java.jaxb.binding:

================
Java JAXB
================

A Java binding for the cansas1d:1.1 standard has been auto-created 
using the JAXB tools from Oracle (formerly Sun, see below for more 
on JAXB) using the *cansas1d.xsd* :index:`XML Schema`.  See the 
:ref:`binding.java.download` section below.


Using the Java Binding
======================

The basics of the binding are these java statements:

.. code-block:: java

		// associate a JAXB context with the canSAS namespace URI
		jc = JAXBContext.newInstance("org.cansas.cansas1d"); 
		Unmarshaller unmarshaller = jc.createUnmarshaller();

		// open an XML file from local storage
		InputStream in = new FileInputStream("a/data/file.xml);

		// load the XML file into a Java data structure
		xmlJavaData = (JAXBElement<SASrootType>) unmarshaller.unmarshal(in);
		
		// get the SASroot object
		SASrootType sasroot = xmlJavaData.getValue()

With a `SASroot` object, one can iterate over the `SASentry` groups 
and, for instance, print the `Title` string:

.. code-block:: java

	for ( SASentryType entry : sasroot.getSASentry() ) {
		System.out.printf("SASentry Title:  %s\n", entry.getTitle());
	}

Full example
----------------------

An example that uses the binding is provided in the java support 
and is available for direct 
:download:`download <../../java/ant-eclipse/src/org/cansas/cansas1d/demo/Reader.java>`
or may be viewed using a web browser:
http://www.cansas.org/trac/browser/1dwg/trunk/java/ant-eclipse/src/org/cansas/cansas1d/demo/Reader.java

Output from `Reader.java` is::

	class: org.cansas.cansas1d.demo.Reader
	SVN ID: $Id$
	
	
	File: ./resources/cansas1d/cs_collagen.xml
	SASentry elements: 1
	SASentry
	Title:	dry chick collagen, d = 673 A, 6531 eV, X6B
	#Runs:	1
	Run@name:	
	Run:	Sep 19 1994     01:41:02 am
	#SASdata:	1
	SASdata@name:	
	#points:	125
	
	the end.
	
	
	File: ./resources/cansas1d/1998spheres.xml
	SASentry elements: 2
	SASentry
	Title:	255 nm PS spheres
	#Runs:	1
	Run@name:	
	Run:	scan2.dat, scan 5
	#SASdata:	1
	SASdata@name:	
	#points:	1824
	
	SASentry
	Title:	460 nm PS spheres
	#Runs:	1
	Run@name:	
	Run:	scan1.dat, scan 67
	#SASdata:	1
	SASdata@name:	
	#points:	3689
	
	the end.
	
	
	File: cannot_find_this.xml
	File not found: cannot_find_this.xml



.. index:: I(Q)

.. _binding.java.howto.I:

example: how to retrieve :math:`I(Q)`
============================================

This is a slightly longer example.
Look near line 75 for this code:

.. code-block:: java
	
	SASdataType sasdata = sasroot.getSASentry().getSASdata()
	// ...
	Qsas[i] = sasdata.getIdata().get(i).getQ().getValue();
	Isas[i] = sasdata.getIdata().get(i).getI().getValue();

to see the operations that unwind the data into usable *double[]*
vectors. Pretty straightforward although there is lots of
interesting, yet unnecessary, diagnostic output.  Here is a table
that describes the items in the line just shown:

==============  ================================================
java item       description
==============  ================================================
*sasdata*       *SASdataType* object
*getIdata()*    amongst the */SASdata/Idata* tuples ...
*get(i)*        ... pick the *Idata* tuple from row *i*.
*getQ()*        Just the */SASdata/Idata/Q*
*getValue()*    and specifically the value, not the unit
==============  ================================================



.. _binding.java.download:

Downloading
===========

Resources 
(JAR files and documentation) for the Java binding may be found 
in the canSAS subversion :ref:`repository`.

*cansas1d-#.#.jar*
	JAR file to add to your CLASSPATH in order to use this binding.
	Adheres to canSAS 1D standard version #.#.

*cansas1d-#.#-javadoc.jar*
	http://www.cansas.org/svn/1dwg/tags/v#.#/java/cansas1d-#.#-javadoc.jar
	
	Use this JAR file if you want to add the source code documentation
	as tooltips to your editor, such as eclipse. 
	Note that this file is compatible with any ZIP program and can be unzipped
	to provide a directory with all the documentation as a set of HTML pages.
	Start with the *index.html* page.
	Adheres to canSAS 1D standard version #.#.

*cansas1d-#.#-sources.jar*	
	JAR file of the source code.   
	Note that this is *just* the source code tree and not 
	the full project development tree for the Java (JAXB) API.
	Adheres to canSAS 1D standard version #.#.

source code (for developers)
	http://www.cansas.org/trac/browser/1dwg/trunk/java/ant-eclipse
	
	canSAS Development project subversion repository for the Java binding.  
	Only use this if you want to participate as a code developer of this binding.


.. index:: ! JAXB

JAXB: Questions and Answers
============================================

:Q: What is *JAXB*?
:A: Java Architecture for XML Binding
	(http://java.sun.com/developer/technicalArticles/WebServices/jaxb)

:Q: Wow! Is it available for other languages?
:A: Ask Google. *JAXB* is for Java. 
	(http://java.sun.com/developer/technicalArticles/WebServices/jaxb)
	
	For example: http://www.devx.com/ibm/Article/20261

.. index:: I(Q)

:Q: How do I pull out the :math:`I(Q)` data?
:A: See Java code fragment :ref:`above <binding.java.howto.I>`

:Q: Has JAXB been useful?
:A: **Very useful.**
	Since an XML Schema was defined, JAXB was 
	very useful to create a Java binding 
	automatically.  Then, *javadoc* was able to
	auto-generate the basic documentation as HTML and 
	*pdfdoclet* was able to auto-generate the 
	documentation in a PDF file.


(re)building the JAXB code
============================

To build the java files with JAXB from the XSD Schema,
refer to the JAXB documentation: [#]_

.. [#] JAXB:  http://docs.oracle.com/cd/E17802_01/webservices/webservices/docs/2.0/tutorial/doc/JAXBUsing.html

Here are the steps taken (this time).  Note that to use `xjc`, you'll need the
full JDK, not just a JVM or JRE.

::

	[jemian@gov,250,v1.1]$ mkdir -p java/ant-eclipse/src/org/cansas
	[jemian@gov,251,v1.1]$ xjc -d java/ant-eclipse/src/org/cansas cansas1d.xsd
	[jemian@gov,262,_1]$ mv *.java ..
	[jemian@gov,263,_1]$ cd ../
	[jemian@gov,264,cansas1d]$ rmdir _1
	edit package line in *.java to read::
	
		package org.cansas.cansas1d;

