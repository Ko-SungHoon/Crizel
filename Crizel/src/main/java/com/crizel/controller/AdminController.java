package com.crizel.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crizel.admin.AdminService;
import com.crizel.admin.AdminVO;

@Controller
public class AdminController {
	@Resource(name="adminService")
    private AdminService service;

	@RequestMapping("admin")
	public ModelAndView admin() {
		ModelAndView mav = new ModelAndView();
		List<AdminVO> menuList = service.menuList();
		
		mav.addObject("menuList", menuList);
		mav.setViewName("/admin/main");
		return mav;
	}
	
	
	@RequestMapping("menuInsertPage")
	public ModelAndView menuInsertPage(@RequestParam(value="menu_level", defaultValue="") String menu_level) {
		ModelAndView mav = new ModelAndView();
		List<AdminVO> menuList = service.menuList();
		mav.addObject("menuList", menuList);
		mav.setViewName("/admin/menuInsertPage");
		return mav;
	}
}
