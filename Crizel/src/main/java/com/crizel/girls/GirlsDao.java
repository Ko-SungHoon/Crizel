package com.crizel.girls;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("girlsDao")
public class GirlsDao {
	@Autowired
	private SqlSessionTemplate sqlSession;

	public String girlsGetName() {
		return sqlSession.selectOne("girls.girlsGetName");
	}

	public List<Object> nameList() {
		return sqlSession.selectList("girls.nameList");
	}

	public void girlsInsert(GirlsVO vo) {
		sqlSession.insert("girls.girlsInsert", vo);
	}

	public void girlsDelete(GirlsVO vo) {
		sqlSession.delete("girls.girlsDelete", vo);
	}

	public List<Object> girlsImg(String name) {
		List<Object> imgList = new ArrayList<Object>();
		GirlsVO vo = null; 
		List<GirlsVO> list = null;
		Instagram ins = new Instagram();
		Twitter twitter = new Twitter();
		
		int size = 0;
		
		if("all".equals(name)){
			list = sqlSession.selectList("girls.girlsImgList");
			size = list.size();
		}else{
			size = 1;
		}
		
		for(int i=0; i<size; i++){
			if("all".equals(name)){
				vo = list.get(i);
			}else{
				vo = sqlSession.selectOne("girls.girlsImg", name);
			}
			
			if("twitter".equals(vo.getType())){						//트위터
				imgList.addAll(twitter.getList(vo.getAddr()));
			}else if("insta".equals(vo.getType())){					//인스타
				imgList.addAll(ins.getList(vo.getAddr()));
			}else if("blog".equals(vo.getType())){					//블로그
				try {
					org.jsoup.nodes.Document doc = null;
					try {
						doc = Jsoup.connect(vo.getAddr()).get();
					} catch (IOException e1) {
						e1.printStackTrace();
					}
					String URL = vo.getAddr();
			        doc = Jsoup.connect(URL).get();
			        Elements elem = doc.select(vo.getTag1());
			        for (org.jsoup.nodes.Element e : elem) {
						String img = e.attr(vo.getTag2());
						imgList.add(img);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return imgList;
	}

}
