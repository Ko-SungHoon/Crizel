<%
/* 20171229_fri KO */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/excel/_class.jsp"%>
<%@ page import="egovframework.rfc3.common.crypt.DESede" %>
<%!
public String numberSet(String val){
	if(Integer.parseInt(val) < 10){
		val = "0" + val;
	}
	return val;
}

public String numberSet(int val){
	String returnVal = Integer.toString(val);
	if(val<10){
		returnVal = "0" + Integer.toString(val);
	}
	
	return returnVal;
}
%>
<%
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);

// 암호화 모듈 encrypt(String) , decrypt(String)
DESede ds = new DESede();

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


		/** 파일 업로드 처리 **/
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if (isMultipart) {
			try {
				/** 파일 경로 설정 **/	
				String tempFilePath =  getServletContext().getRealPath("/upload_data/division_work/temp/");
				File tempFileDir = new File(tempFilePath);
				if (!tempFileDir.exists()) tempFileDir.mkdirs();
				String saveFilePath =  getServletContext().getRealPath("/upload_data/division_work/");
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
							fileName = "SCHOOH_CHART_" + getDate("yyyyMMddHHmmss") + "_" + String.valueOf(++fileCnt) + fileName.substring(fileName.lastIndexOf("."));
							uploadedFile = new File(saveFileDir, fileName);
							item.write(uploadedFile);
						}
					}
				}

				/** DB Process **/
				Connection conn = null;
				ResultSet rs = null;
				StringBuffer sql = null;
				PreparedStatement pstmt = null;
				PreparedStatement pstmt2 = null;
				
				
				
				/**
				*   PURPOSE :   현재날짜 백업테이블 생성을 위한 변수 생성
				*   CREATE  :   20171215_fri   KO
				*   MODIFY  :   ....
				*/
				Calendar cal 	= Calendar.getInstance();	
				String year 	= numberSet(cal.get(Calendar.YEAR));
				String month 	= numberSet(cal.get(Calendar.MONTH)+1);
				String date 	= numberSet(cal.get(Calendar.DATE));
				String day 		= year + month + date;
				
				String tableName1 = "RFC_COMTCOFFICE_PART_" + day;
				String tableName2 = "RFC_COMTNMANAGER_" + day;
				String tableName3 = "RFC_COMTNMENU_" + day;
				
				boolean dupCheck = false;
				/* END */

				int key = 0;
				int result = 0;
				
				try {
					sqlMapClient.startTransaction();
					conn = sqlMapClient.getCurrentConnection();
					
					List<Map<String, Object>> dataList = getExcelRead(uploadedFile, 1);
					
					
					/**
					*   PURPOSE :   현재날짜 백업테이블 생성
					*   CREATE  :   20171215_fri   KO
					*   MODIFY  :   ....
					*/
					sql = new StringBuffer();
					sql.append("SELECT * FROM TAB WHERE TNAME = ?				");
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, tableName1);
					rs = pstmt.executeQuery();
					if(rs.next()){
						dupCheck = true;
					}
					if(pstmt!=null){pstmt.close();}
					if(rs!=null){rs.close();}
					
					if(!dupCheck){
						sql = new StringBuffer();
						sql.append("CREATE TABLE " + tableName1 + " AS SELECT * FROM RFC_COMTCOFFICE_PART		");		//담당관리 테이블
						pstmt = conn.prepareStatement(sql.toString());
						result = pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
					}
					
					dupCheck = false;
					sql = new StringBuffer();
					sql.append("SELECT * FROM TAB WHERE TNAME = ?				");
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, tableName2);
					rs = pstmt.executeQuery();
					if(rs.next()){
						dupCheck = true;
					}
					if(pstmt!=null){pstmt.close();}
					if(rs!=null){rs.close();}
					
					if(!dupCheck){
						sql = new StringBuffer();
						sql.append("CREATE TABLE " + tableName2 + " AS SELECT * FROM RFC_COMTNMANAGER		");				//업무사용자 테이블
						pstmt = conn.prepareStatement(sql.toString());
						result = pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
					}
					
					dupCheck = false;
					sql = new StringBuffer();
					sql.append("SELECT * FROM TAB WHERE TNAME = ?				");
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, tableName3);
					rs = pstmt.executeQuery();
					if(rs.next()){
						dupCheck = true;
					}
					if(pstmt!=null){pstmt.close();}
					if(rs!=null){rs.close();}
					
					if(!dupCheck){
						sql = new StringBuffer();
						sql.append("CREATE TABLE " + tableName3 + " AS SELECT * FROM RFC_COMTNMENU		");				//메뉴 테이블
						pstmt = conn.prepareStatement(sql.toString());
						result = pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
					}
					/* END */
					
					if (dataList.size() > 0 && dataList != null) {
						/**
						*   PURPOSE :   메뉴테이블의 OFFICE_PT_SID와 담당자테이블의 아이디를 메뉴테이블의 임시필드에 저장한다
						*   CREATE  :   20171229_FRI   KO
						*   MODIFY  :   ....
						*/
						sql = new StringBuffer();
						sql.append("UPDATE RFC_COMTNMENU SET TMP_FIELD10 = null,  	");
						sql.append("						 TMP_FIELD11 = null,  	");
						sql.append("						 TMP_FIELD12 = null,  	");
						sql.append("						 TMP_FIELD13 = null,  	");
						sql.append("						 TMP_FIELD14 = null,  	");
						sql.append("						 TMP_FIELD15 = null,  	");
						sql.append("						 TMP_FIELD16 = null,  	");
						sql.append("						 TMP_FIELD17 = null  	");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
						
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTNMENU A																					");	
						sql.append("USING(																										");	
						sql.append("	SELECT MENU_SID, OFFICE_PT_SID, OFFICE_PT_SID2, OFFICE_PT_SID3, OFFICE_PT_SID4,							");
						sql.append("		(SELECT USER_ID FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID) USER_ID,			");
						sql.append("		(SELECT USER_ID FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID2) USER_ID2,		");
						sql.append("		(SELECT USER_ID FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID3) USER_ID3,		");
						sql.append("		(SELECT USER_ID FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID4) USER_ID4,		");
						sql.append("		(SELECT OFFICE_CD FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID) OFFICE_CD,		");
						sql.append("		(SELECT OFFICE_CD FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID2) OFFICE_CD1,	");
						sql.append("		(SELECT OFFICE_CD FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID3) OFFICE_CD2,	");
						sql.append("		(SELECT OFFICE_CD FROM RFC_COMTCOFFICE_PART WHERE OFFICE_PT_SID = RC.OFFICE_PT_SID4) OFFICE_CD3		");
						sql.append("	FROM RFC_COMTNMENU RC																					");
						sql.append(") B																											");
						sql.append("ON(A.MENU_SID = B.MENU_SID)																					");
						sql.append("WHEN MATCHED THEN																							");
						sql.append("UPDATE SET A.TMP_FIELD10 = B.USER_ID,																		");
						sql.append("		   A.TMP_FIELD11 = B.USER_ID2,																		");
						sql.append("		   A.TMP_FIELD12 = B.USER_ID3,																		");
						sql.append("		   A.TMP_FIELD13 = B.USER_ID4,																		");
						sql.append("		   A.TMP_FIELD14 = B.OFFICE_CD,																		");
						sql.append("		   A.TMP_FIELD15 = B.OFFICE_CD1,																	");
						sql.append("		   A.TMP_FIELD16 = B.OFFICE_CD2,																	");
						sql.append("		   A.TMP_FIELD17 = B.OFFICE_CD3																		");
						pstmt = conn.prepareStatement(sql.toString());
						result = pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
						
						/* END */
						
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTCOFFICE_PART USING DUAL									\n");
						sql.append("ON (USER_ID = ?)															\n");
						sql.append("WHEN MATCHED THEN															\n");
						sql.append("UPDATE SET																	\n");
						sql.append("       OFFICE_CD = ?                                                        \n");
						sql.append("      ,USER_NM = ?															\n");
						sql.append("      ,OFFICE_TEL = ?                                                       \n");
						sql.append("      ,MODIFY_DATE = SYSDATE												\n");
						sql.append("WHEN NOT MATCHED THEN														\n");
						sql.append("INSERT (OFFICE_PT_SID, SGROUP_ID, USER_ID, OFFICE_CD, USER_NM, OFFICE_TEL, OFFICE_PT_IX, MODIFY_DATE, REGISTER_DATE, OFFICE_PT_IS_USE)	\n");
						sql.append("VALUES((SELECT NVL(MAX(OFFICE_PT_SID),0) + 1 FROM RFC_COMTCOFFICE_PART),'SGRP_00001',?,?,?,?, (SELECT NVL(MAX(OFFICE_PT_SID),0) + 1 FROM RFC_COMTCOFFICE_PART), SYSDATE, SYSDATE, 1)																\n");

						pstmt = conn.prepareStatement(sql.toString());
						
						// 테이블에 데이터 입력
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTNMANAGER USING DUAL										\n");
						sql.append("ON (EMPLYR_ID = ?)															\n");
						sql.append("WHEN MATCHED THEN															\n");
						sql.append("UPDATE SET																	\n");
						sql.append("       EMPLYR_NM = ?                                                        \n");
						sql.append("      ,moblfrist_no = ?														\n");
						sql.append("      ,moblmiddle_no = ?                                                    \n");
						sql.append("      ,moblend_no = ?                                                       \n");
						sql.append("      ,MODIFY_DATE = SYSDATE                                                \n");
						sql.append("WHEN NOT MATCHED THEN														\n");
						sql.append("INSERT (UNIQ_ID,SITE_GROUP_ID,ORGNZT_ID, EMPLYR_ID, EMPLYR_NM, moblfrist_no, moblmiddle_no, moblend_no, USER_LEVEL, USER_AUTH_CODE, LOGIN_FIRST_EVENT_YN, EMPLYR_STTUS_CODE, EMAIL_STTUS_CODE, SBSCRB_DE, MODIFY_DATE)							\n");
						sql.append("VALUES((SELECT 'USR_'||LPAD(NVL(MAX(SUBSTR(UNIQ_ID,5)),0) + 1,11,0) FROM RFC_COMTNMANAGER),'SGRP_00001',?,?,?,?,?,?,0, 'DES', '1', 'E', 'T', SYSDATE, SYSDATE)		\n");
						
						pstmt2 = conn.prepareStatement(sql.toString());

						for (Map<String, Object> dataMap : dataList) {
							if(!"".equals(dataMap.get("cell1").toString())){
								String chkId = parseNull(dataMap.get("cell1").toString(), "").trim();
								// 사용자 ID 양식 체크
								if("gne_".equals(chkId.substring(0,4))) {

									if(chkId.substring(4).length() > 5) {
										throw new Exception("[사용자ID에러] 엑셀양식을 확인해주십시오. 사용자ID는 GNE_ + 숫자5자리입니다.");
									} else {
										// 문자열 숫자 체크
										for(char ch : chkId.substring(4).toCharArray()) {
											if(!Character.isDigit(ch)){
												throw new Exception("[사용자ID에러] 엑셀양식을 확인해주십시오. 사용자ID는 GNE_ + 숫자5자리입니다.");
											}
										}
									}
								} else {
									throw new Exception("[사용자ID에러] 엑셀양식을 확인해주십시오. 사용자ID는 GNE_ + 숫자5자리입니다.");
								}

								pstmt.setString(1, parseNull(dataMap.get("cell1").toString(), "").trim());
								pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
								pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
								pstmt.setString(4, parseNull(dataMap.get("cell4").toString(), "").trim());
								pstmt.setString(5, parseNull(dataMap.get("cell1").toString(), "").trim());
								pstmt.setString(6, parseNull(dataMap.get("cell2").toString(), "").trim());
								pstmt.setString(7, parseNull(dataMap.get("cell3").toString(), "").trim());
								pstmt.setString(8, parseNull(dataMap.get("cell4").toString(), "").trim());
								pstmt.addBatch();
								
								String[] arrayTel = parseNull(dataMap.get("cell4").toString(), "000-000-0000").trim().split("-");

								pstmt2.setString(1, parseNull(dataMap.get("cell1").toString(), "").trim());
								pstmt2.setString(2, parseNull(dataMap.get("cell3").toString(), "").trim());
								//pstmt2.setString(3, ds.encrypt(arrayTel[0]));
								//pstmt2.setString(4, ds.encrypt(arrayTel[1]));
								//pstmt2.setString(5, ds.encrypt(arrayTel[2]));
								pstmt2.setString(3, arrayTel[0]);
								pstmt2.setString(4, arrayTel[1]);
								pstmt2.setString(5, arrayTel[2]);
								pstmt2.setString(6, parseNull(dataMap.get("cell2").toString(), "").trim());
								pstmt2.setString(7, parseNull(dataMap.get("cell1").toString(), "").trim());
								pstmt2.setString(8, parseNull(dataMap.get("cell3").toString(), "").trim());
								//pstmt2.setString(8, ds.encrypt(arrayTel[0]));
								//pstmt2.setString(9, ds.encrypt(arrayTel[1]));
								//pstmt2.setString(10, ds.encrypt(arrayTel[2]));
								pstmt2.setString(9, arrayTel[0]);
								pstmt2.setString(10, arrayTel[1]);
								pstmt2.setString(11, arrayTel[2]);

								pstmt2.addBatch();
							}
						}
						
						int[] count = pstmt.executeBatch();
						int[] count2 = pstmt2.executeBatch();

						result = count.length;
						
						/* sql = new StringBuffer();
						sql.append("DELETE FROM RFC_COMTCOFFICE_PART WHERE UPPER(SUBSTR(USER_ID,0,4)) = 'GNE_' AND LENGTH(USER_ID) = '9' AND MODIFY_DATE < (SELECT MAX(MODIFY_DATE) FROM RFC_COMTCOFFICE_PART) ");
						pstmt = conn.prepareStatement(sql.toString());
						rs = pstmt.executeQuery(); */
						
						/**
						*   PURPOSE :   메뉴테이블의 임시필드에 있는 아이디와 담당자테이블의 아이디를 비교하여 병합한다. 담당자가 4명까지 있을 수 있으므로 작업도 4번 한다. 부서코드 유지를 위해 pcode까지 병합한다
						*   CREATE  :   20171229_FRI   KO
						*   MODIFY  :   ....
						*/
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTNMENU A																									");	
						sql.append("USING(SELECT * FROM RFC_COMTCOFFICE_PART) B																					");	
						sql.append("ON(A.TMP_FIELD10 = B.USER_ID)																								");
						sql.append("WHEN MATCHED THEN UPDATE SET A.OFFICE_PT_SID = B.OFFICE_PT_SID, A.PCODE = A.TMP_FIELD14 WHERE A.TMP_FIELD10 = B.USER_ID		");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
						
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTNMENU A																									");	
						sql.append("USING(SELECT * FROM RFC_COMTCOFFICE_PART) B																					");	
						sql.append("ON(A.TMP_FIELD11 = B.USER_ID)																								");
						sql.append("WHEN MATCHED THEN UPDATE SET A.OFFICE_PT_SID2 = B.OFFICE_PT_SID, A.PCODE2 = A.TMP_FIELD15 WHERE A.TMP_FIELD11 = B.USER_ID	");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
						
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTNMENU A																									");	
						sql.append("USING(SELECT * FROM RFC_COMTCOFFICE_PART) B																					");	
						sql.append("ON(A.TMP_FIELD12 = B.USER_ID)																								");
						sql.append("WHEN MATCHED THEN UPDATE SET A.OFFICE_PT_SID3 = B.OFFICE_PT_SID, A.PCODE3 = A.TMP_FIELD16 WHERE A.TMP_FIELD12 = B.USER_ID	");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
						
						sql = new StringBuffer();
						sql.append("MERGE INTO RFC_COMTNMENU A																									");	
						sql.append("USING(SELECT * FROM RFC_COMTCOFFICE_PART) B																					");	
						sql.append("ON(A.TMP_FIELD13 = B.USER_ID)																								");
						sql.append("WHEN MATCHED THEN UPDATE SET A.OFFICE_PT_SID4 = B.OFFICE_PT_SID, A.PCODE4 = A.TMP_FIELD17 WHERE A.TMP_FIELD13 = B.USER_ID	");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						if(pstmt!=null){pstmt.close();}
						/* END */
						
						/**
						*   PURPOSE :   최신 데이터가 아닌 GNE_ + 9자리 아이디를 삭제한다
						*   CREATE  :   20171229_FRI   KO
						*   MODIFY  :   ....
						*/
						sql = new StringBuffer();
						sql.append("DELETE FROM RFC_COMTCOFFICE_PART WHERE MODIFY_DATE < ( 												");
						sql.append("													  SELECT MAX(TO_CHAR(MODIFY_DATE- 5/24/60, 'yyyymmdd hh24:mi:ss')) ");
						sql.append("													  FROM RFC_COMTCOFFICE_PART 					");
						sql.append("													  WHERE UPPER(SUBSTR(USER_ID,0,4)) = 'GNE_'		");
						sql.append("													  	AND LENGTH(USER_ID) = '9'					");
						sql.append("													 ) 												");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						
						sql = new StringBuffer();
						sql.append("DELETE FROM RFC_COMTNMANAGER WHERE MODIFY_DATE < ( 													");
						sql.append("													  SELECT MAX(TO_CHAR(MODIFY_DATE- 5/24/60, 'yyyymmdd hh24:mi:ss'))   ");
						sql.append("													  FROM RFC_COMTNMANAGER 						");
						sql.append("													  WHERE UPPER(SUBSTR(EMPLYR_ID,0,4)) = 'GNE_'	");
						sql.append("													  	AND LENGTH(EMPLYR_ID) = '9'					");
						sql.append("													 ) 												");
						sql.append("							AND UPPER(SUBSTR(EMPLYR_ID,0,4)) = 'GNE_' AND LENGTH(EMPLYR_ID) = '9' 	");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						/* END */
						
						/**
						*   PURPOSE :   담당자가 없는 메뉴의 PCODE를 삭제한다.
						*   CREATE  :   20171229_FRI   KO
						*   MODIFY  :   ....
						*/
						sql = new StringBuffer();
						sql.append("UPDATE RFC_COMTNMENU SET PCODE = NULL WHERE OFFICE_PT_SID = 0									");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						sql = new StringBuffer();
						sql.append("UPDATE RFC_COMTNMENU SET PCODE2 = NULL WHERE OFFICE_PT_SID2 = 0									");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						sql = new StringBuffer();
						sql.append("UPDATE RFC_COMTNMENU SET PCODE3 = NULL WHERE OFFICE_PT_SID3 = 0									");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						sql = new StringBuffer();
						sql.append("UPDATE RFC_COMTNMENU SET PCODE4 = NULL WHERE OFFICE_PT_SID4 = 0									");
						pstmt = conn.prepareStatement(sql.toString());
						pstmt.executeUpdate();
						/* END */
						
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
					out.println(e.toString());
					e.printStackTrace();
					sqlMapClient.endTransaction();
					
					out.println("<script type=\"text/javascript\">");
					out.println("alert('" + e.toString() + "');");
					out.println("history.go(-1);");
					out.println("</script>");

					//alertBack(out, "처리중 오류가 발생하였습니다."); 
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
