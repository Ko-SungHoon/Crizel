package com.crizel.money;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("MoneyDao")
public class MoneyDao {

	@Autowired
	private SqlSessionTemplate sqlSession;;

	public List<Map<String, Object>> moneyList(String year, String month) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("year", year);
		map.put("month", month);
		return sqlSession.selectList("money.moneyList",map);
	}
	
	public String moneySum(String year, String month) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("year", year);
		map.put("month", month);
		return sqlSession.selectOne("money.moneySum",map);
	}

	public List<MoneyVO> moneyView(String day) {
		return sqlSession.selectList("money.moneyView",day);
	}

	public void moneyInsert(MoneyVO vo) {
		sqlSession.insert("money.moneyInsert",vo);
	}

	public void moneyDelete(String money_id) {
		sqlSession.delete("money.moneyDelete",money_id);
	}
	
}
