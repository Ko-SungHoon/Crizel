<%
/**
*	PURPOSE	:	교육수첩 조직도 기관 등록 팝업
*	CREATE	:	20171108_wedns	JI
*	MODIFY	:	add 야간직통2, 팩스2, 우편번호 /   20171227_wed    JI
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

//Connection conn =   null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
String sql_str	=	"";
int key = 0;
int result = 0;
List<Map<String, Object>> cateList1 =   null;
String cateId1                      =   "";
List<Map<String, Object>> cateList2 =   null;
String cateId2                      =   "";
List<Map<String, Object>> cateList3 =   null;
String cateId3                      =   "";
List<Map<String, Object>> cateList4 =   null;
String cateId4                      =   "";
List<Map<String, Object>> cateList5 =   null;
String cateId5                      =   "";
List<Map<String, Object>> dataList  =   null;

//	고정 parameter
String command	=	parseNull(request.getParameter("command"));		//COMMAND	=> insert1,2,3,4,5/ update1,2,3,4,5

//	value parameters
String group_seq	=	parseNull(request.getParameter("group_seq"));	//기관 번호
String group_nm	    =	parseNull(request.getParameter("group_nm"));	//기관 이름
String group_lv	    =	parseNull(request.getParameter("group_lv"));	//기관 등급
String group_depth	=	parseNull(request.getParameter("group_depth"));	//기관 깊이
String parent_seq	=	parseNull(request.getParameter("parent_seq"));	//부모 기관 번호
String school_flag	=	parseNull(request.getParameter("school_flag"));	//기관 학교 정보 여부
String group_addr	=	parseNull(request.getParameter("group_addr"));	//기관 주소
String group_addr_post	=	parseNull(request.getParameter("group_addr_post"));	//기관 우편번호
String group_tel1	=	parseNull(request.getParameter("group_tel1"));	//기관 대표번호
String group_tel2	=	parseNull(request.getParameter("group_tel2"));	//기관 야간직통
String group_tel3	=	parseNull(request.getParameter("group_tel3"));	//기관 전화 임시
String group_tel4	=	parseNull(request.getParameter("group_tel4"));	//기관 전화 임시
String group_fax	=	parseNull(request.getParameter("group_fax"));	//기관 팩스
String group_fax2   =	parseNull(request.getParameter("group_fax2"));	//기관 팩스
String group_url	=	parseNull(request.getParameter("group_url"));	//기관 URL
String group_alimi	=	parseNull(request.getParameter("group_alimi"));	//기관 알리미 URl
String show_flag	=	parseNull(request.getParameter("show_flag"));	//노출 여부

%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 조직도 관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

        <script>

			$(function(){
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
                $("#search_trd_group").change(function () {
					var group_val	=	$(this).val();
					setSelect (group_val, 3);
				});
			});
        
            //  only number input
            function numbersOnly(obj) {
                $(obj).keyup(function(){
                     $(this).val($(this).val().replace(/[^0-9]/g,""));
                });
            }

			//	data send
			function postForm() {
				<% if (command.substring(6,7).equals("1")) { %>
					if ($("#fst_group_nm").val().length < 1) {alert("기관 이름은 2자 이상이어야 합니다.");$("#fst_group_nm").focus();return;}
				<% } else if (command.substring(6,7).equals("2")) { %>
					if ($("#snd_group_nm").val().length < 1) {alert("기관 이름은 2자 이상이어야 합니다.");$("#snd_group_nm").focus();return;}
					if ($("#search_fst_group option:selected").val() < 0) {alert("1차 기관을 선택해야 합니다.");return;}
				<% } else if (command.substring(6,7).equals("3")) { %>
					if ($("#trd_group_nm").val().length < 1) {alert("기관 이름은 2자 이상이어야 합니다.");$("#trd_group_nm").focus();return;}
					if ($("#search_snd_group option:selected").val() < 0) {alert("2차 기관을 선택해야 합니다.");return;}
				<% } else if (command.substring(6,7).equals("4")) { %>
					if ($("#fth_group_nm").val().length < 1) {alert("기관 이름은 2자 이상이어야 합니다.");$("#fth_group_nm").focus();return;}
					if ($("#search_trd_group option:selected").val() < 0) {alert("3차 기관을 선택해야 합니다.");return;}
				<% } else if (command.substring(6,7).equals("5")) { %>
					if ($("#fith_group_nm").val().length < 1) {alert("기관 이름은 2자 이상이어야 합니다.");$("#fith_group_nm").focus();return;}
					if ($("#search_fth_group option:selected").val() < 0) {alert("4차 기관을 선택해야 합니다.");return;}
				<% } %>

				$("#postForm").attr("action", "/program/sucheop/admin/sucheop_group_up.jsp");
				$("#postForm").submit();
			}

			//select box 동적 function
			function setSelect (group_seq, level) {

				if (group_seq < 0 || !group_seq) {
					if (level == 1) {
						$("#search_snd_group").html("<option value=\"-1\">-- 2차 기관 --</option>");
						$("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>");
                        $("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
					} else if (level == 2) {
						$("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>");
                        $("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
					} else if (level == 3) {
                        $("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
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
						}
					},
					error: function(request, textStatus, errorThrown){	//에러에러....
						alert('error: ' + textStatus);
					}
				});
			}
        
        </script>
	</head>
<body>
<%
//	1차 그룹 리스트 call
try {

	//	수정 요청 시의 data select
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//	수정 시 기관 정보 가져오기
	if (command.substring(0,6).equals("update")) {
		sql	=	new StringBuffer();
		sql_str	=	"SELECT * FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = " + group_seq;
		sql.append(sql_str);
		pstmt	=	conn.prepareStatement(sql.toString());
		rs		=	pstmt.executeQuery();
		while (rs.next()) {
			group_seq		=    parseNull(rs.getString("GROUP_SEQ"));
			group_nm		=    parseNull(rs.getString("GROUP_NM"));
			group_lv		=    parseNull(rs.getString("GROUP_LV"));
			group_depth		=    parseNull(rs.getString("GROUP_DEPTH"));
			parent_seq		=    parseNull(rs.getString("PARENT_SEQ"));
			school_flag		=    parseNull(rs.getString("SCHOOL_FLAG"));
			group_addr		=    parseNull(rs.getString("ADDR"));
			group_addr_post	=    parseNull(rs.getString("ADDR_POST"));
			group_tel1		=    parseNull(rs.getString("TEL1"));
			group_tel2		=    parseNull(rs.getString("TEL2"));
			group_tel3		=    parseNull(rs.getString("TEL3"));
			group_tel4		=    parseNull(rs.getString("TEL4"));
			group_fax		=    parseNull(rs.getString("FAX"));
			group_fax2      =    parseNull(rs.getString("FAX2"));
			group_url		=    parseNull(rs.getString("URL"));
			group_alimi		=    parseNull(rs.getString("ALIMI"));
			show_flag		=    parseNull(rs.getString("SHOW_FLAG"));
		}
	} else {
        group_lv    =   "1";
    }
    
	//	1차 기관 list
	sql	=	new StringBuffer();
	sql_str	=	"SELECT * FROM NOTE_GROUP_LIST WHERE GROUP_DEPTH = 1 ORDER BY GROUP_SEQ ASC";
	sql.append(sql_str);
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	cateList1 = getResultMapRows(rs);
	
    if (Integer.parseInt(group_lv) > 1) {
        if (Integer.parseInt(group_lv) > 2) {
            if (Integer.parseInt(group_lv) > 3) {
                if (Integer.parseInt(group_lv) > 4) {
                    cateId5    =    group_seq;
                    sql        =	new StringBuffer();
                    sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId5 +"') ORDER BY GROUP_SEQ ASC");
                    pstmt      =    conn.prepareStatement(sql.toString());
                    rs         =    pstmt.executeQuery();
                    cateList5  =    getResultMapRows(rs);
                    cateId4    =    cateList5.get(0).get("PARENT_SEQ").toString();
                }// ./end if lv = 4
                if (cateId4.equals("")) {cateId4    =   group_seq;}
                sql        =	new StringBuffer();
                sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId4 +"') ORDER BY GROUP_SEQ ASC");
                pstmt      =    conn.prepareStatement(sql.toString());
                rs         =    pstmt.executeQuery();
                cateList4  =    getResultMapRows(rs);
                cateId3    =    cateList4.get(0).get("PARENT_SEQ").toString();
            }// ./end if lv = 3
            if (cateId3.equals("")) {cateId3    =   group_seq;}
            sql        =	new StringBuffer();
            sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId3 +"') ORDER BY GROUP_SEQ ASC");
            pstmt      =    conn.prepareStatement(sql.toString());
            rs         =    pstmt.executeQuery();
            cateList3  =    getResultMapRows(rs);
            cateId2    =   cateList3.get(0).get("PARENT_SEQ").toString();
        }// ./end if lv = 2
        if (cateId2.equals("")) {cateId2    =   group_seq;}
        sql        =	new StringBuffer();
        sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId2 +"') ORDER BY GROUP_SEQ ASC");
        pstmt      =    conn.prepareStatement(sql.toString());
        rs         =    pstmt.executeQuery();
        cateList2  =    getResultMapRows(rs);
        cateId1    =   cateList2.get(0).get("PARENT_SEQ").toString();
    } else {
        if (cateId1.equals("")) cateId1    =   group_seq;
    }

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

%>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>조직도 기관 관리</strong></p>
	</div>
	<div id="content">
		<div class="listArea">
			<form action="" method="post" id="postForm">
			<input type="hidden" name="command" id="command" value="<%=command %>">
			<input type="hidden" name="group_seq" id="group_seq" value="<%=group_seq %>">
			
				<fieldset>
					<legend>조직도 기관 관리</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="25%"/>
						<col width="25%"/>
						<col width="25%"/>
						<col width="25%"/>
						</colgroup>
						<% if (!command.equals("") && (command.equals("insert5") || command.equals("insert4") || command.equals("insert3") || command.equals("insert2") || command.equals("update5") || command.equals("update4") || command.equals("update3") || command.equals("update2"))) { %>
						<tr>
							<th>1차 기관</th>
							<td >
								<select name="search_fst_group" id="search_fst_group" for="search_fst_group" value="" >
									<option value="-1">-- 1차 기관 선택 --</option>
									<%
									String outHtml	=	"";
									if (cateList1 != null && cateList1.size() > 0) {
										for (int i = 0; i < cateList1.size(); i++) {
											Map<String, Object> dataMap	=	cateList1.get(i);
											outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ"));
                                            if (cateId1.equals(parseNull((String)dataMap.get("GROUP_SEQ")))) {
                                                outHtml	+=	" selected='selected'";
                                            }
                                            outHtml +=	">";
											outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
											outHtml +=	"</option>";
										}// .end for
									}// .end if
									out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
						<% if (command.equals("insert5") || command.equals("insert4") || command.equals("insert3") || command.equals("update5") || command.equals("update4") || command.equals("update3")) { %>
						<tr>
							<th>2차 기관</th>
							<td >
								<select name="search_snd_group" id="search_snd_group" for="search_snd_group" value="" >
									<option value="-1">-- 2차 기관 선택 --</option>
                                    <%
									outHtml	=	"";
									if (cateList2 != null && cateList2.size() > 0) {
										for (int i = 0; i < cateList2.size(); i++) {
											Map<String, Object> dataMap	=	cateList2.get(i);
											outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ"));
                                            if (cateId2.equals(parseNull((String)dataMap.get("GROUP_SEQ")))) {
                                                outHtml	+=	" selected='selected'";
                                            }
                                            outHtml +=	">";
											outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
											outHtml +=	"</option>";
										}// .end for
									}// .end if
									out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
						<% } %>
						<% if (command.equals("insert5") || command.equals("insert4") || command.equals("update5") || command.equals("update4")) { %>
						<tr>
							<th>3차 기관</th>
							<td >
								<select name="search_trd_group" id="search_trd_group" for="search_trd_group" value="" >
									<option value="-1">-- 3차 기관 선택 --</option>
                                    <%
									outHtml	=	"";
									if (cateList3 != null && cateList3.size() > 0) {
										for (int i = 0; i < cateList3.size(); i++) {
											Map<String, Object> dataMap	=	cateList3.get(i);
											outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ"));
                                            if (cateId3.equals(parseNull((String)dataMap.get("GROUP_SEQ")))) {
                                                outHtml	+=	" selected='selected'";
                                            }
                                            outHtml +=	">";
											outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
											outHtml +=	"</option>";
										}// .end for
									}// .end if
									out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
						<% } %>
                        <% if (command.equals("insert5") || command.equals("update5")) { %>
						<tr>
							<th>4차 기관</th>
							<td >
								<select name="search_fth_group" id="search_fth_group" for="search_fth_group" value="" >
									<option value="-1">-- 4차 기관 선택 --</option>
                                    <%
									outHtml	=	"";
									if (cateList4 != null && cateList4.size() > 0) {
										for (int i = 0; i < cateList4.size(); i++) {
											Map<String, Object> dataMap	=	cateList4.get(i);
											outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ"));
                                            if (cateId4.equals(parseNull((String)dataMap.get("GROUP_SEQ")))) {
                                                outHtml	+=	" selected='selected'";
                                            }
                                            outHtml +=	">";
											outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
											outHtml +=	"</option>";
										}// .end for
									}// .end if
									out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
						<% } %>
						<% } %>
						<!-- 기관 이름 -->
						<% if (command.equals("insert1") || command.equals("update1")) { %>
						<tr>
							<th>1차 기관 이름</th>
							<td >
								<input type="text" id="fst_group_nm" name="fst_group_nm" for="fst_group_nm" value="<%=group_nm%>" placeholder="기관이름을 입력하세요." />
							</td>
						</tr>
						<% } else if (command.equals("insert2") || command.equals("update2")) { %>
						<tr>
							<th>2차 기관 이름</th>
							<td >
								<input type="text" id="snd_group_nm" name="snd_group_nm" for="snd_group_nm" value="<%=group_nm%>" placeholder="기관이름을 입력하세요." />
							</td>
						</tr>
						<% } else if (command.equals("insert3") || command.equals("update3")) { %>
						<tr>
							<th>3차 기관 이름</th>
							<td >
								<input type="text" id="trd_group_nm" name="trd_group_nm" for="trd_group_nm" value="<%=group_nm%>" placeholder="기관이름을 입력하세요." />
							</td>
						</tr>
						<% } else if (command.equals("insert4") || command.equals("update4")) { %>
						<tr>
							<th>4차 기관 이름</th>
							<td >
								<input type="text" id="fth_group_nm" name="fth_group_nm" for="fth_group_nm" value="<%=group_nm%>" placeholder="기관이름을 입력하세요."  />
							</td>
						</tr>
                        <% } else if (command.equals("insert5") || command.equals("update5")) { %>
						<tr>
							<th>5차 기관 이름</th>
							<td >
								<input type="text" id="fith_group_nm" name="fith_group_nm" for="fith_group_nm" value="<%=group_nm%>" placeholder="기관이름을 입력하세요."  />
							</td>
						</tr>
						<% } %>
						<!-- ./기관 이름 -->
						<tr>
							<th>우편번호</th>
							<td >
								<input type="text" id="group_addr_post" name="group_addr_post" for="group_addr_post" value="<%=group_addr_post %>" placeholder="우편번호"  />
							</td>
						</tr>
						<tr>
							<th>주소</th>
							<td >
								<input type="text" id="group_addr" name="group_addr" for="group_addr" value="<%=group_addr %>" placeholder="주소를 입력하세요." />
							</td>
						</tr>
						<tr>
							<th>대표전화1</th>
							<td >
								<input type="text" id="group_tel1" name="group_tel1" for="group_tel1" value="<%=group_tel1%>" placeholder="대표 번호를 입력하세요." />
							</td>
						</tr>
						<tr>
							<th>대표전화2</th>
							<td >
								<input type="text" id="group_tel2" name="group_tel2" for="group_tel2" value="<%=group_tel2%>" placeholder="대표 번호를 입력하세요." />
							</td>
						</tr>
						<tr>
							<th>야간직통</th>
							<td >
								<input type="text" id="group_tel3" name="group_tel3" for="group_tel3" value="<%=group_tel3%>" placeholder="야간직통 번호를 입력하세요." />
							</td>
						</tr>
                        <tr>
							<th>야간직통2</th>
							<td >
								<input type="text" id="group_tel4" name="group_tel4" for="group_tel4" value="<%=group_tel4%>" placeholder="야간직통 번호를 입력하세요." />
							</td>
						</tr>
						<tr>
							<th>fax</th>
							<td >
								<input type="text" id="group_fax" name="group_fax" for="group_fax" value="<%=group_fax%>" placeholder="fax 번호를 입력하세요." />
							</td>
						</tr>
                        <tr>
							<th>fax2</th>
							<td >
								<input type="text" id="group_fax2" name="group_fax2" for="group_fax2" value="<%=group_fax%>" placeholder="fax 번호를 입력하세요." />
							</td>
						</tr>
						<tr>
							<th>기관 URL</th>
							<td >
								<input type="text" id="group_url" name="group_url" for="group_url" value="<%=group_url%>" placeholder="http://" />
							</td>
						</tr>
                        <% if (command.substring(0,6).equals("update")) { %>
                        <tr>
                            <th>정렬순서</th>
                            <td><input type="text" id="group_depth" name="group_depth" value="<%=group_depth %>"></td>
                        </tr>
                        <% } %>
						<!--<tr>
							<th>알리미 URL</th>
							<td >
								<input type="text" id="alimi_url" name="alimi_url" for="alimi_url" value="<%=group_alimi%>" placeholder="http://" />
							</td>
						</tr>-->
						<tr>
							<th>학교 정보 여부</th>
							<td>
								<input type="radio" id="radio1" name="school_yn" value="Y" <%if (school_flag.equals("Y")) {%>checked="checked" <%}%>/>학교
								<input type="radio" id="radio2" name="school_yn" value="K" <%if (school_flag.equals("K")) {%>checked="checked" <%}%> />유치원
								<input type="radio" id="radio2" name="school_yn" value="N" <%if (school_flag.equals("N") || school_flag.equals("")) {%>checked="checked" <%}%> />기관
							</td>
						</tr>
						<tr>
							<th>노출 여부</th>
							<td>
								<input type="radio" id="radio3" name="show_yn" value="Y" <%if (show_flag.equals("Y") || show_flag.equals("")) {%>checked="checked"<%}%> />적용
								<input type="radio" id="radio4" name="show_yn" value="N" <%if (show_flag.equals("N")) {%>checked="checked"<%}%>/>적용안함
							</td>
						</tr>
					</table>
					<button type="button" onclick="postForm();" class="btn small edge mako">확인</button>
				</fieldset>
			</form>
		</div>		
	</div>
	<!-- // content -->
</div>
</body>
</html>