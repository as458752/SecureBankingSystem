package com.group2.banking.service;

public class MutexLock {
	static Integer users = 1;
	static Integer user_ques_mapping = 1;
	static Integer accounts = 1;
	static Integer edituseraccountapprovals = 1;
	static Integer credit_card = 1;
	static Integer transactions = 1;
	
	public static Integer getUsersTableMutex() {
		return MutexLock.users;
	}
	
	public static Integer getUserQuesMappingTableMutex() {
		return MutexLock.user_ques_mapping;
	}
	
	public static Integer getAccountsTableMutex() {
		return MutexLock.accounts;
	}
	
	public static Integer getEdituseraccountapprovals() {
		return MutexLock.edituseraccountapprovals;
	}
	
	public static Integer getCreditCardTableMutex() {
		return MutexLock.credit_card;
	}
	
	public static Integer getTransactionTableMutex() {
		return MutexLock.transactions;
	}

}
