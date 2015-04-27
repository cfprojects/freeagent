<!--- 
	To use this Application.cfc, simply change the extends property 
	of your Mach-II Application.cfc to "freeagent.application.machii" 
	then overwrite the loadFreeAgent method to add your agents - 
	for an example, see /freeagent/skeleton/machii/Application.cfc 
	
	-- this Application.cfc is not a requirement - you can just as 
	easily place the CreateObject() and newContainer() method calls 
	in your existing Application.cfc -- this component is for convenience 
--->
<cfcomponent extends="MachII.mach-ii" output="false">
	
	<cffunction name="loadFramework" access="public" output="false">
		<cfset super.loadFramework() />
		
		<!--- if we're reloading the config, then go ahead and reload FreeAgent as well --->
		<cfif application[variables.MACHII_APP_KEY].apploader.shouldReloadConfig()>
			<cfset getFreeAgent().resetContainers() />
		</cfif>
		
		<cfset LoadFreeAgent(getFreeAgent()) />
	</cffunction>
	
	<cffunction name="loadFreeAgent" access="private" output="false">
		<cfargument name="FreeAgent" type="any" required="true" />
		<!--- <cfset FreeAgent.newContainer("myapp","ioc.coldspringadapter").init("...path to coldspring config...") /> --->
		<!--- <cfset writeFreeAgentModule("myapp") /> --->
	</cffunction>
	
	<cffunction name="getFreeAgent" access="private" output="false">
		<cfreturn CreateObject("component","freeagent.freeagent").init() />
	</cffunction>
	
	<cffunction name="writeFreeAgentModule" access="private" output="false">
		<cfargument name="module" type="string" required="true" />
		<cfargument name="container" type="string" required="false" default="#module#" />
		<cfargument name="eventhandler" type="string" required="false" default="eventhandler" />
		
		<cfset arguments.machii = application[variables.MACHII_APP_KEY].apploader />
		
		<cfinvoke component="freeagent.eventhandler.machiiwriter" 
			method="writeModuleXML" 
			argumentcollection="#arguments#" />
	</cffunction>
	
</cfcomponent>