# Rosters, Honor Rolls, and Name Lists
XSLT 1.0 formats primarily for Cascade Server. The original XML was created and maintained by Argos (A Reporting Tool for Banner). 

## XML Example
XML tags and attributes were not always consistently or appropriately named. Case was also inconsistent. 

One structure resembled this (names and sensitive information have been scrubbed)...
```
<XML>
	<Header PREF_CLASS_2="2015">
		<Detail NAME="Jane A. Doe" PREF_CLASS="2015"/>
		<Detail NAME="John A. Doe" PREF_CLASS="2015"/>
		...
	</Header>
	...
</XML>
```
Another example...
```
<XML>
	<Header SOCIETY_GROUP="Gold" SOCIETY_ORDER="1">
		<Detail GS_NAME="Jane A. Doe `00 `03MBA" LAST_NAME="Doe"/>
		<Detail GS_NAME="John A. Doe `02" LAST_NAME="Doe"/>
		...
	</Header>
	...
</XML>
```


## XSLT Template Chooser
Unique attributes or tags can be used in choosing the correct template. If the XML is too generic, use the XML Feed Block asset name.

```
<xsl:choose>
	<!-- All honor rolls are listed the same way -->
	<xsl:when test="XML/DeansList or XML/PresidentsList">
		<xsl:apply-templates mode="namelist" select="XML"/>
	</xsl:when>
	<!-- @PREF_CLASS is unique to alumni -->
	<xsl:when test="XML and XML[@PREF_CLASS != '']">
		<xsl:apply-templates mode="alumni-donors" select="XML"/>
	</xsl:when>
	<!-- feed block system name -->
	<xsl:when test="XML and contains(../name,'parents-honor-roll')">
		<xsl:apply-templates mode="parent-donors" select="XML"/>
	</xsl:when>
	<xsl:otherwise/>
</xsl:choose>
```

