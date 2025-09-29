<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

<!-- strip all diff attributes; this should have lower priority than the next rule  -->
<xsl:template match="@diff" priority="1"/>

<!-- strip all tags and their contents that have a diff attribute with the value del -->
<xsl:template match="*[@diff='del']" priority="2"/>

<!-- match anything that doesn't have an explicit rule, and identity transform it -->
<xsl:template match="/ | @* | node()">
<xsl:copy>
  <xsl:apply-templates select="@* | node()"/>
</xsl:copy>
</xsl:template>

</xsl:stylesheet>

