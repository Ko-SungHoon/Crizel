package controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;

import model.CrizelService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.xml.sax.SAXException;

import vo.CrizelVo;

@Controller
public class CrizelController {
	CrizelService service;

	@Autowired
	public CrizelController(CrizelService service) {
		super();
		this.service = service;
	}
	@RequestMapping("list.do")
	public ModelAndView list(@RequestParam String day) {
		ModelAndView mav = new ModelAndView();		
		Calendar cal = Calendar.getInstance();
		final String[] week = { "일", "월", "화", "수", "목", "금", "토" };
		if (day.equals("today")) {
			day = week[cal.get(Calendar.DAY_OF_WEEK) - 1];
		}
		mav.addObject("list",service.list(day));
		mav.addObject("day",day);
		mav.setViewName("/list/list");
		return mav;

	}

	@RequestMapping("listDetail.do")
	public ModelAndView listDetail(@RequestParam String keyword, String type,
			HttpServletResponse response) throws ParserConfigurationException,
			SAXException, IOException {
		ModelAndView mav = new ModelAndView();
		mav.addObject("listDetail",service.listDetail(keyword,type));
		mav.setViewName("/list/list");
		return mav;

	}
	
	@RequestMapping("aniDelete.do")
	public String aniDelete(@ModelAttribute CrizelVo vo){
		service.aniDelete(vo);
		return "redirect:list.do?day=today";
	}

		
	@RequestMapping("listInsertPage.do")
	public ModelAndView listInsertPage() {
		ModelAndView mav = new ModelAndView();		
		mav.setViewName("/list/listInsertPage");
		return mav;
	}
	
	@RequestMapping("listInsert.do")
	public String listInsert(@ModelAttribute CrizelVo vo) throws UnsupportedEncodingException {
		service.listInsert(vo);
		return "redirect:listInsertPage.do?day="+URLEncoder.encode(vo.getDay(), "UTF-8");
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("login.do")
	public void login(@ModelAttribute CrizelVo vo, HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		CrizelVo vo2 = service.login(vo);
		JSONObject obj = new JSONObject();
		if (vo2 != null) {
			HttpSession session = request.getSession();
			session.setAttribute("login", vo2);

			obj.put("result", "success");
			response.setContentType("application/x-json; charset=UTF-8");
			response.getWriter().print(obj);
		} else {
			obj.put("result", "fail");
			response.setContentType("application/x-json; charset=UTF-8");
			response.getWriter().print(obj);
		}
	}

	@RequestMapping("logout.do")
	public String logout(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		session.invalidate();
		return "../index";
	}

	@RequestMapping("registerPage.do")
	public String registerPage() {
		
		return "registerPage";
	}

	@RequestMapping("register.do")
	public String register(@ModelAttribute CrizelVo vo, String re_id,
			String re_pw) {
		vo.setId(re_id);
		vo.setPw(re_pw);
		service.register(vo);
		return "../index";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("registerCheck.do")
	public void registerCheck(@RequestParam String re_id,
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String check = service.registerCheck(re_id);
		JSONObject obj = new JSONObject();
		if (check != null) {
			obj.put("result", "success");
			response.setContentType("application/x-json; charset=UTF-8");
			response.getWriter().print(obj);
		} else {
			obj.put("result", "fail");
			response.setContentType("application/x-json; charset=UTF-8");
			response.getWriter().print(obj);
		}
	}
	
	@RequestMapping("comic.do")
	public ModelAndView comic(@RequestParam(value="type", required=false) String type,
							@RequestParam(value="keyword", required=false) String keyword,
							@RequestParam(value="list", required=false) String list,
							@RequestParam(value="img", required=false) String img) throws IOException {
		ModelAndView mav = new ModelAndView();
		if(type != null){
			List<Map<String,Object>> comic = service.comic(type, keyword, list, img);
			mav.addObject("comic", comic);
		}
		mav.addObject("type", type);
		mav.addObject("keyword", keyword);
		mav.setViewName("/comic");
		return mav;
	}
	
	@RequestMapping("comicView.do")
	public void comicView(@RequestParam(value="addr", required=false) String addr) throws IOException {
		service.comicView(addr);
	}
	
	@RequestMapping("comicDown.do")
	public void comicDown(@RequestParam(value="addr", required=false) String addr,
						  @RequestParam(value="type", required=false) String type) throws IOException {
		service.comicDown(addr, type);
	}
	
	
	@RequestMapping("yes24.do")
	public ModelAndView yes24(@RequestParam(value="keyword", required=false)String keyword ,
							  @RequestParam(value="PageNumber", required=false, defaultValue="1")String PageNumber) throws IOException {
		ModelAndView mav = new ModelAndView();		
		mav.addObject("list", service.yes24(keyword, PageNumber));
		mav.addObject("page", service.yes24Page(keyword, PageNumber));
		mav.addObject("keyword", keyword);
		mav.setViewName("/yes24");
		return mav;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("json.do")
	public void json(HttpServletResponse response,
			@RequestParam(value="keyword", defaultValue="" )String keyword) throws IOException{
		List<CrizelVo> jsonList = service.json(keyword);
		
		JSONArray arr = new JSONArray();
		for(CrizelVo ob : jsonList){
			JSONObject obj = new JSONObject();
			obj.put("name", ob.getName());
			obj.put("addr", ob.getAddr());
			
			arr.add(obj);
		}
		
		response.setContentType("application/x-json; charset=UTF-8");
		response.getWriter().print(arr);
	}
	
	@RequestMapping("pubg.do")
	public ModelAndView pubg(@RequestParam(value="nickname", required=false, defaultValue="cribel") String nickname,
							 @RequestParam(value="region", required=false, defaultValue="krjp") String region,
							 @RequestParam(value="mode", required=false, defaultValue="solo") String mode		) throws Exception {
		ModelAndView mav = new ModelAndView();	
		Map<String,Object> map = service.pubg(nickname, region, mode);
		if(!"".equals(nickname)){
			mav.addObject("data", map);
		}
		mav.addObject("nickname", nickname);
		mav.addObject("region", region);
		mav.addObject("mode", mode);
		mav.setViewName("/pubg");
		return mav;
	}
	
	@RequestMapping("nico.do")
	public ModelAndView nico(@RequestParam(value="keyword", required=false, defaultValue="佐倉としたい大西") String keyword,
							 @RequestParam(value="type", required=false, defaultValue="A") String type,
							 @RequestParam(value="url", required=false, defaultValue="") String url){
		ModelAndView mav = new ModelAndView();	
		mav.addObject("data", service.nico(keyword, type, url));
		mav.addObject("keyword", keyword);
		mav.addObject("type", type);
		mav.addObject("url", url);
		mav.setViewName("/nico");
		return mav;
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
}
