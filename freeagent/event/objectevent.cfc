<cfcomponent displayname="FreeAgent.event.ObjectEvent" extends="genericevent" output="false">
	
	<cfset instance.getCollection = "getAllValues" />
	
	<cffunction name="getCollection" access="public" output="false" returntype="struct">
		<cfset var result = "" />
		
		<cfinvoke component="#instance.event#" 
			method="#instance.getCollection#" 
			returnvariable="result" />
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="onMissingMethod" access="public" output="false" 
	hint="this method is provided purely for the benefit of the framework in which the app is installed -- do not use this in your code">
		<cfargument name="MissingMethodName" type="string" required="true" />
		<cfargument name="MissingMethodArguments" type="any" required="true" />
		<cfset var arg = arguments.MissingMethodArguments />
		<cfset var result = "" />
		<cfset var x = 0 />
		
		<cfif structKeyExists(MissingMethodArguments,1)>
			<cfinvoke 
				component="#instance.event#" 
				method="#arguments.MissingMethodName#" 
				returnvariable="result">
					<cfloop index="x" from="1" to="#ArrayLen(arg)#">
						<cfinvokeargument name="#x#" value="#arg[x]#" />
					</cfloop>
			</cfinvoke>
		<cfelse>
			<cfinvoke 
				component="#instance.event#" 
				method="#arguments.MissingMethodName#" 
				argumentcollection="#arguments#" 
				returnvariable="result" />
		</cfif>
		
		<cfif isDefined("result")>
			<cfreturn result />
		</cfif>
	</cffunction>
	
</cfcomponent>