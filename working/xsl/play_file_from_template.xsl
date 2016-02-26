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
      <xd:p><xd:b>Created on:</xd:b> July 9, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>This is an identity transform which turns a basic ISE template file
        into a play file with a specific id and title.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:param name="projectDirectory"/>
  <xsl:param name="playId"/>
  <xsl:param name="playTitle"/>
<!-- This isn't used at the moment, but we may find a purpose for it. -->
  <xsl:variable name="includes" select="doc('includes.xml')"/>
  
  <xsl:template match="/">
    <xsl:result-document href="{$projectDirectory}/{$playId}.xml">
      <xsl:apply-templates/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="titleStmt/title">
    <title><xsl:value-of select="$playTitle"/></title>
  </xsl:template>
  
  <xsl:template match="change">
    <change when="{format-date(current-date(), '[Y0001]-[M01]-[D01]')}">
      Created this file from the ISE template based on user input.
    </change>
  </xsl:template>
  
  <xsl:template match="TEI" mode="#all">
    <xsl:text>
</xsl:text>
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="rend" select="'ise'"/>
      <xsl:attribute name="xml:id" select="$playId"/>
      <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  

  
  <!-- Let's add in some formatting help. -->
  <xsl:template match="processing-instruction()" mode="#all">
    <xsl:text>
</xsl:text>
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- Copy everything else as-is. -->
  <xsl:template match="@*|node()" priority="-1" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>