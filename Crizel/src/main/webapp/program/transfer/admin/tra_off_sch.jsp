<%
/**
*	PURPOSE	:	전입학 / 전입학 오프라인 등록 / 학교선택
*	CREATE	:	20180124_wed	JMG
*	MODIFY	:	....
*/

%>

<%!
//type이 0일경우 코드값(1,2,3) 출력, type이 1일경우 messeage 출력
public static String resultType(int shortInNum, int shortOutNum, int fixNum, int currNum){
	String resultStr	=	"";
	int sum				=	shortInNum + shortOutNum;
	if((fixNum > currNum) && (shortInNum + shortOutNum) > 0){
		resultStr	=	"1";
	}else if((fixNum <= currNum) && (shortInNum + shortOutNum) > 1){
		resultStr	=	"2";
	}else if((fixNum <= currNum) && (shortInNum + shortOutNum) < 1){
		resultStr	=	"3";
	}
	
	return resultStr;
}

%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);
Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;
String sql_str          =   "";
String sql_where        =   "";
int key                 =   0;
int result              =   0;

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){ */
	%>
<!-- 	<script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script>
 --><%/* } */

//파라미터
String goTab			=	parseNull(request.getParameter("goTab"));
String genderParam		=	parseNull(request.getParameter("stsex"));
String fuseYn			=	parseNull(request.getParameter("fuseyn"));
String fcode			=	parseNull(request.getParameter("fcode"));
String stGradeParam		=	parseNull(request.getParameter("stgrade"));

String orgNo			=	"";
String orgName			=	"";
String stSex			=	"";
String gender			=	"";
String orgArea			=	"";
int fixNum				=	0;
int currNum				=	0;
int shortInNum			=	0;
int shortOutNum			=	0;
String tabChk			=	"Y";		//DEFAULT 값
String cssTxt			=	"";

String tabName			=	"";
String tabNo			=	"";
String useYn			=	"";

List<Map<String, Object>> tabList		=	null;
List<Map<String, Object>> schoolList	=	null;

try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
    
	//탭
    sql     =   new StringBuffer();
    sql_str =   "SELECT TABNAME, TABNO, USEYN FROM TORG_TAB WHERE USEYN !='N' ORDER BY TABNO ";
    sql.append(sql_str);
    pstmt	=	conn.prepareStatement(sql.toString());
    rs      =   pstmt.executeQuery();
    tabList	=	getResultMapRows(rs);
    
    if(tabList == null || tabList.size() < 1){
    	tabChk	= "N";
    }
    
    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}     
    
    //첫 페이지 보여주기
    if("".equals(goTab) && "Y".equals(tabChk)){		//사용여부가 Y인 테이블이 하나이상 존재하고 goTab이 빈값일 떄
    	sql     =   new StringBuffer();
        sql_str =   "SELECT MIN(TABNO) AS GO_TAB FROM TORG_TAB WHERE USEYN !='N' ORDER BY TABNO ";
        sql.append(sql_str);
        pstmt	=	conn.prepareStatement(sql.toString());
        rs      =   pstmt.executeQuery();
        if(rs.next())	goTab = rs.getString("GO_TAB");
        	
        if (rs != null) try { rs.close(); } catch (SQLException se) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}        
    }    
    
    sql		=	new StringBuffer();
    sql_str	=	" SELECT INFO.ORGNO, INFO.ORGNAME, INFO.SEX, INFO.TABNO, INFO.ORGAREA, NUM.SHORTINNUM, 	";
    sql_str +=	" NUM.SHORTOUTNUM, NUM.FIXNUM, NUM.CURRNUM FROM TORG_INFO INFO, TORG_TAB TAB, TORG_NUM_PERSON NUM				";
    sql_str	+=	" WHERE INFO.TABNO = TAB.TABNO AND INFO.ORGNO = NUM.ORGNO AND 			";
    sql_str +=	" INFO.TABNO = ? AND TAB.USEYN != 'N' 									";
    sql_str +=	" AND (INFO.SEX = ? OR INFO.SEX = 'C') AND INFO.USEYN != 'N'			";		
    sql_str	+=	" AND NUM.GRADE = ?														";
    
    if("Y".equals(fuseYn)){
   		sql_where	=	" AND (NUM.FCODE = ? OR NUM.FCODE2 = ? OR NUM.FCODE3 = ?) ";
   		sql_str 	+=	sql_where;
    }
    
    sql.append(sql_str);
    pstmt		=	conn.prepareStatement(sql.toString());
    pstmt.setString(1, goTab);
    pstmt.setString(2, genderParam);
    pstmt.setString(3, stGradeParam);
    
    if("Y".equals(fuseYn)){
    	pstmt.setString(4, fcode);
    	pstmt.setString(5, fcode);
    	pstmt.setString(6, fcode);
    }
    
    rs			=	pstmt.executeQuery();
    schoolList	=	getResultMapRows(rs);
	
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>

<h1 class="blind">학교 선택</h1>
<div id="right_view">
    <div class="top_view">
        <p class="location"><strong>희망학교 선택</strong></p>
    </div>
</div>
<br/>
<div class="contents" style="padding:10px;">
<div class="searchBox">
<%
if(tabList != null && tabList.size() > 0){
	for(int i=0; i<tabList.size(); i++){
		Map<String, Object> map	=	tabList.get(i);
		tabName =   parseNull((String)map.get("TABNAME"));
		tabNo	=   parseNull((String)map.get("TABNO"));
		useYn	=   parseNull((String)map.get("USEYN"));
		%>
		<span <%if(goTab.equals(tabNo)){ %>class="btn small edge white"<%}else{ %>class="btn small edge mako"<%} %>>
			<a href="javascript:selTab('<%=tabNo%>');" <%if(goTab.equals(tabNo)){ %><%}else{ %>style="color:white;"<%} %>
			title="<%=tabName%>"><%=tabName%></a>           					
		</span>
		<%                        				
	}
}
%>
</div>
<br/>
<!-- 선택한 학교 (태그수정하면 안됩니다!) -->
<div id="selectSchools" style="height:60px; width:200px; float:left;">
	<select size="3" name="selSchools" id="selSchools" style="height:60px; width:200px;"></select>
</div>
<br/>
<div style="float:left; width:80px; height:60px; text-align:center;">
	<input type="button" value="삭제" onclick="javascript:optionRemove();" class="btn small edge mako">
</div>
<!-- //선택한 학교 -->
<!-- 타입비교용 -->
<div id="schType" style="display:none;">

</div>

<div class="listArea">
	<form name="schoolForm" id="schoolForm" method="post">
		<table class="bbs_list">
			<caption>희망학교 선택입니다.</caption>
			<colgroup>
				<col style="">
				<col style="">
				<col style="">
				<col style="">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">학교명</th>
					<th scope="col">지역</th>
					<th scope="col">구분</th>
					<th scope="col">선택</th>
				</tr>
			</thead>
			<tbody>
			
			<%
				if(schoolList != null && schoolList.size() > 0){
					for(int i=0; i<schoolList.size(); i++){
						Map<String, Object> map = schoolList.get(i);
						orgName		=	(String)map.get("ORGNAME");
						stSex		=	(String)map.get("SEX");
						orgArea		=	(String)map.get("ORGAREA");
						orgNo		=	(String)map.get("ORGNO");
						fixNum		=	Integer.parseInt(parseNull((String)map.get("FIXNUM"),"1"));
						currNum		=	Integer.parseInt(parseNull((String)map.get("CURRNUM"),"1"));
						shortInNum	=	Integer.parseInt(parseNull((String)map.get("SHORTINNUM"),"1"));
						shortOutNum =	Integer.parseInt(parseNull((String)map.get("SHORTOUTNUM"),"1"));
					
	   					if("F".equals(stSex)){
           					gender = "여";
           				}else if("M".equals(stSex)){
           					gender = "남";
           				}else{
           					gender = "공학";
           				}
	   					
	   					if("1".equals(resultType(shortInNum, shortOutNum, fixNum, currNum))){
	   						cssTxt	=	"style='color:blue;'";
	   					}else if("2".equals(resultType(shortInNum, shortOutNum, fixNum, currNum))){
	   						cssTxt	=	"style='color:orange;'";
	   					}else if("3".equals(resultType(shortInNum, shortOutNum, fixNum, currNum))){
	   						cssTxt	=	"style='color:red;'";
	   					}
	   				
					%>
					<tr>
						<td><span <%=cssTxt%>><%=orgName%></span><%-- <%=resultType(shortInNum, shortOutNum, fixNum, currNum) %> --%></td>
						<td><%=orgArea%></td>
						<td><%=gender%></td>
						<td><a href="javascript:schComp('<%=orgNo%>', '<%=orgName%>', 
						'<%=resultType(shortInNum, shortOutNum, fixNum, currNum)%>', '<%=resultType(shortInNum, shortOutNum, fixNum, currNum)%>');">선택</a></td>
					</tr>	
					<%
					}
				}
			%>
			</tbody>
		</table>    
	</form>  
	<div style="text-align:center">    
	<input type="button" value="적용" onclick="javascript:inputSchool();" class="btn mako medium">
	</div>
</div>
</div>