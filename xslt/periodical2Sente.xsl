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
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"  name="xml"/>
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"  name="text"/>
    
    <!-- This stylesheet builds Sente XML for scans of periodicals. It does not need html as input -->
   
    <!-- v1: production version; currently adapted to hadiqat -->
    <!-- as the import engine is extremely bugy or rather as duplicate detection is a bit over ambitious, I have to introduce individual article titles to get all references imported. I used the unique call-numbers for this purpose -->
    
    <!-- provides calendar conversion -->
    <xsl:include href="https://rawgit.com/tillgrallert/xslt-calendar-conversion/master/date-function.xsl"/>
    
    <!-- load functions to increment issues -->
    <xsl:include href="periodical2Sente-functions.xsl"/>
    
    <xsl:variable name="vgDate" select="current-date()"/>
    
    <xsl:param name="pPublicationTitle" select="'al-Quds: Jarīda ʿilmiyya adabiyya akhbāriyya'"/>
    <xsl:param name="pShortTitle" select="'Quds'"/>
    <xsl:param name="pCitId" select="'quds'"/>
    <xsl:param name="pPublisher"/>
    <xsl:param name="pPublPlace" select="'al-Quds'"/>
    <!--  -->
    <xsl:param name="p_editors">
        <tei:person>
            <tei:persName xml:lang="ar-Latn-x-ijmes">
                <tei:forename>Ḥanāniyyā</tei:forename>
                <tei:surname>Jirjī Ḥabīb</tei:surname>
            </tei:persName>
            <tei:idno type="viaf"></tei:idno>
        </tei:person>
    </xsl:param>
    <!-- dates, calendars etc. -->
    <xsl:param name="pgStartDate" select="'1908-09-18'"/>
    <xsl:param name="pgStopDate" select="'1908-10-18'"/>
    <!-- $p_weekdays-published contains a comma-separated list of weekdays in English -->
    <xsl:param name="p_weekdays-published" select="'Tuesday, Friday'"/>
    <!-- select calendars for output -->
    <xsl:param name="p_cal-islamic" select="true()"/>
    <xsl:param name="p_cal-julian" select="true()"/>
    <xsl:param name="p_cal-ottomanfiscal" select="false()"/>
    <!-- sometimes the computation of Hijri dates is one day off from the local Hijrī. It is not -->
<!--    <xsl:param name="pgDHCorrector" select="0"/>-->
    
    <!-- issue, pages -->
    <xsl:param name="pgStartIssue" select="1"/>
    <xsl:param name="p_volume" select="1"/>
    <xsl:param name="p_switch-vol-issue" select="false()"/>
    <xsl:param name="p_pages" select="4"/>
    
    <!-- these two paramaters select the folder containing the image files -->
    <xsl:param name="pgUrlBase" select="'/BachUni/BachSources/'"/>
    <xsl:param name="pgUrlVar" select="'al-muqtabas'"/>
    <xsl:param name="pgStartImg" select="1"/>
    
    <!-- generate Sente XML -->
    <xsl:template match="/">
        <xsl:result-document href="../xml/_output/{$pCitId}2Sente-from_{replace($pgStartDate,'-','')}-to_{replace($pgStopDate,'-','')}-when_{format-date($vgDate,'[Y01][M01][D01]')}.Sente.xml" format="xml">
        <xsl:element name="tss:senteContainer">
            <xsl:attribute name="version">1.0</xsl:attribute>
            <xsl:attribute name="xsi:schemaLocation">http://www.thirdstreetsoftware.com/SenteXML-1.0 SenteXML.xsd</xsl:attribute>
            <xsl:element name="tss:library">
                <xsl:element name="tss:references">
                    <xsl:call-template name="t_references-sente"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        </xsl:result-document>
    </xsl:template>
     
    <xsl:template name="t_references-sente">
        <!-- for al-Hasna it must be monthly -->
        <xsl:variable name="vRefs">
            <xsl:call-template name="t_increment-daily">
                <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
                <xsl:with-param name="p_date-start" select="$pgStartDate"/>
                <xsl:with-param name="p_date-stop" select="$pgStopDate"/>
                <xsl:with-param name="p_issue" select="$pgStartIssue"/>
                <xsl:with-param name="p_pages" select="$p_pages"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="$vRefs/issue">
            <xsl:element name="tss:reference">
                <xsl:element name="tss:publicationType">
                    <xsl:attribute name="name">Archival Periodical</xsl:attribute>
                </xsl:element>
                <xsl:element name="tss:authors">
                    <xsl:apply-templates select="$p_editors/tei:person" mode="m_tei-to-sente"/>
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
                                <xsl:value-of select="$p_volume"/>
                            </xsl:element>
                            <xsl:element name="tss:characteristic">
                                <xsl:attribute name="name">volume</xsl:attribute>
                                <xsl:value-of select="./number"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="tss:characteristic">
                                <xsl:attribute name="name">volume</xsl:attribute>
                                <xsl:value-of select="$p_volume"/>
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
                        <xsl:value-of select="concat('1-',$p_pages)"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publicationCountry</xsl:attribute>
                        <xsl:value-of select="$pPublPlace"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publisher</xsl:attribute>
                        <xsl:value-of select="$pPublisher"/>
                    </xsl:element>
                    <!--  toggle Islamic date-->
                    <xsl:if test="$p_cal-islamic = true()">
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
                    </xsl:if>
                    <!-- toggle Julian (*rūmī*) date -->
                    <xsl:if test="$p_cal-julian = true()">
                        <xsl:element name="tss:characteristic">
                            <xsl:attribute name="name">Date Rumi</xsl:attribute>
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
                            <xsl:value-of select="$vDateJFormatted"/>
                        </xsl:element>
                    </xsl:if>
                    <!-- toggle Ottoman fiscal (*mālī*) date -->
                    <xsl:if test="$p_cal-ottomanfiscal = true()">
                        <xsl:element name="tss:characteristic">
                            <xsl:attribute name="name">Date Rumi</xsl:attribute>
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
                            <xsl:value-of select="$vDateMFormatted"/>
                        </xsl:element>
                    </xsl:if>
                    
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
                        <xsl:value-of select="concat($pCitId,'_',$p_volume,'-',./number)"/>
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