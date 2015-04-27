<cfcomponent extends="MachII.framework.Listener" output="false">
	
	<cffunction name="configure" returntype="void" access="public" output="false">
		<!--- perform any initialization --->
		<!--- none needed thus far --->
	</cffunction>
	
	<cffunction name="getFreeAgentEventFacade" access="private" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfscript>
			if (isDefined("request.freeagent.event")) { return request.freeagent.event; } 
			
			request.freeagent.event = CreateObject("component","freeagent.event.machii").init(event,getParameter("container"),getParameter("eventhandler")); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false">
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="any" required="true" />
		<!--- onMissingMethod allows us to avoid duplicating all the method names from the FreeAgent event handler --->
		<cfset getFreeAgentEventFacade(MissingMethodArguments.event).InvokeFreeAgentEvent(arguments.MissingMethodName) />
	</cffunction>
</cfcomponent>