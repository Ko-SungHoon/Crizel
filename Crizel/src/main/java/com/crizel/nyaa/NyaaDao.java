package com.crizel.nyaa;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("nyaaDao")
public class NyaaDao {
	@Autowired
	private SqlSessionTemplate sqlSession;

}
