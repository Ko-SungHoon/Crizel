package money;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("MoneyDao")
public class MoneyDao {

	@Autowired
	private SqlSessionFactory factory;
	
	public List<MoneyVO> moneyDetail(String day, String id) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("day", day);
		map.put("id", id);
		return factory.openSession().selectList("usernamespace.moneyDetail",map);
	}

	public int insert(MoneyVO vo) {
		return factory.openSession().insert("usernamespace.insert",vo);
	}

	public int delete(String money_id, String id) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("money_id", money_id);
		map.put("id", id);
		return factory.openSession().delete("usernamespace.delete",map);
	}

	public int monthSum(String m, String id) {
		String month =m+".";
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("month", month);
		map.put("id", id);
		return factory.openSession().selectOne("usernamespace.monthSum",map);
	}

	public MoneyVO login(MoneyVO vo) {
		return factory.openSession().selectOne("usernamespace.login", vo);		
	}

	public void register(MoneyVO vo) {
		factory.openSession().insert("usernamespace.register", vo);		
		
	}

	public String registerCheck(String re_id) {
		return factory.openSession().selectOne("usernamespace.registerCheck",re_id);	
	}

	public List<MoneyVO> totalList(String year, String month, String id) {
		int mon = Integer.parseInt(month)+1;		
		String day = year + "." + mon;
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("day", day);
		map.put("id", id);
		return factory.openSession().selectList("usernamespace.totalList",map);
	}
}
