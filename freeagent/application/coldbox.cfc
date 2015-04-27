<!--- 
	To use this Application.cfc, simply change the extends property 
	of your ColdBox Application.cfc to "freeagent.application.coldbox" 
	then overwrite the loadFreeAgent method to add your agents - 
	for an example, see /freeagent/skeleton/coldbox/Application.cfc 
	
	-- this Application.cfc is not a requirement - you can just as 
	easily place the CreateObject() and newContainer() method calls 
	in your existing Application.cfc -- this component is for convenience 
--->
----------------------------------------------------------------------->
<cfcomponent extends="coldbox.system.Coldbox" output="false">
	
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfscript>
			LoadFreeAgent(getFreeAgent()); 
			LoadColdBox(); 
			return true; 
		</cfscript>
	</cffunction>
	
	<cffunction name="loadFreeAgent" access="private" output="false">
		<cfargument name="FreeAgent" type="any" required="true" />
		<!--- <cfset FreeAgent.newContainer("myapp","ioc.coldspringadapter").init("...path to coldspring config...") /> --->
	</cffunction>
	
	<cffunction name="getFreeAgent" access="private" output="false">
		<cfreturn CreateObject("component","freeagent.freeagent").init() />
	</cffunction>
	
	<!--- from the ColdBox skeleton application --->
	<!--- on Request Start --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<cfargument name="targetPage" type="string" required="true" />
		<cfset reloadChecks() />
		
		<!--- Process A ColdBox Request Only --->
		<cfif findNoCase('index.cfm', listLast(arguments.targetPage, '/'))>
			<cfset processColdBoxRequest() />
		</cfif>
		
		<!--- WHATEVER YOU WANT BELOW --->
		<cfreturn true />
	</cffunction>
	
	<cffunction name="reloadFreeAgent" access="public" output="false">
		<cfset loadFreeAgent(getFreeAgent().resetContainers()) />
	</cffunction>
	
	<cffunction name="reloadChecks" access="public" output="false" returntype="void" 
	hint="this allows FreeAgent applications to reload at the same time that the default ColdBox IoC Container reloads">
		<cfset var cbController = 0 />
		<cfset super.reloadChecks() />
		
		<cfset cbController = application[locateAppKey()] />
		
		<cfif cbController.getSetting("IOCFrameworkReload")>
			<cfset reloadFreeAgent() />
		</cfif>
	</cffunction>
	
</cfcomponent>
