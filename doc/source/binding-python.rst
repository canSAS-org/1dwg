.. $Id$

.. index:: ! binding; Python

.. _Python.binding:

================
Python 
================

The Python binding to read canSAS 1-D data files
has been implemented using the :ref:`gnosis`.
It is very easy to use, once you have the `gnosis utils` installed.
XML files are read by the :meth:`readCanSasFile` routine
from the `cansas1d` support file. 

=======  ====================
version  namespace
=======  ====================
1.0      `cansas1d/1.0`
1.1      `urn:cansas1d:1.1`
=======  ====================

If either namespace or version don't match, an exception is raised.

If the version and namespace match this table, the data from the file is mapped
into Python objects, as shown by the examples below.  Otherwise, an
appropriate exception is raised.


Interactive example using `cansas1d`
=============================================

Here is an interactive example showing how to read a canSAS 1D 
data file using the canSAS 1D Python binding:

>>> from cansas1d import readCanSasFile
>>> sasxml = readCanSasFile('bimodal-test1.xml')
>>> print sasxml.SASentry.Title
<Title id="34b0470" >
>>> print sasxml.SASentry.Title.PCDATA
SAS bimodal test1
>>> print len(sasxml.SASentry.SASdata.Idata)
91
>>> print sasxml.SASentry.SASsample.ID.PCDATA
bimodal-test1
>>> source = sasxml.SASentry.SASinstrument.SASsource
>>> print source.radiation.PCDATA, source.wavelength.PCDATA, source.wavelength.unit
artificial 1.00 A


Interactive Example using `gnosis.xml.objectify`
================================================

Here is an interactive example showing how to read a canSAS 1D 
data file using `gnosis.xml.objectify`:

>>> from gnosis.xml.objectify import XML_Objectify
>>> sasxml = XML_Objectify('bimodal-test1.xml').make_instance()
>>> print sasxml.SASentry.Title.PCDATA
SAS bimodal test1
>>> sasxml.SASentry.Run.PCDATA
1992
>>> sasxml.SASentry.SASinstrument.name.PCDATA
simulated SAS calculation
>>> data0 = sasxml.SASentry.SASdata.Idata[0]
>>> print data0.Q.unit,  data0.I.unit
1/A 1/cm
>>> print data0.Q.PCDATA,  data0.I.PCDATA,  data0.Idev.PCDATA
0.0040157139 3497.473 90.72816


example: how to retrieve :math:`I(Q)`
================================================

briefly (ignoring any exception handling):

>>> from cansas1d import readCanSasFile
>>> sasxml = readCanSasFile('bimodal-test1.xml')
>>> Q = [float(i.Q.PCDATA) for i in sasxml.SASentry.SASdata.Idata]
>>> I = [float(i.I.PCDATA) for i in sasxml.SASentry.SASdata.Idata]


.. _cansas1d.py:

`cansas1d.py` source code documentation
===========================================

Here is the source code and documentation of the
`cansas1d.py` Python binding.
This file (and an example that calls this file and prints 
more data from the file) may be found in the canSAS 
:ref:`subversion <repository>` repository.

.. automodule:: cansas1d
    :members:
    :undoc-members:
    :show-inheritance:


.. _gnosis:

gnosis utils
=================

The Python binding to read canSAS 1-D data files
has been implemented using the gnosis utilities. [#]_
Specifically, the `gnosis.xml.objectify` package turns 
arbitrary XML documents into Python objects.
Since `gnosis.xml.objectify` is not aware of the XML Schema,
it is necessary to check that the file read is a canSAS 1D file.
Matching of the namespace and version should be sufficient
to accept a canSAS 1D file.  Appropriate exceptions
are raised if the file does not pass these tests.

.. [#] gnosis utilities: http://freecode.com/projects/gnosisxml/

You can install the gnosis utilities if you have the `distutils` package using::

    easy_install -U gnosis
   