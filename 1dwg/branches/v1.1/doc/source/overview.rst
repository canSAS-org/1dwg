.. $Id$

=================
Overview
=================

.. index:: canSAS; objective
.. index:: canSAS; aims
.. index:: ! canSAS
.. index:: ! I(Q)

One of the first aims of the **canSAS**
(Collective Action for Nomadic Small-Angle Scatterers) 
forum of users, software developers, and facility staff was to discuss
better sharing of SAS data analysis software. The canSAS forum 
(http://www.cansas.org/canSAS)
identified that a significant need within the SAS
community can be satisfied by a robust, self-describing, text-based, standard format to
communicate reduced one-dimensional small-angle scattering data, :math:`I(Q)`, between users
of our facilities. Our goal has been to define such a format that leaves the data file
instantly human-readable, editable in the simplest of editors, and importable by simple
text import filters in programs that need not recognise advanced structure in the file
nor require advanced programming interfaces. The file should contain both the primary
data of :math:`I(Q)`
and also any other descriptive information (:index:`metadata`) 
about the sample, measurement, instrument, processing, or analysis steps.

Objective
================

.. index:: ! cansas1d:1.1 standard
.. index:: canSAS; objective

The cansas1d:1.1
standard meets the objectives for a 1D standard, incorporating :index:`metadata`
about the measurement, parameters and results of processing or analysis steps.
Even multiple measurements (related or unrelated) may be included within a single XML
file.


General Layout of the XML Data
====================================

.. index:: I(Q)

The canSAS 1-D standard for reduced 1-D SAS data is implemented using XML files. A
single file can contain SAS data from a single experiment or multiple experiments. All
types of relevant data (:math:`I(Q)`, :index:`metadata`) 
are described for each experiment. More details are provided below.

.. index:: element; SASroot
.. index:: element; SASentry

The basic elements of the cansas1d:1.1 standard are shown in the following table.
After an XML header, the root element of the file is :ref:`SASroot`
which contains one or more :ref:`SASentry`
elements, each of which
describes a single experiment (data set, time-slice, step in a series, new sample,
etc.). Details of the *SASentry* element are also shown in the
next figure. 
See the section :ref:`elements`
for examples of cansas1d:1.1 XML data files. 
Examples, Case Studies, and other background information
are below. More discussion can be found on the
canSAS 1D Data Formats Working Group page 
(http://www.cansas.org/wgwiki/index.php/1D_Data_Formats_Working_Group) 
and its discussion page.  
(http://www.cansas.org/wgwiki/index.php/Talk:1D_Data_Formats_Working_Group)

	.. figure:: ../../graphics/10-minimum.png
	    :alt: cansas1d:1.1 standard block diagram, minimum elements
	    
	    block diagram of minimum elements required for *cansas1d:1.1* standard

:ref:`SASroot`
	the root element of the file (after the XML header) 

:ref:`SASentry`
	describes a single experiment (data set, time-slice, step in a series, new sample, etc.) 

.. index:: ! XML header

.. _XML.header:

.. rubric:: Required header for cansas1d:1.1 XML files

.. code-block:: xml
	:linenos:
	
	<?xml version="1.0"?>
	<SASroot version="1.1"
		xmlns="cansas1d:1.1"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="cansas1d:1.1
		    http://www.cansas.org/svn/1dwg/trunk/cansas1d.xsd"
		>

.. index:
	XML header
	element; SASroot
	element; SASentry
	element; Title
	element; Run
	element; SASdata
	element; Idata
	element; SAStransmission_spectrum
	element; Tdata
	element; {any}
	element; SASsample
	element; SASinstrument
	element; SASsource
	element; SAScollimation
	element; SASdetector 
	element; SASprocess
	element; SASnote

.. rubric:: Basic elements of the canSAS 1-D standard

===============================   ===========================================================================
Element                           Description
===============================   ===========================================================================
:ref:`XML Header<XML.header>`     descriptive info required at the start of every XML file
:ref:`SASroot`                    root element of XML file
:ref:`SASentry`                   data set, time-slice, step in a series, new sample, etc.
*Title*                           for this particular :ref:`SASentry`
*Run*                             run number or ID number of experiment
*{any}*                           any XML element can be used at this point
:ref:`SASdata`                    this is where the reduced 1-D SAS data is stored
:ref:`Idata`                      a single data point of :math:`I(Q)` (and related items) in the dataset
:ref:`SAStransmission_spectrum`   any transmission spectra may be stored here
:ref:`Tdata`                      a single data point in the transmission spectrum
*{any}*                           any XML element can be used at this point
:ref:`SASsample`                  description of the sample
:ref:`SASinstrument`              description of the instrument
:ref:`SASsource`                  description of the source
:ref:`SAScollimation`             description of the collimation
:ref:`SASdetector`                description of the detector
:ref:`SASprocess`                 description of each processing or analysis step
:ref:`SASnote`                    anything at all
===============================   ===========================================================================

.. _rules:

Rules
========================

.. index:: ! unit
.. index:: ! Q
.. index::
	single: validation; against XML Schema
	single: geometry; Q
	see: units; unit
	single: geometry; translation
	single: geometry; orientation (rotation)

#. A cansas1d:1.1 XML data files will adhere to the standard if it can
	successfully :ref:`validate <validate>` against the established XML Schema.
	 
	http://www.cansas.org/trac/browser/1dwg/trunk/cansas1d.xsd
#. :math:`Q=(4 \pi / \lambda) \sin(\theta)`
	where :math:`\lambda` is the wavelength of the radiation,
	and :math:`2\theta` is the angle through which the detected radiation has been scattered.
	
	.. _Q geometry:
	
	.. figure:: ../../graphics/Q-geometry.jpg
	    :alt: Q geometry
	    :height: 200 px
	    
	    definition of Q geometry for small-angle scattering

#. units to be given in standard SI abbreviations (eg, m, cm, mm, nm, K) 
	with the following exceptions:
	
	============   ===================================================
	use this       to mean this
	============   ===================================================
	um             micrometres
	C              Celsius
	A              Angstrom
	percent        %
	fraction       fraction
	a.u.           arbitrary units
	none           no units are relevant (such as dimensionless)
	============   ===================================================

#. where reciprocal units need to be quoted, the format shall be "1/abbreviation",
	such as ``1/A``
#. use ``^`` to indicate an exponent (rather than ``**``), such as ``m^2``
#. when raised to a power, use similar to ``A^3`` or ``1/m^4`` 
	(and not ``A3`` or ``A**3`` or ``m-4``)
#. :index:`coordinate axes`:
	(See the sections titled :ref:`axes definition` and :ref:`compatibility`.)
	
	a. :math:`z` is along the trajectory of the radiation
	   (positive value in the direction towards the detector)
	#. :math:`x` is orthogonal to :math:`z` in the horizontal plane
	   (positive values increase to the right when viewed 
	   towards the incoming radiation)
	#. :math:`y` is orthogonal to :math:`z` and :math:`x` 
	   in the vertical plane (positive values increase upwards)

#. orientation (angles) describes single-axis rotations (rotations about
	multiple axes require more information):
	
	a. :index:`roll` is about :math:`z`
	#. :index:`pitch` is about  :math:`x`
	#. :index:`yaw` is about  :math:`y`

#. Binary data is not supported

.. _axes definition:

Definition of the coordinate axes
--------------------------------------

The definitions of the coordinate axes for translation and orientation 
geometry are described by the following two figures.

.. index::
	geometry; translation
	element; x
	element; y
	element; z

.. figure:: ../../graphics/translation-orientation-geometry.jpg
    :alt: view from source				       
    :width: 350 px	
    
    Coordinate axes as viewed from the source.

.. figure:: ../../graphics/translation-orientation-geometry-2.jpg
    :alt:						  
    :width: 350 px
    
    Coordinate axes as viewed from the detector.
    				  


.. _XmlWriter:

Converting data into the XML format: *XmlWriter*
====================================================

.. index:: ! xmlWriter

The canSAS/xmlWriter (http://www.cansas.org/formats/tools/xmlWriter/)
is a WWW form
to translate three-column ASCII text data into the cansas1d:1.1 XML
format. This form will help you in creating an XML file with all the required
elements in the correct places. The form requests the SAS data of *Q*, *I*, and *Idev*
(defined elsewhere on this page) and some basic :index:`metadata`
(title, run, sample info, ...).

Press the *Submit* button and you will receive a nicely
formatted WWW page with the SAS data. If you then choose *View page source*
(from one of your browser menus), you will see the raw XML of the cansas1d:1.1 XML format
and you can copy/paste this into an XML file. 

The SAS data that you paste into the form box is likely to be copied directly from
a 3-column ASCII file from a text editor. Line breaks are OK, they will be treated
as white-space as will tabs and commas. Do not be concerned that the data looks
awful in the form entry box, just check the result to see that it comes out
OK.


Documentation and Definitions
========================================

.. _cansas1d.xsd:

XML Schema
-------------

The *cansas1d.xsd* :index:`XML Schema` 
(http://www.cansas.org/trac/browser/1dwg/trunk/cansas1d.xsd)
defines the rules for the XML file format and is used to
validate any XML file for adherence to the format.

	:TRAC:
		(view source code highlighted by bug tracking system)
		
		http://www.cansas.org/trac/browser/1dwg/trunk/cansas1d.xsd

	:SVN:
		(view raw source code from version control system)
		
		http://www.cansas.org/svn/1dwg/trunk/cansas1d.xsd

XML stylesheets
----------------

An :index:`XML stylesheet`, or *XSLT* (http://www.w3schools.com/xsl/),
can be used to extract :index:`metadata` 
or to convert into another file format. The
default canSAS stylesheet *cansasxml-html.xsl*
(http://www.cansas.org/svn/1dwg/trunk/cansasxml-html.xsl)
should be copied into each folder with canSAS XML data
file(s). It can be used to display the data in a supporting WWW browser
(such as Firefox or Internet Explorer) or to import into Microsoft Excel
(with the added XML support in Excel). 

.. Steve King suggests retiring this document since it has expired URLs.
	The content is still good and may be a good addition to this document.
	It is also moved to a new URL:
	
		http://www.small-angle.ac.uk/small-angle/Formats/mainColumnParagraphs/00/text_files/file/New_canSAS_XML_Data_Format.pdf
	
	I copied that locally to refs/New_canSAS_XML_Data_Format.pdf
	
	.. tip:: See the excellent write-up by Steve King, ISIS, for an example.
	
		http://www.isis.rl.ac.uk/archive/LargeScale/LOQ/xml/cansas_xml_format.pdf
		
	

By default, MS Windows binds *.xml* files to start
Internet Explorer. Double-clicking on a canSAS XML data file with the
*cansasxml-html.xsl* (see above tip)
stylesheet in the same directory will produce a
WWW page with the SAS data and selected metadata.


Suggestions for support software that write cansas1d:1.1 XML data files
-------------------------------------------------------------------------

.. index::
	single: file; Writing cansas1d:1.1 files
	single: best practices

Some common best practices have been identified in the list below.

* be sure to update to the latest SVN repository revision:

	.. code-block:: text

		svn update

* check the output directory to see if it contains the default XSLT file
* copy the latest XSLT file to the output directory if either:
	* the output directory contains an older revision
	* the output directory does not have the default XSLT file
* The most recent XSLT file can be identified by examining the file
	for the *$ Revision: $* string, such as in the next example. 
	
	.. code-block:: text
	
		# $Revision$


Examples and Case Studies
=========================================================

.. index:: XML file; cansas1d.xml

:Basic example:
	http://www.cansas.org/trac/browser/1dwg/trunk/cansas1d.xml
	
    Note that, for clarity, only one row of data is
    shown. This is probably a very good example to use as a starting point for
    creating XML files with a text editor.

.. index:: XML file; bimodal-test1.xml
.. index:: case study; bimodal test data

:Bimodal test data:
	http://www.cansas.org/trac/browser/1dwg/trunk/bimodal-test1.xml

    Simulated SAS data (with added noise) calculated from model bimodal size 
    distribution to test size distribution analysis routines.


.. index:: case study; glassy carbon round robin

:Glassy Carbon Round Robin:
	http://www.cansas.org/wgwiki/index.php/Glassy_Carbon_Round_Robin

    Samples of a commercial glassy carbon
    measured at several facilities worldwide.

.. index:: case study; dry chick collagen SAXS

:dry chick collagen SAXS:
	see :ref:`case_study-collagen` section
	
	SAXS data from *dry chick collagen* illustrates the
	minimum information necessary to meet the requirements of the standard
	format.

.. index:: case study; AF1410 steel SANS

:AF1410 steel SANS:
	see :ref:`case_study-af1410` section
	
	SANS data from *AF1410 steel* using magnetic
	contrast variation (with multiple samples and multiple data sets for each
	sample), the files can be viewed from the TRAC site (no description yet).
	
	http://www.cansas.org/trac/browser/1dwg/trunk/examples/af1410/

.. index:: XML file; cansas1d-template.xml

:Test all the cansas1d:1.1 rules:
	http://www.cansas.org/trac/browser/1dwg/trunk/cansas1d-template.xml
	
    The *cansas1d-template.xml* data file is used to test all the rules in the XML
    Schema. This is probably not a very good example to use as a starting point
    for creating XML files with a text editor since it tests many of the
    special-case rules.


XML layout for multiple experiments
-------------------------------------------

.. index::
	single: multiple experiments
	single: multiple data sets

Each experiment is described with a single *SASentry* element. The
fragment below shows how multiple experiments with multiple data sets
can be included in a single XML file. This illustrates using more than
one *SASentry* and more than one *SASdata* element.

.. literalinclude:: examples/brief-sketch-multiple.xml
   :language: xml
   :linenos:

Full examples of canSAS XML files with multiple experiments
include:

.. index:: XML file; W1W2.XML

:multiple data sets:
	ISIS LOQ SANS instrument: 
	
	http://www.cansas.org/trac/browser/1dwg/trunk/W1W2.XML

.. index:: XML file; cs_af1410.xml

:multiple samples, multiple data sets:
	AF1410 steel SANS contrast variation study from NIST:
	
	http://www.cansas.org/trac/browser/1dwg/trunk/examples/af1410/cs_af1410.xml
	
    SANS study using magnetic
    contrast variation (with multiple samples and multiple data sets for each
    sample), the files can be viewed from the TRAC site (no description yet).

Foreign Elements
------------------------

.. index:: XML; foreign elements

To allow for inclusion of elements that are not defined by the 
*cansas1d.xsd* XML Schema, XML **foreign elements** 
are permitted at select locations in the
cansas1d:1.1 format. Please refer to the :ref:`XML Help` section 
for more help with XML foreign elements.

.. note::  **Need to make another example.**
	This example was based on v1.0.  With v1.1, there is no need for
	the foreign namespace in this example.  

There is an example that demonstrates the use of a foreign namespace:
http://www.cansas.org/trac/browser/1dwg/data/Glassy%20Carbon/ISIS/GLASSYC_C4G8G9_withTL.xml

This example uses a foreign namespace to record the transmission spectrum related to
the acquisition of the SANS data at a time-of-flight facility. Look near line 153
for this element::

	<transmission_spectrum xmlns="urn:transmission:spectrum">

The foreign namespace given (``urn:transmission:spectrum``) becomes the 
default namespace for just the *transmission_spectrum* element.*

Also refer to canSAS TRAC ticket #47
(http://www.cansas.org/trac/changeset/47)
for an example of arranging the content in 
*SASprocessnote* to avoid the use of foreign namespace
elements.

Support tools for Visualization & Analysis software
=========================================================

Support for importing cansas1d:1.1 files exists for 
these languages and environments: 

.. index::
	single: binding; FORTRAN
	see: FORTRAN; binding, FORTRAN

:FORTRAN:
	See the :ref:`fortran.binding` section.

.. index::
	single: binding; IgorPro
	see: IgorPro; binding, IgorPro

:IgorPro:
	See the :ref:`IgorPro.binding` section.

.. index::
	single: binding; Java JAXB
	see: Java JAXB; binding, Java JAXB

:Java JAXB:
	See the :ref:`Java.JAXB.binding` section.

.. index::
	single: binding; Microsoft Excel
	see: Microsoft Excel; binding, Microsoft Excel

:Microsoft Excel:
	Support for Microsoft Excel is provided through the default canSAS stylesheet,
	*cansasxml-html.xsl* (http://www.cansas.org/svn/1dwg/trunk/cansasxml-html.xsl).
	The ISIS **LOQ** instrument (http://www.isis.stfc.ac.uk/instruments/loq/loq2470.html)
	has provided an excellent description of how to import data from the cansas1d:1.1 format into Excel.
	Also note that the old WWW site (http://www.isis.rl.ac.uk/archive/LargeScale/LOQ/loq.htm)
	may still be available. 

.. index::
	single: binding; PHP
	see: PHP; binding, PHP
	single: xmlWriter

:PHP:
	See the :ref:`PHP.binding` section.
	
	The *canSAS/xmlWriter* (http://www.cansas.org/xmlWriter/)
	is implemented in PHP (http://www.php.net) and writes a cansas1d:1.1 data 
	file given three-column ASCII data as input.  The code uses
	*DomDocument* (http://www.php.net/DomDocument)
	to build the XML file.  Look for the line beginning with::
	
		function prepare_cansasxml($post)
	
	Another example of *DomDocument*
	is in the ``function surveillance($post)`` where
	logging information is inserted into an XML file.
	
	PHP source: http://www.cansas.org/trac/browser/1dwg/trunk/php/xmlWriter/index.php

.. index::
	single: binding; Python
	see: Python; binding, Python
	single: xmlWriter

:Python:
	See the :ref:`Python.binding` section.

.. index::
	single: binding; XML Stylesheet (XSLT)

:XSLT:
	*XSLT*  (useful in a web browser) is described later in the
	:ref:`Example.XML.Stylesheets` section.


Software repositories (for cansas1d:1.1 standard)
=========================================================

:TRAC:
	(bug reporting)
	http://www.cansas.org/trac/browser/1dwg/tags/v1.1

:SVN:
	(*subversion* revision control system)
	http://www.cansas.org/svn/1dwg/tags/v1.1
