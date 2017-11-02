<%@ page import="java.sql.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<%@ page import="org.springframework.jdbc.support.rowset.SqlRowSet" %>
<html>
<head>
<script language="javascript">
function validateSession(){
	<%
	response.setHeader( "Pragma", "no-cache" );
	   response.setHeader( "Cache-Control", "no-cache" );
	   response.setDateHeader( "Expires", 0 );
	try{
		if(SessionManagement.check(request,"user_id")==null || SessionManagement.check(request,"user_id").equals("") || SessionManagement.check(request,"user_id").equals("null")){
			response.sendRedirect("login.jsp");
			return;
		}
		if(!SessionManagement.check(request,"user_role").equals("2")){
			response.sendRedirect("AuthError.jsp");
		}
	   }
	   catch(Exception e)
	   {
		   response.sendRedirect("error.jsp");
	   } 
	%>
}

function editRecord(id){
    var f=document.form;
    f.method="post";
    f.action='Edituser.jsp?id='+id;
    f.submit();
}
function AccountDetails(id) {
    var f=document.form;
    f.method="post";
    f.action='Account.jsp?id='+id;
    f.submit();
}
</script>
  <title>GoSwiss</title>
  <link rel="stylesheet" type="text/css" href="IUP-1.css">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<br><br>
<div class="container">
  
</div>
<h1><center>MY DETAILS</center></h1>
<br>
<br>
<form method="post" name="form">
<table border="1">
<tr><th width="15">User ID</th><th>User Name</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Address</th><th>Phone</th><th>Role</th><th>Edit</th></tr>
<%
try{
    
SqlRowSet rs = DBConnector.execute("select * from users where user_status=1 and user_id=?", new Object[]{Integer.parseInt(SessionManagement.check(request, "user_id"))}, new int[]{Types.INTEGER});

%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(2)%></td>
<td><%=rs.getString(4)%></td>
<td><%=rs.getString(5)%></td>
<td><%=rs.getString(6)%></td>
<td><%=rs.getString(7)%></td>
<td><%=rs.getString(8)%></td>
<td><%=rs.getString(9)%></td>
<td><input type="button" name="edit" value="Edit" style="background-color:green;font-weight:bold;color:white;" onclick="editRecord(<%=rs.getString(1)%>);" ></td>
</tr>
<%
}
%>
<%
}
catch(Exception e){
	response.sendRedirect("error.jsp");
}
%>
</table><br><br>
<h1><center>LIST OF EXTERNAL USERS</center></h1>
<br>
<br>
<form method="post" name="form">
<table border="1">
<tr><th width="15">User ID</th><th>First Name</th><th>Lastname</th><th>Address</th><th>Phone</th><th>Edit</th><th>Account</th></tr>
<%
int sumcount=0;
try{
SqlRowSet rs = DBConnector.execute("select * from users where user_status=1 and Role_id=4 OR Role_id=?", new Object[]{5}, new int[]{Types.INTEGER});
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(4)%></td>
<td><%=rs.getString(5)%></td>
<td><%=rs.getString(7)%></td>
<td><%=rs.getString(8)%></td>
<td><input type="button" name="edit" value="Edit" style="background-color:green;font-weight:bold;color:white;" onclick="editRecord(<%=rs.getString(1)%>);" ></td>
<td><input type="button" name="account" value="account" style="background-color:blue;font-weight:bold;color:white;" onclick="AccountDetails(<%=rs.getString(1)%>);" ></td>
</tr>
<%
}
%>
<%
}
catch(Exception e){
response.sendRedirect("error.jsp");
}
%>
</table>
<br>
<br>
<h1><center>LIST OF INTERNAL USERS</center></h1>
<table border="1">
<tr><th width="15">User ID</th><th>First Name</th><th>Last Name</th><th>Address</th><th>Phone</th><th>Edit</th></tr>
<%
try{
SqlRowSet rs = DBConnector.execute("select * from users where user_status=1 and Role_id=?", new Object[]{1}, new int[]{Types.INTEGER});
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(4)%></td>
<td><%=rs.getString(5)%></td>
<td><%=rs.getString(7)%></td>
<td><%=rs.getString(8)%></td>
<td><input type="button" name="edit" value="Edit" style="background-color:green;font-weight:bold;color:white;" onclick="editRecord(<%=rs.getString(1)%>);" ></td>
</tr>
<%
}
%>
<%
}
catch(Exception e){
response.sendRedirect("error.jsp");
}
%>
</table>
</form>
</body>
</html>