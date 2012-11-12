.. $Id: validation.rst 241 2012-08-27 07:15:24Z prjemian $

.. _Examples:

===================================================
Examples
===================================================

Various topics have been considered or presented in considering this standard. 
Some are described below.

.. index::
	single: XML; cansas1d/1.1 data file

.. _example.xml.data.files:

Example XML Data Files
==================================

This section presents two examples of XML Data Files adhering to the cansas1d/1.1 standard.

The first file (:ref:`data-simple.xml`) 
is a basic example and the second file (:ref:`cansas1d.xml`) 
uses almost all the allowed elements.
In each, though, most of the data has been removed to clarify the structure.

.. index:: XML file; data-simple.xml

.. _data-simple.xml:

*data-simple.xml*
---------------------

The example data file :download:`data-simple.xml <examples/data-simple.xml>`
shows just the basic elements of the cansas1d/1.1 standard.  Only a 
single data point has been shown to more clearly show the other structure.
The data file is actually an excerpt from the *bimodal-test1.xml*
(http://www.cansas.org/trac/browser/1dwg/trunk/bimodal-test1.xml)
example file in the main distribution.

.. literalinclude:: examples/data-simple.xml
   :language: xml
   :linenos:

.. index:: XML Stylesheet

The stylesheet identified on line 2 in *data-simple.xml* (:ref:`ascii3col.xsl`) is a very basic XSLT.
When the *data-simple.xml* is opened in a browser (from a directory containing both
*data-simple.xml* and *ascii3col.xsl*), the result looked like this:

	.. figure:: graphics/ascii3col.png
	    :alt: Simple XSLT view of *data-simple.xml*
	    
	    View of *data-simple.xml* in a browser after XSLT transformation using *ascii3col.xsl*.


.. index:: XML file; cansas1d.xml

.. _cansas1d.xml:

*cansas1d.xml*
---------------------

The example data file :download:`cansas1d.xml<../../cansas1d.xml>` 
(http://www.cansas.org/trac/browser/1dwg/trunk/cansas1d.xml)
shows examples
of most of the elements of the cansas1d/1.1 standard.  Only a single data 
point has been provided here to more clearly show the other structure
in the data file.

.. index:: XML; cansas1d/1.1 data file

.. literalinclude:: ../../cansas1d.xml
   :language: xml
   :linenos:



.. index::
	single: binding; XML Stylesheet (XSLT)
	see: XSLT; XML Stylesheet

.. index::  ! XML Stylesheet

.. _example.xml.stylesheets:

Example XML Stylesheets
==================================

This section presents examples of XML Stylesheets
useful for the cansas1d/1.1 standard.  
XML Stylesheets (XSLT) 
are used to transform XML documents into 
other documents such as XML documents, xhtml documents, or even ASCII text.
XML stylesheets also can be used to extract :index:`metadata`
from XML files.


.. index:: XSLT file; ascii3col.xsl

.. _ascii3col.xsl:

*ascii3col.xsl*
---------------------

The *ascii3col.xsl* stylesheet displays
all the *Idata* blocks in a cansas1d/1.1 file
in 3-column ASCII form.  Be careful using this stylesheet
on files with multiple *SASdata* or
*SASentry* blocks since this stylesheet
assumes there is only one of each of these.  While it
is the most common case to have only one of each, some of
the examples have multiple data sets.  This stylesheet will
concatenate all of the *Idata*.

.. index:: XML Stylesheet; ascii3col.xsl

.. literalinclude:: examples/ascii3col.xsl
   :language: xml
   :linenos:


.. index:: XSLT file; cansasxml-html.xsl

.. _cansasxml-html.xsl:

*cansasxml-html.xsl*
---------------------

.. index:: XML Stylesheet; cansasxml-html.xsl

The :download:`cansasxml-html.xsl <../../cansasxml-html.xsl>`  
(at almost 600 lines, it is too large to print here)
is the standard XSL stylesheet for cansas1d/1.1 files.
It shows all available :ref:`SASdata` and :index:`metadata`,
separated by the different :ref:`SASentry` blocks.
