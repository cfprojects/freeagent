<cfcomponent displayname="FreeAgent.Util" output="false" 
hint="Provides default functionality for FreeAgent components">
	
	<cffunction name="init" access="public" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFreeAgent" access="public" output="false">
		<cfreturn application.FreeAgent />
	</cffunction>
	
	<cffunction name="formatAttributes" access="private" output="false">
		<cfargument name="collection" type="struct" required="true" />
		<cfscript>
			var result = ""; 
			var i = 0; 
			
			for (i in collection) { 
				result = result & " " & lcase(i) & "=""" & htmleditformat(collection[i]) & """"; 
			} 
			
			return result; 
		</cfscript>
	</cffunction>
	
	<cffunction name="SplitLabel" access="private" output="false" returntype="string">
		<cfargument name="label" type="string" required="true" />
		<cfset var alpha = "abcdefghijklmnopqrstuvwxyz" />
		<cfreturn Replace(REReplace(label,"([#alpha#])([#ucase(alpha)#])","\1 \2","ALL"),"_"," ","ALL") />
	</cffunction>
	
</cfcomponent>