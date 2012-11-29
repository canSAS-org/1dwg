.. $Id$

.. index:: ! binding; FORTRAN

.. _fortran.binding:

================
FORTRAN
================

The development of the FORTRAN language, 
so beloved of scientists, pre-dates the development of XML. 
And it shows. FORTRAN is not a language that manipulates strings with ease, 
and this makes parsing XML decidedly awkward. 
So unless you *really* must use FORTRAN, 
you are probably better off with C/C++ (or something else more 'modern'), 
see for example Daniel Veillard's LIBXML2 library at http://xmlsoft.org/ 
or Frank van den Berghen's parser at 
http://www.applied-mathematics.net/tools/xmlParser.html.

If you have to use a dialect earlier than FORTRAN-90 (F90), 
then the chances are you will have to code your own parser.

Software Development Kits
==============================

For later dialects, there are some SDKs available on the Web:

**F90**
	
	* *XMLPARSE* - by Arjen Markus at http://xml-fortran.sourceforge.net/
	* *FoX* - by Toby White  others at http://uszla.me.uk/space/software/FoX/

**F95**

	* *XML* - by Mart Rentmeester at http://nn-online.org/code/xml/


canSAS 1-D SAS XML v1.0 support
======================================

.. sidebar:: Needs update to v1.1

	This update is expected to follow soon on the release of v1.1

Steve King[mailto:stephen.king@stfc.ac.uk] (ISIS) has provided a F77 routine 
that will read cansas1d/1.0 XML files.

http://www.cansas.org/trac/browser/1dwg/trunk/fortran/SASXML_G77.F 
