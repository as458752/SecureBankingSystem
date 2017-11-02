<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="com.group2.banking.controller.*" %>
<%@ page import="java.sql.*" %>
<%@page import="com.group2.banking.service.*" %>
<%@ page import="org.springframework.jdbc.support.rowset.SqlRowSet" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GoSwiss</title>
  <link rel="stylesheet" type="text/css" href="IUP-1.css">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<nav class="navbar navbar-inverse" >
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">GoSwiss</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active container-fluid"><form action="${contextPath}/welcomePage"><input type="submit" value="Home" method="GET" class="navbar-brand"></form></li>
      <li><form action="${contextPath}/ViewUsers"><input type="submit" value="Users" method="GET" class="navbar-brand"></form></li>
      <li><form action="${contextPath}/pendingApprovals"><input type="submit" value="PendingApprovals" method="GET" class="navbar-brand"></form></li>
      <%
      response.setHeader( "Pragma", "no-cache" );
	   response.setHeader( "Cache-Control", "no-cache" );
	   response.setDateHeader( "Expires", 0 );
      		try{
                SqlRowSet rs = DBConnector.execute("select * from account where type_id=3 and account_status=1 and user_id=?", new Object[]{Integer.parseInt(SessionManagement.check(request,"user_id"))}, new int[]{Types.INTEGER});
                SqlRowSet rs1 = DBConnector.execute("select * from account where type_id=3 and account_status=1 and user_id=?", new Object[]{Integer.parseInt(SessionManagement.check(request,"user_id"))}, new int[]{Types.INTEGER});
      %>
      <%if((SessionManagement.check(request, "user_role").equals("4") && rs.next()) || (SessionManagement.check(request, "user_role").equals("5") && rs1.next())){ %>
      <li><form action="${contextPath}/viewCreditFunctions"><input type="submit" value="Credit Functions" method="GET" class="navbar-brand"></form></li>
      <%}} 
      	catch(Exception e){
      		System.out.println(e);
      		response.sendRedirect("error.jsp");
      		return;
      	}
      %>
      <li><form action="${contextPath}/changepasswordpage"><input type="submit" value="Change Password" method="GET" class="navbar-brand"></form></li>
      <li><form action="${contextPath}/Logout"><input type="submit" value="LOGOUT" method="GET" class="navbar-brand"></form></li>
    </ul>
  </div>
</nav>
</body>
</html>