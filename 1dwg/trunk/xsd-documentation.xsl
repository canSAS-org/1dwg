<xsl:stylesheet version="1.0"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cs="cansas1d/1.0">

	<!-- http://www.w3schools.com/xsl/xsl_transformation.asp -->

	<xsl:strip-space elements="DT DD" />

	<xsl:template match="/">
		<html>
			<head>
				<title>
					Extracted documentation from canSAS 1-D XML Schema
				</title>
			</head>
			<body>
				<h1>
					Extracted documentation from canSAS 1-D XML Schema
				</h1>
				<DL>
				<xsl:apply-templates select="//xsd:documentation" />
				</DL>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="xsd:documentation-html">
		<DT><xsl:value-of select="xsd:DT" /></DT>
		<DD><xsl:value-of select="xsd:DD" /></DD>
	</xsl:template>

	<xsl:template match="xsd:documentation">
		;&lt;TT&gt;<xsl:value-of select="xsd:DT" /> &lt;/TT&gt;:
		<xsl:value-of select="xsd:DD" /> &lt;br /&gt;<br />
	</xsl:template>

</xsl:stylesheet>
