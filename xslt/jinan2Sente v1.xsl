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
    
    <!-- This stylesheet builds Sente XML for scans of periodicals. It does not need html as input -->
   
    <!-- v1: production version; currently adapted to hadiqat -->
    <!-- as the import engine is extremely bugy or rather as duplicate detection is a bit over ambitious, I have to introduce individual article titles to get all references imported. I used the unique call-numbers for this purpose -->
    <!-- provides citations, date, and currency conversion -->
    <xsl:include href="/BachUni/projekte/XML/Functions/BachFunctions v3.xsl"/> 
    
    <xsl:variable name="vgDate" select="current-date()"/>
    
    <xsl:param name="pgStartDate" select="'1879-01-01'"/>
    <xsl:param name="pgStopDate" select="'1885-12-31'"/>
    <xsl:param name="pgStartImg" select="1"/>
    <xsl:param name="pgStartIssue" select="1"/>
    <xsl:param name="pgVolume" select="10"/>
    <xsl:param name="pgPages" select="32"/>
    <!-- sometimes the computation of Hijri dates is one day off from the local Hijrī -->
    <xsl:param name="pgDHCorrector" select="0"/>
    <!-- these two paramaters select the folder containing the image files -->
    <xsl:param name="pgUrlBase" select="'/BachUni/projekte/Damascus/sources damascus/'"/>
    <xsl:param name="pgUrlVar" select="'al-manar'"/>
    
    
    <!--<xsl:template match="*">
        <xsl:apply-templates mode="m4"/>
    </xsl:template>-->
    
    
    <xsl:template match="*">
        <xsl:result-document href="jinan2Sente {replace($pgStartDate,'-','')}-{replace($pgStopDate,'-','')} {format-date($vgDate,'[Y01][M01][D01]')}.xml" method="xml">
        <xsl:element name="tss:senteContainer">
            <xsl:attribute name="version">1.0</xsl:attribute>
            <xsl:attribute name="xsi:schemaLocation">http://www.thirdstreetsoftware.com/SenteXML-1.0 SenteXML.xsd</xsl:attribute>
            <xsl:element name="tss:library">
                <xsl:element name="tss:references">
                    <xsl:call-template name="tReferencesM4"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        </xsl:result-document>
    </xsl:template>
     
    <xsl:template name="tReferencesM4">
        <!-- for al-Hasna it must be monthly -->
        <xsl:variable name="vRefs">
            <xsl:call-template name="tIncrementFortnightly"/>
        </xsl:variable>
        <xsl:for-each select="$vRefs/issue">
            <xsl:element name="tss:reference">
                <xsl:element name="tss:publicationType">
                    <xsl:attribute name="name">Archival Periodical</xsl:attribute>
                </xsl:element>
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
                        <xsl:value-of select="./number"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publicationTitle</xsl:attribute>
                        <xsl:value-of select="'al-Jinān'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Short Titel</xsl:attribute>
                        <xsl:value-of select="'Jinān'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">volume</xsl:attribute>
                        <xsl:value-of select="./volume"/>
                        
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">issue</xsl:attribute>
                        <xsl:value-of select="./number"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">language</xsl:attribute>
                        <xsl:value-of select="'Arabic'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">pages</xsl:attribute>
                        <xsl:value-of select="./pages"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publicationCountry</xsl:attribute>
                        <xsl:value-of select="'Bayrūt'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publisher</xsl:attribute>
                        <xsl:value-of select="'Maṭbaʿa al-Maʿārif'"/>
                    </xsl:element>
                    <!--<xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Hijri</xsl:attribute>
                        <xsl:variable name="vDHijri">
                            <!-\- Suriye used a Hijri date date is sometimes one day ahead of the computed day based on the Rumu calendar -\->
                            <!-\- <xsl:call-template name="funcDateG2H">
                                <xsl:with-param name="pDateG" select="./date"/>
                            </xsl:call-template> -\->
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
                    </xsl:element>-->
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
                        <xsl:value-of select="'PUL'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Standort</xsl:attribute>
                        <xsl:value-of select="'Princeton'"/>
                    </xsl:element>
                   <!-- <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">call-num</xsl:attribute>
                        <xsl:value-of select="concat('EAP119/1/8/',$pgVolume)"/>
                    </xsl:element>-->
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Citation identifier</xsl:attribute>
                        <xsl:value-of select="concat('jinan ',./volume,'-',./number)"/>
                    </xsl:element>
                   <!-- <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">URL</xsl:attribute>
                        <xsl:value-of select="concat('http://eap.bl.uk/database/','overview_item.a4d?catId=892;r=11337')"/>
                    </xsl:element>-->
                </xsl:element>
                <!--<xsl:element name="tss:attachments">
                    <xsl:call-template name="tIncrementUrl2">
                        <xsl:with-param name="pNumStart" select="1"/>
                        <xsl:with-param name="pNumStop" select="$pgPages"/>
                        <xsl:with-param name="pDate" select="./date"/>
                    </xsl:call-template>
                </xsl:element>-->
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
                        <xsl:text>fortnightly</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
     <!--<xsl:template name="tIncrementUrl2">
        <xsl:param name="pNumStart"/>
        <xsl:param name="pNumStop"/>
         <xsl:param name="pDate"/>
        <xsl:variable name="vUrlImgBase">
            <xsl:value-of select="concat($pgUrlBase,$pgUrlVar,'/',substring(replace($pDate,'-',''),1,6),'_')"/>
        </xsl:variable>
        <xsl:element name="tss:attachmentReference">
            <!-\-<xsl:element name="name">
                <xsl:value-of select="concat('p',$pNumStart)"/>
            </xsl:element>-\->
            <xsl:element name="URL">
                <xsl:value-of select="concat($vUrlImgBase, format-number($pNumStart,'000'),'_L.jpg')"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="number($pNumStart) lt number($pNumStop)">
            <xsl:call-template name="tIncrementUrl2">
                <xsl:with-param name="pNumStart" select="$pNumStart + 1"/>
                <xsl:with-param name="pNumStop" select="$pNumStop"/>
                <xsl:with-param name="pDate" select="$pDate"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template> 
    <xsl:template name="tIncrementUrl1">
        <xsl:param name="pNumStart"/>
        <xsl:param name="pNumStop"/>
        <xsl:variable name="vUrlImgBase">
            <xsl:value-of select="concat($pgUrlBase,$pgUrlVar,'/HA-1_Page_')"/>
        </xsl:variable>
        <xsl:element name="tss:attachmentReference">
            <xsl:element name="name">
                <xsl:value-of select="concat('p',$pNumStart)"/>
            </xsl:element>
            <xsl:element name="URL">
                <xsl:value-of select="concat($vUrlImgBase, format-number($pNumStart,'000'),'_150dpi.jpg')"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="number($pNumStart) lt number($pNumStop)">
            <xsl:call-template name="tIncrementUrl1">
                <xsl:with-param name="pNumStart" select="$pNumStart + 1"/>
                <xsl:with-param name="pNumStop" select="$pNumStop"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>-->
    
  
    
    <xsl:template name="tIncrementFortnightly">
        <xsl:param name="pDate" select="$pgStartDate"/>
        <xsl:param name="pIssue" select="$pgStartIssue"/>
        <xsl:param name="pVolume" select="$pgVolume"/>
        <xsl:param name="pPages" select="1"/>
        <xsl:variable name="vDayInc">
            <xsl:choose>
                <xsl:when test="number(tokenize($pDate,'-')[3])=1">
                    <xsl:value-of select="'15'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'01'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vMonthInc">
            <!-- only increments if the day is 15 or higher -->
            <xsl:choose>
                <xsl:when test="number(tokenize($pDate,'-')[3]) &gt;=15">
                    <xsl:value-of select="number(tokenize($pDate,'-')[2]) + 1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number(tokenize($pDate,'-')[2])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vDateInc">
            <xsl:choose>
                <xsl:when test="$vMonthInc &lt;= 12">
                    <xsl:value-of select="concat(tokenize($pDate,'-')[1],'-',format-number($vMonthInc,'00'),'-',$vDayInc)"/>
                </xsl:when>
                <!-- this only kicks in for January -->
                <xsl:otherwise>
                    <xsl:value-of select="concat(number(tokenize($pDate,'-')[1])+1,'-',format-number($vMonthInc -12,'00'),'-',$vDayInc)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vIssueInc">
            <!--<xsl:value-of select="if($pIssue&lt;24) then($pIssue + 1) else(1)"/>-->
            <xsl:choose>
                <xsl:when test="$pIssue&lt;24">
                    <xsl:value-of select="$pIssue +1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vVolumeInc">
            <!--<xsl:value-of select="if($vIssueInc=1) then($pVolume +1) else($pVolume)"/>-->
            <xsl:choose>
                <xsl:when test="$vIssueInc=1">
                    <xsl:value-of select="$pVolume +1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pVolume"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vPagesStart">
            <!--<xsl:value-of select="if($pIssue=1) then(1) else($pPages)"/>-->
            <xsl:choose>
                <xsl:when test="$pIssue=1">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pPages"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:element name="issue">
            <xsl:element name="date">
                <xsl:value-of select="$pDate"/>
            </xsl:element>
            <xsl:element name="number">
                <xsl:value-of select="$pIssue"/>
            </xsl:element>
            <xsl:element name="volume">
                <xsl:value-of select="$pVolume"/>
            </xsl:element>
            <xsl:element name="pages">
                <xsl:value-of select="$vPagesStart"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="$vPagesStart + $pgPages -1"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="$vDateInc lt $pgStopDate">
            <xsl:call-template name="tIncrementFortnightly">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue" select="$vIssueInc"/>
                <xsl:with-param name="pVolume" select="$vVolumeInc"/>
                <xsl:with-param name="pPages" select="$vPagesStart + $pgPages"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>