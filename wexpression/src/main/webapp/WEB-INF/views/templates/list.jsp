<%@page import="flex.messaging.io.amf.ASObject"%>
<%@ page session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<body>
	<ul>
		<c:forEach items="${templates}" var="template">
		<li>${template.get("path") }</li>
		</c:forEach>
	</ul>
</body>
</html>