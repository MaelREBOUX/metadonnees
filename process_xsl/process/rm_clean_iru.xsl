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

  <!-- création d'un Resource Locator conforme aux recommandations nationales sur les métadonnées -->
  <!-- ATTENTION ici on renvoie volontairement au service HTML et non au service XML -->

  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:param name="URL">gmd:URL</xsl:param>
  <xsl:param name="CharacterString">gco:CharacterString</xsl:param>

  <xsl:variable name="defaultUuid"   select="gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString" />
  <xsl:param    name="defaultnewURL">http://portail.sig.rennesmetropole.fr/geonetwork/srv/fre/xml.metadata.get?uuid=</xsl:param>
  <xsl:param    name="workspace" select ="''"  />

  <xsl:template match="@* | node()"  >
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>     				
    </xsl:copy>
  </xsl:template>


  <!-- PROCESS N°6 -->
  <xsl:template match="gco:CharacterString[ancestor::gmd:MD_Identifier]"  priority="2"> 	 
    <!--  un noeud gco:CharacterString ayant pour ancetre MD_Identifier a été trouvée -->
    <xsl:copy>
      <!--  une balise  gco:CharacterString ayant pour ancetre MD_Identifier à été trouvée -->
      <!--  copie dans le fichier de sorti de la nouvelle URL avec UUID --> 
      <xsl:copy-of select="concat($defaultnewURL,$defaultUuid)"/> 
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
