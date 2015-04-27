<cfcomponent output="false" extends="writer">
	
	<cfset instance.framework = "machii" />
	
	<cffunction name="writeModuleXML" access="public" output="false">
		<cfargument name="machii" type="any" required="true" />
		<cfargument name="module" type="string" required="true" />
		<cfargument name="container" type="string" required="true" />
		<cfargument name="eventhandler" type="string" required="true" />
		<cfset var loc = structNew() />
		<cfset var x = 0 />
		
		<cfset loc.config = machii.getConfigPath() />
		<cfset loc.configdir = getDirectoryFromPath(loc.config) />
		<cfset loc.eh = getEventHandler(arguments.container,arguments.eventhandler) />
		
		<cffile action="write" output="#XmlTransform(getXML(loc.eh,container,eventhandler),getXSL())#" 
			file="#loc.configdir#/#lcase(arguments.container)#.xml"  />
		
		<!--- check to see if the module is already declared in the main Mach-II config -- if not, add the module --->
		<cfscript>
			loc.xml = XmlParse(loc.config); 
			loc.search = XmlSearch(loc.config,"/mach-ii/modules/module[@name='#lcase(arguments.module)#']"); 
			if (not arrayLen(loc.search)) { 
				loc.node = XmlElemNew(loc.xml,"module"); 
				loc.node.xmlAttributes["name"] = lcase(arguments.module); 
				loc.node.xmlAttributes["file"] = "config/#lcase(arguments.container)#.xml"; 
				loc.machii = loc.xml["mach-ii"]; 
				if (structKeyExists(loc.machii,"modules")) { 
					loc.modules = loc.machii.modules; 
				} else { 
					loc.modules = XmlElemNew(loc.xml,"modules"); 
					loc.machii.xmlChildren[arrayLen(loc.machii.xmlChildren)+1] = loc.modules; 
				} 
				loc.modules.xmlChildren[arrayLen(loc.modules.xmlChildren)+1] = loc.node; 
			} 
		</cfscript>
		
		<cfif not ArrayLen(loc.search)>
			<cffile action="write" file="#loc.config#" output="#toString(loc.xml)#" />
		</cfif>
	</cffunction>
	
</cfcomponent>