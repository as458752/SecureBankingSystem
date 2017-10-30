<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%
response.setHeader( "Pragma", "no-cache" );
response.setHeader( "Cache-Control", "no-cache" );
response.setDateHeader( "Expires", 0 );
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <link href="<c:url value="/resources/css/jquery-ui.min.css" />" rel="stylesheet">
	<script src="<c:url value="/resources/js/jquery-latest.min.js" />"></script>
	<script src="<c:url value="/resources/js/jquery-ui.min.js" />"></script>

	<!-- keyboard widget css & script (required) -->
	<link href="<c:url value="/resources/css/keyboard.css" />" rel="stylesheet">
	<script src="<c:url value="/resources/js/jquery.keyboard.js" />"></script>
        <script>
		$(function(){
			$('#keyboard').keyboard();
		});
	</script>
        <title>OTP</title>
    </head>
<body>
	<form action="${contextPath}/OTP">
		<span><h2><strong>${OTPMessage}</strong></h2></span>
        <input id="keyboard" type="password" name="OTP">
    	<input type="submit" name="OTP confirm" class="login login-submit" value="OTP Confirm">
 	</form>
</body>
</html>