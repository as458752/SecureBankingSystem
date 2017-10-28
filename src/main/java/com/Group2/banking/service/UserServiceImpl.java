package com.group2.banking.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.security.*;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import com.group2.banking.*;
import com.group2.banking.model.*;
import com.group2.banking.service.*;

public class UserServiceImpl implements UserService {

	  @Autowired
	  DataSource datasource;
	  @Autowired
	  JdbcTemplate jdbcTemplate;
	  
	  public void addSecurityQuestions(User user) {
		  String insertSql = "insert into user_ques_mapping values(?,?,?)";
		  Object[] params;
		  int[] types;
		  insertSql = "insert into user_ques_mapping values(?,?,?)";
    	  if(user.getQ1()!=null && !user.getQ1().equals("") && !user.getQ1().equals("null")) {
    		  	params = new Object[] { (jdbcTemplate.queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")) , 1, user.getQ1()};
  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
				{
  	        		jdbcTemplate.update(insertSql,params,types);
				}
    	  }
    	  if(user.getQ2()!=null && !user.getQ2().equals("") && !user.getQ2().equals("null")) {
    		  	params = new Object[] { (jdbcTemplate.queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")) , 2, user.getQ2()};
  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
				{
  	        		jdbcTemplate.update(insertSql,params,types);
				}
    	  }
    	  if(user.getQ3()!=null && !user.getQ3().equals("") && !user.getQ3().equals("null")) {
    		  	params = new Object[] { (jdbcTemplate.queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")) , 3, user.getQ3()};
  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
				{
  	        		jdbcTemplate.update(insertSql,params,types);
				}
    	  }
    	  if(user.getQ4()!=null && !user.getQ4().equals("") && !user.getQ4().equals("null")) {
    		  	params = new Object[] { (jdbcTemplate.queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")) , 4, user.getQ4()};
  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
				{
  	        		jdbcTemplate.update(insertSql,params,types);
				}
    	  }
    	  if(user.getQ5()!=null && !user.getQ5().equals("") && !user.getQ5().equals("null")) {
    		  	params = new Object[] { (jdbcTemplate.queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")) , 5, user.getQ5()};
  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
				{
  	        		jdbcTemplate.update(insertSql,params,types);
				}
    	  }
    	  if(user.getQ6()!=null && !user.getQ6().equals("") && !user.getQ6().equals("null")) {
    		  	params = new Object[] { (jdbcTemplate.queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")) , 6, user.getQ6()};
  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
				{
  	        		jdbcTemplate.update(insertSql,params,types);
				}
    	  }
	  }
	  
	  public String change_password (User user)
	  {
		  try{
		  		Login login = new Login();
		  		login.setUsername(user.getUsername());
		  		login.setPassword(user.getPassword());
		  		
			  	String updateSql = "SET SQL_SAFE_UPDATES = 0"; 
		  		jdbcTemplate.update(updateSql);
		  
		  	String updateSql1 =  "UPDATE users SET password= ? where username = ?";
	    	 Object[] params1 = new Object[] {GetHash.encrypt(user.getNewpassword()), user.getUsername() };
	    	 int[] types1 = new int[] {Types.VARCHAR, Types.VARCHAR};
	    	 synchronized(MutexLock.getUsersTableMutex())
			 {
	    		 jdbcTemplate.update(updateSql1,params1,types1);
			 }
	    	 
	    	 return "Password has been updated successfully";
		  }
		  catch(Exception e){
			  return "Error";
		  }
	  }
	  
	  
	  public String unlock(User user)
	  {
		  try{
			
		     String updateSql = "SET SQL_SAFE_UPDATES = 0"; 
	    	 jdbcTemplate.update(updateSql); 
	 	       
	    	 String updateSql1 =  "UPDATE users SET user_status= ? where username = ?";
	    	 Object[] params1 = new Object[] {1, user.getUsername() };
	    	 int[] types1 = new int[] {Types.INTEGER, Types.VARCHAR};
	    	 synchronized(MutexLock.getUsersTableMutex())
			 {
	    		 jdbcTemplate.update(updateSql1,params1,types1); 
			 }
	    	 
	    	 
	    	 String updateSql2 =  "UPDATE users SET NO_OF_ATTEMPTS= ? where username = ?";
  	    	 Object[] params2 = new Object[] {0, user.getUsername() };
  	    	 int[] types2 = new int[] {Types.INTEGER, Types.VARCHAR};
  	    	synchronized(MutexLock.getUsersTableMutex())
			 {
  	    		jdbcTemplate.update(updateSql2,params2,types2); 
			 }
		  }
		  catch(Exception e)
		  {
			  return "Error";
		  }
	    	 return "User has been Unlocked";
	    	 
	  }
	    public User validateUser(Login login) {
	    	
	    	String hashedPassword = GetHash.encrypt(login.getPassword());
		    String sql = "select * from users where username='" + login.getUsername() + "'";
		   // List<User> users = jdbcTemplate.query(sql, new UserMapper());
		    List<User> users = new ArrayList<User>();
		    List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		    synchronized(MutexLock.getUsersTableMutex())
			{
		        rows = jdbcTemplate.queryForList(sql);
			}
			for (Map<String, Object> row : rows) {
				User user = new User();
			    user.setUsername((String)row.get("username"));
			    user.setPassword((String)row.get("password"));
			    user.setFirstname((String)row.get("firstname"));
			    user.setLastname((String)row.get("lastname"));
			    user.setEmail((String)row.get("email"));
			    user.setAddress((String)row.get("address"));
			    user.setPhone(Long.valueOf((String)row.get("phone")));
			    user.setRole(row.get("Role_id").toString());
			    user.setno_of_failed_attempts((Integer)row.get("NO_OF_ATTEMPTS"));
			    user.setstatus((Integer)row.get("user_status"));
			    users.add(user);
			}
			
			
		    
		    //Check for password authentication
		    if(users.size()>0){
		        
		        	
		        	
		    	if(users.get(0).getstatus()==4 || users.get(0).getPassword().equals(hashedPassword)){
		    		return users.get(0);
		    	}
		    	else
		    	{
		    		if(users.get(0).getno_of_failed_attempts()==3)
		    			lock(users.get(0));
		    		else
		    		{
		    			  
			  	    	 String updateSql = "SET SQL_SAFE_UPDATES = 0"; 
			  	    	 jdbcTemplate.update(updateSql); 
				 	       
			  	    	 String updateSql1 =  "UPDATE users SET NO_OF_ATTEMPTS= ? where username = ?";
			  	    	 Object[] params1 = new Object[] {users.get(0).getno_of_failed_attempts()+1 , users.get(0).getUsername() };
			  	    	 int[] types1 = new int[] {Types.INTEGER, Types.VARCHAR};
			  	    	synchronized(MutexLock.getUsersTableMutex())
						{
			  	    		jdbcTemplate.update(updateSql1,params1,types1); 
						}
		    		}
		    		
		    	}
		    }
		    
		    return null;
	    } 

	    public void lock(User user1)
	    {
	    	 String updateSql = "SET SQL_SAFE_UPDATES = 0"; 
  	    	 jdbcTemplate.update(updateSql); 
  	    	 
		   	 String updateSql1 =  "UPDATE users SET user_status= ? where username = ?";
			 Object[] params1 = new Object[] {4, user1.getUsername() };
		    int[] types1 = new int[] {Types.INTEGER, Types.VARCHAR};
		    synchronized(MutexLock.getUsersTableMutex())
			{
		    	jdbcTemplate.update(updateSql1,params1,types1); 
			}
	    }
		  
	    public String edit(User edituser)
		   {
		  	      try
		  	      {
		  	    	  
		  	    	 String updateSql = "SET SQL_SAFE_UPDATES = 0";  jdbcTemplate.update(updateSql); 
			 	     Object[] params1;
			 	     int[] types1;
			 	    String updateSql1;
			 	     
		  	    	 if(edituser.getRole()==1 || edituser.getRole()==2) {
		    	    	updateSql1 =  "UPDATE users SET firstname= ? , lastname= ?, address = ? , phone = ? , Role_id=?  where username = ?";
			    	    params1 = new Object[] { edituser.getFirstname(), edituser.getLastname(), edituser.getAddress(), edituser.getPhone(), edituser.getRole(), edituser.getUsername() };
			 	        types1 = new int[] { Types.VARCHAR, Types.VARCHAR , Types.VARCHAR, Types.INTEGER, Types.INTEGER , Types.VARCHAR};
		    	    }
		  	    	 else {
		  	    		updateSql1 =  "UPDATE users SET username=?,firstname= ? , lastname= ?, address = ? , phone = ? where username = ?";
			    	    params1 = new Object[] { edituser.getFirstname(), edituser.getLastname(), edituser.getAddress(), edituser.getPhone(), edituser.getUsername() };
			 	        types1 = new int[] { Types.VARCHAR, Types.VARCHAR , Types.VARCHAR, Types.INTEGER, Types.INTEGER , Types.VARCHAR}; 
		  	    	 }
		 	        
		  	    	synchronized(MutexLock.getUsersTableMutex())
					{
		  	    		jdbcTemplate.update(updateSql1,params1,types1); 
					}
		  	      }
		  	      catch(Exception E)
		  	      {
		  	    	   System.out.println(E);
		  	      }
		  	       return "Updated Successfully!";
				      	
			  }
	    
		  public String register(User adduser){
			  System.out.println("Inside register");

			  String sql = "select * from users where username='" + adduser.getUsername()+"' or email='"+adduser.getEmail()+"'"; 
			  List<User> users = new ArrayList<User>();
			  synchronized(MutexLock.getUsersTableMutex())
			  {
				  users = jdbcTemplate.query(sql, new UserMapper());
			  }
	  	      
	  	      if(users.size() > 0)
	    	  {
	    		  return "Please provide a new username/Email as user already exists with username/Email";
	    	  }
	  	     // Random r=new Random();
	  	      
	  	      //Encrypt Password
	  	      GetHash g = new GetHash();
			  String hashedPassword = g.encrypt(adduser.getPassword());
			  System.out.println("hashedPassword:"+hashedPassword);
	  	      
	  	     
	    	  String insertSql =
		    			  "INSERT INTO users (" +
		    			  " username, " +
		    			  " password, " +
		    			  " firstname, " +
		    			  " lastname, " +
		    			  " email, " +
		    			  " address, " +
		    			  " phone, role_id)" +
		    			  "VALUES (?,?,?,?,?,?,?,?)";
		      Object[] params = new Object[] { adduser.getUsername(),hashedPassword,adduser.getFirstname(),adduser.getLastname(),adduser.getEmail(),adduser.getAddress(),adduser.getPhone(), adduser.getRole() };
	        int[] types = new int[] { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.INTEGER,Types.INTEGER};
	        synchronized(MutexLock.getUsersTableMutex())
			{
		      jdbcTemplate.update(insertSql,params,types);
			}
		      
		      //Add security questions..
		      

		      sql = "select * from users where username='" + adduser.getUsername()+"'";
		      int user_id = 0;
		      synchronized(MutexLock.getUsersTableMutex())
			  {
		    	  user_id = (Integer)jdbcTemplate.queryForList(sql).get(0).get("user_id");
			  }
	    	  insertSql = "insert into user_ques_mapping values(?,?,?)";
	    	  if(adduser.getQ1()!=null && !adduser.getQ1().equals("") && !adduser.getQ1().equals("null")) {
	    		  	params = new Object[] { user_id , 1, adduser.getQ1()};
	  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
	  	        	 synchronized(MutexLock.getUserQuesMappingTableMutex())
	  				 {
	  	        		 jdbcTemplate.update(insertSql,params,types);
	  				 }
	    	  }
	    	  if(adduser.getQ2()!=null && !adduser.getQ2().equals("") && !adduser.getQ2().equals("null")) {
	    		  	params = new Object[] { user_id , 2, adduser.getQ2()};
	  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
	  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
	  				 {
	  	        	    jdbcTemplate.update(insertSql,params,types);
	  				 }
	    	  }
	    	  if(adduser.getQ3()!=null && !adduser.getQ3().equals("") && !adduser.getQ3().equals("null")) {
	    		  	params = new Object[] { user_id , 3, adduser.getQ3()};
	  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
	  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
	  				 {
	  	        	    jdbcTemplate.update(insertSql,params,types);
	  				 }
	    	  }
	    	  if(adduser.getQ4()!=null && !adduser.getQ4().equals("") && !adduser.getQ4().equals("null")) {
	    		  	params = new Object[] { user_id , 4, adduser.getQ4()};
	  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
	  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
	  				 {
	  	        	    jdbcTemplate.update(insertSql,params,types);
	  				 }
	    	  }
	    	  if(adduser.getQ5()!=null && !adduser.getQ5().equals("") && !adduser.getQ5().equals("null")) {
	    		  	params = new Object[] { user_id , 5, adduser.getQ5()};
	  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
	  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
	  				 {
	  	        	    jdbcTemplate.update(insertSql,params,types);
	  				 }
	    	  }
	    	  if(adduser.getQ6()!=null && !adduser.getQ6().equals("") && !adduser.getQ6().equals("null")) {
	    		  	params = new Object[] { user_id , 6, adduser.getQ6()};
	  	        	types = new int[] { Types.INTEGER, Types.INTEGER, Types.VARCHAR};
	  	        	synchronized(MutexLock.getUserQuesMappingTableMutex())
	  				 {
	  	        	    jdbcTemplate.update(insertSql,params,types);
	  				 }
	    	  }
	    	  
	    	  
	  	     return "Registered successfully!"; 
		  }
		  
		  public String register_internal(User adduser){
			  System.out.println("Inside register");

	    	  String sql = "select * from users where username='" + adduser.getUsername()+"' or email='"+adduser.getEmail()+"'";
	    	  List<User> users = new ArrayList<User>();
	    	  synchronized(MutexLock.getUsersTableMutex())
		      {
	    		  users = jdbcTemplate.query(sql, new UserMapper());
		      }
	  	      
	  	      if(users.size() > 0)
	    	  {
	    		  return "Please provide a new username/Email as user already exists with username/Email";
	    	  }
	  	 
	  	     adduser.setPassword(EmailOTPSender.getEmailOTPSender().generateOTP());
	  	      GetHash g = new GetHash();
			  String hashedPassword = g.encrypt(adduser.getPassword());
			  System.out.println("hashedPassword:"+hashedPassword);
	  	      
	  	     
	    	  String insertSql =
		    			  "INSERT INTO users (" +
		    			  " username, " +
		    			  " password, " +
		    			  " firstname, " +
		    			  " lastname, " +
		    			  " email, " +
		    			  " address, " +
		    			  " phone, role_id)" +
		    			  "VALUES (?,?,?,?,?,?,?,?)";
		      Object[] params = new Object[] { adduser.getUsername(),hashedPassword,adduser.getFirstname(),adduser.getLastname(),adduser.getEmail(),adduser.getAddress(),adduser.getPhone(), adduser.getRole() };
	        int[] types = new int[] { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.INTEGER,Types.INTEGER};
	        synchronized(MutexLock.getUsersTableMutex())
		    {  
	        	jdbcTemplate.update(insertSql,params,types);
		    }
		      
		      //Add security questions..
		      
		      EmailOTPSender.getEmailOTPSender().sendMail("Notification from GoSwiss Bank!!", "Please update the password and security questions once you login\n\n\t\tUSERNAME : "+adduser.getUsername()+"\n\t\tPASSOWRD : "+adduser.getPassword(), adduser.getEmail());
	     
	    	  
	    	  
	  	     return "Added User successfully!"; 
		  }
		  
		  
		
		  
		  
	  	  class UserMapper implements RowMapper<User> {
		  	  public User mapRow(ResultSet rs, int arg1) throws SQLException {
		  	    User user = new User();
		  	    user.setUsername(rs.getString("username"));
		  	    return user;
	  	  }


	    }
	  	  
	  	  

	}

	  class UserMapper implements RowMapper<User> {
	  public User mapRow(ResultSet rs, int arg1) throws SQLException {
	    User user = new User();
	    user.setUsername(rs.getString("username"));
	    user.setPassword(rs.getString("password"));
	    user.setFirstname(rs.getString("firstname"));
	    user.setLastname(rs.getString("lastname"));
	    user.setEmail(rs.getString("email"));
	    user.setAddress(rs.getString("address"));
	    user.setPhone(rs.getLong("phone"));
	    return user;
	  }
	}
