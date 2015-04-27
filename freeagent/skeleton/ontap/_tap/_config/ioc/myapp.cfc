<cfcomponent extends="config" hint="configure your FreeAgent containers">
	<!--- loadafter allows you to load this FreeAgent app after another FreeAgent app --->
	<!--- <cfset loadAfter("plugins") /> --->
	
	<cffunction name="configure" access="public" output="false" returntype="void">
		<cfset newContainer("myapp","ioc.coldspringadapter").init("...path to coldspring config...") />
	</cffunction>
	
</cfcomponent>
