<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rsga="http://richard-strauss-ausgabe.de/ns/1.0"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">
   <xsl:import href="rsw.xsl"/>
   <xsl:param name="docIDParam" required="no"/>
   <xsl:output method="xml" indent="no" encoding="utf-8"/>
   <xsl:strip-space elements="additional additions address analytic app availability biblStruct body castList choice cit creation div editionStmt editorialDecl encodingDesc epigraph event facsimile figure fileDesc floatingText front graphic handDesc handNote imprint index lg listBibl listChange listEvent monogr msDesc msIdentifier notatedMusic notesStmt objectDesc org performance person physDesc postscript profileDesc projectDesc publicationStmt relatedItem respons respStmt revisionDesc row seriesStmt sourceDesc sp space state subst supportDesc table teiHeader text textClass titleStmt"/>
   <xsl:key name="who" match="//@who" use="."/>
   <xsl:variable name="docID"
                 select="     if (base-uri()) then     replace(base-uri(), '^(.*/)?(.*)\..*$','$2')     else $docIDParam    "/>
   <xsl:variable name="guidelinesTitleRef">Die vorliegende Ausgabe folgt den <ref target="http://richard-strauss-ausgabe.de/guidelines/xml">Editionsrichtlinien der Kritischen Ausgabe der Werke von Richard Strauss</ref>.</xsl:variable>
   <xsl:variable name="specificFeaturesTitle">Besonderheiten der Edition des vorliegenden Dokuments:</xsl:variable>
   <xsl:variable name="funder">
      <funder>
					    <name ref="http://www.badw.de">Bayerische Akademie der Wissenschaften</name>
					    <address>
						      <street>Alfons-Goppel-Straße 11</street>
						      <postCode>80539</postCode>
						      <placeName>
							        <country>D</country>
							        <settlement>München</settlement>
						      </placeName>
					    </address>
				  </funder>
   </xsl:variable>
   <xsl:variable name="contributorsResp">Vorbereitung der digitalen Edition</xsl:variable>
   <xsl:variable name="publicationStmt">
				  <distributor>Forschungsstelle Richard-Strauss-Ausgabe</distributor>
				  <availability status="restricted">
					    <p>This work is licensed under a <ref target="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</ref>.</p>
				  </availability>
				  <pubPlace>München</pubPlace>
			</xsl:variable>
   <xsl:variable name="seriesStmt">
      <seriesStmt>
				     <title>Richard Strauss: Werke. Kritische Ausgabe. Digitale Dokumentensammlung</title>
			   </seriesStmt>
   </xsl:variable>
   <xsl:variable name="edition">Digitale Ausgabe</xsl:variable>
   <xsl:variable name="staff">
      <name xml:id="slm">Salome Reiser</name>
      <name xml:id="alx">Alexander Erhard</name>
      <name xml:id="sts">Stefan Schenk</name>
      <name xml:id="aap">Andreas Pernpeintner</name>
      <name xml:id="mmm">Martina Mengele</name>
      <name xml:id="flr">Florence Eller</name>
      <name xml:id="sbb">Sebastian Bolz</name>
      <name xml:id="wwb">Walter Werbeck</name>
      <name xml:id="clh">Claudia Heine</name>
      <name xml:id="afl">Florian Amort</name>
      <name xml:id="stk">Steffi Kracht</name>
      <name xml:id="oen">Ursula Welsch</name>
      <name xml:id="ofr">Oliver Fraenske</name>
      <name xml:id="pfr">Peter Fröhlich</name>
      <name xml:id="clh">Claudia Heine</name>
      <name xml:id="dpl">Dominik Leipold</name>
   </xsl:variable>
   <xsl:variable name="sexes">
      <empty/>
   </xsl:variable>
   <xsl:variable name="keywords">
      <empty/>
   </xsl:variable>
   <xsl:template match="@*|node()|comment()|processing-instruction()|text()"
                 priority="-2">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="/processing-instruction()" priority="100"/>
   <xsl:template match="/*" priority="-1">
      <xsl:copy>
         <xsl:attribute name="xml:id">
            <xsl:value-of select="$docID"/>
         </xsl:attribute>
         <xsl:apply-templates select="@*[not(name()='xml:id')]|node()|comment()|processing-instruction()|text()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="desc">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="rs">
      <xsl:call-template name="processRs"/>
   </xsl:template>
   <xsl:template match="graphic">
      <xsl:call-template name="keepOnlyWithAtt"/>
   </xsl:template>
   <xsl:template match="title">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="listBibl">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="textLang">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="idno">
      <xsl:call-template name="keepOnlyWithContent"/>
   </xsl:template>
   <xsl:template match="orgName">
      <xsl:call-template name="onlyWithContentAddCert"/>
   </xsl:template>
   <xsl:template match="persName">
      <xsl:call-template name="onlyWithContentAddCert"/>
   </xsl:template>
   <xsl:template match="placeName">
      <xsl:call-template name="onlyWithContentAddCert"/>
   </xsl:template>
   <xsl:template match="event">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="listEvent">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="org">
      <xsl:call-template name="perOrgRoot"/>
   </xsl:template>
   <xsl:template match="state">
      <xsl:call-template name="keepOnlyWithAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="seg">
      <xsl:call-template name="removeIfTyped"/>
   </xsl:template>
   <xsl:template match="respons">
      <xsl:call-template name="transformRespons"/>
   </xsl:template>
   <xsl:template match="head/date">
      <xsl:call-template name="expandOrRemoveDate"/>
   </xsl:template>
   <xsl:template match="event/head">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='commentary']">
      <xsl:call-template name="tightenCommentary"/>
   </xsl:template>
   <xsl:template match="org/note[@type='summary']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='discussion']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='uncategorized']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='details']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="listBibl/bibl">
      <xsl:call-template name="transformOrRemoveBibl"/>
   </xsl:template>
   <xsl:template match="@key">
      <xsl:attribute name="ref">http://richard-strauss-ausgabe.de/documents/view/<xsl:value-of select="."/>
      </xsl:attribute>
   </xsl:template>
   <xsl:template match="change/text()|div/text()"/>
   <xsl:template match="@who|@resp|@new">
      <xsl:attribute name="{name()}">#<xsl:value-of select="."/>
      </xsl:attribute>
   </xsl:template>
   <xsl:template match="@change">
      <xsl:attribute name="change">#change-<xsl:value-of select="."/>
      </xsl:attribute>
   </xsl:template>
</xsl:stylesheet>
