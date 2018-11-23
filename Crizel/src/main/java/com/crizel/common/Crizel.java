package com.crizel.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.function.IntUnaryOperator;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.crizel.common.util.OneJav;

public class Crizel extends Thread{
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	private String url 			= "jdbc:oracle:thin:@localhost:1521:xe";
	private String username 	= "edu";
	private String password 	= "1234";
	private String driverClass 	= "oracle.jdbc.driver.OracleDriver";
	private String paramDay		= "";
	
	private String dbType 		= "oracle";
	
	public Crizel(){ 
		start();
	}
	
	public Crizel(String day){
		paramDay = day;
		start();
	}
	
	@Override
	public void run() {
		System.out.println(" === Thread Start === ");
		String DB_URL = url;
		String DB_USER = username;
		String DB_PASSWORD = password;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		
		int cnt = 0;
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdft = new SimpleDateFormat("yyyy/MM/dd");
		cal.add(Calendar.DATE, -1);		
		String addr = "https://www.onejav.com/";
		String day = "";
		if(!"".equals(paramDay)){
			day = paramDay;
		}else{
			day = sdft.format(cal.getTime());
		}
		addr += day;
		
		try{
			Class.forName(driverClass);
			conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
			sql = new String();
			sql += "SELECT COUNT(*) AS CNT FROM ONEJAV WHERE DAY = ?	\n";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, day);
		   	rs = pstmt.executeQuery();
		   	if(rs.next()){
		   		cnt = rs.getInt("CNT");
		   	}
		   	if(pstmt!=null){pstmt.close();}
		   	if(rs!=null){rs.close();}
		   	
		   	if(cnt <= 0){
		   		OneJav oj = new OneJav();
		   		List<Map<String,Object>> list = oj.getList(addr, 1, oj.getPageCount(addr), day);
		   		
		   		if(list!=null && list.size()>0){
		   			for(Map<String,Object> ob : list){
					   	sql = new String();
					   	sql += "INSERT INTO ONEJAV(NO, DAY, TITLE, ADDR, IMG, NAME)						\n";
					   	sql += "VALUES((SELECT NVL(MAX(NO)+1,1) AS NO FROM ONEJAV), ?, ?, ?, ?, ?)		\n";
					   	pstmt = conn.prepareStatement(sql);
		   				pstmt.setString(1, day);
		   				pstmt.setString(2, ob.get("title").toString());
		   				pstmt.setString(3, ob.get("addr").toString());
		   				pstmt.setString(4, ob.get("img").toString());
		   				pstmt.setString(5, ob.get("name").toString());
		   				pstmt.executeUpdate();
		   				if(pstmt!=null){pstmt.close();}
					   	if(rs!=null){rs.close();}
		   			}
		   		}
		   	}
		}catch(Exception e){
			System.out.println(e.toString());
			System.out.println(" === Thread End === ");
			if(pstmt!=null){try {pstmt.close();} catch (SQLException e1) {e1.printStackTrace();}}
		   	if(rs!=null){try {rs.close();} catch (SQLException e1) {e1.printStackTrace();}}
		   	if(conn!=null){try {conn.close();} catch (SQLException e1) {e1.printStackTrace();}}
		   	interrupt();
		}finally{
			System.out.println(" === Thread End === ");
			if(pstmt!=null){try {pstmt.close();} catch (SQLException e1) {e1.printStackTrace();}}
		   	if(rs!=null){try {rs.close();} catch (SQLException e1) {e1.printStackTrace();}}
		   	if(conn!=null){try {conn.close();} catch (SQLException e1) {e1.printStackTrace();}}
		   	interrupt();
		}
		
		
		/*
		System.out.println(" === Thread Start === ");
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdft = new SimpleDateFormat("yyyy/MM/dd");
		cal.add(Calendar.DATE, -1);		
		String addr = "https://www.onejav.com/";
		String day = sdft.format(cal.getTime());
		addr += day;

		OneJav oj = new OneJav();
		List<Map<String,Object>> list = null;
		try{
			list = oj.getList(addr, 1, oj.getPageCount(addr), day);
			if(list!=null && list.size()>0){
				int cnt = sqlSession.selectOne(dbType + "_crizel.onejavCnt", day);
				System.out.println("cnt : " + cnt);
				if(cnt<=0){
					for(Map<String,Object> ob : list){
						sqlSession.insert(dbType + "_crizel.onejavInsert", ob);
					}
				}
			}
		}catch(Exception e){
			System.out.println("ERR : " + e.toString());
			System.out.println(" === Thread End === ");
			interrupt();
		}finally{
			System.out.println(" === Thread End === ");
			interrupt();
		}
		*/
	}
}
