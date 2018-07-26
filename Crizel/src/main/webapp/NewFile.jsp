<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String mode = request.getParameter("mode")==null?"":request.getParameter("mode");

if("".equals(mode)){
	String path = request.getParameter("path")==null?"":request.getParameter("path");

	Map<String,Object> map = null;

	if("".equals(path)){
		path = "/";
	}
	File file = new File(path);

	List<Map<String,Object>> directoryList	= new ArrayList<Map<String,Object>>();
	List<String> fileList	  	= new ArrayList<String>();

	Map<String,Object> directoryMap = null;

	if(file.listFiles() != null){
		for(File ob : file.listFiles()){
			if(ob.isDirectory()){
				directoryMap = new HashMap<String,Object>();
				directoryMap.put("name", ob.getName());
				directoryMap.put("path", ob.getPath().replace("\\", "/"));
				directoryList.add(directoryMap);
			}else{
				fileList.add(ob.getName());
			}
		}
	}

	try{
		Collections.sort(fileList, new Comparator<String>() {
	        public int compare(String o1, String o2) {
	            return extractInt(o1) - extractInt(o2);
	        }
	        int extractInt(String s) {
	            String num = s.replaceAll("\\D", "");
	            // return 0 if no digits found
	            return num.isEmpty() ? 0 : Integer.parseInt(num);
	        }
	    });
	}catch(Exception e){
		out.println(e.toString());
	}

	map = new HashMap<String,Object>();
	map.put("folder", directoryList);
	map.put("file", fileList);

	for(Map<String,Object> ob : directoryList){
	%>
		<a href="test.jsp?path=<%=ob.get("path").toString()%>"><%=ob.get("name").toString()%></a><br>
	<%
	}
	%>
	<br><br>
	=======파일===========
	<%
	for(String ob : fileList){
	%>
		<a href="test.jsp?mode=down&filename=<%=ob%>&directory=<%=path%>"><%=ob%></a><br>
	<%
	}
}else{
	String filename = request.getParameter("filename")==null?"":request.getParameter("filename");
	String directory = request.getParameter("directory")==null?"":request.getParameter("directory");
	
	String realname = filename;
	String docName = URLEncoder.encode(realname, "UTF-8").replaceAll("\\+", " ");
	String filePath = directory + "/" + realname;
	
	try {
		File file = new File(filePath);
		if (!file.exists()) {
			try {
				throw new Exception();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
		response.setHeader("Content-Type", "application/octet-stream");
		response.setContentLength((int) file.length());
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");
		int read;
		byte readByte[] = new byte[4096];

		BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
		OutputStream outs = response.getOutputStream();

		while ((read = fin.read(readByte, 0, 4096)) != -1) {
			outs.write(readByte, 0, read);
		}

		outs.flush();
		outs.close();
		fin.close();

	} catch (java.io.IOException e) {
		if (!e.getClass().getName().equals("org.apache.catalina.connector.ClientAbortException")) {

		}

	}
}
%>
</body>
</html>