package com.group2.banking.service;

import com.group2.banking.model.*;

public interface UserService {
	User validateUser(Login login);
	
    String register(User adduser);
    
    String register_internal(User adduser);
	
	String edit(User adduser);
	
	String unlock(User user);
	String change_password(User user);
	void addSecurityQuestions(User user);
}
