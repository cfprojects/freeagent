<cfcomponent output="false">
	
	<cfscript>
		// added for FreeAgent 
		variables.freeagent = structNew(); 
		freeagent.container = ""; // set this to the name of the FreeAgent container for your application 
		freeagent.eventhandler = "eventhandler"; 
	</cfscript>
	
	<cffunction name="getFreeAgentEventFacade" access="private" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfscript>
			if (isDefined("request.freeagent.event")) { return request.freeagent.event; } 
			
			request.freeagent.event = CreateObject("component","freeagent.event.fusebox").init(event,freeagent.container,freeagent.eventhandler); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
	<cffunction name="doFreeAgentEvent" access="private" output="false">
		<cfargument name="eventName" type="string" required="true" />
		<cfargument name="myFusebox" type="any" required="true" />
		<cfargument name="event" type="any" required="true" />
		
		<cfset getFreeAgentEventFacade(arguments.event).InvokeFreeAgentEvent(arguments.eventName) />
	</cffunction>
	
	<cffunction name="postFuseaction" access="public" output="true">
		<cfargument name="myFusebox" type="any" required="true" />
		<cfargument name="event" type="any" required="true" />
		<cfset myFusebox.do(action="view.lay#freeagent.container#") />
	</cffunction>
</cfcomponent>