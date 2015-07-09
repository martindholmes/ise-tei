<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Mar 23, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>The purpose of this transformation is to take an ODD file which covers everything
      required for encoding ISE texts, and from it, to generate simpler versions used at various 
      stages of encoding.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" exclude-result-prefixes="#all"/>
  
  
<!--  We can supply a file which has already been given a particDesc as input to create the values for @who. -->
  <xsl:param name="sourceParticDescFile" as="xs:string"/>
  <xsl:variable name="sourceParticDesc" as="element(particDesc)*" select="if (string-length($sourceParticDescFile) gt 0) then doc($sourceParticDescFile)//particDesc else ()"/>
  
  <xsl:variable name="includes" select="doc('includes.xml')"/>
  
  <xsl:template match="/">
    <xsl:result-document href="schemas/ise.odd" encoding="UTF-8" indent="yes" exclude-result-prefixes="#all">
      <xsl:apply-templates/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="moduleRef[@key='gaiji']" exclude-result-prefixes="#all">
    <xsl:copy-of select="." exclude-result-prefixes="#all" copy-namespaces="no"/>
    
    <elementSpec ident="g" module="gaiji" mode="change">
      <attList>
        <attDef ident="rendition" mode="delete"/>
        <attDef ident="style" mode="delete"/>
        <attDef ident="type" mode="delete"/>
        <attDef ident="ref" mode="replace" usage="req">
          <valList type="closed">
            <xsl:for-each select="$includes//charDecl/*">
              <xsl:sort select="@xml:id" data-type="text"/>
              <valItem ident="{concat('ise:', @xml:id)}">
                <gloss><xsl:value-of select="glyphName"/>
                <xsl:if test="mapping"><xsl:text> (</xsl:text><xsl:value-of select="mapping"/><xsl:text>)</xsl:text></xsl:if></gloss>
              </valItem>
            </xsl:for-each>
          </valList>
        </attDef>
      </attList>
    </elementSpec>
  </xsl:template>
  
  <xsl:template match="moduleRef[@key='core']">
    <xsl:copy-of select="." exclude-result-prefixes="#all" copy-namespaces="no"/>
    <elementSpec ident="sp" module="core" mode="change">
      <attList>
        <attDef ident="who" mode="replace" usage="req">
          <datatype minOccurs="1" maxOccurs="unbounded">
            <ref xmlns="http://relaxng.org/ns/structure/1.0" name="data.enumerated"/>
          </datatype>
          <valList type="closed">
            <xsl:choose>
              <xsl:when test="$sourceParticDesc">
                <xsl:variable name="playPrefix" select="$sourceParticDesc/ancestor::TEI/@xml:id"/>
                <xsl:for-each select="$sourceParticDesc/listPerson/person[@xml:id]">
                  <xsl:sort select="@xml:id"/>
                  <valItem ident="#{@xml:id}">
                    <gloss><xsl:for-each select="persName/node()">
                      <xsl:apply-templates mode="castRendering" select="."/>
                    </xsl:for-each></gloss>
                  </valItem>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$includes//castItem">
                  <xsl:sort select="@xml:id"/>
                  <valItem ident="ise:{@xml:id}">
                    <gloss><xsl:value-of select="role"/></gloss>
                  </valItem>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
            
          </valList>
        </attDef>
      </attList>
    </elementSpec>
  </xsl:template>
  
  <xsl:template match="persName/node()" mode="castRendering">
    <xsl:if test="preceding-sibling::node()"><xsl:text> (</xsl:text></xsl:if>
    <xsl:value-of select="."/>
    <xsl:if test="preceding-sibling::node()"><xsl:text>) </xsl:text></xsl:if>
  </xsl:template>
  
  <!-- Let's add in some formatting help. -->
  <xsl:template match="processing-instruction()" mode="#all">
    <xsl:text>
</xsl:text>
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="TEI" mode="#all">
    <xsl:text>
</xsl:text>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Copy everything else as-is. -->
  <xsl:template match="@*|node()" priority="-1" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>