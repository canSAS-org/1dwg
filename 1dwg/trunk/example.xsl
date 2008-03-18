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
				<title>SAS data in canSAS 1-D format</title>
			</head>
			<body>
				<h1>SAS data in canSAS 1-D format</h1>
				<small>generated using <TT>example.xsl</TT> from canSAS</small>
				<BR />
				<table border="2">
					<tr>
						<th bgcolor="lavender">canSAS 1-D XML version:</th>
						<td><xsl:value-of select="cs:SASroot/@version" /></td>
					</tr>
					<tr>
						<th bgcolor="lavender">number of entries:</th>
						<td><xsl:value-of select="count(cs:SASroot/cs:SASentry)" /></td>
					</tr>
					<xsl:if test="count(/cs:SASroot//cs:SASentry)>1">
						<!-- if more than one SASentry, make a table of contents -->
						<xsl:for-each select="/cs:SASroot//cs:SASentry">
							<tr>
								<th bgcolor="lavender">SASentry-<xsl:value-of select="position()" /></th>
								<td>
									<A HREF="#SASentry-{generate-id(.)}">
										<xsl:if test="@name!=''">
											(<xsl:value-of select="@name" />)
										</xsl:if>
										<xsl:value-of select="cs:Title" />
									</A>
									<xsl:if test="count(cs:SASdata)>1">
										<!-- if more than one SASdata, make a local table of contents -->
										<xsl:for-each select="cs:SASdata">
											<xsl:text> | </xsl:text>
											<A HREF="#SASdata-{generate-id(.)}">
												<xsl:choose>
													<xsl:when test="@name!=''">
														<xsl:value-of select="@name" />
													</xsl:when>
													<xsl:otherwise>
														SASdata<xsl:value-of select="position()" />
													</xsl:otherwise>
												</xsl:choose>
											</A>
										</xsl:for-each>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:if>
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
			<A NAME="#SASentry-{generate-id(.)}" />
			<h1>
					SASentry<xsl:value-of select="position()" />:
					<xsl:if test="@name!=''">
						(<xsl:value-of select="@name" />)
					</xsl:if>
					<xsl:value-of select="cs:Title" />
			</h1>
			<xsl:if test="count(cs:SASdata)>1">
				<TABLE BORDER="2">
					<CAPTION>SASdata contents</CAPTION>
					<xsl:for-each select="cs:SASdata">
						<TR>
							<TH>SASdata-<xsl:value-of select="position()" /></TH>
							<TD>
								<A HREF="#SASdata-{generate-id(.)}">
									<xsl:choose>
									<xsl:when test="@name!=''">
											<xsl:value-of select="@name" />
										</xsl:when>
										<xsl:otherwise>
											SASdata<xsl:value-of select="position()" />
										</xsl:otherwise>
									</xsl:choose>
								</A>
							</TD>
						</TR>
					</xsl:for-each>
				</TABLE>
			</xsl:if>
			<br />
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
		<A NAME="#SASdata-{generate-id(.)}" />
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
		<TR>
			<TD>SASsample</TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='position'">
					<xsl:apply-templates select="." />
				</xsl:when>
				<xsl:when test="name()='orientation'">
					<xsl:apply-templates select="." />
				</xsl:when>
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD><xsl:value-of select="@unit" /></TD>
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASinstrument">
		<TR>
			<TD>SASinstrument</TD>
			<TD><xsl:value-of select="cs:name" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
		</TR>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='SASsource'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='SAScollimation'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='SASdetector'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='name'" />
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD><xsl:value-of select="@unit" /></TD>
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASsource">
		<TR>
			<TD><xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='beam_size'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD><xsl:value-of select="@unit" /></TD>
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:beam_size">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SAScollimation">
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='aperture'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD><xsl:value-of select="@unit" /></TD>
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:aperture">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD><xsl:value-of select="@type" /></TD>
		</TR>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='size'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD><xsl:value-of select="@unit" /></TD>
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:size">
		<TR>
			<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../../..)" />_<xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASdetector">
		<TR>
			<TD><xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="cs:name" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
		</TR>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='name'" />
				<xsl:when test="name()='offset'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='orientation'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='beam_center'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='pixel_size'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD><xsl:value-of select="@unit" /></TD>
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:orientation">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:position">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:offset">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:beam_center">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:pixel_size">
		<TR>
			<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
			<TD />
		</TR>
		<xsl:for-each select="*">
			<TR>
				<TD><xsl:value-of select="name(../..)" />_<xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@unit" /></TD>
			</TR>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:term">
		<TR>
			<TD><xsl:value-of select="@name" /></TD>
			<TD><xsl:value-of select="." /></TD>
			<TD><xsl:value-of select="@unit" /></TD>
		</TR>
	</xsl:template>

	<xsl:template match="cs:SASprocessnote">
		<TR>
			<TD><xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="." /></TD>
			<TD><xsl:value-of select="@name" /></TD>
		</TR>
	</xsl:template>

	<xsl:template match="cs:SASprocess">
		<TR>
			<TD><xsl:value-of select="name()" /></TD>
			<TD><xsl:value-of select="cs:name" /></TD>
			<TD><xsl:value-of select="@name" /></TD>
		</TR>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name()='name'" />
				<xsl:when test="name()='term'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name()='SASprocessnote'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<TR>
						<TD><xsl:value-of select="name(..)" />_<xsl:value-of select="name()" /></TD>
						<TD><xsl:value-of select="." /></TD>
						<TD />
					</TR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="cs:SASnote">
		<xsl:if test="@name!=''">
			<TR>
				<TD><xsl:value-of select="name()" /></TD>
				<TD><xsl:value-of select="." /></TD>
				<TD><xsl:value-of select="@name" /></TD>
			</TR>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
