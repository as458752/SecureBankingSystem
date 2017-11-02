package com.group2.banking.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public class DBConnector {
    @Autowired
    private static UserDefinedJDBCTemplate template;
    
    public static SqlRowSet execute(String sql,Object[] args,int[] argTypes)
    {
        try{
            return template.getJdbcTemplate().queryForRowSet(sql, args, argTypes);
        }catch(Exception e)
        {
            return null;
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
