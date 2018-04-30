<%
/**
*   PURPOSE :   최근 조사 가격 이력 popup
*   CREATE  :   20180416_mon    JI
*   MODIFY  :   20180418 LJH / col 간격 수정
*	MODIFY	:	20180419_thur	JI		최저가 최고가 비율 bool flag 설정
**/
%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);

String item_no	=	parseNull(request.getParameter("item_no"));

StringBuffer sql 		=   null;
List<FoodVO> foodList 	=   null;
HashMap<Integer, String> valMap	=	null;
HashMap<Integer, String> locMap	=	null;
HashMap<Integer, String> comMap	=	null;
int valMapCnt	=	0;
int minVal		=	0;
int useMinVal   =   0;
int minNo		=	0;
int maxVal		=	0;
int useMaxVal   =   0;
int maxNo		=	0;
Boolean lbRatioBool =   true;

String defaultItemCnt   =   parseNull(request.getParameter("defaultItemCnt"), "5");
int totalCnt            =   0;

try{

    //rsch_val total cnt
    sql =   new StringBuffer();
    sql.append(" SELECT COUNT(RSCH_VAL_NO)      ");
    sql.append(" FROM FOOD_RSCH_VAL             ");
    sql.append(" WHERE 1=1                      ");
    sql.append("    /*AND C.STS_FLAG = 'Y'*/    ");
    sql.append("    AND ITEM_NO = ?             ");
    totalCnt    =   jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{item_no});

    if (totalCnt < Integer.parseInt(defaultItemCnt)) {defaultItemCnt  =   Integer.toString(totalCnt);}

    //rsch_val contents list
    sql =   new StringBuffer();
    sql.append(" SELECT                                                         \n");
    sql.append("    A.RSCH_VAL_NO                                               \n");
    sql.append("    , B.CAT_NO                                                  \n");
    sql.append("    , (SELECT CAT_NM FROM FOOD_ST_CAT                           \n");
    sql.append("        WHERE CAT_NO = B.CAT_NO) AS CAT_NM                      \n");
    sql.append("    , A.ITEM_NO                                                 \n");
    sql.append("    , B.FOOD_CAT_INDEX                                          \n");
    sql.append("    , C.MOD_DATE                                                \n");
    sql.append("    , C.RSCH_NM                                                 \n");
    sql.append("    , A.SCH_NO                                                  \n");
    sql.append("    , ( SELECT SCH_NM                                           \n");
    sql.append("        FROM FOOD_SCH_TB                                        \n");
    sql.append("        WHERE SCH_NO = A.SCH_NO                                 \n");
    sql.append("    ) AS SCH_NM                                                 \n");
    sql.append("    , A.NU_NO                                                   \n");
    sql.append("    , ( SELECT NU_NM                                            \n");
    sql.append("        FROM FOOD_SCH_NU                                        \n");
    sql.append("        WHERE NU_NO = A.NU_NO                                   \n");
    sql.append("    ) AS NU_NM                                                  \n");
    sql.append("    , A.ZONE_NO                                                 \n");
    sql.append("    , (SELECT ZONE_NM                                           \n");
    sql.append("      FROM FOOD_ZONE                                            \n");
    sql.append("      WHERE ZONE_NO = A.ZONE_NO                                 \n");
    sql.append("    ) AS ZONE_NM                                                \n");
    sql.append("    , A.TEAM_NO                                                 \n");
    sql.append("    , (SELECT TEAM_NM                                           \n");
    sql.append("      FROM FOOD_TEAM                                            \n");
    sql.append("      WHERE TEAM_NO = A.TEAM_NO                                 \n");
    sql.append("    ) AS TEAM_NM                                                \n");
    sql.append("    , B.FOOD_CODE                                               \n");

    sql.append("    , (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)		\n");
    sql.append("    ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)		\n");
    sql.append("    NM_FOOD														\n");
    sql.append("    FROM FOOD_ST_NM												\n");
    sql.append("    WHERE NM_NO IN (											\n");
    sql.append("    FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))		\n");
    sql.append("    AS NM_FOOD 													\n");
    
    sql.append("    , (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)			\n");
    sql.append("    ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)		\n");
    sql.append("    DT_NM														\n");
    sql.append("    FROM FOOD_ST_DT_NM											\n");
    sql.append("    WHERE DT_NO IN(												\n");
    sql.append("    FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,		\n");
    sql.append("    FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))	\n");
    sql.append("    AS DT_NM 													\n");
    
    sql.append("    , (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)			\n");
    sql.append("    ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)		\n");
    sql.append("    EX_NM														\n");
    sql.append("    FROM FOOD_ST_EXPL											\n");
    sql.append("    WHERE EX_NO IN(												\n");
    sql.append("    FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,		\n");
    sql.append("    FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 	\n");
    sql.append("    FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n");
    sql.append("    FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n");
    sql.append("    FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))\n");
    sql.append("    AS EX_NM 													\n");

    sql.append("    , (SELECT UNIT_NM      										\n");
    sql.append("      FROM FOOD_ST_UNIT       									\n");
    sql.append("      WHERE UNIT_NO = B.FOOD_UNIT								\n");
    sql.append("    ) AS UNIT_NM              									\n");
    sql.append("    , A.NON_SEASON           									\n");
    sql.append("    , A.NON_DISTRI           									\n");
    sql.append("    , A.LOW_VAL                									\n");
    sql.append("    , A.AVR_VAL                									\n");
    sql.append("    , A.CENTER_VAL             									\n");
    sql.append("    , (             									        \n");
    sql.append("        SELECT                                                  \n");
    sql.append("            AVG(AVR_VAL)                                        \n");
    sql.append("        FROM FOOD_RSCH_VAL                                      \n");
    sql.append("        WHERE RSCH_NO = A.RSCH_NO                               \n");
    sql.append("            AND ITEM_NO = A.ITEM_NO                             \n");
    sql.append("    ) AS ZONE_AVR_VAL        									\n");
    sql.append("    , A.RSCH_VAL1             									\n");
    sql.append("    , A.RSCH_VAL2             									\n");
    sql.append("    , A.RSCH_VAL3             									\n");
    sql.append("    , A.RSCH_VAL4             									\n");
    sql.append("    , A.RSCH_VAL5             									\n");
    sql.append("    , A.RSCH_LOC1             									\n");
    sql.append("    , A.RSCH_LOC2             									\n");
    sql.append("    , A.RSCH_LOC3             									\n");
    sql.append("    , A.RSCH_LOC4             									\n");
    sql.append("    , A.RSCH_LOC5             									\n");
    sql.append("    , A.RSCH_COM1             									\n");
    sql.append("    , A.RSCH_COM2             									\n");
    sql.append("    , A.RSCH_COM3             									\n");
    sql.append("    , A.RSCH_COM4             									\n");
    sql.append("    , A.RSCH_COM5             									\n");
    sql.append("    , TO_CHAR(A.RSCH_DATE, 'YYYY-MM-DD') AS RSCH_DATE			\n");
    sql.append("    , A.RSCH_REASON           									\n");
    sql.append("    , E.LOW_RATIO           									\n");
    sql.append("    , E.AVR_RATIO           									\n");
    sql.append("    , E.LB_RATIO               									\n");
    sql.append("    , (                        									\n");
    sql.append("        CASE                                                    \n");
    sql.append("        WHEN (                                                  \n");
    sql.append("            A.LOW_VAL / ((SELECT Z.LOW_VAL                      \n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL                   \n");
    sql.append("                ORDER BY RSCH_VAL_NO DESC) Z                    \n");
    sql.append("            WHERE Z.RSCH_VAL_NO < A.RSCH_VAL_NO                 \n");
    sql.append("                AND Z.RSCH_NO < A.RSCH_NO                       \n");
    sql.append("                AND Z.ITEM_NO = A.ITEM_NO                       \n");
    sql.append("                AND Z.ZONE_NO = A.ZONE_NO                       \n");
    sql.append("                AND ROWNUM = 1) + A.LOW_VAL) * 100              \n");
    sql.append("        ) IS NULL                                               \n");
    sql.append("        THEN 'Y'                                                \n");
    sql.append("        WHEN (                                                  \n");
    sql.append("            A.LOW_VAL / ((SELECT Z.LOW_VAL                      \n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL                   \n");
    sql.append("                ORDER BY RSCH_VAL_NO DESC) Z                    \n");
    sql.append("            WHERE Z.RSCH_VAL_NO < A.RSCH_VAL_NO                 \n");
    sql.append("                AND Z.RSCH_NO < A.RSCH_NO                       \n");
    sql.append("                AND Z.ITEM_NO = A.ITEM_NO                       \n");
    sql.append("                AND Z.ZONE_NO = A.ZONE_NO                       \n");
    sql.append("                AND ROWNUM = 1) + A.LOW_VAL) * 100              \n");
    sql.append("        ) < E.LOW_RATIO                                         \n");
    sql.append("        THEN 'N'                                                \n");
    sql.append("        ELSE 'Y'                                                \n");
    sql.append("        END                                                     \n");
    sql.append("    ) AS LOW_FLAG            									\n");
    sql.append("    , (															\n");
    sql.append("		CASE			 										\n");
    sql.append("        WHEN (			 										\n");
    sql.append("			A.AVR_VAL / ((SELECT Z.LOW_VAL			 		    \n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL					\n");
    sql.append("            	ORDER BY RSCH_VAL_NO DESC) Z					\n");
    sql.append("            WHERE Z.RSCH_VAL_NO < A.RSCH_VAL_NO				    \n");
    sql.append("            	AND Z.RSCH_NO < A.RSCH_NO						\n");
    sql.append("            	AND Z.ITEM_NO = A.ITEM_NO						\n");
    sql.append("            	AND Z.ZONE_NO = A.ZONE_NO						\n");
    sql.append("            	AND ROWNUM = 1) + A.LOW_VAL) * 100			    \n");
    sql.append("            ) IS NULL											\n");
    sql.append("		THEN 'Y'												\n");
    sql.append("        WHEN (													\n");
    sql.append("        	A.LOW_VAL / ((SELECT Z.LOW_VAL					    \n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL					\n");
    sql.append("            	ORDER BY RSCH_VAL_NO DESC) Z					\n");
    sql.append("            WHERE Z.RSCH_VAL_NO < A.RSCH_VAL_NO				    \n");
    sql.append("            	AND Z.RSCH_NO < A.RSCH_NO						\n");
    sql.append("            	AND Z.ITEM_NO = A.ITEM_NO						\n");
    sql.append("            	AND ROWNUM = 1) + A.LOW_VAL) * 100			    \n");
    sql.append("		) < E.LOW_RATIO										    \n");
    sql.append("        THEN 'N'												\n");
    sql.append("        ELSE 'Y'												\n");
    sql.append("        END														\n");
    sql.append("	) AS AVR_FLAG											    \n");

    sql.append(" FROM FOOD_RSCH_VAL A JOIN FOOD_ST_ITEM B                       \n");
    sql.append(" ON A.ITEM_NO = B.ITEM_NO JOIN FOOD_RSCH_TB C                   \n");
    sql.append(" ON A.RSCH_NO = C.RSCH_NO JOIN FOOD_SCH_TB D                    \n");
    sql.append(" ON A.SCH_NO = D.SCH_NO JOIN FOOD_ITEM_PRE E                    \n");
    sql.append(" ON A.ITEM_NO = E.ITEM_NO                                       \n");
    sql.append(" WHERE 1=1                                                      \n");
    sql.append("    /*AND C.STS_FLAG = 'Y'*/                                    \n"); //조사 식품이 없어 임시 주석 처리 나중에 풀어야 함~~
    sql.append("    AND A.ITEM_NO = ?                                           \n");
    sql.append("    AND ROWNUM <= ?                                             \n");
    sql.append(" ORDER BY A.RSCH_VAL_NO, C.REG_DATE, A.REG_DATE                 \n");
    try {
        foodList    =   jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{item_no, defaultItemCnt});
    } catch(Exception e) {
        foodList    =   null;
    }

}catch(Exception e){
	out.println(e.toString());
}
%>

<section class="pop_update">
	<h1 class="c">최근 조사 가격 이력</h1>

    <div class="tab_wrap clearfix">
    <%-- 공백 --%>
    </div>

    <div class="tab_container">

        <table class="table_skin01 td-pd1">
        <caption>품목구분별 거래실례가격 정보 조회 : 권역, 조사명, 조사날짜, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 적용단가, 비교그룹, 평균가, 중앙가, 세권역통합평균가, 조사자, 소속, 조사가1~3 등</caption>
        <colgroup>
          <col style="width:4%"/>
          <col style="width:5%" />
          <col style="width:3%" />
          <col style="width:6%"/>
          <col style="width:4%" />
          <col style="width:3%"/>
          <col style="width:5%"/>
          <col style="width:10%"/>
          <col style="width:2%"/>
          <col style="width:2.5%" />
          <col style="width:2.5%"/>
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col />
          <col style="width:5%"/>
          <col style="width:10%"/>
        </colgroup>
            <thead>
            <tr>
                <th scope="col">조사번호</th>
                <th scope="col">품목구분</th>
                <th scope="col">권역</th>
                <th scope="col">조사명</th>
                <th scope="col">식품코드</th>
                <th scope="col">식품명</th>
                <th scope="col">상세 식품명</th>
                <th scope="col">식품설명</th>
                <th scope="col">단위</th>
                <th scope="col">비계절</th>
                <th scope="col">비유통</th>
                <th scope="col">비교그룹</th>
                <th scope="col">평균가</th>
                <th scope="col">중앙가</th>
                <th scope="col">세권역<br />통합평균가</th>
                <th scope="col">조사자</th>
                <th scope="col">소속</th>
                <th scope="col">조사가1</th>
                <th scope="col">조사가2</th>
                <th scope="col">조사가3</th>
                <th scope="col">조사처1</th>
                <th scope="col">조사처2</th>
                <th scope="col">조사처3</th>
                <th scope="col">브랜드1</th>
                <th scope="col">브랜드2</th>
                <th scope="col">브랜드3</th>
                <th scope="col">조사날짜</th>
                <th scope="col">비고</th>
            </tr>
            </thead>
            <tbody>
            <%
            if (foodList != null && foodList.size() > 0) {
                for (FoodVO vo : foodList) {
                    //초기화~~
                    useMaxVal   =   0;
                    useMinVal   =   0;
            %>
                <tr>
                    <td><%=vo.rsch_val_no %></td>
                    <td><%=vo.cat_nm %> - <%=vo.food_cat_index %></td>
                    <td><%=vo.zone_nm %></td>
                    <td><%=vo.rsch_nm %></td>
                    <td><%=vo.food_code %></td>
                    <td class="fb"><%=vo.nm_food %></td>
                    <td><%=vo.dt_nm %></td>
                    <td><%=vo.ex_nm %></td>
                    <td><%=vo.unit_nm %></td>
                    <td>
                        <%if ("Y".equals(vo.non_season)) {out.println("O");}
                        else {out.println("X");}%>
                    </td>
                    <td>
                        <%if ("Y".equals(vo.non_distri)) {out.println("O");}
                        else {out.println("X");}%>
                    </td>
                   <%--  <td><%if ("N".equals(vo.low_flag)){%><span class="fb red" title="최저가 비율 초과"><%}%>
                        <%=parseNull(vo.low_val, "-") %>
                    </td> --%>
                    <td><%=vo.item_comp_no%></td>
                    <td><%if ("N".equals(vo.avr_flag)){%><span class="fb red"><%}%>
                        <%=parseNull(vo.avr_val, "-") %>
                    </td>
                    <td><%=parseNull(vo.center_val, "-") %></td>
                    <td><%=parseNull(vo.zone_avr_val, "-") %></td>
                    <td><%=vo.sch_nm %> /<br><%=vo.nu_nm %></td>
                    <td><%=vo.zone_nm %>/<br><%=vo.team_nm %></td>
                <%
                    /*조사가 정렬 출력*/
                    valMap  =   null;
					valMap	=	new HashMap<Integer, String>();
                    valMap.put(1, parseNull(vo.rsch_val1, "-"));
					valMap.put(2, parseNull(vo.rsch_val2, "-"));
					valMap.put(3, parseNull(vo.rsch_val3, "-"));
					valMap.put(4, parseNull(vo.rsch_val4, "-"));
					valMap.put(5, parseNull(vo.rsch_val5, "-"));
                    /*조사처 정렬 출력*/
                    locMap  =   null;
                    locMap  =   new HashMap<Integer, String>();
                    locMap.put(1, parseNull(vo.rsch_loc1, "-"));
                    locMap.put(2, parseNull(vo.rsch_loc2, "-"));
                    locMap.put(3, parseNull(vo.rsch_loc3, "-"));
                    locMap.put(4, parseNull(vo.rsch_loc4, "-"));
                    locMap.put(5, parseNull(vo.rsch_loc5, "-"));

                    /*브랜드 정렬 출력*/
                    comMap  =   null;
                    comMap  =   new HashMap<Integer, String>();
                    comMap.put(1, parseNull(vo.rsch_com1, "-"));
                    comMap.put(2, parseNull(vo.rsch_com2, "-"));
                    comMap.put(3, parseNull(vo.rsch_com3, "-"));
                    comMap.put(4, parseNull(vo.rsch_com4, "-"));
                    comMap.put(5, parseNull(vo.rsch_com5, "-"));
                    valMapCnt   =   0;  //초기화
                    for (int j = 1; j <= valMap.size(); j++) {
						if (!"-".equals(valMap.get(j))) {valMapCnt++;}
                    }
                    //가격 유무 여부 확인
                    if (valMapCnt > 0) {
                        if (valMapCnt == 5) {
                            //5개의 값이 모두 같을 경우 산정하기....
							int duplCnt	=	0;
							for (int j = 1; j <= valMap.size(); j++) {
								if (valMap.get(1).equals(valMap.get(j))) {
									duplCnt++;
								}
							}
							//최고값 최저값
							int strNo	=	0;
							for (int j = 1; j <= valMap.size(); j++) {
								if (!"-".equals(valMap.get(j)) && strNo == 0) {
									strNo	=	j;
									minVal	=	Integer.parseInt(valMap.get(j));
									maxVal	=	Integer.parseInt(valMap.get(j));
								}
								if (!"-".equals(valMap.get(j)) && minVal < Integer.parseInt(valMap.get(j))) {
									minVal	=	minVal;
								} else if (!"-".equals(valMap.get(j)) && minVal >= Integer.parseInt(valMap.get(j))) {
									minVal	=	Integer.parseInt(valMap.get(j));
									if (duplCnt == valMap.size()) {minNo	=	j - 1;} 
									else {minNo	=	j;}
								}
								if (!"-".equals(valMap.get(j)) && maxVal > Integer.parseInt(valMap.get(j))) {
									maxVal	=	maxVal;
								} else if (!"-".equals(valMap.get(j)) && maxVal <= Integer.parseInt(valMap.get(j))) {
									maxVal	=	Integer.parseInt(valMap.get(j));
									maxNo	=	j;
								}
							}
							for (int j = 1; j <= valMap.size(); j++) {
								if (j != minNo && j != maxNo) {%>
									<td><span><%=valMap.get(j) %></span></td>
							<%	
                                    useMaxVal   =   Integer.parseInt(valMap.get(j));
                                    useMinVal   =   Integer.parseInt(valMap.get(j));
                                    if (useMaxVal < Integer.parseInt(valMap.get(j))) {
                                        useMaxVal   =   Integer.parseInt(valMap.get(j));
                                    }
                                    if (useMinVal > Integer.parseInt(valMap.get(j))) {
                                        useMinVal   =   Integer.parseInt(valMap.get(j));
                                    }
                                    lbRatioBool =   lbRatioBool(useMinVal, useMaxVal, vo.lb_ratio);
                                }
							}
						//가격이 3개 일 경우
						} else if (valMapCnt == 3) {
							for (int j = 1; j <= valMap.size(); j++) {
								if (!"-".equals(valMap.get(j))) {%>
									<td><span><%=valMap.get(j) %></span></td>
							<%
                                    useMaxVal   =   Integer.parseInt(valMap.get(j));
                                    useMinVal   =   Integer.parseInt(valMap.get(j));
                                    if (useMaxVal < Integer.parseInt(valMap.get(j))) {
                                        useMaxVal   =   Integer.parseInt(valMap.get(j));
                                    }
                                    if (useMinVal > Integer.parseInt(valMap.get(j))) {
                                        useMinVal   =   Integer.parseInt(valMap.get(j));
                                    }
                                    lbRatioBool =   lbRatioBool(useMinVal, useMaxVal, vo.lb_ratio);
                            }}%>

						<%//가격이 1개일 경우... 혹시 모르니...
						} else if (valMapCnt == 1) {%>
							<td><span>
							<%for (int j = 1; j <= valMap.size(); j++) {
								if (!"-".equals(valMap.get(j))) {
									out.println(valMap.get(j));
							}}%>
							</span></td>
							<td><span> - </span></td>
							<td><span> - </span></td>
						<%}
                    } else {%>
                        <td><span> - </span></td>
						<td><span> - </span></td>
						<td><span> - </span></td>
                    <%}
                    //조사처 유무 여부 확인
                    if (valMapCnt > 0) {
                        if (valMapCnt == 5) {
                            for (int j = 1; j <= locMap.size(); j++) {
								if (j != minNo && j != maxNo) {%>
									<td><span><%=locMap.get(j) %></span></td>
							<%	}
							}
                        } else if (valMapCnt == 3) {
                            for (int j = 1; j <= locMap.size(); j++) {
								if (!"-".equals(locMap.get(j))) {%>
									<td><span><%=locMap.get(j) %></span></td>
							<%}}
                        } else if (valMapCnt == 1) {%>
                            <td><span>
							<%for (int j = 1; j <= locMap.size(); j++) {
								if (!"-".equals(locMap.get(j))) {
									out.println(locMap.get(j));
							}}%>
							</span></td>
							<td><span> - </span></td>
							<td><span> - </span></td>
                        <%}
                    } else {%>
                        <td><span> - </span></td>
						<td><span> - </span></td>
						<td><span> - </span></td>
                    <%}
                    //브랜드 유무 여부 확인
                    if (valMapCnt > 0) {
                        if (valMapCnt == 5) {
                            for (int j = 1; j <= comMap.size(); j++) {
								if (j != minNo && j != maxNo) {%>
									<td><span><%=comMap.get(j) %></span></td>
							<%	}
							}
                        } else if (valMapCnt == 3) {
                            for (int j = 1; j <= comMap.size(); j++) {
								if (!"-".equals(comMap.get(j))) {%>
									<td><span><%=comMap.get(j) %></span></td>
							<%}}
                        } else if (valMapCnt == 1) {%>
                            <td><span>
							<%for (int j = 1; j <= comMap.size(); j++) {
								if (!"-".equals(comMap.get(j))) {
									out.println(comMap.get(j));
							}}%>
							</span></td>
							<td><span> - </span></td>
							<td><span> - </span></td>
                        <%}
                    } else {%>
                        <td><span> - </span></td>
						<td><span> - </span></td>
						<td><span> - </span></td>
                    <%}

                %>
                    <td><%=parseNull(vo.rsch_date, "-") %></td>
                    <td><%=parseNull(vo.rsch_reason, "-") %></td>
                </tr>
                <%}/*END FOR*/%>
                <%if (totalCnt > Integer.parseInt(defaultItemCnt)) {%>
                <tr>
                    <td colspan="28">
                        <button type="button" id="addMore" data-value="<%=defaultItemCnt %>" class="btn medium darkblue fb w_150">더 보기</button>
                    </td>
                </tr>
                <%} else if (totalCnt <= Integer.parseInt(defaultItemCnt)) {%>
                <tr>
                    <td colspan="28"><span class="medium darkblue fb w_150">마지막 입니다.</span></button>
                    </td>
                </tr>
                <%}%>
                <%}/*END IF*/ else {%>
                <tr>
                    <td colspan="28"><span>조사된 이력이 없습니다.</span></td>
                </tr>
                <%}%>
            </tbody>
        </table>
    </div>

    <div class="btn_area c magT10">
        <button type="submit" class="btn medium mako fb w_150" onclick="window.close();">닫 기</button>
    </div>

</section>

<script>

    $(function () {
        $("#addMore").click(function (){
            var item_no =   "<%=item_no %>";
            var defaultItemCnt  =   $("#addMore").data("value") + 1;
            location.href   =   "/index.gne?menuCd=DOM_000000127003002000&item_no="+item_no+"&defaultItemCnt="+defaultItemCnt;
        });
    });

</script>