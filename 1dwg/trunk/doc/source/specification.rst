.. $Id$

.. index:: ! cansas1d/1.1 standard

.. _specification:

=================
Specification
=================

The canSAS 1-D standard for reduced 1-D SAS data is implemented using 
XML files. A single file can contain SAS data from a single experiment 
or multiple experiments. All types of relevant data (:math:`I(Q)`, 
metadata) are described for each experiment. More details are provided 
below.

This is the definitive specification of *cansas1d/1.1*,
the canSAS standard format for storing small-angle
scattering data in XML files.
The standard is defined using the rules of XML Schema
(http://www.w3.org/XML/Schema).

.. index:: ! XML; well-formed

.. index::
	single: cansas1d/1.1 standard
	single: validation

Note that the cansas1d/1.1 XML data files must adhere to the 
XML rules which includes being well-formed
(including the use of closing tags).  [#]_
Files that can be validated  against :ref:`cansas1d.xsd`
(http://svn.smallangles.net/trac/canSAS/browser/1dwg/trunk/cansas1d.xsd)
are deemed to be valid cansas1d/1.1 data files.

.. [#] For example, see http://www.w3schools.com/xmL/xml_syntax.asp
        for an explanation of the XML syntax.

In this document, curly braces, *{}*, are used to
indicate text that is supplied by the user.  Such as, an attribute
may be written

    name={text}

and this means that the 
user would replace *{text}* with text that gives,
in this example, a name such as *final detector*.
Thus resulting in::

    name="final detector" 

which is a well-formed XML attribute.

.. index:: element; {any}

Another example is an instance of the :ref:`{any}`
element.  Suppose one had analysis data, then *{any}*
would be replaced 
with *analysis* and the element might look like this::

	<analysis>
	   ... analysis content goes here ...
	</analysis>


.. rubric:: Contents

.. toctree::
   :maxdepth: 2

   overview
   elements
   validation
   compatibility
