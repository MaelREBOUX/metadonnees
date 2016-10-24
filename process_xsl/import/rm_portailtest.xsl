<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0" 
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:gmd="http://www.isotc211.org/2005/gmd" 
      xmlns:srv="http://www.isotc211.org/2005/srv" 
      xmlns:gco="http://www.isotc211.org/2005/gco" 
      xmlns:xlink="http://www.w3.org/1999/xlink" 
      xmlns:gmx="http://www.isotc211.org/2005/gmx" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xmlns:gfc="http://www.isotc211.org/2005/gfc" 
      xmlns:gts="http://www.isotc211.org/2005/gts" 
      xmlns:gml="http://www.opengis.net/gml" 
      xmlns:geonet="http://www.fao.org/geonetwork">


	<!-- modification des url pour la PF de test -->

	<xsl:output omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="URL">gmd:URL</xsl:param>
	<xsl:param name="urlPrefixSearchPortail">https://portail.sig</xsl:param>
	<xsl:param name="urlPrefixCiblePortail">https://portail-test.sig</xsl:param>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="name()=$URL">
					<xsl:if test="(contains(text(), $urlPrefixSearchPortail))">
						<xsl:value-of select="concat($urlPrefixCiblePortail,substring-after(text(),$urlPrefixSearchPortail))">
						</xsl:value-of>
					</xsl:if>
					<xsl:if test="not(contains(text(), $urlPrefixSearchPortail))">
						<xsl:apply-templates select="@* | node()"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@* | node()"/>     				
				</xsl:otherwise>   
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
