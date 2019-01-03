package com.crizel.common;

import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.crizel.common.util.Mars;
import com.crizel.common.util.Saramin;
import com.crizel.common.util.Torrent;

@Controller
public class CrizelController {
	CrizelService service;
	
	@Value( "${db.url}" )	
	private String dbUrl;
	
	@Value( "${db.username}" )	
	private String username;
	
	@Value( "${db.password}" )	
	private String password;
	
	@Value( "${db.driverClassName}" )	
	private String driverClassName;
	
	@Value( "${db.type}" )	
	private String dbType;

	@Autowired
	public CrizelController(CrizelService service) {
		super();
		this.service = service;
	}
	@SuppressWarnings("unchecked")
	@RequestMapping("/main.do")
	public String main(Model model) throws Exception{
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -7);
		String key = "af6cbec63ac47906095794b914d659e7";
		String day = Integer.toString(cal.get(Calendar.YEAR));
		day += cal.get(Calendar.MONTH)+1<10?"0"+Integer.toString(cal.get(Calendar.MONTH)+1):Integer.toString(cal.get(Calendar.MONTH)+1);
		day += cal.get(Calendar.DATE)<10?"0"+Integer.toString(cal.get(Calendar.DATE)):Integer.toString(cal.get(Calendar.DATE));
		
		URL url = new URL("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?key="+key+"&targetDt="+day);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		InputStreamReader isr = new InputStreamReader(conn.getInputStream(), "UTF-8");
		JSONObject object = (JSONObject) JSONValue.parse(isr);
		JSONObject boxOfficeResult = (JSONObject) object.get("boxOfficeResult");
		JSONArray weeklyBoxOfficeList = (JSONArray) boxOfficeResult.get("weeklyBoxOfficeList");
		
		model.addAttribute("movieType", boxOfficeResult);
		model.addAttribute("movieList", weeklyBoxOfficeList);
			
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
		model.addAttribute("saraminList", arr);
		
		
		cal = Calendar.getInstance();
		SimpleDateFormat sdft = new SimpleDateFormat("yyyy/MM/dd");
		cal.add(Calendar.DATE, -1);		
		day = sdft.format(cal.getTime());
		Crizel crizel = new Crizel(day, dbUrl, username, password, driverClassName, dbType);
		crizel.start();
		
		return "/main";
	}
	
	@RequestMapping("list.do")
	public String list( @RequestParam(value="day", required=false, defaultValue="today") String day,
						@RequestParam(value="mode", required=false, defaultValue="") String mode,
						@RequestParam(value="type", required=false, defaultValue="") String type,
						Model model) {
		Calendar cal = Calendar.getInstance();
		final String[] week = { "일", "월", "화", "수", "목", "금", "토" };
		if (day.equals("today")) {
			day = week[cal.get(Calendar.DAY_OF_WEEK) - 1];
		}
		model.addAttribute("list", service.list(day));
		model.addAttribute("day", day);
		model.addAttribute("mode", mode);
		model.addAttribute("type", type);
		return "/list/list";
	}

	@RequestMapping("listDetail.do")
	public String listDetail( @RequestParam(value="keyword", defaultValue="") String keyword, 
									@RequestParam(value="type", defaultValue="") String type, 
									@RequestParam(value="site", defaultValue="") String site,
									@RequestParam(value="mode", defaultValue="") String mode,
									@RequestParam(value="ani_id", defaultValue="") String ani_id,
									Model model,
									HttpServletResponse response, HttpServletRequest request, HttpSession session) throws Exception{
		model.addAttribute("listDetail",service.listDetail(keyword, type, site, mode));
		model.addAttribute("mode", mode);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);
		model.addAttribute("ani_id", ani_id);
		return "/list/list";
	}
	
	@RequestMapping("aniDelete.do")
	public String aniDelete(@ModelAttribute CrizelVo vo,
							@RequestParam(value="mode", defaultValue="") String mode,
							HttpServletResponse response, HttpServletRequest request, HttpSession session){
		service.aniDelete(vo);
		return "redirect:list.do?day=today&mode="+mode;
	}

		
	@RequestMapping("listInsertPage.do")
	public String listInsertPage(@RequestParam(value="mode", defaultValue="insert") String mode, 
			             	     @RequestParam(value="ani_id", defaultValue="") String ani_id, 
			                	 @RequestParam(value="path", defaultValue="E:/크리젤/임시폴더/") String path,
			                	 Model model) {
		CrizelVo ani_info = service.aniInfo(ani_id);
		if("insert".equals(mode)){
			ani_info = new CrizelVo();
			ani_info.setDirectory(path);
		}else{
			if(ani_info.getDirectory()==null){
				ani_info.setDirectory(path);
			}
		}
		model.addAttribute("ani_info", ani_info);
		model.addAttribute("mode", mode);
		return "/list/listInsertPage";
	}
	
	@RequestMapping("listInsert.do")
	public String listInsert(@ModelAttribute CrizelVo vo, 
			 				 @RequestParam(value="mode", defaultValue="") String mode) throws Exception {
		service.listInsert(vo);
		return "redirect:listInsertPage.do?day="+URLEncoder.encode(vo.getDay(), "UTF-8")+"&mode="+mode;
	}
	
	@RequestMapping("listUpdate.do")
	public String listUpdate(@ModelAttribute CrizelVo vo, 
							 @RequestParam(value="mode", defaultValue="") String mode) throws Exception {
		service.listUpdate(vo);
		return "redirect:list.do?day="+URLEncoder.encode(vo.getDay(), "UTF-8")+"&mode=nyaa";
	}
	
	@RequestMapping("loginPage.do")
	public String loginPage() {
		return "/account/login";
	}
	
	@RequestMapping("login.do")
	public String login(@ModelAttribute CrizelVo vo, 
						@RequestParam(value="referer", defaultValue="/") String referer,
						Model model,
						HttpServletResponse response, HttpServletRequest request, HttpSession session) throws Exception {
		String returnUrl = "";
		CrizelVo vo2 = service.login(vo);
		session.setAttribute("login", vo2);
		
		if(vo2==null){
			model.addAttribute("message", "계정을 확인하여 주시기 바랍니다.");
			model.addAttribute("returnPage", referer);
			returnUrl = "/util/alertPage";
		}else{
			model.addAttribute("returnPage", referer);
			returnUrl = "/util/returnPage";
		}
		return returnUrl;
	}

	@RequestMapping("logout.do")
	public void logout(HttpServletResponse response, HttpServletRequest request, HttpSession session) throws Exception {
		session.invalidate();
		response.sendRedirect("/");
	}

	@RequestMapping("registerPage.do")
	public String registerPage() {
		return "/account/registerPage";
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
	public String onejav(	@RequestParam(value="day", defaultValue="") String day,	
					 		@RequestParam(value="type", defaultValue="list") String type,
					 		Model model) throws Exception{
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdft = new SimpleDateFormat("yyyy/MM/dd");
		cal.add(Calendar.DATE, -1);		
		String addr = "https://www.onejav.com/";
		
		if("".equals(day)){
			day = sdft.format(cal.getTime());
		}
		addr += day;
		
		if("list".equals(type)){
			model.addAttribute("list", service.onejav(day));
			model.addAttribute("day", day);
			return "onejav";
		}else{
			@SuppressWarnings("unused")
			Crizel crizel = new Crizel(day, dbUrl, username, password, driverClassName, dbType);
			crizel.start();
			//service.onejavInsert(addr, day);
			return "redirect:onejav.do?day="+day;
		}
	}
	
	@RequestMapping("fileUpload.do")
	public void fileUpload(	@RequestParam(value="directory", defaultValue="D:\\test\\") String directory
						,	MultipartHttpServletRequest request
			) throws Exception {
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
