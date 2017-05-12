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
   
   <!-- this stylesheets rus on a tei:biblStruct as input -->
    
    <!-- provides calendar conversion -->
    <xsl:include href="https://rawgit.com/tillgrallert/xslt-calendar-conversion/master/date-function.xsl"/>
    
    <xsl:variable name="v_date-today" select="current-date()"/>
    
    <!--  $p_step sets incremental steps for the input to be iterated upon. Values are:
        - daily: this includes any publication cycle that is at least weekly
        - fortnightly:
        - monthly: -->
<!--    <xsl:param name="p_step" select="'daily'"/>-->
    <!-- $p_weekdays-published contains a comma-separated list of weekdays in English -->
<!--    <xsl:param name="p_weekdays-published" select="'Tuesday, Friday'"/>-->
    
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
<!--                    <xsl:with-param name="p_step" select="$p_step"/>-->
<!--                    <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>-->
                </xsl:call-template>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="t_iterate-tei">
        <xsl:param name="p_input"/>
        <!-- the following parameters are based on the input and incremented by this template -->
        <xsl:param name="p_date-start" select="$p_input//tei:monogr/tei:imprint/tei:date[@type='official']/@from"/>
        <xsl:param name="p_date-stop" select="$p_input//tei:monogr/tei:imprint/tei:date[@type='official']/@to"/>
        <xsl:param name="p_issue" select="$p_input//tei:monogr/tei:biblScope[@unit='issue']/@from"/>
        <xsl:param name="p_step" select="$p_input/descendant-or-self::tei:biblStruct/tei:note[@type='param'][@n='p_step']"/>
        <xsl:param name="p_weekdays-published" select="$p_input/descendant-or-self::tei:biblStruct/tei:note[@type='param'][@n='p_weekdays-published']"/>
        <xsl:variable name="vDateJD">
            <xsl:call-template name="funcDateG2JD">
                <xsl:with-param name="pDateG" select="$p_date-start"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$p_step='daily'">
                <xsl:variable name="v_date-incremented">
                    <xsl:call-template name="funcDateJD2G">
                        <xsl:with-param name="pJD" select="$vDateJD + 1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="v_date-weekday" select="format-date(xs:date($p_date-start),'[FNn]')"/>
                <xsl:variable name="v_date-incremented-weekday" select="format-date(xs:date($v_date-incremented),'[FNn]')"/>
                <!-- prevent output for weekdays not published -->
                <xsl:if test="contains($p_weekdays-published,$v_date-weekday)">
                    <xsl:if test="$p_verbose = true()">
                        <xsl:message>
                            <xsl:text>#</xsl:text><xsl:value-of select="$p_issue"/><xsl:text> was published on </xsl:text><xsl:value-of select="$p_date-start"/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:call-template name="t_boilerplate-biblstruct">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <!-- information that needs to be incremented -->
                        <xsl:with-param name="p_date" select="$p_date-start"/>
                        <xsl:with-param name="p_issue" select="$p_issue"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$v_date-incremented &lt; $p_date-stop">
                    <xsl:call-template name="t_iterate-tei">
                        <xsl:with-param name="p_input" select="$p_input"/>
                        <xsl:with-param name="p_date-start" select="$v_date-incremented"/>
                        <xsl:with-param name="p_date-stop" select="$p_date-stop"/>
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
                        <xsl:with-param name="p_step" select="$p_step"/>
                        <xsl:with-param name="p_weekdays-published" select="$p_weekdays-published"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <xsl:text>This value of $p_step has not been implemented</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="t_boilerplate-biblstruct">
        <xsl:param name="p_input"/>
        <xsl:param name="p_date"/>
        <xsl:param name="p_issue"/>
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
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_islamic']">
                        <xsl:variable name="v_date-hijri">
                            <xsl:call-template name="funcDateG2H">
                                <xsl:with-param name="pDateG" select="$p_date"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <tei:date type="computed" when="{$p_date}" datingMethod="#cal_islamic" calendar="#cal_islamic" when-custom="{$v_date-hijri}" xml:lang="ar-Latn-x-ijmes">
                            <xsl:value-of select="format-date($v_date-hijri,'[D1]')"/>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="funcDateMonthNameNumber">
                                <xsl:with-param name="pDate" select="$v_date-hijri"/>
                                <xsl:with-param name="pLang" select="'HIjmesFull'"/>
                                <xsl:with-param name="pMode" select="'name'"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="format-date($v_date-hijri,'[Y1]')"/>
                        </tei:date>
                    </xsl:if>
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_julian']">
                        <xsl:variable name="v_date-julian">
                            <xsl:call-template name="funcDateG2J">
                                <xsl:with-param name="pDateG" select="$p_date"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <tei:date type="computed" when="{$p_date}" datingMethod="#cal_julian" calendar="#cal_julian" when-custom="{$v_date-julian}" xml:lang="ar-Latn-x-ijmes">
                            <xsl:value-of select="format-date($v_date-julian,'[D1]')"/>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="funcDateMonthNameNumber">
                                <xsl:with-param name="pDate" select="$v_date-julian"/>
                                <xsl:with-param name="pLang" select="'JIjmes'"/>
                                <xsl:with-param name="pMode" select="'name'"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="format-date($v_date-julian,'[Y1]')"/>
                        </tei:date>
                    </xsl:if>
                    <xsl:if test="$p_input//tei:monogr/tei:imprint/tei:date[@datingMethod='#cal_ottomanfiscal']">
                        <xsl:variable name="v_date-mali">
                            <xsl:call-template name="funcDateG2M">
                                <xsl:with-param name="pDateG" select="$p_date"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <tei:date type="computed" when="{$p_date}" datingMethod="#cal_ottomanfiscal" calendar="#cal_ottomanfiscal" when-custom="{$v_date-mali}" xml:lang="ar-Latn-x-ijmes">
                            <xsl:value-of select="format-date($v_date-mali,'[D1]')"/>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="funcDateMonthNameNumber">
                                <xsl:with-param name="pDate" select="$v_date-mali"/>
                                <xsl:with-param name="pLang" select="'MIjmes'"/>
                                <xsl:with-param name="pMode" select="'name'"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="format-date($v_date-mali,'[Y1]')"/>
                        </tei:date>
                    </xsl:if>
                </tei:imprint>
                <xsl:apply-templates select="$p_input//tei:monogr/tei:biblScope[not(@unit='issue')]"/>
                <tei:biblScope from="{$p_issue}" to="{$p_issue}" unit="issue"/>
            </tei:monogr>
            <xsl:apply-templates select="$p_input/descendant-or-self::tei:biblStruct/tei:ref"/>
            <xsl:apply-templates select="$p_input/descendant-or-self::tei:biblStruct/tei:note"/>
        </tei:biblStruct>
    </xsl:template>
</xsl:stylesheet>