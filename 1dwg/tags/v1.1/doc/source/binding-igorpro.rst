.. $Id$

.. index:: ! binding; IgorPro

.. _igorpro.binding:

================
IgorPro
================

An import tool (binding) for IgorPro has been created (*cansasXML.ipf*). You can check out
the IgorPro working directory from the SVN server (see instructions below).

To use the *canSASxml.ipf* procedure, 
you must have the XMLutils XOP IGOR plugin installed.
See the :ref:`IgorPro Binding Usage Notes` section below.

.. note::
	Note that this tool is not a true binding [#]_
	in that the structure of the 
	XML file is not replicated in IgorPro data structures. 
	This tool reads the vectors of 1-D SAS data (*Q*, *I*, ...) 
	into IgorPro waves (*Qsas*, *Isas*, ...). The tool also reads 
	most of the metadata into an IgorPro textWave for use by other 
	support in IgorPro.
	
	.. [#] For example, see *data binding* from 
		http://en.wikipedia.org/wiki/Binding_%28computer_science%29

.. note::
	Note that the code described here is *not a complete user interface*.
	(See further comments below.) It is expected that this code will be called by a graphical
	user interface routine and that routine will handle the work of copying the loaded SAS data
	in IgorPro from the *root:Packages:CS_XMLreader* data folder to the destination of choice
	(including any renaming of waves as desired). 


:file:
	http://www.cansas.org/trac/browser/1dwg/trunk/IgorPro/cansasXML.ipf

:author:
	Pete R. Jemian <jemian@anl.gov>

:date:
	2013-03-29

:version:
	1.12 (**requires** latest XMLutils XOP -- see below)

:purpose:
	Implement an IgorPro file reader to read the canSAS 1-D reduced SAS
	data in XML files that adhere to the cansas1d:1.1 standard.

:URL:
	:TRAC:
		http://www.cansas.org/trac/browser/1dwg/trunk/IgorPro/cansasXML.ipf
	:SVN:
		http://www.cansas.org/svn/1dwg/trunk/IgorPro/cansasXML.ipf

.. index:: ! IgorPro package; XMLutils XOP

:requires:
	* IgorPro: http://www.wavemetrics.com 
	* *XMLutils* XOP: http://www.igorexchange.com/project/XMLutils
	* minimum requirement: IGOR.5.04.x-1.x-dev (circa 2008-Aug-22)
	                

Checkout of support code in Subversion
=======================================

Subversion (http://subversion.tigris.org/) is a program for 
managing software
versions. There are command line and GUI clients for a 
variety of operating systems. We
won't recommend any here but will show the command lines necessary.

.. index:: 
	single: XMLutils XOP
	single: IgorExchange

.. _XMLutils XOP:

*XMLutils* XOP
------------------

The *XMLutils* XOP, written by Andrew Nelson (ANSTO), 
is hosted on the IgorExchange (http://www.igorexchange.com/).

One good location to place the checked out *XMLutils* directory is in the
*Wavemetrics* directory, next to the *Igor Pro Folder*.

Here is the subversion checkout command:

	.. code-block:: guess
	
		svn co svn://svn.igorexchange.com/packages/XMLutils/ XMLutils

To retrieve an updated version of this support in the future, go into the
*XMLutils* directory (created above) and type either of these commands:

	.. code-block:: text
	
		svn update
		svn up

This will check the repository and update local files as needed.
If the installer program was updated, you'll need to run the
new installer program. It is not necessary to uninstall first.

The installer executables contained in the download will do all the installation
for you. They will place the XOP in the folder */User Procedures/motofit/XMLutils*, 
and create a shortcut/alias to the plugin in *./Igor Extensions*. 
Packages from other facilities should place the XOP there as well. 


.. index:: ! cansasXML.ipf

*cansasXML.ipf*
--------------------

Check out the canSAS 1d SAS XML reader from the subversion repository:

	.. code-block:: text
	
		svn checkout http://www.cansas.org/svn/1dwg/trunk cansas-1dwg

This will download lots of extra files. The file of interest is in the
IgorPro directory and is called *cansasXML.ipf*

To retrieve an updated version of this support in the future,
go into the *cansas-1dwg* directory (created above) and type the command::

	svn update

This will check the repository and update files as needed.


Installation
=================

#. License and Install the *IgorPro* application 
	(should have already done this step by now)
#. Quit *IgorPro* if it is running
#. Download *XMLutils* XOP. Either checkout from subversion (see above) or, with a
	web browser, visit http://svn.igorexchange.com/viewvc/packages/XMLutils/trunk/
#. Install *XMLutils* XOP by double-clicking the installer for your operating system.
#. Download *cansasXML.ipf*. Either checkout from subversion (see above) or, with
	a web browser, copy *cansasXML.ipf* from the on-line subversion repository.
	(http://www.cansas.org/svn/1dwg/trunk/IgorPro/cansasXML.ipf)
#. Copy *cansasXML.ipf* file to *...WavemetricsIgor Pro FolderUser Procedures*
	(or file system equivalent)
#. Then, you should be able to restart *IgorPro* and progress from there.


.. _IgorPro Binding Usage Notes:

Usage Notes
===============

To use the *canSASxml.ipf* procedure, you must have the *XMLutils* XOP IgorPro plugin
installed. This may be downloaded from the IgorExchange Project site. There are
installer executables contained in the download that will do all the installation for
you. Each installer will place the XOP in the folder 
*...Wavemetrics:Igor Pro Folder:User Procedures:motofit:XMLutils*, 
and create a shortcut/alias to the plugin in
*...Wavemetrics:Igor Pro Folder:Igor Extensions*.



.. index:: IgorPro function; CS_XmlReader()

What it does
============

Given an XML file, **CS_XmlReader(fileName)** attempts
to open the file and read its contents as if it conformed to the canSAS XML standard
for reduced 1-D SAS data (cansas1d:1.1, also known as SASXML). If the file is found to be
non-conforming, then *CS_XmlReader(fileName)* returns
with an error code (show below), otherwise it returns *0*, indicating *no error*.
All data read by this code is left in the
IgorPro data folder *root:Packages:CS_XMLreader* for pickup by the calling routine.
(Two examples are provided to show how a routine might retrieve the data.)
 
.. index:: I(Q)

After opening the XML file (with a file identifier *fileID*),
control is passed to *CS_1i_parseXml(fileID)* which then
walks through the XML elements. For each *SASentry* in the
file, a new data folder is created with the name derived from the *Title* element (or best
effort determination).  Efforts are taken to avoid duplication of data folder names (using
standard IgorPro routines). For *SASentry* elements that
contain more than one *SASdata* element, a *SASdata* folder
is created for each.  The corresponding  :math:`I(Q)` is placed in that 
subfolder.  When only one *SASdata* is found, the
:math:`I(Q)` data is placed in the main *Title* folder.

**data columns**
	Each column of data in the *SASdata/Idata/** table
	is placed into a single IgorPro wave. At present, the code does not check for
	non-standard data columns.(The capability is built into the code but is deactivated
	at present).

**metadata**
	Additional :index:`metadata` is collected into a single text wave
	(*metadata*) where the first column is an identifier (or
	*key*) and the second identifier is the *value*. Only those keys with non-empty values 
	are retained in the metadata table.
	
	.. caution:: The *values* are not checked for 
	    characters that may cause trouble when placed in a wave note. This will be the 
	    responsibility of the calling routine to *clean these up* if the need arises.
	
	The code checks for most metadata elements and will check for 
	repeated elements where the standard permits.
	
	Here is an example of the metadata for the :ref:`case_study-collagen`.
	
	.. rubric:: metadata for the *cs_collagen_full.xml* case study
	
	=======   ===============================================   =====================================================================
	row `i`   key: `metadata[i][0]`                             value: `metadata[i][1]`
	=======   ===============================================   =====================================================================
	0         xmlFile                                           *cs_collagen_full.xml*
	1         namespace                                         ``cansas1d:1.1``
	2         *Title*                                           ``dry chick collagen, d = 673 A, 6531 eV, X6B``
	3         *Run*                                             ``Sep 19 1994 01:41:02 am``
	4         *SASsample/ID*                                    ``dry chick collagen, d = 673 A, 6531 eV, X6B``
	5         *SASinstrument/name*                              ``X6B, NSLS, BNL``
	6         *SASinstrument/SASsource/radiation*               ``X-ray synchrotron``
	7         *SASinstrument/SASsource/wavelength*              ``1.898``
	8         *SASinstrument/SASsource/wavelength/@unit*        ``A``
	9         *SASinstrument/SASdetector/@name*                 ``X6B PSD``
	10        *SASnote*                                         ::
	                                                            
		                                                            Sep 19 1994     01:41:02 am     Elt: 00090 Seconds 
		                                                            ID: No spectrum identifier defined
		                                                            Memory Size: 8192 Chls  Conversion Gain: 1024  Adc Offset: 0000 Chls
		                                                            
		                                                            dry chick collagen, d = 673 A
		                                                            6531 eV, X6B
	=======   ===============================================   =====================================================================


.. index:: XML; foreign elements

**XML foreign namespace elements**
	These are ignored at this time.

**XML namespace and header**
	The routine does a *best-efforts* check to ensure that the
	given XML file conforms to the required :ref:`XML file header <XML.header>`.
	If you take a minimalist view (*a.k.a.* a shortcut), it is likely that your file may be
	refused by this and other readers. Pay particular attention to UPPER and lower case in
	the text **cansas1d:1.1** as this is a **key component** used to index through the XML file.

**XML stylesheet processing-instruction is not generated**
	The :ref:`XMLutils XOP` package does not provide a method to insert the prescribed 
	:index:`XML stylesheet` processing-instruction into the XML data file.
	
		.. code-block:: xml
		
			<?xml-stylesheet type=text/xsl href=example.xsl ?>

	If this processing-instruction is desired, it must be added to each XML data file by
	other methods such as use of a text editor or application of an XSLT transformation.


Important Functions
====================

.. index:: 
	single: IgorPro function; CS_XmlReader()
	single: IgorPro function; prj_grabMyXmlData()
	single: IgorPro function; prjTest_cansas1d()

These are the important FUNCTIONS in the *cansasXML.ipf* code.  

	*CS_XmlReader(fileName)*
		reads the named XML file and and loads SAS data
	*prj_grabMyXmlData()*
		demonstration function to show a usage example
	*prjTest_cansas1d()*
		demonstration function to show a usage example


.. put the rest of the function descriptions in the source code file, not very useful here


Example test case
=================

Here is an example running the test routine *prjTest_cansas1d()*.

.. code-block:: text
	:linenos:
		
	*prjTest_cansas1d()
	XMLopenfile: File(path) to open doesn't exist, or file can't be opened
	elmo.xml either not found or cannot be opened for reading
	    Completed in 0.00669666 seconds
	XMLopenfile: XML file was not parseable
	cansasXML.ipf: failed to parse XML
	    Completed in 0.0133704 seconds
	root element is not SASroot with valid canSAS namespace
	    Completed in 0.0134224 seconds
	bimodal-test1.xml 		 identified as: cansas1d:1.1 XML file
	    Title: SAS bimodal test1 
	    Completed in 0.068654 seconds
	root element is not SASroot with valid canSAS namespace
	    Completed in 0.0172572 seconds
	root element is not SASroot with valid canSAS namespace
	    Completed in 0.0123102 seconds
	root element is not SASroot with valid canSAS namespace
	    Completed in 0.00930118 seconds
	ISIS_SANS_Example.xml 		 identified as: cansas1d:1.1 XML file
	    Title: standard can 12mm SANS 
	    Completed in 0.0410387 seconds
	W1W2.xml 		 identified as: cansas1d:1.1 XML file
	    Title: standard can 12mm SANS 
	    Title: TK49 standard 12mm SANS 
	    Completed in 0.0669074 seconds
	ill_sasxml_example.xml 		 identified as: cansas1d:1.1 XML file
	    Title: ILL-D22 example: 7D1 2mm 
	    Completed in 0.0332752 seconds
	isis_sasxml_example.xml 		 identified as: cansas1d:1.1 XML file
	    Title: LOQ TK49 Standard 12mm C9 
	    Completed in 0.0388868 seconds
	r586.xml 		 identified as: cansas1d:1.1 XML file
	    Title: ILL-D11 example1: 2A 5mM 0%D2O 
	    Completed in 0.0213737 seconds
	r597.xml 		 identified as: cansas1d:1.1 XML file
	    Title: ILL-D11 example2: 2A 5mM 0%D2O 
	    Completed in 0.0221894 seconds
	xg009036_001.xml 		 identified as: cansas1d:1.1 XML file
	    Title: det corrn 5m 
	    Completed in 0.0286721 seconds
	cs_collagen.xml 		 identified as: cansas1d:1.1 XML file
	    Title: dry chick collagen, d = 673 A, 6531 eV, X6B 
	    Completed in 0.0296247 seconds
	cs_collagen_full.xml 		 identified as: cansas1d:1.1 XML file
	    Title: dry chick collagen, d = 673 A, 6531 eV, X6B 
	    Completed in 0.0751836 seconds
	cs_af1410.xml 		 identified as: cansas1d:1.1 XML file
	    Title: AF1410-10 (AF1410 steel aged 10 h) 
	    Title: AF1410-8h (AF1410 steel aged 8 h) 
	    Title: AF1410-qu (AF1410 steel aged 0.25 h) 
	    Title: AF1410-cc (AF1410 steel aged 100 h) 
	    Title: AF1410-2h (AF1410 steel aged 2 h) 
	    Title: AF1410-50 (AF1410 steel aged 50 h) 
	    Title: AF1410-20 (AF1410 steel aged 20 h) 
	    Title: AF1410-5h (AF1410 steel aged 5 h) 
	    Title: AF1410-1h (AF1410 steel aged 1 h) 
	    Title: AF1410-hf (AF1410 steel aged 0.5 h) 
	    Completed in 0.338425 seconds
	XMLopenfile: File(path) to open doesn't exist, or file can't be opened
	cansas1d-template.xml either not found or cannot be opened for reading
	    Completed in 0.00892823 seconds
	1998spheres.xml 		 identified as: cansas1d:1.1 XML file
	    Title: 255 nm PS spheres 
	    Title: 460 nm PS spheres 
	    Completed in 2.87649 seconds
	XMLopenfile: File(path) to open doesn't exist, or file can't be opened
	does-not-exist-file.xml either not found or cannot be opened for reading
	    Completed in 0.00404549 seconds
	cs_rr_polymers.xml 		 identified as: cansas1d:1.1 XML file
	    Title: Round Robin Polymer A 
	    Title: Round Robin Polymer B 
	    Title: Round Robin Polymer C 
	    Title: Round Robin Polymer D 
	    Completed in 0.0943477 seconds
	s81-polyurea.xml 		 identified as: cansas1d:1.1 XML file
	    Title: S7 Neat Polyurea 
	    Completed in 0.0361616 seconds

IgorPro Graphical User Interface
==================================

At least two groups are working on graphical user 
interfaces that use the canSAS 1-D
SAS XML format binding to IgorPro. The GUIs are intended 
to be used with their suites of
SAS analysis tools (and hide the details of using this 
support code from the user).

.. note:: There is no support yet for writing the data 
	back into the canSAS format.
	Several details need to be described, and these are 
	being collected on the discussion
	page for the XML format


.. index:: ! IgorPro package; Irena tool suite

Irena tool suite
-----------------

Jan Ilavsky's **Irena** tool suite
for IgorPro has a GUI to
load the data found in the XML file. 
Refer to http://usaxs.xor.aps.anl.gov/staff/ilavsky/irena.htm for more details.
