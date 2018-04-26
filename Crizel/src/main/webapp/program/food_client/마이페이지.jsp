<%
/**
* PURPOSE : 마이페이지
* CREATE  : 201803??  JMG
* MODIFY  : ...
**/
%>
<%@ page import="egovframework.rfc3.board.vo.BoardDataVO" %>
<%@ page import="egovframework.rfc3.board.web.BoardManager" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request); 

int viewYN			=	0;		//1일경우 페이지 정상 작동
String moveUrl		=	"/index.gne?contentsSid=661";					//액션페이지
String moveItemUrl	=	"/index.gne?menuCd=DOM_000000127004000000";		//조사할 품목 더보기
String moveLateUrl	=	"/index.gne?menuCd=DOM_000000127003000000";		//최근조사가격 더보기
String noticeUrl	=	"/board/list.gne?boardId=BBS_0000113&menuCd=DOM_000000127002000000";			//공지사항
String freeUrl		=	"/board/list.gne?boardId=BBS_0000114&menuCd=DOM_000000127009000000";			//자유게시판

//2차 로그인 여부
if("Y".equals(session.getAttribute("foodLoginChk"))){
	viewYN	=	1;
}else{
	out.print("<script> 						\n");
	out.print("alert('2차 로그인 후 이용하실 수 있습니다.');	\n");
	out.print("history.back();			\n");
	out.print("</script> 						\n");
  return;
}

BoardManager boardManager		=	new BoardManager(request);
List<BoardDataVO> freeList		=	boardManager.getBoardDataList("BBS_0000114", 5);	//자유게시판
List<BoardDataVO> noticeList	=	boardManager.getBoardDataList("BBS_0000113", 5);	//공지사항
List<FoodVO> rschList			=	null;	//조사할 항목
List<FoodVO> latestList			=	null;	//최근 조사 항목
FoodVO foodVO					=	new FoodVO();
FoodVO userVO					=	null;

foodVO.sch_id		=	sManager.getId();

StringBuffer sql	=	null;
String sqlWhere		=	"";

try{
	
	//user
	sql		=	new StringBuffer();
	sql.append(" SELECT 					\n");
	sql.append(" SCH_NO, 					\n");
	sql.append(" SCH_TYPE, 					\n");
	sql.append(" SCH_GRADE, 				\n");
	sql.append(" SCH_NM 					\n");
	sql.append(" FROM FOOD_SCH_TB 			\n");
	sql.append(" WHERE SCH_ID = ? 			\n");
	sql.append(" AND SHOW_FLAG = 'Y'		\n");
	
	try{
		userVO		=	jdbcTemplate.queryForObject(sql.toString(), new FoodList(), new Object[]{foodVO.sch_id});
	}catch(Exception e){
		userVO		=	new FoodVO();
	}
	
	//조사할 품목 
	sql		=	new StringBuffer();
	sql.append(" SELECT * FROM ( 														\n");
	sql.append(" 	SELECT ROWNUM AS RNUM, A.* FROM (									\n");
	sql.append(" 		SELECT 															\n");
	sql.append(" 			VAL.RSCH_VAL_NO, 											\n");
	sql.append(" 			ITEM.FOOD_CODE, 											\n");
	sql.append(" 			PRE.ITEM_NM, 												\n");
	sql.append(" 			(SELECT CAT_NM FROM FOOD_ST_CAT								\n");
	sql.append(" 			WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM,						\n");
	sql.append(" 			TO_CHAR(TB.END_DATE, 'YYYY.MM.DD') AS END_DATE,				\n");
	
	//상세식품명
	sql.append(" 			(SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)			\n");
	sql.append(" 			ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)		\n");
	sql.append(" 			DT_NM														\n");
	sql.append(" 			FROM FOOD_ST_DT_NM											\n");
	sql.append(" 			WHERE DT_NO IN(												\n");
	sql.append(" 			FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,		\n");
	sql.append(" 			FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))	\n");
	sql.append(" 			AS DT_NM 													\n");
	
	sql.append(" 		FROM FOOD_RSCH_VAL VAL											\n");
	sql.append(" 		LEFT JOIN FOOD_ITEM_PRE PRE ON									\n");
	sql.append(" 		VAL.ITEM_NO = PRE.ITEM_NO										\n");
	sql.append(" 		LEFT JOIN FOOD_ST_ITEM	ITEM ON									\n");
	sql.append(" 		VAL.ITEM_NO = ITEM.ITEM_NO 										\n");
	sql.append(" 		LEFT JOIN FOOD_RSCH_TB TB ON									\n");
	sql.append(" 		VAL.RSCH_NO = TB.RSCH_NO										\n");
	sql.append(" 		WHERE VAL.SCH_NO = ?											\n");
	sql.append(" 		AND VAL.STS_FLAG != 'Y'											\n");
	sql.append(" 		ORDER BY PRE.ITEM_NO											\n");
	sql.append(" 	)A WHERE ROWNUM <= 5												\n");
	sql.append(" ) WHERE RNUM > 0														\n");
	
	rschList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{userVO.sch_no});
	
	
	//최근 조사 가격
	sql		=	new StringBuffer();
	sql.append(" SELECT * FROM ( 														\n");
	sql.append(" 	SELECT ROWNUM AS RNUM, A.* FROM (									\n");
	sql.append(" 		SELECT 															\n");
	sql.append(" 			VAL.RSCH_VAL_NO, 											\n");
	sql.append(" 			ITEM.FOOD_CODE,												\n");
	sql.append(" 			PRE.ITEM_NM, 												\n");
	sql.append(" 			(SELECT CAT_NM FROM FOOD_ST_CAT								\n");
	sql.append(" 			WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM,						\n");
	sql.append(" 			(SELECT ZONE_NM FROM FOOD_ZONE								\n");
	sql.append(" 			WHERE ZONE_NO = VAL.ZONE_NO) AS ZONE_NM,					\n");
	sql.append(" 			(SELECT NU_NM FROM FOOD_SCH_NU								\n");
	sql.append(" 			WHERE NU_NO = VAL.NU_NO) AS NU_NM,							\n");
	sql.append(" 			TO_CHAR(VAL.REG_DATE, 'YYYY.MM.DD') AS REG_DATE,			\n");
	
	//상세식품명
	sql.append(" 			(SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)			\n");
	sql.append(" 			ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)		\n");
	sql.append(" 			DT_NM														\n");
	sql.append(" 			FROM FOOD_ST_DT_NM											\n");
	sql.append(" 			WHERE DT_NO IN(												\n");
	sql.append(" 			FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,		\n");
	sql.append(" 			FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))	\n");
	sql.append(" 			AS DT_NM 													\n");
	
	sql.append(" 		FROM FOOD_RSCH_VAL VAL											\n");
	sql.append(" 		LEFT JOIN FOOD_ITEM_PRE PRE ON									\n");
	sql.append(" 		VAL.ITEM_NO = PRE.ITEM_NO										\n");
	sql.append(" 		LEFT JOIN FOOD_ST_ITEM	ITEM ON									\n");
	sql.append(" 		VAL.ITEM_NO = ITEM.ITEM_NO 										\n");
	sql.append(" 		LEFT JOIN FOOD_RSCH_TB TB ON									\n");
	sql.append(" 		VAL.RSCH_NO = TB.RSCH_NO										\n");
	sql.append(" 		WHERE TB.SHOW_FLAG = 'Y'										\n");
	sql.append(" 		AND VAL.STS_FLAG = 'Y'											\n");
	sql.append(" 		ORDER BY RSCH_DATE DESC, RSCH_VAL_NO							\n");
	sql.append(" 	)A WHERE ROWNUM <= 5												\n");
	sql.append(" ) WHERE RNUM > 0														\n");
	
	latestList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{});
	
}catch(Exception e){
	alertBack(out, e.toString());
}finally{
	
}
%>
<div class="clearfix mypage">
  <section class="item col-6">
    <h3 class="ntit">조사할 품목</h3>
    <table class="table_skin01">
      <caption>미조사 품목 : 조사번호, 식품코드, 식품분류, 상세식품명, 조사마감일 표시</caption>
      <colgroup>
        <col style="width:15%" />
        <col span="4" />
        <col style="width:20%" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">조사번호</th>
          <th scope="col">식품코드</th>
          <th scope="col">분류</th>
          <th scope="col">식품명</th>
          <th scope="col">상세식품명</th>
          <th scope="col">조사마감일</th>
        </tr>
      </thead>
      <tbody>
		<%
			if(rschList != null && rschList.size() > 0){
				for(int i=0; i<rschList.size(); i++){
					out.print("<tr>");
					out.print("<td>" + rschList.get(i).rsch_val_no + "</td>");
					out.print("<td>" + rschList.get(i).food_code + "</td>");
					out.print("<td>" + rschList.get(i).cat_nm + "</td>");
					out.print("<td>" + rschList.get(i).item_nm + "</td>");
					out.print("<td>" + rschList.get(i).dt_nm + "</td>");
					out.print("<td>" + rschList.get(i).end_date + "</td>");
					out.print("</tr>");
				}
			}else{
				out.print("<tr>");
				out.print("<td colspan=\"6\">" + "조사할 품목이 없습니다." + "</td>");
				out.print("</tr>");
			}
		%>       
      </tbody>
    </table>
    <a href="<%=moveItemUrl%>" class="btn small edge white">더보기</a>
  </section>
  
  
  <section class="item col-6">
    <h3 class="ntit">최근 조사 가격</h3>
    <table class="table_skin01">
      <caption>최근 조사 가격 목록 : 조사번호, 식품코드, 식품분류, 상세식품명, 등록일, 권역, 조사자명 표시</caption>
      <colgroup>
        <col style="width:10%" />
        <col span="3" />
        <col style="width:12%" />
        <col style="width:15%" />
        <col style="width:10%" />
        <col style="width:10%" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">조사번호</th>
          <th scope="col">식품코드</th>
          <th scope="col">분류</th>
          <th scope="col">식품명</th>
          <th scope="col">상세식품명</th>
          <th scope="col">등록일</th>
          <th scope="col">권역</th>
          <th scope="col">조사자</th>
        </tr>
      </thead>
      <tbody>
        <%
        	if(latestList != null && latestList.size() > 0){
        		for(int i=0; i<latestList.size(); i++){
        			out.print("<tr>");
        			out.print("<td>" + latestList.get(i).rsch_val_no + "</td>");
        			out.print("<td>" + latestList.get(i).food_code + "</td>");
        			out.print("<td>" + latestList.get(i).cat_nm + "</td>");
        			out.print("<td>" + latestList.get(i).item_nm + "</td>");
        			out.print("<td>" + latestList.get(i).dt_nm + "</td>");
        			out.print("<td>" + latestList.get(i).reg_date + "</td>");
        			out.print("<td>" + latestList.get(i).zone_nm + "</td>");
        			out.print("<td>" + latestList.get(i).nu_nm + "</td>");
        			out.print("</tr>");
        		}
        	}else{
        		out.print("<tr>");
        		out.print("<td colspan=\"8\">" + "최근 조사내역이 없습니다." + "</td>");
        		out.print("</tr>");
        	}
        %>
      </tbody>
    </table>
    <a href="<%=moveLateUrl%>" class="btn small edge white">더보기</a>
  </section>


  <div class="clearfix"> </div>
  <section class="item col-6">
    <h3 class="ntit">공지사항</h3>
    <table class="table_skin01">
      <caption>공지사항 최근 게시글 : 번호, 제목, 작성일 표시</caption>
      <colgroup>
        <col style="width:15%" />
        <col />
        <col style="width:20%" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">번호</th>
          <th scope="col">제목</th>
          <th scope="col">작성일</th>
        </tr>
      </thead>
      <tbody>
        <%
      	if(noticeList != null && noticeList.size() > 0){
      		for(int i=0; i<noticeList.size(); i++){
      			out.print("<tr>");
      			out.print("<td>" + noticeList.get(i).getDataSid() + "</td>");
      			out.print("<td>" + noticeList.get(i).getDataTitle() + "</td>");
      			out.print("<td>" + noticeList.get(i).getRegister_str() + "</td>");
      			out.print("</tr>");
      		}
      	}else{
      		out.print("<tr>");
      		out.print("<td colspan=\"3\">" + "게시물이 없습니다." + "</td>");
      		out.print("</tr>");
      	}
      %>
      </tbody>
    </table>
    <a href="<%=freeUrl%>" class="btn small edge white">더보기</a>
  </section>
  <section class="item col-6">
    <h3 class="ntit">자유게시판</h3>
    <table class="table_skin01">
      <caption>자유게시판 최근 게시글 : 번호, 제목, 작성일 표시</caption>
      <colgroup>
        <col style="width:15%" />
        <col />
        <col style="width:20%" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">번호</th>
          <th scope="col">제목</th>
          <th scope="col">작성일</th>
        </tr>
      </thead>
      <tbody>
      <%
      	if(freeList != null && freeList.size() > 0){
      		for(int i=0; i<freeList.size(); i++){
      			out.print("<tr>");
      			out.print("<td>" + freeList.get(i).getDataSid() + "</td>");
      			out.print("<td>" + freeList.get(i).getDataTitle() + "</td>");
      			out.print("<td>" + freeList.get(i).getRegister_str() + "</td>");
      			out.print("</tr>");
      		}
      	}else{
      		out.print("<tr>");
      		out.print("<td colspan=\"3\">" + "게시물이 없습니다." + "</td>");
      		out.print("</tr>");
      	}
      %>
      </tbody>
    </table>
    <a href="<%=freeUrl%>" class="btn small edge white">더보기</a>
  </section>
</div>