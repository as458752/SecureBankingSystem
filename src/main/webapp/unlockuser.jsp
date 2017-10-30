<%@page language="java"%>
<%@page import="java.sql.*"%>
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
		if(!SessionManagement.check(request,"user_role").equals("3")){
			response.sendRedirect("AuthError.jsp");
		}
	    }
	    catch(Exception e)
	    {
		   // response.sendRedirect("error.jsp");
	    } 
	%>
}
</script>
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<h1><center>Unlock Confirmation!</center></h1>

<br><br>

<div class="userform">
<form method="POST" action="${contextPath}/edituser" class="form-signin">

<%
String id=request.getParameter("id");
int no=Integer.parseInt(id);
try {
Class.forName("com.mysql.jdbc.Driver").newInstance();
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank", "root", "abhisana@1993");
ResultSet rs = null;
synchronized(MutexLock.getUsersTableMutex())
{
        PreparedStatement pStatement = conn.prepareStatement("select * from users where user_id=?");
        pStatement.setInt(1, no);
        rs = pStatement.executeQuery();
}
while(rs.next()){
%>
<fieldset>
    <span>${message}</span>
  <span>${message1}</span>
    <h2><legend><strong>User with below information has been unlocked:</strong></legend></h2>
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
   
    <h4 class="text-center"><a href="lockeduser.jsp"><input type="button" value="Back" name="Back"/></a></h4>  
  </fieldset>
  
<%
}
}
catch(Exception e){ 
    String s = e.getMessage();
    response.sendRedirect("error.jsp"); }
%>
<%
try{
	
           Class.forName("com.mysql.jdbc.Driver");
           Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bank", "root", "abhisana@1993");
           Statement st=con.createStatement();
           int i=st.executeUpdate("SET SQL_SAFE_UPDATES = 0");
           String query1 = "UPDATE users SET user_status=1 where user_id=?";
           String query2 = "UPDATE users SET NO_OF_ATTEMPTS=0 where user_id=?";
           int i2;
           int i3;
           synchronized(MutexLock.getUsersTableMutex())
           {
	           PreparedStatement pStatement = con.prepareStatement(query1);
	           pStatement.setInt(1, no);
	           i2 = pStatement.executeUpdate();
	           pStatement = con.prepareStatement(query2);
	           pStatement.setInt(1, no);
	           i3 = pStatement.executeUpdate();
           }
}
catch (Exception e){
	//System.out.print(e.printStackTrace());
	//response.sendRedirect("error.jsp");

}
%>
</table>
</form>
</div>
</body>
</html>