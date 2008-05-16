<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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
 	<TH>Q  <xsl:value-of select="/SASroot/SASentry/SASdata/Idata/Q/@unit"/></TH>
	<TH>I <xsl:value-of select="/SASroot/SASentry/SASdata/Idata/I/@unit"/></TH>
	<TH>Idev <xsl:value-of select="/SASroot/SASentry/SASdata/Idata/Idev/@unit"/></TH>
	<TH>Qdev <xsl:value-of select="/SASroot/SASentry/SASdata/Idata/Qdev/@unit"/></TH>
 </TR>


<xsl:for-each select="SASroot/SASentry/SASdata/Idata">

 <TR>
	<TD><xsl:value-of select="Q"/> </TD>
	<TD><xsl:value-of select="I"/></TD>
	<TD><xsl:value-of select="Idev"/></TD>
	<TD><xsl:value-of select="Qdev"/></TD>
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
<TD><xsl:value-of select="SASroot/SASentry/Title"/></TD>
</TR>
<TR>
<TD>Run</TD>
<TD><xsl:value-of select="SASroot/SASentry/Run"/></TD>
</TR>
<TR>
<TD>Sample temperature:  <xsl:value-of select="SASroot/SASentry/SASsample/temperature/@unit"/> </TD>
<TD><xsl:value-of select="SASroot/SASentry/SASsample/temperature"/></TD>
</TR>
<xsl:for-each select="SASroot/SASentry/SASprocess/term">


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