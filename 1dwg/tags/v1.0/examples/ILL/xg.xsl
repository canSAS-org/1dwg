<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:cs="cansas1d/1.0"
xsi:schemaLocation="cansas1d/1.0 http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd">
<xsl:template match="/">



<html>
<head>
   <title>ILL_SANS as html</title>
</head>

<body>
<center>

<table>
<tr>
<td><table border = "1" cellpadding="4" cellspacing="2">


<tr>
 	<th>Q  <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:Q/@unit"/></th>
	<th>I <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:I/@unit"/></th>
	<th>Idev <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:Idev/@unit"/></th>
	<th>Qdev <xsl:value-of select="/cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata/cs:Qdev/@unit"/></th>
 </tr>


<xsl:for-each select="cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata">

 <tr>
	<td><xsl:value-of select="cs:Q"/> </td>
	<td><xsl:value-of select="cs:I"/></td>
	<td><xsl:value-of select="cs:Idev"/></td>
	<td><xsl:value-of select="cs:Qdev"/></td>
 </tr>
</xsl:for-each>
</table></td>
<td  valign="top"><table border="1" cellpadding="4" cellspacing="2" >
<tr>
<th>Metadata component</th>
<th>Content</th>
</tr>
<tr>
<td>Title</td>
<td><xsl:value-of select="cs:SASroot/cs:SASentry/cs:Title"/></td>
</tr>
<tr>
<td>Run</td>
<td><xsl:value-of select="cs:SASroot/cs:SASentry/cs:Run"/></td>
</tr>
<tr>
<td>Sample temperature:  <xsl:value-of select="cs:SASroot/cs:SASentry/cs:SASsample/cs:temperature/@unit"/> </td>
<td><xsl:value-of select="cs:SASroot/cs:SASentry/cs:SASsample/cs:temperature"/></td>
</tr>
<xsl:for-each select="cs:SASroot/cs:SASentry/cs:SASprocess/cs:term">


<tr><td><xsl:value-of select="@name"/>:  <xsl:value-of select="@unit"/></td><td><xsl:value-of select="."/></td></tr>


</xsl:for-each>

</table>
</td></tr></table>
<h6 align="left">
<hr/>
<font face="Tahoma">
Using Stylesheet:  xg.xsl copied from $SAS_DIR/xg.tsl by g2x
</font></h6>
</center>
</body>
</html>
</xsl:template>
</xsl:stylesheet>  