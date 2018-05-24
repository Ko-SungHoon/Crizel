package com.crizel.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crizel.admin.AdminService;
import com.crizel.girls.GirlsService;
import com.crizel.girls.GirlsVO;

@Controller
public class GirlsController {
	@Resource(name="girlsService")
    private GirlsService service;

	@RequestMapping("girls.do")
	public ModelAndView girls(
			@RequestParam(value="name", required=false, defaultValue="") String name,
			HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		List<Object> nameList = service.nameList();
		List<Object> girlsList = null;
		
		if(!"".equals(name)){
			girlsList = service.girlsImg(name);
			mav.addObject("girlsList", girlsList);
		}
		mav.addObject("name", name);
		mav.addObject("nameList", nameList);
		mav.setViewName("/girls/main");
		return mav;

	}
	
	@RequestMapping("girlsDownload.do")
	public void girlsDownload(
			@RequestParam(value="url", required=false) String url,
			@RequestParam(value="name", required=false) String name,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		service.girlsDownload(url, name, response);
	}
	
	@RequestMapping("girlsInsertPage.do")
	public ModelAndView girlsInsertPage(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		List<Object> nameList = service.nameList();
		mav.addObject("nameList", nameList);
		mav.setViewName("/girls/girlsInsertPage");
		return mav;

	}
	
	@RequestMapping("girlsInsert.do")
	public String girlsInsert(@ModelAttribute GirlsVO vo) {
		service.girlsInsert(vo);
		return "redirect:girls.do";

	}

	@RequestMapping("girlsDelete.do")
	public String girlsDelete(@ModelAttribute GirlsVO vo) {
		service.girlsDelete(vo);
		return "redirect:girlsInsertPage.do";

	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
}
