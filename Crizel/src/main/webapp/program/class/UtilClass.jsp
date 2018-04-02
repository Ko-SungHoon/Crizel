<%@page import="org.springframework.context.support.FileSystemXmlApplicationContext"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%
/**
* @author LEE HYUNSOO
* @version 1.0
* @created 2016.06.21
*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@page import="java.text.DecimalFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Random"%>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.ProgressListener" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="com.ibatis.sqlmap.client.SqlMapClient" %>
<%@page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@page import="javax.sql.DataSource" %>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="org.springframework.context.ApplicationContext" %>
<%@page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@page import="org.springframework.context.support.FileSystemXmlApplicationContext" %>
<%!
public static String XSSFilter(String str) {
	str = str.replaceAll("eval\\((.*)\\)", "");
	str = str.replaceAll("[\\\"\\'][\\s]*javascript:(.*)[\\\"\\']", "\"\"");
	str = str.replaceAll("[\\\"\\'][\\s]*vbscript:(.*)[\\\"\\']", "\"\"");
	str = str.replaceAll("document.cookie", "&#100;&#111;&#99;&#117;&#109;&#101;&#110;&#116;&#46;&#99;&#111;&#111;&#107;&#105;&#101;");
	str = str.replaceAll("<script", "&lt;script");
	str = str.replaceAll("script>", "script&gt;");
	str = str.replaceAll("<iframe", "&lt;iframe");
	str = str.replaceAll("<object", "&lt;object");
	str = str.replaceAll("<embed", "&lt;embed"); 
	str = str.replaceAll("onload", "no_onload");
	str = str.replaceAll("expression", "no_expression");
	str = str.replaceAll("onmouseover", "no_onmouseover");
	str = str.replaceAll("onmouseout", "no_onmouseout");
	str = str.replaceAll("onclick", "no_onclick");
	return str;
}

/** Null Pointer Exception#1 **/
public static String parseNull(String strText) throws Exception {
	String rtnVal = "";
	try {
		if (strText != null) rtnVal = strText;
	} catch (Exception e) {
		return rtnVal;
	}
	return XSSFilter(rtnVal);
}
/** Null Pointer Exception#2 **/
public static String parseNull(String strText, String defText) throws Exception {
	String rtnVal = "";
	try {
		if (parseNull(strText).equals("")) rtnVal = defText;
		else rtnVal = strText;
	} catch (Exception e) {
		return rtnVal;
	}
	return XSSFilter(rtnVal);
}

public static String parseNull(String[] strTexts, String delimeter) throws Exception {
	String rtnVal = "";
	try {
		for(int i=0; i<strTexts.length; i++) {
			if(!"".equals(rtnVal)) rtnVal += "|";
			rtnVal += strTexts[i];
		}
	} catch (Exception e) {
		return rtnVal;
	}
	return rtnVal;
}
public static String parseNull(String[] strTexts) throws Exception {
	return parseNull(strTexts, "|");
}
/** 현재 날짜 및 시간 구하기#1 **/
public static String getDate() {
	return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA).format(Calendar.getInstance().getTime());
}

/** 현재 날짜 및 시간 구하기#2 **/
public static String getDate(String dateType) {
	return new SimpleDateFormat(dateType, Locale.KOREA).format(Calendar.getInstance().getTime());
}

/** 파일 확장자 체크 **/
public static boolean doCheckFileExt(String fileName, String[] availableExt) throws Exception {
	boolean rtnFlag = false;
	String fileExt = fileName.substring(fileName.lastIndexOf('.') + 1, fileName.length());
	for (int i = 0; i < availableExt.length; i++) {
		if (fileExt.toLowerCase().equals(availableExt[i])) {
			rtnFlag =  true;
			break;
		}
	}
	return rtnFlag;
}
/** 접근 가능한 IP 체크 **/
public static boolean isAllowIp(String thisIp, String[] allowIp) {
	boolean flag = false;
	for (int i = 0; i < allowIp.length; i++) {
		if (thisIp.equals(allowIp[i])) {
			flag = true;
			break;
		}
	}
	return flag;
}
/** return ResultSet **/
public static List<Map<String, Object>> getResultMapRows(ResultSet rs) throws Exception {
	/** ResultSet의  MetaData를 가져온다. **/
	ResultSetMetaData metaData = rs.getMetaData();
	/** ResultSet의 Column의 갯수를 가져온다. **/
	int sizeOfColumn = metaData.getColumnCount();
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	Map<String, Object> map = null;
	String column = "";
	/** rs의 내용을 돌려준다 **/
	while (rs.next()) {
		/** 내부에서 map을 초기화 **/
		map = new HashMap<String, Object>();
		/** Column의 갯수만큼 회전 **/
		for (int indexOfcolumn = 0; indexOfcolumn < sizeOfColumn; indexOfcolumn++){
			column = metaData.getColumnName(indexOfcolumn + 1);
			/** map에 값을 입력 map.put(columnName, columnName으로 getString) **/
			map.put(column, parseNull(rs.getString(column)));
		}
		/** list에 저장 **/
		list.add(map);
	}
	return list;
}
public static Map<String, Object> getResultMapRow(ResultSet rs) throws Exception {
	/** ResultSet의  MetaData를 가져온다. **/
	ResultSetMetaData metaData = rs.getMetaData();
	/** ResultSet의 Column의 갯수를 가져온다. **/
	int sizeOfColumn = metaData.getColumnCount();
	Map<String, Object> map = null;
	String column = "";
	/** rs의 내용을 돌려준다 **/
	while (rs.next()) {
		/** 내부에서 map을 초기화 **/
		map = new HashMap<String, Object>();
		/** Column의 갯수만큼 회전 **/
		for (int indexOfcolumn = 0; indexOfcolumn < sizeOfColumn; indexOfcolumn++){
			column = metaData.getColumnName(indexOfcolumn + 1);
			/** map에 값을 입력 map.put(columnName, columnName으로 getString) **/
			map.put(column, parseNull(rs.getString(column)));
		}
	}
	return map;
}
public static void alertClose(JspWriter out, String message) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		out.println("window.opener='nothing';window.open('','_parent','');window.close();");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void alertBack(JspWriter out, String message) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		out.println("history.go(-1);");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void alertBack(JspWriter out, String message, String go_num) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		out.println("history.go("+go_num+");");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void alert(JspWriter out, String message) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void alertUrl(JspWriter out, String message, String url) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		if(url != null && !"".equals(url)) out.println("location.href='"+url+"';");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void parentReload(JspWriter out) {
	try {
		out.println("<script type=\"text/javascript\">");
		out.println("if(parent.opener != undefined) {parent.opener.location.reload();} \n");
		out.println("else if(parent != undefined) {parent.location.reload();} \n");
		out.println("else {window.opener.location.reload();} \n");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void parentClose(JspWriter out) {
	try {
		out.println("<script type=\"text/javascript\">");
		out.println("parent.close();");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void goUrl(JspWriter out, String url) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(url != null && !"".equals(url)) out.println("location.href='"+url+"';");
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void goParentUrl(JspWriter out, String url) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(url != null && !"".equals(url)) {
			out.println("if(parent.opener != undefined) {parent.opener.location.href='"+url+"';} \n");
			out.println("else if(parent != undefined) {parent.location.href='"+url+"';} \n");
			out.println("else {window.opener.location.href='"+url+"';} \n");
		}
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static void alertParentUrl(JspWriter out, String message, String url) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		if(url != null && !"".equals(url)) {
			out.println("if(parent.opener != undefined) {parent.opener.location.href='"+url+"';} \n");
			out.println("else if(parent != undefined) {parent.location.href='"+url+"';} \n");
			out.println("else {window.opener.location.href='"+url+"';} \n");
		}
		out.println("</script>");
	} catch(Exception e) {
	}
}
public static boolean compare(String value1, String value2) {
	if(value1 != null && !"".equals(value1) && value1.equals(value2)) return true;
	return false;
}
public static String selected(String value1, String value2) {
	return (compare(value1, value2)) ? " selected=\"selected\"" : "";
}
public static String checked(String value1, String value2) {
	return (compare(value1, value2)) ? " checked=\"checked\"" : "";
}
public static String checked_idx(String value1, String value2) {
	return (value2.indexOf(value1) > -1) ? " checked=\"checked\"" : "";
}
public static String readonly(String value1, String value2) {
	return (compare(value1, value2)) ? " readonly=\"readonly\"" : "";
}
public static String randomCode(int cnt, String type) {
	StringBuffer strPwd = null;
	boolean chk = false;
	//char[] charaters = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9'};
	char[] charaters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','#','$','%','^','&','*'};
	Random rn = null;

	do {
		strPwd = new StringBuffer();
		rn = new Random();
		for( int i = 0 ; i < cnt ; i++ ){
			strPwd.append( charaters[ rn.nextInt( charaters.length ) ] );
		}
		if(strPwd.toString().indexOf('#') > -1 || strPwd.toString().indexOf('$') > -1 || strPwd.toString().indexOf('%') > -1
			|| strPwd.toString().indexOf('^') > -1 || strPwd.toString().indexOf('&') > -1 || strPwd.toString().indexOf('*') > -1) {
			chk = true;
		}
	} while(!chk);
	/*
	char str[] = new char[1];
	int strs[] = new int[1];
	for (int j = 0; j < cnt; j++) {
		if (type.equals("P")) {
			// 특수기호 포함
			str[0] = (char) ((Math.random() * 94) + 33);
			strPwd.append(str);
		} else if (type.equals("A")) {
			// 대문자
			str[0] = (char) ((Math.random() * 26) + 65);
			strPwd.append(str);
		} else if (type.equals("S")) {
			// 소문자
			str[0] = (char) ((Math.random() * 26) + 97);
			strPwd.append(str);
		} else if (type.equals("I")) {
			// 숫자형
			strs[0] = (int) (Math.random() * 9);
			strPwd.append(strs[0]);
		} else if (type.equals("C")) {
			// 소문자,숫자형
			Random rnd = new Random();
			if (rnd.nextBoolean()) {
				strPwd.append((char) ((int) (rnd.nextInt(26)) + 97));
			} else {
				strPwd.append((rnd.nextInt(10)));
			}
		}
	}*/
	return strPwd.toString();
}
public static String randomCode(int cnt) {
	return randomCode(cnt, "P");
}
public static String randomCode() {
	return randomCode(8);
}
public static String newCode(int strLen, String prefixStr) {
	return prefixStr + newCode(strLen);
}
public static String newCode(int strLen) {
	return (randomCode(strLen)).toUpperCase() + (System.currentTimeMillis());
}
public static String newCode() {
	return newCode(2);
}
public static int getArrayIndex(String value, String[] array)
{
	int index = 0;
	for(int i=0; i<array.length; i++) {
		if(value.equals(array[i])) {
			index = i;
			break;
		}
	}
	return index;
}
// 현재가 특정 일자 이전(이하)인지 체크 (현재==특정일자 true)
public static boolean isNowBefore(String checkDate)
{
	if(checkDate == null) return false;
	checkDate = checkDate.replaceAll("[^0-9]", "");
	if(checkDate.length() == 8) {
		String strYear = checkDate.substring(0, 4);
		String strMonth = checkDate.substring(4, 6);
		String strDay = checkDate.substring(6, 8);
		int year = Integer.parseInt(strYear);
		int month = Integer.parseInt(strMonth);
		int day = Integer.parseInt(strDay);
		month--;
		Calendar aDate = Calendar.getInstance();
		aDate.set(year, month, day);
		aDate.set( Calendar.HOUR_OF_DAY, 0 );
		aDate.set( Calendar.MINUTE, 0 );
		aDate.set( Calendar.SECOND, 0 );
		aDate.set( Calendar.MILLISECOND, 0 );
		//aDate.add(Calendar.DATE, 1);
		Calendar sDate = Calendar.getInstance();
		sDate.set( Calendar.HOUR_OF_DAY, 0 );
		sDate.set( Calendar.MINUTE, 1 );
		sDate.set( Calendar.SECOND, 0 );
		sDate.set( Calendar.MILLISECOND, 0 );
		if (sDate.before(aDate)) {
			return true;
		}
	}
	return false;
}
// 현재가 특정 일자 이후(이상)인지 체크 (현재==특정일자 true)
public static boolean isNowAfter(String checkDate)
{
	if(checkDate == null) return false;
	checkDate = checkDate.replaceAll("[^0-9]", "");
	if(checkDate.length() == 8) {
		String strYear = checkDate.substring(0, 4);
		String strMonth = checkDate.substring(4, 6);
		String strDay = checkDate.substring(6, 8);
		int year = Integer.parseInt(strYear);
		int month = Integer.parseInt(strMonth);
		int day = Integer.parseInt(strDay);
		month--;
		Calendar aDate = Calendar.getInstance();
		aDate.set(year, month, day);
		aDate.set( Calendar.HOUR_OF_DAY, 0 );
		aDate.set( Calendar.MINUTE, 1 );
		aDate.set( Calendar.SECOND, 0 );
		aDate.set( Calendar.MILLISECOND, 0 );
		//aDate.add(Calendar.DATE, -1);
		Calendar sDate = Calendar.getInstance();
		sDate.set( Calendar.HOUR_OF_DAY, 0 );
		sDate.set( Calendar.MINUTE, 0 );
		sDate.set( Calendar.SECOND, 0 );
		sDate.set( Calendar.MILLISECOND, 0 );
		if (sDate.after(aDate)) {
			return true;
		}
	}
	return false;
}
public static String nl2br(String str) {
	if(str != null && !"".equals(str)) {
		str = str.replaceAll("\r\n", "<br>");
		str = str.replaceAll("\r", "<br>");
		str = str.replaceAll("\n", "<br>");
	} else {
		str = "";
	}
	return str;
}
// 문자열 좌측에 지정 자리수만큰 0 채우기
public static String str_pad(int num, int strlen) {
	StringBuffer fm = new StringBuffer();
	fm.append("%0");
	fm.append(Integer.toString(strlen));
	fm.append("d");
	String str = String.format(fm.toString(), num);
	return str;
}
/**
함수 사용은
strCut(대상문자열, 시작위치로할키워드, 자를길이, 키워드위치에서얼마나이전길이만큼포함할것인가, 태그를없앨것인가, 긴문자일경우"..."을추가할것인가)
처럼 하시면 되겠습니다.

[예]
"가나다라" 에서 2바이트까지 자르고 싶을경우 strCut("가나다라", null, 2, 0, true, true); 처럼 하시면 됩니다.
=> 결과 : "가"
"가나다라" 에서 "다"라는 키워드 기준에서 2바이트까지 자르고싶을경우 strCut("가나다라", "다", 2, 0, true, true); 처럼 하시면 됩니다.
=> 결과 : "다"
"가나다라" 에서 "라"라는 키워드 기준으로 그 이전의 4바이트까지 포함하여 6바이트까지 자르고 싶을 경우 strCut("가나다라", "라", 6, 4, true, true); 처럼 하시면 됩니다.
=> 결과 : "나다라"
"가나다라" 에서 3바이트를 자를 경우
=> 결과 : "가"
"가a나다라" 에서 3바이트를 자를 경우
=> 결과 : "가a"
"가나다라" 에서 "나" 키워드 기준으로 이전 1바이트 포함하여 4바이트까지 자를 경우
=> 결과 : "나"
*/
public String strCut(String szText, String szKey, int nLength, int nPrev, boolean isNotag, boolean isAdddot){  // 문자열 자르기
		String r_val = szText;
		int oF = 0, oL = 0, rF = 0, rL = 0;
		int nLengthPrev = 0;
		Pattern p = Pattern.compile("<(/?)([^<>]*)?>", Pattern.CASE_INSENSITIVE);  // 태그제거 패턴
		if(isNotag) {r_val = p.matcher(r_val).replaceAll("");}  // 태그 제거
		r_val = r_val.replaceAll("&amp;", "&");
		r_val = r_val.replaceAll("(!/|\r|\n|&nbsp;)", "");  // 공백제거
		try {
			byte[] bytes = r_val.getBytes("UTF-8");     // 바이트로 보관
			if(szKey != null && !szKey.equals("")) {
				nLengthPrev = (r_val.indexOf(szKey) == -1)? 0: r_val.indexOf(szKey);  // 일단 위치찾고
				nLengthPrev = r_val.substring(0, nLengthPrev).getBytes("MS949").length;  // 위치까지길이를 byte로 다시 구한다
				nLengthPrev = (nLengthPrev-nPrev >= 0)? nLengthPrev-nPrev:0;    // 좀 앞부분부터 가져오도록한다.
			}
			// x부터 y길이만큼 잘라낸다. 한글안깨지게.
			int j = 0;
			if(nLengthPrev > 0) while(j < bytes.length) {
				if((bytes[j] & 0x80) != 0) {
					oF+=2; rF+=3; if(oF+2 > nLengthPrev) {break;} j+=3;
				} else {if(oF+1 > nLengthPrev) {break;} ++oF; ++rF; ++j;}
			}
			j = rF;
			while(j < bytes.length) {
				if((bytes[j] & 0x80) != 0) {
					if(oL+2 > nLength) {break;} oL+=2; rL+=3; j+=3;
				} else {if(oL+1 > nLength) {break;} ++oL; ++rL; ++j;}
			}
			r_val = new String(bytes, rF, rL, "UTF-8");  // charset 옵션
			if(isAdddot && rF+rL+3 <= bytes.length) {r_val+="...";}  // ...을 붙일지말지 옵션
		} catch(UnsupportedEncodingException e){ e.printStackTrace(); }
		return r_val;
}
public String getRoleId(SqlMapClient sqlMapClient, Connection conn, String id)
{
	String roleId = null;
	if(id == null || "".equals(id)) return roleId;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try{
		StringBuffer query = new StringBuffer();
		query.append("SELECT ROLE_ID FROM RFC_COMTNAUTHORITES WHERE SUBJECT_ID = ?");
		pstmt = conn.prepareStatement(query.toString());
		pstmt.setString(1, id);
		rs = pstmt.executeQuery();
		if(rs.next()) roleId = rs.getString("ROLE_ID");
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	}
	return roleId;
}
public String[] getAllowIpArrays(SqlMapClient sqlMapClient, Connection conn)
{
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer result = new StringBuffer();
	try{
		StringBuffer query = new StringBuffer();
		query.append("SELECT ACCESS_IP FROM RFC_COMTNACCESSIP WHERE ATYPE = 'admin' ");
		pstmt = conn.prepareStatement(query.toString());
		rs = pstmt.executeQuery();
		while(rs.next()) {
			if(result.length() > 1) result.append("|");
			result.append(rs.getString("ACCESS_IP"));
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	}
	return (result.toString()).split("\\|");
}
%>

<%!
public String timeSet(String value){
	value = value==null?"":value;
	if(!"".equals(value)){
		String val = value.substring(0,2);
		String val2 = value.substring(2,4);
		value = val + ":" + val2;
	}
	return value;
}
%>
<%!
public String moneySet(String value){
	value = value==null?"":value;
	String price = "";
	DecimalFormat df = new DecimalFormat("#,###");
	if(!"".equals(value) && value !=null){
		price = df.format(Integer.parseInt(value));
	}else{
		price = "0";
	}
	return price;
}
%>
<%!
public String telSet(String value){
	value = value==null?"":value;
	String val = "";
	String val2 = "";
	String val3 = "";
	if(value.length() == 11){
		val = value.substring(0,3);
		val2 = value.substring(3,7);
		val3 = value.substring(7,11);
		value = val + "-" + val2 + "-" + val3;
	}else if(value.length() == 10){
		val = value.substring(0,3);
		val2 = value.substring(3,6);
		val3 = value.substring(6,10);
		value = val + "-" + val2 + "-" + val3;
	}else if(value.length() == 7){
		val = value.substring(0,3);
		val2 = value.substring(3,7);
		value = val + "-" + val2;
	}else if(value.length() == 8){
		val = value.substring(0,4);
		val2 = value.substring(4,8);
		value = val + "-" + val2;
	}
	return value;
}
%>
<%
//WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
ApplicationContext context = new FileSystemXmlApplicationContext(getServletContext().getRealPath("/WEB-INF")+"/servlet-context.xml");
//SqlMapClient sqlMapClient = (SqlMapClient) context.getBean("sqlMapClient");
DataSource dataSource = (DataSource) context.getBean("dataSource");
JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

String[] donationArea = {"경남","그외"};
String[] donationArea2 = {"김해시","거제시","거창군","고성군","남해군","밀양시","사천시","산청군","의령군","양산시","거제시","진주시","하동군","함안군","함양군","합천군","창원시","창녕군","통영시"};
String[] donationSchoolType = {"U","E","M","H","T"};
String[] donationSchoolTypeName = {"유치원","초등학교","중학교","고등학교","특수학교"};
String adminLoginUrl = "/iam/login/login.sko";

String smsCallback = "055-278-1773";

%>