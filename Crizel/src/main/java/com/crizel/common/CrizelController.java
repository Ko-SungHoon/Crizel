package com.crizel.common;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.xml.sax.SAXException;

@Controller
public class CrizelController {
	CrizelService service;

	@Autowired
	public CrizelController(CrizelService service) {
		super();
		this.service = service;
	}
	@RequestMapping("list.do")
	public ModelAndView list(
			@RequestParam(value="day", required=false, defaultValue="today") String day,
			@RequestParam(value="mode", required=false, defaultValue="") String mode,
			@RequestParam(value="type", required=false, defaultValue="") String type) {
		ModelAndView mav = new ModelAndView();		
		Calendar cal = Calendar.getInstance();
		final String[] week = { "일", "월", "화", "수", "목", "금", "토" };
		if (day.equals("today")) {
			day = week[cal.get(Calendar.DAY_OF_WEEK) - 1];
		}
		mav.addObject("list", service.list(day));
		mav.addObject("day", day);
		mav.addObject("mode", mode);
		mav.addObject("type", type);
		mav.setViewName("/list/list");
		return mav;
	}

	@RequestMapping("listDetail.do")
	public ModelAndView listDetail(@RequestParam String keyword, String type, String site,
			@RequestParam(value="mode", defaultValue="") String mode,
			HttpServletResponse response) throws Exception,
			SAXException, IOException {
		ModelAndView mav = new ModelAndView();
		mav.addObject("listDetail",service.listDetail(keyword, type, site, mode));
		mav.addObject("mode", mode);
		mav.addObject("type", type);
		mav.addObject("keyword", keyword);
		mav.setViewName("/list/list");
		return mav;
	}
	
	@RequestMapping("aniDelete.do")
	public String aniDelete(@ModelAttribute CrizelVo vo,
			@RequestParam(value="mode", defaultValue="") String mode){
		service.aniDelete(vo);
		return "redirect:list.do?day=today&mode="+mode;
	}

		
	@RequestMapping("listInsertPage.do")
	public ModelAndView listInsertPage() {
		ModelAndView mav = new ModelAndView();		
		mav.setViewName("/list/listInsertPage");
		return mav;
	}
	
	@RequestMapping("listInsert.do")
	public String listInsert(@ModelAttribute CrizelVo vo, @RequestParam(value="mode", defaultValue="") String mode) throws UnsupportedEncodingException {
		service.listInsert(vo);
		return "redirect:listInsertPage.do?day="+URLEncoder.encode(vo.getDay(), "UTF-8")+"&mode="+mode;
	}
	
	@RequestMapping("loginPage.do")
	public String loginPage() {
		return "login";
	}

	/*@SuppressWarnings("unchecked")
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
	}*/
	
	@RequestMapping("login.do")
	public void login(@ModelAttribute CrizelVo vo, HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		CrizelVo vo2 = service.login(vo);
		
		HttpSession session = request.getSession();
		session.setAttribute("login", vo2);
		
		RequestDispatcher rd = request.getRequestDispatcher("/");
		rd.forward(request, response);
	}

	@RequestMapping("logout.do")
	public void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		session.invalidate();
		response.sendRedirect("/");
	}

	@RequestMapping("registerPage.do")
	public String registerPage() {
		return "registerPage";
	}

	@RequestMapping("register.do")
	public void register(@ModelAttribute CrizelVo vo, String re_id, String re_pw,
			HttpServletRequest request, HttpServletResponse response) throws IOException {
		vo.setId(re_id);
		vo.setPw(re_pw);
		service.register(vo);
		response.sendRedirect("/");
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
	
	@RequestMapping("comic")
	public ModelAndView comic(	@RequestParam(value="type", required=false, defaultValue="") String type
							,	@RequestParam(value="keyword", required=false, defaultValue="") String keyword
							,	@RequestParam(value="addrA", required=false, defaultValue="") String addrA
							,	@RequestParam(value="addrB", required=false, defaultValue="") String addrB
							,	@RequestParam(value="addrC", required=false, defaultValue="") String addrC
							,	@RequestParam(value="title", required=false, defaultValue="") String title
			) throws Exception {
		ModelAndView mav = new ModelAndView();
		Maru mr = new Maru();
		
		if("A".equals(type)){
			// 검색했을 때 만화제목이 나오는 목록
			mav.addObject("list", mr.getList("http://marumaru.in/?r=home&mod=search&keyword=" + URLEncoder.encode(keyword, "UTF-8")));
		}else if("B".equals(type)){
			// 만화 화수 목록
			mav.addObject("viewList", mr.getComic("http://marumaru.in/" + addrB));
			mav.addObject("comicViewList", service.comicViewList(addrB));	// viewCount 목록
			mav.addObject("addrB", addrB);									// 만화 viewCount 업데이트 시 where절에 쓸 주소
			
			//	읽은 화수 표시
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("title", URLEncoder.encode(title,"UTF-8"));
			map.put("addr", addrB);
			service.comicViewCheck(map);
		}else if("C".equals(type)){
			// 만화 이미지 리스트
			mav.addObject("imgList", mr.getView(addrC));
			
			// 만화 화수 목록(만화 밑에 뜨게)
			mav.addObject("viewList", mr.getComic("http://marumaru.in/" + addrB));
			mav.addObject("comicViewList", service.comicViewList(addrB));	// viewCount 목록
			mav.addObject("addrB", addrB);									// 만화 viewCount 업데이트 시 where절에 쓸 주소
		}else{
			mav.addObject("comicList", service.comicList());
		}
		
		mav.addObject("type", type);
		mav.addObject("keyword", keyword);
		mav.setViewName("comic/main");
		return mav;
	}
	
	@RequestMapping("comicInsertPage")
	public ModelAndView comicInsertPage(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		List<Object> comicList = service.comicList();
		mav.addObject("comicList", comicList);
		mav.setViewName("comic/comicInsertPage");
		return mav;
	}
	
	@RequestMapping("comicInsert")
	public String comicInsert(@ModelAttribute CrizelVo vo) {
		service.comicInsert(vo);
		return "redirect:comicInsertPage.do";

	}

	@RequestMapping("comicDelete")
	public String comicDelete(@ModelAttribute CrizelVo vo) {
		service.comicDelete(vo);
		return "redirect:comicInsertPage.do";

	}
	
	@RequestMapping("comicView")
	public void comicView(@RequestParam(value="addr", required=false) String addr
			,	HttpServletRequest request, HttpServletResponse response) throws Exception {
		Maru mr = new Maru();
		mr.ImageStream(addr, request, response);
	}
	
	@RequestMapping("comicDown")
	public void comicDown(@RequestParam(value="addr", required=false) String addr,
						  @RequestParam(value="type", required=false) String type) throws IOException {
		service.comicDown(addr, type);
	}
	
	@RequestMapping("comicViewCheck")
	public void comicViewCheck(
			@RequestParam(value="title", required=false) String title,
			@RequestParam(value="addr", required=false) String addr,
			HttpServletResponse response) throws IOException {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("title", title);
		map.put("addr", addr);
		service.comicViewCheck(map);
		response.setContentType("application/x-json; charset=UTF-8");
		response.getWriter().print("1");
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping("saramin.do")
	public void saramin(HttpServletResponse response) throws Exception {
		Saramin saram = new Saramin();
		List<Map<String,Object>> list = saram.getList();
		
		JSONArray arr = new JSONArray();
		for(Map<String,Object> ob : list){
			JSONObject obj = new JSONObject();
			obj.put("url", ob.get("url").toString());
			obj.put("name", ob.get("name").toString());
			obj.put("salary", ob.get("salary").toString());
			obj.put("category", ob.get("job-category").toString());
			arr.add(obj);
		}
		
		response.setContentType("application/x-json; charset=UTF-8");
		response.getWriter().print(arr);
		
	}
	
	@RequestMapping("music.do")
	public ModelAndView music(
			@RequestParam(value="url", required=false, defaultValue="http://hikarinoakariost.info/") String url,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Music music = new Music();
		mav.addObject("music", music.music(url));
		mav.setViewName("music");
		return mav;
		
	}
	
	@RequestMapping("torrent")
	public ModelAndView torrent() throws UnsupportedEncodingException{
		ModelAndView mav = new ModelAndView();
		Torrent t1 = new Torrent();
		List<Map<String,Object>> list = t1.getList(); 
		mav.addObject("list", list);
		mav.setViewName("torrent");
		return mav;
	}
	
	@RequestMapping("mars")
	public ModelAndView mars(	@RequestParam(value="addr", defaultValue="https://5siri.com/xe/index.php?mid=manko") String addr
							,	@RequestParam(value="type", defaultValue="list") String type) throws Exception{
		ModelAndView mav = new ModelAndView();
		Mars mars = new Mars();
		if("list".equals(type)){
			mav.addObject("list", mars.getList(addr));
		}else{
			mav.addObject("view", mars.getView(addr));
		}
		mav.addObject("addr", URLEncoder.encode(addr, "UTF-8"));
		mav.setViewName("mars");
		return mav;
	}
	
	@RequestMapping("onejav")
	public ModelAndView onejav(	@RequestParam(value="addr", defaultValue="") String addr
							,	@RequestParam(value="type", defaultValue="list") String type) throws Exception{
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);		
		String year 	= Integer.toString(cal.get(Calendar.YEAR));
		String month 	= cal.get(Calendar.MONTH)+1<10 	?"0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1);
		String day		= cal.get(Calendar.DATE)<10		?"0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE));
		
		if("".equals(addr)){
			addr = "http://www.onejav.com/" + year + "/" + month + "/" + day;
		}
		
		ModelAndView mav = new ModelAndView();

		OneJav oj = new OneJav();
		mav.addObject("list", oj.getList(addr));
		mav.addObject("addr", addr);
		mav.addObject("year", year);
		mav.addObject("month", month);
		mav.addObject("day", day);
		
		mav.setViewName("onejav");
		return mav;
	}
	
	@RequestMapping("fileUpload.do")
	public void fileUpload(	@RequestParam(value="directory", defaultValue="D:\\test\\") String directory
						,	MultipartHttpServletRequest request
			) throws Exception {
		ModelAndView mav = new ModelAndView();
		String path 	= directory;		// 경로
		String saveFile = "";				// 저장파일명
		String realFile = "";				// 실제파일명
		int extIndex 	= 0;

		File file = new File(path);
		if (!file.isDirectory()) {file.mkdirs();}

		List<MultipartFile> mf = request.getFiles("file");

		for (int i = 0; i < mf.size(); i++) {
			extIndex = mf.get(i).getOriginalFilename().lastIndexOf(".");												// 확장자를 구하기 위해 마지막 . 위치를 구함										
			saveFile =  mf.get(i).getOriginalFilename().substring(0,extIndex) + "_" + System.currentTimeMillis();		// 확장자 앞 텍스트와 구분을 위한 문자열 추가
			saveFile += mf.get(i).getOriginalFilename().substring(extIndex, mf.get(i).getOriginalFilename().length());	// 확장자 추가
			realFile = mf.get(i).getOriginalFilename();
			
			mf.get(i).transferTo(new File(path + saveFile));
		}
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
}
