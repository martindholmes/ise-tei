<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  version="2.0"
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:hcmc="http://hcmc.uvic.ca/ns"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:saxon="http://saxon.sf.net/">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Mar 26, 2015</xd:p>
      <xd:p><xd:b>Author:</xd:b> mholmes</xd:p>
      <xd:p>Creates a web page from an ISE play encoded in TEI.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xhtml" encoding="UTF-8" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>
  
  <xsl:variable name="includes" select="doc('includes.xml')"/>
  
  <xsl:template match="/">
    <xsl:variable name="docRoot" select="."/>
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html>
    </xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title><xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title"/></title>
        <style type="text/css">
          
          html, body{
            margin: 0;
            padding: 0;
            font-family: georgia, serif;
          }
          
          div.meta{
            float: left;
            width: 20em;
            padding: 1em;
            background-color: #d0d0ff;
            margin: 0;
            position: fixed;
          }
          
          table.stats, table.stats td{
            border: solid 1pt black;
            border-collapse: collapse;
          }
          
          table.stats td{
            padding: 0.2em;
            text-align: right;
          }
          
          table.stats thead td{
            font-weight: bold;
            text-align: center;
          }
          
          div.play{
            margin: 0 0 0 22em;
            padding: 1em;
            border: solid 1px black;
          }

          /* Elements in text. */
          
          div.front, div.body, div.back, div.div, div.sp, div.l, div.stage{
            display: block;
          }
          
          span.tln{
            display: none;
            font-size: 80%;
            margin-left: -3em;
            float: left;
          }
          
          span.tln.showing{
            display: block;
          }
          
          span.speaker{
            font-style: italic;
            padding: 0 2em;
          }
          
          /*The first l in a speech will follow the 
          speaker element, so it shouldn't be 
          block. */
          span.speaker + div.l{
            display: inline;
          }
          
          div.sp div.l::first-of-type{
            display: inline;
          }
          
          div.act, div.prologue, div.epilogue, div.scene{
            border-top: solid 1pt gray;
            border-bottom: solid 1pt gray;
            border-collapse: collapse;
            margin: 0;
            padding: 1em;
          }
          
          div.act, div.prologue, div.epilogue{
            padding-left: 4em;
          }
          
          div.scene:first-of-type, div.scene:last-of-type{
            border-width: 0;
          }
          
          div.docTitle{
            text-align: center;
            font-size: 300%;
          }
          
          h2, h3, h4, h5, h6{
            text-align: center;
          }
          
          div.stage{
            font-style: italic;
            margin: 1em 0;
          }
         
          /* Breaks. */
          
          cb[n="2"], pb{
          display: block;
          border-bottom: solid 1px black;
          }
          
          cb[n="2"]{
          width: 50%;
          margin-left: 25%;
          }
          
          /* Inline textual features. */
          span.gOld{
            display: none;
            background-color: #ffff00;
          }
          span.ligature{
            letter-spacing: -0.1em;
          }
          span.gModern{
          }
          
          *[class~="simple:allcaps"]{
            text-transform: capitalize;
          }
          
          *[class~="simple:blackletter"]{
            font-weight: bold;
            font-family: monospace;
          }
          
          *[class~="simple:bold"]{
            font-weight: bold;
          }
          
          *[class~="simple:bottombraced"]{
            text-decoration: underline;
          }
          
          *[class~="simple:boxed"]{
            border: solid 1pt black;
            padding: 0.2em;
          }
          
          *[class~="simple:centre"]{
            display: block;
            text-align: center;
          }
          
          *[class~="simple:cursive"]{
            font-family: cursive;
          }
          
          *[class~="simple:display"]{
            display: block;
          }
          
          *[class~="simple:doublestrikethrough"]{
            text-decoration: line-through;
          }
          
          *[class~="simple:doubleunderline"]{
            text-decoration: underline;
            border-bottom: double 1pt black;
          }
          
          *[class~="simple:dropcap"]{
            display: inline-block;
            float: left;
            font-size: 200%;
            vertical-align: top;
            padding: 0.25em;
            margin-right: 0.1em;
            border: solid 1pt black;
          }
          
          *[class~="simple:float"]{
            display: block;
            float: left;
          }
          
          *[class~="simple:hyphen"]{
            content: "-";
          }
          
          *[class~="simple:italic"]{
            font-style: italic;
          }
          
          *[class~="simple:larger"]{
            font-size: 120%;
          }
          
          *[class~="simple:leftbraced"]{
            border-left: solid 1pt black;
          }
          
          *[class~="simple:letterspace"]{
          letter-spacing: 1ex;
          }
          
          *[class~="simple:normalstyle"]{
            font-style: normal;
            font-weight: normal;
          }
          
          *[class~="simple:normalweight"]{
            font-weight: normal;
          }
          
          *[class~="simple:right"]{
            text-align: right;
          }
          
          *[class~="simple:rotateleft"]{
            background-color: #ffff00;
          }
          
          *[class~="simple:rotateright"]{
            background-color: #00ffff;
          }
          
          *[class~="simple:smallcaps"]{
            font-variant: small-caps;
          }
          
          [rendition~="simple:smaller"]{
            font-size: 80%;
          }
          
          *[class~="simple:strikethrough"]{
            text-decoration: line-through;
          }
          
          *[class~="simple:subscript"]{
            font-size: 70%;
            vertical-align: sub;
          }
          
          *[class~="simple:superscript"]{
            font-size: 70%;
            vertical-align: super;
          }
          
          *[class~="simple:topbraced"]{
            border-top: solid 1pt black;
          }
          
          *[class~="simple:typewriter"]{
            font-family: monospace;
          }
          
          *[class~="simple:underline"]{
            text-decoration: underline;
          }
          
          *[class~="simple:wavyunderline"]{
            text-decoration: underline;
          }
        </style>
        
        <script type="text/javascript">
<xsl:text disable-output-escaping="yes">
          function showHideGlyphs(sender){
            var olds = document.getElementsByClassName('gOld');
            var moderns = document.getElementsByClassName('gModern');
            var oldStyle = sender.checked? 'inline':'none';
            var modernStyle = sender.checked? 'none':'inline';
            for (var i=0; i&lt;olds.length; i++){
              olds[i].style.display = oldStyle;
            }
            for (var i=0; i&lt;moderns.length; i++){
              moderns[i].style.display = modernStyle;
            }
          }
</xsl:text>
        </script>
      </head>
      <body>
        <div class="meta">
          
          <form>
            <p style="text-indent: -2em; margin-left: 2em;"><input type="checkbox" onclick="showHideGlyphs(this)"/> Show ligatures and other special glyphs</p>
          </form>
          <h3>Stats</h3>
          <table class="stats">
            <tr>
              <td>Major divisions encoded:</td>
              <td><xsl:value-of select="count(//div[@type=('act', 'epilogue', 'prologue')])"/></td>
            </tr>
            <tr>
              <td>Scenes encoded:</td>
              <td><xsl:value-of select="count(//div[@type=('scene')])"/></td>
            </tr>
            <tr>
              <td>Speeches encoded:</td>
              <td><xsl:value-of select="count(//sp)"/></td>
            </tr>
            <tr>
              <td>Lines encoded:</td>
              <td><xsl:value-of select="count(//l)"/></td>
            </tr>
            <tr>
              <td>Special chars encoded:</td>
              <td><xsl:value-of select="count(//g)"/></td>
            </tr>
          </table>
          
          <xsl:if test="//sp[@who]">
            <h3>Speakers, speeches and lines</h3>
            <table class="stats">
              <thead>
                <tr>
                  <td>Speaker (id)</td>
                  <td>Speeches</td>
                  <td>Lines</td>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="$includes//castItem">
                  <xsl:sort select="role"/>
                  <xsl:variable name="thisCastItem" select="."/>
                  <xsl:variable name="whoVal" select="concat('ise:', $thisCastItem/@xml:id)"/>
                  <xsl:if test="$docRoot//sp[@who=$whoVal]">
                    <tr>
                      <td><xsl:value-of select="$thisCastItem/role"/> (<xsl:value-of select="$thisCastItem/@xml:id"/>)</td>
                      <td><xsl:value-of select="count($docRoot//sp[@who=$whoVal])"/></td>
                      <td><xsl:value-of select="count($docRoot//l[ancestor::sp[@who=$whoVal]])"/></td>
                    </tr>
                  </xsl:if>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:if>
        </div>
        
        <div class="play">
          <xsl:apply-templates select="TEI/text"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="front | body | back | docTitle | div | sp | l | stage">
    <div>
      <xsl:copy-of select="hcmc:processAtts(.)"/>
      <xsl:apply-templates select="@* | node()"/>
    </div>
  </xsl:template>
  
  <xsl:template match="head">
    <xsl:element name="h{count(ancestor::div) + 1}">
      <xsl:copy-of select="hcmc:processAtts(.)"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="speaker">
    <span class="speaker">
      <xsl:copy-of select="hcmc:processAtts(.)"/>
      <xsl:apply-templates select="@* | node()"/>
    </span>
  </xsl:template>
  
  <xsl:template match="hi">
    <span>
      <xsl:copy-of select="hcmc:processAtts(.)"/>
      <xsl:apply-templates select="@* | node()"/>
    </span>
  </xsl:template>
  
  <xsl:template match="lb">
    <br><xsl:copy-of select="hcmc:processAtts(.)"/></br>
  </xsl:template>
  
  <xsl:template match="lb[@type='tln']">
    <span class="tln{if (@n mod 5 = 0) then ' showing' else ''}"><xsl:value-of select="@n"/></span>
  </xsl:template>
  
  <xsl:template match="g[@ref]">
    <xsl:variable name="gId" select="substring-after(@ref, 'ise:')"/>
    <xsl:variable name="glyph" select="$includes//glyph[@xml:id=$gId]"/>
    <span class="g">
      <xsl:if test="$glyph">
        <xsl:attribute name="title">
          <xsl:value-of select="$glyph/glyphName"/>
          <xsl:if test="$glyph/mapping"> (<xsl:value-of select="$glyph/mapping[1]"/>)</xsl:if>
        </xsl:attribute>
        <xsl:if test="$glyph/mapping"><span class="gOld{if (contains($gId, 'igature')) then ' ligature' else ''}"><xsl:value-of select="$glyph/mapping[1]"/></span></xsl:if>
      </xsl:if>
      <span class="gModern"><xsl:apply-templates select="@* | node()"/></span>
    </span>
  </xsl:template>
  
  <xsl:template match="@who">
    <xsl:attribute name="title" select="$includes//castItem[@xml:id = substring-after(., 'ise:')]/role"/>
  </xsl:template>
  
<!-- Atts handled by function. -->
  <xsl:template match="@rendition | @style | @type"/>
  
  <xsl:function name="hcmc:processAtts" as="attribute()*">
    <xsl:param name="el"/>
    <xsl:attribute name="class"><xsl:value-of select="string-join(($el/local-name(), $el/@type, $el/@rendition), ' ')"/></xsl:attribute>
    <xsl:if test="$el/@style"><xsl:attribute name="style" select="$el/@style"/></xsl:if>
    <!--<xsl:if test="$el/self::l"><xsl:attribute name="title" select="concat('Line number ', xs:string(count($el/preceding::l) + 1))"/></xsl:if>-->
  </xsl:function>
  
  <xsl:template match="@*" priority="-1"/>
  
</xsl:stylesheet>