<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oape="https://openarabicpe.github.io/ns"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:include href="https://tillgrallert.github.io/xslt-calendar-conversion/functions/date-functions.xsl"/>
    
    <!-- identity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:date[@calendar='#cal_julian']">
        <xsl:copy-of select="oape:date-format-iso-string-to-tei(oape:date-convert-calendars(@when, '#cal_gregorian', '#cal_ottomanfiscal'), '#cal_ottomanfiscal', true(), true(), 'ar-Latn-x-ijmes')"/>
    </xsl:template>
    
</xsl:stylesheet>