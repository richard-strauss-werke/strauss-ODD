<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rsga="http://richard-strauss-ausgabe.de/ns/1.0"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">
   <xsl:import href="rswa.xsl"/>
   <xsl:output method="xml" indent="yes" encoding="utf-8"/>
   <xsl:strip-space elements="additional additions address analytic app availability biblStruct body castList choice cit creation div editionStmt editorialDecl encodingDesc epigraph event facsimile figure fileDesc floatingText front graphic handDesc handNote imprint index lg listBibl listChange listEvent monogr msDesc msIdentifier notatedMusic notesStmt objectDesc org performance person physDesc postscript profileDesc projectDesc publicationStmt relatedItem respons respStmt revisionDesc row seriesStmt sourceDesc sp space state subst supportDesc table teiHeader text textClass titleStmt"/>
   <xsl:key name="who" match="//@who" use="."/>
   <xsl:variable name="docID" select="replace(base-uri(), '^(.*/)?(.*)\..*$','$2')"/>
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
   </xsl:variable>
   <xsl:variable name="publicationStmt">
				  <distributor>Forschungsstelle zur Edition der Werke von Richard Strauss</distributor>
				  <availability status="restricted">
					    <p>This work is licensed under a <ref target="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</ref>.</p>
				  </availability>
				  <pubPlace>München</pubPlace>
			</xsl:variable>
   <xsl:variable name="seriesStmt">
      <seriesStmt>
				     <title>Digitale Dokumentensammlung zum Werk von Richard Strauss</title>
			   </seriesStmt>
   </xsl:variable>
   <xsl:variable name="edition">Digitale Ausgabe</xsl:variable>
   <xsl:variable name="sexes">
      <sex value="M">männlich</sex>
      <sex value="F">weiblich</sex>
      <sex value="O">sonstiges</sex>
      <sex value="N">keines</sex>
      <sex value="U">unbekannt</sex>
      <dummy/>
   </xsl:variable>
   <xsl:template match="@*|node()|comment()|processing-instruction()|text()"
                 priority="-1">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="/processing-instruction()" priority="100"/>
   <xsl:template match="/*">
      <xsl:copy>
         <xsl:attribute name="xml:id">
            <xsl:value-of select="$docID"/>
         </xsl:attribute>
         <xsl:apply-templates select="@*[not(name()='xml:id')]|node()|comment()|processing-instruction()|text()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="rs">
      <xsl:call-template name="processRs"/>
   </xsl:template>
   <xsl:template match="graphic">
      <xsl:call-template name="keepOnlyWithAtt"/>
   </xsl:template>
   <xsl:template match="listBibl">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
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
   <xsl:template match="respons">
      <xsl:call-template name="transformRespons"/>
   </xsl:template>
   <xsl:template match="event">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="listEvent">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="state">
      <xsl:call-template name="keepOnlyWithAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="affiliation">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="birth">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="death">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="faith">
      <xsl:call-template name="keepOnlyWithAttOrContent"/>
   </xsl:template>
   <xsl:template match="residence">
      <xsl:call-template name="keepOnlyWithContent"/>
   </xsl:template>
   <xsl:template match="sex">
      <xsl:call-template name="expandOrRemoveSex"/>
   </xsl:template>
   <xsl:template match="affiliation/date">
      <xsl:call-template name="expandOrRemoveDate"/>
   </xsl:template>
   <xsl:template match="birth/date">
      <xsl:call-template name="expandOrRemoveDate"/>
   </xsl:template>
   <xsl:template match="death/date">
      <xsl:call-template name="expandOrRemoveDate"/>
   </xsl:template>
   <xsl:template match="head/date">
      <xsl:call-template name="expandOrRemoveDate"/>
   </xsl:template>
   <xsl:template match="event/head">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='commentary']">
      <xsl:call-template name="tightenCommentary"/>
   </xsl:template>
   <xsl:template match="person/note[@type='summary']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='discussion']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='uncategorized']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='details']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='figures']">
      <xsl:call-template name="keepOnlyWithChildAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="listBibl/bibl">
      <xsl:call-template name="transformOrRemoveBibl"/>
   </xsl:template>
   <xsl:template match="@key">
      <xsl:attribute name="ref">http://richard-strauss-ausgabe.de/documents/xml/<xsl:value-of select="."/>
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
