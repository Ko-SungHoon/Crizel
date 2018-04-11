<%
/**
*   PURPOSE :   조사자(팀장) 관리 - 목록
*   CREATE  :   20180319_mon    Ko
*   MODIFY  :   체크박스 추가	20180327_tue	JI
*   MODIFY  :   엑셀업로드 추가	20180403_tue	KO
*   MODIFY  :   학교/기관 select 추가 set the query where setting value	20180404_wed	JI
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
SessionManager sessionManager = new SessionManager(request);
String pageTitle = "조사자(팀장) 관리";
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > <%=pageTitle %></title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
        <script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script>
</script>
</head>
<body>
<%
String searchSch	= parseNull(request.getParameter("searchSch"), "sch");   //권역
String whereSchType	= " AND A.SCH_TYPE NOT IN ('Z', 'Y', 'X', 'V')		";
if ("ang".equals(searchSch)) {
	whereSchType	= " AND A.SCH_TYPE IN ('Z', 'Y', 'X', 'V')		";
}
String search0		= parseNull(request.getParameter("search0"));   //권역
String search2		= parseNull(request.getParameter("search2"));   //팀
String search3		= parseNull(request.getParameter("search3"));   //조사자/조사팀장 여부
String search1		= parseNull(request.getParameter("search1"));   //검색 선택 분류
String keyword		= parseNull(request.getParameter("keyword"));   //검색어

StringBuffer sql 		= null;
Object[] setObj         = null;
List<String> setList	= new ArrayList<String>();
List<FoodVO> foodList 	= null;
List<FoodVO> zoneList	= null;
List<FoodVO> teamList	= null;

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt = 0;
int num = 0;

try{

	sql = new StringBuffer();
	sql.append(" SELECT COUNT(*)																		");
	sql.append(" FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B												");
	sql.append(" ON A.SCH_NO = B.SCH_NO																	");
	sql.append(" WHERE (B.SHOW_FLAG = 'Y'																");
	sql.append(" 	OR A.SCH_NO IN (SELECT A.SCH_NO														");
	sql.append("        			FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO	");
	sql.append("         		 	GROUP BY A.SCH_NO, B.NU_NO											");
	sql.append("         		 	HAVING NVL(B.NU_NO,0) = 0))											");
	sql.append(whereSchType);
	
	if(!"".equals(search0)){
		sql.append(" AND A.ZONE_NO = ?								");
		setList.add(search0);
		paging.setParams("search0", search0);
	}
	if(!"".equals(search1) && !"".equals(keyword) ){
		if("sch_nm".equals(search1)){
			sql.append(" AND A.SCH_NM LIKE '%'||?||'%'				");
		}else if("nu_nm".equals(search1)){
			sql.append(" AND B.NU_NM LIKE '%'||?||'%'				");
		}
		setList.add(keyword);
		paging.setParams("search1", search1);
		paging.setParams("keyword", keyword);
	}
	if(!"".equals(search2)){
		sql.append(" AND A.TEAM_NO = ?								");
		setList.add(search2);
		paging.setParams("search2", search2);
	}
	if(!"".equals(search3)){
		sql.append(" AND A.SCH_GRADE = ?							");
		setList.add(search3);
		paging.setParams("search3", search3);
	}
	
	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}
	
	try{
		totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);
	}catch(Exception e){
		totalCount = 0;
	}
	
	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(15);
	paging.makePaging();

	sql = new StringBuffer();
	sql.append(" SELECT * FROM(												");
	sql.append("	SELECT ROWNUM AS RNUM, C.* FROM (						");
	sql.append(" SELECT														");
	sql.append("	A.SCH_NO,												");
	sql.append("	A.SCH_ORG_SID,											");
	sql.append("	A.SCH_TYPE,												");
	sql.append("	A.SCH_ID,												");
	sql.append("	A.SCH_NM,												");
	sql.append("	A.SCH_TEL,												");
	sql.append("	A.SCH_FAX,												");
	sql.append("	A.SCH_AREA,												");
	sql.append("	A.SCH_POST,												");
	sql.append("	A.SCH_ADDR,												");
	sql.append("	A.SCH_FOUND,											");
	sql.append("	A.SCH_URL,												");
	sql.append("	A.SCH_GEN,												");
	sql.append("	A.SHOW_FLAG,											");
	sql.append("	TO_CHAR(A.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,			");
	sql.append("	A.ZONE_NO,												");
	sql.append("	A.CAT_NO,												");
	sql.append("	A.TEAM_NO,												");
	sql.append("	A.SCH_GRADE,											");
	sql.append("	A.SCH_LV,												");
	sql.append("	A.SCH_PW,												");
	sql.append("	A.SCH_APP_FLAG,											");
	sql.append("	A.APP_DATE,												");
	sql.append("	A.ETC1,													");
	sql.append("	A.ETC2,													");
	sql.append("	A.ETC3,													");
	sql.append("	B.NU_NO,												");
	sql.append("	B.NU_NM,												");
	sql.append("	B.NU_TEL,												");
	sql.append("	B.NU_MAIL, 												");
	sql.append("	(	SELECT ZONE_NM 										");
	sql.append("		FROM FOOD_ZONE										");
	sql.append("		WHERE ZONE_NO = A.ZONE_NO	) AS ZONE_NM,			");
	sql.append("	(	SELECT CAT_NM 										");
	sql.append("		FROM FOOD_ST_CAT									");
	sql.append("		WHERE CAT_NO = A.CAT_NO	) AS CAT_NM,				");
	sql.append("	(	SELECT TEAM_NM 										");
	sql.append("		FROM FOOD_TEAM										");
	sql.append("		WHERE TEAM_NO = A.TEAM_NO	) AS TEAM_NM,			");
	sql.append("	(	SELECT JO_NM 										");
	sql.append("		FROM FOOD_JO										");
	sql.append("		WHERE JO_NO = A.JO_NO	) AS JO_NM,					");
    sql.append("	(	SELECT AREA_NM 										");
	sql.append("		FROM FOOD_AREA										");
	sql.append("		WHERE AREA_NO = A.AREA_NO	) AS AREA_NM,			");
	sql.append("	(	SELECT NVL(COUNT(RSCH_ITEM_NO), 0)					");
	sql.append("		FROM FOOD_RSCH_ITEM									");
	sql.append("		WHERE SCH_NO = A.SCH_NO	) AS RSCH_ITEM_CNT			");
	sql.append(" FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B					");
	sql.append(" ON A.SCH_NO = B.SCH_NO										");
	sql.append(" WHERE (B.SHOW_FLAG = 'Y'									");
	sql.append(" 	OR A.SCH_NO IN (SELECT A.SCH_NO														");
	sql.append("        			FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO	");
	sql.append("         		 	GROUP BY A.SCH_NO, B.NU_NO											");
	sql.append("         		 	HAVING NVL(B.NU_NO,0) = 0))											");
	sql.append(whereSchType);
	
	if(!"".equals(search0)){
		sql.append(" AND A.ZONE_NO = ?										");
	}
	if(!"".equals(search1) && !"".equals(keyword) ) {
		if("sch_nm".equals(search1)) {
			sql.append(" AND A.SCH_NM LIKE '%'||?||'%'						");
		}else if("nu_nm".equals(search1)) {
			sql.append(" AND B.NU_NM LIKE '%'||?||'%'						");
		}
	}
	if(!"".equals(search2)){
		sql.append(" AND A.TEAM_NO = ?										");
	}
	if(!"".equals(search3)){
		sql.append(" AND A.SCH_GRADE = ?									");
	}
	
	
	sql.append(" ORDER BY DECODE(A.SCH_APP_FLAG, 'N', 1, 'Y', 2), SCH_NM		");
	sql.append("	) C WHERE ROWNUM <= ").append(paging.getEndRowNo()).append("	");
	sql.append(" ) WHERE RNUM > ").append(paging.getStartRowNo()).append(" 			");

	foodList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);

	sql = new StringBuffer();
	sql.append(" SELECT *				 ");
	sql.append(" FROM FOOD_ZONE 			 ");
	sql.append(" WHERE SHOW_FLAG = 'Y'	 ");
	sql.append(" ORDER BY ZONE_NM 		 ");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	if(!"".equals(search0)){
		sql = new StringBuffer();
		sql.append(" SELECT *				 					");
		sql.append(" FROM FOOD_TEAM 			 					");	
		sql.append(" WHERE SHOW_FLAG = 'Y' AND ZONE_NO = ?		");
		sql.append(" ORDER BY ORDER1, TEAM_NM	");
		teamList = jdbcTemplate.query(sql.toString(), new FoodList(), search0);
	}
	
}catch(Exception e){
	out.println(e.toString());
}


%>
<script>

    function applySubmit(sch_no, sch_app_flag){
        if(confirm("승인상태를 변경하시겠습니까?")){
            $.ajax({
                type : "POST",
                url : "/program/food/research/researcher_approval.jsp",
                data : {"sch_no" : sch_no,
                        "sch_app_flag" : sch_app_flag},
                success : function(data){
                    if(data.trim() == "OK"){
                        alert('정상적으로 처리되었습니다.');
                        location.reload();
					}else if(data.trim() == "OVER"){
						alert("조사식품이 있는 학교는 취소처리할 수 없습니다.\n조사식품을 모두 삭제 후 취소처리하세요.");
                    }else{
                        alert("처리 중 오류가 발생하였습니다.");				
                    }
                },
                error : function(request, status, error){
                    alert("처리 중 오류가 발생하였습니다..");
                }
            });
        }else{
            return;
        }
    }

	function schSelect (value) {
		location.href	=	"/program/food/research/food_research_list.jsp?searchSch="+ value;
	}

	/* 권역 선택 select */
    function teamSelect(value){
        var zone_no = value;
        $.ajax({
            type : "POST",
            url : "/program/food/research/team_list.jsp",
            data : {"zone_no" : zone_no},
            async : false,
            success : function(data){
                $("#search2").html(data.trim());
            },
            error : function(request, status, error){
            }
        });
    }

    $(function() {

        //전체 체크박스 event
        $(".all_chk").click(function () {

            if ($(".all_chk").is(":checked")) {
                $(".sch_chk").prop('checked', true);
                return;
            }
            $(".sch_chk").prop('checked', false);
            return;
            
        });
    });

    //일괄승인 function
    function wholeAcept () {
        //1st check cnt
        var chk_class   =   $(".sch_chk");
        if (chk_class.length < 1) {
            alert("승인대상이 없습니다.");
            return;
        }
        var chk_val     =   "";
        //2nd check checked val
        for (var i = 0; i < chk_class.length; i++) {
            if (chk_class.eq(i).is(":checked") && chk_val.length > 0) {
                chk_val +=  "," + chk_class.eq(i).val();
            } else if (chk_class.eq(i).is(":checked")) {
                chk_val =   chk_class.eq(i).val();
            }
        }
        
        //3rd check value chk
        if (chk_val.length < 1) {
            alert("승인대상을 선택하세요.");
            return;
        }
        //4th submit
		if (confirm("선택한 대상을 승인 하시겠습니까?") == true) {
			var sch_app_flag    =   "Y";
			$.ajax({
				type : "POST",
				url : "/program/food/research/researcher_approval.jsp",
				data : {"sch_no" : chk_val,
						"sch_app_flag" : sch_app_flag},
				success : function(data){
					if(data.trim() == "OK") {
						alert('정상적으로 처리되었습니다.');
						location.reload();
					}else{
						alert(data.trim());
						alert("처리 중 오류가 발생하였습니다.");
					}
				},
				error : function(request, status, error){
					alert("처리 중 오류가 발생하였습니다..");
				}
			});
		}
    }
    
	//excel sample
	function sampleExcel () {
		if (confirm("조사자, 권역 샘플 엑셀을 다운로드 하시겠습니까?")) {
			location.href	=	"/img/food/food_zone_sample.xls";
		}
		return;
	}

	//excel dw
	function downExcel () {
		if (confirm("조사자 엑셀을 다운로드 하시겟습니까?")) {

		}
		return;
	}
    
  	//excel up
    function upExcel () {
        if (confirm("조사자, 권역 엑셀을 업로드 하시겠습니까?\n전반적인 조사자 설정이 변경됩니다.")) {
            $("#researcher_file").click();
        }
        return;
    }
  
    function setFile () {
        //파일 검증
        var fileName    =   $("#researcher_file").val().split("\\")[$("#researcher_file").val().split("\\").length -1];
        var fileExtName =   $("#researcher_file").val().split(".")[$("#researcher_file").val().split(".").length -1];
        fileExtName     =   fileExtName.toLowerCase();
        if ($.inArray(fileExtName, ['xls'/* , 'xlsx' */]) == -1) {
            alert ("xls 형식의 엑셀 파일만 등록이 가능합니다.");
            $(this).val("");
            return;
        }
        
        $("#researcher_excel_form").attr("action", "./researcher_excel_up.jsp");
        $("#researcher_excel_form").submit();
    }
    
    function newWin(url, title, w, h){
        var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
        var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

        var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
        var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        var left = ((width / 2) - (w / 2)) + dualScreenLeft;
        var top = ((height / 2) - (h / 2)) + dualScreenTop;
        var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    }
    
    function zonePopup(){newWin("food_zone_popup.jsp", 'PRINTVIEW', '1000', '740');}

</script>

<div id="right_view">
	<div class="top_view">
		<p class="location"><strong><%=pageTitle %></strong></p>
		<p class="loc_admin">
			<a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
			<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
		</p>
	</div>
</div>
<!-- S : #content -->
	<div id="content">
	<div class="searchBox magB20">
		<form id="researcher_excel_form" enctype="multipart/form-data" method="post">
           <input type="file" id="researcher_file" name="researcher_file" value="" onchange="setFile()" style="display: none;">
       </form>
	
		<p class="boxin">
            <button type="button" class="btn medium mako" onclick="zonePopup()">권역/팀 수정</button>
		</p>
		
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<select id="searchSch" name="searchSch" onchange="schSelect(this.value)">
					<option value="sch" <%if ("sch".equals(searchSch)) {out.println("selected");}%>>학교</option>
					<option value="ang" <%if ("ang".equals(searchSch)) {out.println("selected");}%>>기관</option>
				</select>
		<%if ("sch".equals(searchSch)) {%>
                <select id="search0" name="search0" onchange="teamSelect(this.value)">
					<option value="">권역선택</option>
					<%
					if(zoneList!=null && zoneList.size()>0){
						for(FoodVO ob : zoneList){
							out.println("<option value='" + ob.zone_no + "' ");
							if(ob.zone_no.equals(search0)){
								out.println("selected");
							}
							out.println(">");
							out.println(ob.zone_nm + "</option>");
						}
					}
					%>
				</select>
                <select id="search2" name="search2">
					<option value="">팀선택</option>
					<%
					if(teamList!=null && teamList.size()>0){
						for(FoodVO ob : teamList){
					%>	
					<option value="<%=ob.team_no %>" 
					<%if(ob.team_no.equals(search2)){out.println("selected");}%>><%=ob.team_nm %></option>
					<%
						}
					}
					%>
				</select>
		<%}/** END IF searchSch **/%>
                <select id="search3" name="search3">
					<option value="">조사자/팀장</option>
					<option value="R" <%if("R".equals(search3)){out.println("selected");}%>>조사자</option>
					<option value="T" <%if("T".equals(search3)){out.println("selected");}%>>조사팀장</option>
				</select>
				<select id="search1" name="search1">
					<option value="">선택</option>
					<option value="sch_nm" <%if("sch_nm".equals(search1)){out.println("selected");}%>>학교명</option>
					<option value="nu_nm" <%if("nu_nm".equals(search1)){out.println("selected");}%>>영양사</option>
				</select>
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
				<div class="f_r">
					<button type="button" class="btn small edge mako" onclick="sampleExcel();">샘플엑셀</button>
					<button type="button" class="btn small edge mako" onclick="upExcel();">엑셀업로드</button>
					<button type="button" class="btn small edge mako" onclick="downExcel();">엑셀다운로드</button>
				</div>
			</fieldset>
		</form>
	</div>
	<div class="f_r">
		<!-- <button type="button" class="btn small edge darkMblue" onclick="">추가</button> -->
        <button type="button" class="btn small edge darkMblue" onclick="wholeAcept();">일괄승인</button>
	</div>
	<p class="f_l magT10">
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<p class="clearfix"></p>
	<table class="bbs_list">
		<caption>조사자(팀장) 정보 테이블</caption>
		<colgroup>
            <col style="width: 2%">
			<col style="width: 2%">
			<col style="width: 5%">
			<col style="width: 5%">
			<col style="width: 5%">
			<col style="width: 5%">
			<col style="width: 5%">
			<col style="width: 8%">
			<col style="width: 5%">
			<col>
			<col style="width: 5%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 5%">
			<col style="width: 10%">
		</colgroup>
		<thead>
			<tr>
                <th><input type="checkbox" value="all" class="all_chk"></th>
				<th scope="col">순서</th>
				<th scope="col">기관/학교</th>
				<th scope="col">권역</th>
				<th scope="col">품목</th>
				<th scope="col">팀</th>
				<th scope="col">조</th>
				<th scope="col">지역</th>
				<th scope="col">조사 식품 수</th>
				<th scope="col">학교/기관명</th>
				<th scope="col">조사자/조사팀장</th>
				<th scope="col">영양사명</th>
				<th scope="col">등록일</th>
				<th scope="col">승인여부</th>
				<th scope="col">승인일시</th>
			</tr>
		</thead>
		<tbody>
		<%
		num = paging.getRowNo();
		if(foodList!=null && foodList.size()>0){
			for(FoodVO vo : foodList){
		%>
			<tr>
                <td><input type="checkbox" class="sch_chk" value="<%=vo.sch_no %>"></td>
				<td><%=num-- %></td>
				<td><%if("ang".equals(searchSch)){out.println("기관");}else{out.println("학교");}%></td>
				<td><%=vo.zone_nm%></td>
				<td><%=vo.cat_nm%></td>
				<td><%=vo.team_nm %></td>
				<td><%=vo.jo_nm %></td>
				<td><%=vo.area_nm %></td>
                <td><%=vo.rsch_item_cnt %></td>
				<td><a href="food_research_view.jsp?sch_no=<%=vo.sch_no%>"><%=vo.sch_nm %></a></td>
				<td><%=outSchGrade(vo.sch_grade) %></td>
				<td><%=vo.nu_nm %></td>
				<td><%=vo.reg_date%></td>
				<td>
				<%
				if("N".equals(vo.sch_app_flag)){
				%>
					<button class="btn small edge green" type="button" onclick="applySubmit('<%=vo.sch_no%>', 'Y')">승인</button>
				<%}else if("Y".equals(vo.sch_app_flag)){ %>
					<button class="btn small edge white" type="button" onclick="applySubmit('<%=vo.sch_no%>', 'N')">취소</button>
				<%} %>
				</td>
				<td><%=vo.app_date %></td>
			</tr>
		<%
			}
		}else{
		%>	
			<tr>
				<td colspan="15">데이터가 없습니다.</td>			
			</tr>
		<%} %>
		</tbody>
	</table>

	<% if(paging.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging.getHtml() %>
	</div>
	<% } %>
</div>
<!-- // E : #content -->
</body>
</html>
