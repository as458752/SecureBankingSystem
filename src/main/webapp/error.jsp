<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
response.setHeader( "Pragma", "no-cache" );
response.setHeader( "Cache-Control", "no-cache" );
response.setDateHeader( "Expires", 0 );
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GoSwiss</title>
</head>
<body>
<h1> SERVER ERROR OCCURRED! Retry after some-time or Please note the timestamp and contact "GoSwiss" Technical Support </h1>
  <span>${message}</span>
</body>
</html>