<%@page import="org.springframework.jdbc.support.rowset.SqlRowSet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        <%@ page import="java.sql.*" %>
<%@ page import="com.group2.banking.controller.*" %>
<%@ page import="com.group2.banking.service.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GoSwiss</title>
<script>
	function validateSession(){
		<%
		response.setHeader( "Pragma", "no-cache" );
		   response.setHeader( "Cache-Control", "no-cache" );
		   response.setDateHeader( "Expires", 0 );
		String message = "temp";
		try{
		if(SessionManagement.check(request,"user_id")==null || SessionManagement.check(request,"user_id").equals("") || SessionManagement.check(request,"user_id").equals("null")){
			response.sendRedirect("login.jsp");
			return;
		}
		
		int user_id = Integer.parseInt(SessionManagement.check(request,"user_id"));
		int role = Integer.parseInt(SessionManagement.check(request,"user_role"));
                
                if(role==1){
                    response.sendRedirect("AuthError.jsp");
                    return;
                }
		
		String id = request.getParameter("id");
		String id1 = request.getParameter("id1");
		//Connection conn = DBConnector.getConnection();
		//PreparedStatement st = conn.prepareStatement("select * from transactions where transaction_id=?");
		//st.setInt(1,Integer.parseInt(id));
		//ResultSet rs = st.executeQuery();
                SqlRowSet rs = DBConnector.execute("select * from transactions where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
		if(!rs.next()){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		String accountFrom = rs.getString(2);
		String accountTo = rs.getString(3);
		int amount = rs.getInt(4);
		String receiver_id = rs.getString(5);
		int type_id = rs.getInt(6);
		int status_id = rs.getInt(7);
		
		if(status_id!=1 && status_id!=2 && status_id!=3 && status_id!=8 && status_id!=9){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		
		if((role==3 || role==2 || role==1) && status_id!=3 && status_id!=8 && status_id!=9){
			response.sendRedirect("AuthError.jsp");
			return;
		}
                //SqlRowSet rs_temp = DBConnector.execute("select * from account where account_id=?", new Object[]{Integer.parseInt(accountFrom)}, new int[]{Types.INTEGER});
                if(accountFrom!=null && !accountFrom.equals("null") && !accountFrom.equals("NULL") && !accountFrom.equals("") && !DBConnector.execute("select * from account where account_id=?", new Object[]{Integer.parseInt(accountFrom)}, new int[]{Types.INTEGER}).next()){
                    response.sendRedirect("AuthError.jsp");
                    return;
                }
                //SqlRowSet rs_temp1 = DBConnector.execute("select * from account where account_id=?", new Object[]{Integer.parseInt(accountTo)}, new int[]{Types.INTEGER});
                if(accountTo!=null && !accountTo.equals("") && !accountTo.equals("null") && !accountTo.equals("NULL") && !DBConnector.execute("select * from account where account_id=?", new Object[]{Integer.parseInt(accountTo)}, new int[]{Types.INTEGER}).next()){
                    response.sendRedirect("AuthError.jsp");
                    return;
                }
		
		if(role==4 || role==5){
			if(status_id==1 && (id1==null || id1.equals("") || id1.equals("null") || id1.equals("NULL"))){
				response.sendRedirect("AuthError.jsp");
				return;	
			}
			else if(status_id!=1 && status_id!=2){
				response.sendRedirect("AuthError.jsp");
				return;	
			}
		}
		
		if(role==1 || role==2 || role==3){
			if(id1!=null && !id1.equals("") && !id1.equals("null") && !id1.equals("NULL")){
				response.sendRedirect("AuthError.jsp");
				return;
			}
			if(type_id==2){
				int acc = Integer.parseInt(accountTo);
                                SqlRowSet accdetails = DBConnector.execute("select * from account where account_id=?", new Object[]{acc}, new int[]{Types.INTEGER});accdetails.next();
				//ResultSet accdetails = DBConnector.getQueryResult("select * from account where account_id="+acc);accdetails.next();
                                SqlRowSet user_for_acc = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetails.getInt(2)}, new int[]{Types.INTEGER});user_for_acc.next();
				//ResultSet user_for_acc = DBConnector.getQueryResult("select * from users where user_id="+accdetails.getInt(2));user_for_acc.next();
				int amount_left = accdetails.getInt(3);
				if(amount_left-amount<0){
					message = "Insuffecient funds";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=6 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=6 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your transaction has been declined due to insuffecient funds.", user_for_acc.getString(6));
				}
				else{
					message = "Transaction approved";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left-amount)+" where account_id="+acc);
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left-amount), acc}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type1.executeUpdate();
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been debited with amount : $"+amount, user_for_acc.getString(6));
				}
			}
			else if(type_id==1){
				int acc = Integer.parseInt(accountTo);
				//ResultSet accdetails = DBConnector.getQueryResult("select * from account where account_id="+acc);accdetails.next();
                                SqlRowSet accdetails = DBConnector.execute("select * from account where account_id=?", new Object[]{acc}, new int[]{Types.INTEGER});accdetails.next();
				//ResultSet user_for_acc = DBConnector.getQueryResult("select * from users where user_id="+accdetails.getInt(2));user_for_acc.next();
                                SqlRowSet user_for_acc = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetails.getInt(2)}, new int[]{Types.INTEGER});user_for_acc.next();
				int amount_left = accdetails.getInt(3);
				
				message = "Transaction approved";
				//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left+amount)+" where account_id="+acc);
                                DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left+amount), acc}, new int[]{Types.INTEGER, Types.INTEGER});
				//st_type1.executeUpdate();
					
				//st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+Integer.parseInt(id));
				DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
                                //st_type1.executeUpdate();
				EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been credited with amount : $"+amount, user_for_acc.getString(6));
			}
			else if(type_id==3){
				int accTo = Integer.parseInt(accountTo);
				//ResultSet accdetailsTo = DBConnector.getQueryResult("select * from account where account_id="+accTo);accdetailsTo.next();
                                SqlRowSet accdetailsTo = DBConnector.execute("select * from account where account_id=?", new Object[]{accTo}, new int[]{Types.INTEGER});accdetailsTo.next();
				//ResultSet user_for_acc_to = DBConnector.getQueryResult("select * from users where user_id="+accdetailsTo.getInt(2));user_for_acc_to.next();
                                SqlRowSet user_for_acc_to = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsTo.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_to.next();
				int amount_left_to = accdetailsTo.getInt(3);
				
				int accFrom = Integer.parseInt(accountFrom);
				//ResultSet accdetailsFrom = DBConnector.getQueryResult("select * from account where account_id="+accFrom);accdetailsFrom.next();
                                SqlRowSet accdetailsFrom = DBConnector.execute("select * from account where account_id=?", new Object[]{accFrom}, new int[]{Types.INTEGER});accdetailsFrom.next();
				//ResultSet user_for_acc_from = DBConnector.getQueryResult("select * from users where user_id="+accdetailsFrom.getInt(2));user_for_acc_from.next();
                                SqlRowSet user_for_acc_from = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsFrom.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_from.next();
				int amount_left_from = accdetailsFrom.getInt(3);
				
				if(amount_left_from-amount<0){
					message = "Insuffecient funds";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=6 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=6 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your transaction has been declined due to insuffecient funds.", user_for_acc_from.getString(6));
				}
				else{
					message = "Transaction Approved.";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_from-amount)+" where account_id="+accFrom);
					DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_from-amount), accFrom}, new int[]{Types.INTEGER, Types.INTEGER});
                                        //st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been debited with amount : $"+amount, user_for_acc_from.getString(6));
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_to+amount)+" where account_id="+accTo);
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_to+amount), accTo}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been credited with amount : $"+amount, user_for_acc_to.getString(6));
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
				}
			}
			else if(status_id==8){
				int accTo = Integer.parseInt(accountTo);
				//ResultSet accdetailsTo = DBConnector.getQueryResult("select * from account where account_id="+accTo);accdetailsTo.next();
                                SqlRowSet accdetailsTo = DBConnector.execute("select * from account where account_id=?", new Object[]{accTo}, new int[]{Types.INTEGER});accdetailsTo.next();
				//ResultSet user_for_acc_to = DBConnector.getQueryResult("select * from users where user_id="+accdetailsTo.getInt(2));user_for_acc_to.next();
                                SqlRowSet user_for_acc_to = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsTo.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_to.next();
				int amount_left_to = accdetailsTo.getInt(3);
				
				int accFrom = Integer.parseInt(accountFrom);
				//ResultSet accdetailsFrom = DBConnector.getQueryResult("select * from account where account_id="+accFrom);accdetailsFrom.next();
                                SqlRowSet accdetailsFrom = DBConnector.execute("select * from account where account_id=?", new Object[]{accFrom}, new int[]{Types.INTEGER});accdetailsFrom.next();
				//ResultSet user_for_acc_from = DBConnector.getQueryResult("select * from users where user_id="+accdetailsFrom.getInt(2));user_for_acc_from.next();
                                SqlRowSet user_for_acc_from = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsFrom.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_from.next();
				int amount_left_from = accdetailsFrom.getInt(3);
				
				if(1500-amount_left_from-amount<0){
					message = "Credit Limit Exceeded";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=6 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=6 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your transaction has been declined due to unavailability of credit.", user_for_acc_from.getString(6));
				}
				else{
					message = "Transaction Approved.";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_from+amount)+" where account_id="+accFrom);
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_from+amount), accFrom}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "A Credit Card payment was initiated for amount : $"+amount, user_for_acc_from.getString(6));
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_to+amount)+" where account_id="+accTo);
					//st_type1.executeUpdate();
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_to+amount), accTo}, new int[]{Types.INTEGER, Types.INTEGER});
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been credited with amount : $"+amount, user_for_acc_to.getString(6));
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
				}
			}
			else if(status_id==9){
				int accTo = Integer.parseInt(accountTo);
				//ResultSet accdetailsTo = DBConnector.getQueryResult("select * from account where account_id="+accTo);accdetailsTo.next();
                                SqlRowSet accdetailsTo = DBConnector.execute("select * from account where account_id=?", new Object[]{accTo}, new int[]{Types.INTEGER});accdetailsTo.next();
				//ResultSet user_for_acc_to = DBConnector.getQueryResult("select * from users where user_id="+accdetailsTo.getInt(2));user_for_acc_to.next();
                                SqlRowSet user_for_acc_to = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsTo.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_to.next();
				int amount_left_to = accdetailsTo.getInt(3);
				
				int accFrom = Integer.parseInt(accountFrom);
				//ResultSet accdetailsFrom = DBConnector.getQueryResult("select * from account where account_id="+accFrom);accdetailsFrom.next();
                                SqlRowSet accdetailsFrom = DBConnector.execute("select * from account where account_id=?", new Object[]{accFrom}, new int[]{Types.INTEGER});accdetailsFrom.next();
				//ResultSet user_for_acc_from = DBConnector.getQueryResult("select * from users where user_id="+accdetailsFrom.getInt(2));user_for_acc_from.next();
                                SqlRowSet user_for_acc_from = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsFrom.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_from.next();
				int amount_left_from = accdetailsFrom.getInt(3);
				
				if(amount_left_from-amount<0){
					message = "Insuffecient funds";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=6 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=6 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your transaction has been declined due to insuffecient funds.", user_for_acc_from.getString(6));
				}
				else{
					message = "Transaction Approved.";
					//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_from-amount)+" where account_id="+accFrom);
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_from-amount), accFrom}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been debited with amount : $"+amount, user_for_acc_from.getString(6));
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_to-amount)+" where account_id="+accTo);
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_to-amount), accTo}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type1.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Payment for Credit Card balance has been submitted for amount : $"+amount, user_for_acc_to.getString(6));
					
					//st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+Integer.parseInt(id));
                                        DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type1.executeUpdate();
				}
			}
		}
		else if(role==4 || role==5){			
			if(id1!=null && !id1.equals("") && !id1.equals("null") && !id1.equals("NULL") && status_id!=1){
				response.sendRedirect("AuthError.jsp");
				return;
			}
			
			if(id1!=null && !id1.equals("") && !id1.equals("null") && !id1.equals("NULL")){
				//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("select * from account where account_id=? and user_id=?");
				//st_type1.setInt(1,Integer.parseInt(id1));
				//st_type1.setInt(2,user_id);
				//ResultSet accdetailsTo = st_type1.executeQuery();
                                SqlRowSet accdetailsTo = DBConnector.execute("select * from account where account_id=? and user_id=?", new Object[]{Integer.parseInt(id1), user_id}, new int[]{Types.INTEGER, Types.INTEGER});
				if(!accdetailsTo.next()){
					response.sendRedirect("AuthError.jsp");
					return;					
				}
			}
			
			//PreparedStatement st_type1 = DBConnector.getConnection().prepareStatement("select * from account where account_id=? and user_id=?");
                        int account_id_temp;
			if(status_id==1){
				//st_type1.setInt(1,Integer.parseInt(id1));
                                account_id_temp = Integer.parseInt(id1);
			}
			else if(status_id==2){
				//st_type1.setInt(1,Integer.parseInt(accountTo));
                                account_id_temp = Integer.parseInt(accountTo);
			}
			else{
				response.sendRedirect("AuthError.jsp");
				return;
			}
			//st_type1.setInt(2,user_id);
			//ResultSet accdetailsTo = st_type1.executeQuery();
                        SqlRowSet accdetailsTo = DBConnector.execute("select * from account where account_id=? and user_id=?", new Object[]{account_id_temp, user_id}, new int[]{Types.INTEGER, Types.INTEGER});
			if(!accdetailsTo.next()){
				response.sendRedirect("AuthError.jsp");
				return;				
			}
			//ResultSet user_for_acc_to = DBConnector.getQueryResult("select * from users where user_id="+user_id);user_for_acc_to.next();
                        SqlRowSet user_for_acc_to = DBConnector.execute("select * from users where user_id=?", new Object[]{user_id}, new int[]{Types.INTEGER});user_for_acc_to.next();
			//ResultSet accdetailsFrom = DBConnector.getQueryResult("select * from account where account_id="+accountFrom);accdetailsFrom.next();
                        SqlRowSet accdetailsFrom = DBConnector.execute("select * from account where account_id=?", new Object[]{accountFrom}, new int[]{Types.INTEGER});accdetailsFrom.next();
			//ResultSet user_for_acc_from = DBConnector.getQueryResult("select * from users where user_id="+accdetailsFrom.getString(2));user_for_acc_from.next();
                        SqlRowSet user_for_acc_from = DBConnector.execute("select * from users where user_id=?", new Object[]{accdetailsFrom.getInt(2)}, new int[]{Types.INTEGER});user_for_acc_from.next();
			int amount_left_from = accdetailsFrom.getInt(3);
			int amount_left_to = accdetailsTo.getInt(3);
			
			System.out.println(amount_left_from);
			System.out.println(amount);
			if(amount_left_from<amount){
				message  = "Insuffecient Funds";
				//st_type1 = DBConnector.getConnection().prepareStatement("update transactions set status_id=6 where transaction_id="+Integer.parseInt(id));
                                DBConnector.update("update transactions set status_id=6 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
				//st_type1.executeUpdate();
				EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your transaction has been declined due to insuffecient funds.", user_for_acc_from.getString(6));
			}
			else{
				message = "Transaction Approved";
				if(amount>=10000){
					if(status_id==1){
						//PreparedStatement st_type2 = DBConnector.getConnection().prepareStatement("update transactions set status_id=3, accountTo=? where transaction_id="+id);	
						//st_type2.setInt(1,accdetailsTo.getInt(1));
                                                DBConnector.update("update transactions set status_id=3, accountTo=? where transaction_id=?", new Object[]{accdetailsTo.getInt(1), Integer.parseInt(id)}, new int[]{Types.INTEGER, Types.INTEGER});
						//st_type2.executeUpdate();
					}
					else{
						//PreparedStatement st_type2 = DBConnector.getConnection().prepareStatement("update transactions set status_id=3 where transaction_id="+id);
                                                DBConnector.update("update transactions set status_id=3 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
						//st_type2.executeUpdate();
					}
				}
				else{
					//PreparedStatement st_type2 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_from-amount)+" where account_id="+accdetailsFrom.getInt(1));
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_from-amount), accdetailsFrom.getInt(1)}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type2.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been debited with amount : $"+amount, user_for_acc_from.getString(6));
					
					//st_type2 = DBConnector.getConnection().prepareStatement("update account set amount="+(amount_left_to+amount)+" where account_id="+accdetailsTo.getInt(1));
                                        DBConnector.update("update account set amount=? where account_id=?", new Object[]{(amount_left_to+amount), accdetailsTo.getInt(1)}, new int[]{Types.INTEGER, Types.INTEGER});
					//st_type2.executeUpdate();
					EmailOTPSender.getEmailOTPSender().sendMail("Transaction Status - ID : ##"+id+"##", "Your account has been credited with amount : $"+amount, user_for_acc_to.getString(6));
					
					//PreparedStatement st_type3 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+id);	
                                        DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type2.executeUpdate();
					
					if(status_id==1){
						//st_type3 = DBConnector.getConnection().prepareStatement("update transactions set accountTo=? where transaction_id="+id);
                                                DBConnector.update("update transactions set accountTo=? where transaction_id=?", new Object[]{accdetailsTo.getInt(1), Integer.parseInt(id)}, new int[]{Types.INTEGER, Types.INTEGER});
						//st_type3.setInt(1,accdetailsTo.getInt(1));
						//st_type3.executeUpdate();
					}
					//st_type3 = DBConnector.getConnection().prepareStatement("update transactions set status_id=7 where transaction_id="+id);
                                        DBConnector.update("update transactions set status_id=7 where transaction_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
					//st_type3.executeUpdate();
				}
			}
		}
		else{
			response.sendRedirect("AuthError.jsp");
			return;	
		}
		}
		catch(Exception e){
			System.out.println(e);
			response.sendRedirect("error.jsp");
			return;
		}
		%>
	}
	
</script>
</head>
<body onpageshow="validateSession()">
<jsp:include page="header.jsp"></jsp:include>
<h1><strong><%=message %></strong></h1>
</body>
</html>