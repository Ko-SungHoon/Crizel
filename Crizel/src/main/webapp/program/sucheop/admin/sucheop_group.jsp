<%
/**
*	PURPOSE	:	교육수첩 교원 관리 페이지
*	CREATE	:	20171103_fri	JI
*	MODIFY	:	기관번호 주석 처리   /   20171214_thur   JI
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
String sql_str	        =	"";
int key                 =   0;
int result              =   0;
List<Map<String, Object>> cateList	=	null;
List<Map<String, Object>> cateList2	=	null;
List<Map<String, Object>> cateList3	=	null;
List<Map<String, Object>> cateList4	=	null;
List<Map<String, Object>> dataList	=	null;

int totalCnt    =   0;

//	parameters
String row_num      =	parseNull(request.getParameter("row_num"));
String group_seq    =	parseNull(request.getParameter("group_seq"));
String group_nm     =	parseNull(request.getParameter("group_nm"));
String group_lv     =	parseNull(request.getParameter("group_lv"));
String group_lv_img =	parseNull(request.getParameter("group_lv_img"));
String group_depth  =	parseNull(request.getParameter("group_depth"));
String parent_seq   =	parseNull(request.getParameter("parent_seq"));
String reg_dt       =	parseNull(request.getParameter("reg_dt"));
String reg_hms      =	parseNull(request.getParameter("reg_hms"));
String modify_dt    =	parseNull(request.getParameter("modify_dt"));
String modify_hms   =	parseNull(request.getParameter("modify_hms"));
String school_flag  =	parseNull(request.getParameter("school_flag"));
String group_addr   =	parseNull(request.getParameter("group_addr"));
String group_tel1   =	parseNull(request.getParameter("group_tel1"));
String group_tel2   =	parseNull(request.getParameter("group_tel2"));
String group_tel3   =	parseNull(request.getParameter("group_tel3"));
String group_fax    =	parseNull(request.getParameter("group_fax"));
String group_url    =	parseNull(request.getParameter("group_url"));
String group_alimi  =	parseNull(request.getParameter("group_alimi"));
String show_flag    =	parseNull(request.getParameter("show_flag"));
String group_reg    =	parseNull(request.getParameter("group_reg"));
String group_modify	=	parseNull(request.getParameter("group_modify"));

//	검색
String search_fst_group	=	parseNull(request.getParameter("search_fst_group"), "-1");    //1차 기관
String search_snd_group	=	parseNull(request.getParameter("search_snd_group"), "-1");    //2차 기관
String search_trd_group	=	parseNull(request.getParameter("search_trd_group"), "-1");    //3차 기관
String search_fth_group	=	parseNull(request.getParameter("search_fth_group"), "-1");    //4차 기관

//	1차 그룹 리스트 call
try {

    sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//	1차 기관 list 호출
	sql			=	new StringBuffer();
	sql_str		=	"SELECT * FROM NOTE_GROUP_LIST WHERE GROUP_LV = 1 ORDER BY GROUP_SEQ ASC";
	sql.append(sql_str);
	pstmt		=	conn.prepareStatement(sql.toString());
	rs			=	pstmt.executeQuery();
	cateList	=	getResultMapRows(rs);
    
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

    }   }   }


	//	기관 list call
	sql        =	new StringBuffer();
	sql_str    =	"";
	sql_str	   +=	"SELECT ROWNUM AS RNUM, NOTE_GROUP_LIST.* ";
	sql_str	   +=	"	, TO_CHAR(TO_DATE(REG_DT||REG_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS GROUP_REG ";
	sql_str	   +=	"	, TO_CHAR(TO_DATE(MODIFY_DT||MODIFY_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS GROUP_MODIFY ";
	sql_str	   +=	" FROM NOTE_GROUP_LIST ";
    if (Integer.parseInt(search_trd_group) > 0) {       sql_str	   +=	" START WITH GROUP_SEQ =  " + search_trd_group;
    } else if (Integer.parseInt(search_snd_group) > 0) {sql_str	   +=	" START WITH GROUP_SEQ =  " + search_snd_group;
    } else if (Integer.parseInt(search_fst_group) > 0) {sql_str	   +=	" START WITH GROUP_SEQ =  " + search_fst_group;
    } else sql_str	   +=	" START WITH PARENT_SEQ = -1 ";
	sql_str	   +=	" CONNECT BY PRIOR GROUP_SEQ	=	PARENT_SEQ";
	sql_str	   +=	" ORDER SIBLINGS BY GROUP_DEPTH ASC";

	sql.append(sql_str);

	pstmt	=	conn.prepareStatement(sql.toString());

	rs		=	pstmt.executeQuery();
	dataList	=	getResultMapRows(rs);

} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}

//총 기관 확인
totalCnt    =   dataList.size();

%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 조직도 관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">

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
            $("#search_trd_group").change(function () {
				var group_val	=	$(this).val();
				setSelect (group_val, 3);
			});

		});

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

        function excel_up (level) {
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
            if (confirm ("경고!!!!\n파일을 등록하면 이전 내용은 삭제 됩니다.\n'" + fileName + "' 파일을 등록하시겠습니까?")) {
                $("#group_excel_form").attr("action", "./sucheop_group_excel_up.jsp?type=group");
                $("#group_excel_form").submit();
            } else {$(this).val("");return;}
        }

		function excel_dw () {
			location.href =   "sucheop_group_excel_dw.jsp";
		}
        
		function group_del (group_seq, group_lv) {
			if (confirm("기관을 삭제하면 소속 기관 및 소속 교원이 모두 삭제됩니다!!\n그래도 삭제를 진행하시겠습니까?")) {
				location.replace("./sucheop_group_up.jsp?command=delete&group_seq=" + group_seq + "&group_level=" + group_lv);
			}
		}

	</script>
	</head>

	<body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>조직도 관리</strong></p>
				<p class="location" style="float:right; margin-right:20px;">
                    <span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
			</div>
		<div id="content">
			<div class="searchBox">
				<form id="searchForm" action="./sucheop_group.jsp" method="post">
					<input name="command" id="command" type="hidden" value="">
							<!-- 기관 검색 part -->
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
												//search_fst_group
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

							<input class="btn small edge mako" type="submit" value="검색">
							<!-- ./기관 검색 part -->
						</div>
					</fieldset>
				</form><!-- ./End form tag -->
					
					<!-- 등록 btn group -->
					<div class="btn_area txt_r magT20">
						<button class="btn medium edge mako" type="button" onclick="new_win2('sucheop_group_register.jsp?command=insert1','group_form','600','400','yes','yes','yes');">1차기관 등록</button>
						<button class="btn medium edge mako" type="button" onclick="new_win2('sucheop_group_register.jsp?command=insert2','group_form','600','400','yes','yes','yes');">2차기관 등록</button>
						<button class="btn medium edge mako" type="button" onclick="new_win2('sucheop_group_register.jsp?command=insert3','group_form','600','400','yes','yes','yes');">3차기관 등록</button>
						<button class="btn medium edge mako" type="button" onclick="new_win2('sucheop_group_register.jsp?command=insert4','group_form','600','400','yes','yes','yes');">4차기관 등록</button>
                        <button class="btn medium edge mako" type="button" onclick="new_win2('sucheop_group_register.jsp?command=insert5','group_form','600','400','yes','yes','yes');">5차기관 등록</button>
					</div>
					<!-- ./등록 btn group -->
					
			</div>

			<div class="btn_area txt_r magT20">
				<!-- des : 임시 주석 처리 요청이 있을 시 대응
				    <button class="btn medium edge white" onclick="check_delete();" type="button">선택삭제</button>
                -->
                <button class="btn medium edge green" onclick="location.href='./sample_group.xls'" type="button">업로드용샘플엑셀다운로드</button>
                <form id="group_excel_form" method="post" enctype="multipart/form-data" >
                    <input type="file" id="uploadfile" name="uploadfile" class="uploadfile" onchange="setFile();" style="display: none;">
                </form>
                <button class="btn medium edge darkMblue" onclick="excel_up();" type="button">엑셀 파일등록하기</button>
				<button class="btn medium edge mako" onclick="excel_dw();" type="button">엑셀다운로드</button>
			</div>
			
			<!-- 전체기관 Label 로 표시 -->
            <div>
                <label for="..none" style="font-weight: bold;">총 기관 수 : <span style="color: blue; font-weight: bold; font-size: 1.2rem;"><%=Integer.toString(totalCnt) %></span></label>
            </div><!-- ./전체기관 Label 로 표시 -->

			<div class="listArea">
				<form id="postForm" action="" method="post">
					<fieldset>
					<legend>상담로그 목록 결과</legend>
					<table class="bbs_list">
					<colgroup>
					<!--<col class="wps_5">-->
					<!--<col class="wps_5">-->
					<col class="wps_5">
					<col width="*">
					<col class="wps_10">
					<col class="wps_10">
					<col class="wps_10">
					<col class="*">
					<col class="*">
					<col class="wps_5">
					<col class="wps_5">
					</colgroup>
					<thead>
					<tr>
					<!--<th scope="col"><input name="chkAll" id="chkAll" type="checkbox"></th>-->
					<th scope="col">번호</th>
					<!--<th scope="col">기관번호</th>-->
					<th scope="col">기관이름</th>
					<th scope="col">그룹레벨</th>
					<th scope="col">정렬순서</th>
					<th scope="col">노출여부</th>
					<th scope="col">등록일</th>
					<th scope="col">수정일</th>
					<th scope="col">수정</th>
					<th scope="col">삭제</th>
					</tr>
					</thead>
					<tbody>
					<%
					//	spreading dataList info 
					if (dataList != null && dataList.size() > 0) {
						for (int i = 0; i < dataList.size(); i++) {
							Map<String, Object> dataMap	=	dataList.get(i);
							row_num			=	parseNull((String)dataMap.get("RNUM"));
							group_seq	    =	parseNull((String)dataMap.get("GROUP_SEQ"));
							group_nm	    =	parseNull((String)dataMap.get("GROUP_NM"));
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
								group_lv_img	=	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"/images/egovframework/rfc3/iam/office/folder_05.gif\" alt=\"group_fth\">&nbsp;";
							}
							group_depth	    =	parseNull((String)dataMap.get("GROUP_DEPTH"));
							parent_seq	    =	parseNull((String)dataMap.get("PARENT_SEQ"));
							reg_dt	        =	parseNull((String)dataMap.get("REG_DT"));
							reg_hms	        =	parseNull((String)dataMap.get("REG_HMS"));
							modify_dt	    =	parseNull((String)dataMap.get("MODIFY_DT"));
							modify_hms	    =	parseNull((String)dataMap.get("MODIFY_HMS"));
							school_flag	    =	parseNull((String)dataMap.get("SCHOOL_FLAG"));
							group_addr	    =	parseNull((String)dataMap.get("ADDR"));
							group_tel1	    =	parseNull((String)dataMap.get("TEL1"));
							group_tel2	    =	parseNull((String)dataMap.get("TEL2"));
							group_tel3	    =	parseNull((String)dataMap.get("TEL3"));
							group_fax	    =	parseNull((String)dataMap.get("FAX"));
							group_url	    =	parseNull((String)dataMap.get("URL"));
							group_alimi	    =	parseNull((String)dataMap.get("ALIMI"));
							show_flag	    =	parseNull((String)dataMap.get("SHOW_FLAG"));
							group_reg	    =	parseNull((String)dataMap.get("GROUP_REG"));
							group_modify	=	parseNull((String)dataMap.get("GROUP_MODIFY"), "수정기록 없음");


					%>
					<tr>
						<!--<td><input name="chk" id="chk" type="checkbox" value="14855"></td>-->
						<td><%=row_num %></td>
						<!--<td><%=group_seq %></td>-->
						<td style="padding-left: 12%; text-align: left;"><%=group_lv_img %><%=group_nm %></td>
						<td><%=group_lv_img %></td>
						<td><%=group_depth %></td>
						<td><font color="blue"><%=show_flag %></font></td>
						<td><%=group_reg %></td>
						<td><%=group_modify %></td>
						<td><a class="btn edge small mako" onclick="new_win2('sucheop_group_register.jsp?command=update<%=group_lv %>&group_seq=<%=group_seq%>&parent_seq=<%=parent_seq%>','group_form','600','400','yes','yes','yes');">수정</a></td>
						<td><a class="btn edge small mako" onclick="group_del(<%=group_seq %>, <%=group_lv %>);" style="background-color: #fa0000; border-color: #fa0000;">삭제</a></td>
					</tr>
					<%
						}
					%>
					<%
					} else {
						out.println("<tr><td colspan=\"9\">데이터가 없습니다.</tr>");
					}
					%>
					</tbody>
					</table>
					</fieldset>
				</form>
			</div>

		</div>
		<!-- // content -->
		</div>

	</body>
</html>
