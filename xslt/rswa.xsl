<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:rsga="http://richard-strauss-ausgabe.de/ns/1.0"
	exclude-result-prefixes="rsga xs tei">

	<!-- xslt version of the original xquery script, adjusted to tei-c usage; alpha -->


	<!-- overridden in import -->
	<xsl:variable name="docID" select="/null"/>
	<xsl:variable name="staff" select="/null"/>
	<xsl:variable name="contributorsResp" select="/null"/>
	<xsl:variable name="funder" select="/null"/>
	<xsl:variable name="publicationStmt" select="/null"/>
	<xsl:variable name="seriesStmt" select="/null"/>
	<xsl:variable name="edition" select="/null"/>
	<xsl:variable name="guidelinesTitleRef" select="/null"/>
	<xsl:variable name="specificFeaturesTitle" select="/null"/>
	<xsl:variable name="sexes" select="/null"/>


	<!-- named templates -->

	<xsl:template name="keepOnlyWithAnyText">
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAnyAttOrAnyText">
		<xsl:if test=".//@* or normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithContent">
		<xsl:if test="node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAtt">
		<xsl:if test="@*">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAttOrContent">
		<xsl:if test="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAttOrChildContent">
		<xsl:if test="@*|*/node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithChildAttOrChildContent">
		<xsl:if test="*/@*|*/node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithChildAttOrAnyText">
		<xsl:if test="./*/@* or normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithGrandChildContent">
		<xsl:if test="*/*/node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="warnIfHasChildOrRemove">
		<xsl:if test="node()">
			<xsl:comment>Der Datensatz ist nicht publikationsfertig, da noch Aufgaben eingetragen sind.</xsl:comment>
		</xsl:if>
	</xsl:template>


	<xsl:template name="expandOrRemoveDate">
		<xsl:if test="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:value-of select="rsga:formatDateNode(.)"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandOrRemoveOrigPlace">
		<xsl:if test="node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
				<xsl:value-of select="rsga:certString(.)"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="onlyWithContentAddCert">
		<xsl:if test="node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
				<xsl:if test="parent::change">
					<xsl:value-of select="rsga:certString(.)"/>
				</xsl:if>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandOrRemoveSex">
		<xsl:if test="@*">
			<xsl:copy-of select="$sexes/*[@value=current()/@value]"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="wrapTextClassContentOrRemove">
		<xsl:if test="node()">
			<xsl:copy>
				<keywords>
					<term>
						<xsl:apply-templates select="@*|node()"/>
					</term>
				</keywords>
			</xsl:copy>
		</xsl:if>
	</xsl:template>


	<!-- TODO: the matching of the items within the commentary and bibl elements is currently not part of the the odd, but only takes place here in the xslt -> change later. -->
	<xsl:template name="tightenCommentary">
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:for-each select="node()">
					<xsl:if test="normalize-space()">
						<xsl:copy>
							<xsl:apply-templates select="@*"/>
							<xsl:for-each select="node()">
								<xsl:if test="normalize-space()">
									<xsl:copy>
										<xsl:apply-templates select="@*|node()"/>
									</xsl:copy>
								</xsl:if>
							</xsl:for-each>
						</xsl:copy>
					</xsl:if>
				</xsl:for-each>
				<xsl:apply-templates select="node()" mode="commentaryBibl"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="transformOrRemoveBibl">
		<xsl:if test=".//@* or normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()[normalize-space()]"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processCreationChangeMs">
		<xsl:copy>
			<xsl:attribute name="xml:id">change-<xsl:value-of select="count(preceding-sibling::*) + 1"
				/></xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="processRevisionDescChange">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()[node()]"/>
		</xsl:copy>
	</xsl:template>

	<!-- temporary; TODO change encoding practice -->
	<xsl:template name="transformOrRemoveRepository">
		<xsl:if test="normalize-space()">
			<xsl:variable name="el" select="."/>
			<xsl:analyze-string select="." regex="^(.*)\s\((.*)\)">
				<xsl:matching-substring>
					<xsl:element name="settlement">
						<xsl:value-of select="regex-group(2)"/>
					</xsl:element>
					<xsl:element name="repository">
						<xsl:apply-templates select="$el/@*"/>
						<xsl:value-of select="regex-group(1)"/>
					</xsl:element>
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:copy-of select="$el"/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandTitleStmt">
		<xsl:copy>
			<title>
				<xsl:for-each select="//change[parent::listChange]">
					<xsl:if test="position() ne 1">
						<xsl:text> </xsl:text>
						<lb/>
					</xsl:if>
					<xsl:call-template name="processCreationChange"/>
				</xsl:for-each>
			</title>
			<xsl:for-each select="//@role[.='creator'][ancestor::listChange]/..">
				<author>
					<xsl:apply-templates select="@key|node()"/>
					<xsl:value-of select="rsga:certString(.)"/>
				</author>
			</xsl:for-each>
			<xsl:copy-of select="$funder"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandEdition">
		<xsl:copy>
			<xsl:value-of select="$edition"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandPublicationStmt">
		<xsl:copy>
			<xsl:copy-of select="$publicationStmt"/>
			<idno type="RSWA">
				<xsl:value-of select="$docID"/>
			</idno>
			<xsl:apply-templates select="idno"/>
		</xsl:copy>
		<xsl:copy-of select="$seriesStmt"/>
	</xsl:template>

	<xsl:template name="expandEditorialDecl">
		<xsl:copy>
			<p><xsl:value-of select="$guidelinesTitleRef"/></p>
			<xsl:if test="normalize-space()">
				<p><xsl:value-of select="$specificFeaturesTitle"/></p>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandRespStmt">
		<xsl:copy>
			<resp>
				<xsl:value-of select="$contributorsResp"/>
			</resp>
			<xsl:for-each select="distinct-values(//@who|//@resp)">
				<xsl:variable name="who" select="."/>
				<xsl:copy-of select="$staff/id($who)"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="transformRespons">
		<xsl:copy>
			<xsl:apply-templates select="@*[not(name()='rsga:when')]"/>
			<desc>
				<date when="{@rsga:when}"/>
			</desc>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="processPhysDesc">
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="node()[node()]"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- @rsga:pdf and @rsga:seitepdf only refer to internal files and will be removed from the public version -->
	<xsl:template name="processRs">
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:choose>
					<xsl:when test="@type=('lit','rez')">
						<xsl:if test="@rsga:seite">
							<xsl:attribute name="n">
								<xsl:value-of select="@rsga:seite"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="@*[not(starts-with(name(), 'rsga:'))]|node()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@*|node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processCreationChange">
		<xsl:variable name="firstPart">
			<xsl:for-each select="*[@role='creator']">
				<xsl:if test="position() ne 1"> / </xsl:if>
				<xsl:value-of select="rsga:reverseName(string())"/>
			</xsl:for-each>
			<xsl:for-each select="*[@role='addressee']">
				<xsl:choose>
					<xsl:when test="position()=1"> an </xsl:when>
					<xsl:otherwise> / </xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="rsga:reverseName(string())"/>
			</xsl:for-each>
			<xsl:for-each select="placeName">
				<xsl:choose>
					<xsl:when test="position()=1"> in </xsl:when>
					<xsl:otherwise> / </xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="onlyWithContentAddCert"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="secondPart">
			<xsl:variable name="placesCreator">
				<xsl:for-each select="origPlace">
					<xsl:if test="position() ne 1"> / </xsl:if>
					<xsl:call-template name="onlyWithContentAddCert"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="dates">
				<xsl:for-each select="origDate">
					<xsl:if test="position() ne 1"> / </xsl:if>
					<xsl:value-of select="rsga:formatDateNode(.)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="normalize-space(string-join(($placesCreator, $dates), ', '))"/>
		</xsl:variable>
		<xsl:value-of select="$firstPart"/>
		<xsl:if test="$secondPart">
			<xsl:text> </xsl:text>
			<lb/>
		</xsl:if>
		<xsl:value-of select="$secondPart"/>
	</xsl:template>





	<!-- functions -->

	<xsl:function name="rsga:reverseName" as="xs:string">
		<xsl:param name="str" as="xs:string"/>
		<xsl:value-of select="string-join(reverse(tokenize($str, ', ')), ' ')"/>
	</xsl:function>

	<xsl:function name="rsga:formatDateNode" as="xs:string*">
		<xsl:param name="date" as="node()?"/>
		<xsl:variable name="when" select="rsga:dateLong($date/@when, ())"/>
		<xsl:variable name="notBefore" select="rsga:dateLong($date/@notBefore, 'fr. ')"/>
		<xsl:variable name="notAfter" select="rsga:dateLong($date/@notAfter, 'sp. ')"/>
		<xsl:variable name="from" select="string-join(rsga:dateLong($date/@from, ()),'')"/>
		<xsl:variable name="to" select="string-join(rsga:dateLong($date/@to, ()),'')"/>
		<xsl:variable name="fromTo"
			select="if ($from or $to) then concat($from, '&#x00A0;–', (if ($to) then ' ' else ()), $to) else ()"/>
		<xsl:variable name="dates">
			<xsl:value-of select="string-join(($when, $notBefore, $notAfter, $fromTo), '')"/>
		</xsl:variable>
		<xsl:if test="$date/text()">
			<xsl:value-of select="$date/text()"/>
			<xsl:value-of select="if ($dates) then ' ' else ()"/>
		</xsl:if>
		<xsl:value-of select="concat(rsga:precisionString($date), $dates, rsga:certString($date))"/>
	</xsl:function>

	<xsl:function name="rsga:dateLong" as="xs:string*">
		<xsl:param name="date" as="xs:string?"/>
		<xsl:param name="prefix" as="xs:string?"/>
		<xsl:if test="$date">
			<xsl:value-of select="$prefix"/>
			<xsl:choose>
				<xsl:when test="matches($date, '[\d]{4}-[\d]{2}-[\d]{2}')">
					<xsl:value-of
						select="format-date(xs:date($date), '[FNn], [D]. [MNn] [Y]', 'de', (), ())"/>
				</xsl:when>
				<xsl:when test="matches($date, '[\d]{4}-[\d]{2}')">
					<xsl:value-of
						select="concat(('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 
						'August', 'September', 'Oktober', 'November', 'Dezember')[xs:integer(substring($date,6,2))], ' ', substring($date,1,4))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$date"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:function>

	<xsl:function name="rsga:precisionString" as="xs:string*">
		<xsl:param name="node" as="node()?"/>
		<xsl:value-of select="if (data($node/@precision)='medium') then 'ca. ' else ()"/>
	</xsl:function>

	<xsl:function name="rsga:certString" as="xs:string?">
		<xsl:param name="node" as="node()?"/>
		<xsl:variable name="cert">
			<xsl:value-of select="$node/@cert"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$cert='low'"> (fälschl.)</xsl:when>
			<xsl:when test="$cert='medium'"> (?)</xsl:when>
			<xsl:when test="$cert='high'"> (ws.)</xsl:when>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>

