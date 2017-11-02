<%@page import="org.springframework.jdbc.support.rowset.SqlRowSet"%>
<%@page language="java"%>
<%@page import="java.sql.*"%>
<%@page import="java.lang.System"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>

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
		   //response.sendRedirect("error.jsp");
		   System.out.println(e.getMessage());
		   return;
	    } 
	%>
}
</script>
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<h1><center>Delete Confirmation!</center></h1>

<br><br>

<div class="userform">
<form method="POST" action="${contextPath}/edituser" class="form-signin">

<%
String id=request.getParameter("id");

//User cannot delete his own account..
if(SessionManagement.check(request,"user_id").equals(id)){
	//response.sendRedirect("AuthError.jsp");
	return;
}
int no=Integer.parseInt(id);
try {
//Connection conn = DBConnector.getConnection();
String query = "select * from users where user_id=?";


//PreparedStatement preparedStatement = conn.prepareStatement(query);
//preparedStatement.setInt(1, no);
//ResultSet rs=null;
SqlRowSet rs = DBConnector.execute(query, new Object[]{no}, new int[]{Types.INTEGER});

while(rs.next()){
%>
<fieldset>
    <span>${message}</span>
  <span>${message1}</span>
    <h2><legend><strong>User with below information has been deleted:</strong></legend></h2>
      <strong>User name:</strong><Label> <%=rs.getString(2)%> </Label>
        <br>
        <strong>First name:</strong><Label> <%=rs.getString(4)%> </Label>
        <br>
        <strong>Last name:</strong><Label> <%=rs.getString(5)%> </Label> <br>
        
      
        <strong>E-mail:</strong> <Label> <%=rs.getString(6)%> </Label>
        <br>
        <strong>Address:</strong> <Label> <%=rs.getString(7)%> </Label>
        <br>
        <strong>Phone:</strong> <Label> <%=rs.getString(8)%> </Label>
        <br>
         <strong>Role:</strong> <Label> <%=rs.getString(9)%> </Label>
   
        <br>
        <br>
   
    <h4 class="text-center"><a href="welcome.jsp"><input type="button" value="Back" name="Back"/></a></h4>  
  </fieldset>
  
<%
}
}
catch(Exception e){ 
	//response.sendRedirect("error.jsp"); 
	System.out.println(e);
	}
%>
<%
try{
	
           Connection con = DBConnector.getConnection();
           String query0="SET SQL_SAFE_UPDATES = ?";
           String query1="delete from account where user_id=?";
           String query2="delete from user_ques_mapping  where user_id=?";
           String query3="delete from users where user_id=?";
           
           DBConnector.update(query0, new Object[]{0}, new int[]{Types.INTEGER});
           
           DBConnector.update(query1, new Object[]{no}, new int[]{Types.INTEGER});
           
           DBConnector.update(query2, new Object[]{no}, new int[]{Types.INTEGER});
           
           DBConnector.update(query3, new Object[]{no}, new int[]{Types.INTEGER});
           
}
catch (Exception e){
	System.out.println(e);
	//System.out.println(e.getMessage());
	//response.sendRedirect("error.jsp");
	return;

}
%>
</table>
</form>
</div>
</body>
</html>