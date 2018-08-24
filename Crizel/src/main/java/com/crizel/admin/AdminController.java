package com.crizel.admin;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdminController {
	@Autowired
	private AdminService adminService;

	@RequestMapping("/admin/main")
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response, HttpSession session, AdminVO adminVO) {
		ModelAndView mav = new ModelAndView();
		List<AdminVO> menuList = adminService.menuList();
		
		mav.addObject("menuList", menuList);
		mav.setViewName("/admin/main");
		return mav;
	}
	
	@RequestMapping("/admin/menuInsertPage")
	public ModelAndView menuInsertPage(HttpServletRequest request, HttpServletResponse response, HttpSession session, AdminVO adminVO) {
		ModelAndView mav = new ModelAndView();
		List<AdminVO> menuList = adminService.menuList();
		mav.addObject("menuList", menuList);
		mav.setViewName("/admin/menuInsertPage");
		return mav;
	}
}
