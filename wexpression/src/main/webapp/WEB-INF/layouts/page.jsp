<?xml version="1.0" encoding="UTF-8" ?>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ page session="false"%>
<html>
<head>
<title>Wexpression</title>


<link rel="stylesheet" href="<c:url value="/resources/page.css" />"
	type="text/css" media="screen" />
<link rel="stylesheet" href="<c:url value="/resources/form.css" />"
	type="text/css" media="screen" />
<link rel="stylesheet"
	href="<c:url value="/resources/messages/messages.css" />"
	type="text/css" media="screen" />
<link rel="stylesheet"
	href="<c:url value="/resources/jquery-ui/1.8.19/css/ui-lightness/jquery-ui-1.8.19.custom.css" />"
	type="text/css" media="screen" />
	
<script type="text/javascript"
	src="<c:url value="/resources/jquery/1.7/jquery.js" />"></script>
<script type="text/javascript"
	src="<c:url value="/resources/jquery-ui/1.8.19/js/jquery-ui-1.8.19.custom.min.js" />" />


<meta name="google" value="notranslate" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><!-- Include CSS to eliminate any default margins/padding and set the height of the html element and 
             the body element to 100%, because Firefox, or any Gecko based browser, interprets percentage as 
             the percentage of the height of its parent container, which has to be set explicitly.  Fix for
             Firefox 3.6 focus border issues.  Initially, don't display flashContent div so it won't show 
             if JavaScript disabled.
        -->
<style type="text/css" media="screen">
html,body {
	height: 100%;
}

body {
	margin: 0;
	padding: 0;
	overflow: auto;
	text-align: center;
	background-color: #ffffff;
}

object:focus {
	outline: none;
}

#flashContent {
	display: none;
}
</style>

<!-- Enable Browser History by replacing useBrowserHistory tokens with two hyphens -->
<!-- BEGIN Browser History required section -->
<link rel="stylesheet" type="text/css"
	href="<c:url value="/resources/flash/history/history.css" />" />
<script type="text/javascript"
	src="<c:url value="/resources/flash/history/history.js" />"></script>
<!-- END Browser History required section -->

<script type="text/javascript"
	src="<c:url value="/resources/flash/swfobject.js" />"></script>

</head>
<body>
	<div id="header">
		<h1>
			<a href="<c:url value="/"/>">Wexpression</a>
		</h1>
	</div>
	<div id="leftNav">
		<tiles:insertTemplate template="menu.jsp" />
	</div>

	<div id="content">
		<tiles:insertAttribute name="content" />
	</div>
</body>
</html>
