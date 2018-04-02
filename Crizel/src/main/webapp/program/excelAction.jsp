<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Enumeration"%>
<%!
public List<Map<String, Object>> getExcelRead(File file){
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
		for(rowindex=1;rowindex<rows;rowindex++){
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

public List<Map<String, Object>> getExcelRead2(File file){
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
		for(rowindex=1;rowindex<rows;rowindex++){
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
%>

<%
	request.setCharacterEncoding("UTF-8");

	String root = request.getSession().getServletContext().getRealPath("/");
	String directory = "/upload_data/test/";
	MultipartRequest mr = new MultipartRequest(request, root+directory, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	
	out.println("경로 : " + root+directory + "<br><br>");
	
	/** DB Process **/
	StringBuffer sql = null;
	int key = 0;
	int result = 0;
	
	Enumeration files = mr.getFileNames();
	String fileName = "";
	String realFile = "";
	String saveFile = "";
	String fileExt	= "";
	
	File file = null;
	List<Map<String,Object>> excelList = null;
	
	while(files.hasMoreElements()){
		fileName = (String)files.nextElement();
		file = mr.getFile(fileName);
		realFile = mr.getOriginalFileName(fileName);
		saveFile = mr.getFilesystemName(fileName);
		
		//excelList = getExcelRead(file, 1);
		
		fileExt = realFile.split("\\.")[1];
		
		if("xls".equals(fileExt)){
			excelList = getExcelRead(file);
		}else if("xlsx".equals(fileExt)){
			excelList = getExcelRead2(file);
		}
		
		out.println("file : " + file + "<br>");
		out.println("realFile : " + realFile + "<br>");
		out.println("saveFile : " + saveFile + "<br>");
	}
	
	int maxId = jdbcTemplate.queryForObject("SELECT NVL(MAX(TEST_ID)+1, 1) FROM TEST2", Integer.class);
	
	sql = new StringBuffer();
	sql.append("INSERT INTO TEST2(TEST_ID, TEST1, TEST2)		");
	sql.append("VALUES(?, ?, ?)									");
	
	List<Object[]> batch = new ArrayList<Object[]>();
	
	if(excelList!=null && excelList.size()>0){
		for(Map<String,Object> ob : excelList){
			if(!"".equals(ob.get("cell1")) && !"".equals(ob.get("cell2")) && !"".equals(ob.get("cell3"))){
				out.println("값1 : " + ob.get("cell1") + "<br>");
				out.println("값2 : " + ob.get("cell2") + "<br><br>");
				
				Object[] value = new Object[]{
					maxId++,
					ob.get("cell1"),
					ob.get("cell2")
				};
				batch.add(value);
			}
		}
	}
	
	int a[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
	
	
	out.println("값 : " + a.length + "<br>");
%>