<cfcomponent extends="freeagent.application.standalone" output="false">
	
	<cfscript>
		this.root = getDirectoryFromPath(getCurrentTemplatePath()); 
		this.name = right(rereplacenocase(this.root,"\W","_","ALL"),65); 
		this.sessionmanagement = true; 
		this.sessiontimeout = CreateTimeSpan(0,0,20,0); 
		
		// declare the container name for your application 
		variables.freeagent.container = "myapp"; 
	</cfscript>
	
	<cffunction name="loadFreeAgent" access="private" output="false">
		<cfargument name="FreeAgent" type="any" required="true" />
		<!--- add the containers for your application --->
		<cfset FreeAgent.newContainer(variables.freeagent.container,"freeagent.ioc.coldspringadapter").init("...path to coldspring config...") />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" output="true">
		<cfargument name="targetpage" type="string" required="true" />
		
		<!--- this if statement allows webservices to be called within the application --->
		<cfif listlast(targetpage,".") is not "cfc">
			<cfset runEvent() />
			
			<!--- the event is executed, show the view --->
			<cfinclude template="view/html.cfm" />
			
			<!--- we're not using the onRequest() method, so this abort prevents duplication of the view or an error --->
			<cfabort />
		</cfif>
	</cffunction>
	
</cfcomponent>