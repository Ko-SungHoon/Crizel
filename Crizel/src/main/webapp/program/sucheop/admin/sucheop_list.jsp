<%
/**
*	PURPOSE	:	교육수첩 교원 관리 페이지
*	CREATE	:	20171103_fri	JI
*	MODIFY	:	휴대폰 확인 로그 쌓기 추가  /   20171215_fri    JI
*	MODIFY	:	add show flag column /   20171226_tue    JI
*/

%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

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

//Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;
String sql_str          =   "";
String sql_where        =   "";
int key                 =   0;
int result              =   0;
List<Map<String, Object>> cateList	=	null;
List<Map<String, Object>> cateList2	=	null;
List<Map<String, Object>> cateList3	=	null;
List<Map<String, Object>> cateList4	=	null;
List<Map<String, Object>> cateList5	=	null;
List<Map<String, Object>> dataList  =   null;

//	parameters
String row_num          =	parseNull(request.getParameter("row_num"));
String group_lv         =   parseNull(request.getParameter("group_lv"));
String group_lv_img     =   parseNull(request.getParameter("group_lv_img"));
String group_name       =   parseNull(request.getParameter("group_name"));
String mem_seq          =	parseNull(request.getParameter("mem_seq"));
String group_list_seq   =	parseNull(request.getParameter("group_list_seq"));
String mem_nm           =	parseNull(request.getParameter("mem_nm"));
String mem_grade        =	parseNull(request.getParameter("mem_grade"));
String mem_level        =	parseNull(request.getParameter("mem_level"));
String mem_tel          =	parseNull(request.getParameter("mem_tel"));
String mem_mobile       =	parseNull(request.getParameter("mem_mobile"));
String mem_sso_id       =	parseNull(request.getParameter("mem_sso_id"));
String mem_reg          =	parseNull(request.getParameter("mem_reg"));
String mem_modify       =	parseNull(request.getParameter("mem_modify"));
String show_flag        =   parseNull(request.getParameter("show_flag"));

//	검색
String search_fst_group     =	parseNull(request.getParameter("search_fst_group"), "-1");    //1차 기관
String search_snd_group     =	parseNull(request.getParameter("search_snd_group"), "-1");    //2차 기관
String search_trd_group     =	parseNull(request.getParameter("search_trd_group"), "-1");    //3차 기관
String search_fth_group     =	parseNull(request.getParameter("search_fth_group"), "-1");    //4차 기관
String search_fith_group     =	parseNull(request.getParameter("search_fith_group"), "-1");    //5차 기관
String search_group_keyword =   parseNull(request.getParameter("search_group_keyword"), "");    //기관명 검색
String search_name_keyword  =   parseNull(request.getParameter("search_name_keyword"), "");    //기관명 검색

int totalCnt        =   0;

String sessionName  =   "";             //로그인 유저 이름
String sessionNum   =   "";             //로그인 유저 phoneNum
//String sessionId    =   "";             //로그인 유저 Id
String lastLogSeq   =   "1";            //NOTE_MVIEW_LOG 마지막 log_seq

sessionName =   parseNull(sessionManager.getName(), "");            //유저 이름
sessionNum  =   parseNull(sessionManager.getUserHomepage(), "");    //유저 phoneNum
sessionId   =   parseNull(sessionManager.getId(), "");              //유저 Id

//	1차 그룹 리스트 call
try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

    /**
    *   PURPOSE :   교원관리 페이지 호출 시 "휴대폰 확인 로그 쌓기"
    *   CREATE  :   20171215_fri    JI
    *   MODIFY  :   ....
    **/
    //NOTE_MVIEW_LOG INSERT
    //last log_seq select or log_seq set 1
    sql     =   new StringBuffer();
    sql_str =   "SELECT * FROM (SELECT * FROM NOTE_MVIEW_LOG ORDER BY LOG_SEQ DESC) WHERE ROWNUM = 1";
    sql.append(sql_str);
    pstmt   =   conn.prepareStatement(sql.toString());
    rs      =   pstmt.executeQuery();
    if (rs.next()) {lastLogSeq  =   Integer.toString(rs.getInt("LOG_SEQ") + 1);}
    
    //INSERT
    sql     =   new StringBuffer();
    sql_str =   "INSERT INTO NOTE_MVIEW_LOG ";
    //sql_str +=  " (LOG_SEQ, CERT_MOBILE_ID, CERT_MOBILE_NUM, SEARCH_GROUP, SEARCH_MEM, CHK_DATETIME, VIEW_URL, VIEW_TITLE, CERT_NAME, IP_ADDR) ";
    sql_str +=  " (LOG_SEQ, CERT_MOBILE_ID, SEARCH_GROUP, SEARCH_MEM, CHK_DATETIME, VIEW_URL, VIEW_TITLE, CERT_NAME, IP_ADDR) ";
    sql_str +=  " VALUES ";
    sql_str +=  " ('"+ lastLogSeq +"'";     //last seq
    sql_str +=  " , '"+ sessionId +"'";       //certification id
    //sql_str +=  " , '"+ sessionNum +"'";      //certification mobile num
    sql_str +=  " , '"+ search_group_keyword +"'";     //group search value
    sql_str +=  " , '"+ search_name_keyword +"'";       //mem search value
    sql_str +=  " , TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') "; //view datetime
    sql_str +=  " , '/program/sucheop/admin/sucheop_list.jsp?search_group_keyword=" + search_group_keyword + "&searchMem=" + search_name_keyword + "' ";    //present url address
    sql_str +=  " , 'RFC 교원관리' ";       //present url address
    sql_str +=  " , '" + sessionName + "' "; //certification user name
    sql_str +=  " , '" + request.getRemoteAddr() + "' ";    //certification user ipaddr
    sql_str +=  " ) ";
    sql.append(sql_str);
    pstmt   =   conn.prepareStatement(sql.toString());
    pstmt.executeUpdate();
    /** END **/
    
	sql	=	new StringBuffer();
	sql_str	=	"SELECT * FROM NOTE_GROUP_LIST WHERE GROUP_LV = 1 ORDER BY GROUP_SEQ ASC";
	sql.append(sql_str);
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	cateList = getResultMapRows(rs);
    
    //  1차 기관 parent 2차 기관 query
	if (Integer.parseInt(search_fst_group) > 0) {
        
            sql			=	new StringBuffer();
            sql_str		=	"SELECT A.* FROM NOTE_GROUP_LIST A ";
            sql_str		+=	" WHERE A.GROUP_LV = 2 ";
            sql_str		+=	" AND A.PARENT_SEQ = " + search_fst_group + " ";
            sql_str		+=	" ORDER BY A.GROUP_SEQ ASC";
            sql.append(sql_str);
            pstmt		=	conn.prepareStatement(sql.toString());
            rs			=	pstmt.executeQuery();
            cateList2	=	getResultMapRows(rs);

        //	2차 기관 parent 3차 기관 query
        if (Integer.parseInt(search_snd_group) > 0) {
            sql			=	new StringBuffer();
            sql_str		=	"SELECT A.* FROM NOTE_GROUP_LIST A ";
            sql_str		+=	" WHERE A.GROUP_LV = 3 ";
            sql_str		+=	" AND A.PARENT_SEQ = " + search_snd_group + " ";
            sql_str		+=	" ORDER BY A.GROUP_SEQ ASC";
            sql.append(sql_str);
            pstmt		=	conn.prepareStatement(sql.toString());
            rs			=	pstmt.executeQuery();
            cateList3	=	getResultMapRows(rs);

            //	3차 기관 parent 4차 기관 query
            if (Integer.parseInt(search_trd_group) > 0) {
                sql			=	new StringBuffer();
                sql_str		=	"SELECT A.* FROM NOTE_GROUP_LIST A ";
                sql_str		+=	" WHERE A.GROUP_LV = 4 ";
                sql_str		+=	" AND A.PARENT_SEQ = " + search_trd_group + " ";
                sql_str		+=	" ORDER BY A.GROUP_SEQ ASC";
                sql.append(sql_str);
                pstmt		=	conn.prepareStatement(sql.toString());
                rs			=	pstmt.executeQuery();
                cateList4	=	getResultMapRows(rs);
                //	4차 기관 parent 5차 기관 query
                if (Integer.parseInt(search_fth_group) > 0) {
                    sql			=	new StringBuffer();
                    sql_str		=	"SELECT A.* FROM NOTE_GROUP_LIST A ";
                    sql_str		+=	" WHERE A.GROUP_LV = 5 ";
                    sql_str		+=	" AND A.PARENT_SEQ = " + search_fth_group + " ";
                    sql_str		+=	" ORDER BY A.GROUP_SEQ ASC";
                    sql.append(sql_str);
                    pstmt		=	conn.prepareStatement(sql.toString());
                    rs			=	pstmt.executeQuery();
                    cateList5	=	getResultMapRows(rs);
                }
            }
        }
    }// ./end 기관 list query
    
    //교원 list query
    sql         =   new StringBuffer();
    sql_str     =   "SELECT ";
    sql_str     +=  " SUBSTR(B.MEM_TEL,1,3)||'-'||SUBSTR(B.MEM_TEL,4,3)||'-'||SUBSTR(B.MEM_TEL,7,4) AS MEM_TEL ";
    sql_str     +=  " , SUBSTR(B.MEM_MOBILE,1,3)||'-'||SUBSTR(B.MEM_MOBILE,4,4)||'-'||SUBSTR(B.MEM_MOBILE,8,4) AS MEM_MOBILE ";
    sql_str     +=  " , B.* FROM (";
    sql_str     +=   " SELECT ";
    sql_str     +=  "   ROWNUM AS RNUM ";
    sql_str     +=  "   , (SELECT GROUP_NM FROM NOTE_GROUP_LIST G WHERE G.GROUP_SEQ = A.GROUP_LIST_SEQ) AS GROUP_NAME ";
    sql_str     +=  "   , (SELECT GROUP_LV FROM NOTE_GROUP_LIST G WHERE G.GROUP_SEQ = A.GROUP_LIST_SEQ) AS GROUP_LV ";
    sql_str     +=  "   , TO_CHAR(TO_DATE(A.REG_DT||A.REG_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS MEM_REG";
    sql_str     +=  "   , TO_CHAR(TO_DATE(A.MODIFY_DT||A.MODIFY_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS MODIFY_REG";
    sql_str     +=  "   , A.*";
    sql_str     +=  " FROM NOTE_GROUP_MEM A ) B ";
    if (Integer.parseInt(search_fst_group) > 0) {
        sql_where   =   " WHERE GROUP_LIST_SEQ = '" + search_fst_group + "' ";
        if (Integer.parseInt(search_snd_group) > 0) {
        sql_where   =   " WHERE GROUP_LIST_SEQ = '" + search_snd_group + "' ";
            if (Integer.parseInt(search_trd_group) > 0) {
        sql_where   =   " WHERE GROUP_LIST_SEQ = '" + search_trd_group + "' ";
                if (Integer.parseInt(search_fth_group) > 0) {
        sql_where   =   " WHERE GROUP_LIST_SEQ = '" + search_fth_group + "' ";
                    if (Integer.parseInt(search_fith_group) > 0) {
        sql_where   =   " WHERE GROUP_LIST_SEQ = '" + search_fith_group + "' ";
        }   }   }   }
        //기관, 성명 검색어 존재 여부
        if (search_group_keyword.length() > 0 || search_name_keyword.length() > 0) {
            sql_where   +=  " AND MEM_NM LIKE '%" + search_name_keyword + "%' AND GROUP_NAME LIKE '%" + search_group_keyword + "%'";
        }
    } else {
        //기관, 성명 검색어 존재 여부
        if (search_group_keyword.length() > 0  || search_name_keyword.length() > 0 ) {
            sql_where   +=  " WHERE MEM_NM LIKE '%" + search_name_keyword + "%' AND GROUP_NAME LIKE '%" + search_group_keyword + "%'";
        }
    }
    sql_str     +=  sql_where + " ORDER BY MEM_SEQ ASC ";
    sql.append(sql_str);
    pstmt       =   conn.prepareStatement(sql.toString());
    rs          =   pstmt.executeQuery();
    
    dataList    =   getResultMapRows(rs);

} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}

//총 인원 확인
totalCnt    =   dataList.size();

%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 교원 관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

	<script>

		$(function() {

			$("#chkAll").click(function(){
				//만약 전체 선택 체크박스가 체크된상태일경우
				if($("#chkAll").prop("checked")) {
					//해당화면에 전체 checkbox들을 체크해준다
					$("input[type=checkbox]").prop("checked",true);
					// 전체선택 체크박스가 해제된 경우
				} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
					$("input[type=checkbox]").prop("checked",false);
				}
			});

			//select box 동적 DB conn
			$("#search_fst_group").change(function () {
				var group_val	=	$(this).val();
				setSelect (group_val, 1);
			});
			//select box 동적 DB conn
			$("#search_snd_group").change(function () {
				var group_val	=	$(this).val();
				setSelect (group_val, 2);
			});
			//select box 동적 DB conn
			$("#search_trd_group").change(function () {
				var group_val	=	$(this).val();
				setSelect (group_val, 3);
			});
            //select box 동적 DB conn
			$("#search_fth_group").change(function () {
				var group_val	=	$(this).val();
				setSelect (group_val, 4);
			});

		});

		//select box 동적 function
		function setSelect (group_seq, level) {

			if (group_seq < 0 || !group_seq) {
				if (level == 1) {
					$("#search_snd_group").html("<option value=\"-1\">-- 2차 기관 --</option>");
					$("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>");
					$("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
					$("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
				} else if (level == 2) {
					$("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>");
					$("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
                    $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
				} else if (level == 3) {
					$("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
                    $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
				} else if (level == 4) {
                    $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
				}
				return;
			}

			var url         =   "./selectbox_conn.jsp";
			var from_data   =   {group_seq: group_seq};

			$.ajax({
				url: url,
				type: 'POST',
				data: from_data,
				dataType: 'text',
				timeout: 10000,
				success: function(data){
					if (level == 1) {
						$("#search_snd_group").html("<option value=\"-1\">-- 2차 기관 --</option>" + data);
					} else if (level == 2) {
						$("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>" + data);
					} else if (level == 3) {
						$("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>" + data);
					} else if (level == 4) {
						$("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>" + data);
					}
				},
				error: function(request, textStatus, errorThrown){	//에러에러....
					alert('error: ' + textStatus);
				}
			});
		}
        
        function excel_up () {
            $("#uploadfile").click();
        }
        
        function setFile () {
            var fileName    =   $("#uploadfile").val().split("\\")[$("#uploadfile").val().split("\\").length -1];
            var fileExtName =   $("#uploadfile").val().split(".")[$("#uploadfile").val().split(".").length -1];
            fileExtName     =   fileExtName.toLowerCase();
            if ($.inArray(fileExtName, ['xls'/*, 'xlsx'*/]) == -1) {
                alert ("엑셀 파일만 등록이 가능합니다.");
                $(this).val("");
                return;
            }
            if (confirm ("경고!!!!\n파일을 등록하면 이전 내용은 삭제 됩니다.\n반드시 조직도 먼저 등록한 후 등록하세요.\n'" + fileName + "' 파일을 등록하시겠습니까?")) {
                $("#group_excel_form").attr("action", "./sucheop_group_excel_up.jsp?type=mem");
                $("#group_excel_form").submit();
            } else {$(this).val("");return;}
        }

        function excel_dw () {
            var url         =   "./sucheop_mem_excel_dw_log.jsp";

			$.ajax({
				url: url,
				type: 'POST',
				dataType: 'text',
				timeout: 10000,
				success: function(data){
                    if (data == "1") {}
                    else {alert("로그 전송 오류 입니다. 관리자에게 문의하세요.");}
                },
				error: function(request, textStatus, errorThrown){	//에러에러....
					alert('error: ' + textStatus);
				}
			});
			location.href =   "sucheop_mem_excel_dw.jsp";
		}

	</script>
	</head>

    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>교원 관리</strong></p>
				<p class="location" style="float:right; margin-right:20px;">
                    <span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
			</div>
		<div id="content">
			<div class="searchBox">
				<form id="searchForm" action="./sucheop_list.jsp" method="post">
					<input name="pageNo" id="pageNo" type="hidden" value="1">
					<input name="chk_obj" id="chk_obj" type="hidden" value="">
					<input name="command" id="command" type="hidden" value="board_delete">
							<!-- ./기관 검색 part -->
					<fieldset>
						<legend>기관 검색</legend>
						<div class="boxinner">
							<span>
								<label for="search_category_gb">기관 검색</label>
								<select name="search_fst_group" id="search_fst_group">
								    <option value="-1">-- 1차 기관 --</option>
									<%
										String outHtml	=	"";
										if (cateList != null && cateList.size() > 0) {
											for (int i = 0; i < cateList.size(); i++) {
												Map<String, Object> dataMap	=	cateList.get(i);
												outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ"));
												if (parseNull((String)dataMap.get("GROUP_SEQ")).equals(search_fst_group)) {
													outHtml	+=	" selected='selected' ";
												}
												outHtml	+=	">";
												outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
												outHtml +=	"</option>";
											}
										}
										out.println(outHtml);
									%>
								</select>
							</span>
							<span>
								<select name="search_snd_group" id="search_snd_group">
								    <option value="-1">-- 2차 기관 --</option>
                                    <%
                                    outHtml =   "";
                                    if (cateList2 != null && cateList2.size() > 0) {
                                        for (int i =0; i < cateList2.size(); i++) {
                                            Map<String, Object> dataMap2    =   cateList2.get(i);
                                            //search_snd_group
                                            outHtml +=  "<option value=" + parseNull((String)dataMap2.get("GROUP_SEQ"));
                                            if (parseNull((String)dataMap2.get("GROUP_SEQ")).equals(search_snd_group)) {
                                                outHtml +=  " selected='selected' ";
                                            }
                                            outHtml +=  ">";
                                            outHtml +=  parseNull((String)dataMap2.get("GROUP_NM"));
                                            outHtml +=  "</option>";
                                        }
                                    }
                                    out.println(outHtml);
                                    %>
								</select>
							</span>
							<span>
								<select name="search_trd_group" id="search_trd_group">
								    <option value="-1">-- 3차 기관 --</option>
                                    <%
                                    outHtml =   "";
                                    if (cateList3 != null && cateList3.size() > 0) {
                                        for (int i =0; i < cateList3.size(); i++) {
                                            Map<String, Object> dataMap3    =   cateList3.get(i);
                                            //search_snd_group
                                            outHtml +=  "<option value=" + parseNull((String)dataMap3.get("GROUP_SEQ"));
                                            if (parseNull((String)dataMap3.get("GROUP_SEQ")).equals(search_trd_group)) {
                                                outHtml +=  " selected='selected' ";
                                            }
                                            outHtml +=  ">";
                                            outHtml +=  parseNull((String)dataMap3.get("GROUP_NM"));
                                            outHtml +=  "</option>";
                                        }
                                    }
                                    out.println(outHtml);
                                    %>
								</select>
							</span>
							<span>
								<select name="search_fth_group" id="search_fth_group">
								    <option value="-1">-- 4차 기관 --</option>
                                    <%
                                    outHtml =   "";
                                    if (cateList4 != null && cateList4.size() > 0) {
                                        for (int i =0; i < cateList4.size(); i++) {
                                            Map<String, Object> dataMap4    =   cateList4.get(i);
                                            //search_snd_group
                                            outHtml +=  "<option value=" + parseNull((String)dataMap4.get("GROUP_SEQ"));
                                            if (parseNull((String)dataMap4.get("GROUP_SEQ")).equals(search_fth_group)) {
                                                outHtml +=  " selected='selected' ";
                                            }
                                            outHtml +=  ">";
                                            outHtml +=  parseNull((String)dataMap4.get("GROUP_NM"));
                                            outHtml +=  "</option>";
                                        }
                                    }
                                    out.println(outHtml);
                                    %>
								</select>
							</span>
                            <span>
								<select name="search_fith_group" id="search_fith_group">
								    <option value="-1">-- 5차 기관 --</option>
                                    <%
                                    outHtml =   "";
                                    if (cateList5 != null && cateList5.size() > 0) {
                                        for (int i =0; i < cateList5.size(); i++) {
                                            Map<String, Object> dataMap5    =   cateList5.get(i);
                                            //search_snd_group
                                            outHtml +=  "<option value=" + parseNull((String)dataMap5.get("GROUP_SEQ"));
                                            if (parseNull((String)dataMap5.get("GROUP_SEQ")).equals(search_fith_group)) {
                                                outHtml +=  " selected='selected' ";
                                            }
                                            outHtml +=  ">";
                                            outHtml +=  parseNull((String)dataMap5.get("GROUP_NM"));
                                            outHtml +=  "</option>";
                                        }
                                    }
                                    out.println(outHtml);
                                    %>
								</select>
							</span>
							<!-- ./기관 검색 part -->
						</div>
					</fieldset>
					<!-- input 검색 part -->
					<fieldset>
                        <legend>input 검색</legend>
                        <span>
                            <label for="search_advice_sts">기관명 검색</label>
                            <input name="search_group_keyword" id="search_group_keyword" type="text" value="<%=search_group_keyword %>">
                        </span>
                        <span>
                            <label for="search_advice_sts">교원명 검색</label>
                            <input name="search_name_keyword" id="search_name_keyword" type="text" value="<%=search_name_keyword %>">
                            <input class="btn small edge mako" type="submit" value="검색">
                        </span>
                    </fieldset>
					<!-- ./input 검색 part -->
				</form><!-- ./End form tag -->
			</div>

			<div class="btn_area txt_r magT20">
				<!-- des : 임시 주석 처리 요청이 있을 시 대응
				    <button class="btn medium edge white" onclick="check_delete();" type="button">선택삭제</button>
                -->
                <button class="btn medium edge green" onclick="location.href='./sample_member.xls'" type="button">샘플엑셀다운로드</button>
                <form id="group_excel_form" method="post" enctype="multipart/form-data" >
                    <input type="file" id="uploadfile" name="uploadfile" class="uploadfile" onchange="setFile();" style="display: none;">
                </form>
                <button class="btn medium edge darkMblue" onclick="excel_up();" type="button">엑셀 파일등록하기</button>
				<button class="btn medium edge mako" onclick="excel_dw();" type="button">엑셀다운로드</button>
			</div>

            <!-- 전체교원 Label 로 표시 -->
            <div>
                <label for="..none" style="font-weight: bold;">총 교원수 : <span style="color: blue; font-weight: bold; font-size: 1.2rem;"><%=Integer.toString(totalCnt) %></span></label>
            </div><!-- ./전체교원 Label 로 표시 -->
			<div class="listArea">
				<form id="postForm" action="" method="post">
					<fieldset>
					<legend>교원 목록 결과</legend>
					<table class="bbs_list">
					<colgroup>
					<!--<col class="wps_5">-->
					<col class="wps_5">
					<col class="wps_10">
					<col class="wps_10">
					<col>
					<col>
					<col>
					<col>
					<col class="wps_10">
					<col class="wps_10">
					<col class="wps_5">
					</colgroup>
					<thead>
					<tr>
					<!--<th scope="col"><input name="chkAll" id="chkAll" type="checkbox"></th>-->
					<th scope="col">번호</th>
					<th scope="col">기관명</th>
					<th scope="col">직위(급수)</th>
					<th scope="col">성명</th>
					<th scope="col">사무실전화</th>
					<th scope="col">휴대전화</th>
					<th scope="col">노출여부</th>
					<th scope="col">등록일</th>
					<th scope="col">상태변경일</th>
					<th scope="col">수정</th>
					</tr>
					</thead>
					<tbody>
                    
                    <%
                    //	spreading dataList info 
					if (dataList != null && dataList.size() > 0) {
						for (int i = 0; i < dataList.size(); i++) {
							Map<String, Object> dataMap	=	dataList.get(i);
                            row_num         =   parseNull((String)dataMap.get("RNUM"));
                            group_lv	    =	parseNull((String)dataMap.get("GROUP_LV"));
                            group_lv_img	=	"";
							if (group_lv.equals("1")) {
								group_lv_img	=	"<img src=\"/images/egovframework/rfc3/iam/office/folder_01.gif\" alt=\"group_fst\">&nbsp;";
							} else if (group_lv.equals("2")) {
								group_lv_img	=	"&nbsp;&nbsp;<img src=\"/images/egovframework/rfc3/iam/office/folder_02.gif\" alt=\"group_snd\">&nbsp;";
							} else if (group_lv.equals("3")) {
								group_lv_img	=	"&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"/images/egovframework/rfc3/iam/office/folder_03.gif\" alt=\"group_trd\">&nbsp;";
							} else if (group_lv.equals("4")) {
								group_lv_img	=	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"/images/egovframework/rfc3/iam/office/folder_04.gif\" alt=\"group_fth\">&nbsp;";
							} else if (group_lv.equals("5")) {
                                group_lv_img	=	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"/images/egovframework/rfc3/iam/office/folder_05.gif\" alt=\"group_fth\">&nbsp;";
                            }
                            group_name       =  parseNull((String)dataMap.get("GROUP_NAME"));
                            mem_seq          =	parseNull((String)dataMap.get("MEM_SEQ"));
                            group_list_seq   =	parseNull((String)dataMap.get("GROUP_LIST_SEQ"));
                            mem_nm           =	parseNull((String)dataMap.get("MEM_NM"));
                            mem_grade        =	parseNull((String)dataMap.get("MEM_GRADE"));
                            mem_level        =	parseNull((String)dataMap.get("MEM_LEVEL"));
                            mem_tel          =	parseNull((String)dataMap.get("MEM_TEL"));
                            mem_mobile       =	parseNull((String)dataMap.get("MEM_MOBILE"));
                            mem_sso_id       =	parseNull((String)dataMap.get("MEM_SSO_ID"));
                            mem_reg          =	parseNull((String)dataMap.get("MEM_REG"));
                            mem_modify       =	parseNull((String)dataMap.get("MEM_MODIFY"));
                            show_flag        =  parseNull((String)dataMap.get("SHOW_FLAG"));
                    %>
                    <tr>
						<!--<td><input name="chk" id="chk" type="checkbox" value=""></td>-->
						<td><%=mem_seq %></td>
						<td><%=group_lv_img %><%=group_name %></td>
						<td>
                            <%=mem_grade %>
                            <% if (mem_level.length() > 0) out.println("(" + mem_level + ")"); %>
                        </td>
						<td><%=mem_nm %></td>
						<td><%=mem_tel %></td>
						<td><%=mem_mobile %></td>
                        <td><font color="blue"><%=show_flag %></font></td>
						<td><%=mem_reg %></td>
						<td><%=mem_reg %></td>
						<td><a class="btn edge small mako"  onclick="new_win2('sucheop_mem_edit.jsp?command=update&mem_seq=<%=mem_seq%>','group_form','600','400','yes','yes','yes');">수정</a></td>
					</tr>
                    <%}// ./end for
                    } else {// ./end if
                        out.println("<tr><td colspan=\"9\">데이터가 없습니다.</td></tr>");
                    }
                    %>

					</tbody>
					</table>
					</fieldset>
				</form>
			</div>

		<div class="page_area">


		</div>

		</div>
		<!-- // content -->
		</div>

	</body>
</html>
