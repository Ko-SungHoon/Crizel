package com.crizel.mhw;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("footballDAO")
public class MhwDAO {
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List<MhwVO> monsterList(String type) {
		return sqlSession.selectList("mhw.monsterList", type);
	}
}
