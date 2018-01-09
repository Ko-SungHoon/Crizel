package board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("boardDao")
public class BoardDao {
	@Autowired
	private SqlSessionFactory factory;

	public int totalCount() {
		return factory.openSession().selectOne("board.totalCount");
	}

	public void boardInsert(BoardVO vo) {
		factory.openSession().insert("board.boardInsert", vo);
	}

	public List<Object> board(Map<String, Integer> row) {
		return factory.openSession().selectList("board.board", row);
	}

	public BoardVO boardContent(BoardVO vo) {
		return factory.openSession().selectOne("board.boardContent", vo);
	}

	public void boardDelete(int b_id) {
		factory.openSession().update("board.boardDelete", b_id);
		factory.openSession().delete("board.fileAllDel", b_id);
	}

	public void boardUpdate(BoardVO vo) {
		factory.openSession().update("board.boardUpdate", vo);
	}

	public int searchBId() {
		return factory.openSession().selectOne("board.searchBId");
	}

	public void fileInsert(BoardVO vo) {
		factory.openSession().insert("board.fileInsert", vo);
	}

	public String realName(String filename) {
		return factory.openSession().selectOne("board.realName", filename);
	}

	public List<BoardVO> boardContentFile(BoardVO vo) {
		return factory.openSession().selectList("board.boardContentFile", vo);
	}

	public void boardFileDel(BoardVO vo) {
		factory.openSession().delete("board.boardFileDel", vo);
	}


}
