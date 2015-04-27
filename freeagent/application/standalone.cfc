<cfcomponent output="false">
	
	<cfscript>
		// declare the container name for your application 
		variables.freeagent = structNew(); 
		freeagent.container = ""; 
		freeagent.defaultEvent = "index"; 
		freeagent.eventVar = "event"; 
		freeagent.routes = structNew(); 
	</cfscript>
	
	<cffunction name="onApplicationStart" access="public" output="false">
		<cfset loadFreeAgent(getFreeAgent()) />
	</cffunction>
	
	<cffunction name="getFreeAgent" access="private" output="false">
		<cfset CreateObject("component","freeagent.freeagent").init() />
	</cffunction>
	
	<cffunction name="setRoute" access="private" output="false">
		<cfargument name="route" type="string" required="true" />
		<cfargument name="container" type="string" required="true" />
		<cfset variables.FreeAgent.routes[route] = container />
	</cffunction>
	
	<cffunction name="getRoute" access="private" output="false">
		<cfargument name="route" type="string" required="true" />
		<cfset var r = variables.FreeAgent.routes />
		<cfreturn iif(structKeyExists(r,route) and len(trim(r[route])),"r[arguments.route]","arguments.route") />
	</cffunction>
	
	<cffunction name="runEvent" access="private" output="false">
		<cfset var event = getEventObject() />
		<cfset var EventName = getRequestedEvent(event) />
		
		<!--- redirect to login if the user is not authorized to execute this event --->
		<cfset secureEvent(Event) />
		
		<!--- the user is authorized, execute the event --->
		<cfset event.InvokeFreeAgentEvent(EventName[3]) />
	</cffunction>
	
	<cffunction name="getRequestedEvent" access="private" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfscript>
			var fa = variables.FreeAgent; 
			var ev = fa.EventVar; 
			
			// if no event is defined for the request, then we use the default event 
			if (not event.valueExists(ev)) { return getEventArray(fa.defaultEvent); } 
			
			// otherwise we return the requested event 
			return getEventArray(event.getValue(ev)); 
		</cfscript>
	</cffunction>
	
	<cffunction name="getEventObject" access="private" output="false">
		<cfscript>
			if (isDefined("request.freeagent.event")) { return request.freeagent.event; } 
			
			request.freeagent.event = createEventObject(); 
			
			return request.freeagent.event; 
		</cfscript>
	</cffunction>
	
	<cffunction name="getEventArray" access="private" output="false">
		<cfargument name="EventName" type="string" required="true" />
		<cfscript>
			var ev = EventName; 
			var result = listToArray("eventhandler,index"); 
			ArrayPrepend(result,variables.FreeAgent.container); 
			
			if (refindnocase("^\w+(\.\w+){0,2}?$",ev)) { 
				switch (listlen(ev,".")) { 
					case 3: { result[2] = listgetat(ev,2,"."); } 
					case 2: { result[1] = getRoute(listfirst(ev,".")); } 
					case 1: { result[3] = listlast(ev,"."); } 
				} 
			} 
			
			return result; 
		</cfscript>
	</cffunction>
	
	<cffunction name="createEventObject" access="private" output="false">
		<cfscript>
			var rc = getRequestCollection(); 
			var ev = FreeAgent.eventVar; 
			
			ev = getEventArray(iif(structKeyExists(rc,ev),"rc[ev]",de(""))); 
			
			return CreateObject("component","freeagent.event.genericevent").init(rc,ev[1],ev[2]); 
		</cfscript>
	</cffunction>
	
	<cffunction name="getRequestCollection" access="private" output="false" returntype="struct">
		<cfscript>
			var collection = duplicate(url); 
			structAppend(collection,form,true); 
			return collection; 
		</cfscript>
	</cffunction>
	
	<cffunction name="secureEvent" access="private" output="false">
		<cfargument name="Event" type="any" required="true" />
		<cfscript>
			var sec = CreateObject("component","freeagent.securityfacade").init(); 
			var ev = variables.FreeAgent.eventVar; 
			ev = getEventArray(iif(event.valueExists(ev),"event.getValue(ev)",de(""))); 
			if (not sec.checkPermission(ArrayToList(ev,"/"))) { 
				event.redirect(iif(sec.isLoggedIn(),"sec.getAccessDeniedURL()","sec.getLoginURL()")); 
			} 
		</cfscript>
	</cffunction>
	
</cfcomponent>