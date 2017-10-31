package com.group2.banking.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.group2.banking.service.DBConnector;
import com.group2.banking.service.MutexLock;

public class AuthUtil {
	public synchronized static int isUserAuthorizedToEditandCreateUserAccounts(String user_id, String owner_id) throws Exception{
		//ResultSet rs = DBConnector.getQueryResult("select * from edituseraccountapprovals where owner_id="+Integer.parseInt(owner_id)+" and user_id="+Integer.parseInt(user_id));
		PreparedStatement st1 = DBConnector.getConnection().prepareStatement("select * from edituseraccountapprovals where owner_id=? and user_id=?");
                st1.setInt(1,Integer.parseInt(owner_id));
                st1.setInt(2, Integer.parseInt(user_id));
                ResultSet rs = null;
                synchronized(MutexLock.getEdituseraccountapprovals()){
                    rs = st1.executeQuery();
                }
		if(rs.next()) {
			if(rs.getInt(3)==1) {
				Connection con = DBConnector.getConnection();
				PreparedStatement st = con.prepareStatement("SET SQL_SAFE_UPDATES = 0");
				st.executeUpdate();
				st = con.prepareStatement("delete from edituseraccountapprovals where owner_id="+Integer.parseInt(owner_id)+" and user_id="+Integer.parseInt(user_id));
				st.executeUpdate();
				return 1;
			}
			else if(rs.getInt(3)==3) {
				return 3;
			}
		}else {
			Connection con = DBConnector.getConnection();
			PreparedStatement st = con.prepareStatement("insert into edituseraccountapprovals values("+owner_id+","+user_id+","+"2,1)");
			st.executeUpdate();
		}
		return 2;
	}
}
