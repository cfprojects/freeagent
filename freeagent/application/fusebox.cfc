<!--- 
	To use this Application.cfc, simply change the extends property 
	of your Fusebox Application.cfc to "freeagent.application.fusebox" 
	then overwrite the loadFreeAgent method to add your agents - 
	for an example, see /freeagent/skeleton/fusebox/Application.cfc 
	
	-- this Application.cfc is not a requirement - you can just as 
	easily place the CreateObject() and newContainer() method calls 
	in your existing Application.cfc -- this component is for convenience 
--->
<cfcomponent extends="fusebox5.Application" output="false">
	
	<cfscript>
		// must enable implicit (no-XML) mode! 
		FUSEBOX_PARAMETERS.allowImplicitFusebox = true; 
		FUSEBOX_PARAMETERS.allowImplicitCircuits = true; 
	</cfscript>
	
	<cffunction name="onApplicationStart" access="public" output="false">
		<cfset super.onApplicationStart() />
		<cfset LoadFreeAgent(getFreeAgent()) />
	</cffunction>
	
	<cffunction name="loadFreeAgent" access="private" output="false">
		<cfargument name="FreeAgent" type="any" required="true" />
		<!--- <cfset getFreeAgent().newContainer("myapp","ioc.coldspringadapter").init("...path to coldspring config...") /> --->
		<!--- <cfset writeFreeAgentCircuit("myapp") /> --->
	</cffunction>
	
	<cffunction name="getFreeAgent" access="private" output="false">
		<cfreturn CreateObject("component","freeagent.freeagent").init() />
	</cffunction>
	
	<cffunction name="writeFreeAgentCircuit" access="private" output="false">
		<cfargument name="circuit" type="string" required="true" />
		<cfargument name="container" type="string" required="false" default="#circuit#" />
		<cfargument name="eventhandler" type="string" required="false" default="eventhandler" />
		
		<cfset arguments.fusebox = application[variables.FUSEBOX_APPLICATION_KEY] />
		
		<cfinvoke component="freeagent.eventhandler.fuseboxwriter" 
			method="writeCircuitComponent" 
			argumentcollection="#arguments#" />
	</cffunction>
	
</cfcomponent>