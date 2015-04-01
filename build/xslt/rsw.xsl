<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rsga="http://richard-strauss-ausgabe.de/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="rsga xs tei functx">

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
	<xsl:variable name="keywords" select="/null"/>


	<!-- named templates -->

	<xsl:template name="perOrgRoot">
		<xsl:copy>
			<xsl:attribute name="xml:id">
				<xsl:value-of select="$docID"/>
			</xsl:attribute>
			<xsl:apply-templates
				select="@*[not(name()='xml:id')]|node()[local-name()!='note']|comment()|processing-instruction()|text()"/>
			<xsl:apply-templates select="note"/>
		</xsl:copy>
	</xsl:template>

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

	<xsl:template name="expandOrRemoveSexElement">
		<xsl:if test="@*">
			<xsl:copy-of select="$sexes/*[@value=current()/@value]"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processImprint">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="local-name()='date'">
							<xsl:copy>
								<xsl:apply-templates select="@*"/>
								<xsl:value-of select="rsga:formatDateNode(.)"/>
							</xsl:copy>
						</xsl:when>
						<xsl:when test="node()">
							<xsl:copy>
								<xsl:apply-templates select="@*|node()"/>
							</xsl:copy>
						</xsl:when>
					</xsl:choose>
				
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>


	<xsl:template name="addTermRef">
		<xsl:copy>
			<xsl:copy-of select="$keywords//text()[.=current()]/../@ref"/>
			<xsl:value-of select="."/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="tightenCommentary">
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<!-- note/@type="commentary" -->
				<xsl:apply-templates select="@*"/>
				<xsl:for-each select="node()">
					<xsl:if test="normalize-space()">
						<xsl:copy>
							<!-- child notes -->
							<xsl:for-each select="rs">
								<xsl:call-template name="processRs"/>
							</xsl:for-each>
							<xsl:for-each select="p">
								<xsl:if test="normalize-space()">
									<xsl:copy>
										<!-- rs or p -->
										<xsl:apply-templates select="@*|node()"/>
									</xsl:copy>
								</xsl:if>
							</xsl:for-each>
						</xsl:copy>
					</xsl:if>
				</xsl:for-each>
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


	<!-- TODO dies noch ins ODD einbetten, eleganter machen + noch verbinden mit erstem Paragraphen! -->
	<xsl:template name="processRevisionDescChange">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>

			<xsl:choose>
				<xsl:when test="@type">
					<p>
						<xsl:apply-templates select="element()[1]/@*"/>
					<xsl:choose>
						<xsl:when test="@type='UO'">Übertragung nach Original </xsl:when>
						<xsl:when test="@type='UC'">Übertragung nach Entwurf </xsl:when>
						<xsl:when test="@type='UA'">Übertragung nach Abschrift v.f.H. </xsl:when>
						<xsl:when test="@type='UP'">Übertragung nach Xerokopie </xsl:when>
						<xsl:when test="@type='UI'">Übertragung nach Mikroform </xsl:when>
						<xsl:when test="@type='UM'">Übertragung nach autogr. Abschrift </xsl:when>
						<xsl:when test="@type='UD'">Übertragung nach Original [Digitalisat] </xsl:when>
						<xsl:when test="@type='UG'">Übertragung nach Entwurf [Digitalisat] </xsl:when>
						<xsl:when test="@type='UH'">Übertragung nach Abschrift v.f.H. [Digitalisat] </xsl:when>
						<xsl:when test="@type='UF'">Übertragung nach Xerokopie [Digitalisat] </xsl:when>
						<xsl:when test="@type='UJ'">Übertragung nach Mikroform [Digitalisat] </xsl:when>
						<xsl:when test="@type='UB'"
							>Übertragung nach autogr. Abschrift [Digitalisat] </xsl:when>
						<xsl:when test="@type='UE'">Übertragung nach Edition </xsl:when>
						<xsl:when test="@type='UZ'">Übertragung nach Auszug </xsl:when>
						<xsl:when test="@type='UW'">Übertragung </xsl:when>
						<xsl:when test="@type='KO'">Korrektur nach Original </xsl:when>
						<xsl:when test="@type='KC'">Korrektur nach Entwurf </xsl:when>
						<xsl:when test="@type='KA'">Korrektur nach Abschrift v.f.H. </xsl:when>
						<xsl:when test="@type='KP'">Korrektur nach Xerokopie </xsl:when>
						<xsl:when test="@type='KI'">Korrektur nach Mikroform </xsl:when>
						<xsl:when test="@type='KM'">Korrektur nach autogr. Abschrift </xsl:when>
						<xsl:when test="@type='KD'">Korrektur nach Original [Digitalisat] </xsl:when>
						<xsl:when test="@type='KG'">Korrektur nach Entwurf [Digitalisat] </xsl:when>
						<xsl:when test="@type='KH'">Korrektur nach Abschrift v.f.H. [Digitalisat] </xsl:when>
						<xsl:when test="@type='KF'">Korrektur nach Xerokopie [Digitalisat] </xsl:when>
						<xsl:when test="@type='KJ'">Korrektur nach Mikroform [Digitalisat] </xsl:when>
						<xsl:when test="@type='KB'">Korrektur nach autogr. Abschrift [Digitalisat] </xsl:when>
						<xsl:when test="@type='KE'">Korrektur nach Edition </xsl:when>
						<xsl:when test="@type='KZ'">Korrektur nach Auszug </xsl:when>
						<xsl:when test="@type='KW'">Korrektur </xsl:when>
						<xsl:when test="@type='VQ'"
							>, Vollständigkeit der Quellenübertragung bestätigt</xsl:when>
						<xsl:when test="@type='VT'">Vollständigkeit der Textauszeichnung bestätigt </xsl:when>
						<xsl:when test="@type='VL'">Vollständigkeit der Verlinkung bestätigt </xsl:when>
						<xsl:when test="@type='P'">vorgeschlagen zur Publikation </xsl:when>
						<xsl:when test="@type='C'"
							>als möglicherweise publikationsfertig gekennzeichnet </xsl:when>
						<xsl:when test="@type='A'">zur Publikation freigegeben </xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
						<xsl:apply-templates select="element()[1]/node()"/>
					</p>
					<xsl:apply-templates select="element()[not(position()=1)][node()]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="element()[node()]"/>
				</xsl:otherwise>
			</xsl:choose>

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

	<xsl:template name="expandTitleStmtMs">
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
			<xsl:for-each select="//@role[.='creator'][ancestor::listChange][../node()]/..">
				<author>
					<xsl:apply-templates select="@key|node()"/>
					<xsl:value-of select="rsga:certString(./..)"/>
				</author>
			</xsl:for-each>
			<xsl:copy-of select="$funder"/>
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
		<xsl:copy>
			<xsl:element name="title">
				<xsl:if test="$summary">
					<xsl:value-of select="normalize-space(string($summary))"/>
				</xsl:if>
				<xsl:if test="$summary and $changes/text()[normalize-space()][following::lb]">
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:copy-of select="$changes"/>
			</xsl:element>
			<xsl:for-each select="//@role[.='creator'][ancestor::listChange][../node()]/..">
				<author>
					<xsl:apply-templates select="@key|node()"/>
					<xsl:value-of select="rsga:certString(./..)"/>
				</author>
			</xsl:for-each>
			<xsl:copy-of select="$funder"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandTitleStmtPrint">
		<xsl:copy>
			<title>
				<xsl:copy-of
					select="(//biblStruct//title[@type='main'])[1]/node()|@*[not(name()='type')]"/>
			</title>

			<xsl:copy-of select="//biblStruct/element()[1]//author|editor"/>


			<xsl:copy-of select="$funder"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="expandTitleStmtEvent">
		<xsl:copy>
			<xsl:element name="title">
				<xsl:comment>TODO Title statement event</xsl:comment>
			</xsl:element>
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


	<xsl:template name="expandEdition">
		<xsl:choose>
			<xsl:when test="parent::editionStmt">
				<xsl:copy>
					<xsl:value-of select="$edition"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="keepOnlyWithAnyText"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="expandPublicationStmt">
		<xsl:copy>
			<xsl:copy-of select="$publicationStmt"/>
			<xsl:if test="$docID">
				<idno type="RSW">
					<xsl:value-of select="$docID"/>
				</idno>
			</xsl:if>
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
		<xsl:variable name="whoResp" select="//@who|//@resp"/>
		<xsl:if test="$whoResp">
			<xsl:copy>
				<resp>
					<xsl:value-of select="$contributorsResp"/>
				</resp>
				<xsl:for-each select="distinct-values($whoResp)">
					<xsl:variable name="who" select="."/>
					<xsl:copy-of select="$staff/id($who)"/>
				</xsl:for-each>
			</xsl:copy>
		</xsl:if>
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

	<xsl:template name="processOpenerWP">
		<xsl:param name="typedSegsI" tunnel="yes"/>
		<xsl:copy>
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
		<xsl:copy>
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
				<xsl:copy>
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
									<xsl:with-param name="typedSegsI"
										select="$this//seg[@type='initial-salute']" tunnel="yes"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="./name()='closer' and $this//seg[@type='concluding-salute']">
								<xsl:call-template name="processCloserWP">
									<xsl:with-param name="typedSegsC"
										select="$this//seg[@type='concluding-salute']" tunnel="yes"/>
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
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="removeIfTyped">
		<xsl:if test="not(@type)">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- @rsga:pdf and @rsga:seitepdf only refer to internal files and get removed from the public version -->
	<xsl:template name="processRs">
		<xsl:if test="normalize-space()">
			<xsl:copy>
				<xsl:apply-templates select="@*[not(starts-with(name(), 'rsga:'))]"/>
				<xsl:if test="@rsga:seite">
					<xsl:attribute name="n">
						<xsl:value-of select="@rsga:seite"/>
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
					<xsl:copy>
						<xsl:apply-templates select="@*[not(name()='role')]"/>
						<xsl:value-of select="rsga:reverseName(string())"/>
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
				<xsl:copy>
					<xsl:apply-templates select="@*[not(name()='role')]"/>
					<xsl:value-of select="rsga:reverseName(string())"/>
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
					<xsl:value-of select="rsga:formatDateNode(.)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of
				select="normalize-space(string-join(($placesCreator[normalize-space()], $dates[normalize-space()]), ', '))"
			/>
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
		<xsl:variable name="from" select="rsga:dateLong($date/@from, ())"/>
		<xsl:variable name="to" select="rsga:dateLong($date/@to, ())"/>
		<xsl:variable name="fromTo"
			select="if ($from or $to) then concat($from, '&#160;–', (if ($to) then ' ' else ()), $to) else ()"/>
		<xsl:variable name="dates">
			<xsl:value-of select="string-join(($when, $notBefore, $notAfter, $fromTo), ', ')"/>
		</xsl:variable>
		<xsl:if test="$date/text()">
			<xsl:value-of select="$date/text()"/>
			<xsl:value-of select="if ($dates) then ' ' else ()"/>
		</xsl:if>
		<xsl:value-of select="concat(rsga:precisionString($date), $dates, rsga:certString($date))"/>
	</xsl:function>


	<!-- modified functx function to work with earlier dates, too -->
	<xsl:function name="functx:day-of-week" as="xs:integer?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence
			select="
			if (empty($date))
			then ()
			else xs:integer((xs:date($date) - xs:date('1801-01-06'))
			div xs:dayTimeDuration('P1D')) mod 7
			"
		/>
	</xsl:function>

	<!-- modified functx function with German dates -->
	<xsl:function name="functx:day-of-week-name-de" as="xs:string?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence
			select="('Dienstag', 'Mittwoch','Donnerstag', 'Freitag', 'Samstag','Sonntag', 'Montag')[functx:day-of-week($date)+1]"
		/>
	</xsl:function>

	<xsl:function name="rsga:dateLong" as="xs:string?">
		<xsl:param name="date" as="xs:string?"/>
		<xsl:param name="prefix" as="xs:string?"/>
		<xsl:if test="$date">
			<xsl:variable name="dateOnly">
				<xsl:choose>
					<xsl:when test="matches($date, '[\d]{4}-[\d]{2}-[\d]{2}')">
						<!-- replaced, since German dates don't work in eXist out of the box -->
						<!--<xsl:value-of select="format-date(xs:date($date), '[FNn], [D]. [MNn] [Y]', 'de', (), ())"/>-->
						<xsl:value-of
							select="concat(
							functx:day-of-week-name-de($date), ', ', substring($date,9,2), '. ',        ('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember')[xs:integer(substring($date,6,2))], ' ', substring($date,1,4))"
						/>
					</xsl:when>
					<xsl:when test="matches($date, '[\d]{4}-[\d]{2}')">
						<xsl:value-of
							select="concat(('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli',         'August', 'September', 'Oktober', 'November', 'Dezember')[xs:integer(substring($date,6,2))], ' ', substring($date,1,4))"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$date"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="string-join(($prefix, $dateOnly), '')"/>
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