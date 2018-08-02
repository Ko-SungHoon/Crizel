package com.crizel.nyaa;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class NyaaController {
	NyaaService service;

	@Autowired
	public NyaaController(NyaaService service) {
		super();
		this.service = service;
	}

	@RequestMapping("nyaa.do")
	public ModelAndView wiki(
			@RequestParam(value="type", required=false, defaultValue="1_4") String type,
			@RequestParam(value="keyword", required=false, defaultValue="") String keyword) throws Exception {
		ModelAndView mav = new ModelAndView();	
		List<Map<String,Object>> nyaaList = service.nyaaList(type, keyword);
		mav.addObject("nyaaList", nyaaList);
		mav.addObject("type", type);
		mav.addObject("keyword", keyword);
		mav.setViewName("/nyaa/main");
		return mav;
	}
}
