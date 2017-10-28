<%@ page import="java.sql.*" %>
<%@page import="com.group2.banking.service.*" %>
<%@page import="com.group2.banking.controller.*" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
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
		
		if(SessionManagement.check(request,"account_id")==null || SessionManagement.check(request,"account_id").equals("") || SessionManagement.check(request,"account_id").equals("null")){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		Connection con = DBConnector.getConnection();
		PreparedStatement st = con.prepareStatement("select * from account where account_id=? and user_id=?");
		st.setInt(1, Integer.parseInt(SessionManagement.check(request,"account_id")));
		st.setInt(2, Integer.parseInt(SessionManagement.check(request,"user_id")));
		ResultSet rs = null;
		synchronized(MutexLock.getAccountsTableMutex()){
			rs = st.executeQuery();
		}
		if(!rs.next()){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		if(rs.getInt(4)==3){
			response.sendRedirect("AuthError.jsp");
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
function goback(){
	var form = document.gobackform;
	form.action = "Account.jsp?id="+<%=SessionManagement.check(request,"user_id")%>
	form.method = "post";
	form.submit();
}

</script>
</head>
<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<%
   try{
	int user_id = Integer.parseInt((String)SessionManagement.check(request,"user_id"));
	ResultSet rs = DBConnector.getQueryResult("select * from users where user_id="+user_id);
	String name = (String)DBConnector.getMatchedValuesFromResultSet(rs, "firstname").get(0);
        int account_id = Integer.parseInt((String)SessionManagement.check(request,"account_id"));
        rs = DBConnector.getQueryResult("select account_type.account_desc, account.amount from account_type inner join account on account_type.type_id=account.type_id where account.account_id="+account_id);
        rs.next();
        String type = (String) rs.getObject("account_desc");
        Integer balance = (Integer) rs.getObject("amount");
%>
	<h2 class="text-center">Welcome <%=name%></h2>
        <h4 class="text-center"><%=type%> Account</h4>
        <h4 class="text-center">Account ID: <%=account_id%></h4>
        <h4 class="text-center">Total Balance: <%=balance%></h4>
        <br>
        <form method="GET" action="${contextPath}/debitCredit" style="width: 300px; margin: 0 auto;" class="form-signin">
        <span>${message}</span>
        <div class="form-group ${error != null ? 'has-error' : ''}">
            <h4 class="form-heading text-center">Debit or Credit Funds</h4>
            <input name="amount" type="text" class="form-control" placeholder="Amount"
                   autofocus="true"/>
            <span>${error}</span>
            <table style="width: 300px">
            <tr>
                <td><button class="btn btn-lg btn-primary btn-block" type="submit" name="action" value="debit">Debit</button></td>
                <td><button class="btn btn-lg btn-primary btn-block" type="submit" name="action" value="credit">Credit</button></td>
            </tr>
            </table>
        </div>
        </form>
        <br>
        <br>
        <form method="GET" action="${contextPath}/transfer" style="width: 300px; margin: 0 auto;" class="form-signin">
        <span>${message1}</span>
        <div class="form-group ${error != null ? 'has-error' : ''}">
            <h4 class="form-heading text-center">Transfer Funds</h4>
            <input name="receiver" type="text" class="form-control" placeholder="account number or email address"/>
            <input name="amount" type="text" class="form-control" placeholder="Amount"/>
            <span>${error}</span>
            <button class="btn btn-lg btn-primary btn-block" type="submit" name="way" value="account">Send by Account Number</button>
            <button class="btn btn-lg btn-primary btn-block" type="submit" name="way" value="email">Send by Email</button>

        </div>
        </form>
        <form name="gobackform"><h4 class="text-center"><input type="button" value="Back" name="Back" onclick="goback()"/></h4></form>
<%
      }
      catch(Exception e)
      {
	   response.sendRedirect("error.jsp");
      }
%>
</body>
</html>
