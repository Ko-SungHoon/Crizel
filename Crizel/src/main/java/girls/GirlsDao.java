package girls;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("girlsDao")
public class GirlsDao {
	@Autowired
	private SqlSessionFactory factory;

	public String girlsGetName() {
		return factory.openSession().selectOne("girls.girlsGetName");
	}

	public List<Object> nameList() {
		return factory.openSession().selectList("girls.nameList");
	}

	public void girlsInsert(GirlsVO vo) {
		factory.openSession().insert("girls.girlsInsert", vo);
	}

	public void girlsDelete(GirlsVO vo) {
		factory.openSession().delete("girls.girlsDelete", vo);
	}

	public List<Object> girlsImg(String name) {
		List<Object> imgList = new ArrayList<Object>();
		String line;
		GirlsVO vo = null; 
		List<GirlsVO> list = null;
		
		int size = 0;
		
		if("all".equals(name)){
			list = factory.openSession().selectList("girls.girlsImgList");
			size = list.size();
		}else{
			size = 1;
		}
		
		for(int i=0; i<size; i++){
			if("all".equals(name)){
				vo = list.get(i);
			}else{
				vo = factory.openSession().selectOne("girls.girlsImg", name);
			}
			
			if("twitter".equals(vo.getType())){						//트위터
				try {
					org.jsoup.nodes.Document doc = null;
					try {
						doc = Jsoup.connect(vo.getAddr()).get();
					} catch (IOException e1) {
						e1.printStackTrace();
					}
					org.jsoup.select.Elements elements = doc.select("div.AdaptiveMedia-photoContainer img");
					for (org.jsoup.nodes.Element e : elements) {
						String img = e.attr("src");
						imgList.add(img);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if("insta".equals(vo.getType())){					//인스타
				HttpURLConnection conn;
				BufferedReader rd;
				try {
					URL url = new URL(vo.getAddr());
					conn = (HttpURLConnection) url.openConnection();
					conn.setRequestMethod("GET");
					rd = new BufferedReader(new InputStreamReader(
							conn.getInputStream()));
					while ((line = rd.readLine()) != null) {
						if (line.contains("sharedData")) {
							line = line.replace("<script type=\"text/javascript\">window._sharedData = ","");
							line = line.replace(";</script>", "");
							
							JSONParser parser = new JSONParser();
						    Object obj = parser.parse( line );
						    JSONObject object = (JSONObject) obj;
							JSONObject entry_data = (JSONObject) object.get("entry_data");
							JSONArray ProfilePage = (JSONArray) entry_data.get("ProfilePage");
							JSONObject ProfilePage_0 = (JSONObject) ProfilePage.get(0);
							JSONObject graphql = (JSONObject) ProfilePage_0.get("graphql");
							JSONObject user = (JSONObject) graphql.get("user");
							JSONObject edge_owner_to_timeline_media = (JSONObject) user.get("edge_owner_to_timeline_media");
							JSONArray edges = (JSONArray) edge_owner_to_timeline_media.get("edges");
							
							for(int i2=0; i2<edges.size(); i2++){
								JSONObject node = (JSONObject)((JSONObject)edges.get(i2)).get("node");
								//System.out.println(node.get("display_url").toString());
								imgList.add(node.get("display_url").toString());
							}
						}
					}
				}catch(Exception e){
					System.out.println(e.toString());
				}
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
