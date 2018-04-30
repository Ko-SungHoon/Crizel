<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.File"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
try{
	String path = request.getParameter("path")==null?"/":request.getParameter("path");
	Map<String,Object> map = null;

	File file = new File(path);
	File[] listFiles = file.listFiles();


	List<Map<String,Object>> directoryList	= new ArrayList<Map<String,Object>>();
	List<String> fileList	  	= new ArrayList<String>();
	Map<String,Object> directoryMap = null;

	if(listFiles != null){
		for(File ob : listFiles){
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

	out.println(path + "<br>");
	out.println("폴더<br>");
	for(Map<String,Object> ob : directoryList){
		out.println("<a href='http://www.gne.go.kr/artcenter/index.gne?menuCd=DOM_000002001006000000&path="+path+"/"+ob.get("name")+"'>");
		out.println(ob.get("name") + "<br>");
		out.println("</a>");
	}
	out.println("<br>파일<br>");

	for(String ob : fileList){
		out.println(ob + "<br>");
	}

	map = new HashMap<String,Object>();
	map.put("folder", directoryList);
	map.put("file", fileList);
}catch(Exception e){
	out.println("에러 : " + e.toString());
}

%>
</body>
</html>