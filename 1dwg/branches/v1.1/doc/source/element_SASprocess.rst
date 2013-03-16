.. $Id$

.. index:: ! element; SASprocess

.. _SASprocess:

============================
*SASprocess*
============================

parent:
	:ref:`SASentry`

.. figure:: ../../graphics/8-SASprocess.png
    
    The *SASprocess* element

.. index::
	element; name
	element; date
	element; description
	element; term
	element; SASprocessnote

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*name*                 string      [0..1]       Optional name for this data processing 
                                                or analysis step.
*date*                 string      [0..1]       Optional date for this data processing 
                                                or analysis step.  [#date]_
*description*          string      [0..1]       Optional description for this data 
                                                processing or analysis step.
*term*                 string      [0..1]       Specifies the value of a single variable,   *unit={unit}*   [#units]_
                                                parameter, or term (while defined here 
                                                as a string, it could be a number) 
                                                related to the *SASprocess* step.
:ref:`SASprocessnote`  container   [1..inf]     Describes anything about *SASprocess* 
                                                that is not already described.
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d:1.1 standard can be placed at 
                                                this point. 
====================== =========== ============ =========================================== ====================================



.. index:: ! element; SASprocessnote

.. _SASprocessnote:

============================
*SASprocessnote*
============================

parent:
	:ref:`SASprocess`

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d:1.1 standard can be placed at 
                                                this point.
====================== =========== ============ =========================================== ====================================

---------------

.. rubric:: Table Notes

.. [#date] Use a format for the date which is 
	easily machine-readable such as 
	ISO-8601 (either ``yyyy-mm-ddThh:mm:ss``
	or  ``yyyy-mm-dd hh:mm:ss``).
	See:  http://www.w3.org/TR/NOTE-datetime
	or    http://en.wikipedia.org/wiki/ISO_8601
	for more details.

..  [#units] The *unit* attribute is required for numerical data. 
	See :ref:`rules` for acceptable values.

