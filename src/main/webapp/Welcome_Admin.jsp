<%@ page import="java.sql.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<html>
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
	    response.sendRedirect("error.jsp");
        } 
	%>
}
function editRecord(id){
    var f=document.form;
    f.method="post";
    f.action='EditUser_Admin_External.jsp?id='+id;
    f.submit();
}
function deleteRecord(id){
	if(confirm("Do you want to delete the user?")) // this will pop up confirmation box and if yes is clicked it call servlet else return to page
	     {
		
			   var f=document.form;
			     f.method="post";
			    f.action='DeleteUser.jsp?id='+id;
			    f.submit();
	     }else{
	       return false;
	    }

	
}
function AccountDetails(id) {
    var f=document.form;
    f.method="post";
    f.action='Account.jsp?id='+id;
    f.submit();
}
</script>
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<br><br>
<div class="container">
  
</div>
<h4 class="text-center"><a href="adduser_Admin.jsp"><input type="button" value="AddUser" name="AddUser"/></a></h4>
<h4 class="text-center"><a href="lockeduser.jsp">List of Locked Users</a></h4>
<strong>${message}</strong>
<h1><center>MY DETAILS</center></h1>
<br>
<br>
<form method="post" name="form">
<table border="1">
<tr><th width="15">User ID</th><th>User Name</th><th>First Name</th><th>Lastname</th><th>Email</th><th>Address</th><th>Phone</th><th>Role</th><th>Edit</th></tr>
<%
Connection con = null;
String url = "jdbc:mysql://localhost:3306/";
String db = "bank";
String driver = "com.mysql.jdbc.Driver";
String userName ="root";

int sumcount=0;
Statement st;
try{
con = DBConnector.getConnection();
String query = "select * from users where user_status=1 and user_id="+SessionManagement.check(request, "user_id");; 
st = con.createStatement();



ResultSet rs=null;
synchronized(MutexLock.getUsersTableMutex())
{
rs = st.executeQuery(query);
}

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
<h1><center>LIST OF EXTERNAL USERS</center></h1><br><br>
<table border="1">
<tr><th width="15">User ID</th><th>User Name</th><th>First Name</th><th>Lastname</th><th>Email</th><th>Address</th><th>Phone</th><th>Role</th><th>Edit</th><th>Delete</th><th>Account</th></tr>
<%
try{
con = DBConnector.getConnection();
String query = "select * from users where user_status=1 and role_id in (4,5)";
st = con.createStatement();
ResultSet rs = st.executeQuery(query);
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
<td><input type="button" name="delete" value="Delete" style="background-color:red;font-weight:bold;color:white;" onclick="deleteRecord(<%=rs.getString(1)%>);" ></td>
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
</table><br><br>
<h1><center>LIST OF INTERNAL USERS</center></h1><br><br>
<table border="1">
<tr><th width="15">User ID</th><th>User Name</th><th>First Name</th><th>Lastname</th><th>Email</th><th>Address</th><th>Phone</th><th>Role</th><th>Edit</th><th>Delete</th></tr>
<%
try{
con = DBConnector.getConnection();
String query = "select * from users where user_status=1 and role_id in (1,2,3) and user_id not in ("+SessionManagement.check(request, "user_id")+")";
st = con.createStatement();
ResultSet rs = st.executeQuery(query);
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
<td><input type="button" name="delete" value="Delete" style="background-color:red;font-weight:bold;color:white;" onclick="deleteRecord(<%=rs.getString(1)%>);" ></td>
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
</form>
</body>
</html>