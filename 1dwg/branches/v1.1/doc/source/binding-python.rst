.. $Id$

.. index:: ! binding; Python

.. _Python.binding:

================
Python
================

Specific support for the cansas1d:1.1 data standard in Python (http://danse.us/trac/sans)
is being developed by NIST/NCNR (http://www.ncnr.nist.gov)
as part of their contribution to the 
DANSE project (http://wiki.cacr.caltech.edu/danse).

Here are some extremely terse instructions (circa 2008) to get you started on a UNIX or Linux system:

.. code-block:: guess
	:linenos:
	
	svn co http://danse.us/trac/sans/browser/trunk/DataLoader DataLoader
	cd DataLoader
	python setup.py install

The release notes (http://danse.us/trac/sans/browser/trunk/DataLoader/release_notes.txt)
have a list of the dependencies.


.. rubric:: Comments

Other constructive suggestions (that predate the NIST/NCNR support) have been gathered on this page.
 
 
*gnosis.xml.objectify*
=========================
 
The *GnosisUtils* (http://freecode.com/projects/gnosisxml/)
offer a method to read any XML file into Python data structures. This utility 
does not validate the XML against a specific XML Schema which can be both good 
(flexible, especially when XML Foreign Namespace elements are used) and not 
so good (XML content not guaranteed to be valid *by the rules*).

A quick test of this turned up an acceptable result in that it was able to read 
several of the canSAS test XML files, including those with foreign namespaces.  
And **it was very easy**. 
(Especially with some help from http://www.xml.com/pub/a/2003/07/02/py-xml.html)

Here is a quick example.

Installation
------------

Here is the condensed *GnosisUtils* installation (without all that output) steps. 
Your system may have *gnosis* already installed. 
You may also need sysAdmin privileges. 
You may need ...

	.. code-block:: guess
		:linenos:
		
		cd /tmp
		wget http://freshmeat.net/redir/gnosisxml/22028/url_tgz/Gnosis_Utils-1.2.2.tar.gz
		tar xzf Gnosis_Utils-1.2.2.tar.gz 
		cd Gnosis_Utils-1.2.2/
		python setup.py install_all

Alternatively, it might be simpler to install from the PyPI
repository (http://pypi.python.org/pypi/Gnosis%20Utilities):

	.. code-block:: guess
		:linenos:
		
		easy_install -U gnosis_utils

.. index:: Python file; python-test.py

Quick test in Python
------------------------

.. sidebar:: Conclusion: OK

	The *GnosisUtils* have the promise of being a useful tool to support 
	reading this format in Python.  Now, how to write back out... ?
	From the website, it appears the development of GnosisUtils 
	has stagnated in 2007 at v1.2.2.

Here is the Python code (without all that output) (called *python-test.py*):

	.. rubric:: *python-test.py*
	
	.. code-block:: python
		:linenos:
		
		import gnosis.xml.objectify
		
		sasxml = gnosis.xml.objectify.XML_Objectify('bimodal-test1.xml').make_instance()  
		print sasxml.SASentry.Title.PCDATA
		print sasxml.SASentry.Run.PCDATA
		print sasxml.SASentry.SASinstrument.name.PCDATA
		data0 = sasxml.SASentry.SASdata.Idata[0]
		print data0.Q.unit,  data0.I.unit
		print data0.Q.PCDATA,  data0.I.PCDATA,  data0.Idev.PCDATA

	.. rubric:: Output from *python-test.py*
		
	.. code-block:: guess
		:linenos:
		
		[Pete@ubuntu,2441,cansas1dwg]$ ./python-test.py 
		SAS bimodal test1
		1992
		simulated SAS calculation
		1/A 1/cm
		0.0040157139 3497.473 90.72816

	.. rubric:: Full session output
		
	.. code-block:: guess
		:linenos:
		
		[Pete@ubuntu,2429,/tmp]$ cd /tmp
		/tmp
		[Pete@ubuntu,2430,/tmp]$ wget http://freshmeat.net/redir/gnosisxml/22028/url_tgz/Gnosis_Utils-1.2.2.tar.gz
		--11:43:16--  http://freshmeat.net/redir/gnosisxml/22028/url_tgz/Gnosis_Utils-1.2.2.tar.gz
		           => `Gnosis_Utils-1.2.2.tar.gz'
		Resolving freshmeat.net... 66.35.250.168
		Connecting to freshmeat.net|66.35.250.168|:80... connected.
		HTTP request sent, awaiting response... 302 Found
		Location: http://www.gnosis.cx/download/Gnosis_Utils.More/Gnosis_Utils-1.2.2.tar.gz [following]
		--11:43:16--  http://www.gnosis.cx/download/Gnosis_Utils.More/Gnosis_Utils-1.2.2.tar.gz
		           => `Gnosis_Utils-1.2.2.tar.gz'
		Resolving www.gnosis.cx... 64.41.64.172
		Connecting to www.gnosis.cx|64.41.64.172|:80... connected.
		HTTP request sent, awaiting response... 200 OK
		Length: 287,989 (281K) [application/x-tar]
		
		100%[==============================================================================>] 287,989       --.--K/s             
		
		11:43:16 (2.47 MB/s) - `Gnosis_Utils-1.2.2.tar.gz' saved [287989/287989]
		
		[Pete@ubuntu,2431,/tmp]$ tar xzf Gnosis_Utils-1.2.2.tar.gz 
		[Pete@ubuntu,2432,/tmp]$ cd Gnosis_Utils-1.2.2/
		/tmp/Gnosis_Utils-1.2.2
		[Pete@ubuntu,2433,Gnosis_Utils-1.2.2]$ python setup.py install_all
		[Pete@ubuntu,2434,Gnosis_Utils-1.2.2]$ cd ~/workspace/cansas1dwg-regitte
		[Pete@ubuntu,2435,cansas1dwg-regitte]$ python
		Python 2.5.1 (r251:54863, May 18 2007, 16:56:43) 
		[GCC 3.4.4 (cygming special, gdc 0.12, using dmd 0.125)] on cygwin
		Type "help", "copyright", "credits" or "license" for more information.
		>>> import gnosis.xml.objectify
		>>> sasxml = gnosis.xml.objectify.XML_Objectify('bimodal-test1.xml').make_instance()  
		>>> print sasxml.SASentry.Title.PCDATA
		SAS bimodal test1
		>>> print sasxml.SASentry.Run.PCDATA
		1992
		>>> print sasxml.SASentry.SASinstrument.name.PCDATA
		simulated SAS calculation
		>>> data0 = sasxml.SASentry.SASdata.Idata[0]
		>>> print data0.Q.unit
		1/A
		>>> print data0.I.unit
		1/cm
		>>> print data0.Q.PCDATA,  data0.I.PCDATA,  data0.Idev.PCDATA
		0.0040157139 3497.473 90.72816


	    
*generateDS.py*
===============

.. sidebar:: Conclusion: not ready yet (2008-05-16)

	Either the canSAS standard (by means of the cansas1d.xsd XML Schema) 
	is not ready or *generateDS.py* does not cover the 
	XML Schema requirements we have at this time. Either way, 
	this is not a viable tool to use now.

*generateDS.py* 
(http://www.rexx.com/~dkuhlman/, http://www.rexx.com/~dkuhlman/generateDS.html) 
can build a binding (map the structure of the XML file directly into a 
Python data structure) for Python from an XML Schema.
However, the cansas1d:1.1 XML schema (cansas1d.xsd) does not seem to 
fit the model.It seems, for now, that *generateDS-1.12a* 
fails on a certain *annotate* line.

.. code-block:: guess
	:linenos:
	
	[Pete@ubuntu,2402,cansas1dwg]$ python  \
			~/generateDS-1.12a/generateDS.py  \
			-p CS1D_  \
			-o cansas1d.py  \
			-s cansas1dsubs.py  \
			cansas1d.xsd
	Traceback (most recent call last):
	  File "/home/Pete/generateDS-1.12a/generateDS.py", line 3997, in &lt;module>
	    main()
	  File "/home/Pete/generateDS-1.12a/generateDS.py", line 3993, in main
	    processIncludes, superModule=superModule)
	  File "/home/Pete/generateDS-1.12a/generateDS.py", line 3909, in parseAndGenerate
	    root.annotate()
	AttributeError: 'NoneType' object has no attribute 'annotate'


Other possibilities
=====================

* http://www.devx.com/ibm/Article/20261
* http://mail.python.org/pipermail/xml-sig/2002-April/007559.html
* http://pywebsvcs.sourceforge.net/
