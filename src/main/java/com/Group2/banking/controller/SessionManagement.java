/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.Group2.banking.controller;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
/**
 *
 * @author Jing
 */
public class SessionManagement {
    public static void update(HttpServletRequest request, String userId)
    {
        HttpSession session = request.getSession();
	session.removeAttribute("userId");
        session.setAttribute("userId", userId);
	//setting session to expiry in 3 mins
	session.setMaxInactiveInterval(3*60);
    }
    public static String check(HttpServletRequest request)
    {
        HttpSession session = request.getSession();
        Object obj = session.getAttribute("userId");
        if (obj == null)    return "";
        else    return obj.toString();
    }
}
