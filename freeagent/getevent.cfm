<!--- if we've already fetched the event object in this context, then we should skip this --->
<cfif not structKeyExists(variables,"event") 
or not isObject(variables.event) 
or not structKeyExists(variables.event,"InvokeFreeAgentEvent")>
	<!--- 
		we don't want to use the framework supplied event object, 
		we want to use the FreeAgent event object instead 
	--->
	<cfset event = request.freeagent.event />
	<cfset rc = event.getCollection() />
	
	<!--- disable cfoutputonly if it's been enabled for the request --->
	<cfset temp = 0 />
	<cfloop condition="not val(temp)">
		<cfsavecontent variable="temp">1</cfsavecontent>
		<cfsetting enablecfoutputonly="false" />
	</cfloop>
</cfif>
