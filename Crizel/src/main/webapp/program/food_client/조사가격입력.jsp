<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
/**
*	CREATE	:	조사가격입력 html 코딩 / 20180328 LJH
*	MODIFY	:	html 코딩 완료 / 20180403 LJH
*/

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request); 

int viewYN			=	0;		//1일경우 페이지 정상 작동
String moveUrl		=	"/index.gne?contentsSid=661";		//액션페이지
String moveUrlMain	=	"";		//메인페이지

//2차 로그인 여부
if("Y".equals(session.getAttribute("foodLoginChk"))){
	viewYN	=	1;
}else{
	out.print("<script> 						\n");
	out.print("alert('2차 로그인 후 이용하실 수 있습니다.');	\n");
	out.print("window.close(); 					\n");
	out.print("</script> 						\n");
}

if(viewYN == 1){
	StringBuffer sql 		= 	null;
	String sqlWhere			=	"";
	int resultCnt 			=	0;
	int cnt					=	0;
	int allCnt				= 	0;
	int completeCnt			=	0;
	
	int pageNo				=	Integer.parseInt(parseNull(request.getParameter("pageNo"), "1"));
	int actType				=	Integer.parseInt(parseNull(request.getParameter("actType"), "0"));	//0 : 미완료, 1 : 완료
	Paging pagingVO			=	new Paging();
	List<FoodVO> userList	=	null;
	List<FoodVO> rschList	=	null;
	
	String schId			=	sManager.getId();
	String zoneTxt			=	"";		//권역 텍스트
	String rschTxt			=	"";		//조사명 텍스트
	String endDateTxt		=	"";		//조사기간 텍스트
	String titleTxt			=	"";		//조사, 미조사 품목 텍스트
	
	if(actType == 0)	{
		sqlWhere	+=	" AND (VAL.STS_FLAG = 'N' OR VAL.STS_FLAG = 'RR' OR VAL.STS_FLAG = 'RT')	\n";
		titleTxt	=	"미조사 품목";
	}
	else if(actType == 1){
		sqlWhere	+=	" AND VAL.STS_FLAG = 'Y'	\n ";
		titleTxt	=	"조사완료 품목";
	}
	
	try{
		//userList
		sql		=	new StringBuffer();
		sql.append(" SELECT  					\n");
		sql.append(" SCH.SCH_NO, 				\n");
		sql.append(" SCH.ZONE_NO, 				\n");
		sql.append(" SCH.TEAM_NO, 				\n");
		sql.append(" SCH.JO_NO,  				\n");
		sql.append(" SCH.AREA_NO,  				\n");
		sql.append(" NU.NU_NO,  				\n");
		sql.append(" NU.NU_NM  					\n");
		sql.append(" FROM FOOD_SCH_TB SCH		\n");
		sql.append(" LEFT JOIN FOOD_SCH_NU NU	\n");
		sql.append(" ON SCH.SCH_NO = NU.SCH_NO	\n");
		sql.append(" WHERE SCH.SCH_ID = ?		\n");
		sql.append(" AND NU.SHOW_FLAG = 'Y'		\n");
		
		userList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{schId});
		
		//조사개시 존재여부
		sql		=	new StringBuffer();
		sql.append(" SELECT 				\n");
		sql.append(" COUNT(RSCH_NO) 		\n");
		sql.append(" FROM FOOD_RSCH_TB 		\n");
		sql.append(" WHERE STS_FLAG = 'N' 	\n");
		
		cnt		=	jdbcTemplate.queryForInt(sql.toString());
		
		if(cnt == 1){
			//전체 검색카운트
			sql		=	new StringBuffer();
			sql.append(" SELECT COUNT(PRE.ITEM_NO) AS ALLCNT 							\n");
			sql.append(" FROM FOOD_ITEM_PRE PRE		  									\n");
			sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
			sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
			sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
			sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
			sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");
			sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
			sql.append(" AND SCH.SCH_NO = ? 											\n");
			sql.append(" AND (VAL.STS_FLAG = 'N' OR VAL.STS_FLAG = 'RR' OR VAL.STS_FLAG = 'RT') \n");
			
			allCnt		=	jdbcTemplate.queryForInt(sql.toString(), new Object[]{
					userList.get(0).sch_no
			});
			
			//완료된 카운트
			sql		=	new StringBuffer();
			sql.append(" SELECT COUNT(PRE.ITEM_NO) AS ALLCNT 							\n");
			sql.append(" FROM FOOD_ITEM_PRE PRE		  									\n");
			sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
			sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
			sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
			sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
			sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");
			sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
			sql.append(" AND SCH.SCH_NO = ? 											\n");
			sql.append(" AND VAL.STS_FLAG = 'Y'				 							\n");
			
			completeCnt		=	jdbcTemplate.queryForInt(sql.toString(), new Object[]{
					userList.get(0).sch_no
			});
			
			if(actType == 0)		pagingVO.setTotalCount(allCnt);
			else if(actType == 1)	pagingVO.setTotalCount(completeCnt);
				
			pagingVO.setPageNo(pageNo);
			pagingVO.setPageSize(5);
			pagingVO.makePaging();
			
			sql		=	new StringBuffer();
			sql.append(" SELECT * FROM (												\n");
			sql.append(" SELECT ROWNUM AS RNUM, A.* FROM (								\n");
			sql.append(" SELECT 														\n");
			sql.append(" PRE.ITEM_NO,													\n");
			sql.append(" (SELECT CAT_NM	FROM FOOD_ST_CAT								\n");
			sql.append(" WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM,							\n");
			
			sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)			\n");
			sql.append(" ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)		\n");
			sql.append(" NM_FOOD														\n");
			sql.append(" FROM FOOD_ST_NM												\n");
			sql.append(" WHERE NM_NO IN (												\n");
			sql.append(" FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))		\n");
			sql.append(" AS NM_FOOD,													\n");
			
			sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)				\n");
			sql.append(" ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
			sql.append(" DT_NM															\n");
			sql.append(" FROM FOOD_ST_DT_NM												\n");
			sql.append(" WHERE DT_NO IN(												\n");
			sql.append(" FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,			\n");
			sql.append(" FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))		\n");
			sql.append(" AS DT_NM, 														\n");
			
			sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)				\n");
			sql.append(" ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
			sql.append(" EX_NM															\n");
			sql.append(" FROM FOOD_ST_EXPL												\n");
			sql.append(" WHERE EX_NO IN(												\n");
			sql.append(" FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,			\n");
			sql.append(" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 		\n");
			sql.append(" FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n");
			sql.append(" FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n");
			sql.append(" FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))	\n");
			sql.append(" AS EX_NM, 														\n");
			
			sql.append(" (SELECT UNIT_NM FROM FOOD_ST_UNIT 								\n");
			sql.append(" WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM, 					\n");
			sql.append(" PRE.REG_DATE,													\n");
			sql.append(" PRE.MOD_DATE,													\n");
			sql.append(" PRE.SHOW_FLAG,													\n");
			sql.append(" (SELECT REG_IP FROM FOOD_UP_FILE							 	\n");
			sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_IP,							\n");
			sql.append(" (SELECT REG_ID FROM FOOD_UP_FILE								\n");
			sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_ID,							\n");
			sql.append(" PRE.ITEM_GRP_NO,												\n");
			sql.append(" PRE.ITEM_GRP_ORDER,											\n");
			sql.append(" PRE.ITEM_COMP_NO, 												\n");
			sql.append(" PRE.ITEM_COMP_VAL,												\n");
			sql.append(" PRE.LOW_RATIO, 												\n");
			sql.append(" PRE.AVR_RATIO, 												\n");
			sql.append(" PRE.LB_RATIO,	 												\n");
			sql.append(" TB.RSCH_NM,	 												\n");
			sql.append(" TO_CHAR(TB.END_DATE,'YY/MM/DD') AS END_DATE,					\n");
			sql.append(" SCH.ZONE_NO,	 												\n");
			sql.append(" ZONE.ZONE_NM,	 												\n");
			sql.append(" ITEM.FOOD_CAT_INDEX,											\n");
			sql.append(" ITEM.FOOD_CODE,												\n");
			sql.append(" VAL.STS_FLAG,													\n");
			sql.append(" VAL.RSCH_VAL_NO,												\n");
			sql.append(" NU.NU_NM														\n");
			sql.append(" FROM FOOD_ITEM_PRE PRE 										\n");
			
			sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
			sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
			sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
			sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
			sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");
			sql.append(" LEFT JOIN FOOD_ZONE ZONE ON SCH.ZONE_NO = ZONE.ZONE_NO			\n");
			
			sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
			sql.append(" AND SCH.SCH_NO = ? 											\n");
			sql.append(sqlWhere);
			sql.append(" ORDER BY PRE.ITEM_NO											\n");
			sql.append(" )A WHERE ROWNUM <= ?											\n");
			sql.append(" ) WHERE RNUM > ?												\n");
			
			rschList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{
					userList.get(0).sch_no, pagingVO.getEndRowNo(), pagingVO.getStartRowNo()
			});
			
			if(rschList != null && rschList.size() > 0){
				zoneTxt		=	rschList.get(0).zone_nm;
				rschTxt		=	rschList.get(0).rsch_nm;
				endDateTxt	=	rschList.get(0).end_date;
			}
			
		}else if(cnt == 0){
			//열려있는 조사가 없음.
		}
		
	}catch(Exception e){
		alertBack(out, e.toString());
	}finally{
		
	}
%>

<script>
//제출
function submissionRsch(number){
	
	var rschValArr	=	new Array();	//조사가
	var rschLocArr	=	new Array();	//조사처
	var rschComArr	=	new Array();	//조사업체
	
	for(var i=0; i<5; i++){
		rschValArr[i]	=	$("#rschVal" + (i+1) + "_" + number).val();
		rschValArr[i]	=	$("#rschLoc" + (i+1) + "_" + number).val();
		rschValArr[i]	=	$("#rschCom" + (i+1) + "_" + number).val();
	}
		
	inputCheck(number);
	<%-- $.ajax({
		type : "POST",
		url : "<%=moveUrl%>",
		data : { 
			"number" : number, 		"rschVal" : rschValArr, 
			"rschLoc" : rschLocArr, "rschCom" : rschComArr 
		},
		async: false,
		success : function(data){
			alert(data.trim());
		},
		error : function(){
	       	alert("오류가 발생하였습니다.");
		}
	}); --%>
}

//입력 유효성 검사
function inputCheck(number){
	var alertMsg	=	"";		//출력할 메시지
	var checkCnt	=	0;		//입력한 값의 개수
	var checkSetCnt	=	0;		//(조사가, 조사처, 견적업체) 1set가 온전히 입력된 수
	
	var rschVal		=	"";		//조사가
	var rschLoc		=	"";		//조사처
	var rschCom		=	"";		//견적업체
	
	for(var i=0; i<5; i++){		
		rschVal		=	$("#rschVal" + (i+1) + "_" + number).val();	
		rschLoc		=	$("#rschLoc" + (i+1) + "_" + number).val();	
		rschCom		=	$("#rschCom" + (i+1) + "_" + number).val();	
		
		//조사가, 조사처, 견적업체 1set가 온전히 입력되었을 때 && 조사가 숫자체크
		if(rschVal != "" && rschLoc != "" && rschCom != ""){
			if(numberChk(rschVal) == false)		return;
			checkSetCnt	+=	1;
		}
		
		//조사가, 조사처, 견적업체 중 하나라도 입력되었을때 나머지 두값도 무조건 입력하게 하는 기능 && 조사가 숫자체크
		else if(rschVal != "" || rschLoc != "" || rschCom != ""){
			
			if(rschVal == ""){
				alertMsg	+=	"조사가" + (i+1) + ", ";
				checkCnt	+=	1;
			}
			if(rschLoc == ""){
				if(numberChk(rschVal) == false)		return;
				alertMsg	+=	"조사처" + (i+1) + ", ";
				checkCnt	+=	1;
			}
			if(rschCom == ""){
				if(numberChk(rschVal) == false)		return;
				alertMsg	+=	"견적업체" + (i+1) + ", ";
				checkCnt	+=	1;
			}
		}		
	}
	
	if(checkCnt > 0){
		alertMsg	=	alertMsg.substr(0, alertMsg.length-2);
		alert(alertMsg + "이(가) 입력되지 않았습니다.");
		return;
	}
	
	if(checkSetCnt < 2){
		alert("조사 데이터는 2개 이상 입력되어야 합니다.");
		return;
	}
}

//숫자체크
function numberChk(checkData){
	if(isNaN(checkData) == true){
		alert("조사가에는 숫자만 입력할 수 있습니다.");
		return false;
	}else{
		return true;
	}
}
</script>

<div class="rsrch_info">
  <ul class="clearfix mag0">
    <li><strong>권역</strong>: <%=zoneTxt%></li>
    <li><strong>조사명</strong>: <%=rschTxt%></li>
    <li class="end_date"><strong>조사마감날짜</strong>: <%=endDateTxt%></li>
  </ul>
</div>
<!-- 탭메뉴 -->
<div class="tab_wrap clearfix">
  <ul class="tabs">
    <li<%if(actType==0){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=0">미조사 품목</a></li>
    <li<%if(actType==1){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=1">조사완료 품목</a></li>
  </ul>
</div>
<!-- //탭메뉴 -->

<div class="tab_container">
  <section class="tab_content" style="display:block;">
    <h3 class="stit"><%=titleTxt%> <span class="dec fsize_80">(완료 <span class="fb blue"><%=completeCnt%></span>건 / 전체 <%=allCnt%>건)</span></h3>
    <%if(actType == 0){%>
      <table class="tbl_rsrch tr-even">
        <caption>미조사 품목 입력 : 구분, 식품콛, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 조사자, 조사가 정보, 검증/제출</caption>
        <colgroup>
          <col style="width:50px"/>
          <col style="width:6%" />
          <col style="width:6%"/>
          <col style="width:8%"/>
          <col style="width:14%" />
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:8%"/>
          <col />
          <col style="width:64px;" />
        </colgroup>
        <thead>
          <tr>
            <th scope="row">품목<br />구분</th>
            <th scope="row">식품코드</th>
            <th scope="row">식품명</th>
            <th scope="row">상세식품명</th>
            <th scope="row">식품설명</th>
            <th scope="row">단위</th>
            <th scope="row">비계절</th>
            <th scope="row">비유통</th>
            <th scope="row">조사자</th>
            <th scope="row">조사가 정보</th>
            <th scope="row">검증/제출</th>
          </tr>
        </thead>
        <tbody>
        <%
        if(rschList != null && rschList.size() > 0){
        	for(int i=0; i<rschList.size(); i++){	
        	FoodVO vo			=	rschList.get(i);
        	String classTxt		=	"";
        	
       		//관리자반려 또는 팀장반려일 경우 tr태그에 class를 추가한다.
       		if("RR".equals(vo.sts_flag) || "RT".equals(vo.sts_flag)){
       			classTxt	=	" class=\"rch_return\"";
       		}
        	%>
          <tr<%=classTxt%>>
            <td><span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
            <td><%=vo.food_code%></td>
            <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
            <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
            <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
            <td><%=vo.unit_nm%></td>
            <td><label for="offSeason_<%=vo.rsch_val_no%>" class="blind">비계절 체크</label><input type="checkbox" id="offSeason_<%=vo.rsch_val_no%>" name="offSeason" class="chbig" title="비계절 체크" /></td>
            <td><label for="offDist_<%=vo.rsch_val_no%>" class="blind">비유통 체크</label><input type="checkbox" id="offDist_<%=vo.rsch_val_no%>" name="offDist" class="chbig" title="비유통 체크" /></td>
            <td>
              <label for="rschSel_<%=vo.rsch_val_no%>" class="blind">조사자 선택</label>
              <select id="rschSel_<%=vo.rsch_val_no%>" name="rschSel">
                <option value="">선택</option>
                <%
                	for(int j=0; j<userList.size(); j++){
                		out.print(printOption(userList.get(j).nu_no, userList.get(j).nu_nm, ""));
                	}
                %>
              </select>
            </td>
            <td class="padR5 padL5">
              <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
                <caption>조사가1~5에 대한 조사처 및 견적업체 정보 입력</caption>
                <colgroup>
                  <col style="width:15%" />
                  <col style="width:17%" span="5" />
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col">구분</th>
                    <th scope="col">조사가1</th>
                    <th scope="col">조사가2</th>
                    <th scope="col">조사가3</th>
                    <th scope="col">조사가4</th>
                    <th scope="col">조사가5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th scope="row" class="bg_green">조사가</th>
                    <td><label><input type="text" name="rschVal1" id="rschVal1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val1%>" title="조사가1 가격" /></label></td>
                    <td><label><input type="text" name="rschVal2" id="rschVal2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val2%>" title="조사가2 가격" /></label></td>
                    <td><label><input type="text" name="rschVal3" id="rschVal3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val3%>" title="조사가3 가격" /></label></td>
                    <td><label><input type="text" name="rschVal4" id="rschVal4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val4%>" title="조사가4 가격" /></label></td>
                    <td><label><input type="text" name="rschVal5" id="rschVal5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val5%>" title="조사가5 가격" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">조사처</th>
                    <td><label><input type="text" name="rschLoc1" id="rschLoc1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc1%>" title="조사가1 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc2" id="rschLoc2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc2%>" title="조사가2 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc3" id="rschLoc3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc3%>" title="조사가3 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc4" id="rschLoc4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc4%>" title="조사가4 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc5" id="rschLoc5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc5%>" title="조사가5 조사처" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">견적업체</th>
                    <td><label><input type="text" name="rschCom1" id="rschCom1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com1%>" title="조사가1 견적업체" /></label></td>
                    <td><label><input type="text" name="rschCom2" id="rschCom2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com2%>" title="조사가2 견적업체" /></label></td>
                    <td><label><input type="text" name="rschCom3" id="rschCom3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com3%>" title="조사가3 견적업체" /></label></td>
                    <td><label><input type="text" name="rschCom4" id="rschCom4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com4%>" title="조사가4 견적업체" /></label></td>
                    <td><label><input type="text" name="rschCom5" id="rschCom5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com5%>" title="조사가5 견적업체" /></label></td>
                  </tr>
      		
                </tbody>
              </table>
            </td>
            <td class="btn_mingroup">
            <!-- 반려 사유 링크 : 팀장에 의해 반려되었을 경우 -->
            <%if("RR".equals(vo.sts_flag) || "RT".equals(vo.sts_flag)){%>
              <a href="#" id="resViewBtn" title="반려된 사유보기"><span class="red u fb dp_block magB5">*반려됨<br />(사유보기)</span></a>
            <%}%>
            <!--//반려 사유 끝 -->
              <button type="button" class="btn darkMblue" onclick="verificationRsch('<%=vo.rsch_val_no%>');">검증</button>
              <button type="button" class="btn green" onclick="submissionRsch('<%=vo.rsch_val_no%>');">제출</button>
              <button type="button" class="btn white" onclick="careerRsch('<%=vo.rsch_val_no%>')">이력</button>
            </td>
          </tr>
          <%}
          }else{
            	out.print("<tr>");
              	out.print("<td colspan=\"11\"> 조사 대상이 없습니다. </td>");
              	out.print("</tr>");
          }%>
        </tbody>
      </table>
   <!-- 조사완료 품목 : 조사자 -->
   <%}else if(actType == 1){%>
     <table class="tbl_rsrch tr-even">
         <caption>조사완료 품목 : 구분, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 조사자, 조사가 정보, 검증/제출</caption>
         <colgroup>
           <col style="width:50px"/>
           <col style="width:6%" />
           <col style="width:6%"/>
           <col style="width:8%"/>
           <col style="width:14%" />
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:8%"/>
           <col />
           <col style="width:64px;" />
         </colgroup>
         <thead>
           <tr>
             <th scope="row">품목<br />구분</th>
             <th scope="row">식품코드</th>
             <th scope="row">식품명</th>
             <th scope="row">상세식품명</th>
             <th scope="row">식품설명</th>
             <th scope="row">단위</th>
             <th scope="row">비계절</th>
             <th scope="row">비유통</th>
             <th scope="row">조사자</th>
             <th scope="row">조사가 정보</th>
             <th scope="row">상태</th>
           </tr>
         </thead>
         <tbody>
         <%if(rschList != null && rschList.size() > 0){
         	for(int i=0; i<rschList.size(); i++){
         		FoodVO vo	=	rschList.get(i);
         		%>
         		<tr>
	             <td><span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
	             <td><%=vo.food_code%></td>
	             <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
	             <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
	             <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
	             <td><%=vo.unit_nm%></td>
	             <td><%=vo.non_season%></td>
	             <td><%=vo.non_distri%></td>
	             <td><%=vo.nu_nm%></td>
	             <td class="padR5 padL5">
	               <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
	                 <caption>조사가1~5에 대한 조사처 및 견적업체 정보 입력</caption>
	                 <colgroup>
	                   <col style="width:15%">
	                   <col style="width:17%" span="5">
	                 </colgroup>
	                 <thead>
	                   <tr>
	                     <th scope="col">구분</th>
	                     <th scope="col">조사가1</th>
	                     <th scope="col">조사가2</th>
	                     <th scope="col">조사가3</th>
	                     <th scope="col">조사가4</th>
	                     <th scope="col">조사가5</th>
	                   </tr>
	                 </thead>
	                 <tbody>
	                   <tr>
	                     <th scope="row" class="bg_green">조사가</th>
	                     <td><%=vo.rsch_val1%></td>
	                     <td><%=vo.rsch_val2%></td>
	                     <td><%=vo.rsch_val3%></td>
	                     <td><%=vo.rsch_val4%></td>
	                     <td><%=vo.rsch_val5%></td>
	                   </tr>
	                   <tr>
	                     <th scope="row" class="bg_green">조사처</th>
	                     <td><%=vo.rsch_loc1%></td>
	                     <td><%=vo.rsch_loc2%></td>
	                     <td><%=vo.rsch_loc3%></td>
	                     <td><%=vo.rsch_loc4%></td>
	                     <td><%=vo.rsch_loc5%></td>
	                   </tr>
	                   <tr>
	                     <th scope="row" class="bg_green">견적업체</th>
	                     <td><%=vo.rsch_com1%></td>
	                     <td><%=vo.rsch_com2%></td>
	                     <td><%=vo.rsch_com3%></td>
	                     <td><%=vo.rsch_com4%></td>
	                     <td><%=vo.rsch_com5%></td>
	                   </tr>
	                 </tbody>
	               </table>
	             </td>
	             <td class="btn_mingroup"><span class="wid_state">제출완료</span></td>
	           </tr>
         		<%
         	}
         }else{
        	 out.print("<tr>");
        	 out.print("<td colspan=\"11\">완료 내역이 없습니다.</td>");
        	 out.print("</tr>");
         }
         %>
         </tbody>
       </table>
       <%}%>
   	<!-- paging -->
   	<%if(pagingVO.getTotalCount() > 0){%>
		<div class="pageing">
			<%=pagingVO.getHtml()%>
		</div>
	<%}%>
	<!-- //paging -->
   </section>
</div>



<%/*************************************** STR Modal part ****************************************/%>
<!-- 사유 입력 모달 -->
  <div id="reasonInput" class="modal" style="display:block">
    <div class="topbar">
      <h3>사유 입력</h3>
    </div>
    <div class="inner">
      <form name="" action="" onsubmit="" method="post">
        <!-- 빈번한 입력사유 자동 노출 영역 -->
        <p class="red fb c padT5 padB5">감자(알감자,친환경)보다 가격이 높습니다.</p>
        <!-- //빈번 사유 끝 -->
        <div class="sel_input magT10">
          <select name="" id="">
            <option value="">직접입력</option>
          </select>
          <textarea placeholder="구체적인 사유를 입력하세요." class="magT5 wps_100 h050"></textarea>
        </div>
        <div class="btn_area c mg_b5">
          <input type="submit" class="btn small edge darkMblue" value="확인">
        </div>
      </form>
      <a href="javascript:modal close();" class="btn_cancel" id="inputModalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
    </div>
  </div>
<!-- //사유 입력 모달 끝 -->
<!-- 사유 보기 모달 -->
  <div id="reasonView" class="modal" style="display:block;">
    <div class="topbar">
      <h3>사유 보기</h3>
    </div>
    <div class="inner">
      <!-- 빈번한 사유 자동 노출 영역 -->
      <p class="red fb c padT5 padB5">감자(알감자,친환경)보다 가격이 높습니다.</p>
      <!-- //빈번 사유 끝 -->
      <textarea class="magT5 wps_100 h050" readonly>직접 입력한 사유는 여기에 이렇게 나오는게 맞나요? 나도 잘 모르겠음.</textarea>
    <a href="javascript:modal close();" class="btn_cancel" id="viewModalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
    </div>
  </div>
<!-- //사유 보기 모달 끝 -->
<%/*************************************** END Modal part ****************************************/%>
<%}%>