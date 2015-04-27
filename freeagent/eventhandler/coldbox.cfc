<cfcomponent extends="coldbox.system.EventHandler" output="false">
	
	<cfscript>
		this.event_cache_suffix = "";
		this.prehandler_only 	= "";
		this.prehandler_except 	= "";
		this.posthandler_only 	= "";
		this.posthandler_except = "";
		/* HTTP Methods Allowed for actions. */
		/* Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'} */
		this.allowedMethods = structnew();
		
		// added for FreeAgent 
		variables.freeagent = structNew(); 
		freeagent.eventhandler = "eventhandler"; 
		freeagent.container = ""; // set this to the name of the FreeAgent container for your application 
	</cfscript>
	
	<cffunction name="onMissingAction" returntype="void" output="false" 
	hint="Executes if a request action (method) is not found in this handler">
		<cfargument name="event" type="any" required="true">
		<cfargument name="MissingAction" type="string" required="true" hint="The requested action string"/>
		
		<cfset arguments.event.setView(variables.freeagent.container & "/layout") />
		<cfset arguments.event.setLayout("Layout." & variables.freeagent.container) />
		<cfset getFreeAgentEventFacade(arguments.event).InvokeFreeAgentEvent(arguments.MissingAction) />
	</cffunction>
	
	<cffunction name="getFreeAgentEventFacade" access="private" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfscript>
			if (isDefined("request.freeagent.event")) { return request.freeagent.event; } 
			
			request.freeagent.event = CreateObject("component","freeagent.event.coldbox").init(event,freeagent.container,freeagent.eventhandler); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
</cfcomponent>