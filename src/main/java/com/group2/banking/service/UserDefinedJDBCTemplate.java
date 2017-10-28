package com.group2.banking.service;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

public interface UserDefinedJDBCTemplate {

	public JdbcTemplate getJdbcTemplate();
	
}
