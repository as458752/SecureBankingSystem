<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
	    }
	    catch(Exception e)
	    {
		   response.sendRedirect("error.jsp");
	    } 
	%>
}
<%if(SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5") || SessionManagement.check(request,"user_role").equals("2")){%>
function ApproveViewAndEdit(id,id1){
    var f=document.form;
    f.method="post";
    f.action='Approve.jsp?id='+id+"&id1="+id1+"&type=viewAndEdit";
    f.submit();
}

function DeclineViewAndEdit(id,id1) {
    var f=document.form;
    f.method="post";
    f.action='Decline.jsp?id='+id+"&id1="+id1+"&type=viewAndEdit";
    f.submit();
}
<%}%>
<%if(SessionManagement.check(request,"user_role").equals("3") || SessionManagement.check(request,"user_role").equals("2")){%>
function ApproveAccount(id){
    var f=document.form;
    f.method="post";
    f.action='Approve.jsp?id='+id+"&type=ApproveAccount";
    f.submit();
}

function DeclineAccount(id) {
    var f=document.form;
    f.method="post";
    f.action='Decline.jsp?id='+id+"&type=ApproveAccount";
    f.submit();
}
<%}%>

function ApproveTransaction(id){
	var f=document.form;
	f.method="post";
	if(document.form.contains(document.form.Accounts)){
		f.action='ApproveTransaction.jsp?id='+id+"&id1="+document.form.Accounts.value;	
	}
	else{
		f.action='ApproveTransaction.jsp?id='+id;
	}
	
	f.submit();
}
function DeclineTransaction(id){
	var f=document.form;
	f.method="post";
	if(document.form.contains(document.form.Accounts)){
		f.action='DeclineTransaction.jsp?id='+id+"&id1="+document.form.Accounts.value;	
	}
	else{
		f.action='DeclineTransaction.jsp?id='+id;
	}
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
<br>
<br>
<form method="post" name="form">
<%if(SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")){ %>
<h1><center>PROFILE VIEW APPROVALS</center></h1>
<table border="1">
<tr><th width="15">Profile to View</th><th>Request Created By</th><th>Approve</th><th>Decline</th></tr>
<%
try{
ResultSet rs = DBConnector.getQueryResult("select * from edituseraccountapprovals where owner_id="+SessionManagement.check(request,"user_id")+" and approval_stage=1 and approval_status=2");
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(2)%></td>
<td><input type="button" name="Approve" value="Approve" style="background-color:green;font-weight:bold;color:white;" onclick="ApproveViewAndEdit(<%=rs.getString(2)%>,<%=rs.getString(1)%>);" ></td>
<td><input type="button" name="Decline" value="Decline" style="background-color:blue;font-weight:bold;color:white;" onclick="DeclineViewAndEdit(<%=rs.getString(2)%>,<%=rs.getString(1)%>);" ></td>
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

<%} else if(SessionManagement.check(request,"user_role").equals("2")){ %>
<h1><center>PROFILE VIEW APPROVALS</center></h1>
<table border="1">
<tr><th width="15">Profile to View</th><th>Request Created By</th><th>Approve</th><th>Decline</th></tr>
<%
try{
ResultSet rs = DBConnector.getQueryResult("select * from edituseraccountapprovals where approval_stage=2 and approval_status=2");
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(2)%></td>
<td><input type="button" name="Approve" value="Approve" style="background-color:green;font-weight:bold;color:white;" onclick="ApproveViewAndEdit(<%=rs.getString(2)%>,<%=rs.getString(1)%>);" ></td>
<td><input type="button" name="Decline" value="Decline" style="background-color:blue;font-weight:bold;color:white;" onclick="DeclineViewAndEdit(<%=rs.getString(2)%>,<%=rs.getString(1)%>);" ></td>
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
<%}%>
<%if(SessionManagement.check(request,"user_role").equals("2") || SessionManagement.check(request,"user_role").equals("3")){%>
<h1><center>ACCOUNT CREATION APPROVALS</center></h1>
<table border="1">
<tr><th width="15">User ID</th><th>Type</th><th>Approve</th><th>Decline</th></tr>
<%
try{
ResultSet rs = DBConnector.getQueryResult("select * from account where account_status=2");
%>
<%
while(rs.next()){
%>
<tr><td><%=rs.getString(2)%></td>
<td><%=rs.getString(4)%></td>
<td><input type="button" name="Approve" value="Approve" style="background-color:green;font-weight:bold;color:white;" onclick="ApproveAccount(<%=rs.getString(1)%>);" ></td>
<td><input type="button" name="Decline" value="Decline" style="background-color:blue;font-weight:bold;color:white;" onclick="DeclineAccount(<%=rs.getString(1)%>);" ></td>
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
<%} %>
</table>
<h1><center>PENDING TRANSACTIONS</center></h1>
<table border="1">
<tr><th width="15">Transaction ID</th><th>Type</th><th>From</th><th>To</th><th>Amount</th><th>Select Account</th><th>Approve</th><th>Decline</th></tr>
<%
try{
ResultSet rs = DBConnector.getQueryResult("select * from transactions");
%>
<%
while(rs.next()){
if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && rs.getInt(7)!=1 && rs.getInt(7)!=2){
	continue;
}
if((SessionManagement.check(request,"user_role").equals("1") || SessionManagement.check(request,"user_role").equals("2") || SessionManagement.check(request,"user_role").equals("3")) && rs.getInt(7)!=3 && rs.getInt(7)!=8 && rs.getInt(7)!=9){
	continue;
}
ResultSet rs2 = DBConnector.getQueryResult("select * from account where account_id="+rs.getString(3));
rs2.next();
if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && rs.getString(3)!=null && !rs.getString(3).equals("null") && !rs.getString(3).equals("") && !rs.getString(3).equals("NULL") && rs.getInt(7)==2 && rs2.getInt(2)!=Integer.parseInt(SessionManagement.check(request,"user_id"))){
	continue;
}
if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && rs.getInt(7)==1 && rs.getInt(5)!=Integer.parseInt(SessionManagement.check(request,"user_id"))){
	continue;
}
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(6)%></td>
<%if(rs.getString(2)==null || rs.getString(2).equals("") || rs.getString(2).equals("null") || rs.getString(2).equals("NULL")){ %>
<td><%=rs.getString(3)%></td>
<%}else{ %>
<td><%=rs.getString(2)%></td>
<%} %>
<%if(rs.getString(3)==null || rs.getString(3).equals("") || rs.getString(3).equals("null") || rs.getString(3).equals("NULL")){ %>
<td><strong>MYSELF</strong></td>
<%}else{ %>
<td><%=rs.getString(3)%></td>
<%} %>
<td><%=rs.getString(4) %></td>
<td>
<%
	if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && rs.getInt(7)==1){
		ResultSet rs1 = DBConnector.getQueryResult("select * from account where account_status=1 and type_id<>3 and user_id="+SessionManagement.check(request,"user_id"));
		List<Object> accounts = DBConnector.getMatchedValuesFromResultSet(rs1, "account_id");
		if(accounts.size()>0){
			%><select name="Accounts"><%
			for(int i=0;i<accounts.size();i++){%>
				<option value="<%=accounts.get(i)%>"><%=accounts.get(i)%></option>
			<%}%></select><%}}%>
</td>
<td><input type="button" name="Approve" value="Approve" style="background-color:green;font-weight:bold;color:white;" onclick="ApproveTransaction(<%=rs.getString(1)%>);" ></td>
<td><input type="button" name="Decline" value="Decline" style="background-color:blue;font-weight:bold;color:white;" onclick="DeclineTransaction(<%=rs.getString(1)%>);" ></td>
</tr>
<%
}
%>
<%
}
catch(Exception e){
	System.out.println(e);
response.sendRedirect("error.jsp");
}
%>
</table>
</form>
</body>
</html>