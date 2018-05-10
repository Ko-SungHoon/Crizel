package com.crizel.controller;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crizel.money.MoneyService;
import com.crizel.money.MoneyVO;
import com.ibm.icu.util.Calendar;

@Controller
public class MoneyController {
	MoneyService service;
	MoneyVO MoneyVO;

	@Autowired
	public MoneyController(MoneyService service) {
		super();
		this.service = service;
	}
	
	@RequestMapping("/money")
	public ModelAndView money( @RequestParam(value="year", defaultValue="") String year
							, @RequestParam(value="month", defaultValue="") String month) {
		ModelAndView mav = new ModelAndView();
		
		Calendar cal = Calendar.getInstance();
		
		if("".equals(year)){year = Integer.toString(cal.get(Calendar.YEAR));}
		if("".equals(month)){month = Integer.toString(cal.get(Calendar.MONTH)+1);}
		
		mav.addObject("year", year);
		mav.addObject("month", month);
		
		mav.setViewName("/money/main");
		return mav;
	}
	
	@RequestMapping("/moneyCalendar")
	public void moneyCalendar( @RequestParam(value="year", defaultValue="") String year
							,  @RequestParam(value="month", defaultValue="") String month
							, HttpServletResponse response) throws IOException {
		String calendar = service.calendar(year, month);
		
		response.setContentType("application/x-www-form-urlencoded; charset=UTF-8");
		response.getWriter().print(calendar);
	}
	
	@RequestMapping("/moneyView")
	public ModelAndView moneyView( 	@RequestParam(value="day", defaultValue="") String day) {
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("day", day);
		mav.addObject("moneyView", service.moneyView(day));
		
		mav.setViewName("/money/view");
		return mav;
	}
	
	@RequestMapping("/moneyInsert")
	public void moneyInsert(@ModelAttribute MoneyVO vo, HttpServletResponse response) throws IOException {
		service.moneyInsert(vo);
		response.sendRedirect("/moneyView.do?day="+vo.getDay());
	}
	
	@RequestMapping("/moneyDelete")
	public void moneyDelete(@RequestParam(value="money_id", defaultValue="") String money_id
			, @RequestParam(value="day", defaultValue="") String day
			, HttpServletResponse response) throws IOException {
		service.moneyDelete(money_id);
		response.sendRedirect("/moneyView.do?day="+day);
	}
}
