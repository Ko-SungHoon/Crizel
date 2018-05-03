<%
/**
*	PURPOSE	:	교육수첩 조직도 기관 등록 수행 JSP 파일
*	CREATE	:	20171108_wedns	JI
*	MODIFY	:	중복된 정렬이 발생했을 경우 back()   /   20171227_wed    JI
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/


//SessionManager sessionManager = new SessionManager(request);

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
String sql_str	=	"";

//	고정 parameters
String command	=	parseNull(request.getParameter("command"));		//insert1,2,3,4/update1,2,3,4

if (!command.equals("")) {
	command	=	command.substring(0,6);
} else {
	out.println("<script type='text/javascript'>");
	out.println("alert('파라미터 값 오류 입니다.');");
	out.println("location.replace('./sucheop_group.jsp');");
	out.println("</script>");
}

//	정보 parameters
String group_seq	=	parseNull(request.getParameter("group_seq"));
if (command.equals("")) {
	out.println("<script type='text/javascript'>");
	out.println("alert('파라미터 값 오류 입니다.');");
	out.println("location.replace('./sucheop_group.jsp');");
	out.println("</script>");
}

String search_fst_group	=	parseNull(request.getParameter("search_fst_group"), "-1");    //1차 기관 선택
String search_snd_group	=	parseNull(request.getParameter("search_snd_group"), "-1");    //2차 기관 선택
String search_trd_group	=	parseNull(request.getParameter("search_trd_group"), "-1");    //3차 기관 선택
String search_fth_group	=	parseNull(request.getParameter("search_fth_group"), "-1");    //4차 기관 선택

String fst_group_nm		=	parseNull(request.getParameter("fst_group_nm"));        //1차 기관 이름
String snd_group_nm		=	parseNull(request.getParameter("snd_group_nm"));        //2차 기관 이름
String trd_group_nm		=	parseNull(request.getParameter("trd_group_nm"));        //3차 기관 이름
String fth_group_nm		=	parseNull(request.getParameter("fth_group_nm"));        //4차 기관 이름
String fith_group_nm	=	parseNull(request.getParameter("fith_group_nm"));       //5차 기관 이름
String group_addr		=	parseNull(request.getParameter("group_addr"));			//기관 주소
String group_addr_post	=	parseNull(request.getParameter("group_addr_post"));		//기관 우편번호
String group_tel1		=	parseNull(request.getParameter("group_tel1"));			//기관 대표전화1
String group_tel2		=	parseNull(request.getParameter("group_tel2"));			//기관 대표전화2
String group_tel3		=	parseNull(request.getParameter("group_tel3"));			//기관 야간직통 번호1
String group_tel4		=	parseNull(request.getParameter("group_tel4"));			//기관 야간직통 번호2
String group_fax		=	parseNull(request.getParameter("group_fax"));			//기관 fax
String group_fax2		=	parseNull(request.getParameter("group_fax2"));			//기관 fax2
String group_url		=	parseNull(request.getParameter("group_url"));			//기관 URL
String alimi_url		=	parseNull(request.getParameter("alimi_url"));			//기관 알리미 URL
String school_yn		=	parseNull(request.getParameter("school_yn"));			//기관 학교 정보 여부
String show_yn			=	parseNull(request.getParameter("show_yn"));				//기관 노출 여부
String group_level		=	parseNull(request.getParameter("group_level"));			//기관 레벨
String group_depth		=	parseNull(request.getParameter("group_depth"));			//기관 레벨

int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;
List<Map<String, Object>> dataList2 = null;
List<Map<String, Object>> dataList3 = null;
List<Map<String, Object>> dataList4 = null;
List<Map<String, Object>> dataList5 = null;

boolean depthFlag   =   false;

try {

	//	그룹 레벨 확인
	String group_name	=	"";
	int group_lv		=	0;
	int	sel_parent_seq	=	-1;
	if (fst_group_nm.length() > 0) {
		group_lv	=	1;
		group_name	=	fst_group_nm;
	} else if (snd_group_nm.length() > 0) {
		group_lv	=	2;
		group_name	=	snd_group_nm;
		sel_parent_seq	=	Integer.parseInt(search_fst_group);
	} else if (trd_group_nm.length() > 0) {
		group_lv	=	3;
		group_name	=	trd_group_nm;
		sel_parent_seq	=	Integer.parseInt(search_snd_group);
	} else if (fth_group_nm.length() > 0) {
		group_lv	=	4;
		group_name	=	fth_group_nm;
		sel_parent_seq	=	Integer.parseInt(search_trd_group);
	} else if (fith_group_nm.length() > 0) {
		group_lv	=	5;
		group_name	=	fith_group_nm;
		sel_parent_seq	=	Integer.parseInt(search_fth_group);
	}


	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//	신규 
	if (command.equals("insert")) {
        
        /* 
        *   PURPOSE :   그룹 이름과 그룹 seq 체크
        *   CREATE  :   20171124_fri    JI
        *   MODIFY  :   ....
        */
        if (fst_group_nm.trim().equals("") && snd_group_nm.trim().equals("") && trd_group_nm.trim().equals("") && fth_group_nm.trim().equals("") && fith_group_nm.trim().equals("")) {
            out.println("<script>alert('자료가 명확하지 않습니다.\n확인 후 다시 등록해 주세요.');history.back();</script>");
            return;
        }
        /* END */
        
        //seq 호출 select
        sql	    =	new StringBuffer();
        sql_str =   "SELECT GROUP_SEQ FROM (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST ORDER BY GROUP_SEQ DESC) WHERE ROWNUM = 1";
        sql.append(sql_str);
        pstmt   =   conn.prepareStatement(sql.toString());
        rs = pstmt.executeQuery();
        int last_group_seq  =   1;
        if(rs.next()) {last_group_seq  =   rs.getInt("GROUP_SEQ") + 1;} else {last_group_seq=1;}
        
        //정식 insert sentence
		sql	=	new StringBuffer();
		sql_str	=	"INSERT INTO NOTE_GROUP_LIST ";
		sql_str	+=	"(GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS ";
		sql_str	+=	" , SCHOOL_FLAG, ADDR, ADDR_POST, TEL1, TEL2, TEL3, TEL4, FAX, FAX2, URL, ALIMI, SHOW_FLAG) ";
		sql_str	+=	"VALUES(";
		sql_str	+=	last_group_seq;
		sql_str	+=	", '"+ group_name +"'";
		sql_str	+=	", '" + group_lv + "' ";
        //그룹 정렬순서
		sql_str	+=	", (SELECT NVL(MAX(GROUP_DEPTH) + 1, '1') FROM (SELECT GROUP_DEPTH FROM NOTE_GROUP_LIST WHERE PARENT_SEQ = '"+ sel_parent_seq +"' ORDER BY GROUP_DEPTH DESC) WHERE ROWNUM = 1) ";
        
		sql_str	+=	", '" + sel_parent_seq + "' ";
		sql_str	+=	", TO_CHAR(SYSDATE,'YYYYMMDD')";
		sql_str	+=	", TO_CHAR(SYSDATE,'HH24MISS')";
		sql_str	+=	", '" + school_yn + "' ";
		sql_str	+=	", '" + group_addr + "' ";
		sql_str	+=	", '" + group_addr_post + "' ";
		sql_str	+=	", '" + group_tel1 + "' ";
		sql_str	+=	", '" + group_tel2 + "' ";
		sql_str	+=	", '" + group_tel3 + "' ";
		sql_str	+=	", '" + group_tel4 + "' ";
		sql_str	+=	", '" + group_fax + "' ";
		sql_str	+=	", '" + group_fax2 + "' ";
		sql_str	+=	", '" + group_url + "' ";
		sql_str	+=	", '" + alimi_url + "' ";
		sql_str	+=	", '" + show_yn + "' ";
		sql_str	+=	")";
		sql.append(sql_str);
		pstmt = conn.prepareStatement(sql.toString());
		result = pstmt.executeUpdate();

		if(result > 0){
			sqlMapClient.commitTransaction();
			out.println("insert success");
		}

	} else if (command.equals("update")) {
        /**
        *   PURPOSE :   중복된 정렬이 발생했을 경우 back()
        *   CREATE  :   20171227_wed    JI
        *   MODIFY  :   ...
        **/
        if (Integer.parseInt(group_depth) > 0) {
            sql     =   new StringBuffer();
            sql_str =   "SELECT GROUP_SEQ FROM NOTE_GROUP_LIST ";
            sql_str +=  " WHERE GROUP_SEQ != " + group_seq + " ";
            if (Integer.parseInt(search_fth_group) > 0) {
                sql_str	+=  " AND PARENT_SEQ = '" + search_fth_group + "'";
            } else if (Integer.parseInt(search_trd_group) > 0) {
                sql_str	+=  " AND PARENT_SEQ = '" + search_trd_group + "'";
            } else if (Integer.parseInt(search_snd_group) > 0) {
                sql_str	+=  " AND PARENT_SEQ = '" + search_trd_group + "'";
            } else if (Integer.parseInt(search_fst_group) > 0) {
                sql_str	+=  " AND PARENT_SEQ = '" + search_fst_group + "'";
            } else {
                sql_str	+=  " AND PARENT_SEQ = '-1'";
            }
            sql_str +=  " AND GROUP_DEPTH = '" + group_depth + "'";
            sql.append(sql_str);
            pstmt   =   conn.prepareStatement(sql.toString());
            rs      =   pstmt.executeQuery();
            if (rs.next()) {
                depthFlag   =   false;
                return;
            } else {
                depthFlag   =   true;
            }
        }

		if (group_seq != null && group_seq.length() > 0) {
			sql		=	new StringBuffer();
			sql_str	=	"UPDATE NOTE_GROUP_LIST SET ";
			sql_str	+=	"GROUP_NM = '" + group_name + "'";
			sql_str	+=	", MODIFY_DT = TO_CHAR(SYSDATE, 'YYYYMMDD')";
			sql_str	+=	", MODIFY_HMS = TO_CHAR(SYSDATE, 'HH24MISS')";
            if (Integer.parseInt(search_fth_group) > 0) {
                sql_str	+=  ", PARENT_SEQ = '" + search_fth_group + "'";
            } else if (Integer.parseInt(search_trd_group) > 0) {
                sql_str	+=  ", PARENT_SEQ = '" + search_trd_group + "'";
            } else if (Integer.parseInt(search_snd_group) > 0) {
                sql_str	+=  ", PARENT_SEQ = '" + search_trd_group + "'";
            } else if (Integer.parseInt(search_fst_group) > 0) {
                sql_str	+=  ", PARENT_SEQ = '" + search_fst_group + "'";
            } else {
                sql_str	+=  ", PARENT_SEQ = '-1'";
            }
            sql_str	+=	", GROUP_DEPTH = '" + group_depth + "'";
			sql_str	+=	", ADDR = '" + group_addr + "'";
			sql_str	+=	", ADDR_POST = '" + group_addr_post + "'";
			sql_str	+=	", TEL1 = '" + group_tel1 + "'";
			sql_str	+=	", TEL2 = '" + group_tel2 + "'";
			sql_str	+=	", TEL3 = '" + group_tel3 + "'";
			sql_str	+=	", TEL4 = '" + group_tel4 + "'";
			sql_str	+=	", FAX = '" + group_fax + "'";
			sql_str	+=	", FAX2 = '" + group_fax2 + "'";
			sql_str	+=	", URL = '" + group_url + "'";
			//sql_str	+=	", ALIMI = '" + alimi_url + "'";
			sql_str	+=	", SCHOOL_FLAG = '" + school_yn + "'";
			sql_str	+=	", SHOW_FLAG = '" + show_yn + "'";
			sql_str	+=	" WHERE GROUP_SEQ = '" + group_seq + "'";
			sql.append(sql_str);
			pstmt	=	conn.prepareStatement(sql.toString());

			result	=	pstmt.executeUpdate();

			if (result > 0) {
				sqlMapClient.commitTransaction();
				out.println("update success");
			}
		}
    //그룹 삭제
	} else if (command.equals("delete")) {


		//	나중에 method 처리나 for 문 처리하기
		sql = new StringBuffer();
		sql_str	=	"SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE PARENT_SEQ = '" + group_seq + "'";
		sql.append(sql_str);
		pstmt		=	conn.prepareStatement(sql.toString());
		rs			=	pstmt.executeQuery();
		dataList	=	getResultMapRows(rs);
        
		//2 group sel
		for (int i = 0; i < dataList.size(); i++) {
			Map<String, Object> dataMap	=	dataList.get(i);
			sql	=	new StringBuffer();
			sql_str	=	"SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE PARENT_SEQ = '" + parseNull((String)dataMap.get("GROUP_SEQ")) + "'";
			sql.append(sql_str);
			pstmt	=	conn.prepareStatement(sql.toString());
			rs		=	pstmt.executeQuery();
			dataList2	=	getResultMapRows(rs);
			//3 group sel
			for (int j = 0; j < dataList2.size(); j++) {
				Map<String, Object> dataMap2	=	dataList2.get(j);
				sql	=	new StringBuffer();
				sql_str	=	"SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE PARENT_SEQ = '" + parseNull((String)dataMap2.get("GROUP_SEQ")) + "'";
				sql.append(sql_str);
				pstmt	=	conn.prepareStatement(sql.toString());
				rs		=	pstmt.executeQuery();
				dataList3	=	getResultMapRows(rs);
				//4 group sel
				for (int k = 0; k < dataList3.size(); k ++) {
					Map<String, Object> dataMap3	=	dataList3.get(k);
                    sql	=	new StringBuffer();
                    sql_str	=	"SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE PARENT_SEQ = '" + parseNull((String)dataMap3.get("GROUP_SEQ")) + "'";
                    sql.append(sql_str);
                    pstmt	=	conn.prepareStatement(sql.toString());
                    rs		=	pstmt.executeQuery();
                    dataList4	=	getResultMapRows(rs);
///////////////////////////////////////////////////////////////////////////////////////////
                    //5group sel
                    for (int l = 0; l < dataList4.size(); l++) {
                        Map<String, Object> dataMap4	=	dataList4.get(l);
                        //5 mem del
                        sql	=	new StringBuffer();
                        sql_str	=	"DELETE FROM NOTE_GROUP_MEM WHERE GROUP_LIST_SEQ = " + parseNull((String)dataMap4.get("GROUP_SEQ"));
                        sql.append(sql_str);
                        pstmt	=	conn.prepareStatement(sql.toString());
                        result	=	pstmt.executeUpdate();
                        //5 group del
                        sql	=	new StringBuffer();
                        sql_str	=	"DELETE FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = " + parseNull((String)dataMap4.get("GROUP_SEQ"));
                        sql.append(sql_str);
                        pstmt	=	conn.prepareStatement(sql.toString());
                        result	=	pstmt.executeUpdate();
                        if (result > 0) {} else {break;}
                    }
///////////////////////////////////////////////////////////////////////////////////////////
					//4 mem del
					sql	=	new StringBuffer();
					sql_str	=	"DELETE FROM NOTE_GROUP_MEM WHERE GROUP_LIST_SEQ = " + parseNull((String)dataMap3.get("GROUP_SEQ"));
					sql.append(sql_str);
					pstmt	=	conn.prepareStatement(sql.toString());
					result	=	pstmt.executeUpdate();
					//4 group del
					sql	=	new StringBuffer();
					sql_str	=	"DELETE FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = " + parseNull((String)dataMap3.get("GROUP_SEQ"));
					sql.append(sql_str);
					pstmt	=	conn.prepareStatement(sql.toString());
					result	=	pstmt.executeUpdate();
					if (result > 0) {} else {break;}
				}//end for
				//3 mem del
				sql	=	new StringBuffer();
				sql_str	=	"DELETE FROM NOTE_GROUP_MEM WHERE GROUP_LIST_SEQ = " + parseNull((String)dataMap2.get("GROUP_SEQ"));
				sql.append(sql_str);
				pstmt	=	conn.prepareStatement(sql.toString());
				result	=	pstmt.executeUpdate();
				//3 group del
				sql	=	new StringBuffer();
				sql_str	=	"DELETE FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = " + parseNull((String)dataMap2.get("GROUP_SEQ"));
				sql.append(sql_str);
				pstmt	=	conn.prepareStatement(sql.toString());
				result	=	pstmt.executeUpdate();
				if (result > 0) {} else {break;}
			}//end for
			//2 mem del
			sql	=	new StringBuffer();
			sql_str	=	"DELETE FROM NOTE_GROUP_MEM WHERE GROUP_LIST_SEQ = " + parseNull((String)dataMap.get("GROUP_SEQ"));
			sql.append(sql_str);
			pstmt	=	conn.prepareStatement(sql.toString());
			result	=	pstmt.executeUpdate();
			//2 group del
			sql	=	new StringBuffer();
			sql_str	=	"DELETE FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = " + parseNull((String)dataMap.get("GROUP_SEQ"));
			sql.append(sql_str);
			pstmt	=	conn.prepareStatement(sql.toString());
			result	=	pstmt.executeUpdate();
			if (result > 0) {} else {break;}
		}//end for
		//1 mem del
		sql	=	new StringBuffer();
		sql_str	=	"DELETE FROM NOTE_GROUP_MEM WHERE GROUP_LIST_SEQ = " + group_seq;
		sql.append(sql_str);
		pstmt	=	conn.prepareStatement(sql.toString());
		result	=	pstmt.executeUpdate();
		out.println(sql.toString());
		//1 group del
		sql	=	new StringBuffer();
		sql_str	=	"DELETE FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = " + group_seq;
		sql.append(sql_str);
		pstmt	=	conn.prepareStatement(sql.toString());
		result	=	pstmt.executeUpdate();
		if (result > 0) {} else {out.println("delte fail group"); return;}

		out.println("delete success");
	}

} catch (Exception e) {

	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 

} finally {

	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
    String outHtml  =   "";
    if (command.equals("delete")) {
        if (result > 0) {
            outHtml +=  "<script>alert('정상적으로 삭제되었습니다.');";
            outHtml +=  "location.replace('./sucheop_group.jsp');</script>";
            out.println(outHtml);
        } else {
            outHtml +=  "<script>alert('처리 중 오류가 발생하였습니다.');";
            outHtml +=  "history.back();</script>";
            out.println(outHtml);
        }
    } else if (command.equals("update")) {
        if (result > 0) {
            outHtml +=  "<script>alert('정상적으로 수정되었습니다.');";
            outHtml +=  "opener.location.reload();window.close();</script>";
            out.println(outHtml);
        } else if (!depthFlag) {
            out.println("<script>");
            out.println("alert('중복된 정렬순서값이 존재합니다.');");
            out.println("history.back();");
            out.println("</script>");
        } else {
            outHtml +=  "<script>alert('처리 중 오류가 발생하였습니다.');";
            outHtml +=  "history.back();</script>";
            out.println(outHtml);
        }
    } else {
        if (result > 0) {
            outHtml +=  "<script>alert('정상적으로 등록되었습니다.');";
            outHtml +=  "opener.location.reload();window.close();</script>";
            out.println(outHtml);
        } else {
            outHtml +=  "<script>alert('처리 중 오류가 발생하였습니다.');";
            outHtml +=  "opener.location.reload();window.close();</script>";
            out.println(outHtml);
        }
    }
}

%>