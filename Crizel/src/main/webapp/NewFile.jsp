<%@ page import = "java.sql.*" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.Statement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.sql.SQLException" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.io.File" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat" %>
<style>
#view_tab th{font-weight:bold; vertical-align:middle; padding-left:10px}
#view_tab td{vertical-align:middle; padding-left:10px}
#view_tab .view_tr{border-right:1px solid #dbdbdb}
#view_tab .view_tb{border-bottom:1px solid #dbdbdb}
#btn_g{margin:10px 0 10px 0; font-size:14px}
#btn_g a{padding:5px 5px 5px 5px;}
#btn_g .nav_a{border:1px solid #dbdbdb; padding:5px 5px 5px 5px;}
#btn_g .nav_a2{border:1px solid #dbdbdb; padding:5px 2px 5px 2px;}
</style>
<%
Calendar cal = Calendar.getInstance();
int nowYear = cal.get(Calendar.YEAR);

String menuCd = request.getParameter("menuCd");
String searchYear = request.getParameter("searchType") == null ? ""+nowYear : request.getParameter("searchYear") ;
String searchInst = request.getParameter("searchInst") == null ? "" : request.getParameter("searchInst") ;
String sdate = request.getParameter("sdate") == null ? "" : request.getParameter("sdate") ;
String edate = request.getParameter("edate") == null ? "" : request.getParameter("edate") ;
String searchType = request.getParameter("searchType") == null ? "" : request.getParameter("searchType") ;
String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword") ;
String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode") ;
String num = request.getParameter("num") == null ? "" : request.getParameter("num") ;
String pageNum = request.getParameter("pageNum");
String sub_sql = "";
String sub_sql2 = "";
int current_page = 1;
if(pageNum != null){
	current_page = Integer.parseInt(pageNum);
}
DecimalFormat df = new DecimalFormat("###,###,###,###");
SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
Class.forName("oracle.jdbc.driver.OracleDriver");
Connection 	SrcConn = null;
Statement 	SrcStmt = null;
PreparedStatement pstmt1 = null;
ResultSet 	rs = null;
Statement 	SrcStmt2 = null;
PreparedStatement pstmt2 = null;
ResultSet 	rs2 = null;
%>
<%!
public String pageIndexList2(int current_page,int total_page, String list_url){
	
	int numPerBlock=10;
	int currentPageSetup;
	int n,page;
	StringBuffer sb=new StringBuffer();
	
	
	if(current_page==0||total_page==0)
		return"";
	
	if(list_url.indexOf("?")!=-1){
		list_url=list_url+"&";
	}else{
		list_url=list_url+"?";
	}
	
	//currentPageSetup:표시할 첫페이지-1의 값
	/*currentPageSetup=( (current_page-1)/numPerBlock)*numPerBlock;*/
	currentPageSetup=( (current_page)/numPerBlock)*numPerBlock;
	// 1                   1/10 * 10             0
	// 10                  9/10 * 10             0
	// 11~20                 /10 * 10            10
	// 21~30                 /10 * 10            20
	
	if(current_page%numPerBlock==0)
		currentPageSetup=currentPageSetup-numPerBlock;
	
	//1,[prev]
	n=current_page-numPerBlock;

	if(total_page>numPerBlock&&currentPageSetup>=0){
		sb.append("<a href=\"" +list_url + "pageNum=1\">&lt;&lt;</a>&nbsp;");
		sb.append("<a href=\"" + list_url + "pageNum=" + n + "\">&lt;</a>");
	}
	//바로가기 페이지
	page=currentPageSetup+1;
	while(page<=total_page&&page<=(currentPageSetup+numPerBlock)){
		if(page > 1000){
			if(page==current_page){
				sb.append("<a href=\""+list_url+"pageNum="+page+"\"  class='on'>"+page+"</a>&nbsp;");
			}else{
				sb.append("<a href=\""+list_url+"pageNum="+page+"\"  >"+page+"</a>&nbsp;");
			}
		}else{
			if(page==current_page){
				sb.append("<a href=\""+list_url+"pageNum="+page+"\"  class='on'>"+page+"</a>&nbsp;");
			}else{
				sb.append("<a href=\""+list_url+"pageNum="+page+"\"  >"+page+"</a>&nbsp;");
			}
		}
		page++;
	}
	
	//[Next], 마지막 페이지
	n=current_page+numPerBlock;
	if(total_page-currentPageSetup > numPerBlock){
		sb.append("<a href=\""+list_url+"pageNum="+n+"\">&gt;</a>");
		sb.append("<a href=\""+list_url+"pageNum="+total_page+"\">&gt;&gt;</a>");
		
	}
	
	return sb.toString();
}
%>

<%

if(mode.equals("")){ %>

<section class="board">

<div class="search_form">
	<form name="searchBaseForm" method="post" action="/index.gne?menuCd=<%=menuCd%>">
    <fieldset>
	<legend>게시물 검색</legend>
	<input type="hidden" name="startPage" value="1"/>
	<input type="hidden" name="searchType" value="CNTR_NM"/>
	<ul class="n3">
		<li>
			<span>회계년도</span>
			<select name="searchYear" id="searchYear" class="layout_select2" title="회계년도선택">
				<% 
				for(int y=nowYear; y>=2013; y--) { 
					String selYear = "" + y;
				%>
				<option value="<%=selYear%>" <%if(searchYear.equals(selYear))out.print("selected=\"selected\"");%>><%=selYear%>년</option>
				<% 
				} 
				%>
			</select>
            </li>
		
        <li class="w50">
			<span>계약일자</span>
			<input type="text" title="시작일" name="sdate" id="sdate" value="<%=sdate%>" class="layout_input2 datepicker" onclick="this.value=''" maxlength="10" style="ime-mode:disabled;height:20px; padding:0; width:85px" />
			~
			<input type="text" title="종료일" name="edate" id="edate" value="<%=edate%>" class="layout_input2 datepicker mr15" onclick="this.value=''" maxlength="10" style="ime-mode:disabled;height:20px; padding:0; width:85px" />
		</li>
        
		<li style="padding-top:5px">
			<span>계약기관</span>
			<input type="text" name="searchInst" title="계약기관 입력" class="layout_input2 mr15" value="<%=searchInst%>" onclick="this.value=''"   style="height:20px; padding:0; width:131px"/>
            </li>
       
	<li class="w50" style="padding-top:5px">
			<span>계약명</span>
			<input type="text" name="keyword" title="검색어 입력" class="layout_input2" value="<%=keyword%>" onclick="this.value=''"   style="height:20px; padding:0; width:188px"/>
			<!-- <input type="image" src="/rfc/board/images/common/board_icon09.gif" title="글검색" alt="글검색" class="layout_btn02_1"/>			-->
			
		</li>
        <button style="cursor:pointer">검색하기</button>
	</ul>

	<%--
	회계년도
	<select name="searchYear" id="searchYear" class="layout_select2" title="회계년도선택">
		<% 
		for(int y=nowYear; y>=2013; y--) { 
			String selYear = "" + y;
		%>
		<option value="<%=selYear%>" <%if(searchYear.equals(selYear))out.print("selected=\"selected\"");%>><%=selYear%>년</option>
		<% 
		} 
		%>
	</select>
	&nbsp; &nbsp;
	계약일자
	<input type="text" title="시작일" name="sdate" id="sdate" value="<%=sdate%>" class="layout_input2 datepicker" onclick="this.value=''" maxlength="10" style="ime-mode:disabled;height:20px; padding:0; width:90px" />
	~
	<input type="text" title="종료일" name="edate" id="edate" value="<%=edate%>" class="layout_input2 datepicker" onclick="this.value=''" maxlength="10" style="ime-mode:disabled;height:20px; padding:0; width:90px" />
	&nbsp; &nbsp;
	계약기관
	<input type="text" name="searchInst" title="계약기관 입력" class="layout_input2" value="<%=searchInst%>" onclick="this.value=''"   style="height:20px; padding:0;"/>
	&nbsp; &nbsp;
	계약명
	<input type="text" name="keyword" title="검색어 입력" class="layout_input2" value="<%=keyword%>" onclick="this.value=''"   style="height:20px; padding:0;"/>
	<!-- <input type="image" src="/rfc/board/images/common/board_icon09.gif" title="글검색" alt="글검색" class="layout_btn02_1"/>			-->
	<button>검색하기</button>
	--%>
	</fieldset>
</form>
</div>
	<table class="tb_board">
		<caption>계약체결 현황의 번호, 계약기관, 계약번호, 계약방법구분, 계약명, 계약일자 목록표입니다.</caption>
		<colgroup>
		<col width="50" />
		<col width="120" />
		<col width="120" />
		<col width="80" />
		<col width="*" />
		<col width="80" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">계약기관</th>
				<th scope="col">계약번호</th>
				<th scope="col">계약방법구분</th>
				<th scope="col">계약명</th>
				<th scope="col" class="rfc_bbs_list_last">계약일자</th>
			</tr>
		</thead>
		<tbody>
<%

	String SrcDriver =  "jdbc:oracle:thin:@10.10.12.7:1521:GNEWEB";
	String SrcUser = "gnehomep";
	String SrcPass = "rudskarydbr10!";
	String SrcQuery = null;
	String SrcQuery2 = null;
	try {
		SrcConn = DriverManager.getConnection(SrcDriver, SrcUser, SrcPass);
	} catch(SQLException ex) {

	} finally {

	}


	StringBuffer sqlCount = new StringBuffer();
	sqlCount.append("SELECT COUNT(*) AS CNT \n");
	sqlCount.append("FROM RFC_CNTR_INFO_VIEW \n");
	sqlCount.append("WHERE FSCL_Y = ? \n");
	if (sdate != null && !sdate.equals("")) sqlCount.append("AND CNTR_DT >= TO_CHAR(TO_DATE(?,'YYYY-MM-DD'),'YYYYMMDD') \n");
	if (edate != null && !edate.equals("")) sqlCount.append("AND CNTR_DT <= TO_CHAR(TO_DATE(?,'YYYY-MM-DD'),'YYYYMMDD') \n");
	if (searchInst != null && !searchInst.equals("")) sqlCount.append("AND CNTR_INST_NM LIKE '%' || ? || '%' \n");
	if (keyword != null && !keyword.equals("")) sqlCount.append("AND "+searchType+" LIKE '%' || ? || '%' \n");
	pstmt2 = SrcConn.prepareStatement(sqlCount.toString());
	int listBinding2 = 0;
	pstmt2.setString(++listBinding2, searchYear);
	if (sdate != null && !sdate.equals("")) pstmt2.setString(++listBinding2, sdate);
	if (edate != null && !edate.equals("")) pstmt2.setString(++listBinding2, edate);
	if (searchInst != null && !searchInst.equals("")) pstmt2.setString(++listBinding2, searchInst);
	if (keyword != null && !keyword.equals("")) pstmt2.setString(++listBinding2, keyword);
	rs2 = pstmt2.executeQuery();
	int data_count = 0;
	if(rs2.next()){
		data_count = rs2.getInt(1);
	}else{f
		data_count = 0;
	}
	int numPerPage = 10; 		
	int start, end;
	start = ( (current_page-1) * numPerPage)+1;  //페이지의 첫번째 번호 구하기
	end = current_page * numPerPage;  //페이지의 첫번째 번호 구하기
	int total_page = (int) Math.ceil((double)data_count/numPerPage);
//	String listUrl= "/index.gne?menuCd="+menuCd+"&searchType="+searchType+"&keyword="+keyword;
	String listUrl= "/index.gne?menuCd="+menuCd+"&searchYear="+searchYear+"&sdate="+sdate+"&edate="+edate+"&searchInst="+searchInst+"&searchType="+searchType+"&keyword="+keyword;
	String pageIndexlist = this.pageIndexList2(current_page, total_page, listUrl);
	try{
		StringBuffer sqlList = new StringBuffer();
		sqlList.append("SELECT \n");
		sqlList.append("   ROWINDEX, CM_SEQ_NO, CNTR_NO, CNTR_INST_NM, CNTR_MTHD_DIV_NM, CNTR_NM, CNTR_DT, CNTR_INST_CD, FSCL_Y \n");
		sqlList.append("FROM ( \n");
		//sqlList.append("    SELECT /*+INDEX_DESC (A SYS_C00107393)*/ \n");
		sqlList.append("    SELECT  \n");
		sqlList.append("        ROW_NUMBER() OVER(ORDER BY FSCL_Y DESC, CNTR_DT DESC) AS ROWINDEX, \n");
		sqlList.append("        CM_SEQ_NO, CNTR_NO, CNTR_INST_NM, CNTR_MTHD_DIV_NM, CNTR_NM, CNTR_DT, CNTR_INST_CD, FSCL_Y \n");
		sqlList.append("    FROM RFC_CNTR_INFO_VIEW A \n");
		sqlList.append("    WHERE FSCL_Y = ? \n");
		if (sdate != null && !sdate.equals("")) sqlList.append("AND CNTR_DT >= TO_CHAR(TO_DATE(?,'YYYY-MM-DD'),'YYYYMMDD') \n");
		if (edate != null && !edate.equals("")) sqlList.append("AND CNTR_DT <= TO_CHAR(TO_DATE(?,'YYYY-MM-DD'),'YYYYMMDD') \n");
		if (searchInst != null && !searchInst.equals("")) sqlList.append("AND CNTR_INST_NM LIKE '%' || ? || '%' \n");
		if (keyword != null && !keyword.equals("")) sqlList.append(" AND "+searchType+" LIKE '%' || ? || '%' \n");
		sqlList.append(") B WHERE ROWINDEX BETWEEN ? AND ? \n");
		pstmt1 = SrcConn.prepareStatement(sqlList.toString());
		int listBinding = 0;
		pstmt1.setString(++listBinding, searchYear);
		if (sdate != null && !sdate.equals("")) pstmt1.setString(++listBinding, sdate);
		if (edate != null && !edate.equals("")) pstmt1.setString(++listBinding, edate);
		if (searchInst != null && !searchInst.equals("")) pstmt1.setString(++listBinding, searchInst);
		if (keyword != null && !keyword.equals("")) pstmt1.setString(++listBinding, keyword);
		pstmt1.setInt(++listBinding, start);
		pstmt1.setInt(++listBinding, end);
		rs = pstmt1.executeQuery();
                Date d = null;
				int i =0;
	while(rs.next()){
                    if(rs.getString("CNTR_DT") != null){
                        d = sdf.parse(rs.getString("CNTR_DT"));
                    }
      SimpleDateFormat sdf2= new SimpleDateFormat("yyyy-MM-dd");
	  int pa = data_count - ((current_page-1) * numPerPage) - i;
//	  String listUrl2= "/index.gne?mode=view&pageNum="+current_page+"&menuCd="+menuCd+"&num="+rs.getInt("CM_SEQ_NO")+"&searchType="+searchType+"&keyword="+keyword;
	  String listUrl2= "/index.gne?mode=view&pageNum="+current_page+"&menuCd="+menuCd+"&num="+rs.getInt("CM_SEQ_NO")+"&searchYear="+searchYear+"&sdate="+sdate+"&edate="+edate+"&searchInst="+searchInst+"&searchType="+searchType+"&keyword="+keyword;
 %>
	<tr>
		<td><%=pa%></td>
		<td><%=rs.getString("CNTR_INST_NM")%></td>
		<td><%=rs.getString("CNTR_NO")%></td>
		<td><%=rs.getString("CNTR_MTHD_DIV_NM")%></td>
		<td style="text-align: left; padding-left: 15px;"><a href="<%=listUrl2%>"><%=rs.getString("CNTR_NM")%></a></td>
		<td><%=rs.getString("CNTR_DT") == null ? "" : sdf2.format(d) %></td>
	</tr>

<%	i++;
}
%>


<%
	} catch(SQLException ex) { 
		out.println(ex);
	}finally {
		rs.close();
		rs2.close();
		pstmt1.close();
		pstmt2.close();
		SrcConn.close();
	}

%>	
<% if(data_count == 0){ %>
	<tr>
		<td colspan="6" height="100" align="center">등록된 계약체결현황이 없습니다.</td>
	</tr>
<% } %>
		</tbody>
	</table>

<div class="pageing"><p style="text-align:center;" id="btn_g"><%=pageIndexlist%></p></div>

</section>


<% }else{ 
	String SrcDriver =  "jdbc:oracle:thin:@10.10.12.7:1521:GNEWEB";
	String SrcUser = "gnehomep";
	String SrcPass = "rudskarydbr10!";
	String SrcQuery = null;
	String SrcQuery2 = null;
	try {
		SrcConn = DriverManager.getConnection(SrcDriver, SrcUser, SrcPass);
	} catch(SQLException ex) {

	} finally {

	}


	try {
		if(SrcConn != null){
			SrcStmt = SrcConn.createStatement();
			SrcStmt2 = SrcConn.createStatement();
		}
	} catch(SQLException ex) {

	} finally {

	}
	try{
		SrcQuery = "SELECT * from RFC_cntr_INFO_VIEW where CM_SEQ_NO = '"+num+"'";
		rs = SrcStmt.executeQuery(SrcQuery);
        Date d = null;
		Date d2 = null;
		Date d3 = null;
		Date d4 = null;
		Date d5 = null;
		String sub01 = "";
		String sub02 = "";
		String sub03 = "";
		String sub04 = "";
		String sub05 = "";
		String sub06 = "";
		String sub07 = "";
		String VOLUT_CNTR_REAS = "";
		String PREARR_AMT = "";
		if(rs.next()){
			VOLUT_CNTR_REAS = rs.getString("VOLUT_CNTR_REAS") == null ? "없음" : rs.getString("VOLUT_CNTR_REAS");
			PREARR_AMT = rs.getString("PREARR_AMT") == null || rs.getString("PREARR_AMT").equals("") || rs.getString("PREARR_AMT").equals("0") ? rs.getString("CNTR_AMT") : rs.getString("PREARR_AMT");
			if(rs.getString("CNTR_DT") != null){
				d = sdf.parse(rs.getString("CNTR_DT"));
            }
			if(rs.getString("CNTR_PERI_BEGIN_DT") != null){
				d2 = sdf.parse(rs.getString("CNTR_PERI_BEGIN_DT"));
            }
			if(rs.getString("CNTR_PERI_FIN_DT") != null){
				d3 = sdf.parse(rs.getString("CNTR_PERI_FIN_DT"));
            }
			SimpleDateFormat sdf2= new SimpleDateFormat("yyyy년 MM월 dd일");
			if(VOLUT_CNTR_REAS.equals("없음")){
%>
<section class="board">
<table class="tb_board">
<caption>계약명, 회계년도, 계약기관, 계약번호, 계약방법구분 등 계약체결 현황 상세보기표입니다.</caption>
<colgroup>
<col width="20%" />
<col width="30%" />
<col width="20%" />
<col width="30%" />
</colgroup>
<tr>
	<th scope="row" height="35" class="view_tb view_tr">계약명</th>
	<td colspan="3" class="view_tb"><%=rs.getString("CNTR_NM")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr">회계년도</th>
	<td class="view_tb view_tr"><%=rs.getString("FSCL_Y")%></td>
	<th scope="row" class="view_tb view_tr">계약기관</th>
	<td class="view_tb"><%=rs.getString("CNTR_INST_NM")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr">계약번호</th>
	<td class="view_tb view_tr"><%=rs.getString("CNTR_NO")%></td>
	<th scope="row" class="view_tb view_tr">계약방법구분</th>
	<td class="view_tb"><%=rs.getString("CNTR_MTHD_DIV_NM")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr">목적물구분</th>
	<td class="view_tb view_tr"><%=rs.getString("CNTR_PURP_OBJT_DIV_NM")%></td>
	<th scope="row" class="view_tb view_tr">계약일자</th>
	<td class="view_tb"><%=rs.getString("CNTR_DT") == null ? "" : sdf2.format(d) %></td>
</tr>
<tr>
	<th scope="row" height="35"  class="view_tb view_tr">계약기간시작일</th>
	<td class="view_tb view_tr"><%=rs.getString("CNTR_PERI_BEGIN_DT") == null ? "" : sdf2.format(d2) %></td>
	<th scope="row" class="view_tb view_tr">계약기간종료일자</th>
	<td class="view_tb"><%=rs.getString("CNTR_PERI_FIN_DT") == null ? "" : sdf2.format(d3) %></td>
</tr>
<tr>
	<th scope="row" height="35"  class="view_tb view_tr">계약금액</th>
	<td class="view_tb view_tr"><%=df.format(Long.parseLong(rs.getString("CNTR_AMT")))%></td>
	<th scope="row" class="view_tb view_tr">계약대상자명</th>
	<td class="view_tb"><%=rs.getString("CNTR_PRTNR_NM")%></td>
</tr>
<tr>
	<th scope="row" height="35"  class="view_tb view_tr">계약진행상태구분</th>
	<td class="view_tb view_tr" colspan="3"><%=rs.getString("CNTR_PRGS_STAT_DIV_NM")%></td>
</tr>
<%
			SrcQuery2 = "SELECT * from RFC_SUBCON_CNTR_INFO where CNTR_NO = '"+rs.getString("CNTR_NO")+"'";
			rs2 = SrcStmt2.executeQuery(SrcQuery2);
			while(rs2.next()){
				sub01 = rs2.getString("SUBCON_NM"); //하도급명
				sub02 = rs2.getString("SUBCON_AMT"); //하도금액
				sub02 = df.format(Long.parseLong(sub02));
				sub03 = rs2.getString("SUBCON_RATE"); //하도금율
				sub04 = rs2.getString("SUBCON_CNTR_DT"); //하도급계약일자
				if(sub04 != ""){
					d4 = sdf.parse(sub04);
				}
				sub05 = rs2.getString("DCLA_DT"); //신고일자
				if(sub05 != ""){
					d5 = sdf.parse(sub05);
				}
				sub06 = rs2.getString("CONST_CLSS_DIV_NM"); //공종
				sub07 = rs2.getString("SUBCON_TRXR_NM"); //상호
%>			

<tr>
	<th scope="row" height="35" class="view_tb view_tr">하도급명(<%=rs2.getString("SUBCON_CNTR_SEQ")%>차)</th>
	<td class="view_tb" colspan="3"><%=sub01%></td>
</tr>
<tr>
	<th scope="row" height="35"  class="view_tb view_tr">하도금액</th>
	<td class="view_tb view_tr"><%=sub02%></td>
	<th scope="row" class="view_tb view_tr">하도금율</th>
	<td class="view_tb"><%=sub03.replace(".","")%>%</td>
</tr>
<tr>
	<th scope="row" height="35"  class="view_tb view_tr">하도급계약일자</th>
	<td class="view_tb view_tr"><%=sub04 == "" ? "" : sdf2.format(d4)%></td>
	<th scope="row" class="view_tb view_tr">신고일자</th>
	<td class="view_tb"><%=sub05 == "" ? "" : sdf2.format(d5)%></td>
</tr>
<tr>
	<th scope="row" height="35"  class="view_tb view_tr">공종</th>
	<td class="view_tb view_tr"><%=sub06%></td>
	<th scope="row" class="view_tb view_tr">상호</th>
	<td class="view_tb"><%=sub07%></td>
</tr>
<%		} 
		rs2.close();%>
</table>
<div class="rfc_bbs_btn">
	<a href="/index.gne?menuCd=<%=menuCd%>&pageNum=<%=current_page%>&searchYear=<%=searchYear%>&sdate=<%=sdate%>&edate=<%=edate%>&searchInst=<%=searchInst%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><img src="/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_list.gif" alt="목록" /></a> 
</div>
</section>
<%		}else{ %>
<section class="board">
<table class="tb_board">
<caption>계약명, 계약개요, 계약대상자, 수의계약사유 등 계약체결 현황 상세보기표입니다.</caption>
<colgroup>
<col width="20%" />
<col width="16%" />
<col width="18%" />
<col width="15%" />
<col width="15%" />
<col width="16%" />
</colgroup>
<tr>
	<th scope="row" height="35" class="view_tb view_tr" align="center">계약명</th>
	<td colspan="5" class="view_tb"><%=rs.getString("CNTR_NM")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr" rowspan="2" align="center">계약개요</th>
	<th scope="col" height="35" class="view_tb view_tr" align="center">계약일자</th>
	<th scope="col" height="35" class="view_tb view_tr" align="center">계약기간</th>
	<th scope="col" height="35" class="view_tb view_tr" align="center">예정가격<br/>(추정금액)A</th>
	<th scope="col" height="35" class="view_tb view_tr" align="center">계약금액<br/>(B)</th>
	<th scope="col" height="35" class="view_tb" align="center">계약율(%)<br/>(B/A)</th>
</tr>
<tr>
	<td class="view_tb view_tr" align="center"><%=rs.getString("CNTR_DT") == null ? "" : sdf2.format(d) %></td>
	<td class="view_tb view_tr" align="center"><%=rs.getString("CNTR_PERI_BEGIN_DT") == null ? "" : sdf2.format(d2) %> ~ <br/><%=rs.getString("CNTR_PERI_FIN_DT") == null ? "" : sdf2.format(d3) %></td>
	<td class="view_tb view_tr" align="center"><%=df.format(Long.parseLong(rs.getString("PREARR_AMT")))%></td>
	<td class="view_tb view_tr" align="center"><%=df.format(Long.parseLong(rs.getString("CNTR_AMT")))%></td>
	<td class="view_tb" align="center"><%=Long.parseLong(rs.getString("CNTR_AMT")) / Long.parseLong(PREARR_AMT) * 100%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr" rowspan="2" align="center">계약대상자</th>
	<th scope="col" height="35" class="view_tb view_tr" align="center">업체명</th>
	<th scope="col" height="35" class="view_tb view_tr" align="center">대표자</th>
	<th scope="col" height="35" class="view_tb" colspan="3" align="center">주소</th>
</tr>
<tr>
	<td class="view_tb view_tr" height="35" align="center"><%=rs.getString("CNTR_PRTNR_NM") == null ? "" : rs.getString("CNTR_PRTNR_NM")%></td>
	<td class="view_tb view_tr" height="35" align="center"><%=rs.getString("REPRTIV_NM") == null ? "" : rs.getString("REPRTIV_NM")%></td>
	<td class="view_tb" colspan="3" height="35"><%=rs.getString("BASC_ADDR") == null ? "" : rs.getString("BASC_ADDR")%> <%=rs.getString("DETL_ADDR") == null ? "" : rs.getString("DETL_ADDR")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr" align="center">수의계약사유</th>
	<td colspan="5" class="view_tb"><%=rs.getString("VOLUT_CNTR_REAS_DIV_NM") == null ? "" : rs.getString("VOLUT_CNTR_REAS_DIV_NM")%><br/><%=rs.getString("VOLUT_CNTR_REAS") == null ? "" : rs.getString("VOLUT_CNTR_REAS")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr" align="center">사업장소</th>
	<td colspan="5" class="view_tb"><%=rs.getString("SITE_PLAC_NM") == null ? "" : rs.getString("SITE_PLAC_NM")%></td>
</tr>
<tr>
	<th scope="row" height="35" class="view_tb view_tr" align="center">기타</th>
	<td colspan="5" class="view_tb"><%=rs.getString("OTHR_PTCLR") == null ? "" : rs.getString("OTHR_PTCLR")%></td>
</tr>
</table>
<div class="rfc_bbs_btn">
	<a href="/index.gne?menuCd=<%=menuCd%>&pageNum=<%=current_page%>&searchYear=<%=searchYear%>&sdate=<%=sdate%>&edate=<%=edate%>&searchInst=<%=searchInst%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><img src="/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_list.gif" alt="목록" /></a> 
</div>
</section>
<%		}
		}
	} catch(SQLException ex) {
	out.println(ex);
	}finally {
		rs.close();
		SrcStmt.close();
		SrcStmt2.close();
	}


 } %>