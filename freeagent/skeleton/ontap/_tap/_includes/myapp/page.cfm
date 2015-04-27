<cfif event.isAjaxRequest()>
	<!--- 
		this is the mechanism for returning partial-page content for ajax requests 
	--->
	<cf_html return="tap.view.content" skin="myapp">
		<cfinclude template="#lcase(event.getView())#.cfm" />
	</cf_html>
	
	<cfcontent reset="true" />
	<cfinclude template="/inc/displaymode/html.cfm" />
	<cf_abort />
<cfelse>
	<cf_html return="tap.view.content" skin="myapp">
		<cfinclude template="layout.cfm" />
	</cf_html>
</cfif>
