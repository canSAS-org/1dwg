<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cs="http://www.smallangles.net/cansas1d"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	>

	<!-- http://www.w3schools.com/xsl/xsl_transformation.asp -->
	<!-- http://www.smallangles.net/wgwiki/index.php/cansas1d_documentation -->

	<xsl:template match="/">
		<html>
			<head>
				<title>example XSL for cansas1d</title>
			</head>
			<body>
				<h1>SAS data in canSAS 1-D format</h1>
				<table border="2">
					<tr>
						<th bgcolor="lavender">version:</th>
						<td><xsl:value-of select="cs:SASroot/@version" /></td>
					</tr>
					<tr>
						<th bgcolor="lavender">number of entries:</th>
						<td><xsl:value-of select="count(cs:SASroot/cs:SASentry)" /></td>
					</tr>
				</table>
				<xsl:apply-templates  />
				<hr />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="cs:SASroot">
		<xsl:for-each select="cs:SASentry">
			<hr />
			<br />
			<h1>
				Entry: 
				<xsl:if test="@name!=''">
					(<xsl:value-of select="@name" />)
				</xsl:if>
				<xsl:value-of select="cs:Title" />
			</h1>
			<TABLE BORDER="2">
				<TR>
					<TH>SAS data</TH>
					<TH>Selected Metadata</TH>
				</TR>
				<TR>
					<TD valign="top"><xsl:apply-templates  select="cs:SASdata" /></TD>
					<TD valign="top">
						<TABLE BORDER="2">
							<TR bgcolor="lavender">
								<TH>name</TH>
								<TH>value</TH>
								<TH>unit</TH>
							</TR>
							<TR>
								<TD>Title</TD>
								<TD><xsl:value-of select="cs:Title" /></TD>
								<TD />
							</TR>
							<TR>
								<TD>Run</TD>
								<TD><xsl:value-of select="cs:Run" /></TD>
								<TD />
							</TR>
							<TR><xsl:apply-templates  select="run" /></TR>
							<xsl:apply-templates  select="cs:SASsample" />
							<xsl:apply-templates  select="cs:SASinstrument" />
							<xsl:apply-templates  select="cs:SASprocess" />
							<xsl:apply-templates  select="cs:SASnote" />
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASdata">
		<table border="2">
			<caption>
				<xsl:if test="@name!=''">
					<xsl:value-of select="@name" />
				</xsl:if>
				(<xsl:value-of select="count(cs:Idata)" /> points)
			</caption>
			<tr bgcolor="lavender">
				<xsl:for-each select="cs:Idata[1]/*">
					<th>
						<xsl:value-of select="name()" /> 
						<xsl:if test="@unit!=''">
							(<xsl:value-of select="@unit" />)
						</xsl:if>
					</th>
				</xsl:for-each>
			</tr>
			<xsl:for-each select="cs:Idata">
				<tr>
					<xsl:for-each select="*">
						<td><xsl:value-of select="." /></td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="cs:SASsample">
		<xsl:if test="cs:name!=''">
			<TR>
				<TD>Sample_optional_name</TD>
				<TD><xsl:value-of select="cs:name" /></TD>
				<TD />
			</TR>
		</xsl:if>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD />
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASinstrument">
		<xsl:if test="cs:name!=''">
			<TR>
				<TD>Instrument_name</TD>
				<TD><xsl:value-of select="cs:name" /></TD>
				<TD bgcolor="#9acd32">section follows</TD>
			</TR>
		</xsl:if>
		<xsl:apply-templates select="cs:SASsource" />
		<xsl:apply-templates select="cs:SAScollimation" />
		<xsl:apply-templates select="cs:SASdetector" />
	</xsl:template>

	<xsl:template match="cs:SASsource">
		<xsl:for-each select="*">
			<TR>
				<TD>SASsource_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SAScollimation">
		<xsl:for-each select="*">
			<TR>
				<TD>SAScollimation_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASdetector">
		<xsl:for-each select="*">
			<TR>
				<TD>SASdetector_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASprocess">
		<TR>
			<TD>SASprocess_name</TD>
			<TD><xsl:value-of select="cs:name" /></TD>
			<TD bgcolor="#9acd32">section follows</TD>
		</TR>
		<TR>
			<TD>SASprocess_date</TD>
			<TD><xsl:value-of select="cs:date" /></TD>
			<TD />
		</TR>
		<xsl:if test="count(cs:term)!=0">
			<xsl:for-each select="cs:term">
				<TR>
					<TD><xsl:value-of select="@name" /></TD>
					<TD><xsl:value-of select="." /></TD>
					<TD><xsl:value-of select="@unit" /></TD>
				</TR>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="count(cs:SASprocessnote)!=0">
			<xsl:if test="cs:SASprocessnote/cs:name!=''">
				<TR>
					<TD>SASprocessnote_name</TD>
					<TD><xsl:value-of select="cs:SASprocessnote/cs:name" /></TD>
					<TD bgcolor="#9acd32">section follows</TD>
				</TR>
			</xsl:if>
			<xsl:for-each select="cs:SASprocessnote">
				<xsl:if test=".!=''">
					<TR>
						<TD>SASprocessnote_<xsl:value-of select="@name" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD />
					</TR>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cs:SASnote">
		<xsl:if test="@name!=''">
			<TR>
				<TD>SASnote_<xsl:value-of select="@name" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD />
			</TR>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
