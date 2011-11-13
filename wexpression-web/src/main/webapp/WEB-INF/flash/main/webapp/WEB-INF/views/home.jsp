<%@ page session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Home</title>
</head>
<body>
	<ul>
		<li><a href="<c:url value="/signout" />">Sign Out</a>
		</li>
	</ul>
	<img src="./${imgPath}" />
	<h3>Your Facebook Posts</h3>
	<ul>
		<c:forEach items="${posts}" var="post">
			<li><c:out value="${post.message}" />
			</li>
		</c:forEach>
	</ul>
</body>
</html>