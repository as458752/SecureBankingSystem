package com.group2.banking.service;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.*;

import java.util.*;

public class EmailOTPSender {
	private Session session;
	private static EmailOTPSender emailOTPSender = null;
	
	public static EmailOTPSender getEmailOTPSender(){
		if(emailOTPSender==null){
			emailOTPSender = new EmailOTPSender();
		}
		return emailOTPSender;
	}
	
	private EmailOTPSender(){
		this("noreply.group2@gmail.com","softsec123");
	}
	
	private EmailOTPSender(String userName, String Password){
		Properties props = System.getProperties();
		props.put("mail.smtp.starttls.enable","true" );
        props.put("mail.smtp.host","smtp.gmail.com");
        props.put("mail.smtp.auth", "true" );
        props.put("mail.smtp.port", "587");
        final String username = userName;
        final String password = Password;
        Authenticator auth = new Authenticator() {
        	protected PasswordAuthentication getPasswordAuthentication() {
        		return new PasswordAuthentication(username, password);
		}};
        session = Session.getInstance(props, auth);
	}
	
	public String generateOTP()
    {
		String numbers = "0123456789";
		Random rndm_method = new Random();
 
        String otp = "";
 
        for (int i = 0; i < 6; i++) otp+= rndm_method.nextInt(numbers.length());
        return otp;
    }
	
	public synchronized void sendMail(String subject, String text, String address)
    {
        try
        {
            Message msg = new MimeMessage(session);
            
            InternetAddress[] receivers;
            receivers = new InternetAddress[1];
            receivers[0] = new InternetAddress(address);
            msg.setRecipients(Message.RecipientType.TO, receivers);
            
            msg.setSubject(subject);
            msg.setText(text);
            Transport.send(msg);
            System.out.println("Message sent to");
            for(InternetAddress ad: receivers)
            {
                System.out.println(ad.toUnicodeString());
            }
            System.out.println("Successfully");
        }
        catch (Exception ex)
        {
          System.out.println("Exception: "+ ex);
        }
    }
}
