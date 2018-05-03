<%
/**
*   PURPOSE :   상시프로그램 insert action page
*   CREATE  :   201801230_tue    Ko
*   MODIFY  :   ....
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import ="org.jsoup.Jsoup"%>
<%@ page import ="org.jsoup.nodes.Document"%>
<%@ page import ="org.jsoup.select.Elements"%>
<%@ page import ="org.json.simple.JSONArray"%>
<%@ page import ="org.json.simple.JSONObject"%>
<%@ page import ="org.json.simple.parser.JSONParser"%>
<%!
class BanVO {
	public String year;
	public String month;
	public String day;
	public String name;
}
public List<BanVO> getVO(String year){
	String json 		= "";
	List<BanVO> banList	= new ArrayList<BanVO>();
	BanVO vo			= new BanVO();
	try {
		Document document = Jsoup.connect("https://apis.sktelecom.com/v1/eventday/days?month=&year="+year+"&type=h&day=")
				.userAgent("Mozilla")
				.ignoreContentType(true)
				.header("TDCProjectKey", "61816f66-5e21-42aa-9d76-eed601aa42d5")
				.header("referer", "https://developers.sktelecom.com/projects/project_53742147/services/EventDay/Analytics/")
				.header("Accept", "application/json")
				.get();
		Elements elem = document.select("body");

		for (org.jsoup.nodes.Element e : elem) {
	    	json += e.text();
		}
	    
	    JSONParser parser = new JSONParser();
	    Object obj = parser.parse( json );
	    JSONObject jsonObj = (JSONObject) obj;
	    
	    JSONArray jsonArr = (JSONArray) jsonObj.get("results");
	    
	    for (int i = 0; i < jsonArr.size(); i++) {
			JSONObject data = (JSONObject) jsonArr.get(i);
			vo = new BanVO();
			vo.year 	= data.get("year").toString();
			vo.month 	= data.get("month").toString();
			vo.day 		= data.get("day").toString();
			vo.name 	= data.get("name").toString();
			banList.add(vo);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return banList;
}
%>
<%
/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String mode				= parseNull(request.getParameter("mode"));

StringBuffer sql 		= null;
Object[] setObj 		= null;
int result 				= 0;
int count 				= 0;

Connection conn = null;
PreparedStatement pstmt = null;

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	int banno 			= 0;
	String pro_cat_nm 	= parseNull(request.getParameter("pro_cat_nm"));
	String pro_year 	= parseNull(request.getParameter("pro_year"));
	String pro_name 	= parseNull(request.getParameter("pro_name"));
	String aft_flag 	= parseNull(request.getParameter("aft_flag"));
	String max_per 		= parseNull(request.getParameter("max_per"));
	String show_flag 	= parseNull(request.getParameter("show_flag"));
	String pro_memo 	= parseNull(request.getParameter("pro_memo"));
	String reg_id	 	= parseNull(request.getParameter("reg_id"));
	String reg_ip	 	= parseNull(request.getParameter("reg_ip"));
	String pro_tch_nm	= parseNull(request.getParameter("pro_tch_nm"));
	
	try{
		sql = new StringBuffer();
		sql.append("INSERT INTO ART_PRO_ALWAY(									");
		sql.append("						PRO_NO,								");
		sql.append("						PRO_CAT,							");
		sql.append("						PRO_CAT_NM,							");
		sql.append("						PRO_NAME,							");
		sql.append("						PRO_MEMO,							");
		sql.append("						PRO_YEAR,							");
		sql.append("						REG_ID,								");
		sql.append("						REG_IP,								");
		sql.append("						REG_DATE,							");
		sql.append("						MOD_DATE,							");
		sql.append("						SHOW_FLAG,							");
		sql.append("						DEL_FLAG,							");
		sql.append("						MAX_PER,							");
		sql.append("						AFT_FLAG,							");
		sql.append("						PRO_TCH_NM							");
		sql.append("						)									");
		sql.append("VALUES(														");
		sql.append("						(SELECT NVL(MAX(PRO_NO)+1, 1)		");		//PRO_NO
		sql.append("						FROM ART_PRO_ALWAY),				");
		sql.append("						'ART_PRO_ALWAY',					");		//PRO_CAT
		sql.append("						?,									");		//PRO_CAT_NM
		sql.append("						?,									");		//PRO_NAME
		sql.append("						?,									");		//PRO_MEMO
		sql.append("						?,									");		//PRO_YEAR
		sql.append("						?,									");		//REG_ID
		sql.append("						?,									");		//REG_IP
		sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//REG_DATE
		sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//MOD_DATE
		sql.append("						?,									");		//SHOW_FLAG
		sql.append("						'N',								");		//DEL_FLAG
		sql.append("						?,									");		//MAX_PER
		sql.append("						?,									");		//AFT_FLAG
		sql.append("						?									");		//PRO_TCH_NM
		sql.append("		)													");
		
		setObj = new Object[]{
								pro_cat_nm,
								pro_name,
								pro_memo,
								pro_year,
								reg_id,
								reg_ip,
								show_flag,
								max_per,
								aft_flag,
								pro_tch_nm
							};
		
		result = jdbcTemplate.update(
					sql.toString(), 
					setObj
				);

		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) CNT		");
		sql.append("FROM ART_BAN_TABLE		");
		sql.append("WHERE YEAR = ?			");
		
		count = jdbcTemplate.queryForObject(
				sql.toString(), 
				new Object[]{pro_year},
				Integer.class
			);
		
		if(count <= 0){
			sqlMapClient.startTransaction();
		    conn    =   sqlMapClient.getCurrentConnection();
		    List<BanVO> banList = getVO(pro_year);
		    
			if(banList!=null && banList.size()>0){
				sql = new StringBuffer();
				sql.append("SELECT NVL(MAX(BANNO)+1,1) FROM ART_BAN_TABLE");
				banno = jdbcTemplate.queryForObject(
							sql.toString(),
							Integer.class
						);
				sql = new StringBuffer();
				sql.append("INSERT INTO ART_BAN_TABLE(				");
				sql.append("	BANNO,								");
				sql.append("	YEAR,								");
				sql.append("	BAN_NM,								");
				sql.append("	BAN_DATE,							");
				sql.append("	BAN_ETC								");
				sql.append(")										");
				sql.append("VALUES(									");
				sql.append("	?,									");
				sql.append("	?,									");
				sql.append("	?,									");
				sql.append("	?,									");
				sql.append("	''									");
				sql.append(")										");
				pstmt   =   conn.prepareStatement(sql.toString());
				
				for(BanVO ob : banList){
					pstmt.setInt(1, banno++);
					pstmt.setString(2, pro_year);
					pstmt.setString(3, ob.name);
					pstmt.setString(4, ob.year + "-" + ob.month + "-" + ob.day);
		            pstmt.addBatch();
				}
				int[] batchCount 	=   pstmt.executeBatch();
				result      		=   batchCount.length;
			}
		}
		
		
	}catch(Exception e){
		if(conn!=null){conn.close();}
		if(pstmt!=null){pstmt.close();}
		sqlMapClient.endTransaction();
		
		out.println(e.toString());
	}finally{
		if(conn!=null){conn.close();}
		if(pstmt!=null){pstmt.close();}
		sqlMapClient.endTransaction();
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			//out.println("location.replace('/program/art/admin/programAlwaysInsertPopup.jsp');");
			out.println("</script>");
		}
	}
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	String pro_no 	= parseNull(request.getParameter("pro_no"));

	try{
		sql = new StringBuffer();
		sql.append("UPDATE ART_PRO_ALWAY			");
		sql.append("	SET		DEL_FLAG = 'Y'		");
		sql.append("WHERE PRO_NO = ?				");
		
		setObj = new Object[]{
							pro_no
							};
		result = jdbcTemplate.update(
					sql.toString(), 
					setObj
				);
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('/program/art/admin/alwaysMng.jsp');");
			out.println("</script>");
		}
	}
}else if("update".equals(mode)){		//******************************** 수정 **************************************************************
	int banno			= 0;
	String pro_no 		= parseNull(request.getParameter("pro_no"));
	String pro_cat_nm 	= parseNull(request.getParameter("pro_cat_nm"));
	String pro_year 	= parseNull(request.getParameter("pro_year"));
	String pro_name 	= parseNull(request.getParameter("pro_name"));
	String aft_flag 	= parseNull(request.getParameter("aft_flag"));
	String max_per 		= parseNull(request.getParameter("max_per"));
	String show_flag 	= parseNull(request.getParameter("show_flag"));
	String pro_memo 	= parseNull(request.getParameter("pro_memo"));
	String reg_id	 	= parseNull(request.getParameter("reg_id"));
	String reg_ip	 	= parseNull(request.getParameter("reg_ip"));
	String pro_tch_nm	= parseNull(request.getParameter("pro_tch_nm"));

	try{
		sql = new StringBuffer();
		sql.append("UPDATE ART_PRO_ALWAY									");
		sql.append("	SET	PRO_CAT_NM 	= ?,								");
		sql.append("		PRO_NAME 	= ?,								");
		sql.append("		PRO_MEMO 	= ?,								");
		sql.append("		PRO_YEAR 	= ?,								");
		sql.append("		MOD_DATE 	= TO_CHAR(SYSDATE, 'YYYY-MM-DD'),	");
		sql.append("		SHOW_FLAG 	= ?,								");
		sql.append("		MAX_PER 	= ?,								");
		sql.append("		AFT_FLAG 	= ?,								");
		sql.append("		PRO_TCH_NM 	= ?									");
		sql.append("WHERE PRO_NO 		= ?									");
		
		setObj = new Object[]{
								pro_cat_nm,
								pro_name,
								pro_memo,
								pro_year,
								show_flag,
								max_per,
								aft_flag,
								pro_tch_nm,
								pro_no
							};
		
		result = jdbcTemplate.update(
					sql.toString(), 
					setObj
				);
		
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) CNT		");
		sql.append("FROM ART_BAN_TABLE		");
		sql.append("WHERE YEAR = ?			");
		
		count = jdbcTemplate.queryForObject(
				sql.toString(), 
				new Object[]{pro_year},
				Integer.class
			);
		
		if(count <= 0){
			sqlMapClient.startTransaction();
		    conn    =   sqlMapClient.getCurrentConnection();
		    List<BanVO> banList = getVO(pro_year);
		    
			if(banList!=null && banList.size()>0){
				sql = new StringBuffer();
				sql.append("SELECT NVL(MAX(BANNO)+1,1) FROM ART_BAN_TABLE");
				banno = jdbcTemplate.queryForObject(
							sql.toString(),
							Integer.class
						);
				sql = new StringBuffer();
				sql.append("INSERT INTO ART_BAN_TABLE(				");
				sql.append("	BANNO,								");
				sql.append("	YEAR,								");
				sql.append("	BAN_NM,								");
				sql.append("	BAN_DATE,							");
				sql.append("	BAN_ETC								");
				sql.append(")										");
				sql.append("VALUES(									");
				sql.append("	?,									");
				sql.append("	?,									");
				sql.append("	?,									");
				sql.append("	?,									");
				sql.append("	''									");
				sql.append(")										");
				pstmt   =   conn.prepareStatement(sql.toString());
				
				for(BanVO ob : banList){
					pstmt.setInt(1, banno++);
					pstmt.setString(2, pro_year);
					pstmt.setString(3, ob.name);
					pstmt.setString(4, ob.year + "-" + ob.month + "-" + ob.day);
		            pstmt.addBatch();
				}
				int[] batchCount 	=   pstmt.executeBatch();
				result      		=   batchCount.length;
			}
		}
	}catch(Exception e){
		if(conn!=null){conn.close();}
		if(pstmt!=null){pstmt.close();}
		sqlMapClient.endTransaction();
		
		out.println(e.toString());
	}finally{
		if(conn!=null){conn.close();}
		if(pstmt!=null){pstmt.close();}
		sqlMapClient.endTransaction();
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			//out.println("location.replace('/program/art/admin/programAlwaysInsertPopup.jsp?mode=update&pro_no="+pro_no+"');");
			out.println("</script>");
		}
	}
}
%>
