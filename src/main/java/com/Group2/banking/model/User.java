package com.group2.banking.model;

public class User {
	  private String firstname;
	  private String lastname;
	  private String username;
	  private String password;
	  private String reentered_password;
	  private String email;
	  private String address;
	  private long phone;
	  private int no_of_failed_attempts;
	  private int status;
	  private String role_id;
	  private String question1;
	  private String question2;
	  private String question3;
	  private String question4;
	  private String question5;
	  private String question6;
	  private String newpassword;
	  private String reenter_newpassword;
	  
	  public String getNewpassword() {
			return newpassword;
		}
		public void setNewpassword(String newpassword) {
			this.newpassword = newpassword;
		}
		public String getReenter_newpassword() {
			return reenter_newpassword;
		}
		public void setReenter_newpassword(String reenter_newpassword) {
			this.reenter_newpassword = reenter_newpassword;
		}
	  
	  public int getno_of_failed_attempts() {
			return no_of_failed_attempts;
		}
		public void setno_of_failed_attempts(int attempt) {
			this.no_of_failed_attempts = attempt;
		}
		
		
		  public int getstatus() {
				return status;
			}
			public void setstatus(int status) {
				this.status = status;
			}
		

		
	public String getFirstname() {
		return firstname;
	}
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	public String getLastname() {
		return lastname;
	}
	public void setLastname(String lastname) {
		this.lastname = lastname;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getReentered_password() {
		return reentered_password;
	}
	public void setReentered_password(String reentered_password) {
		this.reentered_password = reentered_password;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public long getPhone() {
		return this.phone;
	}
	public void setPhone(Long phone) {
		this.phone = phone;
	}
	public int getRole() {
		if(role_id==null || role_id.equals("") || role_id.equals("null")) return 0;
		return Integer.parseInt(role_id);
	}
	public void setRole(String role) {
		this.role_id = role;
	}
	
	public void setQ1(String question1) {
		this.question1 = question1;
	}
	public void setQ2(String question2) {
		this.question2 = question2;
	}
	public void setQ3(String question3) {
		this.question3 = question3;
	}
	public void setQ4(String question4) {
		this.question4 = question4;
	}
	public void setQ5(String question5) {
		this.question5 = question5;
	}
	public void setQ6(String question6) {
		this.question6 = question6;
	}
	public String getQ1() {
		return this.question1;
	}
	public String getQ2() {
		return this.question2;
	}
	public String getQ3() {
		return this.question3;
	}
	public String getQ4() {
		return this.question4;
	}
	public String getQ5() {
		return this.question5;
	}
	public String getQ6() {
		return this.question6;
	}
	}
