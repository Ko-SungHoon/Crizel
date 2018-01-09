package wiki;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("wikiDao")
public class WikiDao {
	@Autowired
	private SqlSessionTemplate session;
	
	public List<WikiVO> wikiList() {
		return session.selectList("wiki.wikiList");
	}

	public WikiVO wikiContent(String wiki_id) {
		return session.selectOne("wiki.wikiContent", wiki_id);
	}

	public void wikiInsert(WikiVO vo) {
		session.insert("wiki.wikiInsert", vo);
	}

	public void wikiUpdate(WikiVO vo) {
		session.update("wiki.wikiUpdate", vo);
	}

	public void wikiDelete(String wiki_id) {
		session.delete("wiki.wikiDelete", wiki_id);
	}

	public WikiVO wikiCateContent(String wiki_cate_id) {
		return session.selectOne("wiki.wikiCateContent", wiki_cate_id);
	}

	public void wikiCateInsert(WikiVO vo) {
		session.insert("wiki.wikiCateInsert", vo);
	}

	public void wikiCateUpdate(WikiVO vo) {
		session.update("wiki.wikiCateUpdate", vo);
	}

	public void wikiCateDelete(String wiki_cate_id) {
		session.delete("wiki.wikiCateDelete", wiki_cate_id);
		session.delete("wiki.wikiCateDelete2", wiki_cate_id);
	}

	public List<WikiVO> wikiCateList() {
		return session.selectList("wiki.wikiCateList");
	}

}
