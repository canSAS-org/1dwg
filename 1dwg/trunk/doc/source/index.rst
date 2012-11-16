.. $Id: index.rst 241 2012-08-27 07:15:24Z prjemian $

====================
canSAS1d data format
====================

.. figure:: ../../graphics/cswikilogo.png

The canSAS1d data format is used to communicate one-dimensional 
reduced small-angle scattering data.  It is a text format and 
is based on XML.

.. rubric:: Objective

One of the first aims of the **canSAS** (Collective Action for 
Nomadic Small-Angle Scatterers) forum of users, software 
developers, and facility staff was to discuss better sharing of SAS 
data analysis software. The canSAS (http://www.cansas.org/) identified that a 
significant need within the SAS community can be satisfied by a 
robust, self-describing, text-based, standard format to communicate 
reduced one-dimensional small-angle scattering data, :math:`I(Q)`, 
between users of our facilities. Our goal has been to define such a 
format that leaves the data file instantly human-readable, editable 
in the simplest of editors, and importable by simple text import 
filters in programs that need not recognize advanced structure in 
the file nor require advanced programming interfaces. The file 
should contain both the primary data of :math:`I(Q)` and also any 
other descriptive information (metadata) about the sample, 
measurement, instrument, processing, or analysis steps.

The cansas1d/1.1 standard meets the objectives for a 1D standard, 
incorporating metadata about the measurement, parameters and 
results of processing or analysis steps. Even multiple measurements 
(related or unrelated) may be included within a single XML file.


.. rubric::  Brief Contents


.. toctree::
   :hidden:
   
   contents


* :ref:`Preface`
* :ref:`Specification`
* :ref:`Examples`
* :ref:`case.studies`
* :ref:`Tutorial`
* :ref:`bindings`
* :ref:`downloads`
* :ref:`changes`
