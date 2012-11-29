.. $Id$

.. index:: ! element; SAStransmission_spectrum

.. _SAStransmission_spectrum:

========================================================
*SAStransmission_spectrum*
========================================================

parent:
	:ref:`SASentry`

.. figure:: ../../graphics/11-SAStransmission_spectrum.png
    
    The *SAStransmission_spectrum* element

The *SAStransmission_spectrum* element has a 
*name* attribute to identify what type of spectrum
is being described.  It is expected that this value will take either 
of these two values:

	==========  ================================================
	value       meaning
	==========  ================================================
	*sample*    measurement with the sample and container
	*can*       measurement with just the container
	==========  ================================================


.. index::
	element; Tdata

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:ref:`Tdata`           container   [1..inf]     Each *Tdata* describes a single data point
                                                of a transmission spectrum.
====================== =========== ============ =========================================== ====================================



.. index:: ! element; Tdata

.. _Tdata:

============================
*Tdata* element
============================

parent:
	:ref:`SAStransmission_spectrum`

.. index::
	element; Lambda
	element; T
	element; Tdev
	element; {any}

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*Lambda*               float       [1..1]       Wavelength of the radiation bin.            *unit={unit}*   [#units]_
                                                Either *A* or *nm* are typical units.
*T*                    float       [1..1]       Transmission value (:math:`I/I_0`)          *unit={unit}*   [#units]_
*Tdev*                 float       [0..1]       Estimated uncertainty (usually standard     *unit={unit}*   [#units]_
                                                deviation) of *T*. [#optional]_
                                                It is unexpected for *T* and *Tdev*
                                                to have different units.
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d/1.1 standard can be placed at 
                                                this point. 
====================== =========== ============ =========================================== ====================================

---------------

.. rubric:: Table Notes

..  [#units] The *unit* attribute is required. 
	See :ref:`rules` for acceptable values.
..  [#optional] When an optional element (such as *Tdev*, ...) is used, 
	it must be used in every *Tdata* within the enclosing *SAStransmission_spectrum*.
