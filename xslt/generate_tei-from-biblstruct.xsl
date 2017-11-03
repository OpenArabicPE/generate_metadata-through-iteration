<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/XSL/Format" version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    
    <xsl:variable name="v_source-url" select="base-uri()"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:text/descendant::tei:biblStruct" mode="m_generate-tei"/>
    </xsl:template>
    
    <xsl:template match="tei:biblStruct" mode="m_generate-tei">
        <xsl:variable name="v_oclc" select="tei:monogr/tei:idno[@type='oclc'][1]"/>
        <xsl:variable name="v_issue" select="tei:monogr/tei:biblScope[@unit='issue']/@from"/>
        <xsl:variable name="v_id" select="if(@xml:id) then(@xml:id) else(generate-id())"/>
        <xsl:result-document href="../_output/oclc_{$v_oclc}-i_{$v_issue}.TEIP5.xml">
            <!-- link schema and TEI boilerlplate -->
            <tei:TEI>
                <!-- add @next and @prev -->
                <xsl:call-template name="t_generate-teiHeader">
                    <xsl:with-param name="p_input" select="."/>
                </xsl:call-template>
                <tei:facsimile></tei:facsimile>
                <tei:text></tei:text>
            </tei:TEI>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="t_generate-teiHeader">
        <xsl:param name="p_input"/>
        <tei:teiHeader>
            <tei:fileDesc>
                <tei:titleStmt></tei:titleStmt>
                <!-- responsibilities -->
                <tei:publicationStmt></tei:publicationStmt>
                <tei:sourceDesc>
                    <xsl:copy-of select="$p_input"/>
                </tei:sourceDesc>
            </tei:fileDesc>
            <tei:revisionDesc>
                <tei:change when="{format-date(current-date(),'[Y0001]-[M01]-[D01]')}">Created this file by automatic conversion of <tei:gi>biblStruct</tei:gi> from <xsl:value-of select="$v_source-url"/>.</tei:change>
            </tei:revisionDesc>
        </tei:teiHeader>
    </xsl:template>
    
</xsl:stylesheet>