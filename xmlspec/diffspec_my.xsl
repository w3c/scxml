<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:h="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="h"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version="1.0">

<xsl:import href="diffspec.xsl"/>
  
<xsl:output
  method="xml"
  encoding="UTF-8"
  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  indent="no"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<!-- //////////////////////////////////////////////////////////// -->
<!-- borrowed from mathmlspec.xsl -->
<!-- Blocks -->
<xsl:template match="item/p" priority="1">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="def/p" priority="1">
  <xsl:apply-templates/>
</xsl:template>


<!-- kaz: don't generate extra <p>s around <graphic> -->
<!--                       graphic[not(@role='inline')])" /> -->
<xsl:template match="p">
  <xsl:apply-templates select="." mode="p">
    <xsl:with-param name="x" 
         select="count(eg|glist|olist|ulist|slist|orglist|
                       table|issue|note|processing-instruction())" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="p" match="p">
<xsl:param name="x"/>
  <!-- 2005.10.24 kazuyuki ==> -->
  <!-- add xmlns attribute -->
  <p xmlns="http://www.w3.org/1999/xhtml">
  <!-- 2005.10.24 kazuyuki <== -->
  <!-- kaz: remove extra <p>s around <graphic> -->
  <!--                     self::graphic[not(@role='inline')]) and -->
  <!--                             self::graphic[not(@role='inline')] ]) -->
  <xsl:apply-templates 
    select="node()[not(self::eg or self::glist or self::olist or
                       self::ulist or self::slist or self::orglist or
                       self::table or self::issue or self::note or
                       self::processing-instruction()) and
    count(following-sibling::*[self::eg or self::glist or self::olist or
                               self::ulist or self::slist or self::orglist or
                               self::table or self::issue or self::note or
                               self::processing-instruction()  ])
         = $x]" />
  </p>
  <!--              table|issue|note|processing-instruction()| -->
  <!--              graphic[not(@role='inline')]) -->
  <xsl:apply-templates
       select="(eg|glist|olist|ulist|slist|orglist|
                table|issue|note|processing-instruction())
                  [position() = last() - $x + 1]"/>
  <xsl:if test="$x &gt; 0">
    <xsl:apply-templates select="." mode="p">
      <xsl:with-param name="x" select="$x - 1" />
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>


<!-- maxf: we override the template in diffspec.xsl because it doesn't handle diff attributes in th and td -->
<xsl:template name="diff-markup">
  <xsl:param name="diff">off</xsl:param>
  <xsl:choose>
    <xsl:when test="ancestor::scrap">
      <!-- forget it, we can't add stuff inside tables -->
      <!-- handled in base stylesheet -->
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:when test="self::gitem or self::bibl">
      <!-- forget it, we can't add stuff inside dls; handled below -->
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:when test="ancestor-or-self::phrase">
      <span xmlns="http://www.w3.org/1999/xhtml" class="diff-{$diff}">
	<xsl:apply-imports/>
      </span>
    </xsl:when>
    <xsl:when test="ancestor::p and not(self::p)">
      <span xmlns="http://www.w3.org/1999/xhtml" class="diff-{$diff}">
	<xsl:apply-imports/>
      </span>
    </xsl:when>
    <xsl:when test="ancestor-or-self::affiliation">
      <span xmlns="http://www.w3.org/1999/xhtml" class="diff-{$diff}">
	<xsl:apply-imports/>
      </span>
    </xsl:when>
    <xsl:when test="ancestor-or-self::name">
      <span xmlns="http://www.w3.org/1999/xhtml" class="diff-{$diff}">
	<xsl:apply-imports/>
      </span>
    </xsl:when>

    <xsl:otherwise>
      <div xmlns="http://www.w3.org/1999/xhtml" class="diff-{$diff}">
	<xsl:apply-imports/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- maxf: redefine td/th template to handle diff markup properly (bug in xmlspec) -->
<xsl:template match="td|th" priority="1">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:for-each select="@*">
      <!-- Wait: some of these aren't HTML attributes after all... -->
      <xsl:choose>
        <xsl:when test="local-name(.) = 'role'">
          <xsl:attribute name="class">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="local-name(.) = 'diff'"/>
        <xsl:when test="local-name(.) = 'colspan' and . = 1"/>
        <xsl:when test="local-name(.) = 'rowspan' and . = 1"/>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <!-- maxf: if there are diff atributes, then put the content in a span and put the appropriate class -->
    <xsl:choose>
      <xsl:when test="@diff">
        <div  xmlns="http://www.w3.org/1999/xhtml" class="diff-{@diff}">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
  <!-- /maxf -->
</xsl:template>


<!-- kazuyuki: get date automatically if not specified -->
<xsl:variable name="now" select="date:date-time()"/>

<!-- day -->
<xsl:template match="pubdate/day">
<xsl:choose>
  <xsl:when test="self::node()[. !='']">
    <xsl:value-of select="."/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="date:day-in-month($now)"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- month -->
<xsl:template match="pubdate/month">
<xsl:choose>
  <xsl:when test="self::node()[. !='']">
    <xsl:value-of select="."/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="date:month-name($now)"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- year -->
<xsl:template match="pubdate/year">
<xsl:choose>
  <xsl:when test="self::node()[. !='']">
    <xsl:value-of select="."/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="date:year($now)"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- /kazuyuki: get date automatically if not specified-->



<!-- kazuyuki: automatically generate figure number -->
<!-- define key for figure -->
<xsl:key name="figids" match="*[@id]" use="@id"/>

<!-- print figure caption -->
<xsl:template match="figure">
<p class="caption" xmlns="http://www.w3.org/1999/xhtml">
Figure <xsl:apply-templates select="." mode="fignum"/>:
<xsl:apply-templates/>
</p>
</xsl:template>

<!-- count figure number -->
<xsl:template mode="fignum" match="figure">
  <xsl:number level="any" count="figure" format="1" />
</xsl:template>

<!-- refer figure number -->
<xsl:template match="figref">

  <!-- search node using key -->
  <xsl:param name="target" select="key('figids', @ref)[1]"/>

  <xsl:choose>
    <!-- specified id doesn't exist -->
    <xsl:when test="not($target)">
  <br/>[target="<xsl:value-of select="$target"/>"]<br/>
  [target?="<xsl:value-of select="not($target)"/>"]<br/>
  [local-name="<xsl:value-of select="local-name($target)"/>"]
      <xsl:message>
        <xsl:text>figref to non-existent ID: </xsl:text>
        <xsl:value-of select="@ref"/>
      </xsl:message>
    </xsl:when>

    <!-- specified id found -->
    <xsl:when test="local-name($target)='figure'">
      <xsl:apply-templates select="$target" mode="figref"/>
    </xsl:when>

    <!-- something not expected -->
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unsupported figref to </xsl:text>
          <xsl:value-of select="local-name($target)"/>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text>] </xsl:text>
          <xsl:text> (Contact stylesheet maintainer).</xsl:text>
      </xsl:message>
      <b xmlns="http://www.w3.org/1999/xhtml">
        <xsl:value-of select="key('figids', @ref)"/>
        <xsl:text>???</xsl:text>
      </b>
    </xsl:otherwise>

  </xsl:choose>
 </xsl:template>

<!-- kaz: centering figures -->
<!-- graphic: external illustration -->
<!-- reference external graphic file with alt text -->
<xsl:template match="graphic">
  <img class="center" xmlns="http://www.w3.org/1999/xhtml" src="{@source}">
    <xsl:if test="@alt">
      <xsl:attribute name="alt">
        <xsl:value-of select="@alt"/>
      </xsl:attribute>
    </xsl:if>
  </img>
</xsl:template>

<!-- figref: get figure number -->
<xsl:template match="figure" mode="figref">
Figure <xsl:apply-templates select="." mode="fignum"/>
</xsl:template>
<!-- /kazuyuki: automatically generate figure number -->


<!-- kazuyuki: automatically generate table number -->
<!-- define key for table -->
<xsl:key name="tabids" match="*[@id]" use="@id"/>

<!-- print table caption -->
<xsl:template match="table/caption">
<caption xmlns="http://www.w3.org/1999/xhtml">
Table <xsl:apply-templates select="." mode="tabnum"/>:
<xsl:apply-templates/>
</caption>
</xsl:template>

<!-- count table number -->
<xsl:template mode="tabnum" match="table/caption">
  <xsl:number level="any" count="table" format="1" />
</xsl:template>

<!-- refer table number -->
<xsl:template match="tabref">

  <!-- search node using key -->
  <xsl:param name="target" select="key('tabids', @ref)[1]"/>

  <xsl:choose>
    <!-- specified id doesn't exist -->
    <xsl:when test="not($target)">
  <br/>[target="<xsl:value-of select="$target"/>"]<br/>
  [target?="<xsl:value-of select="not($target)"/>"]<br/>
  [local-name="<xsl:value-of select="local-name($target)"/>"]
      <xsl:message>
        <xsl:text>tabref to non-existent ID: </xsl:text>
        <xsl:value-of select="@ref"/>
      </xsl:message>
    </xsl:when>

    <!-- specified id found -->
    <xsl:when test="local-name($target)='table'">
      <xsl:apply-templates select="$target" mode="tabref"/>
    </xsl:when>

    <!-- something not expected -->
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unsupported tabref to </xsl:text>
          <xsl:value-of select="local-name($target)"/>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text>] </xsl:text>
          <xsl:text> (Contact stylesheet maintainer).</xsl:text>
      </xsl:message>
      <b xmlns="http://www.w3.org/1999/xhtml">
        <xsl:value-of select="key('tabids', @ref)"/>
        <xsl:text>???</xsl:text>
      </b>
    </xsl:otherwise>

  </xsl:choose>
 </xsl:template>

<!-- get table number -->
<xsl:template match="table" mode="tabref">
Table <xsl:apply-templates select="caption" mode="tabnum"/>
</xsl:template>
<!-- /kazuyuki: automatically generate table number -->

<!-- kazuyuki: copyright boilerplate generation -->
<xsl:template match="copyright">
<p xmlns="http://www.w3.org/1999/xhtml" class="copyright">
<a href="http://www.w3.org/Consortium/Legal/ipr-notice#Copyright">
<xsl:text>Copyright</xsl:text>
</a>
<xsl:text> © </xsl:text>
<xsl:value-of select="date:year($now)"/>
<xsl:text> </xsl:text>
<a href="http://www.w3.org/"><acronym title="World Wide Web Consortium">W3C</acronym></a><sup>®</sup><xsl:text> (</xsl:text><a href="http://www.csail.mit.edu/"><acronym title="Massachusetts Institute of Technology">MIT</acronym></a><xsl:text>, </xsl:text><a href="http://www.ercim.eu/"><acronym title="European Research Consortium for Informatics and Mathematics">ERCIM</acronym></a><xsl:text>, </xsl:text><a href="http://www.keio.ac.jp/">Keio</a><xsl:text>, </xsl:text><a href="http://ev.buaa.edu.cn/">Beihang</a><xsl:text>), All Rights Reserved. W3C </xsl:text>
<a href="http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>
<xsl:text>, </xsl:text>
<a href="http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a>
<xsl:text> and </xsl:text>
<a href="http://www.w3.org/Consortium/Legal/copyright-documents">document use</a>
<xsl:text> rules apply.</xsl:text>
</p>
</xsl:template>
<!-- /kazuyuki -->

<!-- scott: additional styling -->
<xsl:variable name="additional.css">
<xsl:text>
table {
        width:80%;
		border:1px solid #000;
		border-collapse:collapse;
		font-size:90%;
	}

td,th{
		border:1px solid #000;
		border-collapse:collapse;
		padding:5px;
	}	


caption{
		background:#ccc;
		font-size:140%;
		border:1px solid #000;
		border-bottom:none;
		padding:5px;
		text-align:center;
	}
<!-- kaz: centering image and caption for that -->
img.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
}
p.caption {
  text-align: center
}
<!-- kaz: RFC2119 keywords -->
.RFC2119 {
  text-transform: lowercase;
  font-style: italic;
}
</xsl:text>
</xsl:variable>

<!-- kaz: RFC2119 key words should be written in upper case -->
<xsl:template match="rfc2119">
  <em xmlns="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="title">
      <xsl:value-of  select="translate(self::node(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:text> in RFC2119 context</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="class">
      <xsl:text>RFC2119</xsl:text>
    </xsl:attribute>
    <xsl:value-of  select="translate(self::node(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
  </em>
</xsl:template>
 <!--  kaz: just display div1 and div2 in the toc, i.e., ignore div3, 4 and 5  --> 
<xsl:param name="toc.level" select="2" /> 

<!-- kaz: 2012-12-05 -->
<!-- strong -->
<xsl:template match="strong">
  <strong xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></strong>
</xsl:template>

</xsl:stylesheet>

