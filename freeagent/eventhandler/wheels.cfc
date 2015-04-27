<cfcomponent extends="wheels.Controller" output="false">
	
	<cffunction name="FreeAgentInit" access="public" output="false" 
	hint="Prepares a CF Wheels controller for use by CF Wheels and allows us to avoid duplicating the FreeAgent evenhandler methods">
		<cfargument name="container" type="string" required="true" hint="name of the FreeAgent IoC container for your application" />
		<cfargument name="eventhandler" type="string" required="false" default="eventhandler" hint="name of the eventhandler bean within your IoC container" />
		<cfargument name="layout" type="string" required="false" default="wheelslayout.cfm" hint="allows you to define an alternate CF Wheels layout template" />
		<cfscript>
			var handler = 0; 
			var x = 0; 
			
			variables.FreeAgent = arguments; 
			handler = getFreeAgentEventHandler(); 
			for (x in handler) { 
				this[x] = this.InvokeFreeAgentEvent; 
			} 
		</cfscript>
	</cffunction>
	
	<cffunction name="getFreeAgent" access="private" output="false" hint="returns the FreeAgent IoC manager">
		<cfreturn application.freeagent />
	</cffunction>
	
	<cffunction name="getFreeAgentContainer" access="private" output="false" 
	hint="returns the FreeAgent IoC container declared for this wheels controller">
		<cfreturn getFreeAgent().getContainer(freeagent.container) />
	</cffunction>
	
	<cffunction name="getFreeAgentEventHandler" access="private" output="false"
	hint="returns the FreeAgent event-handler IoC bean declared for this wheels controller">
		<cfreturn getFreeAgentContainer().getBean(freeagent.eventhandler) />
	</cffunction>
	
	<cffunction name="getFreeAgentEventFacade" access="private" output="false" hint="returns a FreeAgent event object">
		<cfscript>
			if (isDefined("request.freeagent.event")) { return request.freeagent.event; } 
			
			request.freeagent.event = CreateObject("component","freeagent.event.genericevent").init(variables.params,freeagent.container,freeagent.eventhandler); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
	<cffunction name="InvokeFreeAgentEvent" access="public" output="false">
		<cfset getFreeAgentEventFacade().InvokeFreeAgentEvent(variables.params.action) />
		<cfset renderPage(template="layout.cfm", layout=FreeAgent.layout) />
	</cffunction>
</cfcomponent>