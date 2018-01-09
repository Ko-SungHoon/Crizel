package model;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import vo.MoneyVO;

@Service("MoneyService")
public class MoneyService {
	private MoneyDao MoneyDao;
	
	@Autowired
	public MoneyService(MoneyDao MoneyDao) {
		super();
		this.MoneyDao = MoneyDao;
	}
	//가계부 상세내용 불러오기
	public List<MoneyVO> moneyDetail(String day, String id) {
		return MoneyDao.moneyDetail(day, id);
	}

	public int insert(MoneyVO vo) {
		return MoneyDao.insert(vo);
	}
	public int delete(String money_id, String id) {
		return MoneyDao.delete(money_id, id);
	}
	public int monthSum(String m, String id) {
		return MoneyDao.monthSum(m, id);
	}
	public MoneyVO login(MoneyVO vo) {		
		return MoneyDao.login(vo);
		
	}
	public void register(vo.MoneyVO vo) {
		MoneyDao.register(vo);	
		
	}
	public String registerCheck(String re_id) {
		return MoneyDao.registerCheck(re_id);
	}
	public List<vo.MoneyVO> totalList(String year, String month, String id) {
		return MoneyDao.totalList(year, month, id);
	}
	
}
