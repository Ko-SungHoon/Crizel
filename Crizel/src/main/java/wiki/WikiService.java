package wiki;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("wikiService")
public class WikiService {
	@Autowired
	WikiDao dao;
	
	public String parseNull(String value){
		if(value == null){value = "";}		
		return value;
	}
	
	public List<WikiVO> wikiList() {
		return dao.wikiList();
	}

	public WikiVO wikiContent(String wiki_id) {
		return dao.wikiContent(wiki_id);
	}

	public void wikiInsert(WikiVO vo) {
		dao.wikiInsert(vo);
	}

	public void wikiUpdate(WikiVO vo) {
		dao.wikiUpdate(vo);
	}

	public void wikiDelete(String wiki_id) {
		dao.wikiDelete(wiki_id);
	}

	public WikiVO wikiCateContent(String wiki_cate_id) {
		return dao.wikiCateContent(wiki_cate_id);
	}

	public void wikiCateInsert(WikiVO vo) {
		dao.wikiCateInsert(vo);
	}

	public void wikiCateUpdate(WikiVO vo) {
		dao.wikiCateUpdate(vo);
	}

	public void wikiCateDelete(String wiki_cate_id) {
		dao.wikiCateDelete(wiki_cate_id);
	}

	public List<WikiVO> wikiCateList() {
		return dao.wikiCateList();
	}
}
