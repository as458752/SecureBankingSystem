package com.group2.banking.service;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class GetHash {
	public static final String KEY = "my-key-text";
	  
	public static String encrypt(String input) {
	  
	  String keyPassword = KEY + input;
	  StringBuilder hashedPassword = new StringBuilder();

		try {
			MessageDigest sha = MessageDigest.getInstance("SHA-1");
			byte[] getBytes = sha.digest(keyPassword.getBytes());
			char[] digits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
					'a', 'b', 'c', 'd', 'e', 'f' };
			for (int i = 0; i < getBytes.length; ++i) {
				byte b = getBytes[i];
				hashedPassword.append(digits[(b & 0xf0) >> 4]);
				hashedPassword.append(digits[b & 0x0f]);
			}
		} catch (NoSuchAlgorithmException e) {
			// handle error here.
		}

		return hashedPassword.toString();
	}
	  

}
