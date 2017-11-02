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
        try{
            return DBConnector.getJdbcTemplate().queryForRowSet(sql, args, argTypes);
        }catch(Exception e)
        {
            return null;
        }
    }
    
    public static void update(String sql,Object[] args,int[] argTypes)
    {
        try{
            DBConnector.getJdbcTemplate().update(sql, args, argTypes);
        }catch(Exception e)
        {
        }
    }
    
    
	private static Connection con = null;
	public static Connection getConnection() {
		try {
			if(con==null) {
				String url = "jdbc:mysql://localhost:3306/";
				String db = "bank";
				String driver = "com.mysql.jdbc.Driver";
				String userName ="root";
				String password="abhisana@1993";
				Class.forName(driver).newInstance();
				con = DriverManager.getConnection(url+db,userName,password);
			}
		}
		catch(Exception e) {
			System.out.println(e);
		}
		return con;
	}
	public synchronized static ResultSet getQueryResult(String sql) {
		try {
			Statement st = (Statement)DBConnector.getConnection().createStatement();
			return st.executeQuery(sql);
		}
		catch(Exception e) {
			System.out.println(e);
		}
		return null;
	}
	public static List<Object> getMatchedValuesFromResultSet(ResultSet rs, String column){
		try {
			List<Object> temp = new ArrayList<Object>();
			while(rs.next()) {
				temp.add(rs.getObject(column));
			}
			System.out.println(temp);
			return temp;
		}catch(Exception e) {
			System.out.println(e);
		}
		return null;
	}
}
