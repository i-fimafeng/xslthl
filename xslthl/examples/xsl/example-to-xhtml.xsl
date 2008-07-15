<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:s6hl="http://net.sf.xslthl/ConnectorSaxon6" xmlns:sbhl="http://net.sf.xslthl/ConnectorSaxonB" xmlns:xhl="http://net.sf.xslthl/ConnectorXalan"
	xmlns:saxon6="http://icl.com/saxon" xmlns:saxonb="http://saxon.sf.net/" xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:xslthl="http://xslthl.sf.net" extension-element-prefixes="s6hl sbhl xhl xslthl">
	
	<!-- produce xhtml -->
	<xsl:output indent="no" method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
		
	<!-- this parameter is used to set the location of the filename -->
	<xsl:param name="xslthl.config" />
	
	<!-- this construction is needed to have the saxon and xalan connectors working alongside each other -->
	<xalan:component prefix="xhl" functions="highlight">
		<xalan:script lang="javaclass" src="xalan://net.sf.xslthl.ConnectorXalan" />
	</xalan:component>
	
	<!-- for saxon 6 -->
	<saxon6:script implements-prefix="s6hl" language="java" src="java:net.sf.xslthl.ConnectorSaxon6" />
	
	<!-- for saxon 8.5 and later -->
	<saxonb:script implements-prefix="sbhl" language="java" src="java:net.sf.xslthl.ConnectorSaxonB" />  
	
	<!-- start of the stylesheet -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
			<head>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
				<title>Example syntax highlighting with xslthl</title>
				<style><![CDATA[
BODY {
	color: black;
	background: white;
	padding: 0.5em;
}				

PRE {
	background: #ffe;
	border: 1px solid #eed;
}

H1 {
	border-left: 5px solid #aaf;
	padding-left: 0.25em;
	margin-left: -0.5em;
	background: #eef;
}
				]]></style>
			</head>
			<body>
				<div
					style="border: 5px dashed green; background: white; font-family: sans-serif; font-size: 1.5em; padding: 0.5em; text-align: center;">
					The following is an example of syntax highlighting through xslt using
					<a href="http://sourceforge.net/projects/xslthl">xslthl</a>
					. The following Xslt processor was used:
					<xsl:value-of select="system-property('xsl:vendor')" />
					(
					<xsl:value-of select="system-property('xsl:vendor-url')" />
					)
				</div>
				<xsl:apply-templates />
				<hr />
				<address>
					Generated by:
					<xsl:value-of select="system-property('xsl:vendor')" />
					(
					<xsl:value-of select="system-property('xsl:vendor-url')" />
					) - Xslt version:
					<xsl:value-of select="system-property('xsl:version')" />
				</address>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="para">
		<p>
			<xsl:apply-templates />
		</p>
	</xsl:template>
	<xsl:template match="header">
		<h1>
			<xsl:apply-templates />
		</h1>
	</xsl:template>
	<xsl:template match="bold">
		<b>
			<xsl:apply-templates />
		</b>
	</xsl:template>
	<xsl:template match="underline">
		<u>
			<xsl:apply-templates />
		</u>
	</xsl:template>
	<xsl:template match="code">
		<xsl:variable name="result">
			<xsl:call-template name="syntax-highlight">
				<xsl:with-param name="language">
					<xsl:value-of select="@language" />
				</xsl:with-param>
				<xsl:with-param name="source" select="." />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="count(ancestor::code) &gt; 0">
				<!-- prevent starting a new "pre" part when it's already highlighted -->
				<xsl:copy-of select="$result" />
			</xsl:when>
			<xsl:otherwise>
				<pre>
					<xsl:copy-of select="$result" />
				</pre>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- highlighting of the xslthl tags -->
	<xsl:template match="xslthl:keyword">
		<b>
			<xsl:value-of select="." />
		</b>
	</xsl:template>
	<xsl:template match="xslthl:string">
		<span style="color: blue;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	<xsl:template match="xslthl:number">
		<span style="color: blue;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	<xsl:template match="xslthl:comment">
		<span style="color: green; font-style: italic;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	<xsl:template match="xslthl:directive">
		<span style="color: maroon;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	<xsl:template match="xslthl:annotation">
		<span style="color: gray; font-style: italic;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>

	<!-- default XML styles -->
	<xsl:template match="xslthl:tag">
		<span style="color: teal;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	<xsl:template match="xslthl:attribute">
		<span style="color: purple;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	<xsl:template match="xslthl:value">
		<span style="color: blue;">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	
	<!-- This template will perform the actual highlighting -->
	<xsl:template name="syntax-highlight">
		<xsl:param name="language" />
		<xsl:param name="source" />
		<xsl:choose>
			<xsl:when test="function-available('s6hl:highlight')">
				<xsl:variable name="highlighted" select="s6hl:highlight($language, $source, $xslthl.config)" />
				<xsl:apply-templates select="$highlighted" />
			</xsl:when>
			<xsl:when test="function-available('sbhl:highlight')">
				<xsl:variable name="highlighted" select="sbhl:highlight($language, $source, $xslthl.config)" />
				<xsl:apply-templates select="$highlighted" />
			</xsl:when>
			<xsl:when test="function-available('xhl:highlight')">
				<xsl:variable name="highlighted" select="xhl:highlight($language, $source, $xslthl.config)" />
				<xsl:apply-templates select="$highlighted" />
			</xsl:when>
			<xsl:otherwise>
				<div style="border: 2px solid red; background: white; font-family: sans-serif; padding: 0.5em; font-size: 2em;">No syntax highligter available</div>
				<xsl:apply-templates select="$source/*|$source/text()" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>