.. $Id$

.. index:: ! element; SASentry

.. _SASentry:

============================
*SASentry*
============================

parent:
	:ref:`SASroot`

.. figure:: ../../graphics/1-SASroot.png
    
    The *SASentry* element

.. index::
	element; Title
	element; Run
	element; {any}
	element; SASdata
	element; SASsample
	element; SASinstrument
	element; SASprocess
	element; SASnote

====================== =========== ============ =========================================== ====================================
Name                   Type        Occurrence   Description                                 Attributes
====================== =========== ============ =========================================== ====================================
*Title*                string      [1..1]       Title of this *SASentry*.                   *name={short-Run-identifier}*
*Run*                  string      [1..inf]     Run identification for this *SASentry*. 
                                                For many facilities, this is an integer. 
                                                Use multiple instances of *Run* as needed.

                                                Note: 
                                                How to correlate this with *SASdata* and 
                                                *SASinstrument* 
                                                configurations has not yet been defined.

                                                *name* is an optional string attribute to 
                                                identify this particular *Run*. Could use 
                                                this to associate (correlate) multiple
                                                *SASdata* elements with *Run* elements. 
                                                (Give them the same 
                                                *{short-Run-identifier}*.)
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d/1.1 standard can be placed at 
                                                this point.
:ref:`SASdata`         container   [1..inf]     Reduced 1-D SAS data for this *SASentry*.   *name={short-Run-identifier}*
                                                Use multiple *SASdata* elements to 
                                                represent multiple frames. 
                                                Use this to associate (correlate) 
                                                multiple *SASdata*
                                                elements with *Run* elements. 
                                                (Give them the same name.)
:ref:`{any}`           container   [0..inf]     Any element(s) not defined in the           *xmlns:{foreign-prefix}={foreign-namespace}*
                                                cansas1d/1.1 standard can be placed at 
                                                this point.
:ref:`SASsample`       container   [1..1]       Description of the sample.                  *name={short-SASsample-identifier}*
:ref:`SASinstrument`   container   [1..1]       Description of the instrument.
:ref:`SASprocess`      container   [0..inf]     Description of a processing or              *name={short-SASprocess-identifier}*
                                                analysis step.
:ref:`SASnote`         container   [1..inf]     Free form description of anything not       *name={short-SASnote-identifier}*
                                                covered by other elements.
====================== =========== ============ =========================================== ====================================
