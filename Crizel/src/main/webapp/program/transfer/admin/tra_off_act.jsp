<%@page import="com.ibatis.sqlmap.engine.mapping.statement.ExecuteListener"%>
<%@page import="org.json.simple.JSONObject"%>
<%
/**
*	PURPOSE	:	전입학 / 전입학 오프라인 등록 action jsp
*	CREATE	:	20180125_mon	JMG
*	MODIFY	:	....
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/transfer/admin/crypto.jsp" %>

<%!
public static double shortNum(double fixNum, double currNum, int type){
	double returnVal	=	0;
	if(type == 1){
		returnVal	=	fixNum - currNum;
	}else{
		returnVal	=	((fixNum * 5)/100)+(fixNum - currNum);
	}
return returnVal;
}
%>



<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

int chkResult   =   0;
int result 		= 	0;
int[] result2	=	null;

String outHtml  =   "";

String adminId		=	sessionManager.getId();
String adminIp		=	request.getRemoteAddr();
String adminNm		=	sessionManager.getName();
boolean adminChk	=	sessionManager.isRoleAdmin();


//파라미터
String transferNo			=	parseNull(request.getParameter("transferNo"));	//임시내용 삭제용 파라미터

String actType				=	parseNull(request.getParameter("actType"));
String transfer_special		=	parseNull(request.getParameter("transfer_special"));
String schname				=	parseNull(request.getParameter("schname"));
String stsdate				=	parseNull(request.getParameter("stsdate"));
String stedate				=	parseNull(request.getParameter("stedate"));
String gubun				=	parseNull(request.getParameter("gubun"));
String stgrade				=	parseNull(request.getParameter("stgrade"));
String stclass				=	parseNull(request.getParameter("stclass"));
String schtel				=	parseNull(request.getParameter("schtel"));
String schfax				=	parseNull(request.getParameter("schfax"));
String prezipcode			=	parseNull(request.getParameter("prezipcode"));
String preaddr				=	parseNull(request.getParameter("preaddr"));
String currzipcode			=	parseNull(request.getParameter("currzipcode"));
String curraddr				=	parseNull(request.getParameter("curraddr"));
String stname				=	parseNull(request.getParameter("stname"));
String stjumin				=	parseNull(request.getParameter("stjumin"));
String stsex				=	parseNull(request.getParameter("stsex"));
String fcode				=	parseNull(request.getParameter("fcode"));
String fname				=	parseNull(request.getParameter("fname"));
String fuseyn				=	parseNull(request.getParameter("fuseyn"));
String hopeschname1			=	parseNull(request.getParameter("hopeschname1"));
String hopeschname2			=	parseNull(request.getParameter("hopeschname2"));
String hopeschname3			=	parseNull(request.getParameter("hopeschname3"));
String hopeschno1			=	parseNull(request.getParameter("hopeschno1"));
String hopeschno2			=	parseNull(request.getParameter("hopeschno2"));
String hopeschno3			=	parseNull(request.getParameter("hopeschno3"));
String midschname			=	parseNull(request.getParameter("midschname"));
String midsch3class			=	parseNull(request.getParameter("midsch3class"));
String ptname				=	parseNull(request.getParameter("ptname"));
String ptjumin				=	parseNull(request.getParameter("ptjumin"));
String pttel				=	parseNull(request.getParameter("pttel"));
String pthp					=	parseNull(request.getParameter("pthp"));
String mgname				=	parseNull(request.getParameter("mgname"));
String mgtel				=	parseNull(request.getParameter("mgtel"));
String mgposition			=	parseNull(request.getParameter("mgposition"));
String mgduty				=	parseNull(request.getParameter("mgduty"));
String kind					=	parseNull(request.getParameter("kind"));
	
//랜덤
Random rand		=	new Random();
int min			=	1;
int max			=	0;
int randNum		=	0;

//계산
double fixNum			=	0;
double currNum			=	0;
double shortInNum		=	0;
double shortOutNum		=	0;

List<String> hopeSchNoList		=	new ArrayList<String>();
List<String> hopeSchNmList		=	new ArrayList<String>();
List<Map<String, Object>> hopeSchList	=	null;

if(!"".equals(hopeschno1)){
	hopeSchNoList.add(hopeschno1);
	hopeSchNmList.add(hopeschname1);
	max	=	max + 1;
}
if(!"".equals(hopeschno2)){
	hopeSchNoList.add(hopeschno2);
	hopeSchNmList.add(hopeschname2);
	max	=	max + 1;
}
if(!"".equals(hopeschno3)){
	hopeSchNoList.add(hopeschno3);
	hopeSchNmList.add(hopeschname3);
	max	=	max	+ 1;
}
if(hopeSchNoList.size()>0 && hopeSchNoList!=null){
	randNum			=	rand.nextInt((max-min) + 1) + min;
}

JSONObject	obj	=	new JSONObject();
if(!"".equals(stjumin)){
	stjumin 	= 	encrypt(stjumin);
}
if(!"".equals(ptjumin)){
	ptjumin		=	encrypt(ptjumin);
}

//임시저장 
if (actType.equals("temporary")) {
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    sql = new StringBuffer();
	    sql.append(" INSERT INTO TTRANSFER(TRANSFERNO, SPECIAL, STNAME, STJUMIN, STSEX, SCHNAME, 	");
	    sql.append(" PTNAME, PTJUMIN, PREZIPCODE, PREADDR, CURRZIPCODE, CURRADDR, PTTEL, PTHP, 		");
	    sql.append(" STSDATE, STEDATE, GUBUN, STGRADE, STCLASS, FCODE, FNAME, SCHTEL, SCHFAX, 		");
	    sql.append(" RECEIPTYEAR, RECEIPTNUM, MGNAME, MGPOSITION, MGTEL, MIDSCHNAME, MIDSCH3CLASS, 	");
	    sql.append(" FUSEYN, APPLYNAME, APPLYDATE, APPLYTIME, KIND, TEMPFLAG, MGDUTY )  								");
	    sql.append(" VALUES ((SELECT NVL(MAX(TRANSFERNO)+1, '1') FROM TTRANSFER), ?, ?, ?, ?, ?, ?, ");
	    sql.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYY'),		");
	    sql.append(" (SELECT NVL(MAX(RECEIPTNUM)+1, '1') FROM TTRANSFER WHERE RECEIPTYEAR = TO_CHAR(SYSDATE, 'YYYY')), ");
	    sql.append(" ?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?, 'Y', ?) 	 ");
	    
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transfer_special);
	    pstmt.setString(2, stname);
	    pstmt.setString(3, stjumin);
	    pstmt.setString(4, stsex);
	    pstmt.setString(5, schname);
	    pstmt.setString(6, ptname);
	    pstmt.setString(7, ptjumin);
	    pstmt.setString(8, prezipcode);
	    pstmt.setString(9, preaddr);
	    pstmt.setString(10, currzipcode);
	    pstmt.setString(11, curraddr);
	    pstmt.setString(12, pttel);
	    pstmt.setString(13, pthp);
	    pstmt.setString(14, stsdate);
	    pstmt.setString(15, stedate);
	    pstmt.setString(16, gubun);
	    pstmt.setString(17, stgrade);
	    pstmt.setString(18, stclass);
	    pstmt.setString(19, fcode);
	    pstmt.setString(20, fname);
	    pstmt.setString(21, schtel);
	    pstmt.setString(22, schfax);
	    pstmt.setString(23, mgname);
	    pstmt.setString(24, mgposition);
	    pstmt.setString(25, mgtel);
	    pstmt.setString(26, midschname);
	    pstmt.setString(27, midsch3class);
	    pstmt.setString(28, fuseyn);
	    pstmt.setString(29, adminId);
	    pstmt.setString(30, kind);
	    pstmt.setString(31, mgduty);
	    result	=	pstmt.executeUpdate();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql = new StringBuffer();
	    sql.append(" SELECT MAX(TRANSFERNO) AS TRANSFERNO FROM TTRANSFER	");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    rs		=	pstmt.executeQuery();
	    if(rs.next())		transferNo	=	rs.getString("TRANSFERNO");
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql	=	new StringBuffer();
	    sql.append(" INSERT INTO TTRANS_HOPESCH(TRANSFERNO, ORGNO, SCHNAME, ORDERED) ");
		sql.append(" VALUES(?, ?, ?, ?) ");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    for(int i=0; i<hopeSchNoList.size(); i++){
	    	pstmt.setString(1, transferNo);
	    	pstmt.setString(2, hopeSchNoList.get(i).toString());
	    	pstmt.setString(3, hopeSchNmList.get(i).toString());
	    	pstmt.setString(4, Integer.toString(i+1));
	    	pstmt.addBatch();
	    }
	    result2	=	pstmt.executeBatch();
		
	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	} finally {
	
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	
	    outHtml		=	"";
	    String outAlert	=	"";
	    if(result > 0){
	    	outHtml	+=	"<script>alert('임시저장되었습니다.');";
	    	outHtml	+=	"location.href='/program/transfer/admin/tra_req_list.jsp';</script>";
	    	out.print(outHtml);
	    }else{
	    	outHtml	+=	"<script>alert('임시저장에 실패했습니다.');";
	    	outHtml	+=	"history.back();</script>";
	    	out.print(outHtml);
	    }
	   
	}
} else if("tempDel".equals(actType)){
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    sql = new StringBuffer();
	    sql.append(" DELETE TTRANS_HOPESCH WHERE TRANSFERNO = ? ");
	    
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    pstmt.executeUpdate();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql = new StringBuffer();
	    sql.append(" DELETE TTRANSFER WHERE TRANSFERNO = ? AND TEMPFLAG = 'Y' ");
	    
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    result	=	pstmt.executeUpdate();
	    
	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	} finally {
	
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	
	    outHtml	=	"";
	    if(result > 0){
	    	
	    }else{
	    	outHtml	+=	"<script>alert('임시저장 삭제에 실패했습니다.');";
	    	outHtml	+=	"history.back();</script>";
	    	out.print(outHtml);
	    }
	}
} else if("tempCall".equals(actType)) {
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();

	    sql = new StringBuffer();
	    sql.append(" SELECT TRANSFERNO, SPECIAL, STNAME, STJUMIN, STSEX, SCHNAME, PTNAME, PTJUMIN, 	");
	    sql.append(" PREZIPCODE, PREADDR, CURRZIPCODE, CURRADDR, PTTEL, PTHP, STSDATE,				");
	    sql.append(" STEDATE, GUBUN, STGRADE, STCLASS, FCODE, FNAME, SCHTEL, SCHFAX, MGNAME, 		");
	    sql.append(" MGPOSITION, MGDUTY, MGTEL, MIDSCHNAME, MIDSCH3CLASS, FUSEYN, KIND 				");
	    sql.append(" FROM TTRANSFER WHERE TEMPFLAG = 'Y' AND TRANSFERNO = ? AND ROWNUM = 1 			");	
	    
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    rs		=	pstmt.executeQuery();
	    if(rs.next()){
	    	obj.put("transfer_special", parseNull(rs.getString("SPECIAL")));
	    	obj.put("stname", parseNull(rs.getString("STNAME")));
	    	obj.put("stjumin", decrypt(parseNull(rs.getString("STJUMIN"))));
	    	obj.put("stsex", parseNull(rs.getString("STSEX")));
	    	obj.put("schname", parseNull(rs.getString("SCHNAME")));
	    	obj.put("ptname", parseNull(rs.getString("PTNAME")));
	    	obj.put("ptjumin", decrypt(parseNull(rs.getString("PTJUMIN"))));
	    	obj.put("prezipcode", parseNull(rs.getString("PREZIPCODE")));
	    	obj.put("preaddr", parseNull(rs.getString("PREADDR")));
	    	obj.put("currzipcode", parseNull(rs.getString("CURRZIPCODE")));
	    	obj.put("curraddr", parseNull(rs.getString("CURRADDR")));
	    	obj.put("pttel", parseNull(rs.getString("PTTEL")));
	    	obj.put("pthp", parseNull(rs.getString("PTHP")));
	    	obj.put("stsdate", parseNull(rs.getString("STSDATE")));
	    	obj.put("stedate", parseNull(rs.getString("STEDATE")));
	    	obj.put("gubun", parseNull(rs.getString("GUBUN")));
	    	obj.put("stgrade", parseNull(rs.getString("STGRADE")));
	    	obj.put("stclass", parseNull(rs.getString("STCLASS")));
	    	obj.put("fcode", parseNull(rs.getString("FCODE")));
	    	obj.put("fname", parseNull(rs.getString("FNAME")));
	    	obj.put("schtel", parseNull(rs.getString("SCHTEL")));
	    	obj.put("schfax", parseNull(rs.getString("SCHFAX")));
	    	obj.put("mgname", parseNull(rs.getString("MGNAME")));
	    	obj.put("mgposition", parseNull(rs.getString("MGPOSITION")));
	    	obj.put("mgduty", parseNull(rs.getString("MGDUTY")));
	    	obj.put("mgtel", parseNull(rs.getString("MGTEL")));
	    	obj.put("midschname", parseNull(rs.getString("MIDSCHNAME")));
	    	obj.put("midsch3class", parseNull(rs.getString("MIDSCH3CLASS")));
	    	obj.put("fuseyn", parseNull(rs.getString("FUSEYN")));
	    	obj.put("kind", parseNull(rs.getString("KIND")));
	    	obj.put("stsex", parseNull(rs.getString("STSEX")));
	    	chkResult	=	1;
	    }	   
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql = new StringBuffer();
	    sql.append(" SELECT TRANSFERNO, ORGNO, SCHNAME, ORDERED FROM TTRANS_HOPESCH WHERE TRANSFERNO = ? ORDER BY ORDERED ");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    rs		=	pstmt.executeQuery();
	    hopeSchList	=	getResultMapRows(rs);
	    
	    if(hopeSchList != null && hopeSchList.size()>0){
		    for(int i=1; i<=hopeSchList.size(); i++){
		    	Map<String, Object> map	=	hopeSchList.get(i-1);
		    	obj.put("hopeschname"+i, parseNull((String)map.get("SCHNAME")));
		    	obj.put("hopeschno"+i, parseNull((String)map.get("ORGNO")));
		    }	   
	    }
	    
	    sql = new StringBuffer();
	    sql.append(" DELETE TTRANS_HOPESCH WHERE TRANSFERNO = ? ");
	    
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    pstmt.executeUpdate();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}	    
	    
	    sql = new StringBuffer();
	    sql.append(" DELETE TTRANSFER WHERE TRANSFERNO = ? 	");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    result	=	pstmt.executeUpdate();
	    
	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	} finally {
		
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	
	    String outAlert	=	"";
	    outHtml	=	"";
	    if(chkResult > 0){
	    	if(result > 0){
	    		response.setContentType("application/x-json;");
		    	out.print(obj);
	    	}else{
	    		outHtml	=	"<script>alert('임시내용을 삭제하는데에 실패했습니다.');";
	    		outHtml	+=	"history.back();</script>";
	    		
	    	}
	    }else{
	    	outAlert = "임시내용을 불러오는데에 실패했습니다. \n";
	    	if(result > 0){
	    		
	    	}else{
	    		outAlert	+=	"임시내용을 삭제하는데에 실패했습니다. \n";	
	    	}
	    	outHtml	=	"<script> alert('";
	    	outHtml +=	outAlert;
	    	outHtml	+=	"'); history.back();</script>";
	    	out.print(outHtml);
	    }
	}
} else if("insert".equals(actType)){
	try{
		sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    sql = new StringBuffer();
	    sql.append(" INSERT INTO TTRANSFER(TRANSFERNO, SPECIAL, STNAME, STJUMIN, STSEX, SCHNAME, 	");
	    sql.append(" PTNAME, PTJUMIN, PREZIPCODE, PREADDR, CURRZIPCODE, CURRADDR, PTTEL, PTHP, 		");
	    sql.append(" STSDATE, STEDATE, GUBUN, STGRADE, STCLASS, FCODE, FNAME, SCHTEL, SCHFAX, 		");
	    sql.append(" RECEIPTYEAR, RECEIPTNUM, MGNAME, MGPOSITION, MGTEL, MIDSCHNAME, MIDSCH3CLASS, 	");
	    sql.append(" FUSEYN, TRSCHNO, TRSCHNAME, APPLYNAME, APPLYDATE, APPLYTIME, KIND, TEMPFLAG, MGDUTY )  ");
	    sql.append(" VALUES ((SELECT NVL(MAX(TRANSFERNO)+1, '1') FROM TTRANSFER), ?, ?, ?, ?, ?, ?, ");
	    sql.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYY'),		");
	    sql.append(" (SELECT NVL(MAX(RECEIPTNUM)+1, '1') FROM TTRANSFER WHERE RECEIPTYEAR = TO_CHAR(SYSDATE, 'YYYY')), ");
	    sql.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?, 'N', ?) 	 ");
	    
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transfer_special);
	    pstmt.setString(2, stname);
	    pstmt.setString(3, stjumin);
	    pstmt.setString(4, stsex);
	    pstmt.setString(5, schname);
	    pstmt.setString(6, ptname);
	    pstmt.setString(7, ptjumin);
	    pstmt.setString(8, prezipcode);
	    pstmt.setString(9, preaddr);
	    pstmt.setString(10, currzipcode);
	    pstmt.setString(11, curraddr);
	    pstmt.setString(12, pttel);
	    pstmt.setString(13, pthp);
	    pstmt.setString(14, stsdate);
	    pstmt.setString(15, stedate);
	    pstmt.setString(16, gubun);
	    pstmt.setString(17, stgrade);
	    pstmt.setString(18, stclass);
	    pstmt.setString(19, fcode);
	    pstmt.setString(20, fname);
	    pstmt.setString(21, schtel);
	    pstmt.setString(22, schfax);
	    pstmt.setString(23, mgname);
	    pstmt.setString(24, mgposition);
	    pstmt.setString(25, mgtel);
	    pstmt.setString(26, midschname);
	    pstmt.setString(27, midsch3class);
	    pstmt.setString(28, fuseyn);
	    pstmt.setString(29, hopeSchNoList.get(randNum-1));
	    pstmt.setString(30, hopeSchNmList.get(randNum-1));
	    pstmt.setString(31, adminNm);
	    pstmt.setString(32, kind);
	    pstmt.setString(33, mgduty);
	    result	=	pstmt.executeUpdate();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql = new StringBuffer();
	    sql.append(" SELECT MAX(TRANSFERNO) AS TRANSFERNO FROM TTRANSFER	");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    rs		=	pstmt.executeQuery();
	    if(rs.next())		transferNo	=	rs.getString("TRANSFERNO");
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql	=	new StringBuffer();
	    sql.append(" INSERT INTO TTRANS_HOPESCH(TRANSFERNO, ORGNO, SCHNAME, ORDERED) ");
		sql.append(" VALUES(?, ?, ?, ?) ");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    for(int i=0; i<hopeSchNoList.size(); i++){
	    	pstmt.setString(1, transferNo);
	    	pstmt.setString(2, hopeSchNoList.get(i).toString());
	    	pstmt.setString(3, hopeSchNmList.get(i).toString());
	    	pstmt.setString(4, Integer.toString(i+1));
	    	pstmt.addBatch();
	    }
	    result2	=	pstmt.executeBatch();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

	    
	    sql = new StringBuffer();
	    sql.append(" INSERT INTO TTRANS_STATE (TRANSFERNO, STATECD, REGDATE, REGTIME, REGIP, NAME, ORDERED)		");
	    sql.append(" VALUES (?, 'TR_L_APPROVAL', TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), 	");
	    sql.append(" ?, ?, '1')	");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    pstmt.setString(2, adminIp);
	    pstmt.setString(3, adminNm);
	    pstmt.executeUpdate();
	    
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	  	sql	= new StringBuffer();
	  	sql.append(" SELECT FIXNUM, CURRNUM, SHORTINNUM, SHORTOUTNUM FROM TORG_NUM_PERSON ");
	  	sql.append(" WHERE ORGNO = ? AND GRADE = ?  ");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, hopeSchNoList.get(randNum-1));
	    pstmt.setString(2, stgrade);
	    rs	=	pstmt.executeQuery();
	    if(rs.next()){
	    	fixNum		=	rs.getDouble("FIXNUM");
	    	currNum		=	rs.getDouble("CURRNUM");
	    }
	    
	    sql = new StringBuffer();
	    sql.append(" UPDATE TORG_NUM_PERSON SET CURRNUM = CURRNUM+1, SHORTINNUM = ?, SHORTOUTNUM = ? ");
	    sql.append(" WHERE ORGNO = ? AND GRADE = ? ");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setInt(1, (int)shortNum(fixNum, currNum+1, 1));
	    pstmt.setInt(2, (int)shortNum(fixNum, currNum+1, 2));
	    pstmt.setString(3, hopeSchNoList.get(randNum-1));
	    pstmt.setString(4, stgrade);
	  	pstmt.executeUpdate();
	    
	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()+""); 
	} finally {
	
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	
	    outHtml		=	"";
	    String outAlert	=	"";
	    if(result > 0){
	    	outHtml	+=	"<script>alert('등록되었습니다.');";
	    	outHtml	+=	"alert('추첨결과 : " + hopeSchNmList.get(randNum-1) + "');";
	    	outHtml	+=	"location.href='/program/transfer/admin/tra_req_list.jsp';</script>";
	    	out.print(outHtml);
	    }else{
	    	outHtml	+=	"<script>alert('등록에 실패했습니다.');";
	    	outHtml	+=	"history.back();</script>";
	    	out.print(outHtml);
	    }
	   
	}
} else{
    out.println("<script>");
    out.println("alert('파라미터 값 이상입니다. 관리자에게 문의하세요.');");
    out.println("history.back();");
    out.println("</script>");
}
%>
