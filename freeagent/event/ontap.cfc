<cfcomponent displayname="FreeAgent.event.onTap" extends="genericevent" output="false">
	
	<cffunction name="InvokeFreeAgentEvent" returntype="void" output="false" 
	hint="Executes if a request action (method) is not found in this handler">
		<cfargument name="EventName" type="string" required="true" hint="The requested event" />
		<cfset var handler = getEventHandler() />
		
		<cfset super.InvokeFreeAgentEvent(getEventMethodFromProcess(handler,eventname)) />
	</cffunction>
	
	<cffunction name="getEventMethodFromProcess" access="private" output="false">
		<cfargument name="handler" type="any" required="true" />
		<cfargument name="process" type="string" required="true" />
		<cfscript>
			var proc = ListToArray(process,"/"); 
			var x = ArrayLen(proc); 
			var method = ""; 
			
			while (x and not StructKeyExists(eventhandler,method)) { 
				method = proc[x] & method; 
				ArrayDeleteAt(proc,x); 
				x = x - 1; 
			} 
			
			return method; 
		</cfscript>
	</cffunction>
	
	<!--- custom redirect method allows the onTap framework to execute onRequestEnd features on a redirect --->
	<cffunction name="redirect" access="private" output="false">
		<cfargument name="href" type="string" required="true" />
		<cf_abort url="#href#" />
	</cffunction>
	
</cfcomponent>