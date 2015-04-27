===== INSTALLATION =====

To install your FreeAgent application into the onTap framework 

1. Rename the /myapp directory to match your desired URL, i.e. "/forum" 

2. Rename the /_tap/myapp directory to match your desired URL i.e. "/_tap/_forum" 

3. Rename the directory /_tap/_includes/[myapp] to match your FreeAgent application container 
	
	Example: /_tap/_includes/galleon (Galleon forums created by ray camden http://galleon.riaforge.org)  

4. Copy your FreeAgent views to the directory in step 3 

5. Edit the templates /_tap/_htmlhead/100_freeagent.cfm and /_tap/_local/100_freeagent.cfm 
	- replace "myapp" with the name of your FreeAgent application container, 
	
	Example: <cfinclude template="/inc/galleon/xxx.cfm" />
	
6. Rename /_tap/_config/ioc/myapp.cfc to match your application and edit the contents to create your container 
	
	Example: /_tap/_config/ioc/galleon.cfc 
	
	<cffunction name="configure" access="public" output="false" returntype="void">
		<cfset newContainer("galleon","ioc.coldspringadapter").init(ExpandPath("/inc/galleon/config.xml.cfm")) />
	</cffunction>

7. Edit the IoC config for your application to provide full URLs for links, images, style sheets, etc. 
	by editing the init arguments for the AssetManager and LinkManager beans (assetmanager.cfc / linkmanager.cfc) 
	
	