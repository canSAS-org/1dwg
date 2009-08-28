<?xml version="1.0"?>

<!--
########### SVN repository information ###################
# $Date$
# $Author$
# $Revision$
# $HeadURL$
# $Id$
########### SVN repository information ###################

Purpose:
	This stylesheet is used to display the cansas1d/1.0
	xmlWriter surveillance log..
-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
	>

	<xsl:template match="/">
<!-- DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" -->
		<html>
			<head>
				<title>canSAS/xmlWriter Surveillance Log</title>
			</head>
			<body>
				<h1>canSAS/xmlWriter Surveillance Log</h1>
				<BR />
				<xsl:apply-templates  />
				<hr />
				<small><center>$Id$</center></small>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="cansasxml">
		<table border="2">
			<tr>
				<th>date</th>
				<th>time</th>
				<th>method</th>
				<th>a.dd.re.ss</th>
				<th>host</th>
				<th>title</th>
				<th>radiation</th>
				<th>data length</th>
				<!-- <th>?count?</th>-->
			</tr>
			<xsl:for-each select="entry">
				<tr>
					<!-- see http://wwww.w3schools.com/xpath/xpath_functions.asp for more help -->
					<td><xsl:value-of select="@date" /></td>
					<td><xsl:value-of select="@time" /></td>
					<td><xsl:value-of select="server_variables/var[@name='REQUEST_METHOD']" /></td>
					<td><xsl:value-of select="server_variables/var[@name='REMOTE_ADDR']" /></td>
					<td><xsl:value-of select="server_variables/var[@name='REMOTE_HOST']" /></td>
					<td><xsl:value-of select="sas_variables/var[@name='title']" /></td>
					<td><xsl:value-of select="sas_variables/var[@name='instrument_radiation']" /></td>
					<td><xsl:value-of select="string-length(sas_variables/var[@name='SASdata'])" /></td>
					<!-- <td><xsl:value-of select="normalize-space(sas_variables/var[@name='SASdata'])" /></td>-->
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

</xsl:stylesheet>
