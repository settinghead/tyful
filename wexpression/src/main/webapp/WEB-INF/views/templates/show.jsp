<%@page import="java.util.UUID"%>
<%@page import="java.util.Random"%>
<%@ page session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%
UUID swfRandomizer = UUID.randomUUID();
%>

<script type="text/javascript">
	// For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. 
	var swfVersionStr = "10.2.0";
	// To use express install, set to playerProductInstall.swf, otherwise the empty string. 
	var xiSwfUrlStr = "playerProductInstall.swf";
	var flashvars = {};
	flashvars.templateId = "${templateId}";
	flashvars.mode = "${mode}";
	var params = {};
	params.quality = "high";
	params.bgcolor = "#ffffff";
	params.allowscriptaccess = "sameDomain";
	params.allowfullscreen = "true";
	var attributes = {};
	attributes.id = "Main";
	attributes.name = "Main";
	attributes.align = "middle";
	swfobject.embedSWF(
			"<c:url value="/resources/flash/WexpressionClient.swf" />" + "?rnd=<%=swfRandomizer%>",
			"flashContent", "100%", "100%", swfVersionStr, xiSwfUrlStr,
			flashvars, params, attributes);
	// JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
	swfobject.createCSS("#flashContent", "display:block;text-align:left;");
</script>
<!-- SWFObject's dynamic embed method replaces this alternative HTML content with Flash content when enough 
             JavaScript and Flash plug-in support is available. The div is initially hidden so that it doesn't show
             when JavaScript is disabled.
        -->
<div id="flashContent">
	<p>To view this page ensure that Adobe Flash Player version 10.2.0
		or greater is installed.</p>
	<script type="text/javascript">
		var pageHost = ((document.location.protocol == "https:") ? "https://"
				: "http://");
		document
				.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
                                + pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>");
	</script>
</div>

<noscript>
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		width="100%" height="100%" id="Main" name="Main">
		<param name="movie"
			value="<c:url value="/resources/flash/WexpressionClient.swf" />?rnd=<%=swfRandomizer%>" />
		<param name="quality" value="high" />
		<param name="bgcolor" value="#ffffff" />
		<param name="allowScriptAccess" value="sameDomain" />
		<param name="allowFullScreen" value="true" />
		<param name="FlashVars"
			value="mode=${mode}&templateId=${templateId}" />
		<!--[if !IE]>-->
		<object type="application/x-shockwave-flash"
			data="<c:url value="resources/flash/WexpressionClient.swf" />?rnd=<%=swfRandomizer%>"
			width="100%" height="100%">
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="allowFullScreen" value="true" />
			<param name="FlashVars"
				value="mode=${mode}&templateId=${templateId}" />
			<!--<![endif]-->
			<!--[if gte IE 6]>-->
			<p>Either scripts and active content are not permitted to run or
				Adobe Flash Player version 10.2.0 or greater is not installed.</p>
			<!--<![endif]-->
			<a href="http://www.adobe.com/go/getflashplayer"> <img
				src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif"
				alt="Get Adobe Flash Player" />
			</a>
			<!--[if !IE]>-->
		</object>
		<!--<![endif]-->
	</object>
</noscript>