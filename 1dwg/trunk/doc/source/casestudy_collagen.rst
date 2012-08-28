.. $Id$

.. index:: ! case study; dry chick collagen SAXS

.. _case_study-collagen:

================================
Case Study: Dry Chick Collagen
================================

To demonstrate how to get SAS data into the XML standard format, consider this set of
SAXS data collected at the National Synchrotron Light Source, Brookhaven National
Laboratory, using a SAXS camera set up temporarily at beam line X6B (operated by the
Materials Science Division, Argonne National Lab).

The sample was **dry chick collagen**. 
(Thanks to Malcolm Capel, NSLS beam line X12C for the sample.)


	.. figure:: ../../graphics/cs-collagen-data-table-Excel.jpg
	    
	    collagen SAXS in Excel table


	.. figure:: ../../graphics/cs-collagen-saxs-chart-excel.jpg
	    
	    collagen SAXS in Excel chart (log-log)

The raw data was collected on a linear position-sensitive detector 
and reduced to columns of :math:`Q`, :math:`I`, and :math:`Idev` 
(estimated standard deviation of :math:`I`).

The only :index:`metadata`
available for this data (without resorting to digging through piles
of old notebooks) was obtained from the headers of two files: 

	*COLLAGEN.ASC*
		http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/collagen/COLLAGEN.ASC

		.. rubric:: The header lines from *collagen.asc*:
		
		.. code-block:: text
			:linenos:
			
			Sep 19 1994     01:41:02 am     Elt: 00090 Seconds 
			ID: No spectrum identifier defined
			Memory Size: 8192 Chls  Conversion Gain: 1024  Adc Offset: 0000 Chls


	*collagen.saxs*
		http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/collagen/collagen.saxs
	
		.. rubric:: The header lines from *collagen.saxs*:
		
		.. code-block:: text
			:linenos:
			
			dry chick collagen, d = 673 A
			6531 eV, X6B

There is enough information to fulfill the minimum 
requirements of the 1D standard file format and
also make an excellent example of a minimal 
canSAS reduced 1-D SAS data file in XML.


Create the XML data file
========================

The procedure to create the XML data file by hand is described next.

Make the basic XML file
------------------------------

It is easiest to copy a template rather than start from an empty file. Copy the
:download:`cansas1d.xml <../../cansas1d.xml>` file 
(http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xml)
into your working directory and rename it to 
*collagen.xml*.


Modify *collagen.xml*
------------------------------

It is easier to see the metadata in the XML file before you enter the SAXS data
into the file. With the brief metadata available, most of the other 
lines in *cansas1d.xml* can be eliminated. This
will result in a file that looks like the next example.

	.. rubric:: *collagen.xml* with metadata but before data lines are added
	
	.. literalinclude:: ../src/example-collagen-predata.xml
	   :language: xml
	   :linenos:


Prepare the SAXS data
------------------------------

Microsoft Excel is used here to convert the table of SAXS data into the required
lines of XML for the standard. Some may prefer to use a cell formula but here, we
develop a bit of Excel Macro code to clarify our procedure.

Using Excel macros to reformat the SAXS data
------------------------------------------------------------

.. index:: binding; Microsoft Excel

Within Excel, with the SAXS data in columns as shown in the Excel table
above, let's define the macros for our use. In Excel, type 
*<alt><F11>* to open the macro editing window.

	.. rubric:: Microsoft Excel macro to format the *Idata* lines
	
	.. literalinclude:: ../src/example-excel-macro.txt
	   :language: text
	   :linenos:

Your window will look similar to this one when you copy/paste the above example code:
(Yes, my spreadsheet is called *MyFirstMacro.xls*)

	.. figure:: ../../graphics/cs-collagen-macro-editing.jpg
		:width: 800 px
		
		case study: Collagen, SAXS data in Excel chart

Now close the macro editing window and return to the SAXS data in the spreadsheet.


construct the *Idata* lines in XML
------------------------------------------------------------

Move to spreadsheet cell *E5* and enter this formula:

	.. code-block:: text
		
		=IDATA_tag(A5,$A$4,B5,$B$4,C5,$C$4)

Copy it down all rows in column **E** through cell *E335*.

Select cells E5:E335 and copy to clipboard, then paste into 
*collagen.xml* document inside the 
*SASdata* element where you see the XML comment.


Final Result
------------

A nicely-formatted display version of the final result 
can be viewed through the TRAC repository:

	http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cs_collagen_full.xml

Validate the file
=====================

So you think you have an XML file? Let's validate it 
using the procedure from the documentation.  
All the instructions are in the :ref:`validate` section. 
No sense in repeating them here.

References
=====================

All files are available at:

	http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/examples/collagen/
