package com.crizel.common;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

import com.crizel.common.util.OneJav;

@Controller
public class Crizel extends Thread{
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Value( "${db.type}" )	
	private String dbType;
	
	public Crizel(){ 
		start();
	}
	@Override
	public void run() {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdft = new SimpleDateFormat("yyyy/MM/dd");
		cal.add(Calendar.DATE, -1);		
		String addr = "https://www.onejav.com/";
		String day = sdft.format(cal.getTime());
		addr += day;

		OneJav oj = new OneJav();
		List<Map<String,Object>> list = null;
		
		list = oj.getList(addr, 1, oj.getPageCount(addr), day);
		if(list!=null && list.size()>0){
			int cnt = sqlSession.selectOne(dbType + "_crizel.onejavCnt", day);
			if(cnt<=0){
				for(Map<String,Object> ob : list){
					sqlSession.insert(dbType + "_crizel.onejavInsert", ob);
				}
			}
		}
	}
}
