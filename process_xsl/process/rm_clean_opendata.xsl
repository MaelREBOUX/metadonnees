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


  <!-- remplacer l'url de l'ancien site open data par le nouveau -->

  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:param name="URL">gmd:URL</xsl:param>
  <xsl:param name="CharacterString">gco:CharacterString</xsl:param>
  <xsl:param name="urlPrefixSearchOpenData">http://www.data.rennes-metropole.fr</xsl:param>
  <xsl:param name="urlPrefixTargetOpenData">http://data.rennesmetropole.fr</xsl:param>

  <xsl:template match="@* | node()" priority="5" >
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="name()='gmd:URL'">
          <!-- le noeud gmd:URL à été trouvé , test pour controler qu'il contient bien l'URL www.data.rennes-metropole.fr -->
          <xsl:if test="(contains(text(), $urlPrefixSearchOpenData))">
            <!-- obsolète :  si ok concaténation du texte de l'URL cible avec le texte de ce qui se trouve après la partie à remplacer -->     
            <!-- <xsl:copy-of select="concat($urlPrefixTargetOpenData,substring-after(text(),$urlPrefixSearchOpenData))"/> -->
            <!-- on se contente de tout écraser -->
            <xsl:copy-of select="$urlPrefixTargetOpenData"/>
          </xsl:if>
          <xsl:if test="not(contains(text(), $urlPrefixSearchOpenData))">
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
