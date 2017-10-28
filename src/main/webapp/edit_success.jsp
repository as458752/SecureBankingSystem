<%@page language="java"%>
<%@page import="java.sql.*"%>
<%@ page import="com.group2.banking.controller.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">

<head>
<script language="javascript">
function validateSession(){
	<%
	response.setHeader( "Pragma", "no-cache" );
	   response.setHeader( "Cache-Control", "no-cache" );
	   response.setDateHeader( "Expires", 0 );
	try {
		if(SessionManagement.check(request,"user_id")==null || SessionManagement.check(request,"user_id").equals("") || SessionManagement.check(request,"user_id").equals("null")){
			response.sendRedirect("login.jsp");
			return;
		}
	   
        }
        catch(Exception e)
        {
        response.sendRedirect("error.jsp");
        } 
	 
		int role_id = Integer.parseInt(SessionManagement.check(request,"user_role"));
	%>
}
</script>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>GoSwiss</title>

    <link href="/bank/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="/bank/resources/css/common.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
  
<div class="container">
</div>

<h1><center>Edit User</center></h1>

<br><br>

<div class="userform">
<form method="POST" action="${contextPath}/edituser" class="form-signin">


<fieldset>
    <span>${message}</span>
  <span>${message1}</span>
    <h2><legend><strong>Information of user ${username} has been edited:</strong></legend></h2>
        <br>
        <strong>First name:</strong><Label> ${firstname}  </Label>
        <br>
        <strong>Last name:</strong><Label> ${lastname}  </Label> <br>
        
    
      <!--  <strong>E-mail:</strong> <Label> ${email}  </Label>
        <br>  --> 
        <strong>Address:</strong> <Label> ${address} </Label>
        <br>
        <strong>Phone:</strong> <Label> ${phone}  </Label>
        <br>
         <strong>Role: </strong> <Label> ${roles}  </Label>
   
        <br>
        <br>
   
    <h4 class="text-center"><a href="welcome.jsp"><input type="button" value="Back" name="Back"/></a></h4>  
  </fieldset>
  

</table>
</form>
</div>
</body>
</html>