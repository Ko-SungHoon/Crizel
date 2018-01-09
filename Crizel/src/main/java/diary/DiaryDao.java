package diary;

import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("diaryDao")
public class DiaryDao {
	@Autowired
	private SqlSessionFactory factory;

	public DiaryVO content(String day) {
		return factory.openSession().selectOne("diary.content", day);
	}
	public int diaryInsert(DiaryVO vo) {
		return factory.openSession().insert("diary.diaryInsert", vo);
		
	}
	public int diaryDelete(DiaryVO vo) {
		return factory.openSession().update("diary.diaryDelete", vo);
	}
	public int diaryUpdate(DiaryVO vo) {
		return factory.openSession().update("diary.diaryUpdate", vo);
	}
	public List<Object> useDay(String year, String month) {
		String day = year.substring(2,4) + "/" + month + "/";
		return factory.openSession().selectList("diary.useDay", day);
	}

}
