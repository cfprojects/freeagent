<cfcomponent output="false" extends="freeagent.util">
	
	<cfset variables.instance = structNew() />
	<cfset instance.framework = "" />
	
	<cffunction name="getXSL" access="private" output="false">
		<cfreturn ExpandPath("/freeagent/eventhandler/#instance.framework#.xsl") />
	</cffunction>
	
	<cffunction name="getXML" access="private" output="false">
		<cfargument name="component" type="any" required="true" />
		<cfargument name="container" type="string" required="true" />
		<cfargument name="eventhandler" type="string" required="true" />
		<cfscript>
			var eh = arguments.component; 
			var result = XmlParse("<handler />"); 
			var node = 0; 
			var x = 0; 
			
			result.handler.xmlAttributes["container"] = arguments.container; 
			result.handler.xmlAttributes["eventhandler"] = arguments.eventhandler; 
			
			for (x in eh) { 
				if (isCustomFunction(eh[x]) 
				and not listfindnocase("init,onEventStart,onEventEnd,onMissingEvent,getFreeAgent",x)) { 
					node = XmlElemNew(result,"event"); 
					node.xmlAttributes["name"] = lcase(x); 
					arrayAppend(result.handler.xmlChildren,node); 
				} 
			} 
			
			return result; 
		</cfscript>		
	</cffunction>
	
	<cffunction name="getEventHandler" access="private" output="false">
		<cfargument name="container" type="string" required="true" />
		<cfargument name="eventhandler" type="string" required="true" />
		<cfreturn getFreeAgent().getContainer(arguments.container).getBean(eventhandler) />
	</cffunction>
	
</cfcomponent>