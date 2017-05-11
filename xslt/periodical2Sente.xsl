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
    
    <!-- This stylesheet builds Sente XML for scans of periodicals. It does not need html as input -->
   
    <!-- v1: production version; currently adapted to hadiqat -->
    <!-- as the import engine is extremely bugy or rather as duplicate detection is a bit over ambitious, I have to introduce individual article titles to get all references imported. I used the unique call-numbers for this purpose -->
    
    <!-- provides calendar conversion -->
    <xsl:include href="https://rawgit.com/tillgrallert/xslt-calendar-conversion/master/date-function.xsl"/>
    
    <!-- load functions to increment issues -->
    <xsl:include href="periodical2Sente-functions.xsl"/>
    
    <xsl:variable name="vgDate" select="current-date()"/>
    
    <!-- all params could be loaded through external files -->
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
                    <xsl:call-template name="t_references-sente"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>