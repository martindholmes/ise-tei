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
      <xd:p><xd:b>Created on:</xd:b> Mar 26, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>The purpose of this transform is to start from a richly-encoded version
      of a play fragment encoded according to the ise_full schema, and generate simpler
      versions of it by stripping out elements and attributes not used in the intermediate and
      basic schemas.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:param name="targetSchema" select="'ise:basic'"/>
  
  <xsl:template match="TEI" mode="#all">
    <xsl:text>
</xsl:text>
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="rend" select="$targetSchema"/>
      <xsl:choose>
        <xsl:when test="$targetSchema = 'ise:basic'">
          <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()" mode="basic"/>
        </xsl:when>
        <xsl:when test="$targetSchema = 'ise:intermediate'">
          <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()" mode="intermediate"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@rend" mode="#all"/>
  
<!--  Strip out persName and placeName in simpler schemas. -->
  <xsl:template match="persName | placeName" mode="basic intermediate">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="lb[@type='tln']" mode="basic intermediate"/>
  
  <xsl:template match="@who" mode="basic intermediate"/>
  
  <xsl:template match="@rendition" mode="basic"/>
  
  <xsl:template match="g | hi | lb" mode="basic"><xsl:apply-templates mode="#current"/></xsl:template>
  
  <!-- Let's add in some formatting help. -->
  <xsl:template match="processing-instruction()" mode="#all">
    <xsl:text>
</xsl:text>
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- Copy everything else as-is. -->
  <xsl:template match="@*|node()" priority="-1" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>