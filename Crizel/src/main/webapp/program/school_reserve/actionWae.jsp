<%
/**
*   PURPOSE :   시설정보 등록 구동 페이지
*   CREATE  :   2017... 고주임
*   MODIFY  :   ...
*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.iam.manager.ViewManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.DateFormat"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="java.awt.geom.AffineTransform"%>
<%@ page import="java.awt.image.AffineTransformOp"%>
<%!

 protected void ThumbNail(File image, String convFile) throws Exception 
 {

   String destFileName = convFile;
  try
  {
   int wSize = 0, hSize=0;
   BufferedImage bufferedImage = ImageIO.read(image);
   int imageWidth = bufferedImage.getWidth();
   int imageHeight = bufferedImage.getHeight();

   int componentWidth = 0;
   int componentHeight = 0;

   if(imageWidth >=  imageHeight )
   {
    wSize = 700;

    if(imageWidth > wSize )
    {
     componentWidth = wSize;
     componentHeight = (int)Math.round(imageHeight * (wSize / componentWidth));
    }
    else
    {
     componentWidth = imageWidth;
     componentHeight = imageHeight;
    }
   }
   else
   {
    hSize = 700;

    if(imageHeight > hSize )
    {
     componentHeight = hSize;
     componentWidth = (int)Math.round(imageWidth * (hSize / componentHeight));
    }
    else
    {
     componentWidth = imageWidth;
     componentHeight = imageHeight;
    }
   }

   double scale = -1;

   if(true)
   {
    double heightScale = ((double)componentWidth) / ((double)imageWidth);
    int scaledHeight = (int)(((double)imageHeight) * heightScale);
    double widthScale = ((double)componentHeight) / ((double)imageHeight);
    int scaledWidth = (int)(((double)imageWidth) * widthScale);
    if ( scaledWidth <= componentWidth ) scale = widthScale;
    else scale = heightScale;
   }
   // Now create thumbnail
   AffineTransform affineTransform = AffineTransform.getScaleInstance(scale,scale);
   AffineTransformOp affineTransformOp = new AffineTransformOp(affineTransform, null);
   BufferedImage scaledBufferedImage = affineTransformOp.filter(bufferedImage,null);

   // Now do fix to get rid of silly spurious line

   int scaledWidth = scaledBufferedImage.getWidth();
   int scaledHeight = scaledBufferedImage.getHeight();

   int expectedWidth = (int)(imageWidth * scale);
   int expectedHeight = (int)(imageHeight * scale);
   if ( scaledWidth > expectedWidth || scaledHeight > expectedHeight )
   {
    scaledBufferedImage = scaledBufferedImage.getSubimage(0,0,expectedWidth,expectedHeight);
   }
   ImageIO.write(scaledBufferedImage,"PNG", new File(destFileName));

  }
  catch (Exception ee)
  {
   throw ee;
  }

 }

%>
<%
	request.setCharacterEncoding("UTF-8");

	String root = request.getSession().getServletContext().getRealPath("/");
	String directory = "/upload_data/school_reserve/";
	MultipartRequest mr = new MultipartRequest(request, root+directory, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	if(mr.getFile("uploadfile") != null){
		File reFile_1 = null;
		reFile_1 = mr.getFile("uploadfile");
		ThumbNail(reFile_1, root+directory+mr.getFilesystemName("uploadfile"));
	}
	Enumeration files = mr.getFileNames();
	String file1 = (String)files.nextElement();
	String real_img = mr.getOriginalFileName(file1);
	String save_img = mr.getFilesystemName(file1);
	
	String command = mr.getParameter("command");
	String school_id = mr.getParameter("school_id");
	String room_id = "";
	String reserve_type = mr.getParameter("reserve_type");
	String reserve_type2 = mr.getParameter("reserve_type2");
	int reserve_group = Integer.parseInt(mr.getParameter("reserve_group")==null?"1":mr.getParameter("reserve_group"));
	String reserve_area = mr.getParameter("reserve_area");
	String reserve_max = mr.getParameter("reserve_max");
	String reserve_use = mr.getParameter("reserve_use");
	String reserve_start = mr.getParameter("reserve_start");
	String reserve_start2 = mr.getParameter("reserve_start2");
	String reserve_end = mr.getParameter("reserve_end");
	String reserve_end2 = mr.getParameter("reserve_end2");
	String date_type[] = mr.getParameterValues("date_type");
	String option_title[] = mr.getParameterValues("option_title");
	String option_price[] = mr.getParameterValues("option_price");
/* 20171116_thur */
    String addOptPriceUnit[] = mr.getParameterValues("addOptPriceUnit");
/* END */
	String reserve_etc = mr.getParameter("reserve_etc");
	String reserve_notice = mr.getParameter("reserve_notice");
	int reserve_number = Integer.parseInt(mr.getParameter("reserve_group")==null?"1":mr.getParameter("reserve_group"));
	String etc_price1 = mr.getParameter("etc_price1");
	String etc_price2 = mr.getParameter("etc_price2");
	String etc_price3 = mr.getParameter("etc_price3");
	
	String date_start = parseNull(mr.getParameter("date_start"));
	String date_end = parseNull(mr.getParameter("date_end"));
	String reserve_time[] = mr.getParameterValues("reserve_time");
	
	/** DB Process **/
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer sql = null;
	int key = 0;
	int result = 0;
	boolean dupCheck = false;
	
	try {
		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();
		
		//같은시설 등록 방지
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE = ? 	");
		if("기타시설".equals(reserve_type)){	
			sql.append("AND RESERVE_TYPE2 = ?	");
		}
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, school_id);
		pstmt.setString(++key, reserve_type);
		if("기타시설".equals(reserve_type)){
			pstmt.setString(++key, reserve_type2);	
		}		
		rs = pstmt.executeQuery();
		if(rs.next()){
			dupCheck = true;
		}
		
		if(!dupCheck){
			sql = new StringBuffer();
			sql.append("SELECT ROOM_ID_SEQ.NEXTVAL ROOM_ID FROM RESERVE_ROOM ");
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			if(rs.next()){
				room_id = rs.getString("ROOM_ID");
			}
			
			key = 0;
			//시설 테이블 입력
			sql = new StringBuffer();
			sql.append("INSERT INTO RESERVE_ROOM(SCHOOL_ID, ROOM_ID, RESERVE_TYPE, RESERVE_TYPE2, RESERVE_NUMBER, RESERVE_AREA, RESERVE_MAX,  \n");
			sql.append("		RESERVE_ETC, RESERVE_NOTICE, SAVE_IMG, REAL_IMG, DIRECTORY, RESERVE_USE, ETC_PRICE1, ETC_PRICE2, ETC_PRICE3) \n");
			sql.append("VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) \n");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(++key, school_id);
			pstmt.setString(++key, room_id);
			pstmt.setString(++key, reserve_type);
			pstmt.setString(++key, reserve_type2);
			pstmt.setInt(++key, reserve_number);
			pstmt.setString(++key, reserve_area);
			pstmt.setString(++key, reserve_max);
			pstmt.setString(++key, reserve_etc);
			pstmt.setString(++key, reserve_notice);
			pstmt.setString(++key, save_img);
			pstmt.setString(++key, real_img);
			pstmt.setString(++key, directory);
			pstmt.setString(++key, reserve_use);
			pstmt.setString(++key, etc_price1);
			pstmt.setString(++key, etc_price2);
			pstmt.setString(++key, etc_price3);
			pstmt.executeUpdate();
			
			key = 0;
			result++;
			
			//옵션 테이블 입력
			if(option_title!=null){
				for(int i=0; i<option_title.length; i++){
                    sql = new StringBuffer();
					sql.append("INSERT INTO RESERVE_OPTION(OPTION_ID, ROOM_ID, OPTION_TITLE, OPTION_PRICE, OPTION_PRICE_UNIT) \n");
					sql.append("VALUES(OPTION_ID_SEQ.NEXTVAL, ?, ?, ?, ?) \n");
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(++key, room_id);
					pstmt.setString(++key, option_title[i]);
					pstmt.setString(++key, option_price[i]);
					pstmt.setString(++key, addOptPriceUnit[i]);
					pstmt.executeUpdate();
					
					key = 0;
					result++;
				}
			}
			
			if("".equals(date_start)){
				reserve_type = "A";
			}else{
				reserve_type = "B";
			}
			
			
			if("".equals(reserve_time[0]) && !"".equals(reserve_time[2])){
				reserve_time[0] = reserve_time[2];
				reserve_time[2] = "";
				reserve_time[1] = reserve_time[3];
				reserve_time[3] = "";
			}
			if("".equals(reserve_time[4]) && !"".equals(reserve_time[6])){
				reserve_time[4] = reserve_time[6];
				reserve_time[6] = "";
				reserve_time[5] = reserve_time[7];
				reserve_time[7] = "";
			}
			if("".equals(reserve_time[8]) && !"".equals(reserve_time[10])){
				reserve_time[8] = reserve_time[10];
				reserve_time[10] = "";
				reserve_time[9] = reserve_time[11];
				reserve_time[11] = "";
			}
			
            
			//시간 테이블 데이터 입력
			for(int i=0; i<reserve_group; i++){
				sql = new StringBuffer();
				sql.append("INSERT INTO RESERVE_DATE(DATE_ID, SCHOOL_ID, ROOM_ID, DATE_START, DATE_END, TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2  ");
				sql.append(", TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2  ");
				sql.append(", REGISTER_DATE, RESERVE_TYPE, RESERVE_GROUP, RESERVE_BAN)  ");
				sql.append("VALUES(DATE_ID_SEQ.NEXTVAL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ? , 'N') ");
				pstmt = conn.prepareStatement(sql.toString());
				key = 0;
				pstmt.setString(++key, school_id);
				pstmt.setString(++key, room_id);
				pstmt.setString(++key, date_start);
				pstmt.setString(++key, date_end);
				pstmt.setString(++key, reserve_time[0]);
				pstmt.setString(++key, reserve_time[1]);
				pstmt.setString(++key, reserve_time[2]);
				pstmt.setString(++key, reserve_time[3]);
				pstmt.setString(++key, reserve_time[4]);
				pstmt.setString(++key, reserve_time[5]);
				pstmt.setString(++key, reserve_time[6]);
				pstmt.setString(++key, reserve_time[7]);
				pstmt.setString(++key, reserve_time[8]);
				pstmt.setString(++key, reserve_time[9]);
				pstmt.setString(++key, reserve_time[10]);
				pstmt.setString(++key, reserve_time[11]);
				pstmt.setString(++key, reserve_type);
				pstmt.setInt(++key, i);
				result = pstmt.executeUpdate();
				
			}
			
			if(result > 0){
				sqlMapClient.commitTransaction();
			}else{
				sql = new StringBuffer();
				sql.append("DELETE FROM RESERVE_ROOM WHERE ROOM_ID = ? \n");
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, room_id);
				pstmt.executeUpdate();
				
				sql = new StringBuffer();
				sql.append("DELETE FROM RESERVE_DATE WHERE ROOM_ID = ? \n");
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, room_id);
				pstmt.executeUpdate();
				
				sql = new StringBuffer();
				sql.append("DELETE FROM RESERVE_OPTION WHERE ROOM_ID = ? \n");
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, room_id);
				pstmt.executeUpdate();
			}
		}
			
	} catch (Exception e) {
		%>
			<%=e.toString()%>
		<%
		sqlMapClient.endTransaction();
		/*out.println("<script type=\"text/javascript\">");
		out.println("alert('Exception Error_1 : 처리중 오류가 발생하였습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
		*/
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
		if (conn != null) try { conn.close(); } catch (SQLException se) {}
		sqlMapClient.endTransaction();
		if(result > 0){
			out.println("<script type=\"text/javascript\">");
			//out.println("alert('정상적으로 처리되었습니다.');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000001201007001001');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000000106007001001');");		//테스트서버
			out.println("</script>");
		}
		if(dupCheck){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('해당 시설은 이미 등록되어있습니다.');");
			out.println("location.replace('/index.gne?menuCd=DOM_000001201007001001');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000000106007001001');");		//테스트서버
			out.println("</script>");
		}
	}
	
%>


<%!
public String getDateDay(String date, String dateType) throws Exception {
    String day = "" ;
    SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
    Date nDate = dateFormat.parse(date) ;
    Calendar cal = Calendar.getInstance() ;
    cal.setTime(nDate);
    int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
    switch(dayNum){
        case 1: day = "일"; break ;
        case 2: day = "평일"; break ;
        case 3: day = "평일"; break ;
        case 4: day = "평일"; break ;
        case 5: day = "평일"; break ;
        case 6: day = "평일"; break ;
        case 7: day = "토"; break ;
    }
    return day ;
}
%>