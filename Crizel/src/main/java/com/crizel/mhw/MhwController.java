package com.crizel.mhw;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MhwController {
	@Autowired
	MhwService mhwService;
	
	@RequestMapping("/mhw/main")
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response, HttpSession session, MhwVO vo){
		ModelAndView mav = new ModelAndView();
		
		List<MhwVO> monster_1 = mhwService.monsterList("M_1");
		List<MhwVO> monster_2 = mhwService.monsterList("M_2");
		List<MhwVO> monster_3 = mhwService.monsterList("M_3");
		
		mav.addObject("monster_1", monster_1);
		mav.addObject("monster_2", monster_2);
		mav.addObject("monster_3", monster_3);
		mav.setViewName("/mhw/main");
		
		return mav;
	}
}
