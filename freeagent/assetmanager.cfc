<cfcomponent displayname="FreeAgent.AssetManager" extends="util" output="false"
hint="Manages external files for an HTML template">
	<cfset variables.instance = structNew() />
	<cfset instance.crlf = chr(13) & chr(10) />
	
	<cffunction name="init" access="public" output="false">
		<cfargument name="siteURL" type="string" required="false" default="/" />
		<cfargument name="assets" type="string" required="false" default="assets/" />
		<cfargument name="images" type="string" required="false" default="images/" />
		<cfargument name="styles" type="string" required="false" default="styles/" />
		<cfargument name="scripts" type="string" required="false" default="scripts/" />
		<cfargument name="flash" type="string" required="false" default="swf/" />
		
		<cfset structAppend(variables.instance,arguments,true) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSiteURL" access="public" output="false" returntype="string">
		<cfreturn instance.siteURL />
	</cffunction>
	
	<cffunction name="getAssetURL" access="public" output="false" returntype="string">
		<cfreturn getSiteURL() & instance.assets />
	</cffunction>
	
	<cffunction name="getSRC" access="public" output="false" returntype="string">
		<cfargument name="src" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="" />
		<cfset var uri = getAssetURL() />
		
		<cfif len(trim(type)) and structKeyExists(instance,arguments.type)>
			<cfset uri = uri & instance[arguments.type] />
		</cfif>
		
		<cfreturn uri & arguments.src />
	</cffunction>
	
	<cffunction name="img" access="public" output="false" returntype="string">
		<cfargument name="src" type="string" required="true" />
		<cfscript>
			var img = htmleditformat(getSRC(arguments.src,"images")); 
			structDelete(arguments,"src"); 
			return "<img src=""#img#""#formatAttributes(arguments)# />"; 
		</cfscript>
	</cffunction>
	
	<cffunction name="style" access="public" output="false" returntype="string">
		<cfargument name="href" type="string" required="true" />
		<cfreturn "<link rel=""stylesheet"" type=""text/css"" href=""#htmleditformat(getSRC(arguments.href,'styles'))#"" />" />
	</cffunction>
	
	<cffunction name="script" access="public" output="false" returntype="string">
		<cfargument name="src" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="text/javascript" />
		<cfreturn "<script type=""#htmleditformat(arguments.type)#"" src=""#htmleditformat(getSRC(arguments.src,'scripts'))#"" /></script>" />
	</cffunction>
	
	<cffunction name="getFlashVars" access="public" output="false" returntype="string">
		<cfargument name="collection" type="struct" required="true" />
		<cfscript>
			var result = ArrayNew(1); 
			var i = 0; 
			
			for (i in collection) { 
				arrayAppend(result,lcase(i) & "=" & urlencodedformat(collection[i])); 
			} 
			
			return ArrayToList(result,"&"); 
		</cfscript>
	</cffunction>
	
	<cffunction name="getFlashParameters" access="public" output="false" returntype="string">
		<cfargument name="collection" type="struct" required="true" />
		<cfscript>
			var result = ArrayNew(1); 
			var i = 0; 
			
			for (i in collection) { 
				arrayAppend(result,"<param name=""#lcase(i)#"" value=""#htmleditformat(collection[i])#"" />"); 
			} 
			
			return arrayToList(collection,instance.crlf); 
		</cfscript>
	</cffunction>
	
	<cffunction name="flash" access="public" output="false" returntype="string">
		<cfargument name="movie" type="string" required="true" />
		<cfargument name="attributes" type="struct" required="false" default="#structNew()#" />
		<cfargument name="flashvars" type="struct" required="false" default="#structNew()#" />
		<cfargument name="parameters" type="struct" required="false" default="#structNew()#" />
		<cfset var my = structNew() />
		<cfset var i = 0 />
		
		<cfif not structIsEmpty(flashvars)>
			<cfset parameters.flashvars = getFlashVars(arguments.flashvars) />
		</cfif>
		<cfparam name="parameters.bgcolor" type="string" default="##FFFFFF" />
		<cfset my.parameters = getFlashParameters(parameters) />
		
		<cfparam name="attributes.height" type="string" default="100%" />
		<cfparam name="attributes.width" type="string" default="100%" />
		
		<cfset my.attributes = formatAttributes(attributes) />
		<cfset my.src = htmleditformat(getSRC(arguments.movie,"flash")) />
		
		<cfsavecontent variable="result"><cfoutput>
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"#my.attributes#>
<param name="movie" value="#my.src#" />
#my.parameters#
<!--[if !IE]>-->
<object type="application/x-shockwave-flash" data="#my.src#"#my.attributes#>
#my.parameters#
<!--<![endif]-->
#getFlashPlayer()#
<!--[if !IE]>-->
</object>
<!--<![endif]-->
</object>
		</cfoutput></cfsavecontent>
	</cffunction>
	
	<cffunction name="getFlashPlayer" access="public" output="false">
		<cfset var result = "" />
		
		<cfsavecontent variable="result"><cfoutput>
			<a href="http://www.adobe.com/go/getflashplayer">
				<img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
			</a>
		</cfoutput></cfsavecontent>
		
		<cfreturn result />
	</cffunction>
	
</cfcomponent>