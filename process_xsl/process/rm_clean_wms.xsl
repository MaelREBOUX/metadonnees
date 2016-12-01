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

      
  <!-- correction des infos d'accès au service WMS -->
  <!-- l'url doit pointer vers les capacités -->
  <!-- le name doit contenir une chaîne de caractères du type  workspace:layer  -->
      
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:param name="URL">gmd:URL</xsl:param>
  <xsl:param name="CharacterString">gco:CharacterString</xsl:param>


  <!-- a décommenter si l'URL n'a pas été passée de portail.sig à public.sig avec le script XSL geonetwork_process_123  -->
  <xsl:param name="urlPrefixSearch">https://portail.sig.rennesmetropole.fr/geoserver/</xsl:param>
  <xsl:param name="urlPrefixAfterTransf">https://portail.sig.rennesmetropole.fr/geoserver/ows?service=</xsl:param>
  
  <xsl:param name="urlPrefixTargetWms">https://portail.sig.rennesmetropole.fr/geoserver/ows?service=wms&amp;request=GetCapabilities</xsl:param>
  <xsl:param name="urlTypeSearch">/wms?</xsl:param>
  
  <xsl:template match="@* | node()"  >
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>     				
    </xsl:copy>
  </xsl:template>

  <!-- PROCESS N°5  recherche à partir des noeuds gmd:URL et gmd:CharacterString en controlant les noeuds parents et ancetres -->
  <xsl:template match="gmd:URL[parent::gmd:linkage and ancestor::gmd:CI_OnlineResource] | gco:CharacterString[parent::gmd:name and ancestor::gmd:CI_OnlineResource]"  priority="1"> 	 
    <xsl:copy>
      <xsl:choose>
        <!-- le noeud gmd:URL -->
        <xsl:when test="name()='gmd:URL'">
          <!-- le noeud gmd:URL avec le type préfédini (wms ou wfs) à été trouvé -->
				<xsl:if test="contains(text(), $urlPrefixSearch) and contains(text(), $urlTypeSearch) and not (contains(text(), $urlPrefixAfterTransf))">
					<xsl:copy-of  select="$urlPrefixTargetWms"/>
				</xsl:if>
				<xsl:if test="not(contains(text(), $urlPrefixSearch)) and not (contains(text(), $urlTypeSearch)) and not (contains(text(), $urlPrefixAfterTransf))">
					<xsl:apply-templates select="@* | node()"/>     				
				</xsl:if>
				<xsl:if test="contains(text(), $urlPrefixSearch) and not (contains(text(), $urlTypeSearch)) and not (contains(text(), $urlPrefixAfterTransf))">
					<xsl:apply-templates select="@* | node()"/>     				
				</xsl:if>
				<xsl:if test="contains(text(), $urlPrefixAfterTransf)">
					<xsl:apply-templates select="@* | node()"/>     				
				</xsl:if>
        </xsl:when>		
        <xsl:when test="name()='gco:CharacterString'">
          <!-- le noeud gco:CharacterString  a été trouvé -->
          <xsl:if test="contains(../../gmd:linkage/gmd:URL/text(), $urlPrefixSearch) and contains(../../gmd:linkage/gmd:URL/text(), $urlTypeSearch)">
				<!-- concaténation du workspace avec le layer et copie dans le fichier de sortie -->
			   <xsl:copy-of select="concat(concat(substring-before(substring-after(../../gmd:linkage/gmd:URL/text(),$urlPrefixSearch),'/'),':'), .)"/>
          </xsl:if>	
          <xsl:if test="not (contains(../../gmd:linkage/gmd:URL/text(), $urlPrefixSearch)) and not (contains(../../gmd:linkage/gmd:URL/text(), $urlTypeSearch))">
            <xsl:apply-templates select="@* | node()"/>     				
          </xsl:if>	
          <xsl:if test="contains(../../gmd:linkage/gmd:URL/text(), $urlPrefixSearch) and not (contains(../../gmd:linkage/gmd:URL/text(), $urlTypeSearch))">
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
