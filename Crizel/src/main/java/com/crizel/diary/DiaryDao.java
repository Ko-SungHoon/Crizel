package com.crizel.diary;

import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("diaryDao")
public class DiaryDao {
	@Autowired
	private SqlSessionTemplate sqlSession;;

	public DiaryVO content(String day) {
		return sqlSession.selectOne("diary.content", day);
	}
	public int diaryInsert(DiaryVO vo) {
		return sqlSession.insert("diary.diaryInsert", vo);
		
	}
	public int diaryDelete(DiaryVO vo) {
		return sqlSession.update("diary.diaryDelete", vo);
	}
	public int diaryUpdate(DiaryVO vo) {
		return sqlSession.update("diary.diaryUpdate", vo);
	}
	public List<Object> useDay(String year, String month) {
		if(Integer.parseInt(month) < 10){
			month = "0" + month;
		}
		String day = year.substring(2,4) + "/" + month + "/";
		return sqlSession.selectList("diary.useDay", day);
	}

}
