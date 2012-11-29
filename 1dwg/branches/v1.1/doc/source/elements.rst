.. $Id: elements.rst 241 2012-08-27 07:15:24Z prjemian $

.. _elements:

===================================================
Elements of the canSAS XML standard
===================================================

There are various elements (tag names) in the cansas1d/1.1 standard.
Each of these is described below.

:Name:
	XML tag to be used for this element of the standard.


:Type:
	A *Type* may be either of:
	
	:header:
		Describes the required XML header lines.  
                Without questions, use the header
                in the section titled :ref:`XML header`.

	:container:
		A *container* element has subelements but 
		no text of its own.
		These are similar to the NeXus NXDL 
		``group`` type.

	:floating-point number:
		Elements of type *floating-point number*
                are obvious.  In most cases, a ``unit`` attribute
                is required.  This will be noted.

	:string:
		Elements of type *string*
		are any valid string (non-whitespace) sequence.

:Occurence:
	The number of times a particular element may appear is 
	described in the *occurence* column. A value of *[0..1]* 
	indicates the element is optional but may appear one time. A value of
        *[0..inf]* indicates the element is optional 
	but may appear an infinite number of times (also known as unbounded).

.. index:: ! XML; attributes
.. index:: XML; well-formed

:Attributes:
	
	*Attributes* list the required or optional attributes of this element.  
	Note that attributes must adhere to the well-formed [#]_
	XML guidelines::
	
        	attributename="value"
        
	where either single or double quotes surround the value.  
        All attributes must have a value.  Attributes may be given in any order.
	
	.. [#] well-formed XML: http://www.w3schools.com/xmL/xml_syntax.asp




.. toctree::
   :maxdepth: 2
   
   element_XML_header
   element_SASroot
   element_SASentry
   element_SASdata
   element_SAStransmission_spectrum
   element_SASsample
   element_SASinstrument
   element_SASsource
   element_SAScollimation
   element_SASdetector
   element_SASprocess
   element_SASnote
   element_any
