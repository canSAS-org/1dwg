.. $Id$

.. index:: ! element; SASdetector

.. _SASdetector:

============================
*SASdetector*
============================

parent:
	:ref:`SASinstrument`

.. figure:: ../../graphics/7-SASdetector.png
    
    The *SASdetector* element

.. index::
	element; name
	element; SDD
	element; offset
	element; orientation
	element; beam_center
	element; pixel_size
	element; slit_length

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*name*                 string      [1..1]       Identifies the name of this detector.
*SDD*                  float       [0..1]       Distance between sample and detector.       *unit={unit}*   [#units]_
:ref:`det.off`         container   [0..1]       Offset of this detector position in 
                                                *X*, *Y*, (and *Z* if necessary).
:ref:`det.orient`      container   [0..1]       Orientation (rotation) of this detector 
                                                in roll, pitch, and yaw.
:ref:`det.bc`          container   [0..1]       Center of the beam on the detector 
                                                in *X*, *Y*, (and *Z* if necessary).
:ref:`det.pixsz`       container   [0..1]       Size of detector pixels
                                                in *X*, *Y*, (and *Z* if necessary).
*slit_length*          float       [0..1]       Slit length of the instrument               *unit={unit}*   [#units]_
                                                for this detector, expressed in the 
                                                same units as :math:`Q`.  
                                                (See :ref:`rules`)
====================== =========== ============ =========================================== ====================================



geometry
============================

See the figures in :ref:`axes definition`.


.. index:: ! element; offset

.. _det.off:

*offset*
============================

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:math:`x`              float       [0..1]       Offset of the detector position in *X*.     *unit={unit}*   [#units]_
:math:`y`              float       [0..1]       Offset of the detector position in *Y*.     *unit={unit}*   [#units]_
:math:`z`              float       [0..1]       Offset of the detector position in *Z*.     *unit={unit}*   [#units]_  [#Z]_
====================== =========== ============ =========================================== ====================================


.. index:: ! element; orientation

.. _det.orient:

*orientation*
============================

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


.. index:: ! element; beam_center

.. _det.bc:

*beam_center*
============================

Position of the beam center on the detector

====================== =========== ============ ==================================================== ====================================
Name                   Type        Occurrence   Description                                          Attributes
====================== =========== ============ ==================================================== ====================================
:math:`x`              float       [0..1]       Position of the beam center on the detector in *X*.  *unit={unit}*   [#units]_
:math:`y`              float       [0..1]       Position of the beam center on the detector in *Y*.  *unit={unit}*   [#units]_
:math:`z`              float       [0..1]       Position of the beam center on the detector in *Z*.  *unit={unit}*   [#units]_  [#Z]_
====================== =========== ============ ==================================================== ====================================


.. index:: ! element; pixel_size

.. _det.pixsz:

*pixel_size*
============================

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:math:`x`              float       [0..1]       Size of a detector pixel in *X*.            *unit={unit}*   [#units]_
:math:`y`              float       [0..1]       Size of a detector pixel in *Y*.            *unit={unit}*   [#units]_
:math:`z`              float       [0..1]       Size of a detector pixel in *Z*.            *unit={unit}*   [#units]_  [#Z]_
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
