.. $Id$

.. index:: ! element; SASdata

.. _SASdata:

============================
*SASdata*
============================

parent:
	:ref:`SASentry`

.. figure:: ../../graphics/2-SASdata.png
    
    The *SASdata* element

Also, see the :ref:`drawing of the Q geometry <Q geometry>`.

.. index::
	element; Idata

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:ref:`Idata`           container   [1..inf]     Each *Idata* describes a single SAS
                                                data point containing :math:`I(Q)` and 
                                                other terms.
====================== =========== ============ =========================================== ====================================



.. index:: ! element; Idata

.. _Idata:

============================
*Idata*
============================

parent:
	:ref:`SASdata`

.. index::
	element; Q
	element; I
	element; Idev
	element; Qdev
	element; dQw
	element; dQl
	element; Qmean
	element; Shadowfactor
	element; {any}

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*Q*                    float       [1..1]       :math:`Q=(4 \pi / \lambda) \sin(\theta)`    *unit={unit}*   [#units]_
                                                as defined in the :ref:`rules` section.
                                                Either *1/A* or *1/nm* are typical units.
*I*                    float       [1..1]       Intensity of the detected radiation.        *unit={unit}*   [#units]_
                                                as defined in the :ref:`rules` section.
                                                See the section titled
                                                :ref:`intensity-problem` for ways to
                                                describe the SAS intensity.
                                                One possibility might be *1/cm* for 
                                                absolute units when the intensity 
                                                describes a **differential cross-section 
                                                per unit volume per unit solid angle**.
                                                
                                                .. note:: Because there are several
                                                    different ways to describe the SAS 
                                                    intensity,  One should be very 
                                                    careful to inspect the *unit* 
                                                    attribute to determine how to handle 
                                                    subsequent data processing, 
                                                    especially in the area of units 
                                                    conversion.
*Idev*                 float       [0..1]       Estimated uncertainty (usually standard     *unit={unit}*   [#units]_
                                                deviation) of *I*. [#optional]_
                                                It is unexpected for *I* and *Idev*
                                                to have different units.
*Qdev*                 float       [0..1]       Estimated uncertainty (usually standard     *unit={unit}*   [#units]_
                                                deviation) of *Q*. [#optional]_
                                                It is unexpected for *Q* and *Qdev*
                                                to have different units.
                                                
                                                .. note:: If either *dQw* or *dQl* 
                                                    are used, then *Qdev* is not 
                                                    permitted to be used.
*dQw*                  float       [0..1]       :math:`Q` resolution along the axis of      *unit={unit}*   [#units]_
                                                scanning (the high-resolution 
                                                *slit width* direction). Useful for 
                                                defining resolution data from 
                                                slit-smearing instruments such as 
                                                Bonse-Hart geometry.  [#optional]_
                                                It is unexpected for *Q* and *dQw*
                                                to have different units.
                                                
                                                .. note:: If either *dQw* or *dQl* 
                                                    are used, then *Qdev* is not 
                                                    permitted to be used.
*dQl*                  float       [0..1]       :math:`Q` resolution perpendicular to       *unit={unit}*   [#units]_
                                                the axis of scanning (the low-resolution 
                                                *slit length* direction). Useful for 
                                                defining resolution data from 
                                                slit-smearing instruments such as 
                                                Bonse-Hart geometry.  [#optional]_
                                                It is unexpected for *Q* and *dQl*
                                                to have different units.
                                                
                                                .. note:: If either *dQw* or *dQl* 
                                                    are used, then *Qdev* is not 
                                                    permitted to be used.
*Qmean*                float       [0..1]       Mean value of :math:`Q` for this data       *unit={unit}*   [#units]_
                                                point. [#optional]_
                                                Useful when describing data that has 
                                                been binned from higher-resolution 
                                                or from area detectors.
                                                It is unexpected for *Q* and *Qmean*
                                                to have different units.
*Shadowfactor*         float       [0..1]       A numerical factor applied to pixels
                                                affected by the beam stop penumbra.
                                                [#optional]_
                                                
                                                .. note:: The *Shadowfactor*
                                                    is used in data files from NIST/NCNR 
                                                    instruments.  Contact NIST/NCNR 
                                                    for more information.
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d/1.1 standard can be placed at 
                                                this point.
====================== =========== ============ =========================================== ====================================

---------------

.. rubric:: Table Notes

..  [#units] The *unit* attribute is required. 
	See :ref:`rules` for acceptable values.
..  [#optional] When an optional element (such as *Idev*, *Qdev*, ...) is used, 
	it must be used in every *Idata* within the enclosing *SASdata*.
