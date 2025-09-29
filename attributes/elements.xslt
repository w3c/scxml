<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<xsl:apply-templates select="elements"/>
</xsl:template>

<xsl:template match="elements">
  <html>
  <head>
  <style type="text/css">
  body {font-size: 9pt; font-family: verdana}
  table.element td, table.stats td {font-size: 9pt; font-family: verdana; background-color: #cccccc; 
    text-align: left; vertical-align: top}
  table.element th, table.stats th {font-size: 9pt; font-family: verdana; background-color: #dddddd;
    text-align: left; vertical-align: top}
  td.title {color: #ff0000; font-weight: bold}
  div.h1 {font-size: 16pt; color: #0000ff}
  div.h2 {font-size: 14pt; color: #0000ff}
  div.editor {font-size: 8pt; font-style: italic}
  dt {font-weight: bold}
  li {list-style-type: none}

td.elementRowName { width: 50px }
td.elementRowRequired { width: 50px }
td.elementRowaAtributeConstraints { width: 50px }
td.elementRowType { width: 50px }
td.elementRowDefaultValues { width: 50px }
td.elementRowValidValues { width: 50px }
td.elementRowDescription { width: 700px }

  pre.example {
   font-family: "Courier New", monospace;
   white-space: pre;
   background-color: rgb(204,204,255);
   padding: 0.5em;
   border: none;
   margin-left: 0;
   font-size: 90%;
   width: 100%;
}

</style>
  </head>
  <body>

  <xsl:for-each select="element">

    <h2>&lt;<xsl:value-of select="name"/>&gt; Attribute Table</h2>
    <table class="element">
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
    <hr/>

  </xsl:for-each>
  </body>
  </html>
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