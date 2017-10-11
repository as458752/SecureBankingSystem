package com.Group2.banking.controller;

import javax.servlet.http.HttpServletRequest;
import com.Group2.banking.service.*;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.Session;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.Group2.banking.service.UserService;
import com.Group2.banking.model.*;

@Controller
public class BaseController {
  @Autowired
  private UserService userService;
  @Autowired
  private AddUserService adduserservice;
  
  /*  @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView showLogin(HttpServletRequest request, HttpServletResponse response) {
    ModelAndView mav = new ModelAndView("login");
    mav.addObject("login", new Login());
    return mav;
  } */
  
  @RequestMapping(value = "/loginProcess", method = RequestMethod.POST)
  public ModelAndView loginProcess(HttpServletRequest request, HttpServletResponse response,
  @ModelAttribute("login") Login login) 
  {
    ModelAndView mav = null;
    User user = userService.validateUser(login);
    if (null != user) {
    mav = new ModelAndView("welcome");
    mav.addObject("firstname", user.getFirstname());
    } else {
    mav = new ModelAndView("login");
    mav.addObject("error", "Username or Password is wrong!!");
    }
    return mav;
  }
  
  @RequestMapping(value = "/adduser", method = RequestMethod.POST)
  public ModelAndView adduser(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("adduser") AddUser adduser) 
  {
    ModelAndView mav = null;
    String ans=adduserservice.register(adduser);
     mav = new ModelAndView("adduser");
    // mav.addObject("message1",adduser.getPassword()+" "+adduser.getEmail()+" "+adduser.getAddress()+" "+adduser.getPhone()+" "+adduser.getUsername()+"  "+adduser.getFirstname()+" "+adduser.getLastname());
     mav.addObject("message3",ans);
    return mav;
  }
  
  @RequestMapping(value = "/edituser", method = RequestMethod.POST)
  public ModelAndView edituser(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("adduser") AddUser adduser) 
  {
    ModelAndView mav = null;
    String ans=adduserservice.edit(adduser);
    mav = new ModelAndView("Edituser");
    // mav.addObject("message1",adduser.getPassword()+" "+adduser.getEmail()+" "+adduser.getAddress()+" "+adduser.getPhone()+" "+adduser.getUsername()+"  "+adduser.getFirstname()+" "+adduser.getLastname());
   mav.addObject("message3",ans);
    return mav;
  }
}