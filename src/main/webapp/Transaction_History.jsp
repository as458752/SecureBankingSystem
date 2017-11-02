<%@ page import="java.sql.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="org.springframework.jdbc.support.rowset.SqlRowSet" %>
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
                
                SqlRowSet temp = DBConnector.execute("select * from account where account_id=? and user_id=?", new Object[]{Integer.parseInt(request.getParameter("id")),SessionManagement.check(request,"user_id")}, new int[]{Types.INTEGER,Types.INTEGER});
                if(!temp.next()){
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
</script>
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<br><br>
<div class="container">
  
</div>
<h1><center>TRANSACTION HISTORY</center></h1>
<br>
<br>
<form method="post" name="form">
<table border="1">
<tr><th width="15">Transaction ID</th><th>Account from</th><th>Account To</th><th>Amount</th><th>Type</th><th>Status ID</th></tr>
<%
int sumcount=0;
try{
SqlRowSet rs = DBConnector.execute("select * from transactions where accountFrom=? or accountTo=?", new Object[]{Integer.parseInt(request.getParameter("id")),Integer.parseInt(request.getParameter("id"))}, new int[]{Types.INTEGER,Types.INTEGER});
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<%if(null!=rs.getString(2))
{%>
	<td><%=rs.getString(2)%></td>
<%}
else{%>
	<td><%="-"%></td>
<%} %>
<%if(null!=rs.getString(3))
{%>
	<td><%=rs.getString(3)%></td>
<%}
else{%>
	<td><%="-"%></td>
<%} %>
<td><%=rs.getString(4)%></td>
<%
String transaction_type = "";
if(rs.getString(6).equals("1"))
{
	transaction_type = "CREDIT";
}
else if(rs.getString(6).equals("2"))
{
	transaction_type = "DEBIT";
}
else if(rs.getString(6).equals("3"))
{
	transaction_type = "TRANSFER";
}
else if(rs.getString(6).equals("4"))
{
	transaction_type = "PAYMENT";
}
else if(rs.getString(6).equals("5"))
{
	transaction_type = "CREDIT CARD TRANSACTION";
}
%>
<td><%=transaction_type%></td>
<%
String transaction_status = "";
if(rs.getString(7).equals("1"))
{
	transaction_status = "Need To Specify Account";
}
else if(rs.getString(7).equals("2"))
{
	transaction_status = "Need Receiver Approval";
}
else if(rs.getString(7).equals("3"))
{
	transaction_status = "Need Internal User Approval";
}
else if(rs.getString(7).equals("4"))
{
	transaction_status = "DECLINED By Receiver";
}
else if(rs.getString(7).equals("5"))
{
	transaction_status = "DECLINED By Internal User";
}
else if(rs.getString(7).equals("6"))
{
	transaction_status = "Not Sufficient Funds";
}
else if(rs.getString(7).equals("7"))
{
	transaction_status = "Approved";
}
else if(rs.getString(7).equals("8"))
{
	transaction_status = "Avail Credit Payment";
}
else if(rs.getString(7).equals("9"))
{
	transaction_status = "Make Credit Payment";
}
%>
<td><%=transaction_status%></td>

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