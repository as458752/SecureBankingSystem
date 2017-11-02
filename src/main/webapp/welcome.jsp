<%@ page import="java.sql.*" %>
<%@page import="com.group2.banking.service.*" %>
<%@page import="com.group2.banking.controller.*" %>
<%@ page import="org.springframework.jdbc.support.rowset.SqlRowSet" %>
<html>
<head>
<script>

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
	   }
	   catch(Exception e)
	   {
		   response.sendRedirect("error.jsp");
	   } 
	%>
}

</script>
</head>
<%
   try{
	int user_id = Integer.parseInt((String)SessionManagement.check(request,"user_id"));
        SqlRowSet rs = DBConnector.execute("select * from users where user_id=?", new Object[]{user_id}, new int[]{Types.INTEGER});rs.next();
        String name = rs.getString(4);
%>
<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
	<h2>Welcome <%=name%></h2>
<%
      }
      catch(Exception e)
      {
	   response.sendRedirect("error.jsp");
      } 
%>	
</body>
</html>