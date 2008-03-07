<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- http://www.w3schools.com/xsl/xsl_transformation.asp -->

	<xsl:template match="/">
		<html>
			<body>
				<h2>SAS data</h2>
				<table border="1">
					<tr bgcolor="#9acd32">
						<th align="left">Q</th>
						<th align="left">I</th>
						<th align="left">Idev</th>
					</tr>
					<xsl:for-each
						select="SASroot/SASentry/SASdata/Idata">
						<tr>
							<td>
								<xsl:value-of select="Q_A-1" />
							</td>
							<td>
								<xsl:value-of select="I_cm-1" />
							</td>
							<td>
								<xsl:value-of select="Idev_cm-1" />
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
