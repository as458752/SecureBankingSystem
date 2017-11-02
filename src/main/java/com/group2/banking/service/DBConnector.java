package com.group2.banking.service;

import java.sql.Connection;
import com.mysql.jdbc.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public class DBConnector {
    private static DataSource datasource;
    private static JdbcTemplate jdbcTemplate = null;
    
    public static JdbcTemplate getJdbcTemplate()
    {
        try{
            if(jdbcTemplate == null){
        String url = "jdbc:mysql://localhost:3306/bank";
	String db = "bank";
				//String driver = "com.mysql.jdbc.Driver";
				String userName ="root";
				String password="abhisana@1993";
        Driver driver = new Driver();
        DataSource ds = new SimpleDriverDataSource(driver,url,userName,password);
        jdbcTemplate = new JdbcTemplate(ds);
        return jdbcTemplate;
            }
        }catch(Exception e)
        {
            return null;
        }
        finally{
            String s = "s";
            return jdbcTemplate;
        }
    }
    
    public static SqlRowSet execute(String sql,Object[] args,int[] argTypes)
    {
        synchronized(MutexLock.getLock()){
            try{
                return DBConnector.getJdbcTemplate().queryForRowSet(sql, args, argTypes);
            }catch(Exception e)
            {
                e.printStackTrace();
                return null;
            }
        }
    }
    
    public static int update(String sql,Object[] args,int[] argTypes)
    {
        synchronized(MutexLock.getLock()){
            int result = 0;
            try{
                result = DBConnector.getJdbcTemplate().update(sql, args, argTypes);
            }catch(Exception e)
            {
                e.printStackTrace();
                return 0;
            }
            finally{
                return result;
            }
        }
    }
}
