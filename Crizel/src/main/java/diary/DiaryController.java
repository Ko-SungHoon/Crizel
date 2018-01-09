package diary;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DiaryController {
	DiaryService service;

	@Autowired
	public DiaryController(DiaryService service) {
		super();
		this.service = service;
	}

	@RequestMapping("diary.do")
	public ModelAndView diary(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		String year = parseNull(request.getParameter("year"));
		String month = parseNull(request.getParameter("month"));
		String dayChange = parseNull(request.getParameter("dayChange"));		
		HashMap<String, Object> map = service.calendar(year,month, dayChange);
		List<Object> useDay = service.useDay(year, month, dayChange);
		
		mav.addObject("useDay", useDay);
		mav.addObject("cal", map);
		mav.setViewName("/diary/main");
		return mav;

	}
	
	
	@RequestMapping("diaryContent.do")
	public ModelAndView diaryContent(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		String day = parseNull(request.getParameter("day"));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date day1 = null;
		String day2 = "";
		try{
			day1 = sdf.parse(day);
			day2 = sdf.format(day1);
		}catch(ParseException e){
			e.printStackTrace();
		}
		day = day2;
		
		DiaryVO content = service.content(day);
		
		mav.addObject("day", day);
		mav.addObject("content", content);
		mav.setViewName("/diary/content");
		return mav;

	}
	
	
	@RequestMapping("diaryInsertPage.do")
	public ModelAndView diaryInsertPage(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		String day = parseNull(request.getParameter("day"));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date day1 = null;
		String day2 = "";
		try{
			day1 = sdf.parse(day);
			day2 = sdf.format(day1);
		}catch(ParseException e){
			e.printStackTrace();
		}
		day = day2;
		DiaryVO content = service.content(day);
		mav.addObject("day", day);
		mav.addObject("content", content);
		mav.setViewName("/diary/diaryInsertPage");
		return mav;

	}
	
	@RequestMapping("diaryInsert.do")
	public String diaryInsert(@ModelAttribute DiaryVO vo, HttpServletRequest request, HttpServletResponse response) {
		service.diaryInsert(vo);
		return "redirect:diary.do";
	}
	
	@RequestMapping("diaryDelete.do")
	public String diaryDelete(@ModelAttribute DiaryVO vo, HttpServletRequest request, HttpServletResponse response) {
		service.diaryDelete(vo);
		return "redirect:diary.do";
	}
	
	@RequestMapping("diaryUpdate.do")
	public String diaryUpdate(@ModelAttribute DiaryVO vo, HttpServletRequest request, HttpServletResponse response) {
		service.diaryUpdate(vo);
		return "redirect:diary.do";
	}
	
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
}
