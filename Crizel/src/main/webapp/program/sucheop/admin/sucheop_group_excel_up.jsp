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

String type     =   request.getParameter("type");     //  업로드 엑셀 type 구분 mem = 교원, group = 조직도

//  변수 선언
String writer       =       "";     //???
String group_nm     =       "";     //기관 이름
String oldFileName  =       "";     //PC 에서 upload 한 파일 이름

//  현재 issue ① xlsx 파일 read 못 함.....

/* file regist insert table variables */
String file_seq         =       "";     //파일 등록 고유 번호(FILE_SEQ);
String next_file_seq    =       "1";    //다음 file_seq variable
String reg_file_name    =       "";     //등록 파일 이름 따로 저장 variable
/* END */
/* error chk variable */
int error_cnt           =       0;
/* END */

%>

<%
    
    
    /* session chk */
    if (sessionManager.getId().length() < 1) {
        out.println("<script type=\"text/javascript\">");
        out.println("alert('세션이 만료되어서 처리가 불가합니다. 다시 로그인한 후 처리 해주세요.');");
        out.println("history.back();");
        out.println("</script>");
        return;
    }
    /* END */
    
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
                            oldFileName     =   fileName;
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
                Connection conn5        =   null;
                ResultSet rs            =   null;
                ResultSet rs5           =   null;
                StringBuffer sql        =   null;
                StringBuffer sql5       =   null;
                String sql_str          =   "";
                String sql_str5         =   "";
                PreparedStatement pstmt =   null;
                PreparedStatement pstmt5 =   null;
                
                int key = 0;
				int result = 0;
                int fileResult  =   0;
                
                //  2nd try
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
                    
                    //insert note_file_log
                    sql     =   new StringBuffer();
                    sql_str =   "INSERT INTO NOTE_FILE_LOG ";
                    sql_str +=  " (FILE_SEQ, FILE_NM, FILE_EXT_NM, REG_DATETIME, SUCC_FLAG, SUCC_FAIL_REASON, IP_ADDR, ";
                    sql_str +=  " REG_ID, FILE_URL, CONTENT_TYPE) ";
                    sql_str +=  " VALUES ( ";
                    sql_str +=  " '"+ next_file_seq +"' ";                      //file_seq
                    sql_str +=  " ,'"+ oldFileName +"' ";                       //file_nm
                    sql_str +=  " ,'"+ reg_file_name.substring(reg_file_name.lastIndexOf(".")) +"' ";     //file_ext_nm
                    sql_str +=  " ,TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ";      //reg_datetime
                    sql_str +=  " ,'Y' ";                                       //succ_flag
                    sql_str +=  " ,'성공' ";                                     //succ_fail_reason
                    sql_str +=  " ,'" + request.getRemoteAddr()  + "' ";        //ip_addr
                    sql_str +=  " ,'" + sessionManager.getId()  + "' ";         //reg_id
                    sql_str +=  " ,'" + saveFileDir  + "' ";                    //file_url
                    sql_str +=  " ,'교원')";                                     //content_type
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    fileResult  =   pstmt.executeUpdate();
                    
                    if (fileResult > 0) {
                    
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
                            sql_str +=  " ( ?";
                            
                            sql_str +=  "   ,(SELECT group_seq from ( select ";
                            sql_str +=  "   group_seq ";
                            sql_str +=  "   , SUBSTR(SYS_CONNECT_BY_PATH(group_nm,'_'), 2) as full_name ";
                            sql_str +=  "   , CONNECT_BY_ROOT group_seq as root_group ";
                            sql_str +=  "   from note_group_list ";
                            sql_str +=  "   start with parent_seq = '-1' ";
                            sql_str +=  "   CONNECT BY prior group_seq = parent_seq ";
                            sql_str +=  "   order by group_seq asc, group_lv asc) A ";
                            sql_str +=  "   WHERE A.full_name = ? )";
                            
                            sql_str +=  " , ?, ?";
                            sql_str +=  " , ?, ?, ?, ?";
                            sql_str +=  " , TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?";
                            sql_str +=  " ) ";
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList) {

                                pstmt.setString(1, Integer.toString(next_mem_seq));
                                
/*************************************
                                *   PURPOSE :   엑셀파일 내용 변경으로 인하여 소스 추가
                                *   CREATE  :   20171205_tue    JI
                                *   MODIFY  :   ....
                                **/
                                String chkGroupName     =   parseNull(dataMap.get("cell2").toString(), "");
                                if (parseNull(dataMap.get("cell3").toString(), "").length() > 0) {
                                    chkGroupName            +=  "_" + parseNull(dataMap.get("cell3").toString(), "");
                                }
                                if (parseNull(dataMap.get("cell4").toString(), "").length() > 0) {
                                    chkGroupName            +=  "_" + parseNull(dataMap.get("cell4").toString(), "");
                                }
                                if (parseNull(dataMap.get("cell5").toString(), "").length() > 0) {
                                    chkGroupName            +=  "_" + parseNull(dataMap.get("cell5").toString(), "");
                                }
                                if (parseNull(dataMap.get("cell6").toString(), "").length() > 0) {
                                    chkGroupName            +=  "_" + parseNull(dataMap.get("cell6").toString(), "");
                                }
                                String whereGroupName   =   "";
                                
                                for (int i = 6; i > 1; i--) {
                                    if (parseNull(dataMap.get("cell" + Integer.toString(i)).toString(), "").length() > 0) {
                                        whereGroupName  =   parseNull(dataMap.get("cell" + Integer.toString(i)).toString(), "");
                                        break;
                                    }
                                }
                                pstmt.setString(2, chkGroupName);

/************************************************* END ********************/
                                
                                pstmt.setString(3, parseNull(dataMap.get("cell7").toString(), "").trim());
                                pstmt.setString(4, parseNull(dataMap.get("cell8").toString(), "").trim());
                                pstmt.setString(5, parseNull(dataMap.get("cell9").toString(), "").trim());
                                pstmt.setString(6, parseNull(dataMap.get("cell10").toString(), "").trim());
                                pstmt.setString(7, parseNull(dataMap.get("cell11").toString(), "").trim());
                                pstmt.setString(8, parseNull(dataMap.get("cell12").toString(), "").trim());
                                pstmt.setString(9, parseNull(dataMap.get("cell13").toString(), "").trim());

                                //out.println("dataMap :: " + dataMap + "<br>");
                                
                                pstmt.addBatch();

                                next_mem_seq++;
                                error_cnt++;

                            }//end for

                            int[] count   =   pstmt.executeBatch();
                            result        =   count.length;
                            
                            out.println("result :: " + Integer.toString(result));

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
                    
                    //오류 등록 쿼리 확인
                    sql     =   new StringBuffer();
                    sql_str =   "UPDATE NOTE_FILE_LOG SET SUCC_FLAG = 'N', SUCC_FAIL_REASON = '"+ error_cnt +"번 회원입력 중 오류 발생' WHERE FILE_SEQ = " + next_file_seq;
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    pstmt.executeUpdate();
                    
                    e.printStackTrace();
                    sqlMapClient.endTransaction();

                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Exception Error GROUP 2nd try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
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
                out.println("alert('Exception Error GROUP 1st try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                out.println("history.back();");
                out.println("</script>");
            }
        }
        
    //  조직도 엑셀 파일
    } else if (type.equals("group")) {
        
        boolean isMultipart =   ServletFileUpload.isMultipartContent(request);
        //다음 group_seq 번호
        int next_group_seq  =   1;
        int fileResult      =   0;
        int result          =   0;
        int result1         =   0;
        int result2         =   0;
        int result3         =   0;
        int result4         =   0;
        int result5         =   0;
        int tmpCnt1         =   1;
        int tmpCnt2         =   1;
        String tmpParent2   =   "";
        int tmpCnt3         =   1;
        String tmpParent3   =   "";
        int tmpCnt4         =   1;
        String tmpParent4   =   "";
        int tmpCnt5         =   1;
        String tmpParent5   =   "";
        
        
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
                            oldFileName     =   fileName;
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
                Connection conn             =   null;
                Connection conn5            =   null;
                ResultSet rs                =   null;
                ResultSet rs5               =   null;
                StringBuffer sql            =   null;
                StringBuffer sql5           =   null;
                String sql_str              =   "";
                String sql_str5             =   "";
                PreparedStatement pstmt     =   null;
                PreparedStatement pstmt5    =   null;
                
                
                int key = 0;
                
/********************************************************************************************************************************/
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

                    //insert note_file_log
                    sql     =   new StringBuffer();
                    sql_str =   "INSERT INTO NOTE_FILE_LOG ";
                    sql_str +=  " (FILE_SEQ, FILE_NM, FILE_EXT_NM, REG_DATETIME, SUCC_FLAG, SUCC_FAIL_REASON, IP_ADDR, ";
                    sql_str +=  " REG_ID, FILE_URL, CONTENT_TYPE) ";
                    sql_str +=  " VALUES ( ";
                    sql_str +=  " '"+ next_file_seq +"' ";      //file_seq
                    sql_str +=  " ,'"+ oldFileName +"' ";          //file_nm
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
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR_POST, ADDR, TEL1, TEL2, TEL3, TEL4, FAX, FAX2, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ?";
                            sql_str1 +=  " , ?";
                            String sql_str2 =   ", ?";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList) {

                                if (parseNull(dataMap.get("cell2").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell3").toString(), "").trim().length() < 1 && parseNull(dataMap.get("cell4").toString(), "").trim().length() < 1 && parseNull(dataMap.get("cell5").toString(), "").trim().length() < 1 && parseNull(dataMap.get("cell6").toString(), "").trim().length() < 1) {

                                pstmt.setString(1, Integer.toString(next_group_seq));
                                pstmt.setString(2, parseNull(dataMap.get("cell2").toString(), "").trim());
                                pstmt.setString(3, "1");
                                pstmt.setString(4, Integer.toString(tmpCnt1));

                                //1lv insert
                                pstmt.setString(5, "-1");

                                pstmt.setString(6, parseNull(dataMap.get("cell7").toString(), "").trim());      //school_flag
                                pstmt.setString(7, parseNull(dataMap.get("cell8").toString(), "").trim());      //addr_post
                                pstmt.setString(8, parseNull(dataMap.get("cell9").toString(), "").trim());      //addr
                                pstmt.setString(9, parseNull(dataMap.get("cell10").toString(), "").trim());      //tel1
                                pstmt.setString(10, parseNull(dataMap.get("cell11").toString(), "").trim());     //tel2
                                pstmt.setString(11, parseNull(dataMap.get("cell12").toString(), "").trim());    //tel3
                                pstmt.setString(12, parseNull(dataMap.get("cell13").toString(), "").trim());    //tel4
                                pstmt.setString(13, parseNull(dataMap.get("cell14").toString(), "").trim());    //fax
                                pstmt.setString(14, parseNull(dataMap.get("cell15").toString(), "").trim());    //fax2
                                pstmt.setString(15, parseNull(dataMap.get("cell16").toString(), "").trim());    //url
                                pstmt.setString(16, parseNull(dataMap.get("cell17").toString(), "").trim());    //alimi
                                pstmt.setString(17, parseNull(dataMap.get("cell18").toString(), "").trim());    //show_flag

                                pstmt.addBatch();
                                tmpCnt1++;
                                next_group_seq++;
                                
                                error_cnt++;
                                
                                }//end if
                            }//end for
                            //run the batch
                            int[] count1    =   pstmt.executeBatch();
                            result1         =   count1.length;
                        }//end if
                        if (result1 < 1) {
                            sqlMapClient.commitTransaction();
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('1레벨이 없습니다. 다시 확인 해주세요.');");
                            out.println("location.replace('./sucheop_group.jsp');");
                            out.println("</script>");
                        }

                    }//end if insert note_file_log
                } catch (Exception e) {
                    //오류 등록 쿼리 확인
                    sql     =   new StringBuffer();
                    sql_str =   "UPDATE NOTE_FILE_LOG SET SUCC_FLAG = 'N', SUCC_FAIL_REASON = '"+error_cnt+"번 1레벨 기관 입력 중 오류 발생' WHERE FILE_SEQ = " + next_file_seq;
                    sql.append(sql_str);
                    pstmt   =   conn.prepareStatement(sql.toString());
                    pstmt.executeUpdate();
                    e.printStackTrace();
                    sqlMapClient.endTransaction();

                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Exception Error GROUP 2nd try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                    out.println("history.back();");
                    out.println("</script>");
                } finally {
                    if (rs != null) try {rs.close();} catch (SQLException e) {}
                    if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                    if (conn != null) try {conn.close();} catch (SQLException e) {}
                    sqlMapClient.endTransaction();
                }// ./end 2nd try
                
/********************************************************************************************************************************/
                // 2nd batch
                if (result1 > 0) {
                    result2     =   0;
                    //  2nd try 2nd try
                    
                    try {
                        sqlMapClient.startTransaction();
                        conn    =   sqlMapClient.getCurrentConnection();
                        
                        //다음 번호 찾기
                        sql =   new StringBuffer();
                        sql.append("select group_seq from (select * from note_group_list order by group_seq desc) where rownum = 1");
                        pstmt   =   conn.prepareStatement(sql.toString());
                        rs		=	pstmt.executeQuery();
                        if (rs.next()) {
                            next_group_seq   =   rs.getInt("GROUP_SEQ") + 1;
                        }

                        List<Map<String, Object>> dataList2  =   getExcelRead(uploadedFile, 1);

                        if (dataList2.size() > 0 && dataList2 != null) {

                            //  미리 쿼리 짜놈.....
                            sql =   new StringBuffer();
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR_POST, ADDR, TEL1, TEL2, TEL3, TEL4, FAX, FAX2, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ? ";
                            sql_str1 +=  " , ?";
                            String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList2) {

                                if (parseNull(dataMap.get("cell2").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell3").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell4").toString(), "").trim().length() < 1 && parseNull(dataMap.get("cell5").toString(), "").trim().length() < 1 && parseNull(dataMap.get("cell6").toString(), "").trim().length() < 1) {
                                
                                    pstmt.setString(1, Integer.toString(next_group_seq));
                                    pstmt.setString(2, parseNull(dataMap.get("cell3").toString(), "").trim());
                                    pstmt.setString(3, "2");
                                    if (!tmpParent2.equals(parseNull(dataMap.get("cell2").toString(), "").trim())) {
                                        tmpParent2  =   parseNull(dataMap.get("cell2").toString(), "").trim();
                                        tmpCnt2     =   1;
                                    }
                                    pstmt.setString(4, Integer.toString(tmpCnt2));

                                    //2lv insert
                                    pstmt.setString(5, parseNull(dataMap.get("cell2").toString(), "").trim());

                                    pstmt.setString(6, parseNull(dataMap.get("cell7").toString(), "").trim());      //school_flag
                                    pstmt.setString(7, parseNull(dataMap.get("cell8").toString(), "").trim());      //addr_post
                                    pstmt.setString(8, parseNull(dataMap.get("cell9").toString(), "").trim());      //addr
                                    pstmt.setString(9, parseNull(dataMap.get("cell10").toString(), "").trim());     //tel1
                                    pstmt.setString(10, parseNull(dataMap.get("cell11").toString(), "").trim());    //tel2
                                    pstmt.setString(11, parseNull(dataMap.get("cell12").toString(), "").trim());    //tel3
                                    pstmt.setString(12, parseNull(dataMap.get("cell13").toString(), "").trim());    //tel4
                                    pstmt.setString(13, parseNull(dataMap.get("cell14").toString(), "").trim());    //fax
                                    pstmt.setString(14, parseNull(dataMap.get("cell15").toString(), "").trim());    //fax2
                                    pstmt.setString(15, parseNull(dataMap.get("cell16").toString(), "").trim());    //url
                                    pstmt.setString(16, parseNull(dataMap.get("cell17").toString(), "").trim());    //alimi
                                    pstmt.setString(17, parseNull(dataMap.get("cell18").toString(), "").trim());    //show_flag

                                    pstmt.addBatch();
                                    tmpCnt2++;
                                    next_group_seq++;
                                    
                                    error_cnt++;
                                }//end if
                            }//end for
                            //run the batch
                            int[] count2    =   pstmt.executeBatch();
                            result2         =   count2.length;
                        }//end if
                        if (result1 > 0 && result2 < 1) {
                            sqlMapClient.commitTransaction();
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('2레벨까지 정상적으로 처리 되었습니다. 수고하셨습니다.');");
                            out.println("location.replace('./sucheop_group.jsp');");
                            out.println("</script>");
                        }
                        
                    } catch (Exception e) {
                    //오류 등록 쿼리 확인
                        sql     =   new StringBuffer();
                        sql_str =   "UPDATE NOTE_FILE_LOG SET SUCC_FLAG = 'N', SUCC_FAIL_REASON = '"+error_cnt+"번 2레벨 기관 입력 중 오류 발생' WHERE FILE_SEQ = " + next_file_seq;
                        sql.append(sql_str);
                        pstmt   =   conn.prepareStatement(sql.toString());
                        pstmt.executeUpdate();
                        e.printStackTrace();
                        sqlMapClient.endTransaction();

                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Exception Error GROUP 2nd 22nd try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                        out.println("history.back();");
                        out.println("</script>");
                    } finally {
                        if (rs != null) try {rs.close();} catch (SQLException e) {}
                        if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                        if (conn != null) try {conn.close();} catch (SQLException e) {}
                        sqlMapClient.endTransaction();
                    }// ./end 2nd try
                    
                }//END if (level == 2)
/********************************************************************************************************************************/
                // 3rd batch
                if (result2 > 0) {
                    result3     =   0;
                    //  2nd try
                    try {
                        sqlMapClient.startTransaction();
                        conn    =   sqlMapClient.getCurrentConnection();
                        
                        //다음 번호 찾기
                        sql =   new StringBuffer();
                        sql.append("select group_seq from (select * from note_group_list order by group_seq desc) where rownum = 1");
                        pstmt   =   conn.prepareStatement(sql.toString());
                        rs		=	pstmt.executeQuery();
                        if (rs.next()) {
                            next_group_seq   =   rs.getInt("GROUP_SEQ") + 1;
                        }

                        List<Map<String, Object>> dataList3  =   getExcelRead(uploadedFile, 1);

                        if (dataList3.size() > 0 && dataList3 != null) {

                            //  미리 쿼리 짜놈.....
                            sql =   new StringBuffer();
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR_POST, ADDR, TEL1, TEL2, TEL3, TEL4, FAX, FAX2, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ? ";
                            
                            sql_str1 +=  " , ?";
                            /*String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";*/
                            String sql_str2 =   ", (SELECT A.group_seq from ";     //parent_seq
                            sql_str2    +=  " (select ";
                            sql_str2    +=  " group_seq ";
                            sql_str2    +=  " , SUBSTR(SYS_CONNECT_BY_PATH(group_nm,'_'), 2) as full_name ";
                            sql_str2    +=  " , CONNECT_BY_ROOT group_seq as root_group ";
                            sql_str2    +=  " from note_group_list ";
                            sql_str2    +=  " start with parent_seq = '-1' ";
                            sql_str2    +=  " CONNECT BY prior group_seq = parent_seq ";
                            sql_str2    +=  " order by group_seq asc, group_lv asc ) ";
                            sql_str2    +=  " A WHERE A.full_name = ?) ";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList3) {

                                if (parseNull(dataMap.get("cell2").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell3").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell4").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell5").toString(), "").trim().length() < 1 && parseNull(dataMap.get("cell6").toString(), "").trim().length() < 1) {

                                    pstmt.setString(1, Integer.toString(next_group_seq));
                                    pstmt.setString(2, parseNull(dataMap.get("cell4").toString(), "").trim());
                                    pstmt.setString(3, "3");
                                    String tempParent3  =   parseNull(dataMap.get("cell2").toString(), "") + "_" + parseNull(dataMap.get("cell3").toString(), "");
                                    if (!tmpParent3.equals(tempParent3)) {
                                        tmpParent3  =   tempParent3;
                                        tmpCnt3     =   1;
                                    }
                                    pstmt.setString(4,  Integer.toString(tmpCnt3));
                                    pstmt.setString(5, tempParent3);

                                    pstmt.setString(6, parseNull(dataMap.get("cell7").toString(), "").trim());      //school_flag
                                    pstmt.setString(7, parseNull(dataMap.get("cell8").toString(), "").trim());      //addr_post
                                    pstmt.setString(8, parseNull(dataMap.get("cell9").toString(), "").trim());      //addr
                                    pstmt.setString(9, parseNull(dataMap.get("cell10").toString(), "").trim());     //tel1
                                    pstmt.setString(10, parseNull(dataMap.get("cell11").toString(), "").trim());    //tel2
                                    pstmt.setString(11, parseNull(dataMap.get("cell12").toString(), "").trim());    //tel3
                                    pstmt.setString(12, parseNull(dataMap.get("cell13").toString(), "").trim());    //tel4
                                    pstmt.setString(13, parseNull(dataMap.get("cell14").toString(), "").trim());    //fax
                                    pstmt.setString(14, parseNull(dataMap.get("cell15").toString(), "").trim());    //fax2
                                    pstmt.setString(15, parseNull(dataMap.get("cell16").toString(), "").trim());    //url
                                    pstmt.setString(16, parseNull(dataMap.get("cell17").toString(), "").trim());    //alimi
                                    pstmt.setString(17, parseNull(dataMap.get("cell18").toString(), "").trim());    //show_flag

                                    pstmt.addBatch();
                                    tmpCnt3++;
                                    next_group_seq++;
                                    
                                    error_cnt++;
                                    
                                }//end if
                            }//end for
                            //run the batch
                            int[] count3    =   pstmt.executeBatch();
                            result3         =   count3.length;
                            
                            
                        }//end if
                        if (result2 > 0 && result3 < 1) {
                            sqlMapClient.commitTransaction();
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('3레벨까지 정상적으로 처리 되었습니다. 수고하셨습니다.');");
                            out.println("location.replace('./sucheop_group.jsp');");
                            out.println("</script>");
                        }
                        
                    } catch (Exception e) {
//오류 등록 쿼리 확인
                        sql     =   new StringBuffer();
                        sql_str =   "UPDATE NOTE_FILE_LOG SET SUCC_FLAG = 'N', SUCC_FAIL_REASON = '"+error_cnt+"번 3레벨 기관 입력 중 오류 발생' WHERE FILE_SEQ = " + next_file_seq;
                        sql.append(sql_str);
                        pstmt   =   conn.prepareStatement(sql.toString());
                        pstmt.executeUpdate();
                        e.printStackTrace();
                        sqlMapClient.endTransaction();

                        out.println("<script type=\"text/javascript\">"); 
                        out.println("alert('Exception Error GROUP 3rd 22nd try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                        out.println("history.back();");
                        out.println("</script>");
                    } finally {
                        if (rs != null) try {rs.close();} catch (SQLException e) {}
                        if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                        if (conn != null) try {conn.close();} catch (SQLException e) {}
                        sqlMapClient.endTransaction();
                    }// ./end 2nd try
                }//END if (level == 3)
/********************************************************************************************************************************/
                // 4th batch
                if (result3 > 0) {
                    result4     =   0;
                    //  2nd try
                    try {
                        sqlMapClient.startTransaction();
                        conn    =   sqlMapClient.getCurrentConnection();
                        
                        //다음 번호 찾기
                        sql =   new StringBuffer();
                        sql.append("select group_seq from (select * from note_group_list order by group_seq desc) where rownum = 1");
                        pstmt   =   conn.prepareStatement(sql.toString());
                        rs		=	pstmt.executeQuery();
                        if (rs.next()) {
                            next_group_seq   =   rs.getInt("GROUP_SEQ") + 1;
                        }

                        List<Map<String, Object>> dataList4  =   getExcelRead(uploadedFile, 1);

                        if (dataList4.size() > 0 && dataList4 != null) {

                            //  미리 쿼리 짜놈.....
                            sql =   new StringBuffer();
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR_POST, ADDR, TEL1, TEL2, TEL3, TEL4, FAX, FAX2, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ?";
                            
                            sql_str1 +=  " , ?";
                            /*String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";*/
                            String sql_str2 =   ", (SELECT A.group_seq from ";     //parent_seq
                            sql_str2    +=  " (select  ";
                            sql_str2    +=  " group_seq ";
                            sql_str2    +=  " , SUBSTR(SYS_CONNECT_BY_PATH(group_nm,'_'), 2) as full_name ";
                            sql_str2    +=  " , CONNECT_BY_ROOT group_seq as root_group ";
                            sql_str2    +=  " from note_group_list ";
                            sql_str2    +=  " start with parent_seq = '-1' ";
                            sql_str2    +=  " CONNECT BY prior group_seq = parent_seq ";
                            sql_str2    +=  " order by group_seq asc, group_lv asc ) ";
                            sql_str2    +=  " A WHERE A.full_name = ?) ";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList4) {

                                if (parseNull(dataMap.get("cell2").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell3").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell4").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell5").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell6").toString(), "").trim().length() < 1) {

                                    pstmt.setString(1, Integer.toString(next_group_seq));
                                    pstmt.setString(2, parseNull(dataMap.get("cell5").toString(), "").trim());
                                    pstmt.setString(3, "4");
                                    String tempParent4  =   parseNull(dataMap.get("cell2").toString(), "") + "_" + parseNull(dataMap.get("cell3").toString(), "") + "_" + parseNull(dataMap.get("cell4").toString(), "");
                                    if (!tmpParent4.equals(tempParent4)) {
                                        tmpParent4  =   tempParent4;
                                        tmpCnt4     =   1;
                                    }
                                    pstmt.setString(4,  Integer.toString(tmpCnt4));
                                    pstmt.setString(5, tempParent4);

                                    pstmt.setString(6, parseNull(dataMap.get("cell7").toString(), "").trim());      //school_flag
                                    pstmt.setString(7, parseNull(dataMap.get("cell8").toString(), "").trim());      //addr_post
                                    pstmt.setString(8, parseNull(dataMap.get("cell9").toString(), "").trim());      //addr
                                    pstmt.setString(9, parseNull(dataMap.get("cell10").toString(), "").trim());     //tel1
                                    pstmt.setString(10, parseNull(dataMap.get("cell11").toString(), "").trim());    //tel2
                                    pstmt.setString(11, parseNull(dataMap.get("cell12").toString(), "").trim());    //tel3
                                    pstmt.setString(12, parseNull(dataMap.get("cell13").toString(), "").trim());    //tel4
                                    pstmt.setString(13, parseNull(dataMap.get("cell14").toString(), "").trim());    //fax
                                    pstmt.setString(14, parseNull(dataMap.get("cell15").toString(), "").trim());    //fax2
                                    pstmt.setString(15, parseNull(dataMap.get("cell16").toString(), "").trim());    //url
                                    pstmt.setString(16, parseNull(dataMap.get("cell17").toString(), "").trim());    //alimi
                                    pstmt.setString(17, parseNull(dataMap.get("cell18").toString(), "").trim());    //show_flag

                                    pstmt.addBatch();
                                    tmpCnt4++;
                                    next_group_seq++;
                                    
                                    error_cnt++;
                                    
                                }//end if
                            }//end for
                            //run the batch
                            int[] count4    =   pstmt.executeBatch();
                            result4         =   count4.length;
                            
                            
                        }//end if
                        
                        if (result3 > 0 && result4 < 1) {
                            sqlMapClient.commitTransaction();
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('4레벨까지 정상적으로 처리 되었습니다. 수고하셨습니다.');");
                            out.println("location.replace('./sucheop_group.jsp');");
                            out.println("</script>");
                        }
                        
                    } catch (Exception e) {
//오류 등록 쿼리 확인
                        sql     =   new StringBuffer();
                        sql_str =   "UPDATE NOTE_FILE_LOG SET SUCC_FLAG = 'N', SUCC_FAIL_REASON = '"+error_cnt+"번 4레벨 기관 입력 중 오류 발생' WHERE FILE_SEQ = " + next_file_seq;
                        sql.append(sql_str);
                        pstmt   =   conn.prepareStatement(sql.toString());
                        pstmt.executeUpdate();
                        e.printStackTrace();
                        sqlMapClient.endTransaction();

                        out.println("<script type=\"text/javascript\">"); 
                        out.println("alert('Exception Error GROUP 4th 22nd try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                        out.println("history.back();");
                        out.println("</script>");
                    } finally {
                        if (rs != null) try {rs.close();} catch (SQLException e) {}
                        if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                        if (conn != null) try {conn.close();} catch (SQLException e) {}
                        sqlMapClient.endTransaction();
                    }// ./end 2nd try
                }
/********************************************************************************************************************************/
                // 5th batch
                if (result4 > 0) {
                    
                    result5     =   0;
                    //  2nd try
                    try {
                        sqlMapClient.startTransaction();
                        conn    =   sqlMapClient.getCurrentConnection();
                        
                        //다음 번호 찾기
                        sql =   new StringBuffer();
                        sql.append("select group_seq from (select * from note_group_list order by group_seq desc) where rownum = 1");
                        pstmt   =   conn.prepareStatement(sql.toString());
                        rs		=	pstmt.executeQuery();
                        if (rs.next()) {
                            next_group_seq   =   rs.getInt("GROUP_SEQ") + 1;
                        }

                        List<Map<String, Object>> dataList5  =   getExcelRead(uploadedFile, 1);

                        if (dataList5.size() > 0 && dataList5 != null) {

                            //  미리 쿼리 짜놈.....
                            sql =   new StringBuffer();
                            String sql_str1 =   "INSERT INTO NOTE_GROUP_LIST (GROUP_SEQ, GROUP_NM, GROUP_LV, GROUP_DEPTH, PARENT_SEQ, REG_DT, REG_HMS, SCHOOL_FLAG, ADDR_POST, ADDR, TEL1, TEL2, TEL3, TEL4, FAX, FAX2, URL, ALIMI, SHOW_FLAG) ";
                            sql_str1 +=  " VALUES ( ?, ?, ?";
                            
                            sql_str1 +=  " , ?";
                            /*String sql_str2 =   ", (SELECT GROUP_SEQ FROM NOTE_GROUP_LIST WHERE GROUP_NM = ?)";*/
                            String sql_str2 =   ", (SELECT A.group_seq from ";     //parent_seq
                            sql_str2    +=  " (select  ";
                            sql_str2    +=  " group_seq ";
                            sql_str2    +=  " , SUBSTR(SYS_CONNECT_BY_PATH(group_nm,'_'), 2) as full_name ";
                            sql_str2    +=  " , CONNECT_BY_ROOT group_seq as root_group ";
                            sql_str2    +=  " from note_group_list ";
                            sql_str2    +=  " start with parent_seq = '-1' ";
                            sql_str2    +=  " CONNECT BY prior group_seq = parent_seq ";
                            sql_str2    +=  " order by group_seq asc, group_lv asc ) ";
                            sql_str2    +=  " A WHERE A.full_name = ?) ";
                            String sql_str3 =   ", TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')" + ", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                            sql_str     =   sql_str1 + sql_str2 + sql_str3;
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());

                            for (Map<String, Object> dataMap : dataList5) {

                                if (parseNull(dataMap.get("cell2").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell3").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell4").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell5").toString(), "").trim().length() > 0 && parseNull(dataMap.get("cell6").toString(), "").trim().length() > 0) {

                                    pstmt.setString(1, Integer.toString(next_group_seq));
                                    pstmt.setString(2, parseNull(dataMap.get("cell6").toString(), "").trim());
                                    pstmt.setString(3, "5");
                                    String tempParent5  =   parseNull(dataMap.get("cell2").toString(), "") + "_" + parseNull(dataMap.get("cell3").toString(), "") + "_" + parseNull(dataMap.get("cell4").toString(), "") + "_" + parseNull(dataMap.get("cell5").toString(), "");
                                    if (!tmpParent5.equals(tempParent5)) {
                                        tmpParent5  =   tempParent5;
                                        tmpCnt5     =   1;
                                    }
                                    pstmt.setString(4,  Integer.toString(tmpCnt5));
                                    pstmt.setString(5, tempParent5);

                                    pstmt.setString(6, parseNull(dataMap.get("cell7").toString(), "").trim());      //school_flag
                                    pstmt.setString(7, parseNull(dataMap.get("cell8").toString(), "").trim());      //addr_post
                                    pstmt.setString(8, parseNull(dataMap.get("cell9").toString(), "").trim());      //addr
                                    pstmt.setString(9, parseNull(dataMap.get("cell10").toString(), "").trim());     //tel1
                                    pstmt.setString(10, parseNull(dataMap.get("cell11").toString(), "").trim());    //tel2
                                    pstmt.setString(11, parseNull(dataMap.get("cell12").toString(), "").trim());    //tel3
                                    pstmt.setString(12, parseNull(dataMap.get("cell13").toString(), "").trim());    //tel4
                                    pstmt.setString(13, parseNull(dataMap.get("cell14").toString(), "").trim());    //fax
                                    pstmt.setString(14, parseNull(dataMap.get("cell15").toString(), "").trim());    //fax2
                                    pstmt.setString(15, parseNull(dataMap.get("cell16").toString(), "").trim());    //url
                                    pstmt.setString(16, parseNull(dataMap.get("cell17").toString(), "").trim());    //alimi
                                    pstmt.setString(17, parseNull(dataMap.get("cell18").toString(), "").trim());    //show_flag

                                    pstmt.addBatch();
                                    tmpCnt5++;
                                    next_group_seq++;
                                    
                                    error_cnt++;
                                    
                                }//end if
                            }//end for
                            //run the batch
                            int[] count5    =   pstmt.executeBatch();
                            result5         =   count5.length;
                            
                        }//end if
                        if (result5 > 0 || (result4 > 0 && result5 < 1)) {
                            sqlMapClient.commitTransaction();
                            out.println("<script type=\"text/javascript\">");
                            out.println("alert('정상적으로 처리 되었습니다. 수고하셨습니다.');");
                            out.println("location.replace('./sucheop_group.jsp');");
                            out.println("</script>");
                        }
                        
                    } catch (Exception e) {
                        //오류 등록 쿼리 확인
                        sql     =   new StringBuffer();
                        sql_str =   "UPDATE NOTE_FILE_LOG SET SUCC_FLAG = 'N', SUCC_FAIL_REASON = '"+error_cnt+"번 5레벨 기관 입력 중 오류 발생' WHERE FILE_SEQ = " + next_file_seq;
                        sql.append(sql_str);
                        pstmt   =   conn.prepareStatement(sql.toString());
                        pstmt.executeUpdate();
                        e.printStackTrace();
                        sqlMapClient.endTransaction();

                        out.println("<script type=\"text/javascript\">"); 
                        out.println("alert('Exception Error GROUP 5th 22nd try : "+error_cnt+"번 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
                        out.println("history.back();");
                        out.println("</script>");
                    } finally {
                        if (rs != null) try {rs.close();} catch (SQLException e) {}
                        if (pstmt != null) try {pstmt.close();} catch (SQLException e) {}
                        if (conn != null) try {conn.close();} catch (SQLException e) {}
                        sqlMapClient.endTransaction();
                    }// ./end 2nd try
                }
/********************************************************************************************************************************/
            } catch (Exception e) {
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Exception Error GROUP 1st try : 처리중 오류가 발생하였습니다. 엑셀자료를 확인해 주시기 바랍니다.');");
//                out.println("history.back();");
                out.println("</script>");
            }
        }
        
    } //END else if
    else {
        out.println("<script type=\"text/javascript\">");
        out.println("alert('MultiPart Parameter Error : 파라미터 오류가 발생하였습니다.\n개발 담당자에게 문의하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }// ./end type if sentence
%>