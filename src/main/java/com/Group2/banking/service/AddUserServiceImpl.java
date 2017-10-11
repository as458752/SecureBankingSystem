package com.Group2.banking.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Random;
import java.sql.Types;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import com.Group2.banking.*;
import com.Group2.banking.model.*;


public class AddUserServiceImpl implements AddUserService {
  
	  @Autowired
	  DataSource datasource;
	  @Autowired
	  JdbcTemplate jdbcTemplate;
	  
	  public String edit(AddUser adduser)
	  {
		  /* String sql = "select user_id from users where username='" + adduser.getUsername()+"'"; 	 
    	  List<User> users = jdbcTemplate.query(sql, new UserMapper());
  	      User user1= users.size() > 0 ? users.get(0) : null;
  	      
  	      if(users.size() > 0)
    	  {
    		  return "Please provide a unique username";
    	  } */
  	      try
  	      {
    	    String updateSql =
	    			  "UPDATE users " +
	    	          "SET password="+adduser.getPassword()+
	    	          "where username="+adduser.getUsername();
    	    jdbcTemplate.update(updateSql);
  	      }
  	      catch(Exception E)
  	      {
  	    	  return E.getMessage().toString();
  	      }
	    			/*  " password, " +
	    			  " firstname, " +
	    			  " lastname, " +
	    			  " email, " +
	    			  " address, " +
	    			  " phone)" +
	    			  "VALUES (?,?,?,?,?,?,?,?)";
	      Object[] params = new Object[] { r.nextInt() , adduser.getUsername(),adduser.getPassword(),adduser.getFirstname(),adduser.getLastname(),adduser.getEmail(),adduser.getAddress(),adduser.getPhone() };
        int[] types = new int[] { Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.INTEGER };
	      jdbcTemplate.update(insertSql,params,types); */

  	     return "Edited successfully!"; 
	  }
	  public String register(AddUser adduser){

    	  String sql = "select * from users where username='" + adduser.getUsername()+"'"; 	 
    	  List<User> users = jdbcTemplate.query(sql, new UserMapper());
  	     // User user1= users.size() > 0 ? users.get(0) : null;
  	      
  	      if(users.size() > 0)
    	  {
    		  return "Please provide a new username as user already exists";
    	  }
  	      Random r=new Random();
    	    String insertSql =
	    			  "INSERT INTO users (" +
	    	          "user_id,"  +
	    			  " username, " +
	    			  " password, " +
	    			  " firstname, " +
	    			  " lastname, " +
	    			  " email, " +
	    			  " address, " +
	    			  " phone)" +
	    			  "VALUES (?,?,?,?,?,?,?,?)";
	      Object[] params = new Object[] { r.nextInt() , adduser.getUsername(),adduser.getPassword(),adduser.getFirstname(),adduser.getLastname(),adduser.getEmail(),adduser.getAddress(),adduser.getPhone() };
        int[] types = new int[] { Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.INTEGER };
	      jdbcTemplate.update(insertSql,params,types);

  	     return "Registered successfully!"; 
	  }
  	  class UserMapper implements RowMapper<User> {
  	  public User mapRow(ResultSet rs, int arg1) throws SQLException {
  	    User user = new User();
  	    user.setUsername(rs.getString("username"));
  	    return user;
  	  }


    }

}




/*  if(adduser.getPassword()!=adduser.getReentered_password())
  {
	  return "Re-entered password is not matching the entered password";
  } */