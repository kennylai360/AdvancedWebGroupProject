package com.surrey.com3014.group10.controllers;
import com.surrey.com3014.group10.User.model.User;
import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class IndexController {

    @RequestMapping( value ="/contact" , method = RequestMethod.GET)
    public String contact(ModelMap model) {
        model.addAttribute("user", getPrincipal());
        return "contact";
    }

    @RequestMapping(value ="/about", method = RequestMethod.GET)
    public String about(ModelMap model) {
        model.addAttribute("user", getPrincipal());
        return "about";
    }

    private String getPrincipal(){
        String userName = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            userName = ((UserDetails)principal).getUsername();
        } else {
            userName = principal.toString();
        }
        return userName;
    }







}
