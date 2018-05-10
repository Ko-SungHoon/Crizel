package com.crizel.diary;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.util.ChineseCalendar;

@Service("diaryService")
public class DiaryService {
	@Autowired
	DiaryDao dao;
	
	@Autowired
	public DiaryService(DiaryDao dao) {
		super();
		this.dao = dao;
	}
	public HashMap<String, Object> calendar(String year, String month, String dayChange) {
		Calendar cal = Calendar.getInstance();
		if(!"".equals(year)){
			cal.set(Calendar.YEAR, Integer.parseInt(year));
		}
		if(!"".equals(month)){
			cal.set(Calendar.MONTH, Integer.parseInt(month)-1);
		}
		
		if("pre".equals(dayChange)){
			cal.add(Calendar.MONTH, -1);
		}else if("next".equals(dayChange)){
			cal.add(Calendar.MONTH, 1);
		}
		
		year = Integer.toString(cal.get(Calendar.YEAR));
		month = Integer.toString(cal.get(Calendar.MONTH)+1);
		
		int currentYear = Integer.parseInt(year);
		int currentMonth = Integer.parseInt(month) - 1;
		cal = Calendar.getInstance();
		cal.set(currentYear, currentMonth, 1);
		int startNum = cal.get(Calendar.DAY_OF_WEEK);   	//선택 월의 시작요일을 구한다.
		int lastNum = cal.getActualMaximum(Calendar.DATE);  // 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
		cal.set(Calendar.DATE, lastNum);      				// Calendar 객체의 날짜를 마지막 날짜로 변경한다.
		int weekNum = cal.get(Calendar.WEEK_OF_MONTH);		// 마지막 날짜가 속한 주가 선택 월의 몇째 주인지 확인한다. 이렇게 하면 선택 월에 주가 몇번 있는지 확인할 수 있다.
		int calCnt = weekNum * 7;         					// 반복횟수를 정한다
		
		List<Object> holiday = new ArrayList<Object>();
		String date = "";
		for(int i=1; i<=lastNum; i++){
			date = year + "-";
			if(cal.get(Calendar.MONTH)+1 < 10){
				date += "0" + Integer.toString(cal.get(Calendar.MONTH)+1) + "-";
			}else{
				date += Integer.toString(cal.get(Calendar.MONTH)+1) + "-";
			}
			
			if(i < 10){
				date += "0" + Integer.toString(i);
			}else{
				date += Integer.toString(i);
			}
			
			if(holidayCheck(date)){
				holiday.add(date);
			}
			
			
		}

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("year", year);
		map.put("month", month);
		map.put("currentYear", currentYear);
		map.put("currentMonth", currentMonth);
		map.put("startNum", startNum);
		map.put("lastNum", lastNum);
		map.put("weekNum", weekNum);
		map.put("calCnt", calCnt);
		map.put("useDay", dao.useDay(year, month));
		map.put("holiday", holiday);
		
		return map;
	}
	public DiaryVO content(String day) {
		return dao.content(day);
	}
	public int diaryInsert(DiaryVO vo) {
		return dao.diaryInsert(vo);
	}
	public int diaryDelete(DiaryVO vo) {
		return dao.diaryDelete(vo);
	}
	public int diaryUpdate(DiaryVO vo) {
		return dao.diaryUpdate(vo);
	}
	public List<Object> useDay(String year, String month, String dayChange) {
		Calendar cal = Calendar.getInstance();
		if(!"".equals(year)){
			cal.set(Calendar.YEAR, Integer.parseInt(year));
		}
		if(!"".equals(month)){
			cal.set(Calendar.MONTH, Integer.parseInt(month)-1);
		}
		
		if("pre".equals(dayChange)){
			cal.add(Calendar.MONTH, -1);
		}else if("next".equals(dayChange)){
			cal.add(Calendar.MONTH, 1);
		}
		
		year = Integer.toString(cal.get(Calendar.YEAR));
		month = Integer.toString(cal.get(Calendar.MONTH)+1);
		
		List<Object> useDay = dao.useDay(year, month);
		
		return useDay;
	}
	
	public boolean holidayCheck(String today){				//음력공휴일 체크 후 공휴일이면 true를 반환한다
		ChineseCalendar chinaCal = new ChineseCalendar();
        Calendar cal = Calendar.getInstance() ;
        
        String[] arrLunar = {
                  "01-01"   // 설날 2
                , "01-02"   // 설날 3
                , "04-08"   // 부처님 오신날
                , "08-14"   // 추석 1
                , "08-15"   // 추석 2
                , "08-16"   // 추석 3
                , "12-31"   // 설날 1
                , "12-30"   // 설날 1
        };
        
        String[] holiday ={
        	"01-01"			//양력 설
        ,	"03-01"			//삼일절
        ,	"05-05"			//어린이날
        ,	"06-06"			//현충일
        ,	"08-15"			//광복절
        ,	"10-03"			//개천절
        ,	"10-09"			//한글날
        ,	"12-25"			//크리스마스
        		
        };
        
        cal.set(Calendar.YEAR, Integer.parseInt(today.substring(0, 4)));
        cal.set(Calendar.MONTH, Integer.parseInt(today.substring(5, 7)) - 1);
        cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(today.substring(8, 10)));
        chinaCal.setTimeInMillis(cal.getTimeInMillis());
        
        int chinaYY = chinaCal.get(ChineseCalendar.EXTENDED_YEAR) - 2637 ;
        int chinaMM = chinaCal.get(ChineseCalendar.MONTH) + 1;
        int chinaDD = chinaCal.get(ChineseCalendar.DAY_OF_MONTH);
         
        String chinaDate = "" ;     // 음력 날짜
         
        chinaDate += chinaYY ;      // 년
        chinaDate += "-" ;          // 연도 구분자         
         
        if(chinaMM < 10)         // 월
            chinaDate += "0" + Integer.toString(chinaMM) ;
        else
            chinaDate += Integer.toString(chinaMM) ;
         
         
        chinaDate += "-" ;          // 날짜 구분자
         
         
        if(chinaDD < 10)         // 일
            chinaDate += "0" + Integer.toString(chinaDD) ;
        else
            chinaDate += Integer.toString(chinaDD) ;
        
        boolean holidayCheck = false;
        
        for(String ob : arrLunar){
        	if(ob.equals(chinaDate.substring(5,10))){
        		holidayCheck = true;
        		break;
        	}
        }
        
        for(String ob : holiday){
        	if(ob.equals(today.substring(5,10))){
        		holidayCheck = true;
        		break;
        	}
        }
        
        return holidayCheck;
         
	}
	
}
