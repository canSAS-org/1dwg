<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cs="http://www.smallangles.net/cansas1d"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	>

	<!-- http://www.w3schools.com/xsl/xsl_transformation.asp -->

	<xsl:template match="/">
		<html>
			<head>
				<title>example XSL for cansas1d</title>
			</head>
			<body>
				<h1>SAS data in canSAS 1-D format</h1>
				<table>
					<tr>
						<th>version:</th>
						<td><xsl:value-of select="cs:SASroot/@version" /></td>
					</tr>
					<tr>
						<th>number of entries:</th>
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
			<h1>Entry: <xsl:value-of select="@name" /></h1>
			<xsl:apply-templates />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:Title">
		<h2><xsl:value-of select="cs:Title" /></h2>
	</xsl:template>

	<xsl:template match="cs:Run">
		Run: <xsl:value-of select="cs:Run" /><br />
	</xsl:template>

	<xsl:template match="cs:SASdata">
		<h3>SAS data</h3>
		<table border="2">
			<caption>number of points: <xsl:value-of select="count(cs:Idata)" /></caption>
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
		<h3>Sample: <xsl:value-of select="cs:name" /></h3>
		<xsl:for-each select="*">
			<xsl:value-of select="name()" />: <xsl:value-of select="." /><br />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASinstrument">
		<h3>Instrument: <xsl:value-of select="name" /></h3>
		<xsl:apply-templates select="cs:SASsource" />
		<xsl:apply-templates select="cs:SAScollimation" />
		<xsl:apply-templates select="cs:SASdetector" />
	</xsl:template>

	<xsl:template match="cs:SASsource">
		<h4>Source: <xsl:value-of select="@name" /></h4>
		<xsl:for-each select="*">
			<xsl:value-of select="name()" />: <xsl:value-of select="." /><br />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SAScollimation">
		<h4>Collimation: <xsl:value-of select="@name" /></h4>
		<xsl:for-each select="*">
			<xsl:value-of select="name()" />: <xsl:value-of select="." /><br />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASdetector">
		<h4>Detector: <xsl:value-of select="name" /></h4>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="cs:SASprocess">
		<h3>Processing: <xsl:value-of select="cs:name" /></h3>
		date: <xsl:value-of select="cs:date" /><br />
		<xsl:if test="count(cs:term)!=0">
			<DL>
				<xsl:for-each select="cs:term">
					<DT>
						<xsl:value-of select="@name" />
						<xsl:if test="@unit!=''">
							(<xsl:value-of select="@unit" />)
						</xsl:if>
					</DT>
					<DD><xsl:value-of select="." /></DD>
				</xsl:for-each>
			</DL>
		</xsl:if>:
		<xsl:apply-templates  select="cs:SASprocessnote" />
	</xsl:template>

	<xsl:template match="cs:SASnote">
		<h3>Note: <xsl:value-of select="@name" /></h3>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="cs:sizeDist">
		<h3>size distribution: <xsl:value-of select="@name" /></h3>
		<table border="2">
			<caption>number of points: <xsl:value-of select="count(cs:row)" /></caption>
			<tr bgcolor="lavender">
				<xsl:for-each select="cs:row[1]/*">
					<th><xsl:value-of select="name()" /> (<xsl:value-of select="@unit" />)</th>
				</xsl:for-each>
			</tr>
			<xsl:for-each select="cs:row">
				<tr>
					<xsl:for-each select="*">
						<td><xsl:value-of select="." /></td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

</xsl:stylesheet>
