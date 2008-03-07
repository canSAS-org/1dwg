<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- http://www.w3schools.com/xsl/xsl_transformation.asp -->

	<xsl:template match="/">
		# SAS data
		<br />
		# Title:
		<xsl:value-of select="SASroot/SASentry/Title" />
		<br />
		Q I Idev
		<br />
		<xsl:for-each select="SASroot/SASentry/SASdata/Idata">
			<xsl:value-of select="Q_A-1" />
			<xsl:value-of select="I_cm-1" />
			<xsl:value-of select="Idev_cm-1" />
			<br />
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
