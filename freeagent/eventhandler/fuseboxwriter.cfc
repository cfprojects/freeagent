<cfcomponent output="false" extends="writer">
	
	<cfset instance.framework = "fusebox" />
	
	<cffunction name="writeCircuitComponent" access="public" output="false">
		<cfargument name="fusebox" type="any" required="true" />
		<cfargument name="circuit" type="string" required="true" />
		<cfargument name="container" type="string" required="true" />
		<cfargument name="eventhandler" type="string" required="true" />
		<cfset var eh = getEventHandler(arguments.container,arguments.eventhandler) />
		<cfset var loc = structNew() />
		<cfset var x = 0 />
		
		<cffile action="write" output="#XmlTransform(getXML(eh,container,eventhandler),getXSL())#" 
			file="#fusebox.rootDirectory#/controller/#lcase(arguments.circuit)#.cfc"  />
	</cffunction>
	
</cfcomponent>