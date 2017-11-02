package com.group2.banking.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.group2.banking.service.DBConnector;
import com.group2.banking.service.MutexLock;
import java.sql.Types;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public class AuthUtil {
	public synchronized static int isUserAuthorizedToEditandCreateUserAccounts(String user_id, String owner_id) throws Exception{
                SqlRowSet rs = DBConnector.execute("select * from edituseraccountapprovals where owner_id=? and user_id=?", new Object[]{Integer.parseInt(owner_id),Integer.parseInt(user_id)}, new int[]{Types.INTEGER,Types.INTEGER});
		if(rs.next()) {
			if(rs.getInt(3)==1) {
                            DBConnector.getJdbcTemplate().update("SET SQL_SAFE_UPDATES = 0");
                            DBConnector.update("delete from edituseraccountapprovals where owner_id=? and user_id=?", new Object[]{Integer.parseInt(owner_id),Integer.parseInt(user_id)}, new int[]{Types.INTEGER,Types.INTEGER});
                            return 1;
			}
			else if(rs.getInt(3)==3) {
				return 3;
			}
		}else {
                        DBConnector.update("insert into edituseraccountapprovals values(?,?,2,1)", new Object[]{Integer.parseInt(owner_id),Integer.parseInt(user_id)}, new int[]{Types.INTEGER,Types.INTEGER});
		}
		return 2;
	}
}
