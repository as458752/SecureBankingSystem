<%@page language="java"%>
<%@page import="java.sql.*"%>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

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
		
		//ResultSet rs = DBConnector.getQueryResult("select * from account where account_id="+request.getParameter("id"));
		PreparedStatement st = DBConnector.getConnection().prepareStatement("select * from account where account_id=?");
		st.setInt(1,Integer.parseInt(request.getParameter("id")));
		ResultSet rs = null;
		synchronized(MutexLock.getAccountsTableMutex()){
			rs = st.executeQuery();
		}
		
		String user_id = "";
		if(rs.next()){
			user_id = rs.getString(2);			
		}
		else{
			response.sendRedirect("AuthError.jsp");
			return;
		}

		if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5"))){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		if(SessionManagement.check(request,"user_role").equals("1") && !SessionManagement.check(request, user_id).equals("Authorized")){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		if(rs.getInt(4)!=3){
			ResultSet rs1 = DBConnector.getQueryResult("select * from account where user_id="+rs.getInt(2));
			int counter = 0;
			Boolean isCreditPresent = false;
			while(rs1.next()){
				counter++;
				if(rs1.getInt(3)==3){
					isCreditPresent = true;
				}
			}
			
			if(isCreditPresent && counter<=2){
				String message = "Credit Account has to be paid and deleted before deleting your only savings account savings account";
				response.sendRedirect("CannotDeleteAccount.jsp?message="+message);
				return;	
			}
		}
		else{
			int amount = rs.getInt(3);
			if(amount>0){
				String message = "Cannot delete Credit account as there are unpaid bills left";
				response.sendRedirect("CannotDeleteAccount.jsp?message="+message);
				return;
			}
		}
	   
        }
        catch(Exception e)
        {
        response.sendRedirect("error.jsp");
        } 
	 
		int role_id = Integer.parseInt(SessionManagement.check(request,"user_role"));
	%>
}
function GoBackToAccount(id){
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
<h1><center>Delete account confirmation</center></h1>
<br>
<br>
<form method="post" name="form">
<%
String id=request.getParameter("id");
int no=Integer.parseInt(id);
try{
Connection con = null;
PreparedStatement st;
con = DBConnector.getConnection();
String query = "select user_id,account_id,amount,b.account_desc from account a,account_type b where a.type_id=b.type_id and account_id=?";
st = con.prepareStatement(query);
st.setInt(1, no);
ResultSet rs = null;
synchronized(MutexLock.getAccountsTableMutex()){
	rs = st.executeQuery();
}
%>
<%
while(rs.next()){
%>
<Label>User ID:  </Label> <Label> <%=rs.getString(1)%> </Label> <br>
<Label>Account:  </Label> <Label> <%=rs.getString(2)%> </Label> <br>
<Label>Amount:  </Label> <Label> <%=rs.getString(3)%> </Label> <br>
<Label>Description:  </Label> <Label> <%=rs.getString(2)%> </Label> <br>
<br>
<input type="button" name="back" value="Back" style="background-color:green;font-weight:bold;color:white;" onclick="GoBackToAccount(<%=rs.getString(1)%>);" >

<%
}

%>
<%
}
catch(Exception e){
	response.sendRedirect("error.jsp");
}
%>
<%
try{
	int no1=Integer.parseInt(id);
           Connection con = DBConnector.getConnection();
           PreparedStatement st=con.prepareStatement("SET SQL_SAFE_UPDATES = 0");
           int i=st.executeUpdate();
           
           st = con.prepareStatement("delete from account where account_id=?");
           st.setInt(1, no1);
           synchronized(MutexLock.getAccountsTableMutex()){
           	int i1=st.executeUpdate();
           }
}
catch (Exception e){
	response.sendRedirect("error.jsp");
}
%>
</form>
</body>
</html>