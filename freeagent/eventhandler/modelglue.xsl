<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/*">
		<xsl:variable name="container" select="@container" />
		<xsl:variable name="eventhandler" select="@eventhandler" />
		<xsl:variable name="urlprefix" select="@urlprefix" />
		
<xsl:text disable-output-escaping="yes"><![CDATA[<?xml version="1.0" encoding="UTF-8"?>

]]></xsl:text>

<modelglue>
	
	<xsl:comment>
		XML Config File created by FreeAgent for ColdFusion 
		http://freeagent.riaforge.org
	</xsl:comment>
	
	<controllers>
		<controller id="{$container}" type="freeagent.eventhandler.modelglue">
			<message-listener message="invoke{$container}event" function="InvokeFreeAgentEvent" />
		</controller>
	</controllers>
	
	<event-types>
		<event-type name="{$container}Page">
			<before />
			<after>
				<views>
					<include name="body" template="{$container}.cfm" />
				</views>
			</after>
		</event-type>
	</event-types>
	
	<event-handlers>
		<xsl:for-each select="event"><xsl:text>
		
		</xsl:text><event-handler name="{$urlprefix}.{@name}" type="{$container}Page">
			<broadcasts>
				<message name="invoke{$container}event">
					<argument name="container" value="{$container}" />
					<argument name="eventhandler" value="{$eventhandler}" />
					<argument name="eventName" value="{@name}" />
				</message>
			</broadcasts>
			<results />
			<views />
		</event-handler>
		</xsl:for-each>
	</event-handlers>
	
</modelglue>
	</xsl:template>

</xsl:stylesheet>