<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs math xd"
  xmlns:hcmc="http://hcmc.uvic.ca/ns"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 10, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>This transformation generates an ISE pseudo-SGML (ISGML) document from a TEI source.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <!--<xsl:strip-space elements="*"/>-->
  <xsl:output method="text" encoding="UTF-8"  />
  
  <xsl:variable name="includes" select="doc('includes.xml')"/>
  
  
<!--  This maps each TEI Simple style designator to an equivalent 
      tag in ISGML. It's OK to return a tag name + space + attributes;
      the consuming function will handle creating the correct opening 
      and closing ISGML tags. -->
  <xsl:variable name="simpleStyles" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'simple:allcaps'" select="''"/>
      <xsl:map-entry key="'simple:blackletter'" select="'BLL'"/>
      <xsl:map-entry key="'simple:bold'" select="''"/>
      <xsl:map-entry key="'simple:bottombraced'" select="''"/>
      <xsl:map-entry key="'simple:boxed'" select="''"/>
      <xsl:map-entry key="'simple:centre'" select="'C'"/>
      <xsl:map-entry key="'simple:cursive'" select="''"/>
      <xsl:map-entry key="'simple:display'" select="''"/>
      <xsl:map-entry key="'simple:doublestrikethrough'" select="''"/>
      <xsl:map-entry key="'simple:doubleunderline'" select="''"/>
      <!--<xsl:map-entry key="'simple:dropcap'" select="''"/>--> <!-- handled by ORNAMENT element -->
      <xsl:map-entry key="'simple:float'" select="''"/>
      <xsl:map-entry key="'simple:hyphen'" select="''"/>
      <xsl:map-entry key="'simple:inline'" select="''"/>
      <xsl:map-entry key="'simple:italic'" select="'I'"/>
      <xsl:map-entry key="'simple:justify'" select="'J'"/>
      <xsl:map-entry key="'simple:larger'" select="''"/> <!-- Not sure what to do here; there is FONTGROUP but requires numbers. -->
      <xsl:map-entry key="'simple:left'" select="''"/>
      <xsl:map-entry key="'simple:leftbraced'" select="''"/>
      <xsl:map-entry key="'simple:letterspace'" select="'LS'"/>
      <xsl:map-entry key="'simple:normalstyle'" select="'R'"/>
      <xsl:map-entry key="'simple:normalweight'" select="''"/>
      <xsl:map-entry key="'simple:right'" select="'RA'"/>
      <xsl:map-entry key="'simple:rightbraced'" select="''"/>
      <xsl:map-entry key="'simple:rotateleft'" select="''"/>
      <xsl:map-entry key="'simple:rotateright'" select="''"/>
      <xsl:map-entry key="'simple:smallcaps'" select="'SC'"/>
      <xsl:map-entry key="'simple:smaller'" select="''"/>
      <xsl:map-entry key="'simple:strikethrough'" select="''"/>
      <xsl:map-entry key="'simple:subscript'" select="'SUB'"/>
      <xsl:map-entry key="'simple:superscript'" select="'SUP'"/>
      <xsl:map-entry key="'simple:topbraced'" select="''"/>
      <xsl:map-entry key="'simple:typewriter'" select="''"/>
      <xsl:map-entry key="'simple:underline'" select="''"/>
      <xsl:map-entry key="'simple:wavyunderline'" select="''"/>
    </xsl:map>
  </xsl:variable>  
  
  <xsl:template match="/">
    <xsl:variable name="phaseOne">&lt;work&gt;
    <xsl:apply-templates/>
    &lt;/work&gt;</xsl:variable>
    <xsl:value-of select="hcmc:postProcessTextOutput($phaseOne)"/>
  </xsl:template>
  
  
<!-- We haven't actually looked at the header yet. Much more to do here. -->
  <xsl:template match="teiHeader">
    &lt;iseHeader&gt;
     <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/iseHeader&gt;
  </xsl:template>
  
  <xsl:template match="text">
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
<!--   Close any open PAGE or COL elements. -->
    <xsl:if test="descendant::*[self::pb|self::cb][last()][self::cb]">
      &lt;/COL&gt;
    </xsl:if>
    <xsl:if test="descendant::pb">
      &lt;/PAGE&gt;
    </xsl:if>
    <xsl:if test="//div[@type='act']">
      &lt;/MODE&gt;
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="front">
    &lt;FRONTMATTER&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/FRONTMATTER&gt;
  </xsl:template>
  
  <xsl:template match="back">
    &lt;BACKMATTER&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/BACKMATTER&gt;
  </xsl:template>
  
  <xsl:template match="docTitle">
    &lt;TITLEHEAD&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/TITLEHEAD&gt;
  </xsl:template>
  
<!--  Forme works of various kinds. -->
  <xsl:template match="fw[@type='header']">
    &lt;RT&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/RT&gt;
  </xsl:template>
  
  <xsl:template match="fw[@type='title']">
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
  </xsl:template>
  
  <xsl:template match="fw[@type='pageNum']">
    &lt;PN&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/PN&gt;
  </xsl:template>
  
  <xsl:template match="fw[@type='footer']">
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
  </xsl:template>
  
  <xsl:template match="fw[@type='sig']">
    &lt;SIG&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/SIG&gt;
  </xsl:template>
  
  <xsl:template match="fw[@type='catch']">
    &lt;CW&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/CW&gt;
  </xsl:template>
  
  <!--  Things which are milestones in TEI and containers in ISGML. -->
  <!--  We try to avoid numbering things in TEI where it's not necessary. -->
  <xsl:template match="pb">
    <xsl:if test="preceding::*[self::cb | self::pb][1][self::cb[not(@type='fullWidth')]]">
      &lt;/COL&gt;
    </xsl:if>
    <xsl:if test="preceding::pb">
    &lt;/PAGE&gt;
    </xsl:if>
    &lt;PAGE n="<xsl:value-of select="if (@n) then @n else count(preceding::pb) + 1"/>"&gt;

  </xsl:template>
  
  <xsl:template match="cb[@type='fullWidth']">
    <xsl:if test="preceding::*[self::cb | self::pb][1][self::cb[not(@type='fullWidth')]]">
      &lt;/COL&gt;
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="cb[not(@type)]">
    <xsl:if test="preceding::*[self::cb | self::pb][1][self::cb[not(@type='fullWidth')]]">
      &lt;/COL&gt;
    </xsl:if>
      &lt;COL n="<xsl:value-of select="if (@n) then @n else if (preceding::*[self::cb | self::pb][1][self::pb or self::cb[@type='fullWidth']]) then '1' else '2'"/>"&gt;
  </xsl:template>
  
  <xsl:template match="lb[@type='tln']">&lt;TLN n="<xsl:value-of select="@n"/>"/&gt;</xsl:template>
  
<!-- These things are very weird: the <L/> element is used for an empty line 
     in some very specific circumstances. -->
  <xsl:template match="lb[not(@type) and (not(ancestor::*[local-name() = ('p', 'stage')]) or (ancestor::*[local-name() = ('p', 'stage')] and not(following-sibling::*|following-sibling::text())))]">
    &lt;L/&gt;
  </xsl:template>
  
<!--  Major divisions -->
  <xsl:template match="div[@type='prologue']">
    &lt;DIV name="Prologue"&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/DIV&gt;
  </xsl:template>
  
  <xsl:template match="div[@type='epilogue']">
    &lt;DIV name="Epilogue"&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/DIV&gt;
  </xsl:template>
  
  <xsl:template match="div[@type='act']">
    &lt;ACT n="<xsl:value-of select="count(preceding::div[@type='act']) + 1"/>"&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/ACT&gt;
  </xsl:template>
  
  <xsl:template match="div[@type='scene']">
    &lt;SCENE n="<xsl:value-of select="count(preceding-sibling::div[@type='scene']) + 1"/>"&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/SCENE&gt;
  </xsl:template>
  
  <xsl:template match="head">
    &lt;LD&gt;
    <xsl:call-template name="hcmc:realizeAncestorRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/LD&gt;
  </xsl:template>
  
  <xsl:template match="sp">
    &lt;S&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/S&gt;
  </xsl:template>
  
  <xsl:template match="speaker">
    &lt;SP norm="<xsl:value-of select="$includes//castItem[@xml:id=substring-after(current()/ancestor::sp[1]/@who, 'ise:')]/role"/>"&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/SP&gt;
  </xsl:template>
  
  <xsl:template match="stage">
    &lt;SD t="<xsl:value-of select="@type"/>"&gt;
    <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
    &lt;/SD&gt;
  </xsl:template>
  
  <xsl:template match="g">
    <xsl:value-of select="$includes//glyph[@xml:id=substring-after(current()/@ref, 'ise:')]/mapping[@type='isgml']"/>
  </xsl:template>
  
<!-- We match <l> and <p> in speeches not because they should appear in the output but because the
    style in effect is normally realized at this level, not at the higher level where it makes more sense. 
    We also have to look out for mode changes (between verse and prose). -->
  <xsl:template match="*[self::p or self::l or self::ab][ancestor::sp or ancestor::div[@type=('prologue', 'epilogue')]]">
    <xsl:variable name="thisTag" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="preceding::*[self::p or self::l or self::ab][ancestor::sp or ancestor::div[@type=('prologue', 'epilogue')]]">
        <xsl:variable name="precedingTag" select="preceding::*[self::p or self::l or self::ab][ancestor::sp or ancestor::div[@type=('prologue', 'epilogue')]][1]/local-name()"/>
        <xsl:if test="$thisTag != $precedingTag">
          &lt;/MODE&gt;
          &lt;MODE t="<xsl:value-of select="if ($thisTag = 'l') then 'verse' else if ($thisTag = 'p') then 'prose' else 'uncertain'"/>"&gt;
        </xsl:if>
    </xsl:when>
      <xsl:otherwise>
        &lt;MODE t="<xsl:value-of select="if ($thisTag = 'l') then 'verse' else if ($thisTag = 'p') then 'prose' else 'uncertain'"/>"&gt;
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:call-template name="hcmc:realizeAncestorRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>
  </xsl:template>
  
  <xsl:template name="hcmc:processRendition">
    <xsl:param name="parentEl" as="element()"/>
    <xsl:variable name="styleTagNames" select="if ($parentEl/@rendition) then hcmc:getStyleTagNames($parentEl) else ()" as="xs:string*"/>
    <xsl:for-each select="$styleTagNames">
      &lt;<xsl:value-of select="."/>&gt;
    </xsl:for-each>
        <xsl:apply-templates select="$parentEl/*|text()"/>
    <xsl:for-each select="reverse($styleTagNames)">
      &lt;/<xsl:value-of select="replace(., ' .*', '')"/>&gt;
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="hcmc:realizeAncestorRendition">
    <xsl:param name="parentEl" as="element()"/>
    <xsl:variable name="isItalic" as="xs:boolean" select="hcmc:isAncestorItalic($parentEl)"/>
    <xsl:variable name="align" as="xs:string" select="hcmc:ancestorAlignmentTag($parentEl)"/>
    <xsl:value-of select="if (string-length($align) gt 0) then concat('&lt;', $align, '&gt;') else ''"/>
    <xsl:value-of select="if ($isItalic) then '&lt;I&gt;' else ''"/>
      <xsl:choose>
        <xsl:when test="$parentEl/self::p or $parentEl/self::l">
          <xsl:apply-templates select="$parentEl/(*|text())"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="$parentEl"/></xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    <xsl:value-of select="if ($isItalic) then '&lt;/I&gt;' else ''"/>
    <xsl:value-of select="if (string-length($align) gt 0) then concat('&lt;/', $align, '&gt;') else ''"/>
  </xsl:template>
  
<!--  Style-related stuff. -->
  <xsl:template match="hi[contains(@rendition, 'simple:dropcap')]">&lt;ORNAMENT drop="<xsl:value-of select="if (@n) then @n else 3"/>"&gt;<xsl:call-template name="hcmc:processRendition"><xsl:with-param name="parentEl" select="."/></xsl:call-template>&lt;/ORNAMENT&gt;</xsl:template>
  
  <xsl:function name="hcmc:getStyleTagNames" as="xs:string*">
    <xsl:param name="el" as="element()"/>
    <xsl:variable name="renditionVals" select="for $r in tokenize(normalize-space($el/@rendition), '\s+') return $simpleStyles($r)"/>
    <xsl:choose>
      <xsl:when test="$el/descendant::p or $el/descendant::l">
<!--     Some styles apparently have to be rendered at the level of lines or paras.   -->
        <!--<xsl:message>Should not be outputting line-level styles for <xsl:value-of select="$el/local-name()"/>. <xsl:value-of select="$renditionVals"/></xsl:message>-->
        <xsl:sequence select="for $r in $renditionVals return if (not($r=('', 'I', 'J', 'C', 'RA'))) then $r else ()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$renditionVals[not(.='')]"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
<!-- Is italicization in force from the element itself or inherited from any of its parents? -->
  <xsl:function name="hcmc:isAncestorItalic" as="xs:boolean">
    <xsl:param name="el" as="element()"/>
    <xsl:choose>
      <xsl:when test="$el/ancestor-or-self::*[@rendition[matches(., '(simple:italic)|(simple:normalstyle)')]]">
        <xsl:value-of select="$el/ancestor-or-self::*[@rendition[matches(., '(simple:italic)|(simple:normalstyle)')]][1]/matches(@rendition, 'simple:italic')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
<!-- Is there a need for an alignment tag here? The options are <C>, <RA> and <J>. -->
  <xsl:function name="hcmc:ancestorAlignmentTag" as="xs:string">
    <xsl:param name="el" as="element()"/>
    <xsl:choose>
      <xsl:when test="$el/ancestor-or-self::*[@rendition[matches(., '(simple:centre)|(simple:left)|(simple:right)|(simple:justify)')]]">
        <xsl:variable name="ancestorEl" select="$el/ancestor-or-self::*[@rendition[matches(., '(simple:centre)|(simple:left)|(simple:right)|(simple:justify)')]][1]"/>
        <xsl:choose>
          <xsl:when test="$ancestorEl/matches(@rendition, 'simple:right')">RA</xsl:when>
          <xsl:when test="$ancestorEl/matches(@rendition, 'simple:justify')">J</xsl:when>
          <xsl:when test="$ancestorEl/matches(@rendition, 'simple:centre')">C</xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$el/ancestor-or-self::*[@rendition[matches(., '(simple:italic)|(simple:normalstyle)')]][1]/matches(@rendition, 'simple:italic')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
<!-- This function is designed to clean up some artifacts of the output 
     rendering, most particularly sequences of carriage-returns. -->
  <xsl:function name="hcmc:postProcessTextOutput" as="xs:string">
    <xsl:param name="input" as="xs:string"/>
    <xsl:value-of select="
      replace(
      replace($input, '\s*\n\s*\n\s*', '&#x0a;'),
      '[ \t]+(&lt;(TLN|QLN))', '$1')"/>
  </xsl:function>
  
</xsl:stylesheet>