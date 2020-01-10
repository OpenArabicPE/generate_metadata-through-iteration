<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsi oape"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:oape="https://openarabicpe.github.io/ns"
    >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"  name="xml"/>
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"  name="text"/>
   
   <!-- this stylesheets runs on a tei:biblStruct as input -->
    
    <!-- provides calendar conversion -->

    <xsl:include href="https://tillgrallert.github.io/xslt-calendar-conversion/functions/date-functions.xsl"/>
<!--    <xsl:include href="al-quds_find-links-to-facsimile.xsl"/>-->
    
    <xsl:variable name="v_date-today" select="current-date()"/>
    
    <!-- debugging -->
    <xsl:param name="p_verbose" select="true()"/>
    
    <!-- identity transformation -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:result-document href="../xml/_output/{tokenize(base-uri(),'/')[last()]}" format="xml">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>        
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <xsl:element name="tei:listBibl">
                <xsl:call-template name="t_iterate-tei">
                    <xsl:with-param name="p_input" select="ancestor::tei:TEI/descendant::tei:biblStruct[1]"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="t_iterate-tei">
        <xsl:param name="p_input"/>
        <!-- the following parameters are based on the input and incremented by this template -->
        <xsl:param name="p_date-onset" select="$p_input//tei:monogr/tei:imprint/tei:date[@type='official']/@from"/>
        <xsl:param name="p_date-terminus" select="$p_input//tei:monogr/tei:imprint/tei:date[@type='official']/@to"/>
        <xsl:param name="p_issue" select="$p_input//tei:monogr/tei:biblScope[@unit='issue']/@from"/>
        <xsl:param name="p_volume" select="$p_input//tei:monogr/tei:biblScope[@unit='volume']/@from"/>
<!--        <xsl:param name="p_step" select="$p_input/descendant-or-self::tei:biblStruct/tei:note[@type='param'][@n='p_step']"/>-->
<!--        <xsl:param name="p_weekdays-published" select="$p_input/descendant-or-self::tei:biblStruct/tei:note[@type='param'][@n='p_weekdays-published']"/>-->
<!--        <xsl:param name="p_days-of-the-month" select="$p_input/descendant-or-self::tei:biblStruct/tei:note[@type='param'][@n='p_days-of-the-month']"/>-->
        <xsl:param name="p_page-from" select="$p_input//tei:monogr/tei:biblScope[@unit='page']/@from"/>
        <xsl:param name="p_page-to" select="$p_input//tei:monogr/tei:biblScope[@unit='page']/@to"/>
        <xsl:param name="p_pages" select="$p_page-to - $p_page-from +1"/>
        <xsl:param name="p_frequency">
            <xsl:choose>
                <xsl:when test="$p_input/tei:note[@type = 'tagList']/tei:list/tei:item[matches(.,'frequency_.+')]">
                    <xsl:value-of select="replace($p_input/tei:note[@type = 'tagList']/tei:list/tei:item[matches(.,'frequency_.+')],'frequency_','')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>
                        <xsl:text>Parameter $p_frequency is missing</xsl:text>
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <!-- generates a comma-separated list of weekdays in English -->
        <xsl:param name="p_weekdays-published">
            <xsl:choose>
                <xsl:when test="$p_input/tei:note[@type = 'tagList']/tei:list/tei:item[matches(.,'days_\w+')]">
                    <xsl:for-each select="$p_input/tei:note[@type = 'tagList']/tei:list/tei:item[matches(.,'days_\w+')]">
                        <xsl:value-of select="replace(.,'days_','')"/>
                        <xsl:text>,</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$p_frequency = 'daily'">
                        <xsl:message>
                        <xsl:text>Parameter $p_weekdays-published is missing</xsl:text>
                    </xsl:message>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <!-- generates a comma-separated list of days of the month -->
        <xsl:param name="p_days-of-the-month">
            <xsl:choose>
                <xsl:when test="$p_input/tei:note[@type = 'tagList']/tei:list/tei:item[matches(.,'days_\d+')]">
                    <xsl:for-each select="$p_input/tei:note[@type = 'tagList']/tei:list/tei:item[matches(.,'days_\d+')]">
                        <xsl:value-of select="replace(.,'days_','')"/>
                        <xsl:text>,</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$p_frequency = 'daily'">
                        <xsl:message>
                        <xsl:text>Parameter $p_days-of-the-month is missing</xsl:text>
                    </xsl:message>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:variable name="vDateJD" select="oape:date-convert-gregorian-to-julian-day($p_date-onset)"/>
        <xsl:choose>
            <xsl:when test="$p_frequency = 'daily'">
                <xsl:variable name="v_date-incremented" select="oape:date-convert-julian-day-to-gregorian($vDateJD + 1)"/>
                <xsl:variable name="v_date-weekday" select="lower-case(format-date(xs:date($p_date-onset),'[FNn]'))"/>
                <xsl:variable name="v_date-incremented-weekday" select="format-date(xs:date($v_date-incremented),'[FNn]')"/>
                <!-- prevent output for weekdays not published -->
                <xsl:if test="contains($p_weekdays-published,$v_date-weekday)">
                    <xsl:if test="$p_verbose = true()">
                        <xsl:message>
                            <xsl:text>#</xsl:text><xsl:value-of select="$p_issue"/><xsl:text> was published on </xsl:text><xsl:value-of select="$p_date-onset"/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:call-template name="t_boilerplate-biblstruct">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date" select="$p_date-onset"/>
                        <xsl:with-param name="p_issue" select="$p_issue"/>
                        <xsl:with-param name="p_volume" select="$p_volume"/>
                        <xsl:with-param name="p_page-from" select="$p_page-from"/>
                        <xsl:with-param name="p_page-to" select="$p_page-to"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$v_date-incremented &lt; $p_date-terminus">
                    <xsl:call-template name="t_iterate-tei">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date-onset" select="$v_date-incremented"/>
                        <xsl:with-param name="p_date-terminus" select="$p_date-terminus"/>
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
                        <xsl:with-param name="p_volume" select="$p_volume">
                            <!-- this method is far too unreliable -->
                            <!--<xsl:choose>
                                <!-\- if the issue number can be divided by the number of total issues per year, a new volume should begin -\->
                                <xsl:when test="number($p_issue) mod (52 * number(count(tokenize($p_weekdays-published,',')))) = 0">
                                    <xsl:value-of select="$p_volume +1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$p_volume"/>
                                </xsl:otherwise>
                            </xsl:choose>-->
                        </xsl:with-param>
                        <xsl:with-param name="p_frequency" select="$p_frequency"/>
                        <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
                        <xsl:with-param name="p_page-from" select="$p_page-from"/>
                        <xsl:with-param name="p_page-to" select="$p_page-to"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <!-- fortnightly has been implemented! -->
            <xsl:when test="$p_frequency = 'fortnightly'">
                <xsl:variable name="v_date-incremented" select="oape:date-convert-julian-day-to-gregorian($vDateJD + 14)"/>
                 <xsl:if test="$p_verbose = true()">
                        <xsl:message>
                            <xsl:text>#</xsl:text><xsl:value-of select="$p_issue"/><xsl:text> was published on </xsl:text><xsl:value-of select="$p_date-onset"/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:call-template name="t_boilerplate-biblstruct">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date" select="$p_date-onset"/>
                        <xsl:with-param name="p_issue" select="$p_issue"/>
                        <xsl:with-param name="p_volume" select="$p_volume"/>
                        <xsl:with-param name="p_page-from" select="$p_page-from"/>
                        <xsl:with-param name="p_page-to" select="$p_page-to"/>
                    </xsl:call-template>
                <xsl:if test="$v_date-incremented &lt; $p_date-terminus">
                    <xsl:call-template name="t_iterate-tei">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date-onset" select="$v_date-incremented"/>
                        <xsl:with-param name="p_date-terminus" select="$p_date-terminus"/>
                        <xsl:with-param name="p_issue" select="$p_issue + 1"/>
                        <xsl:with-param name="p_volume" select="$p_volume"/>
                        <xsl:with-param name="p_frequency" select="$p_frequency"/>
                        <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
                        <!-- increment pagination -->
                        <xsl:with-param name="p_page-from" select="$p_page-to + 1"/>
                        <xsl:with-param name="p_page-to" select="$p_page-to + $p_pages"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <!-- monthly should be implemented: incremented by date of the month, such as every fifth of the month or every 5th, 11th and 26th of a month -->
            <xsl:when test="$p_frequency = 'monthly'">
                <xsl:variable name="v_date-incremented" select="oape:date-convert-julian-day-to-gregorian($vDateJD + 1)"/>
                <xsl:variable name="v_day-of-the-month-input" select="format-date(xs:date($p_date-onset),'[D01]')"/>
                <xsl:variable name="v_day-of-the-month-incremented" select="format-date(xs:date($v_date-incremented),'[D01]')"/>
                <!-- prevent output for days of the month not published -->
                <xsl:if test="contains($p_days-of-the-month, $v_day-of-the-month-input)">
                    <xsl:if test="$p_verbose = true()">
                        <xsl:message>
                            <xsl:text>#</xsl:text><xsl:value-of select="$p_issue"/><xsl:text> was published on </xsl:text><xsl:value-of select="$p_date-onset"/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:call-template name="t_boilerplate-biblstruct">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date" select="$p_date-onset"/>
                        <xsl:with-param name="p_issue" select="$p_issue"/>
                        <xsl:with-param name="p_volume" select="$p_volume"/>
                        <xsl:with-param name="p_page-from" select="$p_page-from"/>
                        <xsl:with-param name="p_page-to" select="$p_page-to"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$v_date-incremented &lt; $p_date-terminus">
                    <xsl:call-template name="t_iterate-tei">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date-onset" select="$v_date-incremented"/>
                        <xsl:with-param name="p_date-terminus" select="$p_date-terminus"/>
                        <xsl:with-param name="p_issue">
                            <!-- increment issue number only if the periodical was published -->
                            <xsl:choose>
                                <xsl:when test="contains($p_days-of-the-month, $v_day-of-the-month-incremented)">
                                    <xsl:value-of select="$p_issue + 1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$p_issue"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="p_volume" select="$p_volume"/>
                        <xsl:with-param name="p_frequency" select="$p_frequency"/>
                        <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
                        <!-- increment pagination -->
                        <xsl:with-param name="p_page-from">
                            <!-- increment page number only if the periodical was published -->
                            <xsl:choose>
                                <xsl:when test="contains($p_days-of-the-month, $v_day-of-the-month-incremented)">
                                    <xsl:value-of select="$p_page-to + 1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$p_page-from"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="p_page-to">
                            <xsl:choose>
                                <xsl:when test="contains($p_days-of-the-month, $v_day-of-the-month-incremented)">
                                    <xsl:value-of select="$p_page-to + $p_pages"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$p_page-to"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <xsl:text>The value </xsl:text><xsl:value-of select="$p_frequency"/><xsl:text> of $p_step has not been implemented</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="t_boilerplate-biblstruct">
        <xsl:param name="p_input"/>
        <xsl:param name="p_date"/>
        <xsl:param name="p_issue"/>
        <xsl:param name="p_volume"/>
        <xsl:param name="p_page-from"/>
        <xsl:param name="p_page-to"/>
        <!-- $p_url is dysfunctional for Thamarāt al-Funūn  -->
        <xsl:param name="p_url" select="concat($p_input/descendant-or-self::tei:biblStruct/tei:ref[@type='url']/@target,'issue-',$p_issue)"/>
        <tei:biblStruct xml:lang="en">
            <tei:monogr xml:lang="en">
                <!-- title -->
                <xsl:apply-templates select="$p_input//tei:monogr/tei:title"/>
                <!-- idnos on journal level -->
                <xsl:apply-templates select="$p_input//tei:monogr/tei:idno"/>
                <!-- editor -->
                <xsl:apply-templates select="$p_input//tei:monogr/tei:editor"/>
                <tei:imprint xml:lang="en">
                    <xsl:apply-templates select="$p_input//tei:monogr/tei:imprint/tei:publisher"/>
                    <xsl:apply-templates select="$p_input//tei:monogr/tei:imprint/tei:pubPlace"/>
                    <!-- add calendars depending on the input -->
                    <!-- Gregorian -->
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_gregorian']">
                        <xsl:copy-of select="oape:date-format-iso-string-to-tei($p_date, '#cal_gregorian',true(), true(), 'en')"/>
                    </xsl:if>
                    <!-- Islamic Hijri -->
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_islamic']">
                        <xsl:copy-of select="oape:date-format-iso-string-to-tei( oape:date-convert-calendars($p_date,'#cal_gregorian','#cal_islamic'), '#cal_islamic',true(), true(),'ar-Latn-x-ijmes')"/>
                    </xsl:if>
                    <!-- Julian or Rūmī -->
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_julian']">
                        <xsl:copy-of select="oape:date-format-iso-string-to-tei(oape:date-convert-calendars($p_date,'#cal_gregorian','#cal_julian'), '#cal_julian',true(), true(), 'ar-Latn-x-ijmes')"/>
                    </xsl:if>
                    <!-- Ottoman fiscal, mālī calendar -->
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_ottomanfiscal']">
                        <xsl:copy-of select="oape:date-format-iso-string-to-tei(oape:date-convert-calendars($p_date,'#cal_gregorian','#cal_ottomanfiscal'), '#cal_ottomanfiscal',true(), true(),'ar-Latn-x-ijmes')"/>
                    </xsl:if>
                </tei:imprint>
                <tei:biblScope from="{$p_volume}" to="{$p_volume}" unit="volume"/>
                <tei:biblScope from="{$p_issue}" to="{$p_issue}" unit="issue"/>
                <tei:biblScope from="{$p_page-from}" to="{$p_page-to}" unit="page"/>
            </tei:monogr>
            <xsl:apply-templates select="$p_input/descendant-or-self::tei:biblStruct/tei:ref"/>
            <!-- links for al-Quds -->
            <!--<tei:ref type="url">
                <xsl:attribute name="target"  select="$p_url"/>
            </tei:ref>
            <!-\- the HTML served by al-Quds is not well-formed and cannot be used for transformations -\->
            <tei:ref type="url">
                <xsl:attribute name="target">
                    <xsl:call-template name="t_facsimile-url">
                        <xsl:with-param name="p_input-url" select="$p_url"/>
                    </xsl:call-template>
                </xsl:attribute>
            </tei:ref>-->
            <xsl:apply-templates select="$p_input/descendant-or-self::tei:biblStruct/tei:note"/>
        </tei:biblStruct>
    </xsl:template>
    
    <!-- pages -->
</xsl:stylesheet>