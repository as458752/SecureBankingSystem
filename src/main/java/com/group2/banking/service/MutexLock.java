package com.group2.banking.service;

public class MutexLock {
	private static Integer read_write_lock = 1;
        public static Integer getLock(){
            return MutexLock.read_write_lock;
        }

}
