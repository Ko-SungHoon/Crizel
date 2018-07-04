<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="java.util.*"%>
<%@ page import="egovframework.rfc3.menu.web.CmsManager"%>
<%

	CmsManager cm = new CmsManager(request);
	
/********* 임시화면 시작&종료기간 설정 ********/
String startDate =	"201806191650";
String endDate =	"201806191651";
/**********************************************/

SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
String currentDt = sdf.format(new Date()); 
Long icuDt = Long.parseLong(currentDt); 

String host = request.getServerName();
if (host.equals("www.k-sis.com")) {
	if (icuDt >= Long.parseLong(startDate) && icuDt <= Long.parseLong(endDate)) {
		response.sendRedirect("/index.html");
	} else {
		response.sendRedirect(request.getContextPath()+"/index."+cm.getUrlExt());
	}
} else if(host.equals("k-sis.com")){
	if (icuDt >= Long.parseLong(startDate) && icuDt <= Long.parseLong(endDate)) {
		response.sendRedirect("/index.html");
	} else {
		response.sendRedirect(request.getContextPath()+"/index."+cm.getUrlExt());
	}
} else {
	response.sendRedirect(request.getContextPath()+"/index."+cm.getUrlExt());
}
%>
