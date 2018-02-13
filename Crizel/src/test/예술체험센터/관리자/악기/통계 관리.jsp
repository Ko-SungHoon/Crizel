<%
/**
*   PURPOSE :   통계 관리
*   CREATE  :   20180207_wed    Ko
*   MODIFY  :   ....
**/
%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%!
private class InsVO{
	public int req_no;
	public String req_id;
	public String req_group;
	public String req_mng_nm;
	public String req_mng_tel;
	public int req_inst_cnt;
	public String req_memo;
	public String reg_ip;
	public String reg_date;
	public String show_flag;
	public String apply_flag;
	public String apply_date;
	
	public int count;
	
	public String inst_cat;
	public String inst_cat_nm;
	public int inst_no;
	public String inst_nm;
	public int inst_req_cnt;
	
	public String inst_name;
	public int max_cnt;
	public int curr_cnt;
	public int rowspan;
	
	public int artcode_no;
	public String code_tbl;
	public String code_col;
	public String code_name;
	public String code_val1;
	public String code_val2;
	public String code_val3;
	public int order1;
	public int order2;
	public int order3;
}
	
private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.req_no			= rs.getInt("REQ_NO");	
    	vo.req_id			= rs.getString("REQ_ID");	
    	vo.req_group		= rs.getString("REQ_GROUP");	
    	vo.req_mng_nm		= rs.getString("REQ_MNG_NM");	
    	vo.req_mng_tel		= rs.getString("REQ_MNG_TEL");	
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");	
    	vo.req_memo			= rs.getString("REQ_MEMO");	
    	vo.reg_ip			= rs.getString("REG_IP");	
    	vo.reg_date			= rs.getString("REG_DATE");	
    	vo.show_flag		= rs.getString("SHOW_FLAG");
    	vo.apply_flag		= rs.getString("APPLY_FLAG");
    	vo.apply_date		= rs.getString("APPLY_DATE");
    	
    	vo.count			= rs.getInt("COUNT");
    	
    	vo.inst_cat			= rs.getString("INST_CAT");	
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");	
    	vo.inst_no			= rs.getInt("INST_NO");	
    	vo.inst_nm			= rs.getString("INST_NM");	
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");	
        return vo;
    }
}

private class TotalList implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");	
    	vo.inst_name		= rs.getString("INST_NAME");	
    	vo.max_cnt			= rs.getInt("MAX_CNT");	
    	vo.curr_cnt 		= rs.getInt("CURR_CNT");
    	vo.rowspan 			= rs.getInt("ROWSPAN");
        return vo;
    }
}

private class CodeList implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
        vo.artcode_no		= rs.getInt("ARTCODE_NO");
        vo.code_tbl 		= rs.getString("CODE_TBL");
        vo.code_col			= rs.getString("CODE_COL");
        vo.code_name 		= rs.getString("CODE_NAME");
        vo.code_val1 		= rs.getString("CODE_VAL1");
        vo.code_val2		= rs.getString("CODE_VAL2");
        vo.code_val3		= rs.getString("CODE_VAL3");
        vo.order1 			= rs.getInt("ORDER1");
        vo.order2 			= rs.getInt("ORDER2");
        vo.order3 			= rs.getInt("ORDER3");
        return vo;
    }
}

private class InstList implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_no 			= rs.getInt("INST_NO");
        vo.inst_name 		= rs.getString("INST_NAME");
        return vo;
    }
}

%>
<%
StringBuffer sql		= null;
List<InsVO> list 		= null;
List<InsVO> totalList 	= null;
List<InsVO> codeList 	= null;
List<InsVO> instList 	= null;
String search1		= parseNull(request.getParameter("search1"));
String search2		= parseNull(request.getParameter("search2"));
String search3		= parseNull(request.getParameter("search3"));
String keyword		= parseNull(request.getParameter("keyword"));
String start_date	= parseNull(request.getParameter("start_date"));
String end_date		= parseNull(request.getParameter("end_date"));
String menuCd		= parseNull(request.getParameter("menuCd"));

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

sql = new StringBuffer();
sql.append("SELECT	COUNT(*) CNT		 																	");
sql.append("FROM ART_INST_REQ A																				");
sql.append("WHERE 1=1					 																	");

if(!"".equals(start_date)){
	sql.append("AND A.REG_DATE >= '").append(start_date).append("'											");
	paging.setParams("start_date", start_date);
}
if(!"".equals(end_date)){
	sql.append("AND A.REG_DATE <= '").append(end_date).append("'											");
	paging.setParams("end_date", end_date);
}
if(!"".equals(search1) && !"".equals(keyword)){
	if("req_id".equals(search1)){
		sql.append("AND REQ_ID LIKE '%").append(keyword).append("%'											");
	}else if("req_mng_nm".equals(search1)){
		sql.append("AND A.REQ_MNG_NM LIKE '%").append(keyword).append("%'									");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}
if(!"".equals(search2)){
	sql.append("AND A.REQ_NO = (																			");
	sql.append("				SELECT REQ_NO																");
	sql.append("				FROM ART_INST_REQ_CNT														");
	sql.append("				WHERE ROWNUM = 1 AND INST_CAT_NM = '").append(search2).append("'			");
	sql.append("				)																			");
	paging.setParams("search2", search2);
}
if(!"".equals(search3)){
	sql.append("AND A.REQ_NO = (																			");
	sql.append("				SELECT REQ_NO																");
	sql.append("				FROM ART_INST_REQ_CNT														");
	sql.append("				WHERE ROWNUM = 1 AND INST_NO = '").append(search3).append("'				");
	sql.append("				)																			");
	paging.setParams("search3", search3);
}

totalCount = jdbcTemplate.queryForObject(
		sql.toString(),
		Integer.class
	);

paging.setPageNo(Integer.parseInt(pageNo));
paging.setTotalCount(totalCount);

sql = new StringBuffer();
sql.append("SELECT * FROM(													");
sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (							");
sql.append("		SELECT			 										");
sql.append("			A.REQ_NO,				 							");
sql.append("			A.REQ_ID,				 							");
sql.append("			A.REQ_GROUP,				 						");
sql.append("			A.REQ_MNG_NM,				 						");
sql.append("			A.REQ_MNG_TEL,				 						");
sql.append("			A.REQ_INST_CNT,				 						");
sql.append("			A.REQ_MEMO,				 							");
sql.append("			A.REG_IP,				 							");
sql.append("			A.REG_DATE,				 							");
sql.append("			A.SHOW_FLAG,				 						");
sql.append("			A.APPLY_FLAG,				 						");
sql.append("			A.APPLY_DATE,				 						");
sql.append("			(SELECT INST_CAT FROM ART_INST_REQ_CNT WHERE REQ_NO 	= A.REQ_NO AND ROWNUM = 1) 	INST_CAT,			");
sql.append("			(SELECT INST_CAT_NM FROM ART_INST_REQ_CNT WHERE REQ_NO 	= A.REQ_NO AND ROWNUM = 1) 	INST_CAT_NM,		");
sql.append("			(SELECT INST_NO FROM ART_INST_REQ_CNT WHERE REQ_NO 		= A.REQ_NO AND ROWNUM = 1) 	INST_NO,			");
/* sql.append("			(SELECT INST_NM FROM ART_INST_REQ_CNT WHERE REQ_NO 		= A.REQ_NO AND ROWNUM = 1) 	INST_NM,			"); */
sql.append("			(SELECT																									");
sql.append("					SUBSTR(																							");
sql.append("							XMLAGG(																					");
sql.append("									XMLELEMENT(COL ,', ', INST_NM) ORDER BY INST_NM).EXTRACT('//text()'				");
sql.append("							).GETSTRINGVAL()																		");
sql.append("					, 2) INST_NM																					");
sql.append("			FROM ART_INST_REQ_CNT																					");
sql.append("			WHERE REQ_NO = A.REQ_NO																					");
sql.append("			GROUP BY REQ_NO) INST_NM,																				");
sql.append("			(SELECT NVL(SUM(INST_REQ_CNT),0) FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO) 	INST_REQ_CNT,		");
sql.append("			(SELECT NVL(COUNT(*),0) FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO) COUNT							");
sql.append("		FROM ART_INST_REQ A																							");
sql.append("		WHERE 1=1					 																				");

if(!"".equals(start_date)){
	sql.append("AND A.REG_DATE >= '").append(start_date).append("'											");
	paging.setParams("start_date", start_date);
}
if(!"".equals(end_date)){
	sql.append("AND A.REG_DATE <= '").append(end_date).append("'											");
	paging.setParams("end_date", end_date);
}
if(!"".equals(search1) && !"".equals(keyword)){
	if("req_id".equals(search1)){
		sql.append("AND REQ_ID LIKE '%").append(keyword).append("%'											");
	}else if("req_mng_nm".equals(search1)){
		sql.append("AND A.REQ_MNG_NM LIKE '%").append(keyword).append("%'									");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}
if(!"".equals(search2)){
	sql.append("AND A.REQ_NO = (																			");
	sql.append("				SELECT REQ_NO																");
	sql.append("				FROM ART_INST_REQ_CNT														");
	sql.append("				WHERE ROWNUM = 1 AND INST_CAT_NM = '").append(search2).append("'			");
	sql.append("				)																			");
	paging.setParams("search2", search2);
}
if(!"".equals(search3)){
	sql.append("AND A.REQ_NO = (																			");
	sql.append("				SELECT REQ_NO																");
	sql.append("				FROM ART_INST_REQ_CNT														");
	sql.append("				WHERE ROWNUM = 1 AND INST_NO = '").append(search3).append("'				");
	sql.append("				)																			");
	paging.setParams("search3", search3);
}

sql.append("ORDER BY A.REQ_NO DESC			 								");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n	");

list = jdbcTemplate.query(
			sql.toString(), 
			new InsVOMapper()
		);

sql = new StringBuffer();
sql.append("SELECT			 																										");
sql.append("	INST_CAT_NM,		 																								");
sql.append("	INST_NAME,		 																									");
sql.append("	MAX_CNT,		 																									");
sql.append("	CURR_CNT,																											");
sql.append("	COUNT(*)OVER(PARTITION BY INST_CAT_NM) AS ROWSPAN																	");
sql.append("FROM ART_INST_MNG																										");
sql.append("WHERE 1=1					 																							");

if(!"".equals(start_date)){
	sql.append("AND REG_DATE >= '").append(start_date).append("'																	");
	paging.setParams("start_date", start_date);
}
if(!"".equals(end_date)){
	sql.append("AND REG_DATE <= '").append(end_date).append("'																		");
	paging.setParams("end_date", end_date);
}
if(!"".equals(search1) && !"".equals(keyword)){
	if("req_id".equals(search1)){
		sql.append("AND INST_NO = 	(	SELECT INST_NO 																				");
		sql.append("			   		FROM ART_INST_REQ_CNT ");
		sql.append("					WHERE ROWNUM = 1 AND REQ_NO = (SELECT REQ_NO												");
		sql.append("												   FROM ART_INST_REQ											");
		sql.append("												   WHERE REQ_ID LIKE '%").append(keyword).append("%'			");
		sql.append("												   )															");
		sql.append("				)																								");
	}else if("req_mng_nm".equals(search1)){
		sql.append("AND INST_NO = 	(	SELECT INST_NO 																				");
		sql.append("					FROM ART_INST_REQ_CNT 																		");
		sql.append("					WHERE ROWNUM = 1 AND REQ_NO =	(	SELECT REQ_NO 											");
		sql.append("														FROM ART_INST_REQ 										");
		sql.append("														WHERE REQ_MNG_NM LIKE '%").append(keyword).append("%'	");
		sql.append("													)															");
		sql.append("				)																								");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}
if(!"".equals(search2)){
	sql.append("AND INST_CAT_NM = '").append(search2).append("'																		");
	paging.setParams("search2", search2);
}
if(!"".equals(search3)){
	sql.append("AND INST_NO = '").append(search3).append("'																			");
	paging.setParams("search3", search3);
}
sql.append("ORDER BY INST_CAT_NM		 																							");


totalList = jdbcTemplate.query(
		sql.toString(), 
		new TotalList()
	);

sql = new StringBuffer();
sql.append("SELECT *								");
sql.append("FROM ART_PRO_CODE						");
sql.append("WHERE CODE_NAME = 'ART_INST_MNG' 		");
sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
codeList = jdbcTemplate.query(
			sql.toString(), 
			new CodeList()
			);

sql = new StringBuffer();
sql.append("SELECT INST_NO, INST_NAME			");
sql.append("FROM ART_INST_MNG					");
sql.append("WHERE INST_CAT_NM = ? 				");
sql.append("ORDER BY INST_NAME			 		");
instList = jdbcTemplate.query(
			sql.toString(), 
			new Object[]{search2},
			new InstList()
			);


num = paging.getRowNo();
%>



<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
<script>
$.datepicker.regional['kr'] = {
	    closeText: '닫기', // 닫기 버튼 텍스트 변경
	    currentText: '오늘', // 오늘 텍스트 변경
	    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
	    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
	    dayNames: ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'], // 요일 텍스트 설정
	    dayNamesShort: ['월','화','수','목','금','토','일'], // 요일 텍스트 축약 설정
	    dayNamesMin: ['월','화','수','목','금','토','일'] // 요일 최소 축약 텍스트 설정
	};
$.datepicker.setDefaults($.datepicker.regional['kr']);

$(function() {
		//시작일
		$('#start_date').datepicker({
               dateFormat: "yy-mm-dd",             // 날짜의 형식
               changeMonth: true,
               //minDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이전 날짜 선택 불가)
               onClose: function( selectedDate ) {    
                   // 시작일(fromDate) datepicker가 닫힐때
                   // 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
                   $("#end_date").datepicker( "option", "minDate", selectedDate );
               }                
           });
           //종료일
           $('#end_date').datepicker({
               dateFormat: "yy-mm-dd",
               changeMonth: true,
               onClose: function( selectedDate ) {
                   // 종료일(toDate) datepicker가 닫힐때
                   // 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정 
                   $("#start_date").datepicker( "option", "maxDate", selectedDate );
               }                
           });
});
</script>
		
		
<script>
function instSelect(inst_cat_nm){
	var htmlVal = "";
	
	$.ajax({
		type : "POST",
		url : "/program/art/insAdmin/instNmSelect.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			inst_cat_nm : inst_cat_nm
		},
		datatype : "json",
		success : function(data) {
			htmlVal += "<option value=''>선택</option>";
			$.each(JSON.parse(data), function(i, val) {				//ajax로 받아온 json 데이터를 html로 구성한다
				htmlVal += "<option value='"+ val.inst_no +"'>";
				htmlVal += val.inst_name;
				htmlVal += "</option>";
			});
			$("#search3").html(htmlVal);							//프로그램 리스트 출력
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

function searchSubmit(){
	$("#searchForm").attr("action", "").submit();
}
function getPopup(type){
	var addr = "/program/art/insAdmin/instMngPopup.jsp";
	newWin(addr, 'PRINTVIEW', '1000', '740');
}

function updateSubmit(req_no){
	var addr = "/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no;
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function applySubmit(req_no, apply_flag, inst_no){
	var msg;
	
	if(apply_flag == "N"){
		msg = "악기대여 신청을 승인하시겠습니까?";
		apply_flag = "Y";
	}else if(apply_flag == "Y"){
		msg = "악기대여 신청을 취소하시겠습니까?";
		apply_flag = "A";
	}
	
	if(confirm(msg)){
		location.href="/program/art/insAdmin/instMngAction.jsp?mode=apply&req_no="+req_no+"&apply_flag="+apply_flag+"&inst_no="+inst_no;
	}else{
		return false;
	}
}

function excel(){
	$("#searchForm").attr("method", "post");
	$("#searchForm").attr("action", "/program/art/insAdmin/excel.jsp");
	$("#searchForm").submit();
}

</script>
<section class="board">
	<div class="search" style="text-align: left;">
		<form id="searchForm" method="get">
			<fieldset>
				<input type="hidden" id="menuCd" name="menuCd" value="<%=menuCd%>">
				<input type="text" id="start_date" name="start_date" readonly value="<%=start_date%>"> 
				<input type="text" id="end_date" name="end_date" readonly value="<%=end_date%>">
				<label for="search1">검색분류</label> 
				<select id="search1" name="search1">
					<option value="">선택</option>
					<option value="req_id" <%if("req_id".equals(search1)){%> selected="selected" <%}%>>아이디</option>
					<option value="req_mng_nm" <%if("req_mng_nm".equals(search1)){%> selected="selected" <%}%>>신청자명</option>
				</select>
				<label for="keyword">검색어</label> 
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				
				<br>
				
				<select id="search2" name="search2" onchange="instSelect(this.value)">
					<option value="">--악기분류--</option>
					 <%
                      if(codeList!=null && codeList.size()>0){
                      for(InsVO ob : codeList){
                      %>
                          <option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(search2)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
                      <%
                      }
                      }
                      %>
				</select>
				<select id="search3" name="search3">
					<option value="">--악기명--</option>
					<%
					if(instList!=null && instList.size()>0){
					for(InsVO ob : instList){
					%>
					<option value="<%=ob.inst_no%>" <%if(Integer.toString(ob.inst_no).equals(search3)){%> selected <%}%> ><%=ob.inst_name%></option>
					<% 
					}
					}
					
					%>
				</select>
				<button onclick="searchSubmit();">검색하기</button>
				<button type="button" onclick="excel();">엑셀 다운로드</button>
			</fieldset>
		</form>
	</div>
	<p>
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<table class="tb_board">
		<caption>악기 신청관리 테이블</caption>
		<colgroup>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">분류</th>
				<th scope="col">악기명</th>
				<th scope="col">대여수</th>
				<th scope="col">아이디</th>
				<th scope="col">신청자명</th>
				<th scope="col" class="rfc_bbs_list_last">신청일</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(InsVO ob : list){ %>
			<tr>
				<td><%=num--%></td>
				<td><%=ob.inst_cat_nm%></td>
				<td>
					<%=ob.inst_nm %>
				</td>
				<td><%=ob.inst_req_cnt %></td>
				<td><%=ob.req_id %></td>
				<td><%=ob.req_mng_nm %></td>
				<td><%=ob.reg_date%></td>
			</tr>
			<%
			}
			%>
			<tr>
				<td>계</td>
				<td colspan="6">
					<table class="tb_board">
					<thead>
						<tr>
							<th scope="col">분류</th>
							<th scope="col">악기명</th>
							<th scope="col" class="rfc_bbs_list_last">대여량/총량</th>
						</tr>
					</thead>
					<tbody>
					<%
					String inst_cat_nm = "";
					for(InsVO ob : totalList){ 
					%>
					  	<tr>
					  		<%
					  		if(!inst_cat_nm.equals(ob.inst_cat_nm)){
					  		%>
							<td rowspan="<%=ob.rowspan%>"><%=ob.inst_cat_nm%></td>
							<%
							} 
							%>
							<td><%=ob.inst_name %></td>
							<td><%=ob.curr_cnt %> / <%=ob.max_cnt %></td>
						</tr>
					<%
					inst_cat_nm = ob.inst_cat_nm;
					} %>
					</tbody>
					</table>
				</td>
			</tr>
			<%
			}else{
			%>
			<tr>
				<td colspan="7">등록된 게시물이 없습니다.</td>
			</tr>
			<%
			} 
			%>
		</tbody>
	</table>
	
	<% if(paging.getTotalCount() > 0) { %>
	<div class="pageing">
		<%=paging.getHtml("2") %>
	</div>
	<% } %>
</section>