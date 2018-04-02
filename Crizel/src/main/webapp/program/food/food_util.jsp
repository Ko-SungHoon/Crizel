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

<%!
public String outSchGrade (String value) {
    String rtnString    =   "";
    if("T".equals(value)) {rtnString   =   "조사팀장";}
    else if("R".equals(value)) {rtnString   =   "조사자";}
    return rtnString;
}

public String outSchType (String value) {
    String rtnString    =   "";
    if("1".equals(value)) {rtnString   =   "유치원";}
    else if("2".equals(value)) {rtnString   =   "초등학교";}
    else if("3".equals(value)) {rtnString   =   "중학교";}
    else if("4".equals(value)) {rtnString   =   "고등학교";}
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
    if("A".equals(value)) {rtnString   =   "추가";}
    else if("D".equals(value)) {rtnString   =   "삭제";}
    else if("M".equals(value)) {rtnString   =   "변경";}
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

//select option 출력
public String printOption(String value, String text, String nowSel){
	String nowSelect	=	"";
	if(!"".equals(nowSel)){
		if(value.equals(nowSel))		nowSelect	=	"selected = selected";
	}
	String result	=	"<option value='" + value + "' " + nowSelect + ">" + text + "</option>";
	return result;
}
%>
