.. $Id: validation.rst 241 2012-08-27 07:15:24Z prjemian $

.. index::
	single: intensity; problem
	single: intensity; absolute
	see: absolute intensity; intensity, absolute


.. _intensity-problem:

===================================================
The Intensity Problem
===================================================

The intensity (see :ref:`SASdata`) is permitted in three different forms:

#. **absolute units**: :math:`d\Sigma/d\Omega(Q)`
	differential cross-section
	per unit volume per unit solid angle (typical unit: 1/cm)

#. **absolute units**: :math:`d\sigma/d\Omega(Q)`
	differential cross-section
	per unit atom per unit solid angle (typical unit: cm^2)

#. **arbitrary units**: :math:`I(Q)`
	usually a ratio of two
	detectors but unit is meaningless (typical unit: a.u.)

This presents a few problems 
for analysis software to sort out when reading the data.
Fortunately, it is possible to analyze the unit attribute to decide which type of
intensity is being reported and make choices at the time the file is read. But this is
an area for consideration and possible improvement.

One problem arises with software that automatically converts data into some canonical
units used by that software. The software should not convert units between these three
types of intensity indiscriminately.

.. index:: I(Q)

A second problem is that when arbitrary units are used, then the set of possible
analytical results is restricted.  With such units, no meaningful volume fraction 
or number density can be determined directly from :math:`I(Q)`.
