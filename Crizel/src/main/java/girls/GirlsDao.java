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
		GirlsVO vo = factory.openSession().selectOne("girls.girlsImg", name);
			
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
							try {
								FileWriter fw = new FileWriter("Test.json"); // 절대주소 경로 가능
								BufferedWriter bw = new BufferedWriter(fw);
								String str = line;
								bw.write(str);
								bw.newLine(); // 줄바꿈
								bw.close();
							} catch (IOException e) {
								System.err.println(e.toString()); // 에러가 있다면 메시지 출력
								System.exit(1);
							}
							JSONParser parser = new JSONParser();
							Object obj = parser.parse(new FileReader("Test.json"));

							JSONObject object = (JSONObject) obj;
							JSONObject name1 = (JSONObject) object.get("entry_data");
							JSONArray msg = (JSONArray) name1.get("ProfilePage");
							JSONObject data = (JSONObject) msg.get(0);
							JSONObject data2 = (JSONObject) data.get("user");
							JSONObject data3 = (JSONObject) data2.get("media");
							JSONArray msg2 = (JSONArray) data3.get("nodes");

							for (int i1 = 0; i1 < msg2.size(); i1++) {
								JSONObject data4 = (JSONObject) msg2.get(i1);
								//imgList.add(data4.get("thumbnail_src").toString());
								imgList.add(data4.get("display_src").toString());
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
		
		return imgList;
	}

}
