package com.crizel.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

@Service("boardService")
public class BoardService {
	@Resource(name="boardDao")
    private BoardDao dao;

	public Map<String, Object> boardList(BoardVO boardVO) {
		Map<String,Object> map = new HashMap<String,Object>();
		int pageNo 		= boardVO.getPageNo();
		int totalCount 	= dao.totalCount(boardVO);
		int countList 	= boardVO.getCountList(); 	// 한 페이지에 출력될 게시물 수
		int countPage 	= boardVO.getCountPage(); 	// 한 화면에 출력될 페이지 수
		int totalPage 	= boardVO.getTotalPage();	// 전체 페이지
		int startPage 	= boardVO.getStartPage();	// 시작 페이지
		int endPage 	= boardVO.getEndPage();		// 마지막 페이지
		int startRow 	= boardVO.getStartRow();
		int endRow 		= boardVO.getEndRow(); 
		
		totalPage = (totalCount + (countList - 1)) / countList;
		startPage = ((pageNo-1)/countPage) * countPage + 1;
		endPage = startPage + countPage - 1;
		endPage = endPage>totalPage?totalPage:endPage;
		startRow = (pageNo-1) * countList + 1;
		endRow = pageNo * countList;
		
		boardVO.setTotalCount(totalCount);
		boardVO.setTotalPage(totalPage);
		boardVO.setStartPage(startPage);
		boardVO.setEndPage(endPage);
		boardVO.setStartRow(startRow);
		boardVO.setEndRow(endRow);
		
		map.put("boardList", dao.boardList(boardVO));
		map.put("boardVO", boardVO);
		
		return map;
	}

	public BoardVO boardInfo(BoardVO boardVO) {
		return dao.boardInfo(boardVO);
	}

	public List<BoardVO> fileList(BoardVO boardVO) {
		return dao.fileList(boardVO);
	}

	public int boardWriteAction(BoardVO boardVO) {
		return dao.boardWriteAction(boardVO);
	}

	public void boardFileWrite(BoardVO boardVO) {
		dao.boardFileWrite(boardVO);
	}

	public int boardDelete(BoardVO boardVO) {
		return dao.boardDelete(boardVO);
	}

	public BoardVO fileInfo(BoardVO boardVO) {
		return dao.fileInfo(boardVO);
	}

	public int fileDelete(BoardVO boardVO) {
		return dao.fileDelete(boardVO);
	}
}
