<%
/**
*   PURPOSE :   업데이트 요청 Client View
*   CREATE  :   20180410_fri    JI
*   MODIFY  :   20180416_mon    JI  조사자, 조사팀장일 경우에만 접속 가능/관리자
*	MODIFY	:	20180425_wed	KO		학교급식 관리자 권한 추가
**/
%>

<%@ page import="egovframework.rfc3.menu.web.CmsManager" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
String foodRole		= 	"ROLE_000012";		//운영서버:ROLE_000094 , 테스트서버:ROLE_000012	

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);

String moveUrlMain	=	"/index.gne?menuCd=DOM_000000127000000000";		//메인페이지	운영서버:DOM_000002101000000000, 테스트서버:DOM_000000127000000000
String updatePage	= 	"/index.gne?menuCd=DOM_000000127005000000";		//업데이트요청	운영서버:DOM_000002101005000000, 테스트서버:DOM_000000127005000000
String updatePopup	= 	"/index.gne?menuCd=DOM_000000127005003000";		//업데이트요청	운영서버:DOM_000002101005001000, 테스트서버:DOM_000000127005003000

//paging
Paging paging	=	new Paging();
String pageNo   =   parseNull(request.getParameter("pageNo"), "1");
int totalCount  =   0;

//search
String foodItem     =   parseNull(request.getParameter("foodItem"));    //검색 분류
String foodName     =   parseNull(request.getParameter("foodName"));    //검색어
String keywordCate  =   parseNull(request.getParameter("keywordCate")); //검색 분류
String keywordInp   =   parseNull(request.getParameter("keywordInp"));  //검색어
String chkFinish    =   parseNull(request.getParameter("chkFinish"));  //반영 완료 보기 checkbox

//where
Object[] setObj         = null;
List<String> setList	= new ArrayList<String>();

//list
StringBuffer sql 		= null;
List<FoodVO> catList 	= null;
List<FoodVO> updateList	= null;

String yourLevel    =   null;

int viewYN			=	0;		//1일경우 페이지 정상 작동

//2차 로그인 여부
if("Y".equals(session.getAttribute("foodLoginChk")) || sManager.isRoleAdmin() || sManager.isRole(foodRole)){
	viewYN	=	1;
}else{
	out.print("<script> 						\n");
	out.print("alert('2차 로그인 후 이용하실 수 있습니다.');	\n");
	out.print("history.back(); 					\n");
	out.print("</script> 						\n");
	return;
}

try{
    //조사팀장 확인
    //로그인 여부 부터 확인
    if (sManager.getId() == null || sManager.getId().length() < 1) {
        out.println("<script>");
        out.println("alert('로그인 후 이용 바랍니다.');");
        out.println("location.href=\""+moveUrlMain+"\";");
        out.println("</script>");
        return;
    } else {
        if (!sManager.isRoleAdmin()) {
            sql =   new StringBuffer();
            sql.append(" SELECT SCH_GRADE FROM FOOD_SCH_TB WHERE SCH_ID = ? ");
            yourLevel   =   jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{sManager.getId()});
            if (("T".equals(yourLevel)) || sManager.isRoleAdmin() || sManager.isRole(foodRole)) {
            } else {
                out.println("<script>");
                out.println("alert('조사팀장만 업데이트 요청이 가능합니다.');");
                out.println("location.href=\""+moveUrlMain+"\";");
                out.println("</script>");
                return;
            }
        }
    }

    //품목 리스트 조회
    sql =   new StringBuffer();
    sql.append(" SELECT *               ");
    sql.append(" FROM FOOD_ST_CAT       ");
    sql.append(" WHERE SHOW_FLAG = 'Y'  ");
    sql.append(" ORDER BY CAT_NO        ");
    try{
		catList =   jdbcTemplate.query(sql.toString(), new FoodList());
	}catch(Exception e){
		catList =   null;
	}

    //업데이트 리스트 전체 수
    sql =   new StringBuffer();
    sql.append(" SELECT COUNT(*) FROM (														");
	sql.append(" SELECT 																	");
	sql.append("    (SELECT NU_NM FROM FOOD_SCH_NU											");
	sql.append("    WHERE NU_NO = A.NU_NO) AS NU_NM,     									");
	sql.append(" 	(SELECT SUBSTR(XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'	");
	sql.append(" 	).GETSTRINGVAL(),2) NM_FOOD												");
	sql.append(" 	FROM FOOD_ST_NM															");
	sql.append(" 	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	");
	sql.append(" 	AS NM_FOOD,																");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 	XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'			");
	sql.append(" 	).GETSTRINGVAL(),2) DT_NM												");
	sql.append(" 	FROM FOOD_ST_DT_NM														");
	sql.append(" 	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,	");
	sql.append(" 	FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,		");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'		");
	sql.append(" 		).GETSTRINGVAL(),2) EX_NM											");
	sql.append(" 	FROM FOOD_ST_EXPL														");
	sql.append(" 	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,	");
	sql.append(" 	FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,		");
	sql.append(" 	FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,	");
	sql.append(" 	FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,	");
	sql.append(" 	FOOD_EP_24, FOOD_EP_25)) AS EX_NM										");

	sql.append(" FROM FOOD_UPDATE A LEFT JOIN 												");
	sql.append(" (SELECT * FROM FOOD_ITEM_PRE WHERE SHOW_FLAG = 'Y') B						");
	sql.append(" ON A.S_ITEM_NO = B.S_ITEM_NO LEFT JOIN FOOD_ST_ITEM C						");
	sql.append(" ON B.ITEM_NO = C.ITEM_NO													");
	sql.append(" WHERE 1=1              													");
    //품목구분 foodItem
    if(!"".equals(foodItem)) {
        sql.append(" AND C.CAT_NO = ?                                                       ");
        setList.add(foodItem);
        paging.setParams("foodItem", foodItem);
    }
    //식품명 foodName
    if (!"".equals(foodName)) {
        sql.append(" AND NM_FOOD LIKE '%'||?||'%'                                           ");
        setList.add(foodName);
        paging.setParams("foodName", foodName);
    }
    //검색어 분류=>식품명, 요청자명
	if(!"".equals(keywordCate) && !"".equals(keywordInp) ){
		if("nu_nm".equals(keywordCate)){
			sql.append(" AND NU_NM LIKE '%'||?||'%'											");
		}
		setList.add(keywordInp);
		paging.setParams("keywordCate", keywordCate);
		paging.setParams("keywordInp", keywordInp);
	}
    //반영완료 보기 checkbox
	if("on".equals(chkFinish)){
		sql.append(" AND A.STS_FLAG IN ('Y', 'N', 'R', 'A')									");
	}else {
		sql.append(" AND A.STS_FLAG IN ('N', 'R', 'Y') 	        							");
	}
	sql.append(")																			");

	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}

	try{
		totalCount	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);
	}catch(Exception e){
		totalCount	=	0;
	}

    //페이징 set
    paging.setTotalCount(totalCount);
    paging.setPageNo(Integer.parseInt(pageNo));
    paging.setPageSize(10);
    paging.makePaging();

    //업데이트 리스트 조회
    sql =   new StringBuffer();
    sql.append(" SELECT * FROM(																");
	sql.append("	SELECT ROWNUM AS RNUM, C.* FROM (										");

	sql.append("    SELECT  																");
	sql.append("    A.UPD_NO,																");
	sql.append("    A.SCH_NO,																");
	sql.append("    A.NU_NO,																");
	sql.append("    (SELECT NU_NM FROM FOOD_SCH_NU                                     		");
	sql.append("    WHERE NU_NO = A.NU_NO) AS NU_NM, 		                                ");
	sql.append("    A.N_ITEM_CODE,															");
	sql.append("    A.N_ITEM_NM,															");
	sql.append("    A.N_ITEM_DT_NM,															");
	sql.append("    A.N_ITEM_EXPL,															");
	sql.append("    A.N_ITEM_UNIT,															");
	sql.append("    C.FOOD_UNIT,															");
	sql.append("    (SELECT UNIT_NM FROM FOOD_ST_UNIT                                 		");
	sql.append("    WHERE UNIT_NO = C.FOOD_UNIT) AS UNIT_NM,	                            ");
	sql.append("    A.UPD_FLAG,																");
	sql.append("    A.UPD_REASON,															");
	sql.append("    A.STS_FLAG,																");
	sql.append("    A.RJC_REASON,															");
	sql.append("    A.REG_DATE,																");
	sql.append("    A.RJC_DATE,																");
	sql.append("    A.MOD_DATE,																");
	sql.append("    A.STS_DATE,																");
	sql.append("    A.SHOW_FLAG,															");
	sql.append("    C.ITEM_NO,                                                              ");
	sql.append("    C.FOOD_CODE,                                                            ");
	sql.append("    C.FOOD_CAT_INDEX,                                                       ");
	sql.append("    C.CAT_NO,																");
	sql.append("    (SELECT CAT_NM FROM FOOD_ST_CAT                                         ");
	sql.append("    WHERE CAT_NO = A.N_CAT_NO) AS CAT_NM,                                   ");
	sql.append("    D.ZONE_NO,                               							    ");
	sql.append("    (SELECT ZONE_NM FROM FOOD_ZONE                                     		");
	sql.append("    WHERE ZONE_NO = D.ZONE_NO) AS ZONE_NM,                                  ");
	sql.append("    D.TEAM_NO,                               							    ");
	sql.append("    (SELECT TEAM_NM FROM FOOD_TEAM                                     		");
	sql.append("    WHERE TEAM_NO = D.TEAM_NO) AS TEAM_NM,                                  ");
	sql.append("    D.SCH_NM,                               							    ");
	sql.append("    D.SCH_TEL,                               							    ");

	sql.append(" 	(SELECT SUBSTR(XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'	");
	sql.append(" 	).GETSTRINGVAL(),2) NM_FOOD												");
	sql.append(" 	FROM FOOD_ST_NM															");
	sql.append(" 	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	");
	sql.append(" 	AS NM_FOOD,																");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 	XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'			");
	sql.append(" 	).GETSTRINGVAL(),2) DT_NM												");
	sql.append(" 	FROM FOOD_ST_DT_NM														");
	sql.append(" 	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,	");
	sql.append(" 	FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,		");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'		");
	sql.append(" 		).GETSTRINGVAL(),2) EX_NM											");
	sql.append(" 	FROM FOOD_ST_EXPL														");
	sql.append(" 	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,	");
	sql.append(" 	FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,		");
	sql.append(" 	FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,	");
	sql.append(" 	FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,	");
	sql.append(" 	FOOD_EP_24, FOOD_EP_25)) AS EX_NM										");

	sql.append(" FROM (SELECT * FROM FOOD_UPDATE WHERE SHOW_FLAG = 'Y') A LEFT JOIN 		");
	sql.append(" (SELECT * FROM FOOD_ITEM_PRE WHERE SHOW_FLAG = 'Y') B						");
	sql.append(" ON A.S_ITEM_NO = B.S_ITEM_NO LEFT JOIN FOOD_ST_ITEM C						");
	sql.append(" ON B.ITEM_NO = C.ITEM_NO LEFT JOIN FOOD_SCH_TB D							");
	sql.append(" ON A.SCH_NO = D.SCH_NO														");
	sql.append(" WHERE 1=1																	");

    //품목구분 foodItem
    if(!"".equals(foodItem)) {
        sql.append(" AND C.CAT_NO = ?                                                       ");
    }
    //식품명 foodName
    if (!"".equals(foodName)) {
        sql.append(" AND NM_FOOD LIKE '%'||?||'%'                                           ");
    }
    //검색어 분류=>식품명, 요청자명
	if(!"".equals(keywordCate) && !"".equals(keywordInp) ){
		if("nu_nm".equals(keywordCate)){
			sql.append(" AND NU_NM LIKE '%'||?||'%'											");
		}
	}
    //반영완료 보기 checkbox
	if("on".equals(chkFinish)){
		sql.append(" AND A.STS_FLAG IN ('Y', 'N', 'R', 'A')									");
	}else {
		sql.append(" AND A.STS_FLAG IN ('N', 'R', 'Y') 	        							");
	}

    sql.append(" ORDER BY DECODE(A.STS_FLAG, 'N', 1, 'Y', 2), UPD_NO						");
	sql.append("	) C WHERE ROWNUM <= ").append(paging.getEndRowNo()).append("			");
	sql.append(" ) WHERE RNUM > ").append(paging.getStartRowNo()).append(" 					");

    try{
		updateList =    jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
	}catch(Exception e){
		updateList =    null;
	}

}catch(Exception e){
	out.println(e.toString());
}

%>
<script>

    function newWin(url, title, w, h){
        var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
        var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

        var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
        var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        var left = ((width / 2) - (w / 2)) + dualScreenLeft;
        var top = ((height / 2) - (h / 2)) + dualScreenTop;
        var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    }

    //check the search submit
    function chkSearch () {
        return false;
    }
    //반영완료 보기 check box
    $(function () {
		$("#chkFinish").click(function (){
            var chkVal  =   "";
            if ($("#chkFinish").is(":checked")) {chkVal = "on";} 
            else {chkVal = "";}
			$("#foodUpSrch").attr("action", updatePage + "&chkFinish="+chkVal);
       		$("#foodUpSrch").submit();
			return;
		});
	});

</script>

<section>
  <h3 class="blind">업데이트 요청 검색조건</h3>
  <form id="foodUpSrch" name="foodUpSrch" action="<%=updatePage%>" method="post">
    <fieldset class="search_wrap">
      <legend>업데이트 요청 검색조건</legend>
      <table class="bbs_list1 td-l mag0">
        <caption>조사가격 조회 검색조건 : 기간검색, 권역, 품목구분/식품명, 검색어 입력란</caption>
        <colgroup>
          <col style="width:15%" />
          <col style="width:33%"/>
          <col style="width:15%" />
          <col />
        </colgroup>
        <tbody>
          <tr>
          <%if(catList != null && catList.size() > 0){%>
            <th scope="row">품목구분/식품명</th>
            <td>
                <label for="foodItem" class="blind">품목구분</label>
                <select name="foodItem" id="foodItem" title="품목을 선택해주세요." class="wps_30">
                    <option value="">선택</option>
                    <%for(FoodVO vo: catList){%>
                    <option value="<%=vo.cat_no%>" <%if(vo.cat_no.equals(foodItem)){out.println("selected");}%>>
                    <%=vo.cat_nm %></option>
                    <%}%>
                </select>
              <label for="foodName" class="blind">식품명</label>
              <input type="text" id="foodName" name="foodName" value="<%=foodName %>" class="wps_60" />
            </td>
            <%}%>
            <th scope="row">검색어</th>
            <td>
                <label for="keywordCate" class="blind">검색어</label>
                <select name="keywordCate" id="keywordCate" title="검색어분류를 선택해주세요." class="wps_30">
                    <option value="">분류선택</option>
                    <option value="nu_nm" <%if("nu_nm".equals(keywordCate)){out.println("selected");}%>>변경요청자명</option>
                </select>
                <label for="keywordInp" class="blind">키워드 입력</label>
                <input type="text" id="keywordInp" name="keywordInp" value="<%=keywordInp %>" class="wps_60" />
            </td>
          </tr>
        </tbody>
      </table>
    </fieldset>
    <div class="btn_area c magT10">
        <button type="submit" class="btn medium darkMblue fb w_150">검 색</button>
    </div>
  </form>
</section>

<section>
  <h3 class="stit dis_inblock w_150">접수 요청 목록</h3>
  <p class="dis_inblock fb">
    <input type="checkbox" id="chkFinish" name="chkFinish" <%if("on".equals(chkFinish)){out.println("checked");}else{out.println("");}%> onclick="" /> 
    <label for="chkFinish">완료 보기</label>
  </p>
  <div class="btn_update">
    <a href="<%=updatePopup%>" onclick="window.open(this.href, '_blank', 'width=670, height=640, scrollbars=yes, resizable=yes'); return false" class="btn small green fb">업데이트 요청하기</a>
  </div>
  <table class="table_skin01 tr-bd2 td-pd1">
    <caption>업데이트 요청 접수 목록 : 품목구분, 기존/변경과 식품코드, 식품명, 상세식품명, 식품성명, 단위 등의 식품정보와 성명, 권역, 소속, 연락처 등의 변경요청자정보 및 요청구분, 사유, 요청일, 요청처리일, 등의 요청사항을 나열하며 요청에 대한 상태 표시입니다.</caption>
    <colgroup>
      <col style="width:6%" />
      <col style="width:4%" />
      <col style="width:6%" />
      <col style="width:6%" />
      <col style="width:7%" />
      <col />
      <col style="width:4%" />
      <col style="width:6%" />
      <col style="width:5%" />
      <col style="width:5%" />
      <col style="width:5%"/>
      <col style="width:4%"/>
      <col style="width:9%" />
      <col style="width:7%" />
      <col style="width:7%" />
      <col style="width:5%" />
    </colgroup>
    <thead>
      <tr>
        <th rowspan="2" scope="col">품목구분</th>
        <th rowspan="2" scope="col">기존/변경</th>
        <th colspan="5" scope="col">식품정보</th>
        <th colspan="4" scope="col">변경 요청자</th>
        <th colspan="5" scope="col">요청사항</th>
      </tr>
      <tr>
        <th scope="col">식품코드</th>
        <th scope="col">식품명</th>
        <th scope="col">상세식품명</th>
        <th scope="col">식품설명</th>
        <th scope="col">단위</th>
        <th scope="col">성명</th>
        <th scope="col">권역</th>
        <th scope="col">소속</th>
        <th scope="col">연락처</th>
        <th scope="col">요청구분</th>
        <th scope="col">사유</th>
        <th scope="col">요청일</th>
        <th scope="col">요청처리일</th>
        <th scope="col">상태</th>
      </tr>
    </thead>
    <tbody>
    <%if(updateList != null && updateList.size() > 0) {
        for(FoodVO vo : updateList) {%>
        <tr>
            <td rowspan="2"><%=vo.cat_nm %>-<%=vo.food_cat_index %></td>
            <td>기존</td>
            <td><%=parseNull(vo.food_code, "-") %></td>
            <td><%=parseNull(vo.nm_food, "-") %></td>
            <td><span class="wid_ndetail"><%=parseNull(vo.dt_nm, "-") %></span></td>
            <td><span class="wid_expl"><%=parseNull(vo.ex_nm, "-") %></span></td>
            <td><%=parseNull(vo.unit_nm, "-") %></td>
            <td rowspan="2"><%=vo.nu_nm %></td>
            <td rowspan="2"><%=vo.zone_nm %></td>
            <td rowspan="2"><span class="wid_school"><%=vo.sch_nm %></span></td>
            <td rowspan="2"><span class="wid_tel"><%=vo.sch_tel %></span></td>
            <td rowspan="2"><%=outUpdFlag(vo.upd_flag) %></td>
            <td rowspan="2"><%=vo.upd_reason %></td>
            <td rowspan="2"><%=vo.reg_date %></td>
            <td rowspan="2"><%if(vo.sts_date != null && vo.sts_date.length() > 0) {out.println(vo.sts_date);} else {out.println("-");}%></td>
            <td rowspan="2"><%=outUpdStsFlag(vo.sts_flag) %></td>
        </tr>
        <tr class="up_change">
            <td>변경</td>
            <td><%=parseNull(vo.n_item_code, "-") %></td>
            <td><%=parseNull(vo.n_item_nm, "-")  %></td>
            <td><span class="wid_ndetail"><%=parseNull(vo.n_item_dt_nm, "-")  %></span></td>
            <td><span class="wid_expl"><%=parseNull(vo.n_item_expl, "-") %></span></td>
            <td><%=parseNull(vo.n_item_unit, "-")  %></td>
        </tr>
        <%}/*END FOR*/%>
    <%}/*END IF*/else{%>
        <tr>
            <td colspan="16">업데이트 요청이 없습니다.</td>
        </tr>
    <%}%>
    </tbody>
  </table>
</section>

<!-- paging -->
<div class="pageing">
	<%if(paging.getTotalCount() > 0) {
		out.print(paging.getHtml());	
	}%>
</div>