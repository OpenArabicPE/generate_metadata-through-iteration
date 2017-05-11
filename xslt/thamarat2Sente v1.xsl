<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:kml="http://earth.google.com/kml/2.0"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    >
    <xsl:output method="xml" version="1.0" xpath-default-namespace="http://www.thirdstreetsoftware.com/SenteXML-1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"  name="xml"/>
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"  name="text"/>
    
    <!-- This stylesheet builds Sente XML for the scans of Thamarāt. It does not need html as input -->
   
    <!-- v1: production version -->
    <!-- as the import engine is extremely bugy or rather as duplicate detection is a bit over ambitious, I have to introduce individual article titles to get all references imported. I used the unique call-numbers for this purpose -->
    <!-- provides citations, date, and currency conversion -->
    <xsl:include href="/BachUni/projekte/XML/Functions/BachFunctions v2d.xsl"/> 
    
    <xsl:variable name="vgDate" select="current-date()"/>
    
    <xsl:param name="pgStartDate" select="'1892-10-31'"/>
    <xsl:param name="pgStopDate" select="'1892-11-1'"/>
    <xsl:param name="pgStartIssue" select="902"/>
    <xsl:param name="pgStartImg" select="191"/>
    <!-- for serialised novels etc. -->
    <xsl:param name="pgStartSection" select="40"/>
    <xsl:param name="pgPages" select="4"/>
    <!-- these two paramaters select the folder containing the image files -->
    <xsl:param name="pgUrlBase" select="'/BachUni/projekte/Damascus/sources damascus/thamarat al-funun/CDs/'"/>
    <xsl:param name="pgUrlVar" select="'Images/150dpi'"/>
    <!-- sometimes the computation of Hijri dates is one day off from the local Hijrī -->
    <xsl:param name="pgDHCorrector" select="0"/>
    
    
    <xsl:template match="*">
        <xsl:apply-templates mode="m4"/>
    </xsl:template>
    
    
    <xsl:template match="*" mode="m4">
        <xsl:result-document href="thamarat2Sente {replace($pgStartDate,'-','')}-{replace($pgStopDate,'-','')} {format-date($vgDate,'[Y01][M01][D01]')}.xml" method="xml">
        <xsl:element name="tss:senteContainer">
            <xsl:attribute name="version">1.0</xsl:attribute>
            <xsl:attribute name="xsi:schemaLocation">http://www.thirdstreetsoftware.com/SenteXML-1.0 SenteXML.xsd</xsl:attribute>
            <xsl:element name="tss:library">
                <xsl:element name="tss:references">
                    <xsl:call-template name="tReferencesM4"/><!-- this is the line to trigger m1, m3, m4 -->
                </xsl:element>
            </xsl:element>
        </xsl:element>
        </xsl:result-document>
    </xsl:template>
     
    <xsl:template name="tReferencesM4">
        <xsl:variable name="vRefs">
            <xsl:call-template name="tIncrementWeekly"/>
        </xsl:variable>
        <!--<xsl:variable name="vSection">
            <xsl:call-template name="funcNumbersIncrement">
                <xsl:with-param name="pStart" select="1"/>
                <xsl:with-param name="pStep" select="1"/>
                <xsl:with-param name="pStop" select="count($vRefs/issue)"/>
            </xsl:call-template>
        </xsl:variable>-->
        <xsl:for-each select="$vRefs/issue">
            <xsl:element name="tss:reference">
                <xsl:element name="tss:publicationType">
                    <xsl:attribute name="name">Archival Periodical</xsl:attribute>
                </xsl:element>
                <tss:authors>
                    <tss:author role="Author">
                        <tss:surname>ʿAliyyah</tss:surname>
                        <tss:forenames>Fāṭima</tss:forenames>
                        <tss:initials></tss:initials>
                    </tss:author>
                </tss:authors>
                <xsl:element name="tss:dates">
                    <xsl:element name="tss:date">
                        <xsl:attribute name="type">Publication</xsl:attribute>
                        <xsl:attribute name="day">
                            <xsl:value-of select="tokenize(normalize-space(./date),'-')[3]"/>
                        </xsl:attribute>
                        <xsl:attribute name="month">
                            <xsl:value-of select="tokenize(normalize-space(./date),'-')[2]"/>
                        </xsl:attribute>
                        <xsl:attribute name="year">
                            <xsl:value-of select="tokenize(normalize-space(./date),'-')[1]"/>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="tss:date">
                        <xsl:attribute name="type">Retrieval</xsl:attribute>
                        <xsl:attribute name="day">
                            <xsl:value-of select="format-date($vgDate,'[D01]')"/>
                        </xsl:attribute>
                        <xsl:attribute name="month">
                            <xsl:value-of select="format-date($vgDate,'[M01]')"/>
                        </xsl:attribute>
                        <xsl:attribute name="year">
                            <xsl:value-of select="format-date($vgDate,'[Y0001]')"/>
                        </xsl:attribute>
                    </xsl:element>

                </xsl:element>
                <xsl:element name="tss:characteristics">
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">articleTitle</xsl:attribute>
                        <xsl:variable name="vSection">
                           <xsl:value-of select="count(preceding-sibling::issue)+$pgStartSection"/>
                        </xsl:variable>
                        <!--<xsl:value-of select="./number"/>-->
                        <xsl:value-of select="concat('nisāʾ al-muslimīn [',$vSection,']')"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publicationTitle</xsl:attribute>
                        <xsl:value-of select="'Thamarāt al-Funūn'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Short Titel</xsl:attribute>
                        <xsl:value-of select="'Thamarāt'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">volume</xsl:attribute>
                        <xsl:value-of select="./number"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">language</xsl:attribute>
                        <xsl:value-of select="'Arabic'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">pages</xsl:attribute>
                        <xsl:value-of select="concat('1-',$pgPages)"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publicationCountry</xsl:attribute>
                        <xsl:value-of select="'Bayrūt'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publisher</xsl:attribute>
                        <xsl:value-of select="'Jamʿiyyat al-Funūn'"/>
                    </xsl:element>
                    <!--<xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">abstractText</xsl:attribute>
                        <xsl:value-of select="$vAbstract"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Signatur</xsl:attribute>
                        <xsl:value-of select="$vBoaID"/>
                    </xsl:element> -->
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Hijri</xsl:attribute>
                        <xsl:variable name="vDHijri">
                            <!-- Suriye used a Hijri date date is sometimes one day ahead of the computed day based on the Rumu calendar -->
                            <!-- <xsl:call-template name="funcDateG2H">
                                <xsl:with-param name="pDateG" select="./date"/>
                            </xsl:call-template> -->
                            <xsl:variable name="vJDay">
                                <xsl:call-template name="funcDateG2JD">
                                    <xsl:with-param name="pDateG" select="./date"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:call-template name="funcDateJD2H">
                                <xsl:with-param name="pJD" select="$vJDay + $pgDHCorrector"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat(format-number(number(tokenize($vDHijri,'-')[3]),'0'),' ')"/>
                        <xsl:call-template name="funcDateMonthName-Num">
                            <xsl:with-param name="pDate" select="$vDHijri"/>
                            <xsl:with-param name="pLang" select="'HIjmes'"/>
                        </xsl:call-template>
                        <xsl:value-of select="concat(' ',tokenize($vDHijri,'-')[1])"/>
                    </xsl:element>
                    <!--<xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Rumi</xsl:attribute>
                        <xsl:variable name="vDRumi">
                            <xsl:call-template name="funcDateG2R">
                                <xsl:with-param name="pDateG" select="./date"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat(format-number(number(tokenize($vDRumi,'-')[3]),'0'),' ')"/>
                        <xsl:call-template name="funcDateMonthName-Num">
                            <xsl:with-param name="pDate" select="$vDRumi"/>
                            <xsl:with-param name="pLang" select="'RIjmes'"/>
                        </xsl:call-template>
                        <xsl:value-of select="concat(' ',tokenize($vDRumi,'-')[1])"/>
                        
                    </xsl:element>-->
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Repository</xsl:attribute>
                        <xsl:value-of select="'OIB'"/>
                    </xsl:element>
                    <!-- <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Web data source</xsl:attribute>
                        <xsl:text>devletarsivleri.gov.tr</xsl:text>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Hijri</xsl:attribute>
                        <xsl:value-of select="$vBoaDateHic"/>
                    </xsl:element> -->
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Citation identifier</xsl:attribute>
                        <xsl:value-of select="concat('tf-oib ',./number,'a')"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tss:attachments">
                    <xsl:call-template name="tIncrementUrl">
                        <xsl:with-param name="pNumStart" select="./img"/>
                        <xsl:with-param name="pNumStop" select="./img + $pgPages - 1"/>
                    </xsl:call-template>
                </xsl:element>
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
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="tIncrementUrl">
        <xsl:param name="pNumStart"/>
        <xsl:param name="pNumStop"/>
        <xsl:variable name="vUrlImgBase">
            <xsl:value-of select="concat($pgUrlBase,$pgUrlVar,'/TF-',substring($pgStartDate,1,4),'-')"/>
        </xsl:variable>
        <xsl:value-of select="$pNumStop"/>
        <xsl:element name="tss:attachmentReference">
            <xsl:element name="URL">
                <xsl:value-of select="concat($vUrlImgBase, format-number($pNumStart,'0000'),'_150dpi.jpg')"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="number($pNumStart) lt number($pNumStop)">
            <xsl:call-template name="tIncrementUrl">
                <xsl:with-param name="pNumStart" select="$pNumStart + 1"/>
                <xsl:with-param name="pNumStop" select="$pNumStop"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template name="tIncrementWeekly">
        <xsl:param name="pDate" select="$pgStartDate"/>
        <xsl:param name="pIssue" select="$pgStartIssue"/>
        <xsl:param name="pImgUrl" select="$pgStartImg"/>
        <xsl:variable name="vDateJD">
            <xsl:call-template name="funcDateG2JD">
                <xsl:with-param name="pDateG" select="$pDate"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="vDateInc">
            <xsl:call-template name="funcDateJD2G">
                <xsl:with-param name="pJD" select="$vDateJD + 7"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="vIssueInc">
            <xsl:value-of select="$pIssue + 1"/>
        </xsl:variable>
        <xsl:element name="issue">
            <xsl:element name="date">
                <xsl:value-of select="$pDate"/>
            </xsl:element>
            <xsl:element name="number">
                <xsl:value-of select="$pIssue"/>
            </xsl:element>
            <xsl:element name="img">
                <xsl:value-of select="$pImgUrl"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="$vDateInc lt $pgStopDate">
            <xsl:call-template name="tIncrementWeekly">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue" select="$pIssue + 1"/>
                <xsl:with-param name="pImgUrl" select="$pImgUrl + $pgPages"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
  
</xsl:stylesheet>