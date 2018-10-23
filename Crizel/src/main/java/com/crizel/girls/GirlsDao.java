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
		List<GirlsVO> list = null;
		Instagram ins = new Instagram();
		Twitter twitter = new Twitter();
		
		list = sqlSession.selectList("girls.girlsImg", name);
		
		for(int i=0; i<list.size(); i++){
			if("twitter".equals(list.get(i).getType())){						//트위터
				imgList.addAll(twitter.getList(list.get(i).getAddr()));
			}else if("insta".equals(list.get(i).getType())){					//인스타
				imgList.addAll(ins.getList(list.get(i).getAddr()));
			}else if("blog".equals(list.get(i).getType())){					//블로그
				try {
					org.jsoup.nodes.Document doc = null;
					try {
						doc = Jsoup.connect(list.get(i).getAddr()).get();
					} catch (IOException e1) {
						e1.printStackTrace();
					}
					String URL = list.get(i).getAddr();
			        doc = Jsoup.connect(URL).get();
			        Elements elem = doc.select(list.get(i).getTag1());
			        for (org.jsoup.nodes.Element e : elem) {
						String img = e.attr(list.get(i).getTag2());
						imgList.add(img);
					}
				} catch (Exception e) {
					System.out.println(e.toString());
				}
			}
		}
		
		return imgList;
	}

	public List<Object> girlsList() {
		return sqlSession.selectList("girls.girlsList");
	}

}
