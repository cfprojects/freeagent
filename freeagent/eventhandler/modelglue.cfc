<cfcomponent extends="ModelGlue.gesture.controller.Controller" output="false">
	
	<cffunction name="getFreeAgentEventFacade" access="private" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfscript>
			if (isDefined("request.freeagent.event")) { return request.freeagent.event; } 
			
			request.freeagent.event = CreateObject("component","freeagent.event.modelglue").init(event,event.getArgument("container"),event.getArgument("eventhandler")); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
	<cffunction name="InvokeFreeAgentEvent" access="public" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfset getFreeAgentEventFacade(event).InvokeFreeAgentEvent(event.getArgument("eventName")) />
	</cffunction>
</cfcomponent>