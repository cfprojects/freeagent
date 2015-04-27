<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/*">
		<cfcomponent extends="freeagent.eventhandler.fusebox" output="false">
			
			<cfscript>
				// set this to the name of the FreeAgent container for your application 
				freeagent.container = "<xsl:value-of select="@container" />"; 
				
				// set this variable to use an alernative IoC bean for your event handler 
				freeagent.eventhandler = "<xsl:value-of select="@eventhandler" />"; 
			</cfscript>
			
			<xsl:for-each select="event"><xsl:text>
				
				</xsl:text><cffunction name="{@name}" access="public" output="false">
					<cfargument name="myFusebox" />
					<cfargument name="event" />
					
					<cfinvoke method="doFreeAgentEvent" eventName="{@name}" myFusebox="#myFusebox#" event="#event#" />
				</cffunction>
			</xsl:for-each>
		</cfcomponent>
	</xsl:template>

</xsl:stylesheet>