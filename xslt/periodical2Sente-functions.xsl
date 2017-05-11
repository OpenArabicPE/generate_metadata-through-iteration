<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"  name="xml"/>
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"  name="text"/>
    
    <xsl:template name="t_references-sente">
        <!-- for al-Hasna it must be monthly -->
        <xsl:variable name="vRefs">
            <xsl:call-template name="t_increment-daily">
                <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
                <xsl:with-param name="p_date-start" select="$p_date-start"/>
                <xsl:with-param name="p_date-stop" select="$p_date-stop"/>
                <xsl:with-param name="p_issue" select="$pgStartIssue"/>
                <xsl:with-param name="p_pages" select="$p_pages"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:element name="tss:senteContainer">
            <xsl:attribute name="version">1.0</xsl:attribute>
            <xsl:attribute name="xsi:schemaLocation">http://www.thirdstreetsoftware.com/SenteXML-1.0 SenteXML.xsd</xsl:attribute>
            <xsl:element name="tss:library">
                <xsl:element name="tss:references">
        <xsl:for-each select="$vRefs/issue">
            <xsl:element name="tss:reference">
                <xsl:element name="tss:publicationType">
                    <xsl:attribute name="name">Archival Periodical</xsl:attribute>
                </xsl:element>
                <xsl:element name="tss:authors">
                    <xsl:apply-templates select="$p_editors/tei:editor" mode="m_tei-to-sente"/>
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
                        <xsl:value-of select="$p_title-publication"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">Short Titel</xsl:attribute>
                        <xsl:value-of select="$p_title-short"/>
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
                        <xsl:value-of select="$p_pubPlace"/>
                    </xsl:element>
                    <xsl:element name="tss:characteristic">
                        <xsl:attribute name="name">publisher</xsl:attribute>
                        <xsl:value-of select="$p_publisher"/>
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
                        <xsl:value-of select="concat($p_citationID,'_',$p_volume,'-',./number)"/>
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
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
     <xsl:template name="tIncrementUrl2">
        <xsl:param name="pNumStart"/>
        <xsl:param name="pNumStop"/>
         <xsl:param name="pDate"/>
        <xsl:variable name="vUrlImgBase">
            <xsl:value-of select="concat($pgUrlBase,$pgUrlVar,'/',substring(replace($pDate,'-',''),1,6),'_')"/>
        </xsl:variable>
        <xsl:element name="tss:attachmentReference">
            <!--<xsl:element name="name">
                <xsl:value-of select="concat('p',$pNumStart)"/>
            </xsl:element>-->
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
        
    </xsl:template>
    
    <!-- this template produces a series of <issue> notes with children for <date>, <number>, <img> -->
    <xsl:template name="t_increment-daily">
        <xsl:param name="p_date-start"/>
        <xsl:param name="p_date-stop"/>
        <xsl:param name="p_pages"/>
        <xsl:param name="p_issue"/>
<!--        <xsl:param name="p_url-image"/>-->
        <!-- many daily newspapers are published only six days a week, this param expects a list of comma-separated weekdays in English  -->
        <xsl:param name="p_weekdays-published"/>
        <xsl:variable name="vDateJD">
            <xsl:call-template name="funcDateG2JD">
                <xsl:with-param name="pDateG" select="$p_date-start"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_date-incremented">
            <xsl:call-template name="funcDateJD2G">
                <xsl:with-param name="pJD" select="$vDateJD + 1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_date-weekday" select="format-date(xs:date($p_date-start),'[FNn]')"/>
        <xsl:variable name="v_date-incremented-weekday" select="format-date(xs:date($v_date-incremented),'[FNn]')"/>
        <!-- prevent output for weekdays not published -->
        <xsl:if test="contains($p_weekdays-published,$v_date-weekday)">
            <xsl:element name="issue">
                <xsl:element name="date">
                    <xsl:value-of select="$p_date-start"/>
                </xsl:element>
                <xsl:element name="number">
                    <xsl:value-of select="$p_issue"/>
                </xsl:element>
                <!--<xsl:element name="img">
                    <xsl:value-of select="$p_url-image"/>
                </xsl:element>-->
            </xsl:element>
        </xsl:if>
        <xsl:if test="$v_date-incremented &lt; $p_date-stop">
            <xsl:call-template name="t_increment-daily">
                <xsl:with-param name="p_date-start" select="$v_date-incremented"/>
                <xsl:with-param name="p_date-stop" select="$p_date-stop"/>
                <xsl:with-param name="p_pages" select="$p_pages"/>
                <xsl:with-param name="p_issue">
                    <xsl:choose>
                        <xsl:when test="contains($p_weekdays-published,$v_date-incremented-weekday)">
                            <xsl:value-of select="$p_issue + 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$p_issue"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
<!--                <xsl:with-param name="p_url-image" select="$p_url-image + $p_pages"/>-->
                <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="tIncrementFortnightly">
        <xsl:param name="pDate" select="$p_date-start"/>
        <xsl:param name="pIssue" select="$pgStartIssue"/>
        <xsl:param name="pImgUrl" select="$pgStartImg"/>
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
        <xsl:if test="$vDateInc lt $p_date-stop">
            <xsl:call-template name="tIncrementFortnightly">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue" select="$pIssue + 1"/>
                <xsl:with-param name="pImgUrl" select="$pImgUrl + $p_pages"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tIncrementMonthly">
        <xsl:param name="pDate" select="$p_date-start"/>
        <xsl:param name="pIssue" select="$pgStartIssue"/>
        <xsl:param name="pImgUrl" select="$pgStartImg"/>
        <xsl:variable name="vMonthInc" select="number(tokenize($pDate,'-')[2]) + 1"/>
        <xsl:variable name="vDateInc">
            <xsl:choose>
                <xsl:when test="$vMonthInc &lt;= 12">
                    <xsl:value-of select="concat(tokenize($pDate,'-')[1],'-',format-number($vMonthInc,'00'),'-',tokenize($pDate,'-')[3])"/>
                </xsl:when>
                <!-- this only kicks in for January -->
                <xsl:otherwise>
                    <xsl:value-of select="number(tokenize($pDate,'-')[1])+1"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="format-number($vMonthInc -12,'00')"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="tokenize($pDate,'-')[3]"/>
                </xsl:otherwise>
            </xsl:choose>
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
        <xsl:if test="$vDateInc lt $p_date-stop">
            <xsl:call-template name="tIncrementMonthly">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue" select="$pIssue + 1"/>
                <xsl:with-param name="pImgUrl" select="$pImgUrl + $p_pages"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- -->
    <xsl:template match="tei:editor" mode="m_tei-to-sente">
        <xsl:element name="tss:author">
            <xsl:attribute name="role" select="'Editor'"/>
            <xsl:apply-templates select="tei:persName[1]/tei:surname" mode="m_tei-to-sente"/>
            <xsl:apply-templates select="tei:persName[1]/tei:forename" mode="m_tei-to-sente"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:surname" mode="m_tei-to-sente">
        <xsl:element name="tss:surname">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:forename" mode="m_tei-to-sente">
        <xsl:element name="tss:forenames">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>