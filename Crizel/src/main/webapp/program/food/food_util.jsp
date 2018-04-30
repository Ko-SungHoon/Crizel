<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="org.springframework.context.support.FileSystemXmlApplicationContext"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%
/**
*	PURPOSE	:	set the general function page
*	CREATE	:	201803??_???	KO
*	MODIFY	:	20180410_tue	JI	add function outUpdStsFlag() 업데이트 요청 상태 function 추가
*	MODIFY	:	20180410_tue	JI	mod function outUpdFlag() 업데이트 요청 상태 function 수정
*	MODIFY	:	20180410_tue	JI	mod function outSchType() 학교단위 값 수정
*	MODIFY	:	20180423_mon	JI	sha-256 암호화 function 생성
*	MODIFY	:	20180425_wed	KO	자동마감
**/
%>

<%@page import="java.io.PrintWriter"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.springframework.jdbc.core.RowMapper"%>

<%@page import="java.security.InvalidKeyException" %>
<%@page import="java.security.Key" %>
<%@page import="javax.crypto.spec.SecretKeySpec" %>
<%@page import="java.security.MessageDigest"%>

<%
WebApplicationContext endContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
//ApplicationContext endContext = new FileSystemXmlApplicationContext(getServletContext().getRealPath("/WEB-INF")+"/servlet-context.xml");
DataSource endDataSource = (DataSource) endContext.getBean("IamDataSource");		// 운영서버:IamDataSource, 테스트서버:dataSource
JdbcTemplate endJdbcTemplate = new JdbcTemplate(endDataSource);

String endCheckSql 	= null;
int endCnt	 		= 0;
int endResult		= 0;
String end_rsch_no 	= "";
try{
	endCheckSql = new String();
	endCheckSql += "SELECT COUNT(*) AS CNT								";
	endCheckSql += "FROM FOOD_RSCH_TB									";
	endCheckSql += "WHERE SYSDATE >= END_DATE AND STS_FLAG = 'N'		";
	endCnt = endJdbcTemplate.queryForObject(endCheckSql, Integer.class);
}catch(Exception e){
	endCnt = 0;
}

if(endCnt>0){
	try{
		endCheckSql = new String();
		endCheckSql += "SELECT RSCH_NO FROM FOOD_RSCH_TB WHERE STS_FLAG = 'N'	";
		try{
			end_rsch_no = endJdbcTemplate.queryForObject(endCheckSql, String.class);
		}catch(Exception e){
			end_rsch_no = "";
		}
		
		if(!"".equals(end_rsch_no)){
			endCheckSql = new String();
			endCheckSql += "UPDATE FOOD_RSCH_TB SET STS_FLAG = 'Y' WHERE RSCH_NO = ?	 		";
			endJdbcTemplate.update(endCheckSql, end_rsch_no);
		}
	}catch(Exception e){
		out.println(e.toString());
	}
}
%>

<%!
public String outSchGrade (String value) {
    String rtnString    =   "";
    if("T".equals(value)) {rtnString   =   "조사팀장";}
    else if("R".equals(value)) {rtnString   =   "조사자";}
    return rtnString;
}

public String outSchType (String value) {
    String rtnString    =   "";
    if("A".equals(value)) {rtnString   =   "유치원";}
    else if("B".equals(value)) {rtnString   =   "초등학교";}
    else if("C".equals(value)) {rtnString   =   "중학교";}
    else if("D".equals(value)) {rtnString   =   "고등학교";}
    else if("E".equals(value)) {rtnString   =   "대안학교";}
    else if("F".equals(value)) {rtnString   =   "특수학교";}
    else if("G".equals(value)) {rtnString   =   "고등기술학교";}
    else if("H".equals(value)) {rtnString   =   "고등공민학교";}
    else if("I".equals(value)) {rtnString   =   "외국인학교";}
    return rtnString;
}

public String outSchFound (String value) {
    String rtnString    =   "";
    if("1".equals(value)) {rtnString   =   "국립";}
    else if("2".equals(value)) {rtnString   =   "공립";}
    else if("3".equals(value)) {rtnString   =   "사립";}
    return rtnString;
}

public String outUpdFlag(String value){
	String rtnString    =   "";
    if("A".equals(value)) {rtnString   =   "<span class=\"badge bg-add\">추가</span>";}
    else if("D".equals(value)) {rtnString   =   "<span class=\"badge bg-del\">삭제</span>";}
    else if("M".equals(value)) {rtnString   =   "<span class=\"badge bg-modify\">변경</span>";}
    return rtnString;
}

public String outUpdPopFlag(String value){
	String rtnString    =   "";
    if("A".equals(value)) {rtnString   =   "추가";}
    else if("D".equals(value)) {rtnString   =   "삭제";}
    else if("M".equals(value)) {rtnString   =   "변경";}
    return rtnString;
}

public String outUpdStsFlag(String value){
	String rtnString    =   "";
    if("N".equals(value)) {rtnString   =   "<span class=\"blue fb\">접수</span>";}
    else if("Y".equals(value)) {rtnString   =   "<span class=\"blue fb\">접수완료</span>";}
    else if("A".equals(value)) {rtnString   =   "<span class=\"black fb\">반영</span>";}
    else if("R".equals(value)) {rtnString   =   "<span class=\"red fb\">미반영</span>";}
    return rtnString;
}

public String outStsFlag(String value){
	String rtnString    =   "";
    if("N".equals(value)) {rtnString   =   "대기";}
    else if("Y".equals(value)) {rtnString   =   "완료";}
    else if("R".equals(value)) {rtnString   =   "반려";}
    return rtnString;
}

public List<Map<String, Object>> getExcelRead(File file, int startRow){
	List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
	Map<String,Object> map			= null;
	try{
		//파일을 읽기위해 엑셀파일을 가져온다
		FileInputStream fis=new FileInputStream(file);
		HSSFWorkbook workbook=new HSSFWorkbook(fis);
		int rowindex=0;
		int columnindex=0;
		//시트 수 (첫번째에만 존재하므로 0을 준다)
		//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
		HSSFSheet sheet=workbook.getSheetAt(0);
		//행의 수
		int rows=sheet.getPhysicalNumberOfRows();
		for(rowindex=startRow;rowindex<rows;rowindex++){
		    //행을 읽는다
		    HSSFRow row=sheet.getRow(rowindex);
		    if(row !=null){
		        //셀의 수
		        int cells=row.getPhysicalNumberOfCells();
		        
	            map = new HashMap<String,Object>();
		        for(columnindex=0;columnindex<=cells;columnindex++){
		            //셀값을 읽는다
		            HSSFCell cell=row.getCell(columnindex);
		            String value="";
		            //셀이 빈값일경우를 위한 널체크
		            if(cell==null){
		                continue;
		            }else{
		                //타입별로 내용 읽기
		                switch (cell.getCellType()){
		                case HSSFCell.CELL_TYPE_FORMULA:
		                    value=cell.getCellFormula();
		                    break;
		                case HSSFCell.CELL_TYPE_NUMERIC:
		                    value=cell.getNumericCellValue()+"";
		                    break;
		                case HSSFCell.CELL_TYPE_STRING:
		                    value=cell.getStringCellValue()+"";
		                    break;
		                case HSSFCell.CELL_TYPE_BLANK:
		                    value=cell.getBooleanCellValue()+"";
		                    break;
		                case HSSFCell.CELL_TYPE_ERROR:
		                    value=cell.getErrorCellValue()+"";
		                    break;
		                }
		            }
		            if("false".equals(value)){ value = ""; }
		            map.put("cell" + Integer.toString(columnindex+1), value);
		        }
		        list.add(map);
		     }
		}
	}catch(Exception e){
		System.out.println("에러 : " + e.toString());
	}
	return list;
}
/*
public List<Map<String, Object>> getExcelRead2(File file, int startRow){
	List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
	Map<String,Object> map			= null;
	try{
		//파일을 읽기위해 엑셀파일을 가져온다
		FileInputStream fis=new FileInputStream(file);
		XSSFWorkbook workbook=new XSSFWorkbook(fis);
		int rowindex=0;
		int columnindex=0;
		//시트 수 (첫번째에만 존재하므로 0을 준다)
		//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
		XSSFSheet sheet=workbook.getSheetAt(0);
		//행의 수
		int rows=sheet.getPhysicalNumberOfRows();
		for(rowindex=startRow;rowindex<rows;rowindex++){
		    //행을읽는다
		    XSSFRow row=sheet.getRow(rowindex);
		    if(row !=null){
		        //셀의 수
		        int cells=row.getPhysicalNumberOfCells();
				map = new HashMap<String,Object>();
		        for(columnindex=0;columnindex<=cells;columnindex++){
		            //셀값을 읽는다
		            XSSFCell cell=row.getCell(columnindex);
		            String value="";
		            //셀이 빈값일경우를 위한 널체크
		            if(cell==null){
		                continue;
		            }else{
		                //타입별로 내용 읽기
		                switch (cell.getCellType()){
		                case XSSFCell.CELL_TYPE_FORMULA:
		                    value=cell.getCellFormula();
		                    break;
		                case XSSFCell.CELL_TYPE_NUMERIC:
		                    value=cell.getNumericCellValue()+"";
		                    break;
		                case XSSFCell.CELL_TYPE_STRING:
		                    value=cell.getStringCellValue()+"";
		                    break;
		                case XSSFCell.CELL_TYPE_BLANK:
		                    value=cell.getBooleanCellValue()+"";
		                    break;
		                case XSSFCell.CELL_TYPE_ERROR:
		                    value=cell.getErrorCellValue()+"";
		                    break;
		                }
		            }
		            if("false".equals(value)){ value = ""; }
		            map.put("cell" + Integer.toString(columnindex+1), value);
		        }
		        list.add(map);
		    }
		}
	}catch(Exception e){
		System.out.println("에러 : " + e.toString());
	}
	return list;
}
*/
//select option 출력
public String printOption(String value, String text, String nowSel){
	String nowSelect	=	"";
	if(!"".equals(nowSel)){
		if(value.equals(nowSel))		nowSelect	=	"selected = selected";
	}
	String result	=	"<option value='" + value + "' " + nowSelect + ">" + text + "</option>";
	return result;
}

public Boolean lbRatioBool (int minVal, int maxVal, String lbRatio) {
	Boolean rtnBoolean	=	false;
	int min		=	minVal;
	int max		=	maxVal;
	int ratio	=	Integer.parseInt(lbRatio);
	int rsRatio	=	min / (min + max) * 100;
	if (ratio < rsRatio) {
		rtnBoolean	=	true;
	}
	return rtnBoolean;
}

public static String encryptPass (String strPass) {

	try{
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(strPass.getBytes());
		byte byteData[] = md.digest();
		StringBuffer sb = new StringBuffer();
		
		for (int i = 0; i < byteData.length; i++) { 
			sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1)); 
		} 
		
		StringBuffer hexString = new StringBuffer(); 
		
		for (int i=0;i<byteData.length;i++) { 
			String hex=Integer.toHexString(0xff & byteData[i]); 
			if(hex.length()==1){ 
				hexString.append('0'); 
			} 
			hexString.append(hex);
		}
		return hexString.toString();
	}catch(Exception e){
		e.printStackTrace();
		throw new RuntimeException();
	}

}

%>
