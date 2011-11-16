<%@ page session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Sign In</title>
</head>
<body onload="javascript:signin.submit();">
	<form id="signin" action="<c:url value="/signin/facebook" />"
		method="POST">
		<button type="submit">Sign in with Facebook</button>
		<input type="hidden" name="scope"
			value="email,read_stream,offline_access" />
	</form>
</body>
</html>
