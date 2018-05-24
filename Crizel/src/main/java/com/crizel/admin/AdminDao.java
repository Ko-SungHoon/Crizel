package com.crizel.admin;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("adminDao")
public class AdminDao {
	@Autowired
    private SqlSessionTemplate sqlSession;

	public List<AdminVO> menuList() {
		return sqlSession.selectList("admin.menuList");
	}
}
