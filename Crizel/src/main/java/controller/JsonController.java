package controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import util.Saramin;

@Controller
public class JsonController {
	@RequestMapping("saramin.do")
	public void saramin(HttpServletResponse response) throws Exception {
		Saramin saram = new Saramin();
		String html = "";
		
		List<Map<String,Object>> list = saram.getList();
		
		html += "<ul class='ul_type01'>";
		for(Map<String,Object> ob : list){
			html += "<li><ul>";
			html += "<li><a href='"+ ob.get("url").toString() +"'>" + ob.get("name").toString() + "</a></li>";
			html += "<li>" + ob.get("job-category").toString() + "</li>";
			html += "<li>" + ob.get("salary").toString() + "</li>";
			html += "</li></ul>";
		}
		html += "</ul>";
		
		response.setContentType("application/x-html; charset=UTF-8");
		response.getWriter().print(html);
	}
}
