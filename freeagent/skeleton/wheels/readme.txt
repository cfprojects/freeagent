===== INSTALLATION =====

1. Copy the files in this directory into your CF on Wheels application 
	- merge Application.cfc and /events/onApplicationStart.cfm if necessary 
	- replace "myapp" with the name of your FreeAgent application IoC Container 
	
	Example: 
		<cfset FreeAgent.newContainer("galleon","ioc.coldspringadapter").init("... path to ColdSpring config ..." />
	
2. Edit /controllers/myapp.cfc and replace "myapp" with the name of your FreeAgent application IoC container 

	Example: FreeAgentInit("galleon") // (Galleon forums created by ray camden http://galleon.riaforge.org) 

2. Rename the /controllers/myapp.cfc to match your desired URL i.e. "/controllers/forum.cfc" 

3. Rename the directory /views/myapp to match your FreeAgent controller (desired URL) 
	
	Example: /views/forum/ 
	
4. Copy your FreeAgent views to the directory in step 3 

5. Edit the /views/[myapp]/head.cfm template 
	- replace "myapp" with the name of your FreeAgent application IoC container from step 2 
	
6. Edit the IoC config for your application to provide full URLs for links, images, style sheets, etc. 
	by editing the init arguments for the AssetManager and LinkManager beans (assetmanager.cfc / linkmanager.cfc) 
	
	