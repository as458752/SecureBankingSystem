<%@page language="java"%>
<%@page import="java.sql.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.util.*" %>
<%@ page import="com.group2.banking.service.*" %>

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

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
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
		//ResultSet rs = DBConnector.getQueryResult("select * from users where user_id="+request.getParameter("id"));
                PreparedStatement st1 = DBConnector.getConnection().prepareStatement("select * from users where user_id=?");
                st1.setInt(1,Integer.parseInt(request.getParameter("id")));
                ResultSet rs = null;
                synchronized(MutexLock.getUsersTableMutex()){
                    rs = st1.executeQuery();
                }
		if(!rs.next()){
			response.sendRedirect("AuthError.jsp");
			return;			
		}
		
		if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && !SessionManagement.check(request,"user_id").equals(request.getParameter("id"))){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		if(SessionManagement.check(request,"user_role").equals("1")){
			String loggedin_userId = SessionManagement.check(request, "user_id");
			int auth = AuthUtil.isUserAuthorizedToEditandCreateUserAccounts(loggedin_userId,request.getParameter("id"));
			if(SessionManagement.check(request,request.getParameter("id")).equals("Authorized") || auth==1){
				SessionManagement.update(request,request.getParameter("id"),"Authorized");
			}
			else{
				String status = "Pending";
				if(auth==3){
					status = "Declined";
				}
				rs = DBConnector.getQueryResult("select * from users where user_id="+SessionManagement.check(request, "user_id"));
				String email = (String)DBConnector.getMatchedValuesFromResultSet(rs,"email").get(0);
				EmailOTPSender.getEmailOTPSender().sendMail("Status of approval", "The status of your request to view & modify this user's profile : "+status, email);
				response.sendRedirect("ApprovalStatus.jsp");
				return;
			}
		}
        }
        catch(Exception e)
        {
        	System.out.println(e);
        	response.sendRedirect("error.jsp");
        } 
	 
		int role_id = Integer.parseInt(SessionManagement.check(request,"user_role"));
	%>
}
<%if(!SessionManagement.check(request, "user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5")){%>
function deleteAccount(id){
	if(confirm("you want to delete the Account details?")) // this will pop up confirmation box and if yes is clicked it call servlet else return to page
	     {
		
			   var f=document.form;
			     f.method="post";
			    f.action='DeleteAccount.jsp?id='+id;
			    f.submit();
	     }else{
	       return false;
	    }

	
}
<%}%>
function CreateAccount(id,id2){

			   var f=document.form;
			     f.method="post";
			    f.action='addaccount.jsp?id='+id+'&id2='+id2;
			    f.submit();
	
}
</script>
        
        
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<br><br>
<div class="container">
  
</div>

<h1><center>List of Accounts</center></h1>
<br>
<br>
<form method="get" name="form" action="${contextPath}/TransactPage">
<table border="1">
<%if(!SessionManagement.check(request, "user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5")){ %>
<tr><th width="15">Account ID</th><th>Amount</th><th>Account Type</th><th>Credit Limit</th><th>New Limit</th><th>Change Limit</th><th>Delete</th>
<%}else{ %>
<tr><th width="15">Account ID</th><th>Amount</th><th>Account Type</th><th>Perform Transactions</th>
<%} %>
<%
String id=request.getParameter("id");
int no=Integer.parseInt(id);
try{
Connection con = null;
String url = "jdbc:mysql://localhost:3306/";
String db = "bank";
String driver = "com.mysql.jdbc.Driver";
String userName ="root";
String password="abhisana@1993";
PreparedStatement st;
Class.forName(driver).newInstance();
con = DriverManager.getConnection(url+db,userName,password);
String query = "select account.account_id,account.amount,account_type.account_desc from account inner join account_type where account.type_id = account_type.type_id and user_id=? and account_status=?";
st = con.prepareStatement(query);
st.setInt(1,no);
st.setInt(2,1);
ResultSet rs = null;
synchronized(MutexLock.getAccountsTableMutex()){
	rs = st.executeQuery();
}
Boolean isAccountPresent = false, isCreditAccountPresent = false;
%>
<%
while(rs.next()){
	if(!isAccountPresent && !rs.getString(3).equals("Credit")){
		isAccountPresent = true;
	}
	if(rs.getString(3).equals("Credit")){
		isCreditAccountPresent = true;
		if(SessionManagement.check(request, "user_role").equals("4") || SessionManagement.check(request, "user_role").equals("5")){
			continue;
		}
	}
%>
<tr><td><%=rs.getString(1)%></td>
<td><%=rs.getString(2)%></td>
<td><%=rs.getString(3)%></td>
<%if(rs.getString(3).equals("Credit")){
query = "select credit_limit from credit_card where account_id=?";
st = con.prepareStatement(query);
st.setInt(1, rs.getInt(1));
ResultSet rs1 = null;
synchronized(MutexLock.getAccountsTableMutex()){
	rs1 = st.executeQuery();
}
rs1.next();
%>
<td><%=rs1.getString(1)%></td>
<td> <input name="limit" type="text" class="form-control"/></td>
<td><button class="btn btn-lg btn-primary btn-block" type="submit" name="ids" value=<%=(id + "," + rs.getString(1))%> >Change Limit</button></td>
<%
}else{
if(!SessionManagement.check(request, "user_role").equals("4") && !SessionManagement.check(request, "user_role").equals("5")){
%>
<td></td>
<td></td>
<td></td>
<%}}%>
<%if(!SessionManagement.check(request, "user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5")){ %>
<td><input type="button" name="delete" value="Delete" style="background-color:green;font-weight:bold;color:white;" onclick="deleteAccount(<%=rs.getString(1)%>);" ></td>
<%}else{ %>
<td><input type="submit" name="Transact" class="btn btn-lg btn-primary btn-block" value="<%=rs.getString(1)%>"></td>
<% } %>
</tr>
<% } %>
</table>

<br>
<strong>Type of account you want to create:</strong><br>
  <select name="types">
  <option value="1">Savings</option>
  <option value="2">Checking</option>
  <%if(isAccountPresent && !isCreditAccountPresent){ %>
  <option value="3">Credit</option>
  <%} %>
</select>
<input type="button" name="Create" value="Create" style="background-color:Green;font-weight:bold;color:white;" onclick="CreateAccount(<%=request.getParameter("id")%>,document.form.types.value);" >





<%if(SessionManagement.check(request,"user_role").equals("1")){ %>
<h4 class="text-center"><a href="Welcome_Tier1.jsp"><input type="button" value="Back" name="Back"/></a></h4>
<%}else if(SessionManagement.check(request,"user_role").equals("2")){ %>
<h4 class="text-center"><a href="Welcome_Tier2.jsp"><input type="button" value="Back" name="Back"/></a></h4>
<%} else if(SessionManagement.check(request,"user_role").equals("3")){%>
<h4 class="text-center"><a href="Welcome_Admin.jsp"><input type="button" value="Back" name="Back"/></a></h4>
<%} else {%>
<h4 class="text-center"><a href="Welcome_External.jsp"><input type="button" value="Back" name="Back"/></a></h4>
<%} %>



<%
}
catch(Exception e){
	System.out.println(e);
	response.sendRedirect("error.jsp");
}
%>
</form>
</body>
</html>