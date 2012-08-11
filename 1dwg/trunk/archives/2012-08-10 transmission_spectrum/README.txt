2012-08-10, from stephen.king@stfc.ac.uk

herewith my examples of SASXML incorporating transmission vs wavelength.

 

The file _with2TL contains several datasets, some without any any T vs L, some with T vs L 
for **both** sample and can, some with T vs L for **either** the sample or can. Any of 
these is, in my view, a valid use case.

 

The file _noTL is the same datasets but without any T vs L, simply to check that my 
modified stylesheet didn’t barf.

 

Now, these examples use your original suggestion of a foreign namespace, and it works, 
and it does exactly what I’d like, HOWEVER, we already have provision in the standard 
under SASsample for stating a fixed-wavelength transmission, so for consistency I think 
wavelength-dependent transmissions should really also go in the same place!

 

Steve

 
