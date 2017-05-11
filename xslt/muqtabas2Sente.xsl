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
    <xsl:include href="periodical2Sente-functions.xsl"/>
    
    <xsl:variable name="vgDate" select="current-date()"/>
    
    <xsl:param name="pPublicationTitle" select="'al-Muqtabas: Jarīdat Yawmiyya Siyāsiyya Iqtiṣādiyya Ijtimāʿiyya'"/>
    <xsl:param name="pShortTitle" select="'Jarīdat al-Muqtabas'"/>
    <xsl:param name="pCitId" select="'muqtabas'"/>
    <xsl:param name="pPublisher"/>
    <xsl:param name="pPublPlace" select="'Dimashq'"/>
    <xsl:param name="pgStartDate" select="'1915-07-01'"/>
    <xsl:param name="pgStopDate" select="'1915-12-32'"/>
    <xsl:param name="pgStartImg" select="1"/>
    <xsl:param name="pgStartIssue" select="1633"/>
    <xsl:param name="pgVolume" select="6"/>
    <xsl:param name="p_switch-vol-issue" select="true()"/>
    <xsl:param name="pgPages" select="2"/>
    <!-- sometimes the computation of Hijri dates is one day off from the local Hijrī -->
    <xsl:param name="pgDHCorrector" select="0"/>
    <!-- these two paramaters select the folder containing the image files -->
    <xsl:param name="pgUrlBase" select="'/BachUni/BachSources/'"/>
    <xsl:param name="pgUrlVar" select="'al-muqtabas'"/>
    <xsl:param name="pWeekdayNotPublished" select="'Friday'"/>
    
    
    <xsl:template match="/">
        <xsl:result-document href="muqtabas2Sente {replace($pgStartDate,'-','')}-{replace($pgStopDate,'-','')} {format-date($vgDate,'[Y01][M01][D01]')}.xml" method="xml">
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
            <xsl:call-template name="tIncrementDaily">
                <xsl:with-param name="pWeekdayNotPublished" select="$pWeekdayNotPublished"/>
            </xsl:call-template>
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
                        <xsl:value-of select="$pPublicationTitle"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Short Titel</xsl:attribute>
                        <xsl:value-of select="$pShortTitle"/>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="$p_switch-vol-issue=true()">
                            <xsl:element name="tss:characteristic">
                                <xsl:attribute name="name">issue</xsl:attribute>
                                <xsl:value-of select="$pgVolume"/>
                            </xsl:element>
                            <xsl:element name="tss:characteristic">
                                <xsl:attribute name="name">volume</xsl:attribute>
                                <xsl:value-of select="./number"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="tss:characteristic">
                                <xsl:attribute name="name">volume</xsl:attribute>
                                <xsl:value-of select="$pgVolume"/>
                            </xsl:element>
                            <xsl:element name="tss:characteristic">
                                <xsl:attribute name="name">issue</xsl:attribute>
                                <xsl:value-of select="./number"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
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
                        <xsl:value-of select="$pPublPlace"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publisher</xsl:attribute>
                        <xsl:value-of select="$pPublisher"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Hijri</xsl:attribute>
                        <xsl:variable name="vDateH">
                            <xsl:call-template name="funcDateG2H">
                                <xsl:with-param name="pDateG" select="./date"/>
                            </xsl:call-template> 
                       </xsl:variable>
                        <xsl:variable name="vDateHFormatted">
                            <xsl:call-template name="funcDateFormatTei">
                                <xsl:with-param name="pDate" select="$vDateH"/>
                                <xsl:with-param name="pCal" select="'H'"/>
                                <xsl:with-param name="pOutput" select="'formatted'"/>
                                <xsl:with-param name="pWeekday" select="false()"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$vDateHFormatted"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Date Rumi</xsl:attribute>
                        <!-- one has to select either mali or rumi here -->
                        <xsl:variable name="vDateM">
                            <xsl:call-template name="funcDateG2M">
                                <xsl:with-param name="pDateG" select="./date"/>
                            </xsl:call-template> 
                        </xsl:variable>
                        <xsl:variable name="vDateMFormatted">
                            <xsl:call-template name="funcDateFormatTei">
                                <xsl:with-param name="pDate" select="$vDateM"/>
                                <xsl:with-param name="pCal" select="'M'"/>
                                <xsl:with-param name="pOutput" select="'formatted'"/>
                                <xsl:with-param name="pWeekday" select="false()"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="vDateJ">
                            <xsl:call-template name="funcDateG2J">
                                <xsl:with-param name="pDateG" select="./date"/>
                            </xsl:call-template> 
                        </xsl:variable>
                        <xsl:variable name="vDateJFormatted">
                            <xsl:call-template name="funcDateFormatTei">
                                <xsl:with-param name="pDate" select="$vDateJ"/>
                                <xsl:with-param name="pCal" select="'J'"/>
                                <xsl:with-param name="pOutput" select="'formatted'"/>
                                <xsl:with-param name="pWeekday" select="false()"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- one has to select either mali (M) or rumi (J) here -->
                        <xsl:value-of select="$vDateMFormatted"/>
                    </xsl:element>
                    <!--<xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Standort</xsl:attribute>
                        <xsl:value-of select="'AUB'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">call-num</xsl:attribute>
                        <xsl:value-of select="'Mic-Na:142-5'"/>
                    </xsl:element>-->
                    
                    <!--<xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Repository</xsl:attribute>
                        <xsl:value-of select="'EAP'"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Standort</xsl:attribute>
                        <xsl:value-of select="'Masjid al-Aqṣā'"/>
                    </xsl:element>-->
                   <!-- <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">call-num</xsl:attribute>
                        <xsl:value-of select="concat('EAP119/1/8/',$pgVolume)"/>
                    </xsl:element>-->
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Citation identifier</xsl:attribute>
                        <xsl:value-of select="concat($pCitId,'_',$pgVolume,'-',./number)"/>
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
                        <xsl:text>daily</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>