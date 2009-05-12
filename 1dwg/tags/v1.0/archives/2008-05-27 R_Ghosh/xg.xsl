<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:s="cansas1d/1.0"
xsi:schemaLocation="cansas1d/1.0 http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd">
<xsl:template match="/">



<HTML>
<HEAD>
   <TITLE>ILL_SANS as html</TITLE>
</HEAD>

<BODY>
<CENTER>

<TABLE>
<TR>
<TD><TABLE border = "1" cellPadding="4" cellSpacing="2">


<TR>
 	<TH>Q  <xsl:value-of select="/s:SASroot/s:SASentry/s:SASdata/s:Idata/s:Q/@unit"/></TH>
	<TH>I <xsl:value-of select="/s:SASroot/s:SASentry/s:SASdata/s:Idata/s:I/@unit"/></TH>
	<TH>Idev <xsl:value-of select="/s:SASroot/s:SASentry/s:SASdata/s:Idata/s:Idev/@unit"/></TH>
	<TH>Qdev <xsl:value-of select="/s:SASroot/s:SASentry/s:SASdata/s:Idata/s:Qdev/@unit"/></TH>
 </TR>


<xsl:for-each select="s:SASroot/s:SASentry/s:SASdata/s:Idata">

 <TR>
	<TD><xsl:value-of select="s:Q"/> </TD>
	<TD><xsl:value-of select="s:I"/></TD>
	<TD><xsl:value-of select="s:Idev"/></TD>
	<TD><xsl:value-of select="s:Qdev"/></TD>
 </TR>
</xsl:for-each>
</TABLE></TD>
<TD  valign="top"><TABLE border="1" cellPadding="4" cellspacing="2" >
<TR>
<TH>Metadata component</TH>
<TH>Content</TH>
</TR>
<TR>
<TD>Title</TD>
<TD><xsl:value-of select="s:SASroot/s:SASentry/s:Title"/></TD>
</TR>
<TR>
<TD>Run</TD>
<TD><xsl:value-of select="s:SASroot/s:SASentry/s:Run"/></TD>
</TR>
<TR>
<TD>Sample temperature:  <xsl:value-of select="s:SASroot/s:SASentry/s:SASsample/s:temperature/@unit"/> </TD>
<TD><xsl:value-of select="s:SASroot/s:SASentry/s:SASsample/s:temperature"/></TD>
</TR>
<xsl:for-each select="s:SASroot/s:SASentry/s:SASprocess/s:term">


<TR><TD><xsl:value-of select="@name"/>:  <xsl:value-of select="@unit"/></TD><TD><xsl:value-of select="."/></TD></TR>


</xsl:for-each>

</TABLE>
</TD></TR></TABLE>
<H6 align="left">
<HR/>
<FONT face="Tahoma">
Using Stylesheet:  xg.xsl copied from $SAS_DIR/xg.tsl by g2x
</FONT></H6>
</CENTER>
</BODY>
</HTML>
</xsl:template>
</xsl:stylesheet>  