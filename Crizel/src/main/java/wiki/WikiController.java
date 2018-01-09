package wiki;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class WikiController {
	WikiService service;

	@Autowired
	public WikiController(WikiService service) {
		super();
		this.service = service;
	}

	@RequestMapping("wiki.do")
	public ModelAndView wiki(@RequestParam(value="wiki_id", required=false) String wiki_id) {
		ModelAndView mav = new ModelAndView();	
		List<WikiVO> wikiList = service.wikiList();
		WikiVO wikiContent = service.wikiContent(wiki_id);
		mav.addObject("wikiList", wikiList);
		mav.addObject("wikiContent", wikiContent);
		mav.setViewName("/wiki/main");
		return mav;
	}
	
	@RequestMapping("wikiInsertPage.do")
	public ModelAndView wikiInsertPage(@RequestParam(value="wiki_id", required=false) String wiki_id,
			@RequestParam(value="type", required=false) String type) {
		ModelAndView mav = new ModelAndView();	
		if(wiki_id != null){
			WikiVO wikiContent = service.wikiContent(wiki_id);
			mav.addObject("wikiContent", wikiContent);
		}
		List<WikiVO> wikiCateList = service.wikiCateList();
		mav.addObject("wikiCateList", wikiCateList);
		mav.addObject("type", type);
		mav.setViewName("/wiki/wikiInsertPage");
		return mav;
	}
	
	@RequestMapping("wikiInsert.do")
	public String wikiInsert(@ModelAttribute WikiVO vo	/*, BindingResult errors*/	) {
		/*if(errors.hasErrors() ){
			System.out.println(errors.getAllErrors());
		}*/
		service.wikiInsert(vo);
		return "redirect:wiki.do";
	}
	
	@RequestMapping("wikiUpdate.do")
	public String wikiUpdate(@ModelAttribute WikiVO vo) {
		service.wikiUpdate(vo);
		return "redirect:wiki.do?wiki_id="+vo.getWiki_id();
	}
	
	@RequestMapping("wikiDelete.do")
	public String wikiDelete(@RequestParam(value="wiki_id", required=false) String wiki_id) {
		service.wikiDelete(wiki_id);
		return "redirect:wiki.do";
	}
	
	
	@RequestMapping("wikiCateInsertPage.do")
	public ModelAndView wikiCateInsertPage(@RequestParam(value="wiki_cate_id", required=false) String wiki_cate_id,
			@RequestParam(value="type", required=false) String type) {
		ModelAndView mav = new ModelAndView();	
		if(wiki_cate_id != null){
			WikiVO wikiCateContent = service.wikiCateContent(wiki_cate_id);
			mav.addObject("wikiCateContent", wikiCateContent);
		}
		List<WikiVO> wikiCateList = service.wikiCateList();
		mav.addObject("wikiCateList", wikiCateList);
		mav.addObject("type", type);
		mav.setViewName("/wiki/wikiCateInsertPage");
		return mav;
	}
	
	@RequestMapping("wikiCateInsert.do")
	public String wikiCateInsert(@ModelAttribute WikiVO vo	/*, BindingResult errors*/	) {
		/*if(errors.hasErrors() ){
			System.out.println(errors.getAllErrors());
		}*/
		service.wikiCateInsert(vo);
		return "redirect:wiki.do";
	}
	
	@RequestMapping("wikiCateUpdate.do")
	public String wikiCateUpdate(@ModelAttribute WikiVO vo) {
		service.wikiCateUpdate(vo);
		return "redirect:wiki.do?wiki_id="+vo.getWiki_id();	
	}
	
	@RequestMapping("wikiCateDelete.do")
	public String wikiCateDelete(@RequestParam(value="wiki_cate_id", required=false) String wiki_cate_id) {
		service.wikiCateDelete(wiki_cate_id);
		return "redirect:wiki.do";
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
}
