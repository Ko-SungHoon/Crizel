<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.multipart.MultipartHttpServletRequest" %>
<%@ page import="org.springframework.web.multipart.MultipartFile" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="egovframework.rfc3.contents.vo.ContentsVO,egovframework.rfc3.contents.service.ContentsService" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%

/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/

String err = "";
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
//SessionManager sessionManager = new SessionManager(request);

String dt1   = parseNull(request.getParameter("dt1"));
String dt2   = parseNull(request.getParameter("dt2"));
String dt3   = parseNull(request.getParameter("dt3"));
String in_office_cd = parseNull(request.getParameter("in_office_cd"));
String in_office_nm = parseNull(request.getParameter("in_office_nm"));

String dt_office_cd = parseNull(request.getParameter("dt_office_cd"));
String dt_office_nm = parseNull(request.getParameter("dt_office_nm"));

String standard_dt = dt1+dt2+dt3;

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
int result = 0;
int chkCnt = 0;	//중복체크

String rootPath = cm.getMessage("Globals.RootPath");
String uploadPath = cm.getMessage("Globals.UploadPath");

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
	MultipartFile multipartFile = multiRequest.getFile("upload");
	String filePath = rootPath+uploadPath+"/division_work/";
	File dir = new File(filePath);
	if(!dir.exists())
	{
		dir.mkdirs();
	}
		
	String tmpFileName = egovframework.rfc3.common.util.CommonUtil.generateKey();
	String tmpOriginalExt = egovframework.rfc3.common.util.CommonUtil.getExtension(multipartFile.getOriginalFilename());
	filePath = filePath + tmpFileName+tmpOriginalExt;
	multipartFile.transferTo(new File(filePath));
	FileInputStream fis=new FileInputStream(filePath);
	if(tmpOriginalExt.toLowerCase().equals(".xls"))
	{
		
		
		
		
		HSSFWorkbook workbook=new HSSFWorkbook(fis);
		int rowindex=0;
		int columnindex=0;
		//시트 수 (첫번째에만 존재하므로 0을 준다)
		//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
		HSSFSheet sheet=workbook.getSheetAt(0);
		//행의 수
		int rows=sheet.getPhysicalNumberOfRows();
		for(rowindex=1;rowindex<rows;rowindex++){
			HSSFRow row=sheet.getRow(rowindex);
			if(row !=null){
				
				HSSFCell cell_emplyr_nm      = null;
				HSSFCell cell_position_nm    = null;
				HSSFCell cell_office_pt_memo = null;
				HSSFCell cell_office_tel     = null;
				HSSFCell cell_agen_nm        = null;
				
						 
				
				String emplyr_nm       = "";
				String position_nm     = "";
				String office_pt_memo  = "";
				String office_tel      = "";
				String agen_nm         = "";
				
				
				cell_emplyr_nm         = row.getCell(0);
				cell_position_nm       = row.getCell(1);
				cell_office_pt_memo    = row.getCell(2);
				cell_office_tel        = row.getCell(3);
				cell_agen_nm           = row.getCell(4);
				
				emplyr_nm      = value(cell_emplyr_nm);     
				position_nm    = value(cell_position_nm);
				office_pt_memo = value(cell_office_pt_memo);
				office_tel     = value(cell_office_tel);
				agen_nm        = value(cell_agen_nm);
				
				
				// 기존 부서코드에 있는 데이터는 모두 삭제한다.
				sql = new StringBuffer();
				sql.append("DELETE FROM DIVISION_WORK WHERE 1=1 ");
				if(StringUtils.isEmpty(dt_office_cd)){
					sql.append("  AND OFFICE_CD = '"+in_office_cd+"'  ");
				}else{
					sql.append("  AND OFFICE_CD = '"+dt_office_cd+"'  ");
				}
				pstmt = conn.prepareStatement(sql.toString());
				rs = pstmt.executeQuery();	
				
					sql = new StringBuffer();
					sql.append("INSERT INTO DIVISION_WORK ");
					sql.append("(   ");
					sql.append("       E_SEQ           \n");
					sql.append("     , EMPLYR_NM           \n");
					sql.append("     , POSITION_NM         \n");
					sql.append("     , OFFICE_CD           \n");
					sql.append("     , OFFICE_NM           \n");
					sql.append("     , OFFICE_DP           \n");
					sql.append("     , OFFICE_PT_MEMO      \n");
					sql.append("     , OFFICE_TEL          \n");
					sql.append("     , AGENT_ID            \n");
					sql.append("     , AGEN_NM             \n");
					sql.append("     , STANDARD_DT         \n");
					sql.append("     , REG_DT              \n");
					sql.append("     , REG_ID              \n");
					sql.append("     , MOD_DT              \n");
					sql.append("     , MOD_ID              \n");
					sql.append("     , SORT_ORDER          \n");
					sql.append(")   ");
					sql.append(" VALUES ");
					sql.append("(   ");
					sql.append("       DIVISION_WORK_SEQ.NEXTVAL                   \n"); // E_SEQ
					sql.append("      ,'"+emplyr_nm+"'                   \n"); // emplyr_nm
					sql.append("      ,'"+position_nm+"'                   \n"); // position_nm
					if(StringUtils.isEmpty(dt_office_cd)){
						sql.append("      ,'"+in_office_cd+"'                   \n"); // office_cd
						sql.append("      ,'"+in_office_nm+"'                   \n"); // office_nm
						sql.append("      , 3                   \n"); // office_nm
						
					}else{
						sql.append("      ,'"+dt_office_cd+"'                   \n"); // office_cd
						sql.append("      ,'"+dt_office_nm+"'                   \n"); // office_nm
						sql.append("      , 4                   \n"); // office_nm
					}
					sql.append("      ,'"+office_pt_memo+"'                   \n"); // office_pt_memo
					sql.append("      ,'"+office_tel+"'                   \n"); // office_tel
					sql.append("      ,''                   \n"); // agent_id
					sql.append("      ,'"+agen_nm+"'                   \n"); // agen_nm
					sql.append("      ,'"+standard_dt+"'                   \n"); // standard_dt
					sql.append("      ,TO_CHAR(SYSDATE,'YYYYMMDD')                   \n"); // reg_dt
					sql.append("      ,'"+sessionManager.getId()+"'                   \n"); // reg_id
					sql.append("      ,TO_CHAR(SYSDATE,'YYYYMMDD')                   \n"); // mod_dt
					sql.append("      ,'"+sessionManager.getId()+"'                   \n"); // mod_id
					sql.append("      ,'"+(rowindex*10)+"'                   \n"); // sort_order
					sql.append(")   ");
					pstmt = conn.prepareStatement(sql.toString());
					result = pstmt.executeUpdate();
					if(result > 0){
						sqlMapClient.commitTransaction();
					}
					
			}
		}
	
	}
} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	err = e.getMessage();
	//alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	//out.print(e.getMessage());
	
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
	if(result>0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		out.println("opener.location.reload();");
		out.println("window.close();");
		out.println("</script>");
	}else{
		out.println("<script type=\"text/javascript\">");
		out.println("alert('처리 중 오류가 발생하였습니다.');");
		out.println("opener.location.reload();");
		out.println("window.close();");
		out.println("</script>");
	} 
}

%>
<%=err %>
<%!
public String value(HSSFCell cell)
{
	try{
		return cell.getStringCellValue()+"";
	}catch(Exception e)
	{
		return "";
	}
}

%>