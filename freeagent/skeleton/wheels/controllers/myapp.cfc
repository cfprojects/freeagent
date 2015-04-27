<cfcomponent extends="freeagent.eventhandler.wheels">
	
	<!--- 
		FreeAgentInit allows us to avoid duplicating all the method names in our FreeAgent event handler 
		arguments: 
			container:    name of the FreeAgent application IoC container 
			eventhandler: an event-handling bean within the container 
			layout:       sets the CF Wheels layout template 
	--->
	<cfset FreeAgentInit("myapp") />
	
</cfcomponent>