package controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.MoneyService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import vo.MoneyVO;

@Controller
public class MoneyController {
	MoneyService MoneyService;
	MoneyVO MoneyVO;

	@Autowired
	public MoneyController(MoneyService MoneyService) {
		super();
		this.MoneyService = MoneyService;
	}
	
	@RequestMapping("/main.do")
	public ModelAndView main(@RequestParam String y, String m, String id,HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView();		
		Calendar cal = Calendar.getInstance();
		
		if(y.equals("y")&&m.equals("m")){
			y = Integer.toString(cal.get(Calendar.YEAR));
			m = Integer.toString(cal.get(Calendar.MONTH)+1);	
		}		
		
		int currentYear = Integer.parseInt(y);
		int currentMonth = Integer.parseInt(m) - 1;
		cal = Calendar.getInstance();
		cal.set(currentYear, currentMonth, 1);

		// 선택 월의 시작요일을 구한다.
		int startNum = cal.get(Calendar.DAY_OF_WEEK);
		// 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
		int lastNum = cal.getActualMaximum(Calendar.DATE);

		// Calendar 객체의 날짜를 마지막 날짜로 변경한다.
		cal.set(Calendar.DATE, lastNum);

		// 마지막 날짜가 속한 주가 선택 월의 몇째 주인지 확인한다. 이렇게 하면 선택 월에 주가 몇번 있는지 확인할 수 있다.
		int weekNum = cal.get(Calendar.WEEK_OF_MONTH);
		// 반복횟수를 정한다
		int cnt = weekNum * 7;
		String day2;
		List<MoneyVO> list;
		List<Object> list2 = new ArrayList<Object>();
		HashMap<String, Object> map2;
		int daySum = 0;
		int daySumNum = 0;
		for (int i = 0, j = 1; i <= cnt; i++) {
			if (i >= startNum && j <= lastNum) {
				map2 = new HashMap<String, Object>();
				day2 = y + "." + m + "." + j;
				list = MoneyService.moneyDetail(day2, id);		//하루 소비내용 상세
				for (int k = 0; k < list.size(); k++) {
					daySum += list.get(k).getPrice();		//불러온 소비내용에서 금액만 골라내서 더함
					map2.put("daySum", daySum);				//해당요일 총액
					map2.put("daSumNum", daySumNum);		
					daySumNum++;
				}
				daySum = 0;
				map2.put("check", j);
				list2.add(map2);
				j++;
			}
		}
		if (daySumNum != 0) {
			int monthSum = MoneyService.monthSum(y+"."+m, id);		//해당 월 총 소비액 
			mav.addObject("monthSum", monthSum);
		}		
		
		mav.addObject("daySum",daySum);
		mav.addObject("startNum",startNum);
		mav.addObject("lastNum",lastNum);
		mav.addObject("cnt",cnt);
		mav.addObject("year",currentYear);
		mav.addObject("month",currentMonth);
		mav.addObject("price",list2);
		
		mav.setViewName("/money/main");
		return mav;
	}

	@RequestMapping("/moneyDetail.do")
	public ModelAndView moneyDetail(@RequestParam String year, String month,
			String day, String id) throws Exception {
		Calendar cal = Calendar.getInstance();
		int currentYear = Integer.parseInt(year);
		int currentMonth = Integer.parseInt(month) - 1;
		int currentDay = Integer.parseInt(day);
		cal = Calendar.getInstance();
		cal.set(currentYear, currentMonth + 1, currentDay);
		int dayofweekNum = cal.get(Calendar.DAY_OF_WEEK) - 1;
		String dayofweek[] = { "일", "월", "화", "수", "목", "금", "토" };
		HashMap<String, Object> map = new HashMap<String, Object>();
		String day2 = year + "." + (Integer.parseInt(month) + 1) + "." + day; // 디비에서
																				// 검색할
																				// 날짜양식
		List<MoneyVO> list = MoneyService.moneyDetail(day2, id);
		
		ModelAndView mav = new ModelAndView();		
		mav.addObject("list",list);
		mav.addObject("year",year);
		mav.addObject("month",Integer.parseInt(month) + 1);
		mav.addObject("day",day);
		mav.addObject("dayofweek",dayofweek[dayofweekNum]);
		mav.setViewName("/money/list");
		return mav;
	}

	@RequestMapping("/insert.do")
	public String insert(@ModelAttribute MoneyVO vo,
			@RequestParam String year, String month, String day2)
			throws Exception {
		MoneyService.insert(vo);
		return "redirect:moneyDetail.do?year="+year+"&month="+month+"&day="+day2+"&id="+vo.getId();
	}

	@RequestMapping("/delete.do")
	public String delete(@RequestParam String money_id, String year,
			String month, String day2, String id) throws Exception {
		MoneyService.delete(money_id, id);
		return "redirect:moneyDetail.do?year="+year+"&month="+month+"&day="+day2+"&id="+id;
	}

	
	@RequestMapping("/totalList.do")
	public ModelAndView totalList(@RequestParam String year, String month, String id) throws Exception {
		List<MoneyVO> list = MoneyService.totalList(year, month, id);
		ModelAndView mav = new ModelAndView();		
		mav.addObject("list",list);
		mav.setViewName("/money/totalList");
		return mav;
	}
}
