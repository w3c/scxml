<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:ccxml="http://www.w3.org/2002/09/ccxml"
    xmlns="http://www.w3.org/2005/scxml"
    xmlns:str="http://exslt.org/strings"
    version="1.0">
    <xsl:preserve-space elements="*"/>
    <xsl:output
        method="xml"
        standalone="yes"
        indent="yes"
        encoding="UTF-8"/>
    <xsl:template match="/ccxml:ccxml">
        <!--
        -
        - Take the <ccxml/> and map it into a <scxml/>
        - and set the intial state to CCXML. 
        - This beast will only be a single-state 
        - state machine as we handle CCXML's 
        - state vars using cond's on the transition 
        - elements. 
        -
        -->
        <scxml version="1.0" initalstate="CCXML">

            <!--
            -
            - There really should ever be one of 
            - these but we are going to do a for-each
            - just for the fun of it. 
            -
            -->
            <xsl:for-each select="ccxml:eventprocessor">
                <xsl:variable name="statevariable" select="@statevariable"/>
                <state id="CCXML">
                    <!--
                    -
                    - If there is a statevar create the 
                    - var to hold it
                    -
                    -->
                    <xsl:if test="@statevariable != ''">
                        <var>
                            <xsl:attribute name="name"><xsl:value-of select="@statevariable" /></xsl:attribute> 
                        </var>
                    </xsl:if>

                    <!--
                    -
                    - Process each of the ccxml <transition>
                    - elements and map them in SCXML <transition>'s
                    -
                    -->
                    <xsl:for-each select="ccxml:transition">
                        <transition>
                            <!--
                            -
                            - @event and @name move over without 
                            - really any magic. 
                            -
                            -->
                            <xsl:if test="@event != ''">
                              <xsl:attribute name="event"><xsl:value-of select="@event" /></xsl:attribute> 
                            </xsl:if>
                            <xsl:if test="@name != ''">
                                <xsl:attribute name="name">
                                    <xsl:value-of select="@name" />
                                </xsl:attribute> 
                            </xsl:if>
                            
                            <!--
                            -
                            - @state and @cond require a bit of
                            - munging to get to work right as 
                            - the CCXML states are modeled as 
                            - cond attributes in SCXML. 
                            -
                            -->
                            <xsl:choose>
                                <xsl:when test="@state != '' and @cond !='' ">
                                    <xsl:attribute name="cond">(<xsl:for-each select="str:split(@state)">(<xsl:value-of select="$statevariable" /> == '<xsl:value-of select="." />')<xsl:if test="not(position()=last())"> || </xsl:if></xsl:for-each>) &amp;&amp; (<xsl:value-of select="@cond" />)</xsl:attribute> 
                                </xsl:when>
                                <xsl:when test="@state != ''">
                                    <xsl:attribute name="cond"><xsl:for-each select="str:split(@state)">(<xsl:value-of select="$statevariable" /> == '<xsl:value-of select="." />')<xsl:if test="not(position()=last())"> || </xsl:if></xsl:for-each></xsl:attribute> 
                                </xsl:when>
                                <xsl:when test="@cond  != ''">
                                    <xsl:attribute name="cond">
                                        <xsl:value-of select="@cond" />
                                    </xsl:attribute> 
                                </xsl:when>
                            </xsl:choose>
                            
                            <!--
                            -
                            - This should pick up all
                            - the executable content 
                            -
                            -->
                            <xsl:apply-templates/>
                        </transition>
                    </xsl:for-each>
                </state>
            </xsl:for-each>
        </scxml>
    </xsl:template>

    <!--
    -
    - The CCXML <if>/<elseif>/<else> elements 
    - just need to be mapped into their SCXML versions.
    -
    -->
    <xsl:template match="ccxml:if">
        <if>
            <xsl:attribute name="cond"><xsl:value-of select="@cond" /></xsl:attribute> 
            <xsl:apply-templates/>
        </if>
    </xsl:template>
    <xsl:template match="ccxml:elseif">
        <elseif>
            <xsl:attribute name="cond"><xsl:value-of select="@cond" /></xsl:attribute> 
            <xsl:apply-templates/>
        </elseif>
    </xsl:template>
    <xsl:template match="ccxml:else">
        <else>
            <xsl:apply-templates/>
        </else>
    </xsl:template>

    <!--
    -
    - The CCXML <exit> also needs to be remaped.
    -
    -->
    <xsl:template match="ccxml:exit">
        <exit/>
    </xsl:template>
    
    <!--
    -
    - This should pick up all the executable content. 
    - For this stuff we just copy it in keeping 
    - the original namespace. 
    -
    -->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>