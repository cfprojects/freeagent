<!--- 
	To use this Application.cfc, simply set the extends property 
	of your Model-Glue Application.cfc to "freeagent.application.modelglue" 
	then overwrite the loadFreeAgent method to add your agents - 
	for an example, see /freeagent/skeleton/modelglue/Application.cfc 
	
	-- this Application.cfc is not a requirement - you can just as 
	easily place the CreateObject() and newContainer() method calls 
	in your existing Application.cfc -- this component is for convenience 
--->
<cfcomponent output="false">
	
	<cffunction name="onApplicationStart" access="public" output="false">
		<cfset LoadFreeAgent(getFreeAgent()) />
	</cffunction>
	
	<cffunction name="loadFreeAgent" access="private" output="false">
		<cfargument name="FreeAgent" type="any" required="true" />
		<!--- <cfset FreeAgent.newContainer("myapp","ioc.coldspringadapter").init("...path to coldspring config...") /> --->
		<!--- <cfset writeFreeAgentInclude("myapp") /> --->
	</cffunction>
	
	<cffunction name="getFreeAgent" access="private" output="false">
		<cfreturn CreateObject("component","freeagent.freeagent").init() />
	</cffunction>
	
	<cffunction name="writeFreeAgentInclude" access="private" output="false">
		<cfargument name="include" type="string" required="true" />
		<cfargument name="container" type="string" required="false" default="#include#" />
		<cfargument name="eventhandler" type="string" required="false" default="eventhandler" />
		<cfset var loc = structNew() />
		<cfset arguments.config = "" />
		
		<cfset loc.configdir = getDirectoryFromPath(getMetaData(this).path) & "config/" />
		<cfdirectory name="loc.search" action="list" directory="#loc.configdir#" />
		<cfloop query="loc.search">
			<cfif findnocase("modelglue",loc.search.name)>
				<cfset arguments.config = loc.configdir & loc.search.name />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfif not fileExists(arguments.config)>
			<cfthrow type="FreeAgent.Config.FileNotFound" 
				message="FreeAgent: Unable to locate the ModelGlue.xml config" 
				detail="Config files are expected in the directory #loc.configdir#" />
		</cfif>
		
		<cfinvoke component="freeagent.eventhandler.modelgluewriter" 
			method="writeIncludeXML" argumentcollection="#arguments#" />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" output="false">
		<!--- <cfdump var="#application#" /><cfabort /> --->
	</cffunction>
	
	<cffunction name="onSessionStart"  output="false">
		<!--- Not sure anyone'll ever need this...
		<cfset invokeSessionEvent("modelglue.onSessionStartPreRequest", session, application) />
		--->
		<!--- Set flag letting MG know it needs to broadcast onSessionStart before onRequestStart --->
		<cfset request._modelglue.bootstrap.sessionStart = true />
	</cffunction>
	
	<cffunction name="onSessionEnd" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" 	type="struct" required="false">
	
		<cfset invokeSessionEvent("modelglue.onSessionEnd", arguments.sessionScope, appScope) />
	</cffunction>
	
	<cffunction name="invokeSessionEvent" output="false" access="private">
		<cfargument name="eventName" />
		<cfargument name="sessionScope" />
		<cfargument name="appScope" />
	
		<cfset var mgInstances = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator").findInScope(appScope) />
		<cfset var values = structNew() />
		<cfset var i = "" />
	
		<cfset values.sessionScope = arguments.sessionScope />
	
		<cfloop from="1" to="#arrayLen(mgInstances)#" index="i">
			<cfset mgInstances[i].executeEvent(arguments.eventName, values) />
		</cfloop>
	</cffunction>
	
</cfcomponent>