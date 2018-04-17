<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교찾기</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<%!
public String phoneConvert(String phoneNumber){
	String regEx = "(\\d{3})(\\d{3,4})(\\d{4})";
	return phoneNumber.replaceAll(regEx, "$1-$2-$3");
}
%>		
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String sid = "";
String title = "";
String writer = "";
String addr = "";
String url = "";
String tel = "";
String fax = "";
String area_type = "";
String coedu = "";
String cate1 = "";
String cate2 = "";
String post = "";
String code = "";
String search1 = request.getParameter("search1")==null?"":request.getParameter("search1");
String keyword = request.getParameter("keyword")==null?"":request.getParameter("keyword");

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

List<Map<String, Object>> dataList = null;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();


	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) AS CNT FROM SCHOOL_SEARCH ");
	sql.append("WHERE 1=1 ");

	if(!"".equals(keyword)){
		if("title".equals(search1)){
			sql.append("AND TITLE LIKE '%'||?||'%' ");
		}else if("writer".equals(search1)){
			sql.append("AND WRITER LIKE '%'||?||'%' ");
		}
		paging.setParams("search1", search1);
		paging.setParams("keyword", keyword);
	}

	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(keyword) && !"".equals(search1)){
		++cnt;
		pstmt.setString(cnt, keyword);
	}

	rs = pstmt.executeQuery();
	if(rs.next())
		totalCount = rs.getInt("CNT");

	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);

	cnt = 0;

	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");
	sql.append("		SELECT \n");
	sql.append("			SID, CODE, TITLE, ADDR, URL, TEL, FAX, AREA_TYPE, COEDU, CATE1, CATE2, POST \n");
	sql.append("		FROM SCHOOL_SEARCH WHERE 1=1 \n");

	if(!"".equals(keyword)){
		if("title".equals(search1)){
			sql.append("AND TITLE LIKE '%'||?||'%' ");
		}else if("writer".equals(search1)){
			sql.append("AND WRITER LIKE '%'||?||'%' ");
		}
		paging.setParams("search1", search1);
		paging.setParams("keyword", keyword);
	}

	sql.append("		ORDER BY TITLE \n");
	sql.append("	) A WHERE ROWNUM < ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");

	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(keyword) && !"".equals(search1)){
		++cnt;
		pstmt.setString(cnt, keyword);
	}

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

<script>
	$(function(){
		$("#allCheck").click(function(){
			if($(this).is(":checked")){
				$("input[name=delCheck").prop("checked", "checked");
			}else{
				$("input[name=delCheck").removeAttr("checked");
			}
		});
	});

	function del(){
		var cnt = 0;
		$("input[name=delCheck]:checked").each(function() {
			cnt++;
		});

		if(cnt > 0){
			if (confirm("삭제 하시겠습니까?")){
				 return true;
				}else{
				  return false;
				}
		}else{
			alert("항목을 선택하여 주시기 바랍니다.");
			return false;
		}
	}
</script>
</head>
<body>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>학교찾기</strong></p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="" method="post" id="searchForm">
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
					<select name="search1" id="search1">
						<option value="title">학교명</option>
					</select>
					<input type="text" name="keyword" id="keyword" value="<%=keyword%>">
					<input type="submit" value="검색하기" class="btn small edge mako">
					<div class="btn_area txt_r">
						<button type="button" class="btn medium edge darkMblue" onclick="new_win2('excelForm.jsp','group_form','700','600','yes','yes','yes');" >일괄등록</button>
					</div>
				</fieldset>
			</form>
		</div>

		<div class="listArea">
			<form action="del.jsp" method="post" id="listForm" onsubmit="return del();">
				<fieldset>
					<legend>학교찾기 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="5%"/>
						<col width="5%"/>
						<col width="15%"/>
						<col width="25%"/>
						<col />
						<col width="15%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="title"><input type="checkbox" name="allCheck" id="allCheck" ></th>
								<th scope="col">번호</th>
								<th scope="col">학교코드</th>
								<th scope="col">학교명</th>
								<th scope="col">주소</th>
								<th scope="col">전화번호</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								sid = parseNull(map.get("SID").toString());
								title = parseNull(map.get("TITLE").toString());
								addr = parseNull(map.get("ADDR").toString());
								tel = parseNull(map.get("TEL").toString());
								post = parseNull(map.get("POST").toString());
								code = parseNull(map.get("CODE").toString());
						%>
							<tr>
								<td class="title"><input type="checkbox" name="delCheck" value="<%=sid%>"></td>
								<td><%=num-- %></td>
								<td><%=code%></td>
								<td><a href="view.jsp?sid=<%=sid%>"><%=title %></a></td>
								<td class="txt_l"><%if(!"".equals(post)){%> (<%=post%>) <%}%> <%=addr %></td>
								<td><%=phoneConvert(tel) %></td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="6">데이터가 없습니다.</td>
							</tr>
						<%
						}
						%>
						</tbody>
					</table>
					<div class="btn_area">
							<button class="btn small edge white">선택삭제</button>
							<button class="btn small edge darkMblue" type="button" onclick="location.href='insert.jsp?command=insert'">등록</button>
					</div>
				</fieldset>
			</form>
		</div>
		<% if(paging.getTotalCount() > 0) { %>
		<div class="page_area">
			<%=paging.getHtml() %>
		</div>
		<% } %>
	</div>
	<!-- // content -->
</div>
</body>
</html>
