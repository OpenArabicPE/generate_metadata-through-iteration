<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <!-- identity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:surface[@xml:id='facs_4']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-- add  facsimile -->
            <xsl:variable name="v_source" select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr"/>
            <xsl:variable name="v_url-next" select="ancestor::tei:TEI/@next"/>
            <xsl:variable name="v_source-next" select="document($v_url-next)/descendant::tei:sourceDesc/tei:biblStruct/tei:monogr"/>
            <xsl:variable name="v_oclc" select="$v_source/tei:idno[@type='OCLC'][1]"/>
            <xsl:variable name="v_publication-id" select="concat('oclc_',$v_oclc)"/>
            <!--<xsl:variable name="v_image-url" select="concat('../images/al-asr-al-jadid-i_',$v_source-next/tei:biblScope[@unit='issue']/@from,'-date_',$v_source-next/tei:imprint/tei:date[@when][1]/@when,'-p_0.tif')"/>-->
            <xsl:variable name="v_image-url" select="concat('../images/',$v_publication-id,'-i_',$v_source-next/tei:biblScope[@unit='issue']/@from,'-p_0.tif')"/>
                <xsl:if test="fs:exists(fs:new(resolve-uri($v_image-url, base-uri(.))))" xmlns:fs="java.io.File">
                    <xsl:element name="tei:graphic">
                        <xsl:attribute name="xml:id" select="'facs_4-g_3'"/>
                        <xsl:attribute name="url" select="$v_image-url"/>
                        <xsl:attribute name="mimeType" select="'image/tiff'"/>
                    </xsl:element>
                </xsl:if>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>