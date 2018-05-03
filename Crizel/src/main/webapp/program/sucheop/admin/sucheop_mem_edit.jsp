<%
/**
*	PURPOSE	:	교육수첩 조직도 교원 수정 팝업
*	CREATE	:	20171108_wedns	JI
*	MODIFY	:	....
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

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
String sql_str	=	"";
int key = 0;
int result = 0;
List<Map<String, Object>> dataList  =   null;
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

//parameters
String type             =   parseNull(request.getParameter("command"));	          //type
String mem_seq          =	parseNull(request.getParameter("mem_seq"));	          //교원 번호
String group_list_seq	=	"";     //교원 기관 번호
String mem_nm	        =	"";     //교원 이름
String mem_grade	    =	"";     //교원 직급
String mem_level	    =	"";     //교원 급수
String mem_tel	        =	"";     //교원 사무실 전화
String mem_mobile	    =	"";     //교원 휴대전화
String mem_sso_id	    =	"";     //교원 통합로그인 ID
String show_flag	    =	"";     //교원 show_flag
//add select parameter value
String mem_group_lv     =   "";     //참여 기관 level

//	1차 그룹 리스트 call
try {
    //ready sql
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
    
    sql        =   new StringBuffer();
	sql_str    =  "SELECT A.*, (SELECT GROUP_LV FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = A.GROUP_LIST_SEQ) AS MEM_GROUP_LV FROM NOTE_GROUP_MEM A WHERE MEM_SEQ = '" + mem_seq + "'";
	sql.append(sql_str);
	pstmt      =   conn.prepareStatement(sql.toString());
	rs         =   pstmt.executeQuery();
	if (rs.next()) {
        group_list_seq  =   rs.getString("GROUP_LIST_SEQ");
        mem_nm          =   rs.getString("MEM_NM");
        mem_grade       =   rs.getString("MEM_GRADE");
        mem_level       =   rs.getString("MEM_LEVEL");
        mem_tel         =   rs.getString("MEM_TEL");
        mem_mobile      =   rs.getString("MEM_MOBILE");
        mem_sso_id      =   rs.getString("MEM_SSO_ID");
        show_flag       =   rs.getString("SHOW_FLAG");
        mem_group_lv    =   rs.getString("MEM_GROUP_LV");
    }

	out.println(mem_group_lv);

	sql        =	new StringBuffer();
	sql_str    =	"SELECT * FROM NOTE_GROUP_LIST WHERE GROUP_LV = 1 ORDER BY GROUP_SEQ ASC";
	sql.append(sql_str);
	pstmt      = conn.prepareStatement(sql.toString());
    rs         = pstmt.executeQuery();
	cateList1  = getResultMapRows(rs);
    
    if (Integer.parseInt(mem_group_lv) > 1) {
        if (Integer.parseInt(mem_group_lv) > 2) {
            if (Integer.parseInt(mem_group_lv) > 3) {
                if (Integer.parseInt(mem_group_lv) > 4) {
                    cateId5    =    group_list_seq;
                    sql        =	new StringBuffer();
                    sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId5 +"') ORDER BY GROUP_SEQ ASC");
                    pstmt      =    conn.prepareStatement(sql.toString());
                    rs         =    pstmt.executeQuery();
                    cateList5  =    getResultMapRows(rs);
                    cateId4    =    cateList5.get(0).get("PARENT_SEQ").toString();
                }// ./end if lv = 4
                if (cateId4.equals("")) {cateId4    =    group_list_seq;}
                sql        =	new StringBuffer();
                sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId4 +"') ORDER BY GROUP_SEQ ASC");
                pstmt      =    conn.prepareStatement(sql.toString());
                rs         =    pstmt.executeQuery();
                cateList4  =    getResultMapRows(rs);
                cateId3    =    cateList4.get(0).get("PARENT_SEQ").toString();
            }// ./end if lv = 3
            if (cateId3.equals("")) {cateId3    =   group_list_seq;}
            sql        =	new StringBuffer();
            sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId3 +"') ORDER BY GROUP_SEQ ASC");
            pstmt      =    conn.prepareStatement(sql.toString());
            rs         =    pstmt.executeQuery();
            cateList3  =    getResultMapRows(rs);
            cateId2    =   cateList3.get(0).get("PARENT_SEQ").toString();
        }// ./end if lv = 2
        if (cateId2.equals("")) {cateId2    =   group_list_seq;}
        sql        =	new StringBuffer();
        sql.append("SELECT * FROM NOTE_GROUP_LIST A WHERE PARENT_SEQ = (SELECT PARENT_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_SEQ = '"+ cateId2 +"') ORDER BY GROUP_SEQ ASC");
        pstmt      =    conn.prepareStatement(sql.toString());
        rs         =    pstmt.executeQuery();
        cateList2  =    getResultMapRows(rs);
        cateId1    =   cateList2.get(0).get("PARENT_SEQ").toString();
    } else {
        if (cateId1.equals("")) {cateId1    =   group_list_seq;}
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

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 교원 관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

    <script>
        
		$(function () {
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

        //  only number input
        function numbersOnly(obj) {
            $(obj).keyup(function(){
                 $(this).val($(this).val().replace(/[^0-9]/g,""));
            }); 
        }

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
                        $("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>");
                        $("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
                        $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
					} else if (level == 2) {
						$("#search_trd_group").html("<option value=\"-1\">-- 3차 기관 --</option>" + data);
                        $("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>");
                        $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
					} else if (level == 3) {
						$("#search_fth_group").html("<option value=\"-1\">-- 4차 기관 --</option>" + data);
                        $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>");
					} else if (level == 4) {
                        $("#search_fith_group").html("<option value=\"-1\">-- 5차 기관 --</option>" + data);
                    }
				},
				error: function(request, textStatus, errorThrown){	//에러에러....
					alert('error: ' + textStatus);
				}
			});
		}
        
        //	data send
        function postForm() {
            if ($("#search_fst_group").val() < 0) {alert("소속 기관을 선택해야 합니다.");$("#search_fst_group").focus();return;}
            if ($("#mem_nm").val().length < 1) {alert("기관 이름은 2자 이상이어야 합니다.");$("#mem_nm").focus();return;}

            $("#postForm").attr("action", "/program/sucheop/admin/sucheop_mem_up.jsp");
            $("#postForm").submit();
        }
    
    </script>

    </head>
<body>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>교원 관리</strong></p>
	</div>
	<div id="content">
		<div class="listArea">
			<form action="" method="post" id="postForm">
			<input type="hidden" name="command" id="command" value="">
			
				<fieldset>
					<legend>상담교사관리</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="25%"/>
						<col width="25%"/>
						<col width="25%"/>
						<col width="25%"/>
						</colgroup>
						
						<tr>
							<th>번호</th>
							<td >
								<input type="text" id="mem_seq" name="mem_seq" for="mem_seq" value="<%=mem_seq%>" readonly style="background-color: #aaa; color: #fff;" />
							</td>
						</tr>
						
						<!-- 기관 선택 -->
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
                                                outHtml	+=	">";
												outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
												outHtml +=	"</option>";
											}
										}
										out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
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
                                                outHtml	+=	">";
												outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
												outHtml +=	"</option>";
											}
										}
										out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
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
                                                outHtml	+=	">";
												outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
												outHtml +=	"</option>";
											}
										}
										out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
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
                                                outHtml	+=	">";
												outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
												outHtml +=	"</option>";
											}
										}
										out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
						<tr>
							<th>5차 기관</th>
							<td >
								<select name="search_fith_group" id="search_fith_group" for="search_fith_group" value="" >
									<option value="-1">-- 5차 기관 선택 --</option>
                                    <%
										outHtml	=	"";
										if (cateList5 != null && cateList5.size() > 0) {
											for (int i = 0; i < cateList5.size(); i++) {
												Map<String, Object> dataMap	=	cateList5.get(i);
												outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ"));
                                                if (cateId5.equals(parseNull((String)dataMap.get("GROUP_SEQ")))) {
                                                    outHtml	+=	" selected='selected'";
                                                }
                                                outHtml	+=	">";
												outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
												outHtml +=	"</option>";
											}
										}
										out.println(outHtml);
									%>
								</select>
							</td>
						</tr>
						<!-- ./기관 선택 -->
						
						<tr>
							<th>이름</th>
							<td >
								<input type="text" id="mem_nm" name="mem_nm" for="mem_nm" value="<%=mem_nm %>" placeholder="필수사항" />
							</td>
						</tr>
						<tr>
							<th>직책</th>
							<td >
								<input type="text" id="mem_grade" name="mem_grade" for="mem_grade" value="<%=mem_grade %>" placeholder="필수사항" />
							</td>
						</tr>
						<tr>
							<th>급수</th>
							<td >
								<input type="text" id="mem_level" name="mem_level" for="mem_level" value="<%=mem_level %>" placeholder="필수사항" />
							</td>
						</tr>
						<tr>
							<th>사무실전화</th>
							<td >
								<input type="text" id="mem_tel" name="mem_tel" for="mem_tel" value="<%=mem_tel %>" placeholder="숫자만 입력" onkeydown="numbersOnly(this);" />
							</td>
						</tr>
						<tr>
							<th>휴대전화</th>
							<td >
								<input type="text" id="mem_mobile" name="mem_mobile" for="mem_mobile" value="<%=mem_mobile %>" placeholder="숫자만 입력" onkeydown="numbersOnly(this);" />
							</td>
						</tr>
						<tr>
							<th>통합로그인 ID</th>
							<td >
								<input type="text" id="mem_sso_id" name="mem_sso_id" for="mem_sso_id" value="<%=mem_sso_id %>" placeholder="필수사항이 아닙니다." />
							</td>
						</tr>
						<tr>
							<th>노출 여부</th>
							<td>
								<input type="radio" id="radio3" name="show_yn" value="Y" <% if (show_flag.equals("Y")) {out.println(" checked='checked' "); } %> />적용
								<input type="radio" id="radio4" name="show_yn" value="N" <% if (show_flag.equals("N")) {out.println(" checked='checked' "); } %> />적용안함
							</td>
						</tr>
					</table>
					<button type="button" onclick="postForm();" class="btn small edge mako">확인</button>
					<!--<button type="button" onclick="alert('닫기 btn');" class="btn small edge mako">닫기</button>-->
				</fieldset>
			</form>
		</div>		
	</div>
	<!-- // content -->
</div>
</body>
</html>