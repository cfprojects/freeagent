<cfcomponent displayname="FreeAgent.event.GenericEvent" extends="freeagent.util" output="false">
	
	<cfscript>
		variables.instance = structNew(); 
	</cfscript>
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="event" type="any" required="true" />
		<cfargument name="container" type="string" required="true" />
		<cfargument name="eventhandler" type="string" required="false" default="eventhandler" />
		<cfset structAppend(instance,arguments,true) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="InvokeFreeAgentEvent" returntype="void" output="false" 
	hint="Executes if a request action (method) is not found in this handler">
		<cfargument name="EventName" type="string" required="true" hint="The requested event"/>
		<cfset var handler = getEventHandler() />
		<cfset this.setView(eventName) />
		
		<cftry>
			<!--- the onEventStart method allows you to execute code at the beginning of all events in the handler --->
			<cfif structKeyExists(handler,"onEventStart")>
				<cfset handler.onEventStart(Event=This,EventName=EventName) />
			</cfif>
			
			<cfif structKeyExists(handler,EventName)>
				<!--- if there's a function for this event, execute it --->
				<cfinvoke component="#handler#" method="#EventName#">
					<cfinvokeargument name="event" value="#this#" />
				</cfinvoke>
			<cfelseif structKeyExists(handler,"onMissingEvent")>
				<!--- if there's an onMissingEvent method in the handler, execute that instead --->
				<!--- this is useful for ignoring missing events for pure-content pages that don't need to execute any model code --->
				<cfset handler.onMissingEvent(Event=This,EventName=EventName) />
			<cfelse>
				<!--- otherwise let the developer know that the event couldn't be found --->
				<cfset raiseMissingEventException(EventName) />
			</cfif>
			
			<!--- the onEventEnd method allows you to execute code at the end of all events in a handler --->
			<cfif structKeyExists(handler,"onEventEnd")>
				<cfset handler.onEventEnd(Event=This,EventName=EventName) />
			</cfif>
			
			<cfcatch type="any">
				<cfif structKeyExists(handler,"onError")>
					<cfinvoke component="#handler#" method="onError">
						<cfinvokeargument name="error" value="#cfcatch#" />
						<cfinvokeargument name="event" value="#this#" />
						<cfinvokeargument name="eventName" value="#eventName#" />
					</cfinvoke>
				<cfelse>
					<cfrethrow />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getContainer" access="private" output="false">
		<cfreturn getFreeAgent().getContainer(instance.container) />
	</cffunction>
	
	<cffunction name="getEventHandler" access="private" output="false">
		<cfreturn getContainer().getBean(instance.eventhandler) />
	</cffunction>
	
	<cffunction name="RaiseMissingEventException" access="private" output="false">
		<cfargument name="event" type="string" required="true" />
		<cfthrow type="FreeAgent.MissingEvent" 
			message="FreeAgent: Unable to locate the event #arguments.event#" />
	</cffunction>
	
	<cffunction name="getCollection" access="public" output="false" returntype="struct">
		<cfreturn instance.event />
	</cffunction>
	
	<cffunction name="getValue" access="public" output="false" returntype="any">
		<cfargument name="name" type="string" required="true" />
		<cfset var collection = this.getCollection() />
		<cfreturn collection[arguments.name] />
	</cffunction>
	
	<cffunction name="setValue" access="public" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset var collection = this.getCollection() />
		<cfset collection[arguments.name] = arguments.value />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="valueExists" access="public" output="false" returntype="boolean">
		<cfargument name="name" type="string" required="true" />
		<cfreturn structKeyExists(getCollection(),arguments.name) />
	</cffunction>
	
	<cffunction name="getView" access="public" output="false" returntype="string" 
	hint="gets the name of the view template for the current event relative to the container view directory, excluding the .cfm extension">
		<cfreturn instance.view />
	</cffunction>
	
	<cffunction name="setView" access="public" output="false" 
	hint="allows you to override the view template name for the current event">
		<cfargument name="view" type="string" required="true" hint="name of the view template relative to the container view directory, excluding the .cfm extension" />
		<cfset instance.view = arguments.view />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="redirect" access="public" output="false" 
	hint="sends the browser to a new location - may include framework-specific cleanup as well">
		<cfargument name="href" type="string" required="true" hint="a fully qualified url to send the browser to" />
		<cflocation url="#href#" addtoken="false" />
	</cffunction>
	
	<cffunction name="isAjaxRequest" access="public" output="false" returntype="boolean" 
	hint="determines if the current request is Ajax and therefore should return only partial-page content">
		<cfscript>
			var rc = getCollection(); 
			// if you're not actually using jQuery to perform an XmlHttpRequest, 
			// you can tell the event that it's an ajax request by adding ajax=1 to the event parameters 
			if (structKeyExists(rc,"ajax") and val(rc.ajax) gt 0) { return true; } 
			
			// otherwise, if you're using jQuery then the system will get the http header 
			if (cgi.http_x_requested_with is "XMLHTTPRequest") { return true; } 
			return false; 
		</cfscript>
	</cffunction>
	
</cfcomponent>