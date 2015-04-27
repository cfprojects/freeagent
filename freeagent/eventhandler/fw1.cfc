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
			
			request.freeagent.event = CreateObject("component","freeagent.event.genericevent").init(event,freeagent.container,freeagent.eventhandler); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false">
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="any" required="true" />
		<cfset var rc = MissingMethodArguments.rc />
		
		<!--- 
			onMissingMethod allows us to avoid duplicating all the method names 
			from the FreeAgent event handler -- however, because there is an onMissingMethod method here, 
			FW/1 will always execute startX and endX methods on this handler, which we don't want. 
			So we have to check to see if this is a startX or endX method call to prevent passing 
			those method calls on to our FreeAgent event handler where they would produce an error 
		--->
		<cfif MissingMethodName is listlast(request.action,".")>
			<cfset getFreeAgentEventFacade(rc).InvokeFreeAgentEvent(arguments.MissingMethodName) />
		</cfif>
	</cffunction>
	
	<cffunction name="before" access="public" output="false">
	</cffunction>
	
	<cffunction name="after" access="public" output="false">
		<cfset request.view = FreeAgent.container />
	</cffunction>
</cfcomponent>