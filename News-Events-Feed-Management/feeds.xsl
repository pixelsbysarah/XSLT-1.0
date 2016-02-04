<?xml version="1.0" encoding="UTF-8"?>
<!-- Subscribers: List dependent formats here -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:atom="http://www.w3.org/2005/Atom">
    <xsl:include href="/_common/_internal/formats/format-date"/>
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
    <xsl:variable name="maxItems">3</xsl:variable>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ </xsl:variable>
    <!-- Brief announcements: content comes from within the CMS via XML -->
    <xsl:template match="announcements">
		<xsl:if test="heading != ''">
			<h2><xsl:value-of select="heading"/></h2>
			<ul>
				<xsl:for-each select="announcement">
					<li>
					<xsl:choose>
						<xsl:when test="ann-link/path != '/'">
							<a class="arrow" href="ann-link/link"><xsl:value-of select="ann-heading"/></a>
						</xsl:when>
						<xsl:otherwise>
							<strong><xsl:value-of select="ann-heading"/></strong>
						</xsl:otherwise>
					</xsl:choose>
						<p><xsl:if test="brief-text != '/'"><xsl:value-of select="brief-text/node()"/></xsl:if></p>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
    </xsl:template>
    <!-- News/Event Chooser: Applies relevant template for news, calendar, or a "live" feed -->
    <xsl:template match="Feed" name="news-events">
        <xsl:if test="feed-block != '/'">
            <xsl:variable name="chLink" select="feed-block/content/rss/channel/link"/>
            <div class="col">
                <xsl:if test="feed-name != ''"><h2><xsl:value-of select="feed-name"/></h2></xsl:if>
                <xsl:variable name="feed-name-clean" select="translate(feed-name,$ucletters,$lcletters)"/>
                <ul id="{$feed-name-clean}">
                    <xsl:choose>
                        <xsl:when test="contains(feed-block/content/rss/channel/link, '360.rollins.edu')">
                            <xsl:apply-templates mode="news" select="feed-block/content/rss/channel/item"/>
                        </xsl:when>
                        <xsl:when test="contains(feed-block/content/rss/channel/link, 'calendar.')">
                            <xsl:apply-templates mode="calendar" select="feed-block/content/rss/channel/item"/>
                        </xsl:when>
                        <xsl:when test="live-feed/value = 'Yes'">
                                <script>
                                var u = "<xsl:value-of select="$chLink"/>/feed/", container = "<xsl:value-of select="$feed-name-clean"/>";
                                liveFeed(u,container);
                                </script>
                        </xsl:when>
                    </xsl:choose>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- news RSS feed: taking image out of description, displaying separately-->
    <xsl:template match="rss/channel/item" mode="news">
        <xsl:if test="position() &lt;= $maxItems">
            <li>
                <xsl:if test="contains(description,'&lt;img')">
                    <a href="{link}" target="_blank">
                        <xsl:variable name="iurl" select="substring-before(substring-after(description,'http://'),'.jpg')"/>
                        <img alt="" src="http://{$iurl}.jpg"/>
                    </a>
                </xsl:if>
                <a class="arrow" href="{link}" target="_blank"><xsl:value-of select="title"/></a>
                <p><xsl:copy-of select="substring(substring-after(substring-before(description,'&lt;/p&gt;'),'&lt;p&gt;'),1,91)"/>...</p>
            </li>
        </xsl:if>
    </xsl:template>
    <!-- legacy calendar RSS feed: text requires more "massaging" -->
    <xsl:template match="rss/channel/item" mode="calendar">
        <xsl:if test="position() &lt;= $maxItems">
            <li>
                <div class="date"><xsl:value-of select="category"/></div>
                <a class="arrow" href="{link}" target="_blank"><xsl:value-of select="title"/></a>
                <p><xsl:copy-of select="substring(substring-after(substring-before(description,']]&gt;'),'CDATA['),1,91)"/>...</p>
            </li>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>