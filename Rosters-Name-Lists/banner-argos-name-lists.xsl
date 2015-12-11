<?xml version="1.0" encoding="UTF-8"?>
<!-- Subscriber list here -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:exslt="http://exslt.org/common" xmlns:xalan="http://xml.apache.org/xalan">
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
        <xsl:variable name="alpha">
            <item>A</item>
            <item>B</item>
            <item>C</item>
            <item>D</item>
    		<item>E</item>
    		<item>F</item>
    		<item>G</item>
    		<item>H</item>
    		<item>I</item>
    		<item>J</item>
    		<item>K</item>
    		<item>L</item>
    		<item>M</item>
    		<item>N</item>
    		<item>O</item>
    		<item>P</item>
    		<item>Q</item>
    		<item>R</item>
    		<item>S</item>
    		<item>T</item>
    		<item>U</item>
    		<item>V</item>
    		<item>W</item>
    		<item>X</item>
    		<item>Y</item>
    		<item>Z</item>
    	</xsl:variable>
        <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
        <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ </xsl:variable>
    	<xsl:variable name="alphaLength" select="count(exslt:node-set($alpha)//item)"/>
    <!-- President's and Dean's Lists -->
    <xsl:template match="XML" mode="namelist">
        <xsl:variable name="columns" select="2"/>
        <xsl:variable name="ct" select="count(PresidentsList|DeansList) div $columns"/>
        <xsl:variable name="cols" select="round($ct)"/>
        <h2><xsl:value-of select="//@TERM_DESC"/> Semester</h2>
         <div class="doscol">
             <xsl:for-each select="PresidentsList|DeansList">
                <!-- <xsl:value-of select="position()"/> -->
                <div class="item" id="{position()}">
                    <xsl:value-of select="@FIRST_NAME"/><xsl:text> </xsl:text>
                    <xsl:if test="@MIDDLE_INITIAL"><xsl:value-of select="@MIDDLE_INITIAL"/><xsl:text>. </xsl:text></xsl:if>
                    <xsl:value-of select="@LAST_NAME"/>
                    <xsl:if test="@NAME_SUFFIX"><xsl:text> </xsl:text><xsl:value-of select="@NAME_SUFFIX"/></xsl:if>
                </div>
             </xsl:for-each>
         </div>
         <br clear="all"/>
    </xsl:template>
    <!-- Donor Society with various membership levels -->
    <xsl:template match="Header" mode="fiatlux">
    	<div class="trescol accordion" id="accordion">
    		<xsl:variable name="heading"><xsl:value-of select="@FLS_LEVEL"/></xsl:variable>
            <xsl:variable name="exception">President</xsl:variable>
            <xsl:variable name="apostrophe"><xsl:choose><xsl:when test="position() != 1">'s</xsl:when><xsl:otherwise>s'</xsl:otherwise></xsl:choose></xsl:variable>
    		<h3 class="society">View <xsl:value-of select="@FLS_LEVEL"/><xsl:choose><xsl:when test="position() != 1">s'</xsl:when><xsl:otherwise>'s</xsl:otherwise></xsl:choose> Circle Donors</h3>
    		<div class="donors">
				<xsl:for-each select="Detail">
					<div class="itemcol"><xsl:value-of select="@GS_NAME"/></div>
				</xsl:for-each>
            </div>
        </div>
    </xsl:template>
    <!-- Donor Society with one membership level -->
    <xsl:template match="XML" mode="societies">
    	<xsl:choose>
			<xsl:when test="Header[@FLS_LEVEL != '']">
				<xsl:apply-templates mode="fiatlux" select="Header"/>
			</xsl:when>
			<xsl:otherwise>
				<div class="trescol accordion" id="accordion">
                    <xsl:for-each select="Header">
                        <xsl:variable name="society"><xsl:value-of select="translate(@SOCIETY_GROUP, $ucletters, $lcletters)"/> Society</xsl:variable>
    					<h3 class="society">View <xsl:value-of select="$society"/> Donors</h3>
    					<div class="donors">
    						<xsl:for-each select="Detail">
    							<div class="itemcol"><xsl:value-of select="@GS_NAME"/></div>
    						</xsl:for-each>
    					</div>
                    </xsl:for-each>
				</div>
			</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Parents: Grouped by alphabet. Checks if there are members whose last name starts with each letter. jQueryUI accordion used to collapse groups. -->
    <xsl:template match="XML" mode="parent-donors">
        <xsl:variable name="i">1</xsl:variable>
        <xsl:variable name="letterCount"><xsl:value-of select="count(exslt:node-set($alpha)//item)"/></xsl:variable>
        <xsl:variable name="elements"><xsl:value-of select="Detail"/></xsl:variable>
        <xsl:variable name="dCount"><xsl:value-of select="count(Detail)"/></xsl:variable>
        <select id="ddlink">
            <xsl:for-each select="exslt:node-set($alpha)//item">
                <option value="#{.}"><xsl:value-of select="."/></option>
            </xsl:for-each>
        </select>
        <div class="trescol accordion" id="accordion">
            <xsl:call-template name="alphaLoop">
                <xsl:with-param name="letteri" select="$i"/>
                <xsl:with-param name="length" select="$letterCount"/>
                <xsl:with-param name="dLength" select="$dCount"/>
            </xsl:call-template>
        </div>  
    </xsl:template>
    <xsl:template match="Detail" name="alphaLoop">
        <xsl:param name="letteri"/>
        <xsl:param name="length"/>
        <xsl:param name="dLength"/>
        <xsl:variable name="dAlphaCount">
            <xsl:value-of select="count(*[starts-with(translate(@LAST_NAME,$lcletters,$ucletters), exslt:node-set($alpha)//item[$letteri])])"/>
        </xsl:variable>
        <xsl:if test="$letteri &lt;= $length">
            <xsl:if test="$dAlphaCount &gt; 0">
            	<h2 data-groupcount="{$dAlphaCount}" id="{exslt:node-set($alpha)//item[$letteri]}"><xsl:value-of select="exslt:node-set($alpha)//item[$letteri]"/></h2>
            	<div class="donors">
                    <xsl:apply-templates mode="alpha" select="Detail">
                        <xsl:with-param name="letteri"><xsl:value-of select="$letteri"/></xsl:with-param>
                        <xsl:with-param name="currLetter"><xsl:value-of select="exslt:node-set($alpha)//item[$letteri]"/></xsl:with-param>
                        <xsl:sort case-order="upper-first" data-type="text" order="ascending" select="@LAST_NAME"/> 
                    </xsl:apply-templates>
                </div>
            </xsl:if>
            <xsl:call-template name="alphaLoop">
                <xsl:with-param name="letteri" select="$letteri + 1"/>
                <xsl:with-param name="length" select="$length"/>
                <xsl:with-param name="dLength" select="$dLength - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="Detail" mode="alpha">
        <xsl:param name="letteri"/>
        <xsl:param name="currLetter"/>
            <xsl:if test="self::node()[starts-with(translate(@LAST_NAME,$lcletters,$ucletters), $currLetter)]">
                <div class="itemcol"><xsl:value-of select="@GS_NAME"/></div>
            </xsl:if>
    </xsl:template>
    <!-- Alumni donors. Arranged by class year and collapsed with jQueryUI -->
    <xsl:template match="XML" mode="alumni-donors">
        <xsl:variable name="firstyear" select="@PREF_CLASS"/>
        <select id="ddlink">
            <xsl:for-each select="Header">
                <option value="#{@PREF_CLASS_2}"><xsl:value-of select="@PREF_CLASS_2"/></option>
            </xsl:for-each>
        </select>
        <div class="trescol accordion" id="accordion">
            <xsl:for-each select="Header">
                <h3 id="{@PREF_CLASS_2}">Class of <xsl:value-of select="@PREF_CLASS_2"/></h3>
                    <div class="donors">
                        <xsl:for-each select="Detail">
                            <p><xsl:value-of select="@NAME"/></p>
                        </xsl:for-each>
                    </div>
            </xsl:for-each>
        </div>
    </xsl:template>
 </xsl:stylesheet>