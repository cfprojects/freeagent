<cfset event = CreateObject("component","freeagent.event.ontap").init(attributes,"myapp") />
<cfset event.InvokeFreeAgentEvent(tap.process) />

<cfinclude template="/inc/myapp/page.cfm" />
