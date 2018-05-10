package com.crizel.board;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

@Service("boardService")
public class BoardService {
	@Resource(name="boardDao")
    private BoardDao dao;

	public int totalCount(Map<String, Object> map) {
		return dao.totalCount(map);
	}

	public void boardInsert(BoardVO vo) {
		dao.boardInsert(vo);
	}

	public List<Object> board(Map<String, Object> map) {
		return dao.board(map);
	}

	public BoardVO boardContent(BoardVO vo) {
		return dao.boardContent(vo);
	}

	public void boardDelete(int b_id) {
		dao.boardDelete(b_id);
	}

	public void boardUpdate(BoardVO vo) {
		dao.boardUpdate(vo);
	}

	public int searchBId() {
		return dao.searchBId();
	}

	public void fileInsert(BoardVO vo) {
		dao.fileInsert(vo);
	}

	public String realName(String filename) {
		return dao.realName(filename);
	}

	public List<BoardVO> boardContentFile(BoardVO vo) {
		return dao.boardContentFile(vo);
	}

	public void boardFileDel(BoardVO vo) {
		dao.boardFileDel(vo);
	}
	
}
