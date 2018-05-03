<%
/**
*   PURPOSE :   업무분장 출력 페이지
*   CREATE  :   2017......  who
*   MODIFY  :   "마지막에 '과'가 붙을 경우 과 대신 '담당'을 replace 하라는 요청  /   20180102_tue    JI
*   MODIFY  :   복수의 성명이 나타날 시 " " 에 br 대치 요청  /   20180102_tue    JI
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="org.springframework.util.StringUtils" %>
<%
String err ="";
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

//String o_cd    = parseNull(request.getParameter("o_cd"),"1000001002000"); //데이터 없으면 총무과 기본으로 보여주게 세팅
SessionManager sessionManager = new SessionManager(request);

String standard_yyyy = "";
String standard_mm   = "";
String standard_dd   = "";

List<Map<String, Object>> officeListHd = null;	//3레벨 리스트
List<Map<String, Object>> deptList     = null;	//입력받은 3레벨 기준의 4레벨 조직정보
List<Map<String, Object>> officeListDt = null;	//4레벨 조직정보별 업무분장 데이터 리스트

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	/* 기준일자 출력 */
	sql = new StringBuffer();
	sql.append("  SELECT                          \n");
    sql.append("          MAX(A.STANDARD_DT) AS STANDARD_DT                                         \n");
    sql.append("        , SUBSTR(MAX(A.STANDARD_DT),1,4) AS STANDARD_YYYY                           \n");
    sql.append("        , SUBSTR(MAX(A.STANDARD_DT),5,2) AS STANDARD_MM                           \n");
    sql.append("        , SUBSTR(MAX(A.STANDARD_DT),7,2) AS STANDARD_DD                           \n");
	sql.append("     FROM DIVISION_WORK A         \n");
	sql.append("     WHERE A.OFFICE_CD = '"+o_cd+"' \n");
	sql.append("     ORDER BY A.SORT_ORDER        \n");
	
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();	
	officeListHd = getResultMapRows(rs);
	
	if(officeListHd != null && officeListHd.size() > 0){
		Map<String,Object> map = officeListHd.get(0);
		standard_yyyy        = parseNull((String)map.get("STANDARD_YYYY"));
		standard_mm          = parseNull((String)map.get("STANDARD_MM"));
		standard_dd          = parseNull((String)map.get("STANDARD_DD"));
		
		if(!"".equals(parseNull(standard_mm))){
			String temp = standard_mm.substring(0,1);
			
			if("0".equals(temp)){
				standard_mm = standard_mm.substring(1);
			}
		}
		
		if(!"".equals(parseNull(standard_dd))){
			String temp1 = standard_dd.substring(0,1);
			
			if("0".equals(temp1)){
				standard_dd = standard_dd.substring(1);
			}
		}
	}
	
	/* 조직정보  */
	sql = new StringBuffer();
	sql.append("SELECT TRIM(A.OFFICE_CD) OFFICE_CD , TRIM(A.OFFICE_NM) OFFICE_NM , (SELECT MAX(SORT_ORDER) FROM DIVISION_WORK WHERE OFFICE_NM = A.OFFICE_NM) SORT_ORDER 				\n");
	sql.append("FROM RFC_COMTCOFFICE A LEFT JOIN DIVISION_WORK B																					\n");
	sql.append("ON A.OFFICE_NM = B.OFFICE_NM																										\n");
	sql.append("WHERE A.OFFICE_CD LIKE '%'||SUBSTR('"+o_cd+"',1,10)||'%'																			\n");
	if("1000004002000".equals(o_cd)){
		sql.append("OR A.OFFICE_CD LIKE '%'||SUBSTR('1000001001000',1,10)||'%'																		\n");	//총무과일경우	
		sql.append("OR A.OFFICE_CD LIKE '%'||SUBSTR('1000002001000',1,10)||'%'																		\n");	//교육감실,부교육감실	
		sql.append("OR A.OFFICE_CD LIKE '%'||SUBSTR('1000004001000',1,10)||'%'																		\n");	//,행정국장실 추가
	}	
	sql.append("GROUP BY A.OFFICE_CD, A.OFFICE_NM																									\n");
	//sql.append("   AND OFFICE_DP = 4                   \n");
	sql.append("ORDER BY SORT_ORDER NULLS FIRST            \n");
	
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();	
	deptList = getResultMapRows(rs);


	if(officeListHd != null && officeListHd.size() > 0){ %>
	<h3><%=standard_yyyy %>년 <%=standard_mm %>월 <%=standard_dd %>일 기준</h3>
	<%} %>

	<div class="work_new">
	<%if(deptList != null && deptList.size() > 0){ 
			for(int j=0; j<deptList.size(); j++){
				Map<String,Object> deptMap = deptList.get(j);
				String dept_office_cd = parseNull((String)deptMap.get("OFFICE_CD"));
				String dept_office_nm = parseNull((String)deptMap.get("OFFICE_NM"));
				
				/* 조직별 업무분장  */
				sql = new StringBuffer();
				sql.append("   SELECT                               \n");
				sql.append("       E_SEQ                            \n");
				sql.append("     , EMPLYR_NM                        \n");
				sql.append("     , POSITION_NM                      \n");
				sql.append("     , OFFICE_CD                        \n");
				sql.append("     , OFFICE_NM                        \n");
				sql.append("     , OFFICE_PT_MEMO                   \n");
				sql.append("     , OFFICE_TEL                       \n");
				sql.append("     , AGENT_ID                         \n");
				sql.append("     , AGEN_NM                          \n");
				sql.append("     , STANDARD_DT                      \n");
				sql.append("     , REG_DT                           \n");
				sql.append("     , REG_ID                           \n");
				sql.append("     , MOD_DT                           \n");
				sql.append("     , MOD_ID                           \n");
				sql.append("     , SORT_ORDER                       \n");
				sql.append("     , OFFICE_DP                        \n");
				sql.append("	FROM DIVISION_WORK               	 \n");
				sql.append("	WHERE OFFICE_NM = '"+dept_office_nm+"'   \n");
				if("1000004002000".equals(o_cd)){
					sql.append("	AND OFFICE_CD LIKE '%'||'1000004002000'||'%'  \n");							//총무과일 경우 
				}else{
					sql.append("	AND OFFICE_CD LIKE '%'||'"+dept_office_cd.substring(0,10)+"'||'%'  \n");
				}
				
				sql.append("	ORDER BY SORT_ORDER ASC             \n");
				
				pstmt = conn.prepareStatement(sql.toString());
				rs = pstmt.executeQuery();	
				officeListDt = getResultMapRows(rs);
				if(officeListDt != null && officeListDt.size() > 0){
	%>
				<section class="buseo_juyo">
					<h3>
					<%
					if("교육협력관".equals(dept_office_nm) || "교육감실".equals(dept_office_nm) || "부교육감실".equals(dept_office_nm) || "행정국장실".equals(dept_office_nm)){
					%>
					<%=dept_office_nm%>
                    <%
                    /**
                    *   PURPOSE :   "마지막에 '과'가 붙을 경우 과 대신 '담당'을 replace 하라는 요청
                    *   CREATE  :   20180102_tue
                    *   MODIFY  :   "관" 추가 / 20180103_wed   JI
                    **/
                    } else if ((dept_office_nm != null && dept_office_nm.length() > 0) && ("학교혁신과".equals(dept_office_nm) || "초등교육과".equals(dept_office_nm) || "중등교육과".equals(dept_office_nm) || "창의인재과".equals(dept_office_nm) || "체육건강과".equals(dept_office_nm) || "학생생활과".equals(dept_office_nm) || "총무과".equals(dept_office_nm) || "교육복지과".equals(dept_office_nm) || "재정과".equals(dept_office_nm) || "시설과".equals(dept_office_nm) || "학교지원과".equals(dept_office_nm) || "지식정보과".equals(dept_office_nm) || "감사관".equals(dept_office_nm) || "홍보담당관".equals(dept_office_nm) || "정책기획관".equals(dept_office_nm) || "안전총괄담당관".equals(dept_office_nm) || "적정규모학교추진단".equals(dept_office_nm))) {
                        out.println(dept_office_nm);
                    /** END **/
                    %>
					<%
					}else{
					%>
					<%=dept_office_nm%>담당
					<%
					}				
					%>
					 업무분장</h3>
					<table class="tbl_type01 c5">
						<caption><%= dept_office_nm%>의 직위·직급, 성명, 전화번호, 담당업무, 업무대행자를 나타내고 있습니다.</caption>
						<colgroup><col class="wps_15" /><col class="wps_15" /><col class="wps_15" /><col  /><col class="wps_15" /></colgroup>
						<thead>
							<tr>
								<th scope="col">직위·직급</th>
								<th scope="col">성명</th>
								<th scope="col">전화번호</th>
								<th scope="col">담당업무</th>
								<th scope="col">업무대행자</th>
							</tr>
						</thead>
						<tbody>
							<%
							
							
								for(int k=0; k<officeListDt.size(); k++){
									Map<String,Object> dtMap = officeListDt.get(k);
									String dt_e_seq      	 = parseNull((String)dtMap.get("E_SEQ"));
									String dt_emplyr_nm      = parseNull((String)dtMap.get("EMPLYR_NM"));
									String dt_position_nm    = parseNull((String)dtMap.get("POSITION_NM"));
									String dt_office_cd      = parseNull((String)dtMap.get("OFFICE_CD"));
									String dt_office_nm      = parseNull((String)dtMap.get("OFFICE_NM"));
									String dt_office_pt_memo = parseNull((String)dtMap.get("OFFICE_PT_MEMO"));
									String dt_office_tel     = parseNull((String)dtMap.get("OFFICE_TEL"));
									String dt_agent_id       = parseNull((String)dtMap.get("AGENT_ID"));
									String dt_agen_nm        = parseNull((String)dtMap.get("AGEN_NM"));
                                    /**
                                    *   PURPOSE :   복수의 성명이 나타날 시 " " 에 br 대치 요청
                                    *   CREATE  :   20180102_tue    JI
                                    *   MODIFY  :   ....
                                    **/
                                    if (dt_agen_nm != null && dt_agen_nm.length() > 0) {
                                        dt_agen_nm               = dt_agen_nm.replaceAll("\\p{Z}", "<br>");
                                        dt_agen_nm               = dt_agen_nm.replaceAll("\n", "<br>");
                                    }
                                    /** END **/
									String dt_standard_dt    = parseNull((String)dtMap.get("STANDARD_DT"));
									String dt_reg_dt         = parseNull((String)dtMap.get("REG_DT"));
									String dt_reg_id         = parseNull((String)dtMap.get("REG_ID"));
									String dt_mod_dt         = parseNull((String)dtMap.get("MOD_DT"));
									String dt_mod_id         = parseNull((String)dtMap.get("MOD_ID"));
									String dt_sort_order     = parseNull((String)dtMap.get("SORT_ORDER"));
									String dt_office_dp      = parseNull((String)dtMap.get("OFFICE_DP"));
									dt_office_pt_memo = dt_office_pt_memo.replace("\n","<br>");
							%>
							<tr>
								<td><%=dt_position_nm %></td>
								<td><%=dt_emplyr_nm %></td>
								<td><%=dt_office_tel %></td>
								<td class="l">
									<%=dt_office_pt_memo %>
								</td>
								<td><span class="name_align"><%=dt_agen_nm %></span></td>
							</tr>
							<%	}
							%>
						</tbody>
					</table>
				</section>
				
	<%	
				}
		}
	} 
%>

<%
} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	err = e.getMessage();
	//out.print(e.getMessage());
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>
</div>