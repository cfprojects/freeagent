<!--- put your menus, etc. here --->

<cfinclude template="/freeagent/getevent.cfm" />
<cfinclude template="#lcase(event.getView())#.cfm" />

