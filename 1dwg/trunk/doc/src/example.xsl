<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:cs="cansas1d/1.0"
xsi:schemaLocation="cansas1d/1.0 http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd">
<xsl:template match="/">

<html>
<head>
   <title>ASCII 3-column SAS data</title>
</head>

<body>
<center>

<table border = "1" cellpadding="4" cellspacing="2">

<tr>
 	<th>Q  <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:Q/@unit"/></th>
	<th>I <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:I/@unit"/></th>
	<th>Idev <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:Idev/@unit"/></th>
 </tr>

<xsl:for-each select="cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata">

 <tr>
	<td><xsl:value-of select="cs:Q"/> </td>
	<td><xsl:value-of select="cs:I"/></td>
	<td><xsl:value-of select="cs:Idev"/></td>
 </tr>
</xsl:for-each>
</table>
<h6 align="left">
<hr/>
<font face="Tahoma">
Using Stylesheet:  ascii3col.xsl
</font></h6>
</center>
</body>
</html>
</xsl:template>
</xsl:stylesheet>  