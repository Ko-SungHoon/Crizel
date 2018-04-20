package money;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.util.Calendar;

@Service("MoneyService")
public class MoneyService {
	private MoneyDao dao;
	
	@Autowired
	public MoneyService(MoneyDao MoneyDao) {
		super();
		this.dao = MoneyDao;
	}

	public String calendar(String year, String month) {
		Calendar cal = Calendar.getInstance();

		String html = "";
		
		String day			= "";
		String dayPrice 	= "";
		
		if("".equals(year)){year = Integer.toString(cal.get(Calendar.YEAR));}
		if("".equals(month)){month = Integer.toString(cal.get(Calendar.MONTH)+1);}
		if(Integer.parseInt(month)<10){month = "0" + month;}
		
		List<Map<String,Object>> dataList = dao.moneyList(year, month);
		String totalData = dao.moneySum(year, month);
		
		int currentYear = Integer.parseInt(year);
		int currentMonth = Integer.parseInt(month) - 1;
		cal = Calendar.getInstance();
		cal.set(currentYear, currentMonth, 1);
		int startNum = cal.get(Calendar.DAY_OF_WEEK);   	//선택 월의 시작요일을 구한다.
		int lastNum = cal.getActualMaximum(Calendar.DATE);  // 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
		cal.set(Calendar.DATE, lastNum);      				// Calendar 객체의 날짜를 마지막 날짜로 변경한다.
		int weekNum = cal.get(Calendar.WEEK_OF_MONTH);   	// 마지막 날짜가 속한 주가 선택 월의 몇째 주인지 확인한다. 이렇게 하면 선택 월에 주가 몇번 있는지 확인할 수 있다.
		int dayVal = 1;            							//날짜를 출력할 변수
		int dayValCheck = 0;
		 
		html += "<tbody>";
		for(int i=0; i<weekNum; i++){
			
			html += "<tr>";
			for(int j=0; j<7; j++){
				day = dayVal<10?"0"+Integer.toString(dayVal):Integer.toString(dayVal);
				
				dayValCheck++;
				html += "<td";
				
				if(j==0){html += " class='sun'";}
				else if(j==6){html += " class='sat'";}
				
				for(Map<String,Object> ob : dataList){
					
					if((year+month+day).equals(ob.get("DAY").toString())){
						if(j==0){html += " class='sun on'";}
						else if(j==6){html += " class='sat on'";}
						else{html += " class = 'on'";}
						
						dayPrice = ob.get("PRICE").toString();
					}else{
						dayPrice = "";
					}
				}
				
				html += ">";
				if(dayValCheck >= startNum && dayVal<=lastNum){
					html += "<a class='day' href='/moneyView.do?day="+(year+month+day)+"'>";
					html += Integer.toString(dayVal++);
					if(!"".equals(dayPrice)){
					   html += "<br><span class='dayPrice'>" + dayPrice + "원</span>";
					}
					html += "</a>";
				}
				html += "</td>";
			}
			html += "</tr>";
		}
		html += "</tbody>";
		
		html += "<tfoot>";
		html += "<tr>";
		html += "<td colspan='7'>총합 : " + totalData + "원</td>";
		html += "</tr>";
		html += "</tfoot>";
		return html;
	}

	public List<MoneyVO> moneyView(String day) {
		return dao.moneyView(day);
	}

	public void moneyInsert(money.MoneyVO vo) {
		dao.moneyInsert(vo);
	}

	public void moneyDelete(String money_id) {
		dao.moneyDelete(money_id);
	}
	
}
