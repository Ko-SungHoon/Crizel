package com.crizel.common;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

@Repository("dao")
public class CrizelDao {
	@Autowired
	private SqlSessionTemplate sqlSession;


	public List<Object> list(String day) {
		return sqlSession.selectList("crizel.list", day);
	}

	public List<Object> listDetail(String keyword, String type)
			throws ParserConfigurationException, SAXException, IOException {
		List<Object> a = new ArrayList<Object>();
		Map<String, Object> map;
		DocumentBuilderFactory factory2 = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory2.newDocumentBuilder();
		Document doc;
		if (type.equals("video")) {
			doc = builder.parse("https://torrents.ohys.net/download/rss.php?dir=new&q=" + keyword);
			//doc = builder.parse("https://www.nyaa.se/?page=rss&cats=1_11&term=" + keyword);       //nyaa가 막혀서 못씀
		} else if (type.equals("audio")) {
			doc = builder.parse("https://www.nyaa.se/?page=rss&cats=3_0&term=" + keyword);
		} else {
			doc = builder.parse("https://sukebei.nyaa.se/?page=rss&term=" + keyword);
		}
		NodeList list = doc.getElementsByTagName("title");
		NodeList list2 = doc.getElementsByTagName("link");

		int i = 0;
		Element element, element2;
		String content, content2;

		while (list.item(i) != null) {
			map = new HashMap<String, Object>();
			element = (Element) list.item(i);
			content = element.getTextContent();

			element2 = (Element) list2.item(i);
			content2 = element2.getTextContent();

			map.put("title", content);
			map.put("link", content2);

			a.add(map);

			i++;
		}

		return a;
	}

	public void listInsert(CrizelVo vo) {
		sqlSession.insert("crizel.listInsert", vo);

	}

	public void aniDelete(CrizelVo vo) {
		sqlSession.delete("crizel.listDelete", vo);
	}
	public CrizelVo login(CrizelVo vo) {
		return sqlSession.selectOne("crizel.login", vo);
	}

	public void register(CrizelVo vo) {
		sqlSession.insert("crizel.register", vo);

	}

	public String registerCheck(String re_id) {
		return sqlSession.selectOne("crizel.registerCheck", re_id);
	}

	public List<CrizelVo> json(String keyword) {
		return sqlSession.selectList("crizel.json", keyword);
	}

	public List<Object> comicList() {
		return sqlSession.selectList("crizel.comicList");
	}

	public void comicInsert(CrizelVo vo) {
		sqlSession.insert("crizel.comicInsert", vo);
	}

	public void comicDelete(CrizelVo vo) {
		sqlSession.delete("crizel.comicDelete", vo);
	}

	public void comicViewCheck(Map<String, Object> map) {
		sqlSession.insert("crizel.comicViewCheck", map);
	}

	public List<Map<String, Object>> comicViewList(String addr) {
		return sqlSession.selectList("crizel.comicViewList", addr);
	}

	public void test() {
		sqlSession.update("crizel.test");
	}

	

}
