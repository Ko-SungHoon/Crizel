<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<script>
$(function(){
	alert("test");
});
</script>
<%
/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String dirPath = parseNull(request.getParameter("path"));
String filePath = getServletContext().getRealPath(dirPath);
String saveName = parseNull(request.getParameter("filename"));
String realName = parseNull(request.getParameter("filename"));

String ext = saveName.substring(saveName.lastIndexOf(".") + 1, saveName.length());
if(!"hwp".equals(ext) && !"pdf".equals(ext) && !"xls".equals(ext) && !"xlsx".equals(ext) && !"zip".equals(ext) && !"exe".equals(ext)) {
	out.println("<script type=\"text/javascript\">");
	out.println("alert('파일이 존재하지 않습니다.');");
	out.println("history.back();");
	out.println("</script>");
}

File file = new File(filePath + File.separator + saveName);
if (!file.exists()) {
	out.println("<script type=\"text/javascript\">");
	out.println("alert('파일이 존재하지 않습니다.');");
	out.println("history.back();");
	out.println("</script>");
}

if (file.exists()) {
	response.setContentType("application/octet-stream");
	setContentDisposition((realName.equals("") ? saveName : realName), request, response);

	BufferedInputStream bin = null;
	BufferedOutputStream bout = null;

	try {
		out.clear();
		bin = new BufferedInputStream(new FileInputStream(file));
		bout = new BufferedOutputStream(response.getOutputStream());

		byte[] bytes = new byte[1024];
		int readNum = 0;
		while ((readNum = bin.read(bytes, 0, bytes.length)) != -1) bout.write(bytes, 0, readNum);
		
		bout.flush();
	} catch (IOException ex) {
		System.out.println("<----------------IOException--------------->");
	} finally {
		if (bin != null) try { bin.close(); } catch (Exception ex1) {}
		if (bout != null) try { bout.close(); } catch (Exception ex2) {}
	}
	response.setStatus(response.SC_OK);
} else response.sendError(response.SC_NOT_FOUND);
%>

<%!
/** Null Pointer Exception#1 **/
public static String parseNull(String str) throws Exception {
	String rtnValue = "";
	
	try {
		if (str != null) rtnValue = str;
	} catch (Exception e) {
		return rtnValue;
	}
	
	return rtnValue;
}

/** Null Pointer Exception#2 **/
public static String parseNull(String str, String def) throws Exception {
	String rtnValue = "";
	
	try {
		if (parseNull(str).equals("")) rtnValue = def;
		else rtnValue = str;
	} catch (Exception e) {
		return rtnValue;
	}
	
	return rtnValue;
}

/** BROWSER 구분 **/
public static String getBrowser(HttpServletRequest request) {
	String header = request.getHeader("User-Agent").toUpperCase();
	
	if (header.indexOf("MSIE") > -1) return "MSIE";
	else if (header.indexOf("TRIDENT") > -1) return "MSIE"; // IE11 문자열 깨짐 방지
	else if (header.indexOf("CHROME") > -1) return "CHROME";
	else if (header.indexOf("OPERA") > -1) return "OPERA";
	return "FIREFOX";
}
	
/** Content-Disposition **/
public static void setContentDisposition(String fileName, HttpServletRequest request, HttpServletResponse response) throws Exception {
	String browser = getBrowser(request);
	String dispositionPrefix = "attachment; filename=";
	String encodedFileName = "";
	
	if (browser.equals("MSIE")) {
		encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
	} else if (browser.equals("FIREFOX")) {
		encodedFileName = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
	} else if (browser.equals("OPERA")) {
		encodedFileName = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
	} else if (browser.equals("CHROME")) {
		StringBuffer sb = new StringBuffer();
		
		for (int i = 0; i < fileName.length(); i++) {
			char c = fileName.charAt(i);
			
			if (c > '~') {
				sb.append(URLEncoder.encode("" + c, "UTF-8"));
			} else {
				sb.append(c);
			}
		}
		
		encodedFileName = sb.toString();
	} else throw new IOException("Not supported browser");
	
	response.setHeader("Content-Disposition", dispositionPrefix + encodedFileName);

	if ("Opera".equals(browser)) response.setContentType("application/octet-stream;charset=UTF-8");
}
%>