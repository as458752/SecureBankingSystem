<%@ page import="java.sql.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<%@ page import="com.group2.banking.controller.*" %>
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
		if(!SessionManagement.check(request,"user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5")){
			response.sendRedirect("AuthError.jsp");
			return;
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
<h1><center>MY DETAILS</center></h1>
<br>
<br>
<form method="post" name="form">
<table border="1">
<tr><th width="15">User ID</th><th>User Name</th><th>First Name</th><th>Lastname</th><th>Email</th><th>Address</th><th>Phone</th><th>Role</th><th>Edit</th><th>Account</th></tr>
<%
Connection con = null;
String url = "jdbc:mysql://localhost:3306/";
String db = "bank";
String driver = "com.mysql.jdbc.Driver";
String userName ="root";
String password="abhisana@1993";

int sumcount=0;
Statement st;
try{
Class.forName(driver).newInstance();
con = DriverManager.getConnection(url+db,userName,password);
String query = "select * from users where user_status="+1+" and user_id="+SessionManagement.check(request, "user_id");
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
</form>
</body>
</html>