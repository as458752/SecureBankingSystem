package com.group2.banking.controller;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import javax.servlet.http.HttpServletRequest;
import com.group2.banking.service.*;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.group2.banking.model.*;

@Controller
public class BaseController {
	@Autowired
	private UserService userService;
	@Autowired
	private UserDefinedJDBCTemplate template;

	
	@RequestMapping(value = "/pendingApprovals", method = RequestMethod.GET)
	public ModelAndView showPendingApprovals(HttpServletRequest request, HttpServletResponse response) {
		try {
			ModelAndView mav = new ModelAndView("Pending_Approvals");
			return mav;
		}catch(Exception e) {
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}
	
	@RequestMapping(value = "/OTP", method = RequestMethod.GET)
	public ModelAndView otpProcess(HttpServletRequest request, HttpServletResponse response) {
		try{
			
		ModelAndView mav = null;
		String nextPage = SessionManagement.check(request, "nextPage");
		String givenOTP = request.getParameter("OTP");
		String expectedOTP = SessionManagement.check(request, "OTP");
		
		Long curTime = System.currentTimeMillis();
		Long otp_TimeStamp = Long.parseLong(SessionManagement.check(request, "OTP_TimeStamp"));
		if(curTime-otp_TimeStamp>180*1000 || !givenOTP.equals(expectedOTP)) {
			String no = SessionManagement.check(request,"no_of_failed_otp");
			if(no==null || no.equals("") || no.equals("null") || no.equals("NULL")) {
				SessionManagement.update(request, "no_of_failed_otp", "1");
				mav = new ModelAndView("otp");
				mav.addObject("OTPMessage","OTP doesn't match. Please try again!");
				return mav;
			}
			else if(no.equals("3")) {
				request.getSession().invalidate();
				mav = new ModelAndView("login");
				mav.addObject("error", "Login failed due to multiple failed OTP attempts");
				return mav;
			}
			SessionManagement.update(request, "no_of_failed_otp", ""+(Integer.parseInt(no)+1));
			mav = new ModelAndView("otp");
			mav.addObject("OTPMessage","OTP doesn't match. Please try again!");
			return mav;
		}
		if(SessionManagement.check(request,"password")!=null && !SessionManagement.check(request,"password").equals("") && !SessionManagement.check(request,"password").equals("null")){
			User user = new User();
			user.setPassword(SessionManagement.check(request, "password"));
			user.setNewpassword(SessionManagement.check(request, "new_password"));
			user.setReenter_newpassword((SessionManagement.check(request,"re_new_password")));
			synchronized(MutexLock.getUsersTableMutex())
			{
				user.setUsername((String)template.getJdbcTemplate().queryForList("select * from users where user_id="+SessionManagement.check(request, "user_id")).get(0).get("username"));
			}
			String ans = userService.change_password(user);
			if(ans.equals("Password has been updated successfully")){
				//add security questions..
				user.setQ1(SessionManagement.check(request, "Q1"));
				user.setQ2(SessionManagement.check(request, "Q2"));
				user.setQ3(SessionManagement.check(request, "Q3"));
				user.setQ4(SessionManagement.check(request, "Q4"));
				user.setQ5(SessionManagement.check(request, "Q5"));
				user.setQ6(SessionManagement.check(request, "Q6"));
				userService.addSecurityQuestions(user);
				
				mav = new ModelAndView("login");
				mav.addObject("message", "Password has been updated successfully. Login to complete the process");
				request.getSession().invalidate();
				return mav;
			}
			else{
				throw new Exception();
			}
		}
		else{
			
			String user_id = "";
			synchronized(MutexLock.getUsersTableMutex())
			{
				user_id = ((Integer)template.getJdbcTemplate().queryForList("select * from users where username='"+SessionManagement.check(request, "userName")+"'").get(0).get("user_id")).toString();
				//SessionManagement.update(request, "user_id", ((Integer)template.getJdbcTemplate().queryForList("select * from users where username='"+SessionManagement.check(request, "userName")+"'").get(0).get("user_id")).toString());
				SessionManagement.update(request, "user_id", user_id);
			}
			mav = new ModelAndView(nextPage);
            SessionManagement.addCookie(request, response, GetHash.encrypt(user_id));
            return mav;
		}
		
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
		
	}
	
	
	@RequestMapping(value = "/welcomePage", method = RequestMethod.GET)
	public ModelAndView welcomePage(HttpServletRequest request, HttpServletResponse response) {
		try
		{
		ModelAndView mav = new ModelAndView("welcome");
		return mav;
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}
	
	@RequestMapping(value = "/Logout", method = RequestMethod.GET)
	public ModelAndView logoutProcess(HttpServletRequest request, HttpServletResponse response) {
		try{
		ModelAndView mav = new ModelAndView("login");
		request.getSession().invalidate();
		return mav;
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}
	
	@RequestMapping(value = "/ViewUsers", method = RequestMethod.GET)
	public ModelAndView viewUsers(HttpServletRequest request, HttpServletResponse response) {
		try
		{
		ModelAndView mav = null;
		String roleString = SessionManagement.check(request, "user_role");
		if(roleString==null || roleString.equals("") || roleString.equals("null")) {
			mav = new ModelAndView("login");
			return mav;
		}
		int role_id = Integer.parseInt(roleString);
		if(role_id==3)
    	{
		    mav = new ModelAndView("Welcome_Admin");
    	}
    	else if(role_id==1)
    	{
    		 mav = new ModelAndView("Welcome_Tier1");
    	}
    	else if(role_id==2)
    	{
    		 mav = new ModelAndView("Welcome_Tier2");
    	}
    	else {
    		mav = new ModelAndView("Welcome_External");
    	}
		return mav;
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			mav.addObject("message","Error in base controller");
			return mav;
		}
	}
	
	@RequestMapping(value = "/loginProcess", method = RequestMethod.POST)
	public ModelAndView loginProcess(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute("login") Login login) {
		try {
                    String s = request.getParameter("g-recaptcha-response");
                    if(!CaptchaValidation.verify(s))
                    {
                        ModelAndView mav = new ModelAndView("login");
			mav.addObject("error", "Please check I'm not a robot button!");
			return mav;
                    }
                    request.getSession().invalidate();
                    System.out.println("Inside login");
                    ModelAndView mav = new ModelAndView("otp");
                    User user = userService.validateUser(login);
                    if (null != user) {
			if(user.getstatus()==4){
				mav = new ModelAndView("login");
				mav.addObject("error", "Your account has been Locked because of multiple failed login attempts. Contact the GoSwiss technical support for assistance.");
				return mav;
			}
			String user_id = "";
			synchronized(MutexLock.getUsersTableMutex())
            {
                user_id = ((Integer)template.getJdbcTemplate().queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("user_id")).toString();
                SessionManagement.update(request, "user_id", user_id);
                SessionManagement.update(request, "user_role", ((Integer)user.getRole()).toString());
            }
            if(SessionManagement.checkCookie(request, GetHash.encrypt(user_id)))
            {
                mav = new ModelAndView("welcome");
                return mav;
            }
			mav.addObject("firstname", user.getFirstname());
			
			EmailOTPSender sender = EmailOTPSender.getEmailOTPSender();
			String otp = sender.generateOTP();
			synchronized(MutexLock.getUsersTableMutex())
			{
				sender.sendMail("GoSwiss OTP", "Your OTP for logging in is = "+otp,(String) template.getJdbcTemplate().queryForList("select * from users where username='"+user.getUsername()+"'").get(0).get("email"));
			}
			//Updating session..
			SessionManagement.update(request, "userName", user.getUsername());
			SessionManagement.update(request, "user_role", ((Integer)user.getRole()).toString());
			SessionManagement.update(request, "nextPage", "welcome");
			SessionManagement.update(request, "OTP", otp);
			SessionManagement.update(request, "OTP_TimeStamp", ((Long)System.currentTimeMillis()).toString());
			System.out.println(SessionManagement.check(request, "OTP_TimeStamp"));
		} else {
			mav = new ModelAndView("login");
			mav.addObject("error", "Username or Password is wrong!!");
		}
		return mav;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}

	@RequestMapping(value = "/adduser", method = RequestMethod.POST)
	public ModelAndView adduser(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute("adduser") User adduser) {
		try
		{
		System.out.println("Inside add user controller");
		ModelAndView mav = null;
	    String ans=userService.register(adduser);
	    mav = new ModelAndView("login");
	    mav.addObject("message",ans);
	    return mav;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}
	

	@RequestMapping(value = "/unlockuser", method = RequestMethod.POST)
	public ModelAndView unlockuser(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute("adduser") User user) {
		try
		{
		// System.out.println("Inside add user controller");
		ModelAndView mav = null;
	    String ans=userService.unlock(user);
	    mav = new ModelAndView("lockeduser");
	    mav.addObject("message",ans);
	    return mav;
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}
	
	
	

	@RequestMapping(value = "/adduser_admin", method = RequestMethod.POST)
	public ModelAndView adduser_admin(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute("adduser") User adduser) {
		try
		{
		System.out.println("Inside add user controller");
		ModelAndView mav = null;
	    String ans=userService.register_internal(adduser);
	    mav = new ModelAndView("adduser_Admin");
	    mav.addObject("message",ans);
	    return mav;
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}
	
	@RequestMapping(value = "/changepasswordpage", method = RequestMethod.GET)
	public ModelAndView initiatechangepassword(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("changepassword");
		return mav;
	}
	
	@RequestMapping(value = "/changepassword", method = RequestMethod.POST)
	public ModelAndView changepassword(HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute("changepassword") User user) {
		try
		{
		System.out.println("Inside change password section ( controller) ");
		ModelAndView mav = null;
	    mav = new ModelAndView("otp");
	    String pass = "";
	    synchronized(MutexLock.getUsersTableMutex())
		{
	    	pass = (String)template.getJdbcTemplate().queryForList("select * from users where user_id="+SessionManagement.check(request, "user_id")).get(0).get("password");
		}
	    if(!GetHash.encrypt(user.getPassword()).equals(pass)){
	    	Login login = new Login();
	    	synchronized(MutexLock.getUsersTableMutex())
			{
		  		login.setUsername((String)template.getJdbcTemplate().queryForList("select * from users where user_id="+SessionManagement.check(request, "user_id")).get(0).get("username"));
		  		login.setPassword((String)template.getJdbcTemplate().queryForList("select * from users where user_id="+SessionManagement.check(request, "user_id")).get(0).get("password"));
			}
	  		
	  		if(userService.validateUser(login)==null){
	  			mav = new ModelAndView("changepassword");
	  			int user_status = 0;
	  			synchronized(MutexLock.getUsersTableMutex())
				{
	  				user_status = (Integer)template.getJdbcTemplate().queryForList("select * from users where user_id="+SessionManagement.check(request, "user_id")).get(0).get("user_status");
				}
		    	if(user_status==4){
		    		mav = new ModelAndView("login");
		    		mav.addObject("error", "Your account has been Locked because of multiple failed password change attempts. Contact the GoSwiss technical support for assistance.");
		    		return mav;
		    	}
	  			mav.addObject("message", "Old Password is incorrect!");
		    	return mav;
	  		}
	    }

	    EmailOTPSender sender = EmailOTPSender.getEmailOTPSender();
		String otp = sender.generateOTP();
		synchronized(MutexLock.getUsersTableMutex())
		{
			sender.sendMail("GoSwiss OTP", "Your OTP for changing password is = "+otp,(String) template.getJdbcTemplate().queryForList("select * from users where user_id="+SessionManagement.check(request, "user_id")).get(0).get("email"));
		}
	    //Update Session
		SessionManagement.update(request, "password", user.getPassword());
		SessionManagement.update(request, "new_password", user.getNewpassword());
		SessionManagement.update(request, "re_new_password", user.getReenter_newpassword());
		SessionManagement.update(request, "Q1",user.getQ1());
		SessionManagement.update(request, "Q2",user.getQ2());
		SessionManagement.update(request, "Q3",user.getQ3());
		SessionManagement.update(request, "Q4",user.getQ4());
		SessionManagement.update(request, "Q5",user.getQ5());
		SessionManagement.update(request, "Q6",user.getQ6());
		SessionManagement.update(request, "OTP", otp);
		SessionManagement.update(request, "OTP_TimeStamp", ((Long)System.currentTimeMillis()).toString());
	    return mav;
		}
		catch(Exception e)
		{
			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	}

	

	@RequestMapping(value = "/edituser", method = RequestMethod.POST)
	  public ModelAndView edituser(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("edituser") User edituser) 
	  {
      try {
	    ModelAndView mav = null;
	   System.out.println("temp.....");
	    // edituser.setUsername(request.getParameter("username"));
	    edituser.setUsername(SessionManagement.check(request, "EdituserName"));
	    
	    //ResultSet rs = DBConnector.getQueryResult("select * from users where email='"+edituser.getEmail()+"'");
	    PreparedStatement st = DBConnector.getConnection().prepareStatement("select * from users where email=? and username<>?");
	    st.setString(1, edituser.getEmail());
	    st.setString(2, edituser.getUsername());
	    ResultSet rs = null;
	    synchronized(MutexLock.getUsersTableMutex()) {
	    	rs = st.executeQuery();
	    }
	    
	    if(rs.next()) {
	    	if(SessionManagement.check(request,"user_role").equals("1")) {
	    		mav = new ModelAndView("Welcome_Tier1");
	    	}
	    	else if(SessionManagement.check(request,"user_role").equals("2")) {
	    		mav = new ModelAndView("Welcome_Tier2");
	    	}
	    	else if(SessionManagement.check(request,"user_role").equals("3")) {
	    		mav = new ModelAndView("Welcome_Admin");
	    	}
	    	else {
	    		mav = new ModelAndView("Welcome_External");
	    	}
	    	mav.addObject("message","Edit Unsuccessful! Please try again as a user with the same email already exists!");
	    	return mav;
	    }
	    
	    String updateSql = "SET SQL_SAFE_UPDATES = 0";  template.getJdbcTemplate().update(updateSql); 
	     Object[] params1;
	     int[] types1;
	    String updateSql1;
	    if(SessionManagement.check(request, "user_role").equals("1") || SessionManagement.check(request, "user_role").equals("2")) {
	    	updateSql1 =  "UPDATE users SET firstname= ? , lastname= ?, address = ? , phone = ?  where username = ?";
    	    params1 = new Object[] { edituser.getFirstname(), edituser.getLastname(), edituser.getAddress(), edituser.getPhone(), edituser.getUsername() };
 	        types1 = new int[] { Types.VARCHAR, Types.VARCHAR , Types.VARCHAR, Types.BIGINT, Types.VARCHAR};
	    }
	    else {
    	    if(edituser.getRole()!=0) {
    	    	updateSql1 =  "UPDATE users SET firstname= ? , lastname= ?, address = ? , phone = ?, email=?, role_id=?  where username = ?";
    	    	params1 = new Object[] {edituser.getFirstname(), edituser.getLastname(), edituser.getAddress(), edituser.getPhone(), edituser.getEmail(),edituser.getRole(),edituser.getUsername() };
 	        	types1 = new int[] { Types.VARCHAR, Types.VARCHAR , Types.VARCHAR, Types.BIGINT, Types.VARCHAR, Types.INTEGER, Types.VARCHAR};
    	    }
    	    else {
    	    	updateSql1 =  "UPDATE users SET firstname= ? , lastname= ?, address = ? , phone = ?, email=?  where username = ?";
    	    	params1 = new Object[] {edituser.getFirstname(), edituser.getLastname(), edituser.getAddress(), edituser.getPhone(), edituser.getEmail(),edituser.getUsername() };
 	        	types1 = new int[] { Types.VARCHAR, Types.VARCHAR , Types.VARCHAR, Types.BIGINT, Types.VARCHAR, Types.VARCHAR};
    	    }
	    }
	    synchronized(MutexLock.getUsersTableMutex())
		{
	    	template.getJdbcTemplate().update(updateSql1,params1,types1);
		}
	    
	    //String ans=userService.edit(edituser);
	    System.out.println("Updated successfully.");
	   
	    mav = new ModelAndView("edit_success");
		    mav.addObject("username",edituser.getUsername());
		    mav.addObject("firstname",edituser.getFirstname());
		    mav.addObject("lastname",edituser.getLastname());
		    mav.addObject("email",edituser.getEmail());
		    mav.addObject("address",edituser.getAddress());
		    mav.addObject("phone",edituser.getPhone());
		    mav.addObject("roles",edituser.getRole());
		    return mav;
      }
  	catch(Exception e)
		{
			e.printStackTrace();
  			ModelAndView mav = null;
			mav = new ModelAndView("error");
			return mav;
		}
	  }
	
	@RequestMapping(value = "/TransactPage", method = RequestMethod.GET)
	public ModelAndView transactPage(HttpServletRequest request, HttpServletResponse response) {
		String account_id = request.getParameter("Transact");
		ModelAndView mav = null;
		try {
			if(account_id==null || account_id.equals("") || account_id.equals("null")) {
				mav = new ModelAndView("AuthError");
				return mav;
			}
			SessionManagement.update(request, "account_id", account_id);
			mav = new ModelAndView("Transaction");
			return mav;
		}
		catch(Exception e) {
			mav = new ModelAndView("error");
			return mav;
		}
	}
	
	@RequestMapping(value = "/debitCredit", method = RequestMethod.GET)
    public ModelAndView debitCredit(HttpServletRequest request, HttpServletResponse response){
        try
        {
            ModelAndView mav = null;
	    mav = new ModelAndView("Transaction");
            int amount = 0;
            try{
                amount = Integer.parseInt(request.getParameter("amount"));
            }catch(NumberFormatException ne)
            {
                mav.addObject("error","Amount is invalid!");
                return mav;
            }
            int account_id = Integer.parseInt(SessionManagement.check(request,"account_id"));
            if(amount<=0) {
            	mav.addObject("error","Amount cannot be zero or less than zero");
            }
            else if (request.getParameter("action").equals("debit"))
            {
                String query = "insert into bank.transactions (accountTo, amount, type_id, status_id) value(" + account_id + "," + amount + ",2,3);";
                Statement st = (Statement)DBConnector.getConnection().createStatement();
                int result = st.executeUpdate(query);
                if(result == 1)  mav.addObject("message","Debit $" + amount + " request Sent");
                else    mav.addObject("error","execute sql query failed!");
            }
            else if (request.getParameter("action").equals("credit"))
            {
                String query = "insert into bank.transactions (accountTo, amount, type_id, status_id) value(" + account_id + "," + amount + ",1,3);";
                Statement st = (Statement)DBConnector.getConnection().createStatement();
                int result = st.executeUpdate(query);
                if(result == 1)  mav.addObject("message","Credit $" + amount + " request Sent"); 
                else    mav.addObject("error","execute sql query failed!"); 
            }
	    return mav;
	}
	catch(Exception e)
	{
            System.out.println(e);
			ModelAndView mav = null;
            mav = new ModelAndView("error");
            return mav;
	}
    }
    
    @RequestMapping(value = "/transfer", method = RequestMethod.GET)
    public ModelAndView transfer(HttpServletRequest request, HttpServletResponse response){
        try
        {
            ModelAndView mav = null;
	    mav = new ModelAndView("Transaction");
            int amount = Integer.parseInt(request.getParameter("amount"));
            String receiver = request.getParameter("receiver");
            int account_id = Integer.parseInt(SessionManagement.check(request,"account_id"));
            int user_id = Integer.parseInt(SessionManagement.check(request,"user_id"));
            if(amount<=0) {
            	mav.addObject("error","Amount cannot be zero or less than zero");
            }
            else if (request.getParameter("way").equals("account"))
            {
                int receiver_id = Integer.parseInt(receiver);
                ResultSet rs = DBConnector.getQueryResult("select * from account where account_id="+receiver_id);
                if(!rs.next())
                {
                    mav.addObject("message1", "The account number does not exist!");
                    return mav;
                }
                int receiver_userid = (Integer) rs.getObject("user_id");
                String query = "";
                if (user_id == receiver_userid) query = "insert into bank.transactions (accountFrom, accountTo, amount, type_id, status_id) value(" + account_id + "," + receiver_id + "," + amount + ",3,3);";
                else query = "insert into bank.transactions (accountFrom, accountTo, amount, type_id, status_id) value(" + account_id + "," + receiver_id + "," + amount + ",3,2);";
                Statement st = (Statement)DBConnector.getConnection().createStatement();
                int result = st.executeUpdate(query);
                if(result == 1) mav.addObject("message1","Transfer $" + amount + " to account "+ receiver +" request Sent");  
                else    mav.addObject("message1", "execute sql query failed!");    
            }
            else if (request.getParameter("way").equals("email"))
            {
                ResultSet rs = DBConnector.getQueryResult("select * from users where email like '%" + receiver + "%'");
                if(!rs.next())
                {
                    mav.addObject("message1", "The email address does not exist!");
                    return mav;
                }
                int receiver_userid = (Integer) rs.getObject("user_id");
                String query = "insert into bank.transactions (accountFrom, amount, receiver_id, type_id, status_id) value(" + account_id + "," + amount + "," + receiver_userid + ",3,1);";
                Statement st = (Statement)DBConnector.getConnection().createStatement();
                int result = st.executeUpdate(query);
                if(result == 1) mav.addObject("message1","Transfer $" + amount + " to email "+ receiver +" request Sent"); 
                else    mav.addObject("message1", "execute sql query failed!");
            }
	    return mav;
	}
	catch(Exception e)
	{
            ModelAndView mav = null;
            mav = new ModelAndView("error");
            return mav;
	}
    }
    
    @RequestMapping(value = "/viewCreditFunctions", method = RequestMethod.GET)
    public ModelAndView ModelAndView(HttpServletRequest request, HttpServletResponse response) {
    	try {
    		ModelAndView mav = new ModelAndView("CreditAccountFunctions");
    		ResultSet rs = DBConnector.getQueryResult("select * from account where type_id=3 and account_status=1 and user_id="+SessionManagement.check(request, "user_id"));
    		if(!rs.next() && SessionManagement.check(request, "user_role").equals("4")) {
    			mav = new ModelAndView("AuthError");
    			return mav;
    		}
    		if(SessionManagement.check(request, "user_role").equals("4")) {
    			SessionManagement.update(request, "account_id", rs.getString(1));
    		}
    		else {
    			SessionManagement.update(request, "account_id", "-1");
    		}
    		return mav;
    	}
    	catch(Exception e) {
    		System.out.println(e);
    		 ModelAndView mav = new ModelAndView("error");
             return mav;
    	}
    }
    
    @RequestMapping(value = "/makeCreditCardPayment", method = RequestMethod.GET)
    public ModelAndView makeCreditCardPayment(HttpServletRequest request, HttpServletResponse response) {
    	ModelAndView mav = new ModelAndView("CreditAccountFunctions");
    	try {
    		int amount = Integer.parseInt(request.getParameter("amount"));
    		if(amount<=0) {
    			mav.addObject("error", "Amount cannot be zero or negative");
    			return mav;
    		}
    		int debitaccountID = Integer.parseInt(request.getParameter("AccountNo"));
    		int creditaccountID = Integer.parseInt(SessionManagement.check(request,"account_id"));
    		
    		PreparedStatement st = DBConnector.getConnection().prepareStatement("insert into transactions (accountFrom,accountTo,amount,type_id,status_id) values(?,?,?,5,9)");
    		st.setInt(1, debitaccountID);
    		st.setInt(2, creditaccountID);
    		st.setInt(3, amount);
    		
    		synchronized(MutexLock.getTransactionTableMutex()) {
    			st.executeUpdate();
    		}
    		mav.addObject("message", "Payment of $"+amount+" has been submitted");
    		return mav;
    	}
    	catch(Exception e) {
    		System.out.println(e);
   		 	mav = new ModelAndView("error");
            return mav;
    	}
    }
    
    @RequestMapping(value = "/availCreditCardPayment", method = RequestMethod.GET)
    public ModelAndView availCreditPayment(HttpServletRequest request, HttpServletResponse response) {
    	ModelAndView mav = new ModelAndView("CreditAccountFunctions");
    	try {
    		int amount = Integer.parseInt(request.getParameter("amount"));
    		if(amount<=0) {
    			mav.addObject("error", "Amount cannot be zero or negative");
    			return mav;
    		}
    		int debitaccountID = Integer.parseInt(request.getParameter("AccountNo"));
    		
    		int card_no = Integer.parseInt(request.getParameter("card_no"));
    		int cvv = Integer.parseInt(request.getParameter("cvv"));
    		long issue_time = Long.parseLong(request.getParameter("date"));
    		
    		PreparedStatement st = DBConnector.getConnection().prepareStatement("select * from credit_card where card_id=? and cvv=? and exp_date=?");
    		st.setInt(1, card_no);
    		st.setInt(2, cvv);
    		st.setLong(3, issue_time);
    		
    		ResultSet rs = st.executeQuery();
    		if(!rs.next()) {
    			mav.addObject("error","Invalid card details");
    			return mav;
    		}
    		
    		int creditaccountID = rs.getInt(5);
    		
    		st = DBConnector.getConnection().prepareStatement("insert into transactions (accountFrom,accountTo,amount,type_id,status_id) values(?,?,?,5,8)");
    		st.setInt(1, creditaccountID);
    		st.setInt(2, debitaccountID);
    		st.setInt(3, amount);
    		
    		synchronized(MutexLock.getTransactionTableMutex()) {
    			st.executeUpdate();
    		}
    		mav.addObject("error", "A payment of $"+amount+" has been requested");
    		return mav;
    	}
    	catch(Exception e) {
    		System.out.println(e);
   		 	mav = new ModelAndView("error");
            return mav;
    	}
    }
      
}
