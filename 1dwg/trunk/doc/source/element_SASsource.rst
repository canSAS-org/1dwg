.. $Id$

.. index:: ! element; SASsource

.. _SASsource:

============================
*SASsource*
============================

parent:
	:ref:`SASinstrument`

.. figure:: ../../graphics/5-SASsource.png
    
    The *SASsource* element

.. index::
	element; radiation
	element; beam_size
	element; beam_shape
	element; wavelength
	element; wavelength_min
	element; wavelength_max
	element; wavelength_spread

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*radiation*            string      [1..1]       Name of the radiation used. 
                                                For maximum compatibility with 
                                                :index:`NeXus`, use one of the types 
                                                defined by NeXus *NXsource*: [#NXsource]_
                                                
                                                * Spallation Neutron Source
                                                * Pulsed Reactor Neutron Source
                                                * Reactor Neutron Source
                                                * Synchrotron X-ray Source
                                                * Pulsed Muon Source
                                                * Rotating Anode X-ray
                                                * Fixed Tube X-ray
                                                
                                                or the NeXus probe type:
                                                
                                                * neutron
                                                * x-ray
                                                * muon
                                                * electron
:ref:`source.bm_sz`    container   [0..1]       Physical dimension of the beam              *name={name}*  [#Z]_
                                                (incident on the sample).
                                                If beam is round, just use *X* dimension.
*beam_shape*           string      [0..1]       Text description of the shape of the beam
                                                (incident on the sample).
*wavelength*           float       [0..1]       wavelength (:math:`\lambda`)                *unit={unit}*   [#units]_
                                                of radiation incident on the sample.
*wavelength_min*       float       [0..1]       Some facilities specify wavelength          *unit={unit}*   [#units]_
                                                using a range. The minimum of such a 
                                                range is given by* wavelength_min*.
*wavelength_max*       float       [0..1]       Some facilities specify wavelength          *unit={unit}*   [#units]_
                                                using a range. The maximum of such a 
                                                range is given by* wavelength_max*.
*wavelength_spread*    float       [0..1]       Some facilities specify the width of        *unit={unit}*   [#units]_
                                                the wavelength spectrum. The width of 
                                                such a range is given by 
                                                *wavelength_spread*.
====================== =========== ============ =========================================== ====================================

geometry
============================

See the figures in :ref:`axes definition`.

.. _source.bm_sz:

*beam_size*
================

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:math:`x`              float       [0..1]       Dimension of the beam in *X*.               *unit={unit}*   [#units]_
:math:`y`              float       [0..1]       Dimension of the beam in *Y*.               *unit={unit}*   [#units]_
:math:`z`              float       [0..1]       Dimension of the beam in *Z*.               *unit={unit}*   [#Z]_  [#units]_
====================== =========== ============ =========================================== ====================================

---------------

.. rubric:: Table Notes

..  [#NXsource] NeXus *NXsource*: 
	http://download.nexusformat.org/doc/html/ClassDefinitions-Base.html#NXsource
..  [#Z] While :math:`z` is allowed by the standard (provided by use of 
	a standard *size* element in the XML Schema), it does not make sense 
	to use it for small-angle scattering in some situations as noted.  
	Use of :math:`z` in such situations may be 
	ignored by processing software.
..  [#units] The *unit* attribute is required. 
	See :ref:`rules` for acceptable values.
