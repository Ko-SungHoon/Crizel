<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jxl.Cell" %>
<%@ page import="jxl.Sheet" %>
<%@ page import="jxl.Workbook" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.ProgressListener"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="com.ibatis.sqlmap.client.SqlMapClient" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>

<%!
/** Null Pointer Exception#1 **/
public static String parseNull(String strText) throws Exception {
	String rtnVal = "";
	
	try {
		if (strText != null) rtnVal = strText;
	} catch (Exception e) {
		return rtnVal;
	}
	
	return rtnVal;
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
	
	return rtnVal;
}

/** 현재 날짜 및 시간 구하기#1 **/
public static String getDate() {
	return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA).format(Calendar.getInstance().getTime());
}

/** 현재 날짜 및 시간 구하기#2 **/
public static String getDate(String dateType) {
	return new SimpleDateFormat(dateType, Locale.KOREA).format(Calendar.getInstance().getTime());
}

/** 기간체크#1 **/
public static boolean isAvailablePeriod(String sDateText, String eDateText) throws Exception {
	return isAvailablePeriod("yyyy-MM-dd HH:mm:ss", sDateText, eDateText);
}

/** 기간체크#2 **/
public static boolean isAvailablePeriod(String dateType, String sDateText, String eDateText) throws Exception {
	boolean flag = false;
	SimpleDateFormat SDF = new SimpleDateFormat(dateType, Locale.KOREA);
	
	Date sDate = SDF.parse(sDateText);
	Date eDate = SDF.parse(eDateText);
	Date toDate = SDF.parse(getDate(dateType));
	
	if (toDate.compareTo(sDate) >= 0 && toDate.compareTo(eDate) <= 0) flag = true;
	
	return flag;
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

/** Xls File Read **/
public static List<Map<String, Object>> getExcelRead(File xlsFile, int startRows) throws Exception {
	List<Map<String, Object>> dataList = null;
	Workbook workbook = null;
	Sheet sheet = null;

	try {
		workbook = Workbook.getWorkbook(xlsFile);
		sheet = workbook.getSheet(0);
		
		int rowsCnt = sheet.getRows();
		int colsCnt = sheet.getColumns();

		if (rowsCnt <= 0) return dataList;
		
		dataList = new ArrayList<Map<String, Object>>();
		for (int rows = startRows; rows < rowsCnt; rows++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();

			for (int cols = 0; cols < colsCnt; cols++) {
				Cell cell = sheet.getCell(cols, rows);
				dataMap.put("cell" + String.valueOf(cols + 1), cell.getContents().trim());
			}

			dataList.add(dataMap);
		}
	} catch (Exception e) {
		System.out.println("<---------- Exception Error : getExcelRead() ---------->");
	}
	
	return dataList;
}

/** Xls File Read for 스승찾기 **/
public static List<Map<String, Object>> getTeacherXlsRead(File xlsFile) throws Exception {
	List<Map<String, Object>> dataList = null;
	Workbook workbook = null;
	Sheet sheet = null;

	try {
		workbook = Workbook.getWorkbook(xlsFile);
		sheet = workbook.getSheet(0);
		
		int rowsCnt = sheet.getRows();
		int colsCnt = sheet.getColumns();

		if (rowsCnt <= 0) return dataList;
		
		dataList = new ArrayList<Map<String, Object>>();
		for (int rows = 1; rows < rowsCnt; rows++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			
			String schoolInfo = "";
			for (int cols = 0; cols < colsCnt; cols++) {
				Cell cell = sheet.getCell(cols, rows);
				if (cols < 6) dataMap.put("cell" + String.valueOf(cols + 1), cell.getContents().trim());
				else {
					String data = cell.getContents().trim().replaceAll("-", "");
					schoolInfo += data + (!data.trim().equals("") ? ">" : "");
				}
			}
			
			if (!schoolInfo.trim().equals("")) schoolInfo = schoolInfo.substring(0, schoolInfo.lastIndexOf(">"));
			dataMap.put("cell7", schoolInfo.trim());
			dataList.add(dataMap);
		}
	} catch (Exception e) {
		System.out.println("<---------- Exception Error : getTeacherXlsRead() ---------->");
	}
	
	return dataList;
}


/** Xls File Read for sucheop pages **/
public static List<Map<String, Object>> getSucheopExcelRead(File xlsFile, int startRows) throws Exception {
    
    List<Map<String, Object>> dataList = null;
	Workbook workbook = null;
	Sheet sheet = null;
    
	try {
		workbook = Workbook.getWorkbook(xlsFile);
		sheet = workbook.getSheet(0);
		
		int rowsCnt = sheet.getRows();
		int colsCnt = sheet.getColumns();

		if (rowsCnt <= 0) return dataList;
		
		dataList = new ArrayList<Map<String, Object>>();
		for (int rows = startRows; rows < rowsCnt; rows++) {
            
            
			Map<String, Object> dataMap = new HashMap<String, Object>();

			for (int cols = 0; cols < colsCnt; cols++) {
				Cell cell = sheet.getCell(cols, rows);
				dataMap.put("cell" + String.valueOf(cols + 1), cell.getContents().trim());
			}

			dataList.add(dataMap);
		}
	} catch (Exception e) {
		System.out.println("<---------- Exception Error : getSucheopExcelRead() ---------->");
	}
	
	return dataList;
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
%>

<%
WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
SqlMapClient sqlMapClient = (SqlMapClient) context.getBean("sqlMapClient");
%>