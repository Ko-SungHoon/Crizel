package com.crizel.board;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.crizel.common.CrizelVo;

@Controller
public class BoardController {
	@Resource(name="boardService")
    private BoardService service;

	@RequestMapping("/board")
	public ModelAndView board(HttpServletRequest request, HttpServletResponse response, HttpSession session, BoardVO boardVO) {
		ModelAndView mav = new ModelAndView();
		
		List<BoardVO> boardList = service.boardList(boardVO);
		
		mav.addObject("boardList", boardList);
		mav.addObject("pageNo", boardVO.getPageNo());
		mav.setViewName("/board/list");
		return mav;
	}
	
	@RequestMapping("/boardWritePage")
	public ModelAndView boardWritePage(HttpServletRequest request, HttpServletResponse response, HttpSession session, BoardVO boardVO) {
		ModelAndView mav = new ModelAndView();
		String listUrl = "";
		listUrl += "/board.do?pageNo="+boardVO.getPageNo();
		listUrl += "&search1="+boardVO.getSearch1();
		listUrl += "&keyword="+boardVO.getKeyword();
		
		BoardVO boardInfo 		= service.boardInfo(boardVO);
		List<BoardVO> fileList	= service.fileList(boardVO);
		
		CrizelVo crizelVO = (CrizelVo)session.getAttribute("login");
		
		if(boardVO.getB_no()==0){
			boardInfo = new BoardVO();
			boardInfo.setUser_nick(crizelVO.getNick());
			boardInfo.setUser_id(crizelVO.getId());
		}
		
		mav.addObject("boardInfo", boardInfo);
		mav.addObject("fileList", fileList);
		mav.addObject("fileSize", 5-fileList.size());
		mav.addObject("listUrl", listUrl);
		mav.setViewName("/board/write");
		return mav;
	}
	
	@RequestMapping("/boardWriteAction")
	public ModelAndView boardWriteAction(MultipartHttpServletRequest request, HttpServletResponse response, HttpSession session, BoardVO boardVO) throws Exception {
		ModelAndView mav = new ModelAndView();
		String message 		= 	boardVO.getB_no()==0?"글이 등록되었습니다.":"글이 수정되었습니다";
		String returnPage	=	boardVO.getB_no()==0?"/board.do":"/boardRead.do?b_no="+boardVO.getB_no();
		
		int boardWriteAction = service.boardWriteAction(boardVO);
		
		String directory 	= "E:\\test\\";
		String real_name 	= "";
		String save_name 	= "";
		
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("YYMMDDhhmmssms");
		String thistime = "";
		
		List<MultipartFile> mf = request.getFiles("uploadFile");
		for (int i = 0; i < mf.size(); i++) {
			if(!"".equals(mf.get(i).getOriginalFilename())){
				thistime = dateFormat.format(calendar.getTime());		// 중복제거용 시간
	            real_name = mf.get(i).getOriginalFilename();			// 본래 파일명
	            save_name = thistime + "_" + real_name;					// 저장되는 파일 이름
	            //long fileSize = mf.get(i).getSize(); 					// 파일 사이즈
	            mf.get(i).transferTo(new File(directory + save_name)); 	// 파일 저장
	            
	            boardVO.setReal_name(real_name);
	            boardVO.setSave_name(save_name);
	            boardVO.setDirectory(directory);
	            
	            service.boardFileWrite(boardVO);
			}
        }
		
		if(boardWriteAction>0){
			mav.addObject("message", message);
			mav.addObject("returnPage", returnPage);
			mav.setViewName("/util/alertPage");
		}else{
			mav.addObject("message", "처리중 오류가 발생하였습니다.");
			mav.addObject("returnPage", returnPage);
			mav.setViewName("/util/alertPage");
		}
		return mav;
	}
	
	@RequestMapping("/boardRead")
	public ModelAndView boardRead(HttpServletRequest request, HttpServletResponse response, HttpSession session, BoardVO boardVO) {
		ModelAndView mav = new ModelAndView();
		String listUrl = "";
		listUrl += "/board.do?pageNo="+boardVO.getPageNo();
		listUrl += "&search1="+boardVO.getSearch1();
		listUrl += "&keyword="+boardVO.getKeyword();
		
		BoardVO boardInfo = service.boardInfo(boardVO);
		List<BoardVO> fileList	= service.fileList(boardVO);
		
		List<BoardVO> imgList = null;
		if(fileList!=null && fileList.size()>0){
			imgList = new ArrayList<BoardVO>();
			for(int i=0; i<fileList.size(); i++){
				BoardVO ob = fileList.get(i);
				if("jpg".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "JPG".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "png".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "PNG".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "gif".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "GIF".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "bmp".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "BMP".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
				   || "".equals(ob.getSave_name().substring(ob.getSave_name().lastIndexOf(".")+1, ob.getSave_name().length()))
						){
					imgList.add(ob);					
				}
			}
		}
		
		mav.addObject("boardInfo", boardInfo);
		mav.addObject("fileList", fileList);
		mav.addObject("imgList", imgList);
		mav.addObject("listUrl", listUrl);
		mav.setViewName("/board/read");
		return mav;
	}
	
	@RequestMapping("/boardDelete")
	public ModelAndView boardDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session, BoardVO boardVO) {
		ModelAndView mav = new ModelAndView();
		String message 		= 	"글이 삭제되었습니다";
		String returnPage	=	"/board.do";
		
		int boardDelete = service.boardDelete(boardVO);
		
		if(boardDelete>0){
			mav.addObject("message", message);
			mav.addObject("returnPage", returnPage);
			mav.setViewName("/util/alertPage");
		}else{
			mav.addObject("message", "처리중 오류가 발생하였습니다.");
			mav.addObject("returnPage", returnPage);
			mav.setViewName("/util/alertPage");
		}
		return mav;
	}
	
	@RequestMapping("download.do")
	public void download(HttpServletRequest request, HttpServletResponse response, HttpSession session, BoardVO boardVO) throws Exception{
		BoardVO fileInfo = service.fileInfo(boardVO);
		
		String real_name = fileInfo.getReal_name();
		String save_name = fileInfo.getSave_name();	
		String directory = fileInfo.getDirectory();
		
		real_name = URLEncoder.encode(real_name, "UTF-8").replaceAll("\\+", " ");

		String filePath = directory + save_name;
		
		try {
			File file = new File(filePath);
			if (!file.exists()) {
				try {
					throw new Exception();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			response.setHeader("Content-Disposition", "attachment;filename=" + real_name + ";");
			response.setHeader("Content-Type", "application/octet-stream");
			response.setContentLength((int) file.length());
			response.setHeader("Content-Transfer-Encoding", "binary;");
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");
			int read;
			byte readByte[] = new byte[4096];

			BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
			OutputStream outs = response.getOutputStream();

			while ((read = fin.read(readByte, 0, 4096)) != -1) {
				outs.write(readByte, 0, read);
			}

			outs.flush();
			outs.close();
			fin.close();

		} catch (java.io.IOException e) {
			if (!e.getClass().getName().equals("org.apache.catalina.connector.ClientAbortException")) {

			}

		}
	}

}
