<?xml version="1.0"?> 
<!-- Copyright 1998-2003 W3C (MIT, ERCIM, Keio), All Rights Reserved. See http://www.w3.org/Consortium/Legal/. -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:conf="http://www.w3.org/2005/scxml-conformance"
    version="1.0">

<!-- Copy everything that doesn't match other rules -->
<xsl:template match="/ | @* | node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

<!-- Success criteria -->

<xsl:template match="//@conf:targetpass"> 
	<xsl:attribute name="target">pass</xsl:attribute>
</xsl:template>

<xsl:template match="conf:pass">
 <final id="pass">
   <onentry>
     <log expr="pass"/>
   </onentry>
 </final>
</xsl:template>

<!-- Failure criteria -->

<xsl:template match="//@conf:targetfail"> 
	<xsl:attribute name="target">fail</xsl:attribute>
</xsl:template>

<xsl:template match="conf:fail">
 <final id="fail">
   <onentry>
    <log expr="fail"/>
   </onentry>
</final>
</xsl:template>

<!-- datamodel -->
<xsl:template match="//@conf:datamodel"> 
</xsl:template>

<xsl:template match="//@conf:expr0"> 
	<xsl:attribute name="expr">0</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:expr1"> 
	<xsl:attribute name="expr">1</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:exprInvalid"> 
	<xsl:attribute name="expr">'undefined'</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:name1"> 
	<xsl:attribute name="name">Var1</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:name2"> 
	<xsl:attribute name="name">Var2</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:location1"> 
	<xsl:attribute name="name">Var1</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:location2"> 
	<xsl:attribute name="name">Var2</xsl:attribute>
</xsl:template>
<!-- transition conditions -->
<xsl:template match="//@conf:cond10"> 
	<xsl:attribute name="cond">Var1==0</xsl:attribute>
</xsl:template>

<!-- transition conditions -->
<xsl:template match="//@conf:cond11"> 
	<xsl:attribute name="cond">Var1==1</xsl:attribute>
</xsl:template>


<!-- transition conditions -->
<xsl:template match="//@conf:cond20"> 
	<xsl:attribute name="cond">Var2==0</xsl:attribute>
</xsl:template>


<!-- transition conditions -->
<xsl:template match="//@conf:cond21"> 
	<xsl:attribute name="cond">Var2==1</xsl:attribute>
</xsl:template>

<xsl:template match="//@conf:cond1Undefined"> 
	<xsl:attribute name="cond">Var1=='undefined'</xsl:attribute>
</xsl:template>


</xsl:stylesheet>