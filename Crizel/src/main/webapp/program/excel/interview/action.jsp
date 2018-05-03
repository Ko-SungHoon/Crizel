<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/excel/_class.jsp" %>

<%
/** 파라미터 UTF-8처리 **/
response.setCharacterEncoding("UTF-8");

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if (getMethod.equals("") || !getMethod.toUpperCase().equals("POST") || 
	getReferer.equals("") || getReferer.indexOf("/program/excel/interview/form.jsp") < 0) {
	out.println("<script type=\"text/javascript\">");
	out.println("alert('잘못된 접근 방식입니다.\\n해당 페이지를 닫습니다.');");
	out.println("window.opener='nothing';window.open('','_parent','');window.close();");
	out.println("</script>");
} else {
	/** 회원정보 **/
	SessionManager sessionManager = new SessionManager(request);
	
	/** 파라미터 변수 선언 **/
	String gubun = "";
	String inputfield = "";
	String sdate = "";
	String shour = "";
	String smin = "";
	String edate = "";
	String ehour = "";
	String emin = "";
	String always = "N";
	String savename = "";
	String realname = "";
	String regid = sessionManager.getId();
	String uptid = sessionManager.getId();
	
	/** 파일 업로드 처리 **/
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (isMultipart) {
		try {
			/** 파일 경로 설정 **/	
			String tempFilePath =  getServletContext().getRealPath("/upload_data/program/excel/interview/temp/");
			File tempFileDir = new File(tempFilePath);
			if (!tempFileDir.exists()) tempFileDir.mkdirs();
			String saveFilePath =  getServletContext().getRealPath("/upload_data/program/excel/interview/");
			File saveFileDir = new File(saveFilePath);
			if (!saveFileDir.exists()) saveFileDir.mkdirs();
			
			/** 첨부 가능한 파일형식 **/
			String[] avaliableExt = { "xls" };
			
			/** 파일 업로드 처리 **/
			File uploadedFile = null;
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(1*1024*1024);
			factory.setRepository(tempFileDir);
			
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setSizeMax(10 * 1024 * 1024);
			upload.setHeaderEncoding("UTF-8");
			
			List<FileItem> items = upload.parseRequest(request);			
			
			int fileCnt = 0;
			for (FileItem item : items) {
				String fieldName = item.getFieldName();
				
				if (item.isFormField()) {
					if (fieldName.equals("gubun"))				gubun = item.getString("UTF-8");
					else if (fieldName.equals("inputfield"))	inputfield = item.getString("UTF-8");
					else if (fieldName.equals("sdate"))			sdate = item.getString("UTF-8");
					else if (fieldName.equals("shour"))			shour = item.getString("UTF-8");
					else if (fieldName.equals("smin"))			smin = item.getString("UTF-8");
					else if (fieldName.equals("edate"))			edate = item.getString("UTF-8");
					else if (fieldName.equals("ehour"))			ehour = item.getString("UTF-8");
					else if (fieldName.equals("emin"))			emin = item.getString("UTF-8");
					else if (fieldName.equals("always"))		always = item.getString("UTF-8");
				} else {
					if (item.getSize() > 0) {
						String fileName = new File(item.getName()).getName();
						realname = fileName;
						if (!doCheckFileExt(fileName, avaliableExt)) {
							out.println("<script type=\"text/javascript\">");
							out.println("alert('해당 파일의 확장자는 첨부 불가능합니다.');");
							out.println("history.back();");
							out.println("</script>");
						}
						/** 파일명 변경 **/
						fileName = "INTERVIEW_" + getDate("yyyyMMddHHmmss") + "_" + String.valueOf(++fileCnt) + fileName.substring(fileName.lastIndexOf("."));
						savename = fileName;
						uploadedFile = new File(saveFileDir, fileName);
						item.write(uploadedFile);
					}
				}
			}
			
			if (always.equals("Y")) {
				sdate = "";
				edate = "";
			} else {
				sdate = sdate.replaceAll("-", "") + shour + smin;
				edate = edate.replaceAll("-", "") + ehour + emin;
			}
			
			/** DB Process **/
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int key = 0;
			int result = 0;
			
			try {
				sqlMapClient.startTransaction();
				conn = sqlMapClient.getCurrentConnection();
				
				/** DATA MERGE **/
				StringBuffer sql = new StringBuffer();
				sql.append("MERGE INTO TBL_FORMDATA A \n");
				sql.append("USING DUAL B \n");
				sql.append("ON (A.GUBUN = ?) \n");
				sql.append("WHEN MATCHED THEN \n");
				sql.append("UPDATE SET \n");
				sql.append("    A.INPUTFIELD = ?, \n");
				sql.append("    A.SDATE = ?, \n");
				sql.append("    A.EDATE = ?, \n");
				sql.append("    A.ALWAYSYN = ?, \n");
				sql.append("    A.SAVENAME = ?, \n");
				sql.append("    A.REALNAME = ?, \n");
				sql.append("    A.UPTID = ?, \n");
				sql.append("    A.UPTDATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') \n");
				sql.append("WHEN NOT MATCHED THEN \n");
				sql.append("INSERT (A.GUBUN, A.INPUTFIELD, A.SDATE, A.EDATE, A.ALWAYSYN, A.SAVENAME, A.REALNAME, A.REGID, A.UPTID) \n");
				sql.append("VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) \n");
				
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(++key, gubun);
				pstmt.setString(++key, inputfield);
				pstmt.setString(++key, sdate);
				pstmt.setString(++key, edate);
				pstmt.setString(++key, always);
				pstmt.setString(++key, savename);
				pstmt.setString(++key, realname);
				pstmt.setString(++key, uptid);
				pstmt.setString(++key, gubun);
				pstmt.setString(++key, inputfield);
				pstmt.setString(++key, sdate);
				pstmt.setString(++key, edate);
				pstmt.setString(++key, always);
				pstmt.setString(++key, savename);
				pstmt.setString(++key, realname);
				pstmt.setString(++key, regid);
 				pstmt.setString(++key, regid);
				result = pstmt.executeUpdate();
				
				if (result > 0) {
					sql = new StringBuffer();
					sql.append("SELECT COUNT(ETC_ID) AS CNT FROM TBL_ETCDATA");
					pstmt = conn.prepareStatement(sql.toString());
					rs = pstmt.executeQuery();
					int selectRst = 0;
					if (rs.next()) selectRst = rs.getInt("CNT");
					rs.close();
					pstmt.close();
					
					int deleteRst = 0;
					if (selectRst > 0) {
						sql = new StringBuffer();
						sql.append("DELETE FROM TBL_ETCDATA");
						pstmt = conn.prepareStatement(sql.toString());
						deleteRst = pstmt.executeUpdate();
						pstmt.close();
					}
					
					boolean insertFlag = (selectRst > 0 && deleteRst > 0) || (selectRst == 0 && deleteRst == 0);
					List<Map<String, Object>> dataList = getExcelRead(uploadedFile, 1);
					if (insertFlag && dataList != null && dataList.size() > 0) {
						result = 0;
						sql = new StringBuffer();
						sql.append("INSERT INTO TBL_ETCDATA \n ");
						sql.append("(ETC_ID, NAME, PRIVATE_NUMBER) \n");
						sql.append("VALUES (?, ?, ?) \n");
						pstmt = conn.prepareStatement(sql.toString());
						
						for (Map<String, Object> dataMap : dataList) {
							key = 0;
							pstmt.setString(++key, parseNull(dataMap.get("cell1").toString(), "").trim());
							pstmt.setString(++key, parseNull(dataMap.get("cell2").toString(), "").trim());
							pstmt.setString(++key, parseNull(dataMap.get("cell3").toString(), "").trim());
							pstmt.addBatch();
						}
						
						int[] count = pstmt.executeBatch();
						result = count.length;
						
						if (result == dataList.size()) result = 1;
						else result = -1;
						
						if (result > 0) {
							sqlMapClient.commitTransaction();
							out.println("<script type=\"text/javascript\">");
							out.println("alert('정상적으로 처리 되었습니다.');");
							out.println("location.href='/program/excel/interview/form.jsp';");
							out.println("</script>");
						} else {
							sqlMapClient.endTransaction();
							out.println("<script type=\"text/javascript\">");
							out.println("alert('처리중 오류가 발생하였습니다.');");
							out.println("history.go(-1);");
							out.println("</script>");
						
						}
					} else {
						sqlMapClient.endTransaction();
						out.println("<script type=\"text/javascript\">");
						out.println("alert('파일 업로드 처리중 오류가 발생하였습니다.');");
						out.println("history.back();");
						out.println("</script>");
					}
				} else {
					sqlMapClient.endTransaction();
					out.println("<script type=\"text/javascript\">");
					out.println("alert('처리중 오류가 발생하였습니다.');");
					out.println("history.go(-1);");
					out.println("</script>");
				}
			} catch (Exception e) {
				sqlMapClient.endTransaction();
				out.println("<script type=\"text/javascript\">");
				out.println("alert('Exception Error_1 : 처리중 오류가 발생하였습니다.');");
				out.println("history.go(-1);");
				out.println("</script>");
			} finally {
				if (rs != null) try { rs.close(); } catch (SQLException se) {}
				if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
				if (conn != null) try { conn.close(); } catch (SQLException se) {}
				sqlMapClient.endTransaction();
			}
		} catch (Exception e) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Exception Error_2 : 처리중 오류가 발생하였습니다.');");
			out.println("history.go(-1);");
			out.println("</script>");
		}
	} else {
		out.println("<script type=\"text/javascript\">");
		out.println("alert('MultiPart Content Error : 처리중 오류가 발생하였습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
	}
}
%>