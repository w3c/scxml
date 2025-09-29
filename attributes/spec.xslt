<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<xsl:apply-templates select="elements"/>
</xsl:template>

<xsl:template match="elements">

  <xsl:for-each select="element">

    <table summary="attibute table" class="element">
    <tr class="elementHeader">
      <th>Name</th>
      <th>Required</th>
      <th>Attribute Constraints</th>
      <th>Type</th>
      <th>Default Value</th>
      <th>Valid Values</th>
      <th>Description</th>
    </tr>

    <xsl:for-each select="attributes/attribute">
      <tr class="elementRow">
        <td class="elementRowName"><xsl:value-of select="name"/></td>
        <td class="elementRowRequired"><xsl:value-of select="required"/></td>
        <td class="elementRowaAtributeConstraints"><xsl:value-of select="attributeConstraints"/></td>
        <td class="elementRowType"><xsl:value-of select="type"/></td>

        <td class="elementRowDefaultValues"><xsl:value-of select="defaultValue"/></td>

        <td class="elementRowValidValues">
			<xsl:apply-templates select="validValues"/>
        </td>

        <td class="elementRowDescription">
			<xsl:apply-templates select="description"/>
        </td>
      </tr>
    </xsl:for-each>
    </table>
  </xsl:for-each>
</xsl:template>

<xsl:template match="description">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="validValues">
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="/ | @* | node()">
<xsl:copy>
  <xsl:apply-templates select="@* | node()"/>
</xsl:copy>
</xsl:template>


</xsl:stylesheet>