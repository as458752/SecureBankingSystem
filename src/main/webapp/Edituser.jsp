<%@page language="java"%>
<%@page import="java.sql.*"%>
<%@ page import="com.group2.banking.controller.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.group2.banking.service.*" %>

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
    
    <script type="text/javascript">
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
    		if(!SessionManagement.check(request,"user_role").equals("1") && !SessionManagement.check(request,"user_role").equals("2")){
    			response.sendRedirect("AuthError.jsp");
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
    
    function validate()
    {
        var b = document.myform.firstname.value;
        var c = document.myform.lastname.value;
        
        var f = document.myform.Address.value;
        var g = document.myform.Phone.value;
         if(b.length>20)
         {  
             alert("Firstname can not have more than 20 characters");
             return false;
         }
         else if(c.length>20)
         {  
             alert("Lastname can not have more than 20 characters");
             return false;
         } 
         else if(f.length>40)
         {  
             alert("Address can not have more than 40 characters");
             return false;
         }
         
       else if(g.length>12)
         {  
             alert("Phone can not have more than 12 digits");
             return false; 
         }
       else if(g<0)
       {  
           alert("Phone number cannot be negative");
           return false; 
       }


    };

        </script>
        
        
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
  
<div class="container">
</div>

<h1><center>Edit User</center></h1>

<br><br>

<div class="userform">
<form method="POST" name="myform" action="${contextPath}/edituser" onsubmit="return validate();" class="form-signin">

<%
String id=request.getParameter("id");
int no=Integer.parseInt(id);
int sumcount=0;
try {
Connection conn = DBConnector.getConnection();
/* String query = "select * from users where user_id="+no;
Statement st = conn.createStatement();
ResultSet rs = st.executeQuery(query); */

String query = "select * from users where user_id=?";


PreparedStatement preparedStatement = conn.prepareStatement(query);
preparedStatement.setInt(1, no);
ResultSet rs=null;
synchronized(MutexLock.getUsersTableMutex())
{
rs = preparedStatement.executeQuery();
}

while(rs.next()){
	SessionManagement.update(request,"EdituserName",rs.getString(2));
%>
<fieldset>
  <%if(SessionManagement.check(request,"user_role").equals("1")){ %>
  <h4 class="text-center"><a href="Welcome_Tier1.jsp"><input type="button" value="Back" name="Back"/></a></h4>
  <%} else{%>
  <h4 class="text-center"><a href="Welcome_Tier2.jsp"><input type="button" value="Back" name="Back"/></a></h4>
  <%} %>
    <span>${message}</span>
  <span>${message1}</span>
    <h2><legend><strong>User information:</strong></legend></h2>
        <strong>First name:</strong><br>
        <input type="text" name="firstname" value="<%=rs.getString(4)%>" required >
        <br><br>
        <strong>Last name:</strong><br>
        <input type="text" name="lastname" value="<%=rs.getString(5)%>" required><br><br>
        
        <strong>Address:</strong><br>
        <input type="text" name="Address" value="<%=rs.getString(7)%>" required><br>
        <br>
        <strong>Phone:</strong><br>
        <input type="number" name="Phone"  value="<%=rs.getString(8)%>" required><br>
        <br>
 		<br>
 		<br>
 		<input type="submit" value="Submit">
    
  </fieldset>
  
<%
}
}
catch(Exception e){
	response.sendRedirect("error.jsp");
}
%>
</table>
</form>
</div>
</body>
</html>