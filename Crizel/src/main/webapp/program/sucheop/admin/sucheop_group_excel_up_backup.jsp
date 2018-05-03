<%
/**
*   PURPOSE :   관리자 => 엑셀파일 업로드 실행 페이지
*   CREATE  :   201711??    JI
*   MODIFY  :   1)  파일등록 로그 테이블(NOTE_FILE_LOG) 저장 부분 추가    20171201_fri    JI
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/excel/_class.jsp"%>

<%
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);


String type = request.getParameter("type");     //  업로드 엑셀 type 구분 mem = 교원, group = 조직도

//  변수 선언
String writer       =       "";     //???
String group_nm     =       "";     //기관 이름

//  현재 issue ① xlsx 파일 read 못 함.....

/* file regist insert table variables */
String file_seq         =       "";     //파일 등록 고유 번호(FILE_SEQ);
String next_file_seq    =       "1";    //다음 file_seq variable
String reg_file_name    =       "";     //등록 파일 이름 따로 저장 variable
/* END */

%>

<%
    //  교원 엑셀 파일
    if (type.equals("mem")) {
       
        boolean isMultipart =   ServletFileUpload.isMultipartContent(request);
        if (isMultipart) {
            try {
        
                //  임시 저장 경로
                String tempFilePath =   getServletContext().getRealPath("/upload_data/sucheop/sucheop_mem/temp/");
                File tempFileDir    =   new File(tempFilePath);
                if (!tempFileDir.exists())  tempFileDir.mkdirs();   //  경로 생성
                //  저장 경로
                String saveFilePath =   getServletContext().getRealPath("/upload_data/sucheop/sucheop_mem/");
                File saveFileDir    =   new File(saveFilePath);
                if (!saveFileDir.exists())  saveFileDir.mkdirs();

                //  파일 형식 확인은 script 에서 하지만 다시 한번 더 체크
                String[] availableExt   =   {"xls"/*, "xlsx"*/};

                //  파일 업로드
                File uploadedFile   =   null;
                DiskFileItemFactory factory =   new DiskFileItemFactory();
                factory.setSizeThreshold(10*1024*1024);
                factory.setRepository(tempFileDir);

                ServletFileUpload upload    =   new ServletFileUpload(factory);
                upload.setSizeMax(100*1024*1024);
                upload.setHeaderEncoding("UTF-8");

                List<FileItem> items    =   upload.parseRequest(request);
                int fileCnt =   0;
                for (FileItem item : items) {
                    String fieldName    =   item.getFieldName();

                    if (item.isFormField()) {
                        if (fieldName.equals("writer")) writer  =   item.getString("UTF-8");
                    } else {
                        if (item.getSize() > 0) {
                            String fileName =   new File(item.getName()).getName();
                            if (!doCheckFileExt(fileName, availableExt)) {
                                out.println("<script type=\"text/javascript\">");
                                out.println("alert('해당 파일의 확장자는 첨부 불가능합니다.')");
                                out.println("history.back();");
                                out.println("</script>");
                            }

                            //  파일명 변경
                            fileName        =   "SUCHEOP_MEM_" + getDate("yyyyMMddHHmmss") + "_" + Integer.toString(fileCnt) + fileName.substring(fileName.lastIndexOf("."));
                            reg_file_name   =   fileName;
                            uploadedFile    =   new File(saveFileDir, fileName);
                            item.write(uploadedFile);
                        }
                    }
                }
                
                
                //  set the DB
                Connection conn         =   null;
                ResultSet rs            =   null;
                StringBuffer sql        =   null;
                String sql_str          =   "";
                PreparedStatement pstmt =   null;
                
                int key = 0;
				int result = 0;
                int fileResult  =   0;
                
                //  2nd try
                try {
                    sqlMapClient.startTransaction();
                    conn    =   sqlMapClient.getCurrentConnection();
                    
                    List<Map<String, Object>> dataList  =   getSucheopExcelRead(uploadedFile, 1);
                    
                    /*
                    *   PURPOSE :   파일 등록 내용 insert
                    *   CREATE  :   20171201_fri    JI
                    *   MODIFY  :   ....
                    */
                    
                    //next file_seq finding
                    sql     =   new StringBuffer();
                    sql_str =   "SELECT FILE_SEQ FROM NOTE_FILE_LOG WHERE ROWNUM = 1 ORDER BY FILE_SEQ DESC";
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    rs		=	pstmt.executeQuery();
                    if (rs.next()) {
                        next_file_seq   =   Integer.toString(rs.getInt("FILE_SEQ") + 1);
                    }
                    
                    out.println("<script>alert(" + next_file_seq + ")</script>");
                    
                    //insert note_file_log
                    sql     =   new StringBuffer();
                    sql_str =   "INSERT INTO NOTE_FILE_LOG ";
                    sql_str +=  " (FILE_SEQ, FILE_NM, FILE_EXT_NM, REG_DATETIME, SUCC_FLAG, SUCC_FAIL_REASON, IP_ADDR, ";
                    sql_str +=  " REG_ID, FILE_URL, CONTENT_TYPE) ";
                    sql_str +=  " VALUES ( ";
                    sql_str +=  " '"+ next_file_seq +"' ";      //file_seq
                    sql_str +=  " ,'"+ reg_file_name +"' ";          //file_nm
                    sql_str +=  " ,'"+ reg_file_name.substring(reg_file_name.lastIndexOf(".")) +"' ";     //file_ext_nm
                    sql_str +=  " ,TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ";      //reg_datetime
                    sql_str +=  " ,'Y' ";                       //succ_flag
                    sql_str +=  " ,'성공' ";                     //succ_fail_reason
                    sql_str +=  " ,'" + request.getRemoteAddr()  + "' ";        //ip_addr
                    sql_str +=  " ,'" + sessionManager.getId()  + "' ";         //reg_id
                    sql_str +=  " ,'" + saveFileDir  + "' ";                    //file_url
                    sql_str +=  " ,'교원')";                                     //content_type
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    fileResult  =   pstmt.executeUpdate();
                    
                    if (fileResult > 0) {
                    
                        //out.println(dataList);

                        if (dataList.size() > 0 && dataList != null) {
                            //query ready
                            //delete table
                            sql =   new StringBuffer();
                            sql.append("DELETE FROM NOTE_GROUP_MEM");
                            pstmt   =   conn.prepareStatement(sql.toString());
                            pstmt.executeUpdate();

                            //다음 group_seq 번호
                            int next_mem_seq    =   1;

                            sql     =   new StringBuffer();
                            sql_str =   " INSERT INTO NOTE_GROUP_MEM ";
                            sql_str +=  " (MEM_SEQ, GROUP_LIST_SEQ, MEM_NM, MEM_GRADE, MEM_LEVEL, MEM_TEL, MEM_MOBILE";
                            sql_str +=  ", MEM_SSO_ID, REG_DT, REG_HMS, SHOW_FLAG) ";
                            sql_str +=  " VALUES ";
                            sql_str +=  "(";
                            sql_str +=  "?, (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?), ?";
                            sql_str +=  ", ?, ?, ?, ?, ?";
                            sql_str +=  ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?";
                            sql_str +=  ")";
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList) {

                                //pstmt.setString(1, parseNull(dataMap.get("cell1").toString(), "").trim());
                                pstmt.setString(1, Integer.toString(next_mem_seq));
                                pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
                                pstmt.setString(4, parseNull(dataMap.get("cell4").toString(), "").trim());
                                pstmt.setString(5, parseNull(dataMap.get("cell5").toString(), "").trim());
                                pstmt.setString(6, parseNull(dataMap.get("cell6").toString(), "").trim());
                                pstmt.setString(7, parseNull(dataMap.get("cell7").toString(), "").trim());
                                pstmt.setString(8, parseNull(dataMap.get("cell8").toString(), "").trim());
                                pstmt.setString(9, parseNull(dataMap.get("cell9").toString(), "").trim());

                                pstmt.addBatch();

                                next_mem_seq++;

                            }//end for

                            int[] count   =   pstmt.executeBatch();
                            result        =   count.length;

                        }//end if
                        
                    }//end if insert note_file_log
                    
                    if (result > 0) {
                        sqlMapClient.commitTransaction();
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('정상적으로 처리 되었습니다.');");
                        out.println("location.replace('./sucheop_list.jsp');");
                        out.println("</script>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    sqlMapClient.endTransaction();

                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Exception Error GROUP 2nd try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                    out.println("history.back();");
                    out.println("</script>");
                } finally {
                    if (rs != null) try {rs.close();} catch (SQLException e) {}
                    if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                    if (conn != null) try {conn.close();} catch (SQLException e) {}
                    sqlMapClient.endTransaction();
                }// ./end 2nd try
            } catch (Exception e) {
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Exception Error GROUP 1st try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                out.println("history.back();");
                out.println("</script>");
            }
        }
        
    //  조직도 엑셀 파일
    } else if (type.equals("group")) {
        
        boolean isMultipart =   ServletFileUpload.isMultipartContent(request);
        //다음 group_seq 번호
        int next_group_seq  =   1;
        int result          =   0;
        int fileResult      =   0;
        if (isMultipart) {
            try {
        
                //  임시 저장 경로
                String tempFilePath =   getServletContext().getRealPath("/upload_data/sucheop/sucheop_group/temp/");
                File tempFileDir    =   new File(tempFilePath);
                if (!tempFileDir.exists())  tempFileDir.mkdirs();   //  경로 생성
                //  저장 경로
                String saveFilePath =   getServletContext().getRealPath("/upload_data/sucheop/sucheop_group/");
                File saveFileDir    =   new File(saveFilePath);
                if (!saveFileDir.exists())  saveFileDir.mkdirs();

                //  파일 형식 확인은 script 에서 하지만 다시 한번 더 체크
                String[] availableExt   =   {"xls"/*, "xlsx"*/};

                //  파일 업로드
                File uploadedFile   =   null;
                DiskFileItemFactory factory =   new DiskFileItemFactory();
                factory.setSizeThreshold(10*1024*1024);
                factory.setRepository(tempFileDir);

                ServletFileUpload upload    =   new ServletFileUpload(factory);
                upload.setSizeMax(100*1024*1024);
                upload.setHeaderEncoding("UTF-8");

                List<FileItem> items    =   upload.parseRequest(request);
                int fileCnt =   0;
                for (FileItem item : items) {
                    String fieldName    =   item.getFieldName();

                    if (item.isFormField()) {
                        if (fieldName.equals("writer")) writer  =   item.getString("UTF-8");
                    } else {
                        if (item.getSize() > 0) {
                            String fileName =   new File(item.getName()).getName();
                            if (!doCheckFileExt(fileName, availableExt)) {
                                out.println("<script type=\"text/javascript\">");
                                out.println("alert('해당 파일의 확장자는 첨부 불가능합니다.')");
                                out.println("history.back();");
                                out.println("</script>");
                            }

                            //  파일명 변경
                            fileName        =   "SUCHEOP_GROUP_" + getDate("yyyyMMddHHmmss") + "_" + Integer.toString(fileCnt) + fileName.substring(fileName.lastIndexOf("."));
                            reg_file_name   =   fileName;
                            uploadedFile    =   new File(saveFileDir, fileName);
                            item.write(uploadedFile);
                        }
                    }
                }

                //  set the DB
                Connection conn         =   null;
                ResultSet rs            =   null;
                StringBuffer sql        =   null;
                String sql_str          =   "";
                PreparedStatement pstmt =   null;
                
                int key = 0;
                
                //  2nd try 1st try
                try {
                    sqlMapClient.startTransaction();
                    conn    =   sqlMapClient.getCurrentConnection();
                    
                    List<Map<String, Object>> dataList  =   getExcelRead(uploadedFile, 1);
                    
                    /*
                    *   PURPOSE :   파일 등록 내용 insert
                    *   CREATE  :   20171201_fri    JI
                    *   MODIFY  :   ....
                    */
                    
                    //next file_seq finding
                    sql     =   new StringBuffer();
                    sql_str =   "SELECT FILE_SEQ FROM NOTE_FILE_LOG WHERE ROWNUM = 1 ORDER BY FILE_SEQ DESC";
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    rs		=	pstmt.executeQuery();
                    if (rs.next()) {
                        next_file_seq   =   Integer.toString(rs.getInt("FILE_SEQ") + 1);
                    }
                    
                    out.println("<script>alert(" + next_file_seq + ")</script>");
                    
                    //insert note_file_log
                    sql     =   new StringBuffer();
                    sql_str =   "INSERT INTO NOTE_FILE_LOG ";
                    sql_str +=  " (FILE_SEQ, FILE_NM, FILE_EXT_NM, REG_DATETIME, SUCC_FLAG, SUCC_FAIL_REASON, IP_ADDR, ";
                    sql_str +=  " REG_ID, FILE_URL, CONTENT_TYPE) ";
                    sql_str +=  " VALUES ( ";
                    sql_str +=  " '"+ next_file_seq +"' ";      //file_seq
                    sql_str +=  " ,'"+ reg_file_name +"' ";          //file_nm
                    sql_str +=  " ,'"+ reg_file_name.substring(reg_file_name.lastIndexOf(".")) +"' ";     //file_ext_nm
                    sql_str +=  " ,TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ";      //reg_datetime
                    sql_str +=  " ,'Y' ";                       //succ_flag
                    sql_str +=  " ,'성공' ";                     //succ_fail_reason
                    sql_str +=  " ,'" + request.getRemoteAddr()  + "' ";        //ip_addr
                    sql_str +=  " ,'" + sessionManager.getId()  + "' ";         //reg_id
                    sql_str +=  " ,'" + saveFileDir  + "' ";                    //file_url
                    sql_str +=  " ,'기관')";                                     //content_type
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    fileResult  =   pstmt.executeUpdate();
                    
                    if (fileResult > 0) {
                    
                        if (dataList.size() > 0 && dataList != null) {
                            //query ready
                            //delete table
                            sql =   new StringBuffer();
                            sql.append("DELETE FROM NOTE_GROUP_LIST");
                            pstmt   =   conn.prepareStatement(sql.toString());
                            pstmt.executeUpdate();

                            //  미리 쿼리 짜놈.....
                            sql =   new StringBuffer();
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR, TEL1, TEL2, TEL3, FAX, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ?, ?";
                            String sql_str2 =   ", ?";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList) {

                                if (parseNull(dataMap.get("cell3").toString(), "").trim().equals("1")) {
                                pstmt.setString(1, Integer.toString(next_group_seq));
                                pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
                                pstmt.setString(4, parseNull(dataMap.get("cell3").toString(), "").trim());

                                //1lv insert
                                pstmt.setString(5, "-1");

                                pstmt.setString(6, parseNull(dataMap.get("cell5").toString(), "").trim());
                                pstmt.setString(7, parseNull(dataMap.get("cell6").toString(), "").trim());
                                pstmt.setString(8, parseNull(dataMap.get("cell7").toString(), "").trim());
                                pstmt.setString(9, parseNull(dataMap.get("cell8").toString(), "").trim());
                                pstmt.setString(10, parseNull(dataMap.get("cell9").toString(), "").trim());
                                pstmt.setString(11, parseNull(dataMap.get("cell10").toString(), "").trim());
                                pstmt.setString(12, parseNull(dataMap.get("cell11").toString(), "").trim());
                                pstmt.setString(13, parseNull(dataMap.get("cell12").toString(), "").trim());
                                pstmt.setString(14, parseNull(dataMap.get("cell13").toString(), "").trim());

                                pstmt.addBatch();
                                next_group_seq++;
                                }//end if
                            }//end for
                            //run the batch
                            int[] count1    =   pstmt.executeBatch();
                            result          =   count1.length;
                        }//end if
                        
                    }//end if insert note_file_log
                } catch (Exception e) {
                    e.printStackTrace();
                    sqlMapClient.endTransaction();

                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Exception Error GROUP 2nd try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
//                    out.println("history.back();");
                    out.println("</script>");
                } finally {
                    if (rs != null) try {rs.close();} catch (SQLException e) {}
                    if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                    if (conn != null) try {conn.close();} catch (SQLException e) {}
                    sqlMapClient.endTransaction();
                }// ./end 2nd try
                // 2nd batch
                if (result > 0) {
                    result      =   0;
                    //  2nd try 2nd try
                    try {
                        sqlMapClient.startTransaction();
                        conn    =   sqlMapClient.getCurrentConnection();

                        List<Map<String, Object>> dataList2  =   getExcelRead(uploadedFile, 1);

                        if (dataList2.size() > 0 && dataList2 != null) {

                            //  미리 쿼리 짜놈.....
                            sql =   new StringBuffer();
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR, TEL1, TEL2, TEL3, FAX, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ?, ?";
                            String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList2) {

                                if (parseNull(dataMap.get("cell3").toString(), "").trim().equals("2")) {
                                pstmt.setString(1, Integer.toString(next_group_seq));
                                pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
                                pstmt.setString(4, parseNull(dataMap.get("cell3").toString(), "").trim());

                                //2lv insert
                                pstmt.setString(5, parseNull(dataMap.get("cell4").toString(), "").trim());

                                pstmt.setString(6, parseNull(dataMap.get("cell5").toString(), "").trim());
                                pstmt.setString(7, parseNull(dataMap.get("cell6").toString(), "").trim());
                                pstmt.setString(8, parseNull(dataMap.get("cell7").toString(), "").trim());
                                pstmt.setString(9, parseNull(dataMap.get("cell8").toString(), "").trim());
                                pstmt.setString(10, parseNull(dataMap.get("cell9").toString(), "").trim());
                                pstmt.setString(11, parseNull(dataMap.get("cell10").toString(), "").trim());
                                pstmt.setString(12, parseNull(dataMap.get("cell11").toString(), "").trim());
                                pstmt.setString(13, parseNull(dataMap.get("cell12").toString(), "").trim());
                                pstmt.setString(14, parseNull(dataMap.get("cell13").toString(), "").trim());

                                pstmt.addBatch();
                                next_group_seq++;
                                }//end if
                            }//end for
                            //run the batch
                            int[] count2    =   pstmt.executeBatch();
                            result          =   count2.length;
                        }//end if
                    } catch (Exception e) {
                        e.printStackTrace();
                        sqlMapClient.endTransaction();

                        out.println("<script type=\"text/javascript\">"); 
                        out.println("alert('Exception Error GROUP 22nd try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                        out.println("history.back();");
                        out.println("</script>");
                    } finally {
                        if (rs != null) try {rs.close();} catch (SQLException e) {}
                        if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                        if (conn != null) try {conn.close();} catch (SQLException e) {}
                        sqlMapClient.endTransaction();
                    }// ./end 2nd try
                    // 3rd batch
                    if (result > 0) {
                        result      =   0;
                        //  2nd try
                        try {
                            sqlMapClient.startTransaction();
                            conn    =   sqlMapClient.getCurrentConnection();

                            List<Map<String, Object>> dataList3  =   getExcelRead(uploadedFile, 1);

                            if (dataList3.size() > 0 && dataList3 != null) {

                                //  미리 쿼리 짜놈.....
                                sql =   new StringBuffer();
                                String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR, TEL1, TEL2, TEL3, FAX, URL, ALIMI, SHOW_FLAG) ";
                                sql_str1 +=  " VALUES ( ?, ?, ?, ?";
                                String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";
                                String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                                sql_str     =   sql_str1 + sql_str2 + sql_str3;
                                sql.append(sql_str);
                                pstmt   =   conn.prepareStatement(sql.toString());

                                for (Map<String, Object> dataMap : dataList3) {

                                    if (parseNull(dataMap.get("cell3").toString(), "").trim().equals("3")) {
                                    pstmt.setString(1, Integer.toString(next_group_seq));
                                    pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                    pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
                                    pstmt.setString(4, parseNull(dataMap.get("cell3").toString(), "").trim());

                                    //2lv insert
                                    pstmt.setString(5, parseNull(dataMap.get("cell4").toString(), "").trim());

                                    pstmt.setString(6, parseNull(dataMap.get("cell5").toString(), "").trim());
                                    pstmt.setString(7, parseNull(dataMap.get("cell6").toString(), "").trim());
                                    pstmt.setString(8, parseNull(dataMap.get("cell7").toString(), "").trim());
                                    pstmt.setString(9, parseNull(dataMap.get("cell8").toString(), "").trim());
                                    pstmt.setString(10, parseNull(dataMap.get("cell9").toString(), "").trim());
                                    pstmt.setString(11, parseNull(dataMap.get("cell10").toString(), "").trim());
                                    pstmt.setString(12, parseNull(dataMap.get("cell11").toString(), "").trim());
                                    pstmt.setString(13, parseNull(dataMap.get("cell12").toString(), "").trim());
                                    pstmt.setString(14, parseNull(dataMap.get("cell13").toString(), "").trim());

                                    pstmt.addBatch();
                                    next_group_seq++;
                                    }//end if
                                }//end for
                                //run the batch
                                int[] count3    =   pstmt.executeBatch();
                                result          =   count3.length;
                                
                            }//end if
                        } catch (Exception e) {
                            e.printStackTrace();
                            sqlMapClient.endTransaction();

                            out.println("<script type=\"text/javascript\">"); 
                            out.println("alert('Exception Error GROUP 22nd try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                            out.println("history.back();");
                            out.println("</script>");
                        } finally {
                            if (rs != null) try {rs.close();} catch (SQLException e) {}
                            if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                            if (conn != null) try {conn.close();} catch (SQLException e) {}
                            sqlMapClient.endTransaction();
                        }// ./end 2nd try
                        // 4th batch
                        if (result > 0) {
                            result      =   0;
                            //  2nd try
                            try {
                                sqlMapClient.startTransaction();
                                conn    =   sqlMapClient.getCurrentConnection();

                                List<Map<String, Object>> dataList4  =   getExcelRead(uploadedFile, 1);

                                if (dataList4.size() > 0 && dataList4 != null) {

                                    //  미리 쿼리 짜놈.....
                                    sql =   new StringBuffer();
                                    String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR, TEL1, TEL2, TEL3, FAX, URL, ALIMI, SHOW_FLAG) ";
                                    sql_str1 +=  " VALUES ( ?, ?, ?, ?";
                                    String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";
                                    String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                                    sql_str     =   sql_str1 + sql_str2 + sql_str3;
                                    sql.append(sql_str);
                                    pstmt   =   conn.prepareStatement(sql.toString());

                                    for (Map<String, Object> dataMap : dataList4) {

                                        if (parseNull(dataMap.get("cell3").toString(), "").trim().equals("4")) {
                                        pstmt.setString(1, Integer.toString(next_group_seq));
                                        pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                        pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
                                        pstmt.setString(4, parseNull(dataMap.get("cell3").toString(), "").trim());

                                        //2lv insert
                                        pstmt.setString(5, parseNull(dataMap.get("cell4").toString(), "").trim());

                                        pstmt.setString(6, parseNull(dataMap.get("cell5").toString(), "").trim());
                                        pstmt.setString(7, parseNull(dataMap.get("cell6").toString(), "").trim());
                                        pstmt.setString(8, parseNull(dataMap.get("cell7").toString(), "").trim());
                                        pstmt.setString(9, parseNull(dataMap.get("cell8").toString(), "").trim());
                                        pstmt.setString(10, parseNull(dataMap.get("cell9").toString(), "").trim());
                                        pstmt.setString(11, parseNull(dataMap.get("cell10").toString(), "").trim());
                                        pstmt.setString(12, parseNull(dataMap.get("cell11").toString(), "").trim());
                                        pstmt.setString(13, parseNull(dataMap.get("cell12").toString(), "").trim());
                                        pstmt.setString(14, parseNull(dataMap.get("cell13").toString(), "").trim());

                                        pstmt.addBatch();
                                        next_group_seq++;
                                        }//end if
                                    }//end for
                                    //run the batch
                                    int[] count4    =   pstmt.executeBatch();
                                    result          =   count4.length;

                                }//end if
                            } catch (Exception e) {
                                e.printStackTrace();
                                sqlMapClient.endTransaction();

                                out.println("<script type=\"text/javascript\">"); 
                                out.println("alert('Exception Error GROUP 22nd try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                                out.println("history.back();");
                                out.println("</script>");
                            } finally {
                                if (rs != null) try {rs.close();} catch (SQLException e) {}
                                if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                                if (conn != null) try {conn.close();} catch (SQLException e) {}
                                sqlMapClient.endTransaction();
                            }// ./end 2nd try
                        }
                        // 5th batch
                        if (result > 0) {
                            result      =   0;
                            //  2nd try
                            try {
                                sqlMapClient.startTransaction();
                                conn    =   sqlMapClient.getCurrentConnection();

                                List<Map<String, Object>> dataList5  =   getExcelRead(uploadedFile, 1);

                                if (dataList5.size() > 0 && dataList5 != null) {

                                    //  미리 쿼리 짜놈.....
                                    sql =   new StringBuffer();
                                    String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR, TEL1, TEL2, TEL3, FAX, URL, ALIMI, SHOW_FLAG) ";
                                    sql_str1 +=  " VALUES ( ?, ?, ?, ?";
                                    String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";
                                    String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                                    sql_str     =   sql_str1 + sql_str2 + sql_str3;
                                    sql.append(sql_str);
                                    pstmt   =   conn.prepareStatement(sql.toString());

                                    for (Map<String, Object> dataMap : dataList5) {

                                        if (parseNull(dataMap.get("cell3").toString(), "").trim().equals("5")) {
                                        pstmt.setString(1, Integer.toString(next_group_seq));
                                        pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                        pstmt.setString(3, parseNull(dataMap.get("cell3").toString(), "").trim());
                                        pstmt.setString(4, parseNull(dataMap.get("cell3").toString(), "").trim());

                                        //2lv insert
                                        pstmt.setString(5, parseNull(dataMap.get("cell4").toString(), "").trim());

                                        pstmt.setString(6, parseNull(dataMap.get("cell5").toString(), "").trim());
                                        pstmt.setString(7, parseNull(dataMap.get("cell6").toString(), "").trim());
                                        pstmt.setString(8, parseNull(dataMap.get("cell7").toString(), "").trim());
                                        pstmt.setString(9, parseNull(dataMap.get("cell8").toString(), "").trim());
                                        pstmt.setString(10, parseNull(dataMap.get("cell9").toString(), "").trim());
                                        pstmt.setString(11, parseNull(dataMap.get("cell10").toString(), "").trim());
                                        pstmt.setString(12, parseNull(dataMap.get("cell11").toString(), "").trim());
                                        pstmt.setString(13, parseNull(dataMap.get("cell12").toString(), "").trim());
                                        pstmt.setString(14, parseNull(dataMap.get("cell13").toString(), "").trim());

                                        pstmt.addBatch();
                                        next_group_seq++;
                                        }//end if
                                    }//end for
                                    //run the batch
                                    int[] count5    =   pstmt.executeBatch();
                                    result          =   count5.length;
                                    
                                    if (result > 0) {
                                        sqlMapClient.commitTransaction();
                                        out.println("<script type=\"text/javascript\">");
                                        out.println("alert('정상적으로 처리 되었습니다.');");
                                        out.println("location.replace('./sucheop_group.jsp');");
                                        out.println("</script>");
                                    }

                                }//end if
                            } catch (Exception e) {
                                e.printStackTrace();
                                sqlMapClient.endTransaction();

                                out.println("<script type=\"text/javascript\">"); 
                                out.println("alert('Exception Error GROUP 22nd try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                                out.println("history.back();");
                                out.println("</script>");
                            } finally {
                                if (rs != null) try {rs.close();} catch (SQLException e) {}
                                if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                                if (conn != null) try {conn.close();} catch (SQLException e) {}
                                sqlMapClient.endTransaction();
                            }// ./end 2nd try
                        }
                    }
                }
                
            } catch (Exception e) {
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Exception Error GROUP 1st try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
//                out.println("history.back();");
                out.println("</script>");
            }
        }
        
    } else {
        out.println("<script type=\"text/javascript\">");
        out.println("alert('MultiPart Parameter Error : 파라미터 오류가 발생하였습니다.\n개발 담당자에게 문의하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }// ./end type if sentence
%>