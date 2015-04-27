<cfcomponent output="false" extends="writer">
	
	<cfset instance.framework = "modelglue" />
	
	<cffunction name="writeIncludeXML" access="public" output="false">
		<cfargument name="config" type="any" required="true" />
		<cfargument name="include" type="string" required="true" />
		<cfargument name="container" type="string" required="true" />
		<cfargument name="eventhandler" type="string" required="true" />
		<cfset var loc = structNew() />
		<cfset var x = 0 />
		
		<cfscript>
			loc.config = arguments.config;
			loc.configdir = getDirectoryFromPath(loc.config);
			loc.eh = getEventHandler(arguments.container,arguments.eventhandler);
			loc.xml = getXML(loc.eh,container,eventhandler);
			loc.xml.handler.xmlAttributes["urlprefix"] = arguments.include;
			loc.webroot = getDirectoryFromPath(cgi.SCRIPT_NAME); 
		</cfscript>
		
		<cffile action="write" output="#XmlTransform(loc.xml,getXSL())#" 
			file="#loc.configdir#/#lcase(arguments.container)#.xml" />
		
		<!--- check to see if the config is already declared in the main Model-Glue config -- add if needed --->
		<cfsavecontent variable="loc.xsl">
			<cfoutput>
				<?xml version="1.0" encoding="UTF-8"?>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
					<xsl:output method="xml" indent="yes" omit-xml-declaration="no" />
					
					<xsl:template match="/modelglue">
						<xsl:copy>
							<xsl:copy-of select="@*" />
							
							<xsl:choose>
								<xsl:when test="./include[@template='#loc.webroot#config/#lcase(arguments.container)#.xml']" />
								
								<xsl:otherwise>
									<xsl:text>
	</xsl:text><include template="#loc.webroot#config/#lcase(arguments.container)#.xml" />
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:copy-of select="./node()" />
						</xsl:copy>
					</xsl:template>
				</xsl:stylesheet>
			</cfoutput>
		</cfsavecontent>
				
		<cffile action="write" file="#loc.config#" output="#XmlTransform(XmlParse(loc.config),trim(loc.xsl))#" />
	</cffunction>
	
</cfcomponent>