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
<title>OTP</title>
</head>
<body>
	<form action="${contextPath}/OTP">
		<span><h2><strong>${OTPMessage}</strong></h2></span>
    	<input type="text" name="OTP" placeholder="OTP">
    	<input type="submit" name="OTP confirm" class="login login-submit" value="OTP Confirm">
 	</form>
</body>
</html>