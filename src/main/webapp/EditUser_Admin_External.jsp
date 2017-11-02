<%@page language="java"%>
<%@page import="java.sql.*"%>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
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
    		if(SessionManagement.check(request,"user_role").equals("1") || SessionManagement.check(request,"user_role").equals("2")){
    			response.sendRedirect("AuthError.jsp");
    			return;
    		}
    		
    		String id = request.getParameter("id");
    		
    		if(id==null || id.equals("") || id.equals("null") || id.equals("NULL") || (!SessionManagement.check(request,"user_id").equals(id) && !SessionManagement.check(request,"user_role").equals("3"))){
    			response.sendRedirect("AuthError.jsp");
    			return;
    		}
    		
    		PreparedStatement st = DBConnector.getConnection().prepareStatement("select * from users where user_id=?");
    		st.setInt(1,Integer.parseInt(request.getParameter("id")));
    		ResultSet rs = null;
    		synchronized(MutexLock.getUsersTableMutex()){
    			rs = st.executeQuery();
    		}
    		
    		if(!rs.next()){
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
        var a = document.myform.username.value;
        var b = document.myform.firstname.value;
        var c = document.myform.lastname.value;
        
   
        
        var e = document.myform.Email.value;
        var f = document.myform.Address.value;
        var g = document.myform.Phone.value;
         if(a.length>20)
            {  
                alert("Username can not have more than 20 characters");
                return false;
            }
         else if(b.length>20)
         {  
             alert("Firstname can not have more than 20 characters");
             return false;
         }
         else if(c.length>20)
         {  
             alert("Lastname can not have more than 20 characters");
             return false;
         }
         
         else if(e.length>20)
         {  
             alert("Email can not have more than 20 characters");
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


 /*     return true;   */
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
  <%if(SessionManagement.check(request,"user_role").equals("3")){ %>
  <h4 class="text-center"><a href="Welcome_Admin.jsp"><input type="button" value="Back" name="Back"/></a></h4>
  <%} else{%>
  <h4 class="text-center"><a href="Welcome_External.jsp"><input type="button" value="Back" name="Back"/></a></h4>
  <%} %>
    <span>${message}</span>
  <span>${message1}</span>
    <h2><legend><strong>User information:</strong></legend></h2>
        <br>
        <strong>First name:</strong><br>
        <input type="text" name="firstname" value="<%=rs.getString(4)%>" required >
        <br><br>
        <strong>Last name:</strong><br>
        <input type="text" name="lastname" value="<%=rs.getString(5)%>" required><br><br>
        <strong>Email:</strong><br>
        <input type="text" name="email" value="<%=rs.getString(6)%>" required >
        <br><br>
        <strong>Address:</strong><br>
        <input type="text" name="Address" value="<%=rs.getString(7)%>" required><br>
        <br>
        <strong>Phone:</strong><br>
        <input type="number" name="Phone"  value="<%=rs.getString(8)%>" required>
        <br><br>
        <%if(SessionManagement.check(request,"user_role").equals("3")){ %>
        	<strong>Roles:</strong><br> <select name="Role">
					<%if(rs.getString(9).equals("4") || rs.getString(9).equals("5")) {%>
					<option value="4">Individual User</option>
					<option value="5">Merchant</option>
					<%}else{ %>
						<option value="1">Regular Employee</option>
						<option value="2">System Manager</option>
						<option value="3">Administrator</option>
					<%} %>
				</select>
        <%} %>
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