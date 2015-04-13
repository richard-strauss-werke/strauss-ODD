<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rsw="http://richard-strauss-ausgabe.de/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="rsw xs tei functx">

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
	<xsl:variable name="changeTypes" select="/null"/>
	<xsl:variable name="sexes" select="/null"/>
	<xsl:variable name="keywords" select="/null"/>
	<xsl:variable name="rswDocumentPrefix"/>
	<xsl:variable name="rswStaffPrefix"/>
	

	<!-- named templates -->

	<xsl:template name="processHandNote">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|*[node()]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="processNotesStmt">
		<xsl:variable name="content">
			<xsl:apply-templates select="node()"/>
		</xsl:variable>
		<xsl:if test="normalize-space($content)">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*"/>
				<xsl:copy-of select="$content"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- In the RSW 'production' TEI files for organizations, listEvent is allowed as a child of org, which is not valid according to TEI 2.8. ListEvent might be added in a future release of the TEI guidelines, see http://sourceforge.net/p/tei/feature-requests/366/ - in this stylesheet, listEvent gets wrapped in a note element if there's an ancestor org, so the resulting documents are valid against 2.8.  -->
	<xsl:template name="processListEvent">
		<xsl:variable name="content">
			<xsl:call-template name="keepOnlyWithAnyAttOrAnyText"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$content and ancestor::org">
				<note>
					<xsl:copy-of copy-namespaces="no" select="$content"/>
				</note>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of copy-namespaces="no" select="$content"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="perOrgRoot">
		<xsl:copy copy-namespaces="no">
			<xsl:attribute name="xml:id">
				<xsl:value-of select="$docID"/>
			</xsl:attribute>
			<xsl:apply-templates select="@*[not(name()='xml:id')]|node()[local-name()!='note']|comment()|processing-instruction()|text()"/>
			<xsl:apply-templates select="note"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="keepOnlyWithAnyText">
		<xsl:if test="normalize-space()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAnyAttOrAnyText">
		<xsl:if test=".//@* or normalize-space()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithContent">
		<xsl:if test="node()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAtt">
		<xsl:if test="@*">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAttOrContent">
		<xsl:if test="@*|node()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithAttOrChildContent">
		<xsl:if test="@*|*/node()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithChildAttOrChildContent">
		<xsl:if test="*/@*|*/node()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithChildAttOrAnyText">
		<xsl:if test="./*/@* or normalize-space()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="keepOnlyWithGrandChildContent">
		<xsl:if test="*/*/node()">
			<xsl:copy copy-namespaces="no">
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
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*"/>
				<xsl:value-of select="rsw:formatDateNode(.)"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandOrRemoveOrigPlace">
		<xsl:if test="node()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
				<xsl:value-of select="rsw:certString(.)"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="onlyWithContentAddCert">
		<xsl:if test="node()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
				<xsl:if test="parent::change">
					<xsl:value-of select="rsw:certString(.)"/>
				</xsl:if>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandOrRemoveSexElement">
		<xsl:if test="@*">
			<xsl:copy-of copy-namespaces="no" select="$sexes/*[@value=current()/@value]"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processImprint">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>
			<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="local-name()='date'">
							<xsl:copy copy-namespaces="no">
								<xsl:apply-templates select="@*"/>
								<xsl:value-of select="rsw:formatDateNode(.)"/>
							</xsl:copy>
						</xsl:when>
						<xsl:when test="node()">
							<xsl:copy copy-namespaces="no">
								<xsl:apply-templates select="@*|node()"/>
							</xsl:copy>
						</xsl:when>
					</xsl:choose>
				
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>


	<xsl:template name="addTermRef">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of copy-namespaces="no" select="$keywords//text()[.=current()]/../@ref"/>
			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<!-- TODO flatten in source files: remove parent there -->
	<xsl:template name="tightenCommentary">
		<!-- note/@type="commentary" -->
		<xsl:for-each select="*">
			<xsl:if test="normalize-space()">
				<note type="commentary">
					<!-- child notes -->
					<xsl:for-each select="rs">
						<xsl:call-template name="processRs"/>
					</xsl:for-each>
					<xsl:for-each select="p">
						<xsl:if test="normalize-space()">
							<xsl:copy copy-namespaces="no">
								<!-- rs or p -->
								<xsl:apply-templates select="@*|node()"/>
							</xsl:copy>
						</xsl:if>
					</xsl:for-each>
				</note>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="transformOrRemoveBibl">
		<xsl:if test=".//@* or normalize-space()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()[normalize-space()]"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>



	<!-- TODO dies noch ins ODD einbetten, eleganter machen + noch verbinden mit erstem Paragraphen! -->
	<xsl:template name="processRevisionDescChange">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>

			<xsl:choose>
				<xsl:when test="@type">
					<p>
						<xsl:apply-templates select="*[1]/@*"/>
						
						<xsl:value-of select="$changeTypes/*[@type=current()/@type]/text()"/>
						<xsl:if test="*/node()">
							<xsl:text>: </xsl:text>
							<xsl:apply-templates select="*[1]/node()"/>
						</xsl:if> 
					</p>
					<xsl:apply-templates select="*[not(position()=1)][node()]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*[node()]"/>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:copy>
	</xsl:template>

	<!-- temporary; TODO change encoding practice + add settlement keys, country etc -->
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
					<xsl:element name="repository">
						<xsl:apply-templates select="$el/@*|$el/node()"/>
					</xsl:element>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:if>
	</xsl:template>

	<xsl:template name="expandTitleStmtMs">
		<xsl:copy copy-namespaces="no">
			<title>
				<xsl:for-each select="//change[parent::listChange]">
					<xsl:if test="position() ne 1">
						<xsl:text> </xsl:text>
						<lb/>
					</xsl:if>
					<xsl:call-template name="processCreationChange"/>
				</xsl:for-each>
			</title>
			<xsl:for-each select="//@role[.='creator'][ancestor::listChange][../node()]/..">
				<author>
					<xsl:apply-templates select="@key|node()"/>
					<xsl:value-of select="rsw:certString(./..)"/>
				</author>
			</xsl:for-each>
			<xsl:apply-templates select="respStmt"/>
			<xsl:copy-of copy-namespaces="no" select="$funder"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandTitleStmtGraphic">
		<xsl:variable name="summary">
			<xsl:for-each select="//notesStmt/note[@type='summary']">
				<xsl:call-template name="keepOnlyWithChildAttOrChildContent"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="changes">
			<xsl:for-each select="//change[parent::listChange]">
				<xsl:if test="position() ne 1">
					<xsl:text> </xsl:text>
					<lb/>
				</xsl:if>
				<xsl:call-template name="processCreationChange"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:copy copy-namespaces="no">
			<xsl:element name="title">
				<xsl:if test="$summary">
					<xsl:value-of select="normalize-space(string($summary))"/>
				</xsl:if>
				<xsl:if test="$summary and $changes/text()[normalize-space()][following::lb]">
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:copy-of copy-namespaces="no" select="$changes"/>
			</xsl:element>
			<xsl:for-each select="//@role[.='creator'][ancestor::listChange][../node()]/..">
				<author>
					<xsl:apply-templates select="@key|node()"/>
					<xsl:value-of select="rsw:certString(./..)"/>
				</author>
			</xsl:for-each>
			<xsl:apply-templates select="respStmt"/>
			<xsl:copy-of copy-namespaces="no" select="$funder"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandTitleStmtPrint">
		<xsl:copy copy-namespaces="no">
			
			<xsl:variable name="firstBiblStructChild" select="//biblStruct/*[1]"/>
			<xsl:variable name="titles">
				<xsl:apply-templates select="$firstBiblStructChild/title[not(@type='short')]"/>	
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="normalize-space($titles)">
					<xsl:copy-of select="$titles"/>
				</xsl:when>
				<xsl:otherwise>
					<title>
						<xsl:comment> Titel muss noch ergänzt werden. </xsl:comment>
					</title>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="$firstBiblStructChild/author"/>
			<xsl:apply-templates select="$firstBiblStructChild/editor"/>
			

			<xsl:apply-templates select="respStmt"/>
			<xsl:copy-of copy-namespaces="no" select="$funder"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandTitleStmtEvent">
		<xsl:copy copy-namespaces="no">
			<xsl:element name="title">
				<xsl:comment>TODO Title statement event</xsl:comment>
			</xsl:element>
			<xsl:apply-templates select="respStmt"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="replaceTextByGraphic">
		<xsl:element name="facsimile">
			<xsl:element name="graphic">
				<xsl:attribute name="url">
					<xsl:value-of select="(//ptr[@type='image'])[1]/@target"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="expandPublicationStmt">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of copy-namespaces="no" select="$publicationStmt"/>
			<xsl:if test="$docID">
				<idno type="RSW">
					<xsl:value-of select="$docID"/>
				</idno>
			</xsl:if>
			<xsl:apply-templates select="idno"/>
		</xsl:copy>
		<xsl:copy-of copy-namespaces="no" select="$seriesStmt"/>
	</xsl:template>


	<xsl:template name="addPrefixDef">
		<listPrefixDef>
			<prefixDef ident="{$rswDocumentPrefix}" matchPattern="([a-z][0-9]+)" replacementPattern="http://richard-strauss-ausgabe.de/documents/view/$1">
				<p>Private URIs, die das Präfix <code><xsl:value-of select="$rswDocumentPrefix"/></code>
			     verwenden, verweisen auf XML-Dokumente des RSW-Projekts.
			     <code><xsl:value-of select="$rswDocumentPrefix"/>:p10000</code> verweist beispielsweise auf <code>http://richard-strauss-ausgabe.de/documents/view/p10000</code>.</p>
			</prefixDef>
			<prefixDef ident="{$rswStaffPrefix}" matchPattern="([a-z]+)" replacementPattern="http://richard-strauss-ausgabe.de/staff.xml#$1">
				<p>Private URIs, die das Präfix <code><xsl:value-of select="$rswStaffPrefix"/></code>
			     verwenden, verweisen auf <gi>person</gi>-Elemente
			     in der Datei "staff.xml".
			     <code><xsl:value-of select="$rswStaffPrefix"/>:mmm</code> verweist beispielsweise auf <code>http://richard-strauss-ausgabe.de/staff.xml#mmm</code>.</p>
			</prefixDef>
		</listPrefixDef>
	</xsl:template>
	
	<xsl:template name="expandEncodingDesc">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>
			<xsl:call-template name="addPrefixDef"/>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandEditorialDecl">
		<xsl:copy copy-namespaces="no">
			<p><xsl:copy-of select="$guidelinesTitleRef" copy-namespaces="no"/></p>
			<xsl:if test="normalize-space()">
				<p><xsl:value-of select="$specificFeaturesTitle"/></p>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandRespStmt">
		<xsl:variable name="whoResp" select="//@who|//@resp"/>
		<xsl:choose>
			<xsl:when test="name/@ref">
				<respStmt>
					<xsl:copy-of copy-namespaces="no" select="resp"/>
					<xsl:for-each select="name[@ref]">
						<xsl:copy copy-namespaces="no">
							<xsl:copy-of copy-namespaces="no" select="@*"/>
							<xsl:value-of select="$staff/*[@ref=current()/@ref]/text()"/>
						</xsl:copy>
					</xsl:for-each>
				</respStmt>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Name der Herausgeber muss noch zur Publikation ergänzt werden.</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$whoResp">
			<respStmt>
				<resp>
					<xsl:value-of select="$contributorsResp"/>
				</resp>
				<xsl:for-each select="distinct-values($whoResp)">
					<xsl:copy-of copy-namespaces="no" select="$staff/*[@ref=current()]"/>
				</xsl:for-each>
			</respStmt>
		</xsl:if>
	</xsl:template>

	<xsl:template name="transformRespons">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*[not(name()='rsw:when')]"/>
			<desc>
				<date when="{@rsw:when}"/>
			</desc>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="processPhysDesc">
		<xsl:if test="normalize-space()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="node()[node()]"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processOpenerWP">
		<xsl:param name="typedSegsI" tunnel="yes"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
			<xsl:if test="$typedSegsI">
				<xsl:for-each select="$typedSegsI">
					<salute rend="inparagraph">
						<xsl:apply-templates select="@*[not(name()='type')]|node()"/>
					</salute>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="processCloserWP">
		<xsl:param name="typedSegsC" tunnel="yes"/>
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>
			<xsl:if test="$typedSegsC">
				<xsl:for-each select="$typedSegsC">
					<salute rend="inparagraph">
						<xsl:apply-templates select="@*[not(name()='type')]|node()"/>
					</salute>
				</xsl:for-each>
			</xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- adds the content of seg[@type] in new opener/closer elements -->
	<xsl:template name="processDiv">
		<xsl:variable name="this" select="."/>
		<xsl:choose>
			<xsl:when test=".//seg[@type]">
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*"/>

					<xsl:for-each select="node()">
						<xsl:variable name="typedSegsI" select=".//seg[@type='initial-salute']"/>
						<xsl:variable name="typedSegsC" select=".//seg[@type='concluding-salute']"/>

						<xsl:if test="not($this/opener) and $typedSegsI">
							<opener>
									<xsl:for-each select="$typedSegsI">
										<salute rend="inparagraph">
										<xsl:apply-templates select="@*[not(name()='type')]|node()"/>
									</salute>
									</xsl:for-each>
								</opener>
						</xsl:if>

						<xsl:choose>
							<xsl:when test="./name()='opener' and $this//seg[@type='initial-salute']">
								<xsl:call-template name="processOpenerWP">
									<xsl:with-param name="typedSegsI" select="$this//seg[@type='initial-salute']" tunnel="yes"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="./name()='closer' and $this//seg[@type='concluding-salute']">
								<xsl:call-template name="processCloserWP">
									<xsl:with-param name="typedSegsC" select="$this//seg[@type='concluding-salute']" tunnel="yes"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="."/>
							</xsl:otherwise>
						</xsl:choose>


						<xsl:if test="not($this/closer) and $typedSegsC">
							<closer>
										<xsl:for-each select="$typedSegsC">
											<salute rend="inparagraph">
												<xsl:apply-templates select="@*[not(name()='type')]|node()"/>
											</salute>
										</xsl:for-each>
									</closer>
						</xsl:if>

					</xsl:for-each>

					<!--					
					<xsl:if test="$typedSegsI and not(.//opener)">
						<opener>
							<xsl:for-each select="$typedSegsI">
								<salute rend="inparagraph">
								<xsl:apply-templates select="@*[not(name()='type')]|node()"/>
							</salute>
							</xsl:for-each>
						</opener>
					</xsl:if>
					
					<xsl:apply-templates select="node()[not(name()='postscript')]">
						<xsl:with-param name="typedSegsI" select="$typedSegsI" tunnel="yes"/>
						<xsl:with-param name="typedSegsC" select="$typedSegsC" tunnel="yes"/>
					</xsl:apply-templates>
					
					<xsl:if test="$typedSegsC and not(.//closer)">
						<closer>
							<xsl:for-each select="$typedSegsC">
								<salute rend="inparagraph">
								<xsl:apply-templates select="@*[not(name()='type')]|node()"/>
							</salute>
							</xsl:for-each>
						</closer>
					</xsl:if>
					
					<xsl:apply-templates select="postscript"/>
-->
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="removeIfTyped">
		<xsl:if test="not(@type)">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- @rsw:pdf and @rsw:seitepdf only refer to internal files and get removed from the public version -->
	<xsl:template name="processRs">
		<xsl:if test="normalize-space()">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*[not(starts-with(name(), 'rsw:'))]"/>
				<xsl:if test="@rsw:seite">
					<xsl:attribute name="n">
						<xsl:value-of select="@rsw:seite"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processCreationChange">
		<xsl:variable name="firstPart">
			<xsl:variable name="creator">
				<xsl:for-each select="*[@role='creator'][element()|text()]">
					<xsl:if test="position() ne 1"> / </xsl:if>
					<xsl:copy copy-namespaces="no">
						<xsl:apply-templates select="@*[not(name()='role')]"/>
						<xsl:value-of select="rsw:reverseName(string())"/>
					</xsl:copy>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="//term/text()">
				<xsl:value-of select="//term/text()"/>
				<xsl:if test="normalize-space($creator)"> von </xsl:if>
			</xsl:if>
			<xsl:value-of select="$creator"/>
			<xsl:for-each select="*[@role='addressee'][element()|text()]">
				<xsl:choose>
					<xsl:when test="position()=1"> an </xsl:when>
					<xsl:otherwise> / </xsl:otherwise>
				</xsl:choose>
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@*[not(name()='role')]"/>
					<xsl:value-of select="rsw:reverseName(string())"/>
				</xsl:copy>
			</xsl:for-each>
			<xsl:for-each select="placeName[element()|text()]">
				<xsl:choose>
					<xsl:when test="position()=1"> in </xsl:when>
					<xsl:otherwise> / </xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="onlyWithContentAddCert"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="secondPart">
			<xsl:variable name="placesCreator">
				<xsl:for-each select="origPlace[@*|text()]">
					<xsl:if test="position() ne 1"> / </xsl:if>
					<xsl:call-template name="onlyWithContentAddCert"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="dates">
				<xsl:for-each select="origDate[@*|text()]">
					<xsl:if test="position() ne 1"> / </xsl:if>
					<xsl:value-of select="rsw:formatDateNode(.)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="normalize-space(string-join(($placesCreator[normalize-space()], $dates[normalize-space()]), ', '))"/>
		</xsl:variable>
		<xsl:value-of select="$firstPart"/>
		<xsl:if test="$secondPart">
			<xsl:text> </xsl:text>
			<lb/>
		</xsl:if>
		<xsl:value-of select="$secondPart"/>
	</xsl:template>





	<!-- functions -->

	<xsl:function name="rsw:reverseName" as="xs:string">
		<xsl:param name="str" as="xs:string"/>
		<xsl:value-of select="string-join(reverse(tokenize($str, ', ')), ' ')"/>
	</xsl:function>

	<xsl:function name="rsw:formatDateNode" as="xs:string*">
		<xsl:param name="date" as="node()?"/>
		<xsl:variable name="when" select="rsw:dateLong($date/@when, ())"/>
		<xsl:variable name="notBefore" select="rsw:dateLong($date/@notBefore, 'fr. ')"/>
		<xsl:variable name="notAfter" select="rsw:dateLong($date/@notAfter, 'sp. ')"/>
		<xsl:variable name="from" select="rsw:dateLong($date/@from, ())"/>
		<xsl:variable name="to" select="rsw:dateLong($date/@to, ())"/>
		<xsl:variable name="fromTo" select="if ($from or $to) then concat($from, '&#160;–', (if ($to) then ' ' else ()), $to) else ()"/>
		<xsl:variable name="dates">
			<xsl:value-of select="string-join(($when, $notBefore, $notAfter, $fromTo), ', ')"/>
		</xsl:variable>
		<xsl:if test="$date/text()">
			<xsl:value-of select="$date/text()"/>
			<xsl:value-of select="if ($dates) then ' ' else ()"/>
		</xsl:if>
		<xsl:value-of select="concat(rsw:precisionString($date), $dates, rsw:certString($date))"/>
	</xsl:function>


	<!-- modified functx function to work with earlier dates, too -->
	<xsl:function name="functx:day-of-week" as="xs:integer?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence select="    if (empty($date))    then ()    else xs:integer((xs:date($date) - xs:date('1801-01-06'))    div xs:dayTimeDuration('P1D')) mod 7    "/>
	</xsl:function>

	<!-- modified functx function with German dates -->
	<xsl:function name="functx:day-of-week-name-de" as="xs:string?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence select="('Dienstag', 'Mittwoch','Donnerstag', 'Freitag', 'Samstag','Sonntag', 'Montag')[functx:day-of-week($date)+1]"/>
	</xsl:function>

	<xsl:function name="rsw:dateLong" as="xs:string?">
		<xsl:param name="date" as="xs:string?"/>
		<xsl:param name="prefix" as="xs:string?"/>
		<xsl:if test="$date">
			<xsl:variable name="dateOnly">
				<xsl:choose>
					<xsl:when test="matches($date, '[\d]{4}-[\d]{2}-[\d]{2}')">
						<!-- replaced, since German dates don't work in eXist out of the box -->
						<!--<xsl:value-of select="format-date(xs:date($date), '[FNn], [D]. [MNn] [Y]', 'de', (), ())"/>-->
						<xsl:value-of select="concat(        functx:day-of-week-name-de($date), ', ', string(number(substring($date,9,2))), '. ',        ('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember')[xs:integer(substring($date,6,2))], ' ', substring($date,1,4))"/>
					</xsl:when>
					<xsl:when test="matches($date, '[\d]{4}-[\d]{2}')">
						<xsl:value-of select="concat(('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli',         'August', 'September', 'Oktober', 'November', 'Dezember')[xs:integer(substring($date,6,2))], ' ', substring($date,1,4))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$date"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="string-join(($prefix, $dateOnly), '')"/>
		</xsl:if>
	</xsl:function>

	<xsl:function name="rsw:precisionString" as="xs:string*">
		<xsl:param name="node" as="node()?"/>
		<xsl:value-of select="if (data($node/@precision)='medium') then 'ca. ' else ()"/>
	</xsl:function>

	<xsl:function name="rsw:certString" as="xs:string?">
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