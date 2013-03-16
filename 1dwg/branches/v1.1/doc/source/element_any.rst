.. $Id$

.. index:: ! element; {any}
	see: <any>; element, {any}

.. _{any}:

============================
*{any}*
============================

This element is used as a catch-all, to allow users to introduce
other data (not defined by this canSAS standard) into the file.

.. index::
	element; {any}

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*{any}*                container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d:1.1 standard can be placed at 
                                                this point.
                                                (These are called **foreign** elements.
                                                It is suggested to associate foreign 
                                                elements with a foreign namespace to 
                                                differentiate them from the canSAS 
                                                elements in the XML file.)
====================== =========== ============ =========================================== ====================================
