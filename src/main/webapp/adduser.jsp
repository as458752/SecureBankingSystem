<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
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
<body>

<nav class="navbar navbar-inverse" >
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">GoSwiss</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="#">Home</a></li>
      <li><a href="#">Page 1</a></li>
      <li><a href="#">Page 2</a></li>
      <li><a href="#">Page 3</a></li>
    </ul>
  </div>
</nav>
  
<div class="container">
  
</div>
<h1><center>USER REGISTRATION FORM</center></h1>
<br><br>
<div class="userform">
<form method="POST" action="${contextPath}/adduser" class="form-signin">
  <fieldset>
  <h4 class="text-center"><a href="welcome.jsp"><input type="button" value="Back" name="Back"/></a></h4>
    <span>${message1}</span>
  <span>${message3}</span>
    <h2><legend><strong>User information:</strong></legend></h2>
        <strong>First name:</strong><br>
        <input type="text" name="firstname" required >
        <br><br>
        <strong>Last name:</strong><br>
        <input type="text" name="lastname"  required><br><br>
        <strong>User name:</strong><br>
        <input type="text" name="username"  required><br>
        <br>
        <strong>Password:</strong><br>
        <input type="password" name="password"  required><br>
        <br>
         <strong>Re-enter Password:</strong><br>
        <input type="password" name="password2"  required><br>
        <br>
        <strong>E-mail:</strong><br>
        <input type="text" name="Email"  required><br>
        <br>
        <strong>Address:</strong><br>
        <input type="text" name="Address"  required><br>
        <br>
        <strong>Phone:</strong><br>
        <input type="number" name="Phone"  required><br>
        <br>
         <strong>Roles:</strong><br>
        <select>
  <option value="Regular Employee">Regular Employee</option>
  <option value="System Manager">System Manager</option>
  <option value="dministrator">Administrator</option>
  <option value="Individual User">Individual User</option>
  <option value="Merchant">Merchant</option>
</select> 
        <br>
    <br><br>
    <button class="button"><b>Submit</b></button>
    
  </fieldset>
</form></div>


</body>
</html>