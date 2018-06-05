<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="kr.miraesoft.zuk.account.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TEST</title>
</head>
<body>
<%!
private String generateingPassword(String lastLogin) {
	//학사 pw 생성 알고리즘 writer 유동진
	StringBuffer reverce_lastLogin = new StringBuffer(lastLogin).reverse();
	
	StringBuffer str24 = new StringBuffer();
	str24.append(reverce_lastLogin);
	str24.append(lastLogin.substring(4,8));
	str24.append(lastLogin.substring(0,4));
	str24.append(lastLogin);
	
	int str0 = Integer.parseInt(str24.substring(0,3))%24;
	int str1 = Integer.parseInt(str24.substring(1,4))%24;
	int str2 = Integer.parseInt(str24.substring(2,5))%24;
	int str3 = Integer.parseInt(str24.substring(3,6))%24;
	int str4 = Integer.parseInt(str24.substring(4,7))%24;
	int str5 = Integer.parseInt(str24.substring(5,8))%24;
	int str6 = Integer.parseInt(str24.substring(6,9))%24;
	int str7 = Integer.parseInt(str24.substring(7,10))%24;
	int str8 = Integer.parseInt(str24.substring(8,11))%24;
	int str9 = Integer.parseInt(str24.substring(9,12))%24;
	int str10 =Integer.parseInt(str24.substring(10,13))%24;
	int str11 =Integer.parseInt(str24.substring(11,14))%24;
	int str12 =Integer.parseInt(str24.substring(12,15))%24;
	int str13 =Integer.parseInt(str24.substring(13,16))%24;
	int str14 =Integer.parseInt(str24.substring(14,17))%24;
	int str15 =Integer.parseInt(str24.substring(15,18))%24;
	int str16 =Integer.parseInt(str24.substring(16,19))%24;
	int str17 =Integer.parseInt(str24.substring(17,20))%24;
	int str18 =Integer.parseInt(str24.substring(18,21))%24;
	int str19 =Integer.parseInt(str24.substring(19,22))%24;
	int str20 =Integer.parseInt(str24.substring(20,23))%24;
	int str21 =Integer.parseInt(str24.substring(21,24))%24;
	int str22 =Integer.parseInt(str24.substring(22,24)+"0")%24;
	int str23 =Integer.parseInt(str24.substring(23,24)+"00")%24;
	
	String key = "HVAgSWDrOCZtNUMiYLFbEKJp";
	
    StringBuffer pw = new StringBuffer();
    pw.append(key.charAt(str0));
    pw.append(key.charAt(str1));
    pw.append(key.charAt(str2));
    pw.append(key.charAt(str3));
    pw.append(key.charAt(str4));
    pw.append(key.charAt(str5));
    pw.append(key.charAt(str6));
    pw.append(key.charAt(str7));
    pw.append(key.charAt(str8));
    pw.append(key.charAt(str9));
    pw.append(key.charAt(str10));
    pw.append(key.charAt(str11));
    pw.append(key.charAt(str12));
    pw.append(key.charAt(str13));
    pw.append(key.charAt(str14));
    pw.append(key.charAt(str15));
    pw.append(key.charAt(str16));
    pw.append(key.charAt(str17));
    pw.append(key.charAt(str18));
    pw.append(key.charAt(str19));
    pw.append(key.charAt(str20));
    pw.append(key.charAt(str21));
    pw.append(key.charAt(str22));
    pw.append(key.charAt(str23));
    
    return pw.toString();
}
%>
<%
String url 	= "jdbc:oracle:thin:@203.246.1.13:1521:PORTAL";
String user = "portal";
String pass = "ckd#porty1";
Connection conn;
PreparedStatement pstmt;
ResultSet rs;
String sql 				= ""; 
String lastLogin 		= "";
User userVO = (User) session.getAttribute(User.SESSION_USER);
try{
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url, user, pass);
	
	sql = new String();
	
	sql += "SELECT TO_CHAR(LAST_LOGIN,'DDHH24MISS') LAST_LOGIN		";
	sql += "FROM PORTY_USER@BRDB									";
	sql += "WHERE NVL(STAFF_ID, EMP_NO) = ?							";
	
	pstmt=conn.prepareStatement(sql);
	pstmt.setString(1, userVO.getUserid());
	rs=pstmt.executeQuery();
	
	if(rs.next()){
		lastLogin = rs.getString("LAST_LOGIN");
	}
	 
	conn.close();
	rs.close();

	
	//out.println("user : " + userVO + "<br>");

	out.println("userLogin : " + userVO.isLogin() + "<br>");

	out.println("userid : " + userVO.getUserid() + "<br>");
	

	out.println("function : " + generateingPassword(lastLogin) + "<br>");
}catch(Exception e){
	out.println(e.toString());
}

%>
</body>
</html>