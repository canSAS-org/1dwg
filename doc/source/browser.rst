
.. _browser:


Browser Compatibility Issues
############################

One of the really nice features of the *cansas1d* format is 
that because it is XML it can be understood by any program 
that interprets `XSLT <https://en.wikipedia.org/wiki/XSLT>`_, 
and this includes web browsers. 
It is no longer necessary to edit a file simply to see its contents!

However, some web browsers can behave differently. 
Here is what we know:

Firefox
*******

* **IS** compatible with *cansas1d*

Internet Explorer
*****************

* **IS** compatible with *cansas1d*

Chrome
******

* **IS** compatible with *cansas1d* **but** only under specific conditions
* In developing Chrome, 
  `Google decided to adopt a security model known as 
  <http://blog.chromium.org/2008/12/security-in-depth-local-web-pages.html>`_
  ``same-origin``. 
  This actively prevents the browser from opening XML/XSL files over ``http://`` 
  connections, including the *cansas1d* stylesheet ``cansas1d.xsl``.
  
workaround for this problem in Chrome on Windows
++++++++++++++++++++++++++++++++++++++++++++++++
  
* A workaround is to run Chrome with the command-line option: ``--allow-file-access-from-files``
* in Windows:

   #. Unpin any instance of Chrome from the taskbar and/or delete any existing shortcuts to Chrome.
   #. Click the Start button and locate Google Chrome under All Programs.
   #. Right-click on Google Chrome and select Properties.
   #. Edit the Target box to append the switch to the text string:
      eg: ``C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --allow-file-access-from-files``
   #. Click Apply and Ok (NB: you may need Administrator permission to do this).
   #. Right-click on Google Chrome again and re-pin it to the taskbar or create a new shortcut.

.. note:: You can use the shortcut *Ctrl-O* to bring up an Open File dialog in any of these browsers.