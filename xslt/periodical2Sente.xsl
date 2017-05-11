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
    
    <!-- potentially most, if not all, params could be written with a single tei:biblStruct element -->
    <xsl:param name="p_biblStruct">
        <tei:biblStruct xml:lang="en">
            <tei:monogr xml:lang="en">
                <tei:title level="j" xml:lang="ar">المقتبس</tei:title>
                <tei:title level="j" type="sub" xml:lang="ar">مجلة تبحث في التربية والتعليم
                    والاجتماع والاقتصاد والاداب والتاريخ والآثار واللغة و تدبير المنزل
                    والصحة والكتب وحضارة العرب والغرب</tei:title>
                <tei:title level="j" type="sub" xml:lang="ar">تصدر في كل شهر عربي بدمشق</tei:title>
                <tei:title level="j" xml:lang="ar-Latn-x-ijmes">[Majallat] al-Muqtabas</tei:title>
                <tei:title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">Majalla tabḥath fī
                    al-tarbiyya wa-l-taʿlīm wa-l-ijtimāʿ wa-l-iqtiṣād wa-l-adab wa-l-tārīkh
                    wa-l-āthār wa-l-lugha wa tadbīr al-manzil wa-l-ṣaḥḥa wa-l-kutub wa
                    ḥaḍāra al-ʿarab wa ḥadāra al-gharb</tei:title>
                <tei:title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">tuṣadir fī kull shar
                    ʿarabī bi-Dimashq</tei:title>
                <tei:title level="j" xml:lang="fr">Al-Moktabas</tei:title>
                <tei:title level="j" type="sub" xml:lang="fr">Revue mensuelle paraissant à Damas
                    (Syrie)</tei:title>
                <tei:title level="j" type="sub" xml:lang="fr">Pédagogie, sociologie, économie
                    politique, littérature, histoire, archéologie, philologie, ménagerie,
                    hygiène, bibliographie, civilisation arabe et occidentale</tei:title>
                <tei:editor ref="viaf:32272677" xml:lang="en">
                    <tei:persName xml:lang="ar">
                        <tei:forename xml:lang="ar">محمد</tei:forename>
                        <tei:surname xml:lang="ar">كرد علي</tei:surname>
                    </tei:persName>
                    <tei:persName xml:lang="ar-Latn-x-ijmes">
                        <tei:forename xml:lang="ar-Latn-x-ijmes">Muḥammad</tei:forename>
                        <tei:surname xml:lang="ar-Latn-x-ijmes">Kurd ʿAlī</tei:surname>
                    </tei:persName>
                </tei:editor>
                <tei:imprint xml:lang="en">
                    <tei:publisher xml:lang="en">
                        <tei:orgName xml:lang="ar">مطبعة المقتبس</tei:orgName> 
                        <tei:orgName notAfter="1914" notBefore="1908" xml:lang="ar-Latn-x-ijmes">Maṭbaʿa al-Muqtabas</tei:orgName> 
                    </tei:publisher>
                    <tei:pubPlace xml:lang="en"> 
                        <tei:placeName xml:lang="ar">دمشق</tei:placeName>
                        <tei:placeName xml:lang="ar-Latn-x-ijmes">Dimashq</tei:placeName> 
                        <tei:placeName xml:lang="en">Damascus</tei:placeName> 
                    </tei:pubPlace>
                    <tei:date type="official" from="1908-09-18" to="1908-10-18" xml:lang="ar-Latn-x-ijmes" when-custom="1329-01-01" datingMethod="#cal_islamic" calendar="#cal_islamic" when="1911-01-02">1 Muḥ 1329</tei:date>
                </tei:imprint>
                <tei:biblScope from="6" to="6" unit="volume"/>
                <tei:biblScope from="1" to="1" unit="issue"/>
                <tei:biblScope unit="page" from="1" to="4"/>
            </tei:monogr>
            <tei:idno type="oclc" xml:lang="en">4770057679</tei:idno>
            <tei:idno type="oclc" xml:lang="en">79440195</tei:idno>
            <tei:idno type="aucr" xml:lang="en">07201136864</tei:idno>
            <tei:idno type="shamela" xml:lang="en">26523</tei:idno>
            <tei:idno type="zenodo" xml:lang="en">45922152</tei:idno>
        </tei:biblStruct>
    </xsl:param>
    
    <!-- param to select the target language -->
    <xsl:param name="p_language" select="'ar-Latn-x-ijmes'"/>
    
    <!-- additional information -->
    <xsl:param name="p_title-short" select="'Quds'"/>
    <xsl:param name="p_citationID" select="'quds'"/>
    
    <!-- all params can contain nodes -->
    <xsl:param name="p_title-publication">
           <xsl:choose>
               <xsl:when test="$p_biblStruct//tei:monogr/tei:title[@level='j'][@xml:lang=$p_language]">
                   <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:title[@level='j'][@xml:lang=$p_language]"/>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:title[@level='j'][1]"/>
               </xsl:otherwise>
           </xsl:choose>
    </xsl:param>
    <!-- $p_editors contains  -->
    <xsl:param name="p_editors">
        <xsl:element name="tei:editor">
            <xsl:choose>
            <xsl:when test="$p_biblStruct//tei:monogr/tei:editor/tei:persName[@xml:lang=$p_language]">
                <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:editor/tei:persName[@xml:lang=$p_language]"/>
            </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:editor/tei:persName[1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:param>
    <xsl:param name="p_publisher">
        <xsl:choose>
            <xsl:when test="$p_biblStruct//tei:monogr/tei:imprint/tei:publisher/node()[@xml:lang=$p_language]">
                <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:imprint/tei:publisher/node()[@xml:lang=$p_language]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:imprint/tei:publisher/node()[1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="p_pubPlace">
        <xsl:choose>
            <xsl:when test="$p_biblStruct//tei:monogr/tei:imprint/tei:pubPlace/node()[@xml:lang=$p_language]">
                <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:imprint/tei:pubPlace/node()[@xml:lang=$p_language]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$p_biblStruct//tei:monogr/tei:imprint/tei:pubPlace/node()[1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <!--<xsl:param name="p_title-publication" select="'al-Quds: Jarīda ʿilmiyya adabiyya akhbāriyya'"/>
    <xsl:param name="p_title-short" select="'Quds'"/>
    <xsl:param name="p_citationID" select="'quds'"/>
    <xsl:param name="p_publisher"/>
    <xsl:param name="p_pubPlace" select="'al-Quds'"/>-->
    <!--  -->
    <!--<xsl:param name="p_editors">
        <tei:person>
            <tei:persName xml:lang="ar-Latn-x-ijmes">
                <tei:forename>Ḥanāniyyā</tei:forename>
                <tei:surname>Jirjī Ḥabīb</tei:surname>
            </tei:persName>
            <tei:idno type="viaf"></tei:idno>
        </tei:person>
    </xsl:param>-->
    <!-- dates, calendars etc. -->
    <xsl:param name="p_date-start" select="$p_biblStruct//tei:date[@type='official']/@from"/>
    <xsl:param name="p_date-stop" select="$p_biblStruct//tei:date[@type='official']/@to"/>
    <!-- $p_weekdays-published contains a comma-separated list of weekdays in English -->
    <xsl:param name="p_weekdays-published" select="'Tuesday, Friday'"/>
    <!-- select calendars for output -->
    <xsl:param name="p_cal-islamic" select="true()"/>
    <xsl:param name="p_cal-julian" select="true()"/>
    <xsl:param name="p_cal-ottomanfiscal" select="false()"/>
    <!-- sometimes the computation of Hijri dates is one day off from the local Hijrī. It is not -->
<!--    <xsl:param name="pgDHCorrector" select="0"/>-->
    
    <!-- issue, pages -->
    <xsl:param name="pgStartIssue" select="$p_biblStruct//tei:monogr/tei:biblScope[@unit='issue']/@from"/>
    <xsl:param name="p_volume" select="$p_biblStruct//tei:monogr/tei:biblScope[@unit='volume']/@from"/>
    <xsl:param name="p_switch-vol-issue" select="false()"/>
    <xsl:param name="p_pages" select="$p_biblStruct//tei:monogr/tei:biblScope[@unit='page']/@to"/>
    
    <!-- these two paramaters select the folder containing the image files -->
    <xsl:param name="pgUrlBase" select="'/BachUni/BachSources/'"/>
    <xsl:param name="pgUrlVar" select="'al-muqtabas'"/>
    <xsl:param name="pgStartImg" select="1"/>
    
    <!-- identity transformation -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- generate Sente XML -->
    <xsl:template match="/">
        <xsl:result-document href="../xml/_output/{$p_title-short}2Sente-from_{replace($p_date-start,'-','')}-to_{replace($p_date-stop,'-','')}-when_{format-date($vgDate,'[Y01][M01][D01]')}.Sente.xml" format="xml">
                    <xsl:call-template name="t_references-sente"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>