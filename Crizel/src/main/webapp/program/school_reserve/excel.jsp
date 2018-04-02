<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<html>
<head>
<title>excel</title>
<meta charset="UTF-8">
</head>
<body>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String pageTitle = "통계 관리";
//String excelFileName = new String(pageTitle.getBytes("KSC5601"), "8859_1");

//******************************MS excel******************************
//MS excel로 다운로드/실행, filename에 저장될 파일명을 적어준다.


String fileName = pageTitle;
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");
response.setHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls;");
response.setHeader("Content-Description", "JSP Generated Data");
   
//↓ 이걸 풀어주면 열기/저장 선택창이 뜨는 게 아니라 그냥 바로 저장된다.
response.setContentType("application/vnd.ms-excel");
//*********************************************************************

		int cnt = 0;
		int totalCount = 0;
		String sid = "";
		String title = "";
		String addr = "";
		String url = "";
		String email = "";
		String tel = "";
		String fax = "";
		String area_type = "";
		String coedu = "";
		String cate1 = "";
		String cate2 = "";
		String post = "";
		String search1 = request.getParameter("search1")==null?"":request.getParameter("search1");
		String keyword = request.getParameter("keyword")==null?"":request.getParameter("keyword");
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> dataList = null;
		Connection conn = null;
		StringBuffer sql = new StringBuffer();
		try {
			sqlMapClient.startTransaction();
			conn = sqlMapClient.getCurrentConnection();	
			
			sql = new StringBuffer();
			sql.append("SELECT * \n");
			sql.append("FROM SCHOOL_SEARCH \n");
			sql.append("ORDER BY SID DESC \n");
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			dataList = getResultMapRows(rs);
		
		} catch (Exception e) {
			e.printStackTrace();
			sqlMapClient.endTransaction();
			alertBack(out, "처리중 오류가 발생하였습니다.");
		} finally {
			if (rs != null) try { rs.close(); } catch (SQLException se) {}
			if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
			if (conn != null) try { conn.close(); } catch (SQLException se) {}
			sqlMapClient.endTransaction();
		}
		%>
<table class="bbs_list">
<thead>
<tr>
	<th >학교형태</th>
	<th >지역구분</th>
	<th >설립구분</th>
	<th >학교명</th>
	<th >우편번호</th>
	<th >주소</th>
	<th >홈페이지</th>
	<th >전화번호</th>
	<th >팩스번호</th>
	<th >남여공학</th>
	
</tr>
</thead>
<tbody>
<%
if(dataList!=null){
	for(int i=0; i<dataList.size(); i++){
		Map<String,Object> map = dataList.get(i);
		sid = parseNull(map.get("SID").toString());
		title = parseNull(map.get("TITLE").toString());
		addr = parseNull(map.get("ADDR").toString());
		url = parseNull(map.get("URL").toString());
		tel = parseNull(map.get("TEL").toString());
		fax = parseNull(map.get("FAX").toString());
		area_type = parseNull(map.get("AREA_TYPE").toString());
		coedu = parseNull(map.get("COEDU").toString());
		cate1 = parseNull(map.get("CATE1").toString());
		cate2 = parseNull(map.get("CATE2").toString());
		post = parseNull(map.get("POST").toString());
%>
	<tr>
		<td><%=cate1 %></td>
		<td><%=area_type%></td>
		<td><%=cate2 %></td>
		<td><%=title %></td>
		<td><%=post %></td>
		<td><%=addr %></td>
		<td><%=url%></td>
		<td><%=tel%></td>
		<td><%=fax%></td>
		<td><%=coedu %></td>
	</tr>
<%
	}
}else{
%>
	<tr>
		<td colspan="10">데이터가 없습니다.</td>
	</tr>
<%
}
%>
</tbody>
</table>
					
</body>
</html>