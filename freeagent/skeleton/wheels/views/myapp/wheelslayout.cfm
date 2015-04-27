<cfif event.isAjaxRequest()>
	<!--- 
		this is the mechanism for returning partial-page content for ajax requests 
	--->
	<cfoutput>#contentForLayout()#</cfoutput>
<cfelse>
	<!--- if this isn't an ajax request, then we display the whole html content --->
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>My App</title>
		
		<cfinclude template="/bc/view/head.cfm" />
	</head>
	
	<body>
		<cfoutput>#contentForLayout()#</cfoutput>
	</body>
	</html>
</cfif>
