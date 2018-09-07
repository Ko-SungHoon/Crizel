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

	public int totalCount(BoardVO boardVO) {
		return sqlSession.selectOne("board.totalCount", boardVO);
	}

	public List<BoardVO> boardList(BoardVO boardVO) {
		return sqlSession.selectList("board.boardList", boardVO);
	}

	public BoardVO boardInfo(BoardVO boardVO) {
		sqlSession.update("board.viewCountIncrease", boardVO);
		return sqlSession.selectOne("board.boardInfo", boardVO);
	}

	public List<BoardVO> fileList(BoardVO boardVO) {
		return sqlSession.selectList("board.fileList", boardVO);
	}

	public int boardWriteAction(BoardVO boardVO) {
		if(boardVO.getB_no()==0){
			return sqlSession.insert("board.boardWriteAction", boardVO);
		}else{
			return sqlSession.update("board.boardUpdateAction", boardVO);
		}
		
	}

	public void boardFileWrite(BoardVO boardVO) {
		sqlSession.insert("board.boardFileWrite", boardVO);
	}

	public int boardDelete(BoardVO boardVO) {
		return sqlSession.update("board.boardDelete", boardVO);
	}

	public BoardVO fileInfo(BoardVO boardVO) {
		return sqlSession.selectOne("board.fileInfo", boardVO);
	}

	

}
