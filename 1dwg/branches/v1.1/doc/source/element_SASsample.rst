.. $Id$

.. index:: ! element; SASsample

.. _SASsample:

============================
*SASsample*
============================

parent:
	:ref:`SASentry`

.. figure:: ../../graphics/3-SASsample.png
    
    The *SASsample* element

.. index::
	element; ID
	element; thickness
	element; transmission
	element; temperature
	element; position
	element; orientation
	element; details
	element; {any}

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*ID*                   string      [1..1]       Text string that identifies this sample.
*thickness*            float       [0..1]       Thickness of this sample.                   *unit={unit}*   [#units]_
*transmission*         float       [0..1]       Transmission (:math:`I/I_0`) of this 
                                                sample.  Note that there is no
                                                *unit* attribute as this number is
                                                dimensionless.
*temperature*          float       [0..1]       Temperature of this sample.                 *unit={unit}*   [#units]_
:ref:`samp.pos`        container   [0..1]       Location of the sample in
                                                *X*, *Y*, and *Z*.
:ref:`samp.orient`     container   [0..1]       Orientation (rotation) of the sample.
*details*              string      [0..inf]     Any additional sample details.
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d:1.1 standard can be placed at 
                                                this point. 
====================== =========== ============ =========================================== ====================================


geometry
============================

See the figures in :ref:`axes definition`.




.. index:: ! element; position

.. _samp.pos:

*position*
================

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:math:`x`              float       [0..1]       Position of the sample in *X*.              *unit={unit}*   [#units]_
:math:`y`              float       [0..1]       Position of the sample in *Y*.              *unit={unit}*   [#units]_
:math:`z`              float       [0..1]       Position of the sample in *Z*.              *unit={unit}*   [#units]_  [#Z]_
====================== =========== ============ =========================================== ====================================


.. index:: ! element; orientation

.. _samp.orient:

*orientation*
================

.. note:: The *orientation* element is intended to describe
	simple rotations about a single axis rather than a full
	set of rotations as in a crystallographic context.

.. index::
	element; roll
	element; pitch
	element; yaw

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*roll*                 float       [0..1]       Rotation about the *Z* axis (roll).         *unit={unit}*   [#units]_
*pitch*                float       [0..1]       Rotation about the *X* axis (pitch).        *unit={unit}*   [#units]_
*yaw*                  float       [0..1]       Rotation about the *Y* axis (yaw).          *unit={unit}*   [#units]_
====================== =========== ============ =========================================== ====================================


---------------

.. rubric:: Table Notes

..  [#units] The *unit* attribute is required. 
	See :ref:`rules` for acceptable values.
..  [#Z] While :math:`z` is allowed by the standard (provided by use of 
	a standard *size* element in the XML Schema), it does not make sense 
	to use it for small-angle scattering in some situations as noted.  
	Use of :math:`z` in such situations may be 
	ignored by processing software.
