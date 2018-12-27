package com.crizel.girls;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

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
			        Elements elem = doc.select("img");
			        for (org.jsoup.nodes.Element e : elem) {
			        	String img = e.attr("src");
			        	if(getCurrentImage(img)){
			        		imgList.add(img);
			        	}					
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

	public List<GirlsVO> girlsInfo(String name) {
		return sqlSession.selectList("girls.girlsInfo", name);
	}
	
	public static boolean getCurrentImage(String addr) {
		boolean a = false;
		try {
			URL url = new URL(addr);
			InputStream is = url.openStream();
			BufferedImage bi = ImageIO.read(is);
			if (bi.getWidth() >= 200) {
				a = true;
			}
		} catch (Exception e) {
			System.out.println("ERR : " + e.toString());
			a = false;
		}
		return a;
	}

}
