package girls;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GirlsController {
	GirlsService service;

	@Autowired
	public GirlsController(GirlsService service) {
		super();
		this.service = service;
	}

	@RequestMapping("girls.do")
	public ModelAndView girls(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();	
		String name = parseNull(request.getParameter("name"));
		List<Object> nameList = service.nameList();
		List<Object> girlsList = service.girlsImg(name);
		mav.addObject("name", name);
		mav.addObject("nameList", nameList);
		mav.addObject("girlsList", girlsList);
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
