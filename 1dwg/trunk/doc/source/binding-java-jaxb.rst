.. $Id$

.. index:: ! binding; Java JAXB

.. _java.jaxb.binding:

================
Java JAXB
================

A Java binding for the cansas1d:1.1 standard has been auto-created using the JAXB tools
from Sun (see below for more on JAXB) using the *cansas1d.xsd* :index:`XML Schema`.
Resources (JAR files and documentation) for the Java binding may be found in
the canSAS subversion repository: http://www.cansas.org/svn/1dwg/tags/v1.0/java

Subversion repository
	http://www.cansas.org/svn/1dwg/tags/v1.0/java
	
	canSAS subversion repository tagged release directory for the Java binding.
	Use resources from this directory in your development projects.

*cansas1d-1.0.jar*
	http://www.cansas.org/svn/1dwg/tags/v1.0/java/cansas1d-1.0.jar
	
	JAR file to add to your CLASSPATH in order to use this binding.

*cansas1d-1.0-javadoc.jar*
	http://www.cansas.org/svn/1dwg/tags/v1.0/java/cansas1d-1.0-javadoc.jar
	
	Use this JAR file if you want to add the 
	javadoc documentation as tooltips to your editor, such as eclipse. 
	(auto-generated from the project source code using maven2)
	Note that this file is compatible with any ZIP program and can be unzipped
	to provide a directory with all the documentation as a set of HTML pages.
	Start with the *index.html* page.

*cansas1d-1.0-sources.jar*
	http://www.cansas.org/svn/1dwg/tags/v1.0/java/cansas1d-1.0-sources.jar
	
	JAR file of the source code.   
	(auto-generated from the project source code using maven2)
	Note that this is *just*
	the source code tree and not the full project development tree
	for the Java (JAXB) API.

*cansas1d-1.0.pdf*
	http://www.cansas.org/svn/1dwg/tags/v1.0/java/cansas1d-1.0.pdf

	PDF file of the javadoc source code documentation.
	(auto-generated from the project source code using pdfdoclet)

source code (for developers)
	http://www.cansas.org/trac/browser/1dwg/trunk/java/maven/eclipse
	
	canSAS Development project subversion repository for the Java binding.  
	Only use this if you want to participate as a code developer of this binding.


*Example_canSAS_Reader.java*: example usage in JAVA
=======================================================

An example (*Example_canSAS_Reader.java*) has been constructed
to show how to read a cansas1d:1.1 XML file using the Java API. 

http://www.cansas.org/trac/browser/1dwg/trunk/java/maven/eclipse/src/main/java/org/scatteringsw/reader/Example_canSAS_Reader.java

In short, these are the important two lines:

.. code-block:: java

	CanSas1dType reader = new CanSas1dType();

and

.. code-block:: java

	SASrootType sasRoot = reader.open(xmlFile);

where *String xmlFile;* is the name of the XML file to be read. 
You will also need these imports:

.. code-block:: java
	:linenos:
	
	import javax.xml.bind.JAXBException;
	
	import net.smallangles.cansas1d.CanSas1dType;
	import net.smallangles.cansas1d.SASdataType;
	import net.smallangles.cansas1d.SASentryType;
	import net.smallangles.cansas1d.SASrootType;
	import net.smallangles.cansas1d.SASentryType.Run;

Also, since *CanSas1dType.open(xmlFile)* can throw a
*JAXBException*, you should use a *try{} catch {}*
clause. See the source code for the example.

.. index:: 
	Java file; Example_canSAS_Reader.java
	XML file; 1998spheres.xml

Here is a Java class that shows how to use the JAXB binding. 
Use this with any of the test data supplied with the cansas-1d-standard
directory (above). By default, it shows the two samples in the
*1998spheres.xml* example file.
(http://www.cansas.org/trac/browser/1dwg/trunk/1998spheres.xml)

.. note:: The reader will have to get the directory paths 
	right until this documentation improves.

.. literalinclude:: examples/Example_canSAS_Reader.java
   :language: java
   :linenos:

.. index:: I(Q)

example: how to retrieve :math:`I(Q)`
============================================

This is a slightly longer example.
Look near line 75 for this code:

.. code-block:: java
	
	Qsas[i] = sdt.getIdata().get(i).getQ().getValue();

to see the operations that unwind the data into usable *double[]*
vectors. Pretty straightforward although there is lots of
interesting, yet unnecessary, diagnostic output.  Here is a table
that describes the items in the line just shown:

==============  ================================================
java item       description
==============  ================================================
*sdt*           *SASdataType* object
*getIdata()*    amongst the */SASdata/Idata* tuples ...
*get(i)*        ... pick the *Idata* tuple from row *i*.
*getQ()*        Just the */SASdata/Idata/Q*
*getValue()*    and specifically the value, not the unit
==============  ================================================

.. index:: Java file; GetSASdata.java

*GetSASdata.java*
-------------------

Since the source code is rather lengthy, download it from:
http://www.cansas.org/svn/1dwg/trunk/doc/src/GetSASdata.java

..
	.. literalinclude:: examples/GetSASdata.java
	   :language: java
	   :linenos:

.. index:: Java file; java-test.java

.. _java-test.xml:

*java-test.xml*
------------------

*java-test.xml* is an example cansas1d:1.1 XML data file
(derived from the standard test file for the *lake* 
desmearing code).

.. literalinclude:: examples/java-test.xml
   :language: xml
   :linenos:


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
:A: See Java code fragment above that gets data for desmearing.  (:ref:`java-test.xml`)

:Q: Has JAXB been useful?
:A: **Very useful.**
	Since an XML Schema was defined, JAXB was 
	very useful to create a Java binding 
	automatically.  Then, *javadoc* was able to
	auto-generate the basic documentation as HTML and 
	*pdfdoclet* was able to auto-generate the 
	documentation in a PDF file.
