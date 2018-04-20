package money;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("MoneyDao")
public class MoneyDao {

	@Autowired
	private SqlSessionFactory factory;

	public List<Map<String, Object>> moneyList(String year, String month) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("year", year);
		map.put("month", month);
		return factory.openSession().selectList("money.moneyList",map);
	}
	
	public String moneySum(String year, String month) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("year", year);
		map.put("month", month);
		return factory.openSession().selectOne("money.moneySum",map);
	}

	public List<MoneyVO> moneyView(String day) {
		return factory.openSession().selectList("money.moneyView",day);
	}

	public void moneyInsert(MoneyVO vo) {
		factory.openSession().insert("money.moneyInsert",vo);
	}

	public void moneyDelete(String money_id) {
		factory.openSession().delete("money.moneyDelete",money_id);
	}
	
}
