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
(http://www.smallangles.net/canSAS)
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

.. index:: ! cansas1d/1.1 standard
.. index:: canSAS; objective

The cansas1d/1.1
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

The basic elements of the cansas1d/1.1 standard are shown in the following table.
After an XML header, the root element of the file is :ref:`SASroot`
which contains one or more :ref:`SASentry`
elements, each of which
describes a single experiment (data set, time-slice, step in a series, new sample,
etc.). Details of the *SASentry* element are also shown in the
next figure. 
See the section :ref:`elements`
for examples of cansas1d/1.1 XML data files. 
Examples, Case Studies, and other background information
are below. More discussion can be found on the
canSAS 1D Data Formats Working Group page 
(http://www.smallangles.net/wgwiki/index.php/1D_Data_Formats_Working_Group) 
and its discussion page.  
(http://www.smallangles.net/wgwiki/index.php/Talk:1D_Data_Formats_Working_Group)

	.. figure:: ../../graphics/10-minimum.png
	    :alt: cansas1d/1.1 standard block diagram, minimum elements
	    
	    block diagram of minimum elements required for *cansas1d/1.1* standard

:ref:`SASroot`
	the root element of the file (after the XML header) 

:ref:`SASentry`
	describes a single experiment (data set, time-slice, step in a series, new sample, etc.) 

.. index:: ! XML header

.. _XML.header:

.. rubric:: Required header for cansas1d/1.1 XML files

.. code-block:: xml
	:linenos:
	
	<?xml version="1.0"?>
	<SASroot version="1.1"
		xmlns="cansas1d/1.1"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="cansas1d/1.1 http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd"
		>

.. index: element; SASroot
.. index: element; SASentry
.. index: element; SASdata
.. index: element; Idata
.. index: element; SAStransmission_spectrum
.. index: element; Tdata
.. index: element; {any}
.. index: element; SASsample
.. index: element; SASinstrument
.. index: element; SASsource
.. index: element; SAScollimation
.. index: element; SASdetector 
.. index: element; SASprocess
.. index: element; SASnote

.. rubric:: Basic elements of the canSAS 1-D standard

===============================   ===========================================================================
Element                           Description
===============================   ===========================================================================
:ref:`XML Header<XML.header>`     descriptive info required at the start of every XML file
:ref:`SASroot`                    root element of XML file
:ref:`SASentry`                   data set, time-slice, step in a series, new sample, etc.
:index:`Title`                    for this particular :ref:`SASentry`
:index:`Run`                      run number or ID number of experiment
:ref:`{any}`                      any XML element can be used at this point
:ref:`SASdata`                    this is where the reduced 1-D SAS data is stored
:ref:`Idata`                      a single data point of :math:`I(Q)` (and related items) in the dataset
:ref:`SAStransmission_spectrum`   any transmission spectra may be stored here
:ref:`Tdata`                      a single data point in the transmission spectrum
:ref:`{any}`                      any XML element can be used at this point
:ref:`SASsample`                  description of the sample
:ref:`SASinstrument`              description of the instrument
:ref:`SASsource`                  description of the source
:ref:`SAScollimation`             description of the collimation
:ref:`SASdetector`                description of the detector
:ref:`SASprocess`                 description of each processing or analysis step
:ref:`SASnote`                    anything at all
===============================   ===========================================================================


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

#. A cansas1d/1.1 XML data files will adhere to the standard if it can
	successfully :ref:`validate` against the established XML Schema. 
	(http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d.xsd)
#. :math:`Q=(4 \pi / \lambda) \sin(\theta)`
	where :math:`\lambda` is the wavelength of the radiation,
	and :math:`2\theta` is the angle through which the detected radiation has been scattered.
	
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
	C              celsius
	A              Angstroms
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
	(See the :ref:`compatibility` section)
	
	a. :math:`z` is along the flight path (positive value in the direction of the detector)
	#. :math:`x` is orthogonal to :math:`z` in the horizontal plane (positive values
		increase to the right when viewed towards the incoming
		radiation)
	#. :math:`y` is orthogonal to :math:`z` and :math:`x` in the vertical plane 
		(positive values increase upwards)
	
	.. figure:: ../../graphics/translation-orientation-geometry.jpg
	    :alt: coordinate axes as viewed from the source
	    :height: 200 px
	    
	    definition of translation and orientation geometry as viewed from the source towards the detector
	
	.. figure:: ../../graphics/translation-orientation-geometry-2.jpg
	    :alt: coordinate axes as viewed from the detector
	    :width: 200 px
	    
	    definition of translation and orientation geometry as viewed from the detector towards the source

#. orientation (angles) describes single-axis rotations (rotations about
	multiple axes require more information):
	
	a. :index:`roll` is about :math:`z`
	#. :index:`pitch` is about  :math:`x`
	#. :index:`yaw` is about  :math:`y`

#. Binary data is not supported


Converting data into the XML format
=====================================

.. index:: ! xmlWriter

The canSAS/xmlWriter (http://www.smallangles.net/canSAS/xmlWriter/)
is a WWW form
to translate three-column ASCII text data into the cansas1d/1.1 XML
format. This form will help you in creating an XML file with all the required
elements in the correct places. The form requests the SAS data of *Q*, *I*, and *Idev*
(defined elsewhere on this page) and some basic :index:`metadata`
(title, run, sample info, ...).

Press the *Submit* button and you will receive a nicely
formatted WWW page with the SAS data. If you then choose *View page source*
(from one of your browser menus), you will see the raw XML of the cansas1d/1.1 XML format
and you can copy/paste this into an XML file. 

The SAS data that you paste into the form box is likely to be copied directly from
a 3-column ASCII file from a text editor. Line breaks are OK, they will be treated
as white-space as will tabs and commas. Do not be concerned that the data looks
awful in the form entry box, just check the result to see that it comes out
OK.


Documentation and Definitions
========================================

XML Schema
-------------

The *cansas1d.xsd* :index:`XML Schema` (http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d.xsd)
defines the rules for the XML file format and is used to
validate any XML file for adherence to the format.

	TRAC (view source code highlighted by bug tracking system)
		http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d.xsd

	SVN (view raw source code from version control system)
		http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd

XML stylesheets
----------------

An :index:`XML stylesheet`, or *XSLT* (http://www.w3schools.com/xsl/),
can be used to extract :index:`metadata` 
or to convert into another file format. The
default canSAS stylesheet *cansasxml-html.xsl*
(http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansasxml-html.xsl)
should be copied into each folder with canSAS XML data
file(s). It can be used to display the data in a supporting WWW browser
(such as Firefox or Internet Explorer) or to import into Microsoft Excel
(with the added XML support in Excel). 

.. tip:: See the excellent write-up by Steve King, ISIS, 
	(http://www.isis.rl.ac.uk/archive/LargeScale/LOQ/xml/cansas_xml_format.pdf)
	for an example.

By default, MS Windows binds *.xml* files to start
Internet Explorer. Double-clicking on a canSAS XML data file with the
*cansasxml-html.xsl* (see above tip)
stylesheet in the same directory will produce a
WWW page with the SAS data and selected metadata.


Suggestions for support software that write cansas1d/1.1 XML data files
-------------------------------------------------------------------------

.. index::
	single: file; Writing cansas1d/1.1 files
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
----------------------------------

.. index:: XML file; cansas1d.xml

**Basic example** 
	http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d.xml
	
    Note that, for clarity, only one row of data is
    shown. This is probably a very good example to use as a starting point for
    creating XML files with a text editor.

.. index:: XML file; bimodal-test1.xml
.. index:: case study; bimodal test data

**Bimodal test data**
	http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/bimodal-test1.xml

    Simulated SAS data (with added noise) calculated from model bimodal size 
    distribution to test size distribution analysis routines.


.. index:: case study; glassy carbon round robin

**Glassy Carbon Round Robin**
	http://www.smallangles.net/wgwiki/index.php/Glassy_Carbon_Round_Robin

    Samples of a commercial glassy carbon
    measured at several facilities worldwide.


..
	    <section xml:id="cansas1d_documentation-Documentation-Definitions">
	        <section xml:id="cansas1d_documentation-examples">
	                <listitem>
	                    <para>SAXS data from 
	                        <link xlink:href="#cansas1d_documentation-case_study-collagen"
	                            >dry chick collagen</link>
	                        <indexterm>
	                            <primary>case study</primary>
	                            <secondary>SAXS of dry chick collagen</secondary>
	                        </indexterm>
	                        illustrates the
	                        minimum information necessary to meet the requirements of the standard
	                        format</para>
	                </listitem>
	                <listitem>
	                    <para>SANS data from 
	                        <link xlink:href="#cansas1d_documentation-case_study-af1410"
	                            >AF1410 steel</link>:<footnote><para>
	                                <link xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/af1410/"
	                                    ><literal>http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/af1410/</literal
	                                    ></link></para></footnote>
	                        <indexterm>
	                            <primary>case study</primary>
	                            <secondary>SANS of AF1410 steel</secondary>
	                        </indexterm>
	                        SANS study using magnetic
	                        contrast variation (with multiple samples and multiple data sets for each
	                        sample), the files can be viewed from the TRAC site (no description yet).</para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <literal>cansas1d-template.xml</literal>:<footnote><para>
	                            <link xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d-template.xml"
	                                ><literal
	                                    >http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d-template.xml</literal
	                                ></link></para></footnote>
	                        <indexterm>
	                            <primary>XML file</primary>
	                            <secondary>cansas1d-template.xml</secondary>
	                        </indexterm>
	                        This is used to test all the rules in the XML
	                        Schema. This is probably not a very good example to use as a starting point
	                        for creating XML files with a text editor since it tests many of the
	                        special-case rules.</para>
	                </listitem>
	            </itemizedlist>
	            <section xml:id="cansas1d_documentation-examples-multiple_experiments">
	                <title>XML layout for multiple experiments</title>
	                <para>Each experiment is described with a single <literal>SASentry</literal> element. The
	                    fragment below shows how multiple experiments
	                    <indexterm>
	                        <primary>multiple experiments</primary>
	                    </indexterm>
	                    <indexterm>
	                        <primary>multiple data sets</primary>
	                    </indexterm>
	                    can be included in a single XML
	                    file. Full examples of canSAS XML files with multiple experiments
	                    include:</para>
	                <itemizedlist>
	                    <listitem>
	                        <para> ISIS LOQ SANS instrument:<footnote><para>
	                            <link xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/W1W2.XML"
	                                ><literal
	                                    >http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/W1W2.XML</literal
	                                ></link></para></footnote>
	                            <indexterm>
	                                <primary>XML file</primary>
	                                <secondary>W1W2.XML</secondary>
	                            </indexterm>
	                            multiple data sets.
	                        </para>
	                    </listitem>
	                    <listitem>
	                        <para> AF1410 steel SANS contrast variation study from NIST:<footnote><para>
	                                <link xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/af1410/cs_af1410.xml"
	                                    ><literal
	                                        >http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/af1410/cs_af1410.xml</literal
	                                    ></link></para></footnote>
	                            <indexterm>
	                                <primary>XML file</primary>
	                                <secondary>cs_af1410.xml</secondary>
	                            </indexterm>
	                            SANS study using magnetic
	                            contrast variation (with multiple samples and multiple data sets for each
	                            sample), the files can be viewed from the TRAC site (no description yet).
	                        </para>
	                    </listitem>
	                </itemizedlist>
	                <para>Here is a brief sketch of how a file would be arranged with multiple SASentry
	                    elements and multiple SASdata elements.
	                    <indexterm>
	                        <primary>XML file</primary>
	                        <secondary>brief-sketch-multiple.xml</secondary>
	                    </indexterm>
	                    <example>
	                        <title>Brief sketch of a file with multiple SASentry and SASdata blocks.</title>
	                        <programlisting language="xml" linenumbering="numbered">
	                            <textobject>
	                                <textdata fileref="brief-sketch-multiple.xml"/>
	                            </textobject>
	                        </programlisting>
	                    </example>
	                </para>
	            </section>
	        </section>



	        <section xml:id="cansas1d_documentation-Foreign_Elements">
	            <title>Foreign Elements</title>
	            <para> To allow for inclusion of elements that are not defined by the 
	                <literal>cansas1d.xsd</literal> XML
	                Schema, XML <emphasis role="italic">foreign elements</emphasis> 
	                <indexterm>
	                    <primary>XML</primary>
	                    <secondary>foreign elements</secondary>
	                </indexterm>
	                are permitted at select locations in the
	                cansas1d/1.1 format. Please refer to the section 
	                <link xlink:href="#wiki-XML_Help"><emphasis>XML Help</emphasis></link>
	                 for more help with XML foreign elements. </para>
	            <para> 
	                There is an example that demonstrates the use of a foreign 
	                namespace:<footnote>
	                    <para>
	                        <link
	                            xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/data/Glassy%20Carbon/ISIS/GLASSYC_C4G8G9_withTL.xml"
	                            ><literal
	                                >http://svn.smallangles.net/trac/canSAS/browser/1dwg/data/Glassy%20Carbon/ISIS/GLASSYC_C4G8G9_withTL.xml</literal></link></para>
	                </footnote>
	                This example uses a foreign namespace to record the transmission spectrum related to
	                the acquisition of the SANS data at a time-of-flight facility. Look near line 153
	                for this element: 
	                <informalexample>
	                    <programlisting>&lt;transmission_spectrum xmlns="urn:transmission:spectrum"></programlisting>
	                </informalexample>
	                The foreign namespace given
	                (<literal>urn:transmission:spectrum</literal>) becomes the default namespace for just the
	                <literal>transmission_spectrum</literal> element. </para>
	            <para>Also refer to <link
	                xlink:href="http://svn.smallangles.net/trac/canSAS/changeset/47">canSAS TRAC
	                ticket #47</link> for an example of arranging the content in 
	                <literal>SASprocessnote</literal> to avoid the use of foreign namespace
	                elements. </para>
	        </section>
	        <section xml:id="cansas1d_documentation-Support_Tools">
	            <title>Support tools for Visualization &amp; Analysis software</title>
	            <para> Support for importing cansas1d/1.1 files exists for these 
	                languages and environments: 
	            </para>
	            <itemizedlist>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">FORTRAN</emphasis>:
	                        See the section titled
	                        <link xlink:href="#cansas1d_documentation-binding-Fortran"
	                            ><emphasis role="italic">Fortran binding</emphasis></link>.
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>FORTRAN</secondary>
	                        </indexterm>
	                        <indexterm>
	                            <primary>FORTRAN</primary>
	                            <see>binding, FORTRAN</see>
	                        </indexterm>
	                    </para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">IgorPro</emphasis>:
	                        See the section titled
	                        <link xlink:href="#cansas1d_documentation-binding-IgorPro"
	                            ><emphasis role="italic">IgorPro binding</emphasis></link>.
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>IgorPro</secondary>
	                        </indexterm>
	                        <indexterm>
	                            <primary>IgorPro</primary>
	                            <see>binding, IgorPro</see>
	                        </indexterm>
	                    </para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">Java</emphasis>:
	                        See the section titled
	                        <link xlink:href="#cansas1d_documentation-binding-Java"
	                            ><emphasis role="italic">Java JAXB binding</emphasis></link>.
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>Java</secondary>
	                        </indexterm>
	                        <indexterm>
	                            <primary>Java</primary>
	                            <see>binding, Java</see>
	                        </indexterm>
	                    </para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">Microsoft Excel</emphasis>:
	                        Support for Microsoft Excel
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>Microsoft Excel</secondary>
	                        </indexterm>
	                        <indexterm>
	                            <primary>Microsoft Excel</primary>
	                            <see>binding, Microsoft Excel</see>
	                        </indexterm>
	                        is provided through the default canSAS stylesheet <link
	                            xlink:href="http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansasxml-html.xsl"
	                            >cansasxml-html.xsl</link>. 
	                        The <link
	                            xlink:href="http://www.isis.stfc.ac.uk/instruments/loq/loq2470.html"
	                            >ISIS LOQ instrument</link> has provided an <link
	                                xlink:href="http://www.isis.rl.ac.uk/archive/LargeScale/LOQ/xml/cansas_xml_format.pdf"
	                                >excellent description</link><footnote><para><link
	                            xlink:href="http://www.isis.stfc.ac.uk/instruments/loq/loq2470.html"
	                            ><literal>http://www.isis.stfc.ac.uk/instruments/loq/loq2470.html</literal
	                            ></link></para></footnote>
	                        of how to import data from the
	                        cansas1d/1.1 format into Excel.
	                        Also note that the
	                            <link
	                            xlink:href="http://www.isis.rl.ac.uk/archive/LargeScale/LOQ/loq.htm">old
	                            WWW site</link><footnote><para><link
	                            xlink:href="http://www.isis.rl.ac.uk/LargeScale/LOQ/loq.htm"
	                            ><literal>http://www.isis.rl.ac.uk/LargeScale/LOQ/loq.htm</literal
	                            ></link></para></footnote>
	                        may still be available. 
	                    </para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">PHP</emphasis>:
	                        The <link xlink:href="#cansas1d_documentation-converting_into_XML"
	                            ><emphasis role="italic">canSAS/xmlWriter</emphasis></link>
	                        <indexterm><primary><literal>xmlWriter</literal></primary></indexterm>
	                        is implemented in <link xlink:href="http://www.php.net">PHP</link
	                        ><footnote><para><link xlink:href="http://www.php.net"
	                            ><literal>http://www.php.net</literal></link></para></footnote>
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>PHP</secondary>
	                        </indexterm>
	                        <indexterm>
	                            <primary>PHP</primary>
	                            <see>binding, PHP</see>
	                        </indexterm>
	                        and writes a cansas1d/1.1 data file given three-column ASCII data as input.
	                        (<link
	                            xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/php/xmlWriter/index.php"
	                            >PHP source</link>)<footnote>
	                            <para>
	                                <link xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/php/xmlWriter/index.php"
	                                    ><literal>http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/php/xmlWriter/index.php</literal></link>
	                            </para>
	                        </footnote>
	                        The code uses <link xlink:href="http://www.php.net/DomDocument">DomDocument</link
	                        ><footnote><para><link xlink:href="http://www.php.net/DomDocument"
	                            ><literal>http://www.php.net/DomDocument</literal></link></para></footnote>
	                        to build the XML file.  Look for the line beginning with
	                        <literal>function prepare_cansasxml($post)</literal>.
	                    </para>
	                    <para>
	                        Another example of <literal>DomDocument</literal>
	                        is in the <literal>function surveillance($post)</literal> where
	                        logging information is inserted into an XML file.
	                    </para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">Python</emphasis>:
	                        See the section titled
	                        <link xlink:href="#cansas1d_documentation-binding-Python"
	                            ><emphasis role="italic">Python binding</emphasis></link>.
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>Python</secondary>
	                        </indexterm>
	                        <indexterm>
	                            <primary>Python</primary>
	                            <see>binding, Python</see>
	                        </indexterm>
	                    </para>
	                </listitem>
	                <listitem>
	                    <para>
	                        <emphasis role="bold">XSLT</emphasis> (useful in a web browser)
	                        is described later in the section titled 
	                        <link xlink:href="#xml-stylesheet"><emphasis role="italic">Example XML Stylesheets</emphasis></link>.
	                        <indexterm>
	                            <primary>binding</primary>
	                            <secondary>XML Stylesheet (XSLT)</secondary>
	                        </indexterm>
	                    </para>
	                </listitem>
	            </itemizedlist>
	        </section>
	        <section xml:id="cansas1d_documentation-repositories">
	            <title>Software repositories (for cansas1d/1.1 standard)</title>
	            <itemizedlist>
	                <listitem>
	                    <para><emphasis role="bold">TRAC</emphasis>: <link
	                            xlink:href="http://svn.smallangles.net/trac/canSAS/browser/1dwg/tags/v1.0"
	                            ><literal>http://svn.smallangles.net/trac/canSAS/browser/1dwg/tags/v1.0</literal></link></para>
	                </listitem>
	                <listitem>
	                    <para><emphasis role="bold">Subversion</emphasis>: <link
	                            xlink:href="http://svn.smallangles.net/svn/canSAS/1dwg/tags/v1.0"
	                            ><literal>http://svn.smallangles.net/svn/canSAS/1dwg/tags/v1.0</literal></link></para>
	                </listitem>
	            </itemizedlist>
	        </section>
	    </section>
	    <section xml:id="cansas1d_documentation-schema_validation">
	        <title>Validation of XML against the Schema</title>
	        <indexterm>
	            <primary>validation</primary>
	            <secondary>against XML Schema</secondary>
	        </indexterm>
	        <orderedlist>
	            <listitem>
	                <para>open browser to: 
	                    <link xlink:href="http://www.xmlvalidation.com/"
	                        ><literal>http://www.xmlvalidation.com/</literal></link></para>
	            </listitem>
	            <listitem>
	                <para>paste content of candidate XML file (with reference in the header to the XML
	                    Schema as shown above) into the form</para>
	            </listitem>
	            <listitem>
	                <para>press <literal>&lt;validate></literal></para>
	            </listitem>
	            <listitem>
	                <para>paste content of 
	                    <literal>cansas1d.xsd</literal><footnote><para><link
	                        xlink:href="http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd"
	                        ><literal>http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd</literal
	                    ></link></para></footnote>
	                    XSD file into form and press <literal>&lt;continue validation></literal>.</para>
	            </listitem>
	            <listitem>
	                <para>check the results</para>
	            </listitem>
	        </orderedlist>
	    </section>
