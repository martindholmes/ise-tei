<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="#all"
  xmlns:s="http://internetshakespeare.uvic.ca/#semantic-markup"
  xmlns:p="http://internetshakespeare.uvic.ca/#pagesetting-markup"
  xmlns:t="http://internetshakespeare.uvic.ca/#typesetting-markup"
  xmlns:a="http://internetshakespeare.uvic.ca/#annotative-markup"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:hcmc="http://hcmc.uvic.ca/ns"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 22, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>The purpose of this stylesheet is to convert the ISE XML
      rendering (multiple-namespace ISE-custom XML) into a standard 
      TEI file conforming with the schema we're developing for encoding
      in TEI.</xd:p>
      <xd:p>This is an experimental stylesheet. The main objective is
      to learn about equivalences between ISE encoding and TEI, and to 
      provide test files in TEI which can be used to develop the schemas
      and to test the corresponding conversion (TEI to ISGML).</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" encoding="UTF-8" exclude-result-prefixes="#all" xml:space="preserve" indent="yes" />
  
  <xsl:template match="/">
<!--   First we convert the header, piece by piece, based on best-fit from the existing text. -->
    <TEI xmlns="http://www.tei-c.org/ns/1.0" rend="ise:full">
      <teiHeader>
        <fileDesc>
          <titleStmt>
            <title type="main"><xsl:value-of select="//meta[@name='DC.Title']/@content"/></title>
            <xsl:if test="//meta[@name='DC.Title.Alternative']">
              <title type="alt"><xsl:value-of select="//meta[@name='DC.Title.Alternative']/@content"/></title>
            </xsl:if>
            <xsl:if test="//meta[@name='DC.Descriptions']">
              <title type="sub"><xsl:value-of select="//meta[@name='DC.Description']/@content"/></title>
            </xsl:if>
            <xsl:for-each select="//meta[starts-with(@name, 'DC.Contributor')]">
              <respStmt>
                <resp><xsl:value-of select="@name"/></resp>
                <name><xsl:value-of select="@content"/></name>
              </respStmt>
            </xsl:for-each>
            
          </titleStmt>
          <editionStmt><p><xsl:value-of select="//meta[@name='DC.Subject']/@content"/></p></editionStmt>
          <publicationStmt>
            <publisher><xsl:value-of select="//meta[@name='DC.Publisher']/@content"/></publisher>
            <xsl:for-each select="//meta[starts-with(@name, 'DC.Date')]">
              <date when="{@content}"><xsl:if test="substring-after(@name, 'DC.Date.')"><xsl:attribute name="type" select="substring-after(@name, 'DC.Date.')"/></xsl:if></date>
            </xsl:for-each>
            <xsl:for-each select="//meta[@name='DC.Identifier']">
              <idno type="{@scheme}"><xsl:value-of select="@content"/></idno>
            </xsl:for-each>
          </publicationStmt>
          <xsl:if test="//meta[@name='ISE.comment'] or //meta[starts-with(@name, 'DC.Relation')]">
            <notesStmt>
              <xsl:for-each select="//meta[@name='ISE.comment']">
                <note>
                  <xsl:value-of select="@content"/>
                </note>
              </xsl:for-each>
              <xsl:for-each select="//meta[starts-with(@name, 'DC.Relation')]">
                <relatedItem type="{@name}"><xsl:choose><xsl:when test="matches(@content, '^\s*[a-z]+://')"><xsl:attribute name="target" select="@content"/></xsl:when>
                <xsl:otherwise>
                  <bibl><xsl:value-of select="@content"/></bibl>
                </xsl:otherwise></xsl:choose></relatedItem>
              </xsl:for-each>
            </notesStmt>
          <sourceDesc><p>
              <xsl:value-of select="//meta[@name='ISE.SourceFormat']/@content"/>
            </p>
            <p>
            <xsl:value-of select="//meta[@name='ISE.PublishingHistory']/@content"/>
          </p>
          </sourceDesc>
          </xsl:if>
        </fileDesc>
        <profileDesc>
          <textClass>
            <xsl:if test="//meta[@name='ISE.PeerReviewed'][@content='Yes']">
              <catRef target="ise:PeerReviewed"/>
            </xsl:if>
            <xsl:for-each select="//meta[@name='ISE.DocumentType']">
              <catRef target="ise:DocumentType{hcmc:upperFirst(@content)}"/>
            </xsl:for-each>
            <xsl:for-each select="//meta[@name='ISE.DocumentClass']">
              <catRef target="ise:DocumentClass{hcmc:upperFirst(@content)}"/>
            </xsl:for-each>
            <xsl:for-each select="//meta[@name='ISE.WorkClass']">
              <catRef target="ise:WorkClass{hcmc:upperFirst(@content)}"/>
            </xsl:for-each>
            <xsl:for-each select="//meta[@name='ISE.Type']">
              <catRef target="ise:Type{hcmc:upperFirst(@content)}"/>
            </xsl:for-each>
            <xsl:for-each select="//meta[starts-with(@name, 'DC.Type')]">
              <catRef target="{@name}.{hcmc:upperFirst(@content)}"/>
            </xsl:for-each>
          </textClass>
        </profileDesc>
        <encodingDesc>
          <editorialDecl>
            <xsl:for-each select="//meta[@name='ISE.EditorialPrinciple']">
              <p><xsl:value-of select="@content"/></p>
            </xsl:for-each>
          </editorialDecl>
        </encodingDesc>
        <revisionDesc status="{//meta[@name='ISE.EditStatus']/@content}">
          <change who="mol:HOLM3" when="{format-date(current-date(), '[Y0001]-[M01]-[D01]')}">This file created by conversion of <xsl:value-of select="document-uri(.)"/>.</change>
        </revisionDesc>
      </teiHeader>
      <text>
<!--  Now we handle everything else, which is an undifferentiated sequence of tags from different namespaces.      -->
<!--  We start by converting the hierarchy from one in which pages and columns rule to one based on a more 
        normal TEI conceptual hierarchy. -->
        <xsl:variable name="newHierarchy">
          <xsl:apply-templates select="work/*[not(self::iseheader)]" mode="changeHierarchy"/>
        </xsl:variable>
        
        <xsl:variable name="reconstituted">
          <xsl:apply-templates select="$newHierarchy" mode="reconstitute"/>
        </xsl:variable>
        <xsl:copy-of select="$reconstituted"/>
      </text>
    </TEI>
    
  </xsl:template>
  
<!-- Hierarchy-changing templates. -->
  <xsl:template match="p:page | t:col | a:mode" mode="changeHierarchy">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@n | @t"/>
    </xsl:copy>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
<!-- Reconstituting templates. -->
<!-- Match the first instance of a joinID and pull in content from what follows. -->
  <xsl:template match="s:*[following::*[@joinID = current()/@joinID]]" mode="reconstitute">
    <xsl:variable name="thisId" select="generate-id()"/>
    <xsl:variable name="thisEl" select="."/>
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'joinID')]"/>
      <xsl:apply-templates mode="#current"/>
      <xsl:for-each select="following::*[@joinID = current()/@joinID]">
        <xsl:apply-templates mode="#current" select="preceding::node()[preceding::*[generate-id() = $thisId]]"/>
        <xsl:apply-templates mode="#current" select="node()"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
<!-- All subsequent instances of the same joinID should be ignored when encountered. -->
  <xsl:template match="s:*[preceding::*[@joinID = current()/@joinID]]" mode="reconstitute"></xsl:template>
  
  
<!-- Regular conversion templates. -->
  <xsl:template match="s:act | s:scene">
    <div type="{local-name()}">
      <xsl:apply-templates mode="#current"/>
    </div>
  </xsl:template>
  
<!-- Speeches: @who may not be a valid QName, so for now we store it in @n. -->
  <xsl:template match="s:s">
    <sp n="s:sp/@norm">
      <xsl:apply-templates mode="#current"/>
    </sp>
  </xsl:template>
  
  <xsl:template match="s:sp">
    <speaker>
      <xsl:apply-templates mode="#current"/>
    </speaker>
  </xsl:template>
  
  <xsl:template match="a:ln">
    <xsl:choose>
      <xsl:when test="@tln"><lb type="tln" n="{@tln}"/></xsl:when>
      <xsl:when test="@qln"><lb type="qln" n="{@qln}"/></xsl:when>
      <xsl:otherwise><lb/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<!--  Lines. -->
  <xsl:template match="p:l">
    <l><xsl:apply-templates mode="#current"/></l>
  </xsl:template>
  
<!-- Forme works. -->
  <xsl:template match="p:rt">
    <fw type="header"><xsl:apply-templates mode="#current"/></fw>
  </xsl:template>
<!--  NOTE THAT WE OUGHT TO WRAP THE ACTUAL TITLE in fw type="title", but we may have 
  to do that in a second pass. -->
  <xsl:template match="p:pn">
    <fw type="pageNum"><xsl:apply-templates mode="#current"/></fw>
  </xsl:template>
  <xsl:template match="p:sig">
    <fw type="sig"><xsl:apply-templates mode="#current"/></fw>
  </xsl:template>
  <xsl:template match="p:cw">
    <fw type="catch"><xsl:apply-templates mode="#current"/></fw>
  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1" mode="changeHierarchy reconstitute">
    <xsl:copy select="." copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="hcmc:upperFirst" as="xs:string">
    <xsl:param as="xs:string" name="input"/>
    <xsl:value-of select="concat(upper-case(substring($input, 1, 1)), substring($input, 2))"/>
  </xsl:function>
  
</xsl:stylesheet>