package com.crizel.common;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.xml.sax.SAXException;

import com.crizel.util.Leopard;
import com.crizel.util.Ohys;

@Repository("dao")
public class CrizelDao {
	@Autowired
	private SqlSessionTemplate sqlSession;


	public List<Object> list(String day) {
		return sqlSession.selectList("crizel.list", day);
	}

	public List<Object> listDetail(String keyword, String type, String site) throws Exception {
		Ohys ohys 		= new Ohys();
		Leopard lp 		= new Leopard();
		List<Object> a 	= new ArrayList<Object>();
		String addr		= "";
		
		if("ohys".equals(site)){
			if("video".equals(type)){
				addr = "https://torrents.ohys.net/download/rss.php?dir=new&q=" + URLEncoder.encode(keyword, "UTF-8");
			}else if("audio".equals(type)){
				addr = "https://www.nyaa.se/?page=rss&cats=3_0&term=" + URLEncoder.encode(keyword, "UTF-8");
			}else{
				addr = "https://sukebei.nyaa.se/?page=rss&term=" + URLEncoder.encode(keyword, "UTF-8");
			}
			a = ohys.getList(addr);
		}else{
			addr = "http://leopard-raws.org/?search=" + URLEncoder.encode(keyword, "UTF-8");
			a = lp.getList(addr);
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
