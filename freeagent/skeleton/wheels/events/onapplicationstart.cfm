<!--- Place code here that should be executed on the "onApplicationStart" event. ---> 

<cfscript>
	// the call to resetContainers() ensures that all the containers are cleaned up if the app is restarted 
	FreeAgent = CreateObject("component","freeagent.freeagent").init().resetContainers(); 
	FreeAgent.newContainer("myapp","freeagent.ioc.coldspringadapter").init("...path to coldspring config..."); 
</cfscript>

