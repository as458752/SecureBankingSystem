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
   try {
		if(SessionManagement.check(request,"user_id")==null || SessionManagement.check(request,"user_id").equals("") || SessionManagement.check(request,"user_id").equals("null")){
			response.sendRedirect("login.jsp");
			return;
		}
		
		String id = request.getParameter("id");
		String id1 = request.getParameter("id1");
		String type = request.getParameter("type");
		if(type.equals("") || type.equals("null") || type==null){
			response.sendRedirect("AuthError.jsp");
			return;
		}
	    
		if(!type.equals("viewAndEdit") && !type.equals("ApproveAccount")){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		else if(type.equals("viewAndEdit") && (!SessionManagement.check(request,"user_role").equals("4") && !SessionManagement.check(request,"user_role").equals("5") && !SessionManagement.check(request,"user_role").equals("2"))){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		else if(type.equals("ApproveAccount") && (!SessionManagement.check(request,"user_role").equals("2") && !SessionManagement.check(request,"user_role").equals("3"))){
			response.sendRedirect("AuthError.jsp");
			return;
		}
		else if(type.equals("viewAndEdit")){
			if(id.equals("") || id.equals("null") || id==null || id1.equals("") || id1.equals("null") || id1==null){
				response.sendRedirect("AuthError.jsp");
				return;
			}
			//ResultSet rs = DBConnector.getQueryResult("select * from edituseraccountapprovals where owner_id="+id1+" and user_id="+id);
                        //PreparedStatement st1 = DBConnector.getConnection().prepareStatement("select * from edituseraccountapprovals where owner_id=? and user_id=?");
                        SqlRowSet rs = DBConnector.execute("select * from edituseraccountapprovals where owner_id=? and user_id=?", new Object[]{Integer.parseInt(id1), Integer.parseInt(id)}, new int[]{Types.INTEGER, Types.INTEGER});
                        //st1.setInt(1,Integer.parseInt(id1));
                        //st1.setInt(2,Integer.parseInt(id));
                        //ResultSet rs = null;
                        
			if(rs.next()){
				if(rs.getInt(3)!=2){
					System.out.println("temp 4");
					response.sendRedirect("AuthError.jsp");
					return;
				}
				if(SessionManagement.check(request,"user_role").equals("2") && rs.getInt(4)!=2){
					System.out.println("temp 5");
					response.sendRedirect("AuthError.jsp");
					return;
				}
				if((SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")) && rs.getInt(4)!=1){
					System.out.println("temp 6");
					response.sendRedirect("AuthError.jsp");
					return;
				}
				
				//Decline..
				//Connection con = DBConnector.getConnection();
				if(SessionManagement.check(request,"user_role").equals("4") || SessionManagement.check(request,"user_role").equals("5")){
					if(!id1.equals(SessionManagement.check(request, "user_id"))){
						response.sendRedirect("AuthError.jsp");
						return;
					}
				}
				//PreparedStatement st = con.prepareStatement("update edituseraccountapprovals set approval_status=3 where owner_id=? and user_id=?");
				//st.setInt(1,Integer.parseInt(id1));
				//st.setInt(2,Integer.parseInt(id));
                                DBConnector.update("update edituseraccountapprovals set approval_status=3 where owner_id=? and user_id=?", new Object[]{Integer.parseInt(id1), Integer.parseInt(id)}, new int[]{Types.INTEGER, Types.INTEGER});
			}
			else{
				System.out.println("temp 7");
				response.sendRedirect("AuthError.jsp");
				return;	
			}
		}
		else if(type.equals("ApproveAccount")){
			if(id.equals("") || id.equals("null") || id==null){
				response.sendRedirect("AuthError.jsp");
				return;
			}
			
			//Connection conn = DBConnector.getConnection();
			//PreparedStatement st = conn.prepareStatement("select * from account where account_id=?");
			//st.setInt(1, Integer.parseInt(id));
			//ResultSet rs = null;
                        SqlRowSet rs = DBConnector.execute("select * from account where account_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
			if(rs.next()){
				if(rs.getInt(5)!=2){
					response.sendRedirect("AuthError.jsp");
					return;
				}
				
				//Decline..
				//st = conn.prepareStatement("update account set account_status=3 where account_id=?");
				//st.setInt(1,Integer.parseInt(id));
                                DBConnector.update("update account set account_status=3 where account_id=?", new Object[]{Integer.parseInt(id)}, new int[]{Types.INTEGER});
			}
			else{
				response.sendRedirect("AuthError.jsp");
				return;	
			}
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
	<h1>Declined!</h1>
</body>
</html>