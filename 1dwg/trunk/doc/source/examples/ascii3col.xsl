<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cs="urn:cansas1d:1.1"
	xsi:schemaLocation="urn:cansas1d:1.1 http://www.cansas.org/svn/1dwg/trunk/cansas1d.xsd"
>
<xsl:template match="/">
<html>
<table>
<xsl:for-each select="cs:SASroot/cs:SASentry/cs:SASdata/cs:Idata">
<tr>
<td><xsl:value-of select="cs:Q"/></td>
<td><xsl:value-of select="cs:I"/></td>
<td><xsl:value-of select="cs:Idev"/></td>
</tr>
</xsl:for-each>
</table>
</html>
</xsl:template>
</xsl:stylesheet>  