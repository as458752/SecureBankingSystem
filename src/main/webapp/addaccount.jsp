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
		
		String id2 = request.getParameter("id2");
		if(id2==null || id2.equals("") || id2.equals("null") || id2.equals("NULL")){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		PreparedStatement st = DBConnector.getConnection().prepareStatement("select * from users where user_id=?");
		st.setString(1,request.getParameter("id"));
		ResultSet rs = st.executeQuery();
		if(!rs.next()){
			response.sendRedirect("AuthError.jsp");
			return;			
		}
		
		if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && !SessionManagement.check(request,"user_id").equals(request.getParameter("id"))){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		if(SessionManagement.check(request,"user_role").equals("1") && !SessionManagement.check(request, request.getParameter("id")).equals("Authorized")){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		st = DBConnector.getConnection().prepareStatement("select * from account where type_id=3 and account_status<>3 and user_id=?");
		st.setInt(1,Integer.parseInt(request.getParameter("id")));
		synchronized(MutexLock.getAccountsTableMutex()){
			rs = st.executeQuery();
		}
		
		if(rs.next() && id2.equals("3")){
			response.sendRedirect("AuthError.jsp");
			return;
		}
	    }
	    catch(Exception e)
	    {
	    	System.out.println(e);
		   response.sendRedirect("error.jsp");
	    } 
	%>
}
</script>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>GoSwiss</title>

    <link href="/bank/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="/bank/resources/css/common.css" rel="stylesheet">
    
    <script type="text/javascript">
         

        </script>
        
        
</head>

<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
  
<div class="container">
</div>

<h1><center>Account details</center></h1>

<br><br>

<div class="userform">
<form method="POST" name="myform" class="form-signin">

<%
String id=request.getParameter("id");
int no=Integer.parseInt(id);
String id2=request.getParameter("id2");
int no1=Integer.parseInt(id2);
try {
Connection conn = DBConnector.getConnection();

     int status = 2; 
	 if(SessionManagement.check(request, "user_role").equals("3") || SessionManagement.check(request, "user_role").equals("2")){
    	  status = 1;
      }
      else{
			status = 2;
      }
      String query = " insert into account (user_id,amount,type_id,account_status)"
    	        + " values (?,?,?,?)";
      PreparedStatement preparedStmt = conn.prepareStatement(query);
      preparedStmt.setInt(1, no);
      preparedStmt.setInt(2, 0);
      preparedStmt.setInt(3, Integer.parseInt(id2));
      preparedStmt.setInt(4, status);
      synchronized(MutexLock.getAccountsTableMutex()){
      	preparedStmt.execute();
      }
%>
<%
}
catch(Exception e){
	response.sendRedirect("error.jsp");
}
%>

<%
String id_display=request.getParameter("id");
int no_display=Integer.parseInt(id);
try {
Connection conn = DBConnector.getConnection();


String query =  "select * from account where user_id=? ORDER BY account_id DESC LIMIT 1";
PreparedStatement st = conn.prepareStatement(query);
st.setInt(1, no_display);
ResultSet rs = null;
synchronized(MutexLock.getAccountsTableMutex()){
	rs = st.executeQuery();
}

while(rs.next()){
	if(!SessionManagement.check(request, "user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5")){
		ResultSet rs1 = DBConnector.getQueryResult("select * from users where user_id="+rs.getInt(2));rs1.next();
		EmailOTPSender.getEmailOTPSender().sendMail("GoSwiss Account Approval - ID : ##"+id, "Your account has been approved for creation.", rs1.getString(6));
		
		if(rs.getInt(4)==3){
			query = "insert into credit_card (cvv,exp_date,credit_limit,account_id) values(?,?,?,?)";
    		st = DBConnector.getConnection().prepareStatement(query);
    		st.setInt(1, Integer.parseInt(EmailOTPSender.getEmailOTPSender().generateOTP()));
    		st.setLong(2, System.currentTimeMillis());
    		st.setInt(3,1500);
    		st.setInt(4,rs.getInt(1));
    		synchronized(MutexLock.getCreditCardTableMutex()){
    			st.executeUpdate();
    		}
    	
    		ResultSet rs2 = DBConnector.getQueryResult("select * from credit_card where account_id="+rs.getInt(1));rs2.next();
    		EmailOTPSender.getEmailOTPSender().sendMail("GoSwiss - Credit Card Details ; Account ID : "+id, "Card No : "+rs2.getInt(1)+"\nCVV : "+rs2.getInt(2)+"\nIssue Date : "+rs2.getLong(3), rs1.getString(6));
		}
	}
%>
<fieldset>
	<%if(!SessionManagement.check(request, "user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5")){ %>
    <h2><legend><strong>Below are the details of the account:</strong></legend></h2>
      <strong>Account number:</strong><Label> <%=rs.getString(1)%> </Label>
        <br>
        <%if(rs.getInt(4)!=3){ %>
        <strong>Balance:</strong><Label> 0 </Label>
        <%} else{%>
        <strong>Credit Limit:</strong><Label> 1500 </Label><br><br>
        <%} %>
        <br>
    <%}else { %>
    	<strong>Your account request is being processed. Our staff will contact you to verify your details. Once verified your account will be approved and you will receive a mail intimating the same</strong>
    	<%if(rs.getInt(4)==3){ %>
    	<strong>Your credit card will be sent to you by post</strong>
    	<%} %>
    <%} %>
  
<%
}%>
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
	e.printStackTrace();
	response.sendRedirect("error.jsp");
	
}
%>
</table>
</form>
</div>

</body>
</html>