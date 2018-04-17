<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/excel/_class.jsp"%>

<%
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);

int sid = 0;
String title = "";
String writer = "";
String addr = "";
String url = "";
String email = "";
String tel = "";
String fax = "";
String school_type = "";
String codeu = "";
String cate1 = "";
String cate2 = "";
String replace_text = "";
String replace_text2 = "";


		/** 파일 업로드 처리 **/
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if (isMultipart) {
			try {
				/** 파일 경로 설정 **/	
				String tempFilePath =  getServletContext().getRealPath("/upload_data/school_search/temp/");
				File tempFileDir = new File(tempFilePath);
				if (!tempFileDir.exists()) tempFileDir.mkdirs();
				String saveFilePath =  getServletContext().getRealPath("/upload_data/school_search/");
				File saveFileDir = new File(saveFilePath);
				if (!saveFileDir.exists()) saveFileDir.mkdirs();
				
				/** 첨부 가능한 파일형식 **/
				String[] avaliableExt = { "xls", "xlsx" };
				
				/** 파일 업로드 처리 **/
				File uploadedFile = null;
				DiskFileItemFactory factory = new DiskFileItemFactory();
				factory.setSizeThreshold(1*1024*1024);
				factory.setRepository(tempFileDir);
				
				ServletFileUpload upload = new ServletFileUpload(factory);
				upload.setSizeMax(100 * 1024 * 1024);
				upload.setHeaderEncoding("UTF-8");
				
				List<FileItem> items = upload.parseRequest(request);
				int fileCnt = 0;
				for (FileItem item : items) {
					String fieldName = item.getFieldName();
					
					if (item.isFormField()) {
						 if (fieldName.equals("writer"))					writer = item.getString("UTF-8"); 
					} else {
						if (item.getSize() > 0) {
							String fileName = new File(item.getName()).getName();
							if (!doCheckFileExt(fileName, avaliableExt)) {
								out.println("<script type=\"text/javascript\">");
								out.println("alert('해당 파일의 확장자는 첨부 불가능합니다.');");
								out.println("history.go(-1);");
								out.println("</script>");
							}
							/** 파일명 변경 **/
							fileName = "SCHOOH_SEARCH_" + getDate("yyyyMMddHHmmss") + "_" + String.valueOf(++fileCnt) + fileName.substring(fileName.lastIndexOf("."));
							uploadedFile = new File(saveFileDir, fileName);
							item.write(uploadedFile);
						}
					}
				}

				/** DB Process **/
				Connection conn = null;
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				int key = 0;
				int result = 0;
				StringBuffer sql = new StringBuffer();
				
				try {
					sqlMapClient.startTransaction();
					conn = sqlMapClient.getCurrentConnection();
					
					List<Map<String, Object>> dataList = getExcelRead(uploadedFile, 1);
					
					if (dataList.size() > 0 && dataList != null) {	
						
						//원래 있던 데이터 삭제
						sql = new StringBuffer();
						sql.append("DELETE FROM SCHOOL_SEARCH \n");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						
						//SID 구함
						sql = new StringBuffer();
						sql.append("SELECT NVL(MAX(SID)+1, 1) CNT FROM SCHOOL_SEARCH \n");
						pstmt = conn.prepareStatement(sql.toString());
						rs = pstmt.executeQuery();						
						while(rs.next()){
							sid = Integer.parseInt(rs.getString("CNT"));
						}
						
						//테이블에 데이터 입력
						sql = new StringBuffer();
						sql.append("INSERT INTO SCHOOL_SEARCH(SID, CATE1, CATE2, TITLE, CODE, AREA_TYPE, COEDU, POST, ADDR, TEL, FAX, URL)  \n");
						sql.append("VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)   \n");
						pstmt = conn.prepareStatement(sql.toString()); 
						
						for (Map<String, Object> dataMap : dataList) {							
							key = 0;
							//엑셀이 비워져있으면 입력안함
							if("".equals(parseNull(dataMap.get("cell1").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell2").toString(), "").trim()) &&									
								"".equals(parseNull(dataMap.get("cell3").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell4").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell5").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell6").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell7").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell8").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell9").toString(), "").trim()) &&
								"".equals(parseNull(dataMap.get("cell10").toString(), "").trim()) 
							){								
							}else{
								replace_text = parseNull(dataMap.get("cell9").toString(), "").trim().replace("-","");	//전화번호 - 제거
								replace_text2 = parseNull(dataMap.get("cell10").toString(), "").trim().replace("-","");	//팩스번호 - 제거
								
								pstmt.setInt(++key, sid++);
								pstmt.setString(++key, parseNull(dataMap.get("cell1").toString(), "").trim());		//학교급
								pstmt.setString(++key, parseNull(dataMap.get("cell2").toString(), "").trim());		//설립구분
								pstmt.setString(++key, parseNull(dataMap.get("cell3").toString(), "").trim());		//학교명
								pstmt.setString(++key, parseNull(dataMap.get("cell4").toString(), "").trim());		//학교코드 
								pstmt.setString(++key, parseNull(dataMap.get("cell5").toString(), "").trim());		//지역구분
								pstmt.setString(++key, parseNull(dataMap.get("cell6").toString(), "").trim());		//남여공학
								pstmt.setString(++key, parseNull(dataMap.get("cell7").toString(), "").trim());		//우편번호
								pstmt.setString(++key, parseNull(dataMap.get("cell8").toString(), "").trim());		//주소
								pstmt.setString(++key, replace_text );												//전화번호
								pstmt.setString(++key, replace_text2);												//팩스번호
								pstmt.setString(++key, parseNull(dataMap.get("cell11").toString(), "").trim());		//홈페이지
								
								pstmt.addBatch();
							}
						}
						
						int[] count = pstmt.executeBatch();
						result = count.length;
						
						if (result > 0) {
							sqlMapClient.commitTransaction();
							out.println("<script type=\"text/javascript\">");
							out.println("alert('정상적으로 처리 되었습니다.');");
							out.println("opener.location.reload();");
							out.println("window.close();");
							out.println("</script>");
						}
					}
					
				} catch (Exception e) {
					e.printStackTrace();
					sqlMapClient.endTransaction();
					out.println("<script type=\"text/javascript\">");
					out.println("alert('Exception Error_2 : 처리중 오류가 발생하였습니다.');");
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
%>
