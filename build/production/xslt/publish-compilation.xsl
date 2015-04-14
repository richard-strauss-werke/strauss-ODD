<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rsw="http://richard-strauss-ausgabe.de/ns/1.0"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">
   <xsl:import href="rsw.xsl"/>
   <xsl:param name="docIDParam" required="no"/>
   <xsl:output method="xml" indent="no" encoding="utf-8"/>
   <xsl:strip-space elements="additional additions address analytic app availability biblStruct body castList choice cit creation div editorialDecl encodingDesc epigraph event facsimile figure fileDesc floatingText front graphic handDesc handNote imprint index lg listBibl listChange listEvent monogr msDesc msIdentifier notatedMusic notesStmt objectDesc org performance person physDesc postscript profileDesc projectDesc publicationStmt relatedItem respons respStmt revisionDesc row seriesStmt sourceDesc sp space state subst supportDesc table teiHeader text textClass titleStmt"/>
   <xsl:key name="who" match="//@who" use="."/>
   <xsl:variable name="docID"
                 select="     if (base-uri()) then     replace(base-uri(), '^(.*/)?(.*)\..*$','$2')     else $docIDParam    "/>
   <xsl:variable name="rswDocumentPrefix">d</xsl:variable>
   <xsl:variable name="rswStaffPrefix">s</xsl:variable>
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
				     <title type="main">Richard Strauss: Werke</title>
				     <title type="sub">Kritische Ausgabe</title>
				     <title type="sub">Digitale Dokumentensammlung</title>
			   </seriesStmt>
   </xsl:variable>
   <xsl:variable name="edition"/>
   <xsl:variable name="staff">
      <name ref="s:alx">Alexander Erhard</name>
      <name ref="s:sts">Stefan Schenk</name>
      <name ref="s:aap">Andreas Pernpeintner</name>
      <name ref="s:clh">Claudia Heine</name>
      <name ref="s:mmm">Martina Mengele</name>
      <name ref="s:flr">Florence Eller</name>
      <name ref="s:sbb">Sebastian Bolz</name>
      <name ref="s:wwb">Walter Werbeck</name>
      <name ref="s:afl">Florian Amort</name>
      <name ref="s:stk">Steffi Kracht</name>
      <name ref="s:oen">Ursula Welsch</name>
      <name ref="s:ofr">Oliver Fraenske</name>
      <name ref="s:pfr">Peter Fröhlich</name>
      <name ref="s:dpl">Dominik Leipold</name>
      <empty/>
   </xsl:variable>
   <xsl:variable name="sexes">
      <sex value="M">männlich</sex>
      <sex value="F">weiblich</sex>
      <sex value="O">sonstiges</sex>
      <sex value="N">keines</sex>
      <sex value="U">unbekannt</sex>
      <empty/>
   </xsl:variable>
   <xsl:variable name="changeTypes">
      <change type="UO">Übertragen nach Original</change>
      <change type="UC">Übertragen nach Entwurf</change>
      <change type="UA">Übertragen nach Abschrift v.f.H.</change>
      <change type="UP">Übertragen nach Papierkopie</change>
      <change type="UI">Übertragen nach Mikroform</change>
      <change type="UM">Übertragen nach autogr. Abschrift</change>
      <change type="UD">Übertragen nach Original [Digitalisat]</change>
      <change type="UG">Übertragen nach Entwurf [Digitalisat]</change>
      <change type="UH">Übertragen nach Abschrift v.f.H. [Digitalisat]</change>
      <change type="UF">Übertragen nach Papierkopie [Digitalisat]</change>
      <change type="UJ">Übertragen nach Mikroform [Digitalisat]</change>
      <change type="UB">Übertragen nach autogr. Abschrift [Digitalisat]</change>
      <change type="UE">Übertragen nach Edition</change>
      <change type="UZ">Übertragen nach Auszug</change>
      <change type="UW">Übertragung</change>
      <change type="KO">Korrigiert nach Original</change>
      <change type="KC">Korrigiert nach Entwurf</change>
      <change type="KA">Korrigiert nach Abschrift v.f.H.</change>
      <change type="KP">Korrigiert nach Papierkopie</change>
      <change type="KI">Korrigiert nach Mikroform</change>
      <change type="KM">Korrigiert nach autogr. Abschrift</change>
      <change type="KD">Korrigiert nach Original [Digitalisat]</change>
      <change type="KG">Korrigiert nach Entwurf [Digitalisat]</change>
      <change type="KH">Korrigiert nach Abschrift v.f.H. [Digitalisat]</change>
      <change type="KF">Korrigiert nach Papierkopie [Digitalisat]</change>
      <change type="KJ">Korrigiert nach Mikroform [Digitalisat]</change>
      <change type="KB">Korrigiert nach autogr. Abschrift [Digitalisat]</change>
      <change type="KE">Korrigiert nach Edition</change>
      <change type="KZ">Korrigiert nach Auszug</change>
      <change type="KW">Korrigiert</change>
      <change type="VQ">Vollständigkeit der Quellenübertragung bestätigt</change>
      <change type="VT">Vollständigkeit der Textauszeichnung bestätigt</change>
      <change type="VL">Vollständigkeit der Verlinkung bestätigt</change>
      <change type="P">Vorgeschlagen zur Publikation</change>
      <change type="C">Als möglicherweise publikationsfertig gekennzeichnet</change>
      <change type="A">Zur Publikation freigegeben</change>
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
   <xsl:template match="desc">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="gloss">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="rs">
      <xsl:call-template name="processRs"/>
   </xsl:template>
   <xsl:template match="graphic">
      <xsl:call-template name="keepOnlyWithAtt"/>
   </xsl:template>
   <xsl:template match="series">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="respStmt">
      <xsl:call-template name="expandRespStmt"/>
   </xsl:template>
   <xsl:template match="title">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="imprint">
      <xsl:call-template name="processImprint"/>
   </xsl:template>
   <xsl:template match="publisher">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="biblScope">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="pubPlace">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="listBibl">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="textLang">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="edition">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="idno">
      <xsl:call-template name="keepOnlyWithContent"/>
   </xsl:template>
   <xsl:template match="notesStmt">
      <xsl:call-template name="processNotesStmt"/>
   </xsl:template>
   <xsl:template match="encodingDesc">
      <xsl:call-template name="expandEncodingDesc"/>
   </xsl:template>
   <xsl:template match="editorialDecl">
      <xsl:call-template name="expandEditorialDecl"/>
   </xsl:template>
   <xsl:template match="handNote">
      <xsl:call-template name="processHandNote"/>
   </xsl:template>
   <xsl:template match="textClass">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="revisionDesc">
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
   <xsl:template match="affiliation">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="birth">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="death">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="event">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="faith">
      <xsl:call-template name="keepOnlyWithAttOrContent"/>
   </xsl:template>
   <xsl:template match="listEvent">
      <xsl:call-template name="processListEvent"/>
   </xsl:template>
   <xsl:template match="occupation">
      <xsl:call-template name="keepOnlyWithAttOrContent"/>
   </xsl:template>
   <xsl:template match="org">
      <xsl:call-template name="perOrgRoot"/>
   </xsl:template>
   <xsl:template match="person">
      <xsl:call-template name="perOrgRoot"/>
   </xsl:template>
   <xsl:template match="residence">
      <xsl:call-template name="keepOnlyWithContent"/>
   </xsl:template>
   <xsl:template match="sex">
      <xsl:call-template name="expandOrRemoveSexElement"/>
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
   <xsl:template match="div">
      <xsl:call-template name="processDiv"/>
   </xsl:template>
   <xsl:template match="origDate">
      <xsl:call-template name="expandOrRemoveDate"/>
   </xsl:template>
   <xsl:template match="origPlace">
      <xsl:call-template name="expandOrRemoveOrigPlace"/>
   </xsl:template>
   <xsl:template match="repository">
      <xsl:call-template name="transformOrRemoveRepository"/>
   </xsl:template>
   <xsl:template match="collection">
      <xsl:call-template name="keepOnlyWithContent"/>
   </xsl:template>
   <xsl:template match="physDesc">
      <xsl:call-template name="processPhysDesc"/>
   </xsl:template>
   <xsl:template match="objectDesc">
      <xsl:call-template name="keepOnlyWithAnyText"/>
   </xsl:template>
   <xsl:template match="additions">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="additional">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="rsw:taskDesc">
      <xsl:call-template name="warnIfHasChildOrRemove"/>
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
   <xsl:template match="notesStmt/note[@type='commentary']">
      <xsl:call-template name="tightenCommentary"/>
   </xsl:template>
   <xsl:template match="org/note[@type='commentary']">
      <xsl:call-template name="tightenCommentary"/>
   </xsl:template>
   <xsl:template match="person/note[@type='commentary']">
      <xsl:call-template name="tightenCommentary"/>
   </xsl:template>
   <xsl:template match="performance/note[@type='commentary']">
      <xsl:call-template name="tightenCommentary"/>
   </xsl:template>
   <xsl:template match="notesStmt/note[@type='summary']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='summary']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='summary']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="performance/note[@type='summary']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="notesStmt/note[@type='discussion']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='discussion']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='discussion']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="performance/note[@type='discussion']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="notesStmt/note[@type='uncategorized']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='uncategorized']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='uncategorized']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="performance/note[@type='uncategorized']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="org/note[@type='details']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='details']">
      <xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
   </xsl:template>
   <xsl:template match="person/note[@type='figures']">
      <xsl:call-template name="keepOnlyWithChildAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="performance/note[@type='listBibl']">
      <xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
   </xsl:template>
   <xsl:template match="revisionDesc/change">
      <xsl:call-template name="processRevisionDescChange"/>
   </xsl:template>
   <xsl:template match="listBibl/bibl">
      <xsl:call-template name="transformOrRemoveBibl"/>
   </xsl:template>
   <xsl:template match="note/bibl">
      <xsl:call-template name="transformOrRemoveBibl"/>
   </xsl:template>
   <xsl:template match="@key[not(parent::country)]">
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
