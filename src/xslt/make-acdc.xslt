<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:XSL="http://www.w3.org/1999/XSL/TransformAlias"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rng="http://relaxng.org/ns/structure/1.0"
	exclude-result-prefixes="rng" version="2.0">

	<xsl:key name="macro-parents" match="elementSpec/@ident|rng:element[not(.//rng:element)]/@name"
		use="..//rng:ref/@name"/>

	<xsl:variable name="common" select="document('../odd/common.xml')"/>

	<xsl:output method="xml" indent="yes" encoding="utf-8"/>

	<xsl:namespace-alias stylesheet-prefix="XSL" result-prefix="xsl"/>


	<xsl:template match="/">
		<XSL:stylesheet version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
			xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:rsw="http://richard-strauss-ausgabe.de/ns/1.0">

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
				editorialDecl encodingDesc epigraph event 
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

			<XSL:variable name="rswDocumentPrefix">
				<xsl:value-of select="$common/id('rswDocumentPrefix')"/>
			</XSL:variable>
			
			<XSL:variable name="rswStaffPrefix">
				<xsl:value-of select="$common/id('rswStaffPrefix')"/>
			</XSL:variable>
			
			<!-- content from the ODD to be added to the processed TEI files: -->
			<XSL:variable name="guidelinesTitleRef">
				<xsl:copy-of copy-namespaces="no" select="$common/id('guidelinesTitleRef')/node()"/>
			</XSL:variable>
			<XSL:variable name="specificFeaturesTitle">
				<xsl:copy-of copy-namespaces="no" select="$common/id('specificFeaturesTitle')/node()"/>
			</XSL:variable>
			<XSL:variable name="funder">
				<xsl:copy-of copy-namespaces="no" select="$common//funder"
					extension-element-prefixes="#default"/>
			</XSL:variable>
			<XSL:variable name="contributorsResp">
				<xsl:value-of select="$common/id('contributorsResp')"/>
			</XSL:variable>
			<XSL:variable name="publicationStmt">
				<xsl:copy-of select="$common//publicationStmt/node()" copy-namespaces="no"
					extension-element-prefixes="#default"/>
			</XSL:variable>
			<XSL:variable name="seriesStmt">
				<xsl:copy-of select="$common//seriesStmt" copy-namespaces="no"
					extension-element-prefixes="#default"/>
			</XSL:variable>
			<XSL:variable name="edition">
				<xsl:value-of select="$common//edition"/>
			</XSL:variable>
			<XSL:variable name="staff">
				<xsl:for-each select="//@ident[.='data.encoding-staff']/..//rng:value">
					<name ref="{text()}">
						<xsl:value-of select="following-sibling::*[1]"/>
					</name>
				</xsl:for-each>
				<!-- maintain a node datatype even if there are no matches: -->
				<empty/>
			</XSL:variable>
			<XSL:variable name="sexes">
				<xsl:for-each select="//valItem[ancestor::elementSpec/equiv//@name='expandOrRemoveSexElement']">
					<sex value="{@ident}">
						<xsl:value-of select="gloss[@xml:lang='de']"/>
					</sex>
				</xsl:for-each>
				<!-- maintain a node datatype even if there are no matches: -->
				<empty/>
			</XSL:variable>
			
			<XSL:variable name="changeTypes">
				<xsl:for-each select="//@ident[.='data.revisionDescChangeType']/..//rng:value">
					<change type="{.}">
						<xsl:value-of select="following-sibling::*[1]/text()"/>
					</change>
				</xsl:for-each>
				<!-- maintain a node datatype even if there are no matches: -->
				<empty/>
			</XSL:variable>
			
			<XSL:variable name="keywords">
				<xsl:for-each select="//@ident[.=('data.keyword_corresp', 'data.keyword_graphic', 'data.keyword_print')]/..//rng:value">
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
				<XSL:copy copy-namespaces="no">
					<XSL:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
				</XSL:copy>
			</XSL:template>

			<XSL:template match="/processing-instruction()" priority="100"/>

			<!-- write document id to root xml:id -->
			<XSL:template match="/*" priority="-1">
				<XSL:copy copy-namespaces="no">
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
									select="if ($ns='http://richard-strauss-ausgabe.de/ns/1.0') then 'rsw:' else ()"/>
								<xsl:value-of select="ancestor::elementSpec/@ident"/>
							</xsl:attribute>
							<XSL:call-template name="{@name}"/>
						</XSL:template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<!-- convert all keys (except on <country>) to refs -->
			<XSL:template match="@key[not(parent::country)]">
				<XSL:if test="normalize-space()">
					<XSL:attribute name="ref">
						<XSL:value-of select="concat($rswDocumentPrefix, ':', .)"/>
					</XSL:attribute>
				</XSL:if>
			</XSL:template>
			
			<!-- add prefix to scribeRef -->
			<XSL:template match="@scribeRef">
				<XSL:if test="normalize-space()">
					<XSL:copy copy-namespaces="no">
						<XSL:value-of select="concat($rswDocumentPrefix, ':', .)"/>
					</XSL:copy>
				</XSL:if>
			</XSL:template>
			
			<!-- clean up -->
			<!-- remove tabs -->
			<XSL:template match="change/text()|div/text()"/>


		</XSL:stylesheet>

	</xsl:template>

</xsl:stylesheet>
