<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsi"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:html="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"
        name="xml"/>

    <!-- PROBLEM: the HTML served by the al-Quds site is not well-formed -->
    <xsl:template name="t_facsimile-url">
        <xsl:param name="p_input-url"/>
        <xsl:variable name="v_input-file-as-string" select="unparsed-text($p_input-url)"
            as="xs:string"/>
        <xsl:variable name="v_url-google-drive">
            <!-- try and find the link to google drive using regex:
        - we look for something like: https://drive.google.com/file/d/0BzWDYcgAm4e_djBoSFl0YnJQOVU/preview -->
            <xsl:analyze-string select="$v_input-file-as-string"
                regex="(https://drive.google.com/file/.+)(/preview)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:value-of select="$v_url-google-drive"/>
    </xsl:template>

    <xsl:template match="html:img" mode="m_html-to-tei">
        <tei:surface>
            <tei:graphic>
                <xsl:attribute name="url" select="substring-after(@src, 'blob:')"/>
            </tei:graphic>
        </tei:surface>
    </xsl:template>
</xsl:stylesheet>
