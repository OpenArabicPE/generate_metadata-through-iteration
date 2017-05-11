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
    <xsl:template name="tIncrementDaily">
        <xsl:param name="pDate" select="$pgStartDate"/>
        <xsl:param name="pIssue" select="$pgStartIssue"/>
        <xsl:param name="pImgUrl" select="$pgStartImg"/>
        <!-- many daily newspapers are published only six days a week.  -->
        <xsl:param name="pWeekdayNotPublished"/>
        <xsl:variable name="vDateJD">
            <xsl:call-template name="funcDateG2JD">
                <xsl:with-param name="pDateG" select="$pDate"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="vDateInc">
            <xsl:call-template name="funcDateJD2G">
                <xsl:with-param name="pJD" select="$vDateJD + 1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="vDateWeekday" select="format-date(xs:date($pDate),'[FNn]')"/>
        <xsl:variable name="vDateIncWeekday" select="format-date(xs:date($vDateInc),'[FNn]')"/>
        <!-- prevent output for weekdays not published -->
        <xsl:if test="$vDateWeekday != $pWeekdayNotPublished">
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
        </xsl:if>
        <xsl:if test="$vDateInc &lt; $pgStopDate">
            <xsl:call-template name="tIncrementDaily">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue">
                    <xsl:choose>
                        <xsl:when test="$vDateIncWeekday != $pWeekdayNotPublished">
                            <xsl:value-of select="$pIssue + 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$pIssue"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="pImgUrl" select="$pImgUrl + $pgPages"/>
                <xsl:with-param name="pWeekdayNotPublished" select="$pWeekdayNotPublished"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- this template produces a series of <issue> notes with children for <date>, <number>, <img> -->
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
    
    <xsl:template name="tIncrementFortnightly">
        <xsl:param name="pDate" select="$pgStartDate"/>
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
        <xsl:if test="$vDateInc lt $pgStopDate">
            <xsl:call-template name="tIncrementFortnightly">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue" select="$pIssue + 1"/>
                <xsl:with-param name="pImgUrl" select="$pImgUrl + $pgPages"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="tIncrementMonthly">
        <xsl:param name="pDate" select="$pgStartDate"/>
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
        <xsl:if test="$vDateInc lt $pgStopDate">
            <xsl:call-template name="tIncrementMonthly">
                <xsl:with-param name="pDate" select="$vDateInc"/>
                <xsl:with-param name="pIssue" select="$pIssue + 1"/>
                <xsl:with-param name="pImgUrl" select="$pImgUrl + $pgPages"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>