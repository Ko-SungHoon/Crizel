package com.crizel.directory;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("DirectoryDao")
public class DirectoryDao {
	@Autowired
	private SqlSessionTemplate sqlSession;

}
