<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:XSL="http://www.w3.org/1999/XSL/TransformAlias"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rng="http://relaxng.org/ns/structure/1.0"
	exclude-result-prefixes="rng" version="2.0">

	<!-- xslt version of the original xquery script, adjusted to tei-c usage; alpha -->
	
	<!-- currently only supports the correspondence and persons schemata -->


	<xsl:key name="macro-parents" match="elementSpec/@ident|rng:element[not(.//rng:element)]/@name"
		use="..//rng:ref/@name"/>

	<xsl:variable name="xmlDocsUrl">
		<xsl:value-of select="id('xmlDocsUrl')/@target"/>
	</xsl:variable>

	<xsl:output method="xml" indent="yes" encoding="utf-8"/>

	<xsl:namespace-alias stylesheet-prefix="XSL" result-prefix="xsl"/>


	<xsl:template match="/">
		<XSL:stylesheet version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
			xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:rsga="http://richard-strauss-ausgabe.de/ns/1.0">

			<xsl:for-each select="distinct-values(//equiv/@filter)">
				<XSL:import href="{.}"/>
			</xsl:for-each>

			<XSL:param name="docIDParam" required="no"/>

			<XSL:output method="xml" indent="no" encoding="utf-8"/>

			<XSL:strip-space
				elements="{normalize-space('
				additional additions address analytic app availability 
				biblStruct body 
				castList choice cit creation 
				div 
				editionStmt editorialDecl encodingDesc epigraph event 
				facsimile figure fileDesc floatingText front 
				graphic 
				handDesc handNote 
				imprint index 
				lg listBibl listChange listEvent 
				monogr msDesc msIdentifier 
				notatedMusic notesStmt 
				objectDesc org 
				performance person physDesc postscript profileDesc projectDesc publicationStmt 
				relatedItem respons respStmt revisionDesc row 
				seriesStmt sourceDesc sp space state subst supportDesc 
				table teiHeader text textClass titleStmt
				')}"/>
			
			<XSL:key name="who" match="//@who" use="."/>

			<!-- get document ID from uri or from the docIDParam; the latter is necessary 
				because base-uri() doesn't currently work in eXist -->
			<XSL:variable name="docID" select="
				if (base-uri()) then
				replace(base-uri(), '^(.*/)?(.*)\..*$','$2')
				else $docIDParam
			"/>

			<!-- content from the ODD to be added to the processed TEI files: -->
			<XSL:variable name="guidelinesTitleRef">
				<xsl:copy-of select="id('guidelinesTitleRef')/node()" copy-namespaces="no"/>
			</XSL:variable>
			<XSL:variable name="specificFeaturesTitle">
				<xsl:copy-of select="id('specificFeaturesTitle')/node()" copy-namespaces="no"/>
			</XSL:variable>
			<XSL:variable name="funder">
				<xsl:copy-of select="//funder" copy-namespaces="no"
					extension-element-prefixes="#default"/>
			</XSL:variable>
			<XSL:variable name="contributorsResp">
				<xsl:value-of select="id('contributorsResp')"/>
			</XSL:variable>
			<XSL:variable name="staff">
				<xsl:for-each select="//@ident[.='data.encoding-staff']/..//rng:value">
					<name xml:id="{text()}">
						<xsl:value-of select="following-sibling::*[1]"/>
					</name>
				</xsl:for-each>
			</XSL:variable>
			<XSL:variable name="publicationStmt">
				<xsl:copy-of select="//publicationStmt/node()" copy-namespaces="no"
					extension-element-prefixes="#default"/>
			</XSL:variable>
			<XSL:variable name="seriesStmt">
				<xsl:copy-of select="//seriesStmt" copy-namespaces="no"
					extension-element-prefixes="#default"/>
			</XSL:variable>
			<XSL:variable name="edition">
				<xsl:value-of select="//edition"/>
			</XSL:variable>
			<XSL:variable name="sexes">
				<xsl:for-each select="//valItem[ancestor::elementSpec/equiv//@name='expandOrRemoveSex']">
					<sex value="{@ident}">
						<xsl:value-of select="gloss[@xml:lang='de']"/>
					</sex>
				</xsl:for-each>
				<!-- maintain a node datatype even if there are no matches: -->
				<empty/>
			</XSL:variable>
			<XSL:variable name="keywords">
				<xsl:for-each select="//@ident[.=('data.keyword_ms', 'data.keyword_print')]/..//rng:value">
					<term>
						<xsl:if test="following-sibling::*[1]/text()">
							<!-- only insert keywords with documentation -->
							<xsl:attribute name="ref">
								<xsl:value-of select="following-sibling::*[1]"/>
							</xsl:attribute>
							<xsl:value-of select="."/>
						</xsl:if>
					</term>
				</xsl:for-each>
				<!-- maintain a node datatype even if there are no matches: -->
				<empty/>
			</XSL:variable>


			<XSL:template match="@*|node()|comment()|processing-instruction()|text()" priority="-2">
				<XSL:copy>
					<XSL:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
				</XSL:copy>
			</XSL:template>

			<XSL:template match="/processing-instruction()" priority="100"/>

			<!-- write document id to root xml:id -->
			<XSL:template match="/*" priority="-1">
				<XSL:copy>
					<XSL:attribute name="xml:id">
						<XSL:value-of select="$docID"/>
					</XSL:attribute>
					<XSL:apply-templates
						select="@*[not(name()='xml:id')]|node()|comment()|processing-instruction()|text()"
					/>
				</XSL:copy>
			</XSL:template>

			<xsl:for-each select="//equiv[@filter]">
				<xsl:variable name="name" select="@name"/>
				<xsl:variable name="macroSpec" select="ancestor::macroSpec"/>
				<xsl:choose>
					<xsl:when test="$macroSpec">
						<xsl:variable name="firstElement" select="($macroSpec//(rng:element|rng:ref))[1]"/>
						<xsl:variable name="firstAttribute" select="($firstElement/rng:attribute)[1]"/>
						<xsl:variable name="firstAttributeValue" select="($firstAttribute//rng:value)[1]"/>
						<xsl:for-each select="key('macro-parents', $macroSpec/@ident)">
							<XSL:template>
								<xsl:attribute name="match">
									<xsl:value-of select="."/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$firstElement/@name"/>
									<xsl:if test="$firstAttribute">
										<xsl:text>[@</xsl:text>
										<xsl:value-of select="$firstAttribute/@name"/>
										<xsl:if test="$firstAttributeValue">
											<xsl:text>='</xsl:text>
											<xsl:value-of select="$firstAttributeValue"/>
											<xsl:text>'</xsl:text>
										</xsl:if>
										<xsl:text>]</xsl:text>
									</xsl:if>
								</xsl:attribute>
								<XSL:call-template name="{$name}"/>
							</XSL:template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<XSL:template>
							<xsl:attribute name="match">
								<xsl:variable name="ns" select="ancestor::elementSpec/@ns"/>
								<xsl:value-of
									select="if ($ns='http://richard-strauss-ausgabe.de/ns/1.0') then 'rsga:' else ()"/>
								<xsl:value-of select="ancestor::elementSpec/@ident"/>
							</xsl:attribute>
							<XSL:call-template name="{@name}"/>
						</XSL:template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<!-- convert all keys to refs -->
			<XSL:template match="@key">
				<XSL:attribute name="ref">
					<xsl:value-of select="$xmlDocsUrl"/>
					<XSL:value-of select="."/>
				</XSL:attribute>
			</XSL:template>

			<!-- clean up -->
			<!-- remove tabs -->
			<XSL:template match="change/text()|div/text()"/>

			<!-- temporary (TODO: change encoding practice) -->
			<XSL:template match="@who|@resp|@new">
				<XSL:attribute><xsl:attribute name="name">{name()}</xsl:attribute>#<XSL:value-of
					select="."/></XSL:attribute>
			</XSL:template>

			<!-- removed here; transformed to a "certainty" element when processing the parent "rs" element -->
			<XSL:template match="rsga:cert"/>

			<XSL:template match="@change">
				<XSL:attribute name="change">#change-<XSL:value-of select="."/></XSL:attribute>
			</XSL:template>

		</XSL:stylesheet>

	</xsl:template>

</xsl:stylesheet>