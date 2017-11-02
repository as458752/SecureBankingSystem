<%@page import="org.springframework.jdbc.support.rowset.SqlRowSet"%>
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
		
		//Connection con = DBConnector.getConnection();
		//PreparedStatement st = con.prepareStatement("select * from account where account_id=? and type_id=3 and user_id=?");
		//st.setInt(1, Integer.parseInt(SessionManagement.check(request,"account_id")));
		//st.setInt(2, Integer.parseInt(SessionManagement.check(request,"user_id")));
		//ResultSet rs = null;
                SqlRowSet rs = DBConnector.execute("select * from account where account_id=? and type_id=3 and user_id=?", new Object[]{Integer.parseInt(SessionManagement.check(request,"account_id")), Integer.parseInt(SessionManagement.check(request,"user_id"))}, new int[]{Types.INTEGER, Types.INTEGER});
		if(!rs.next() && SessionManagement.check(request,"user_role").equals("4")){
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

</script>
</head>
<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<%
   try{
	   	int user_id = Integer.parseInt(SessionManagement.check(request,"user_id"));
	   	int role = Integer.parseInt(SessionManagement.check(request,"user_role"));
%>
	<%if(role==4){ 
		//ResultSet creditAcc = DBConnector.getQueryResult("select * from account where type_id=3 and account_status=1 and user_id="+user_id);
                SqlRowSet creditAcc = DBConnector.execute("select * from account where type_id=3 and account_status=1 and user_id=?", new Object[]{user_id}, new int[]{Types.INTEGER});
	   	if(!creditAcc.next()){
	   		response.sendRedirect("AuthError.jsp");
			return;
	   	}
	   	//ResultSet cardDet = DBConnector.getQueryResult("select * from credit_card where account_id="+creditAcc.getInt(1));
                SqlRowSet cardDet = DBConnector.execute("select * from credit_card where account_id=?", new Object[]{creditAcc.getInt(1)}, new int[]{Types.INTEGER});
	   	if(!cardDet.next()){
	   		response.sendRedirect("AuthError.jsp");
			return;
	   	}
                int creditLimit = cardDet.getInt(4);
	   	int amountLeft = creditLimit-creditAcc.getInt(3);
	%>
        <br>
        <form method="GET" action="${contextPath}/makeCreditCardPayment" style="width: 300px; margin: 0 auto;" class="form-signin">
        <div class="form-group ${error != null ? 'has-error' : ''}">
            <h4 class="form-heading text-center">SETTLE CREDIT CARD BALANCE</h4>
            <strong>Account No : <%=creditAcc.getInt(1)%></strong><br>
            <strong>Credit Limit : <%=creditLimit%></strong><br>
            <strong>Credit Left : <%=amountLeft%></strong><br><br><br>
            <strong>Choose Your Debit Account : </strong>
            <select name="AccountNo">
            	<%
			//ResultSet debitAcc = DBConnector.getQueryResult("select * from account where type_id<>3 and account_status<>3 and user_id="+user_id);
                        SqlRowSet debitAcc = DBConnector.execute("select * from account where type_id<>3 and account_status<>3 and user_id=?", new Object[]{user_id}, new int[]{Types.INTEGER});
            		Boolean temp = false;
            		while(debitAcc.next()){
            			temp = true;
				%>
				<option value="<%=debitAcc.getInt(1)%>"><%=debitAcc.getInt(1)%></option>
				<%} 
					if(!temp){
						response.sendRedirect("AuthError.jsp");
						return;
					}
				%>
            </select><br><br>
                    <span>${message}</span><br>
            <input name="amount" type="text" class="form-control" placeholder="Amount"
                   autofocus="true"/>
            <span>${error}</span>
            <table style="width: 300px">
            <tr>
                <td><button class="btn btn-lg btn-primary btn-block" type="submit" name="action" value="payCredit">Make Payment</button></td>
            </tr>
            </table>
        </div>
        </form>
        <br>
        <%}else if(role==5){ %>
        <br>
        <form method="GET" action="${contextPath}/availCreditCardPayment" style="width: 300px; margin: 0 auto;" class="form-signin">
        <span>${message1}</span>
        <div class="form-group ${error != null ? 'has-error' : ''}">
            <h4 class="form-heading text-center">AVAIL CREDIT CARD PAYMENT</h4>
            <strong>Choose Your Debit Account : </strong>
            <select name="AccountNo">
            	<%
			//ResultSet debitAcc = DBConnector.getQueryResult("select * from account where type_id<>3 and account_status<>3 and user_id="+user_id);
                        SqlRowSet debitAcc = DBConnector.execute("select * from account where type_id<>3 and account_status<>3 and user_id=?", new Object[]{user_id}, new int[]{Types.INTEGER});
            		Boolean temp = false;
            		while(debitAcc.next()){
            			temp = true;
				%>
				<option value="<%=debitAcc.getInt(1)%>"><%=debitAcc.getInt(1)%></option>
				<%} 
					if(!temp){
						response.sendRedirect("AuthError.jsp");
						return;
					}
				%>
            </select><br><br>
            <strong>Enter Credit Card Details : </strong><br>
            <input name="card_no" type="text" class="form-control" placeholder="Enter Credit Card No"/><br>
            <input name="cvv" type="text" class="form-control" placeholder="CVV"/><br>
            <input name="date" type="text" class="form-control" placeholder="Issue Date"/><br>
            <input name="amount" type="text" class="form-control" placeholder="Amount"/><br>
            <span>${error}</span>
            <button class="btn btn-lg btn-primary btn-block" type="submit" name="way" value="account">Avail Payment</button>

        </div>
        </form>
        <%}else{
        	response.sendRedirect("AuthError.jsp");
        	return;
		} %>
<%
      }
      catch(Exception e)
      {
	   response.sendRedirect("error.jsp");
      }
%>
</body>
</html>
