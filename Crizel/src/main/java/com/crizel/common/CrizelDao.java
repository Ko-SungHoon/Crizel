package com.crizel.common;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.crizel.common.util.Leopard;
import com.crizel.common.util.Ohys;
import com.crizel.nyaa.NyaaUtil;

@Repository("dao")
public class CrizelDao {
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Value( "${type}" )	
	private String type;

	public List<Object> list(String day) {
		return sqlSession.selectList(type + "_crizel.list", day);
	}

	public List<Map<String,Object>> listDetail(String keyword, String type, String site, String mode) throws Exception {
		Ohys ohys 					= new Ohys();
		Leopard lp 					= new Leopard();
		NyaaUtil nyaa					= new NyaaUtil();
		List<Map<String,Object>> a 	= new ArrayList<Map<String,Object>>();
		String addr					= "";
		
		if("nyaa".equals(mode)){
			a = nyaa.NyaaList(type, keyword);
		}else{
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
		}
		
		return a;
	}

	public void listInsert(CrizelVo vo) {
		File file = new File(vo.getDirectory());
        if(!file.exists()){
            file.mkdirs();
        }
		sqlSession.insert(type + "_crizel.listInsert", vo);
	}

	public void listUpdate(CrizelVo vo) {
		File file = new File(vo.getDirectory());
        if(!file.exists()){
            file.mkdirs();
        }
		sqlSession.update(type + "_crizel.listUpdate", vo);
	}

	public CrizelVo aniInfo(String ani_id) {
		return sqlSession.selectOne(type + "_crizel.aniInfo", ani_id);
	}

	public void aniDelete(CrizelVo vo) {
		sqlSession.delete(type + "_crizel.listDelete", vo);
	}
	public CrizelVo login(CrizelVo vo) {
		return sqlSession.selectOne(type + "_crizel.login", vo);
	}

	public void register(CrizelVo vo) {
		sqlSession.insert(type + "_crizel.register", vo);

	}

	public String registerCheck(String re_id) {
		return sqlSession.selectOne(type + "_crizel.registerCheck", re_id);
	}

	public List<Object> comicList() {
		return sqlSession.selectList(type + "_crizel.comicList");
	}

	public void comicInsert(CrizelVo vo) {
		sqlSession.insert(type + "_crizel.comicInsert", vo);
	}

	public void comicDelete(CrizelVo vo) {
		sqlSession.delete(type + "_crizel.comicDelete", vo);
	}

	public void comicViewCheck(Map<String, Object> map) {
		sqlSession.insert(type + "_crizel.comicViewCheck", map);
	}

	public List<Map<String, Object>> comicViewList(String addr) {
		return sqlSession.selectList(type + "_crizel.comicViewList", addr);
	}

}
