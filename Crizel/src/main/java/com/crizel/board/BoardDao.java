package com.crizel.board;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("boardDao")
public class BoardDao {
	@Autowired
    private SqlSessionTemplate sqlSession;

	public int totalCount(Map<String, Object> map) {
		return sqlSession.selectOne("board.totalCount", map);
	}

	public void boardInsert(BoardVO vo) {
		sqlSession.insert("board.boardInsert", vo);
	}

	public List<Object> board(Map<String, Object> map) {
		return sqlSession.selectList("board.board", map);
	}

	public BoardVO boardContent(BoardVO vo) {
		return sqlSession.selectOne("board.boardContent", vo);
	}

	public void boardDelete(int b_id) {
		sqlSession.update("board.boardDelete", b_id);
		sqlSession.delete("board.fileAllDel", b_id);
	}

	public void boardUpdate(BoardVO vo) {
		sqlSession.update("board.boardUpdate", vo);
	}

	public int searchBId() {
		return sqlSession.selectOne("board.searchBId");
	}

	public void fileInsert(BoardVO vo) {
		sqlSession.insert("board.fileInsert", vo);
	}

	public String realName(String filename) {
		return sqlSession.selectOne("board.realName", filename);
	}

	public List<BoardVO> boardContentFile(BoardVO vo) {
		return sqlSession.selectList("board.boardContentFile", vo);
	}

	public void boardFileDel(BoardVO vo) {
		sqlSession.delete("board.boardFileDel", vo);
	}


}
