<?xml version="1.0" encoding="UTF-8"?>
<!-- Subscribers: it's handy to know which files are including this template -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
<xsl:template name="link-picker">
    <xsl:param name="link"/>
    <xsl:choose>
        <xsl:when test="$link/@type != 'symlink'">
            <xsl:attribute name="href"><xsl:value-of select="$link/link"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
            <xsl:attribute name="href"><xsl:value-of select="$link/content/system-symlink"/></xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
</xsl:stylesheet>