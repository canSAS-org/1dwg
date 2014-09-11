.. $Id$

.. index:: ! element; SASinstrument

.. _SASinstrument:

============================
*SASinstrument*
============================

parent:
	:ref:`SASentry`

.. figure:: ../../graphics/4-SASinstrument.png
    
    The *SASinstrument* element

.. index::
	element; length
	element; aperture

============================== =========== ============ =========================================== ====================================
Name                           Type        Occurrence   Description                                 Attributes
============================== =========== ============ =========================================== ====================================
*name*                         string      [1..1]       Text string that identifies the name of 
                                                        this instrument
:ref:`SASsource`               container   [1..1]       Description of the radiation source.        *name={name}*
:ref:`SAScollimation`          container   [1..inf]     Description of a collimation element.       *name={name}*
:ref:`SASdetector`             container   [1..inf]     Description of the detector.                *name={name}*
============================== =========== ============ =========================================== ====================================
