<cfcomponent displayname="FreeAgent.IoC.IoCContainer" output="false" 
hint="A generic IoC container - knows how to instantiate an IoC Factory">
	<cfset variables.lockname = "freeagent.ioc." & getTickCount() & "." & randrange(0,999999) />
	<cfset variables.factory = "" />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="factoryClass" type="string" required="true" hint="indicates the class name of the IoC factory to instantiate" />
		<cfargument name="CacheAgentName" type="string" required="false" default="" />
		<cfargument name="CacheContext" type="string" required="false" default="application" />
		<cfargument name="cascade" type="string" required="false" default="" />
		<cfargument name="package" type="string" required="false" default="" />
		<cfargument name="CacheEvict" type="string" required="false" default="none" />
		<cfset setProperties(arguments) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setVersionInfo" access="public" output="false" 
	hint="I allow users to set version information for individual FreeAgent sub-applications">
		<cfargument name="Version" type="string" required="true" hint="a version number, i.e. 1.0.8, etc." />
		<cfargument name="Revision" type="string" required="false" default="" hint="Beta, RC, Final, etc." />
		<cfargument name="ReleaseDate" type="string" required="false" default="" hint="date on which this version was released" />
		<cfargument name="BuildNumber" type="string" required="false" default="#DateFormat(releasedate,'yyyymmdd')#" />
		<cfset setProperties(arguments) />
	</cffunction>
	
	<cffunction name="VersionCompare" access="public" output="false" returntype="boolean" 
	hint="indicates if the installed version of the FreeAgent sub-application is at least the specified version">
		<cfargument name="version" type="string" required="false" default="" />
		<cfargument name="releasedate" type="string" required="false" default="" />
		<cfargument name="buildnumber" type="string" required="false" default="" />
		<cfscript>
			var loc = structNew(); 
			var x = 0; 
			
			if (val(arguments.buildnumber)) { 
				loc.build = getValue("buildnumber"); 
				if (not len(loc.build)) { return false; } 
				if (val(loc.build) lt val(arguments.buildnumber)) { return false; } 
			} 
			
			if (isdate(arguments.releasedate)) { 
				loc.release = getValue("releasedate"); 
				if (not isDate(loc.release)) { return false; } 
				if (loc.release lt arguments.releasedate) { return false; } 
			} 
			
			if (len(arguments.version)) { 
				loc.current = listToArray(getValue("version"),"."); 
				loc.minimum = listToArray(arguments.version,"."); 
				for (x = 1; x lte max(arraylen(loc.current),arraylen(loc.minimum)); x = x + 1) { 
					if (arraylen(loc.current) lt x) { loc.current[x] = 0; } 
					if (arraylen(loc.minimum) lt x) { loc.minimum[x] = 0; } 
					if (val(loc.current[x]) lt val(loc.minimum[x])) { return false; } 
				} 
			} 
			
			return true; 
		</cfscript>
	</cffunction>
	
	<cffunction name="getBean" access="public" output="false" returntype="any">
		<cfargument name="beanName" type="string" required="true" />
		<cfreturn getFactory().getBean(beanName) />
	</cffunction>
	
	<cffunction name="containsBean" access="public" output="false" returntype="any">
		<cfargument name="beanName" type="string" required="true" />
		<cfreturn getFactory().containsBean(beanName) />
	</cffunction>
	
	<cffunction name="reset" access="public" output="false" hint="reloads the factory configuration">
		<cfset var fact = variables.factory />
		
		<cflock name="#variables.lockname#" type="exclusive" timeout="10">
			<cfset variables.factory = "" />
		</cflock>
		
		<!--- we're throwing away a factory, so if it has a detach method, lets call it to clean up any cache, etc. --->
		<cfif isObject(fact) and structKeyExists(fact,"detach")>
			<cfset fact.detach() />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFactory" access="public" output="false">
		<cflock name="#variables.lockname#" type="exclusive" timeout="10">
			<cfif not isObject(variables.factory)>
				<cfset variables.factory = createFactory() />
			</cfif>
			<cfreturn variables.factory />
		</cflock>
	</cffunction>
	
	<cffunction name="createCacheAgent" access="private" output="false">
		<cfset var agent = "" />
		<cfset var agentname = getValue("CacheAgentName") />
		
		<cfif len(trim(agentname))>
			<!--- we got a name for the cachebox agent, so we'll use a cachebox agent for storage --->
			<cfset agent = CreateObject("component","cacheboxagent").init(agentname,getValue("CacheContext"),getValue("CacheEvict")) />
		<cfelse>
			<!--- no cachebox agent name provided, so we'll default to using a simplestorage object --->
			<cfset agent = CreateObject("component","simplestorage").init() />
		</cfif>
		
		<cfreturn agent />
	</cffunction>
	
	<cffunction name="createFactory" access="private" output="false" 
	returntype="any" hint="creates the factory object and configures it">
		<cfreturn createObject("component", getValue("factoryClass")).init(createCacheAgent(),getValue("cascade"),getValue("package")) />
	</cffunction>
	
	<cffunction name="setProperties" access="public" output="false">
		<cfargument name="collection" type="struct" required="true" />
		<cfset var x = 0 />
		
		<cfloop item="x" collection="#collection#">
			<cfinvoke component="#this#" method="set#x#">
				<cfinvokeargument name="1" value="#collection[x]#" />
			</cfinvoke>
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProperties" access="public" output="false" returntype="struct">
		<cfset var result = structNew() />
		
		<cfloop item="x" collection="#variables.instance#">
			<cfinvoke component="#this#" method="get#x#" returnvariable="result.#x#" />
		</cfloop>
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="getValue" access="public" output="false">
		<cfargument name="property" type="string" required="true" />
		<cfreturn iif(structKeyExists(instance,property),"instance[property]",de("")) />
	</cffunction>
	
	<cffunction name="setValue" access="public" output="false">
		<cfargument name="property" type="string" required="true" />
		<cfargument name="content" type="any" required="true" />
		<cfset instance[property] = content />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false">
		<cfargument name="missingmethodname" type="string" required="true" />
		<cfargument name="missingmethodarguments" type="any" required="true" />
		
		<cfset var result = 0 />
		<cfset var rest = removechars(missingmethodname,1,3) />
		
		<cfswitch expression="#left(missingmethodname,3)#">
			<cfcase value="get">
				<cfreturn getValue(rest) />
			</cfcase>
			<cfcase value="set">
				<cfreturn setValue(rest,missingmethodarguments[1]) />
			</cfcase>
			<cfdefaultcase>
				<cfset raiseMissingMethodException() />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="raiseMissingMethodException" access="private" output="false">
		<cfthrow type="FreeAgent.MissingMethod" 
			message="FreeAgent: the IoC Container for #getValue('iocAgentName')# doesn't understand the method #missingmethodname#" />
	</cffunction>
</cfcomponent>