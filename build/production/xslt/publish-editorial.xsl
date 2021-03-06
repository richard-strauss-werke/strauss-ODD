<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rsw="http://richard-strauss-ausgabe.de/ns/1.0"
                xmlns:mei="http://www.music-encoding.org/ns/mei"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">
   <xsl:param name="docIDParam" required="no"/>
   <xsl:output method="xml" indent="no" encoding="utf-8"/>
   <xsl:strip-space elements="additional additions address analytic app availability biblStruct body castList choice cit creation div editorialDecl encodingDesc epigraph event facsimile figure fileDesc floatingText front graphic handDesc handNote imprint index lg listBibl listChange listEvent monogr msDesc msIdentifier notatedMusic notesStmt objectDesc org performance person physDesc postscript profileDesc projectDesc publicationStmt relatedItem respons respStmt revisionDesc row seriesStmt sourceDesc sp space state subst supportDesc table teiHeader text textClass titleStmt"/>
   <xsl:key name="who" match="//@who" use="."/>
   <xsl:variable name="docID"
                 select="     if (base-uri()) then     replace(base-uri(), '^(.*/)?(.*)\..*$','$2')     else $docIDParam    "/>
   <xsl:variable name="rswDocumentPrefix">d</xsl:variable>
   <xsl:variable name="rswStaffPrefix">s</xsl:variable>
   <xsl:variable name="rswPdfPrefix">pdf</xsl:variable>
   <xsl:variable name="rswImgPrefix">img</xsl:variable>
   <xsl:variable name="guidelinesTitleRef">Die vorliegende Ausgabe folgt den <ref target="http://richard-strauss-ausgabe.de/guidelines/xml">Editionsrichtlinien der Kritischen Ausgabe der Werke von Richard Strauss</ref>.</xsl:variable>
   <xsl:variable name="specificFeaturesTitle">Besonderheiten der Edition des vorliegenden Dokuments:</xsl:variable>
   <xsl:variable name="funder">
      <funder xml:id="funder">
					    <name ref="http://www.badw.de">Bayerische Akademie der Wissenschaften</name>
					    <address>
						      <street>Alfons-Goppel-Straße 11</street>
						      <postCode>80539</postCode>
						      <placeName>
							        <country>Deutschland</country>
							        <settlement>München</settlement>
						      </placeName>
					    </address>
					    <idno type="url" n="gnd">http://d-nb.info/gnd/2005521-3</idno>
					    <idno type="url" n="viaf">http://viaf.org/viaf/123154646</idno>
				  </funder>
   </xsl:variable>
   <xsl:variable name="contributorsResp">Vorbereitung der digitalen Edition</xsl:variable>
   <xsl:variable name="publicationStmt">
				  <distributor sameAs="#funder"/>
				  <publisher sameAs="#funder"/>
				  <pubPlace>München</pubPlace>
				  <availability status="free">
					    <licence target="https://creativecommons.org/licenses/by/3.0/">CC-BY 3.0</licence>
				  </availability>
			</xsl:variable>
   <xsl:variable name="seriesStmt">
      <seriesStmt>
				     <title type="main">Richard Strauss: Werke</title>
				     <title type="sub">Kritische Ausgabe</title>
				     <title type="sub">Digitale Dokumentensammlung</title>
			   </seriesStmt>
   </xsl:variable>
   <xsl:variable name="edition"/>
   <xsl:variable name="staff">
      <empty/>
   </xsl:variable>
   <xsl:variable name="sexes">
      <empty/>
   </xsl:variable>
   <xsl:variable name="changeTypes">
      <empty/>
   </xsl:variable>
   <xsl:variable name="idnoUrlMap">
      <empty/>
   </xsl:variable>
   <xsl:variable name="keywords">
      <empty/>
   </xsl:variable>
   <xsl:template match="@*|node()|comment()|processing-instruction()|text()"
                 priority="-2">
      <xsl:copy copy-namespaces="no">
         <xsl:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="/processing-instruction()" priority="100"/>
   <xsl:template match="/*" priority="-1">
      <xsl:copy copy-namespaces="no">
         <xsl:attribute name="xml:id">
            <xsl:value-of select="$docID"/>
         </xsl:attribute>
         <xsl:apply-templates select="@*[not(name()='xml:id')]|node()|comment()|processing-instruction()|text()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="@url">
      <xsl:copy-of select="rsw:imageMimeType(.)"/>
      <xsl:copy copy-namespaces="no">
         <xsl:if test="not(starts-with(., 'http'))">
            <xsl:value-of select="$rswImgPrefix"/>
         </xsl:if>
         <xsl:value-of select="."/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="@key">
      <xsl:if test="normalize-space()">
         <xsl:attribute name="ref">
            <xsl:value-of select="concat($rswDocumentPrefix, ':', .)"/>
         </xsl:attribute>
      </xsl:if>
   </xsl:template>
   <xsl:template match="@scribeRef">
      <xsl:if test="normalize-space()">
         <xsl:copy copy-namespaces="no">
            <xsl:value-of select="concat($rswDocumentPrefix, ':', .)"/>
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <xsl:template match="change/text()|div/text()"/>
</xsl:stylesheet>
