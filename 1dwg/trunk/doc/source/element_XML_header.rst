.. $Id$

.. index:: ! XML header

.. _XML header:

============================
XML header
============================

parent:
	None.  This is the start of the XML file.

..
	.. rubric:: Required header for cansas1d:1.1 XML files

.. code-block:: guess
	:linenos:
	
	<?xml version="1.0"?>
	<?xml-stylesheet type="text/xsl" href="cansasxml-html.xsl">
	<SASroot version="1.1"
			xmlns="urn:cansas1d:1.1"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="urn:cansas1d:1.1 
			                    http://www.cansas.org/formats/1.1/cansas1d.xsd">


====== ========================================================
line   Description
====== ========================================================
1      declaration that this is an XML file,
       Some XML files have an additional attribute that is not
       part of the canSAS standard:
       ``encoding='UTF-8'`` that is not included since not all
       canSAS participants are comfortable supporting UTF-8 
       (http://en.wikipedia.org/wiki/UTF-8) yet.
2      Optional :index:`XML Stylesheet` declaration to allow
       this XML file to display nicely in a (XSLT-compliant)
       WWW browser such as firefox.  The XSLT file named as 
       the argument of the *href* attribute (in this case: 
       *cansasxml-html.xsl*) **must be in the same directory** 
       as this XML file. (This requirement is part of the 
       XSLT specification.)  You can substitute a different
       XSLT file name to achieve a different formatted result.
       See http://www.w3schools.org/xsl for more help.
3      :ref:`SASroot <SASroot>` is the root element of the 
       XML file.  The *version* attribute is the version 
       number of the canSAS standard to which this file 
       has been written. 
       
       The order in which the attributes of any XML element
       appear is not important.  An attribute may not be 
       given twice in an element if the file conforms to 
       the XML standard.  Indentation is optional and is
       ignored by the XML support library.
4      Attribute declaring the default XML namespace.
5      Attribute defining *xsi* as the prefix to identify
       content tags in the *XMLSchema-instance* namespace.
6 & 7  Location of the XML Schema that defines the allowed 
       tags for this XML file.  This attribute has two 
       strings within the quotations, separated by white 
       space (a newline is acceptable).  
       The first string is the XML namespace, 
       repeated from above.  The second string is a suggested
       name of the XML Schema file.  Some XML support libraries 
       will follow the URL shown here to retrieve the
       XML Schema from the canSAS server.  Since this behavior 
       is not guaranteed by the XML standard, don't count on 
       it.
====== ========================================================
