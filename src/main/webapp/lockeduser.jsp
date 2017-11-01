<%@ page import="java.sql.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
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

function temp(id) {
	//alert("hello");
    var f=document.myform;
    f.method="post";
    f.action='unlockuser.jsp?id='+id;
    f.submit();
}


</script>
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<br><br>
<div class="container">
  
</div>
<h1><center>LIST OF USERS</center></h1>
<br>
<br>
<form method="POST" name="myform" action="${contextPath}/unlockuser" class="form-signin">
 <span>${message}</span>
<table border="1">
<tr><th width="15">User ID</th><th>User Name</th><th>Password</th><th>First Name</th><th>Lastname</th><th>Email</th><th>Address</th><th>Phone</th><th>Role</th><th>Unlock</th></tr>
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
String query = "";
synchronized(MutexLock.getUsersTableMutex())
{
	query = "select * from users where user_status="+4;
}
st = con.createStatement();
ResultSet rs = st.executeQuery(query);
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(2)%></td>
<td>*******</td>
<td><%=rs.getString(4)%></td>
<td><%=rs.getString(5)%></td>
<td><%=rs.getString(6)%></td>
<td><%=rs.getString(7)%></td>
<td><%=rs.getString(8)%></td>
<td><%=rs.getString(9)%></td>
<td><input type="button" name="unlock" value="unlock" style="background-color:red;font-weight:bold;color:white;" onclick="temp(<%=rs.getString(1)%>);" ></td>
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