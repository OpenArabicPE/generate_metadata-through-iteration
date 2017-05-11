<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:kml="http://earth.google.com/kml/2.0"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:till="http://www.sitzextase.de"
    >
    <xsl:output method="xml" version="1.0" xpath-default-namespace="http://www.thirdstreetsoftware.com/SenteXML-1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"  name="xml"/>
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"  name="text"/>
    
    <!-- This stylesheet builds the applescript to download the PDFs of Servet-i Fünun from the Millikütüphane in Ankara -->
    <!-- This stylesheet covers various steps in the process:
        a) using html as input it produces an applescript for downloading all the PDFs and the corresponding Sente XML
        b) using the Sente XML from a) and another Sente XML ($pDocBiblData) with automatically generated bibliographic metadata, the stylesheet unites these two into one Sente XML with full bibliographic information and links to the downloaded PDFs
        Problem in b): fields cannot be overwritten by XML import into Sente and custom fields, once filled, even if empty, cannot be updated through XML import -->

    <!-- as the import engine is extremely bugy or rather as duplicate detection is a bit over ambitious, I have to introduce individual article titles to get all references imported. I used the unique call-numbers for this purpose -->
    <!-- provides citations, date, and currency conversion -->
    <xsl:include href="/BachUni/projekte/XML/Functions/BachFunctions v3.xsl"/>
    <xsl:include href="/BachUni/projekte/XML/Html2Sente/applescript v1.xsl"/>
    <xsl:variable name="vgDate" select="current-date()"/>
    
    <xsl:param name="pDocBiblData" select="document('/BachUni/BachSources/servet-i funun/MetaData/Servet v16-31.Sente.xml')"/>
    
    <!-- dealing with HTML input -->
    <xsl:template match="html:html">
        <!--<xsl:result-document href="ServetDownload  {format-date($vgDate,'[Y01][M01][D01]')}.scpt" method="text">
            <xsl:call-template name="tAppleScript">
                <xsl:with-param name="pTargetFolder"
                    select="'/BachUni/BachSources/servet-i funun/Ankara PDFs'"/>
                <xsl:with-param name="pUrlBase" select="''"/>
                <xsl:with-param name="pUrlDoc">
                    <xsl:for-each select=".//html:div[@class='yazi']//html:li/html:span/html:a">
                        <xsl:value-of select="concat('&quot;',@href,'&quot;')"/>
                        <xsl:if test="position()!= last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:with-param>
                <xsl:with-param name="pID">
                    <xsl:for-each select=".//html:div[@class='yazi']//html:li/html:span/html:a">
                        <xsl:variable name="vFileName">
                            <xsl:analyze-string select="@href" regex="/(\d+)(.pdf)">
                                <xsl:matching-substring>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:variable>
                        <xsl:value-of select="concat('&quot;',$vFileName,'&quot;')"/>
                        <xsl:if test="position()!= last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:result-document>-->
        <xsl:result-document href="ServetAnkara2Sente {format-date($vgDate,'[Y01][M01][D01]')}.xml" method="xml">
            <xsl:element name="tss:senteContainer">
                <xsl:attribute name="version">1.0</xsl:attribute>
                <xsl:attribute name="xsi:schemaLocation">http://www.thirdstreetsoftware.com/SenteXML-1.0 SenteXML.xsd</xsl:attribute>
                <xsl:element name="tss:library">
                    <xsl:element name="tss:references">
                        <xsl:apply-templates select=".//html:div[@class='yazi']//html:li"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
  
  <!-- list items with references to PDFs -->
    <xsl:template match="html:li[ancestor::html:div[@class='yazi']][descendant::html:span/html:a]">
        <xsl:variable name="vDetailUrl">
            <xsl:value-of select="'http://gazeteler.ankara.edu.tr/'"/>
            <xsl:value-of select="./html:a/@href" disable-output-escaping="yes"/>
        </xsl:variable>
        
        <xsl:variable name="vItemInfo" select="./html:span"/>
        <xsl:variable name="vUrl" select="$vItemInfo/html:a/@href"/>
        <xsl:variable name="vItemNo">
            <xsl:analyze-string select="$vUrl" regex="/(\d+)(.pdf)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="vCilt" select="$vItemInfo/html:b[2]"/>
        <!--<xsl:variable name="vSayi" select="$vItemInfo/html:b[3]"/>-->
        <xsl:variable name="vTarih" select="$vItemInfo/html:b[4]"/>
        <xsl:variable name="vSayi" select="number(tokenize($vTarih,'-')[1])"/>
        <xsl:variable name="vMonthNo">
            <xsl:call-template name="funcDateMonthNameNumber">
                <xsl:with-param name="pMode" select="'number'"/>
                <xsl:with-param name="pLang">
                    <xsl:choose>
                        <xsl:when test="$vSayi > 1800">
                            <xsl:value-of select="'GTrFull'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'MTrFull'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="pMonth" select="$vCilt"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="vDate">
            <xsl:choose>
                <xsl:when test="$vSayi > 1800">
                    <xsl:value-of select="concat($vSayi,'-',$vMonthNo,'-01')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="funcDateM2G">
                        <xsl:with-param name="pDateM">
                            <xsl:value-of select="concat($vSayi,'-',$vMonthNo,'-01')"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="tss:reference">
            <xsl:element name="tss:publicationType">
                <xsl:attribute name="name">Archival Periodical</xsl:attribute>
            </xsl:element>
            <xsl:element name="tss:dates">
                <xsl:element name="tss:date">
                    <xsl:attribute name="type">Publication</xsl:attribute>
                    <xsl:attribute name="year" select="tokenize($vDate,'-')[1]"/>
                    <xsl:attribute name="month" select="tokenize($vDate,'-')[2]"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tss:characteristics">
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">articleTitle</xsl:attribute>
                    <xsl:value-of select="$vItemNo"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">publicationTitle</xsl:attribute>
                    <xsl:value-of select="'Servet-i Fünūn'"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Short Titel</xsl:attribute>
                    <xsl:value-of select="'Servet-i Fünūn'"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">language</xsl:attribute>
                    <xsl:value-of select="'Ottoman Turkish'"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">publicationCountry</xsl:attribute>
                    <xsl:value-of select="'Der-i Saʿadet'"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">publisher</xsl:attribute>
                    <xsl:value-of select="'Ālem Maṭbaʿasi'"/>
                </xsl:element>
                <xsl:if test="$vSayi &lt; 1800">
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Rumi</xsl:attribute>
                        <xsl:call-template name="funcDateMonthNameNumber">
                            <xsl:with-param name="pMode" select="'name'"/>
                            <xsl:with-param name="pMonth" select="$vMonthNo"/>
                            <xsl:with-param name="pLang" select="'mijmes'"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$vSayi"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Repository</xsl:attribute>
                    <xsl:value-of select="'MKA'"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Standort</xsl:attribute>
                    <xsl:value-of select="'Milli Kütüphane, Ankara'"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">OCLCID</xsl:attribute>
                    <xsl:value-of select="'6298921'"/>
                </xsl:element>
                <!--<xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Signatur</xsl:attribute>
                    <xsl:value-of select="''"/>
                </xsl:element>-->
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">Citation identifier</xsl:attribute>
                    <xsl:value-of select="concat('servet-mka ',$vItemNo)"/>
                </xsl:element>
                <xsl:element name="tss:characteristic">
                    <xsl:attribute name="name">URL</xsl:attribute>
                    <xsl:value-of select="$vUrl"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tss:attachments">
                <xsl:element name="tss:attachmentReference">
                    <xsl:element name="name">
                        <xsl:text>PDF</xsl:text>
                    </xsl:element>
                    <xsl:element name="URL">
                        <xsl:value-of select="concat('file:///BachUni/BachSources/servet-i%20funun/Ankara%20PDFs/',$vItemNo,'.pdf')"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tss:attachmentReference">
                    <xsl:element name="name">
                        <xsl:text>Detail page</xsl:text>
                    </xsl:element>
                    <xsl:element name="URL">
                        <xsl:value-of select="$vDetailUrl"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!--<xsl:element name="tss:attachments">
                    <xsl:call-template name="tIncrementUrl1">
                        <xsl:with-param name="pNumStart" select="./img"/>
                        <xsl:with-param name="pNumStop" select="./img + $pgPages - 1"/>
                    </xsl:call-template>
                </xsl:element>-->
            <xsl:element name="tss:keywords">
                <xsl:element name="tss:keyword">
                    <xsl:attribute name="assigner">Sente User Sebastian</xsl:attribute>
                    <xsl:text>Source</xsl:text>
                </xsl:element>
                <xsl:element name="tss:keyword">
                    <xsl:attribute name="assigner">Sente User Sebastian</xsl:attribute>
                    <xsl:text>newspaper/periodical</xsl:text>
                </xsl:element>
                <xsl:element name="tss:keyword">
                    <xsl:attribute name="assigner">Sente User Sebastian</xsl:attribute>
                    <xsl:text>weekly</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
  </xsl:template>
  
    <!-- list items without references to PDFs -->
    <xsl:template match="html:li[ancestor::html:div[@class='yazi']][not(descendant::html:span/html:a)]">
       <xsl:element name="till:error">
           <xsl:copy-of select="./html:a"/>
           <xsl:copy-of select="./html:span"/>
       </xsl:element> 
    </xsl:template>
    
    <!-- update existing Sente exports: sort the SenteXML -->
    <xsl:template match="tss:senteContainer">
        <xsl:result-document href="{ substring-before(base-uri(),'.')} updated.Sente.xml">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="mCopy"/>
        </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="mCopy">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="mCopy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tss:references" mode="mCopy">
        <xsl:copy>
            <xsl:apply-templates select="./tss:reference" mode="mBibl">
                <xsl:sort select="tss:dates/tss:date[@type='Publication']/@year"/>
                <xsl:sort select="tss:dates/tss:date[@type='Publication']/@month"/>
                <xsl:sort select="tss:characteristics/tss:characteristic[@name='articleTitle']"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <!-- integrate bibliographic data, especially automatically generated dates from $pDocBiblData -->
    <xsl:template match="tss:reference" mode="mBibl">
        <xsl:variable name="vVol" select=".//tss:characteristic[@name='volume']"/>
        <xsl:variable name="vRefBibl" select="$pDocBiblData//tss:reference[.//tss:characteristic[@name='volume']=$vVol]"/>
        <xsl:copy>
            <xsl:apply-templates select="./tss:publicationType" mode="mCopy"/>
            <xsl:element name="tss:dates">
                <xsl:copy-of select="$vRefBibl//tss:date[@type='Publication']"/>
                <xsl:copy-of select=".//tss:date[@type='Entry']"/>
                <xsl:copy-of select=".//tss:date[@type='Modification']"/>
            </xsl:element>
            <xsl:element name="tss:characteristics">
                <xsl:apply-templates select=".//tss:characteristic[not(@name='Date Rumi')][not(@name='issue')][not(@name='pages')]" mode="mCopy"/>
                <xsl:copy-of select="$vRefBibl//tss:characteristic[@name='Date Rumi']"/>
                <xsl:copy-of select="$vRefBibl//tss:characteristic[@name='issue']"/>
                <xsl:copy-of select="$vRefBibl//tss:characteristic[@name='pages']"/>
            </xsl:element>
            <xsl:apply-templates select="./tss:attachments" mode="mCopy"/>
            <xsl:apply-templates select="./tss:keywords" mode="mCopy"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>