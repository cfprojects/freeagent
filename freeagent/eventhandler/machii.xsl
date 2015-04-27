<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/*">
		<xsl:variable name="container" select="@container" />
		<xsl:variable name="eventhandler" select="@eventhandler" />
		
<xsl:text disable-output-escaping="yes"><![CDATA[<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE mach-ii PUBLIC "-//Mach-II//DTD Mach-II Configuration 1.6.0//EN"
	"http://www.mach-ii.com/dtds/mach-ii_1_6_0.dtd" >
]]></xsl:text>

<xsl:comment>
	XML Config File created by FreeAgent for ColdFusion 
	http://freeagent.riaforge.org
</xsl:comment>

<mach-ii version="1.6">
	
	<xsl:comment> LISTENERS </xsl:comment>
	<listeners>
		<listener name="{$container}listener" type="freeagent.eventhandler.machii">
			<parameters>
				<parameter name="container" value="{@container}" />
				<parameter name="eventhandler" value="{@eventhandler}" />
			</parameters>
		</listener>
	</listeners>
	
	<xsl:comment> EVENT-HANDLERS </xsl:comment>
	<event-handlers>
		<xsl:for-each select="event"><xsl:text>
		
		</xsl:text><event-handler event="{@name}" access="public">
			<notify listener="{$container}listener" method="{@name}" />
			<execute subroutine="do{$container}layout"/>
		</event-handler>
		</xsl:for-each>
	</event-handlers>
	
	<xsl:comment> SUBROUTINES </xsl:comment>
	<subroutines>
		<subroutine name="do{$container}layout">
			<view-page name="{$container}" />
		</subroutine>
	</subroutines>
	
	<xsl:comment> PAGE-VIEWS </xsl:comment>
	<page-views>
		<page-view name="{$container}" page="/views/{$container}.cfm" />
	</page-views>
	
</mach-ii>
	</xsl:template>

</xsl:stylesheet>