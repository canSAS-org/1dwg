.. $Id$

.. index:: ! case study; AF1410 steel SANS

.. _case_study-af1410:

================================
Case Study: AF1410 Steel
================================

.. note:: This case study has not yet been written up. 

data file: *cs_af1410.xml*
	http://svn.smallangles.net/svn/canSAS/1dwg/trunk/examples/af1410/cs_af1410.xml

The data file contains multiple :ref:`SASentry` elements that pertain to different samples
treated at different conditions in a time series.  Each *SASentry* element contains two
:ref:`SASdata` sections that correspond to sector averages from the two-dimensional SANS
data.  Since the samples had been subjected to a 1.6T magnetic field to clear
the scattering from magnetic domain boundaries in one direction, the sector average
for that direction has scattering dominated by purely nuclear scattering moments.  The
other *SASdata* section has scattering due to both nuclear and magnetic scattering moments.

Also see the publication: 
	A.J. Allen, D. Gavillet, J.R. Weertman, 
	"Small-Angle Neutron Scattering Studies of
	Carbide Precipitation in Ultrahigh-Strength Steels,"
	*Acta Metall* **41** (1993) 1869-1884.
