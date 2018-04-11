package board;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BoardController {
	BoardService service;

	@Autowired
	public BoardController(BoardService service) {
		super();
		this.service = service;
	}

	@RequestMapping("board.do")
	public ModelAndView board(
			@RequestParam(value="pageParam", defaultValue="1") int pageParam,
			@RequestParam(value="search1", required=false) String search1,
			@RequestParam(value="keyword", required=false) String keyword) {
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("search1", search1);
		map.put("keyword", keyword);
		
		int page = pageParam; // 시작 페이지
		int countList = 10; // 한 페이지에 출력될 게시물 수
		int countPage = 10; // 한 화면에 출력될 페이지 수
		int totalCount = service.totalCount(map);
		int totalPage = totalCount / countList;
		if (totalCount % countList > 0) {
			totalPage++;
		}
		if (totalPage < page) {
			page = totalPage;
		}
		int startPage = ((page - 1) / countPage) * countPage + 1;
		int endPage = startPage + countPage - 1;
		if (endPage > totalPage) {
			endPage = totalPage;
		}
		
		int endRow = totalCount + countList - (countList * page);
		int startRow = totalCount + countList - (countList * page) - countPage+1;
		if(startRow <= 0){
			startRow = 1;
		}
		
		map.put("startRow", startRow);
		map.put("endRow", endRow);

		List<Object> list = service.board(map);

		int pre = page - countPage;
		if (page < countPage) {
			pre = startPage;
		}

		int next = page + countPage;
		if (page > totalPage - countPage) {
			next = endPage + 1;
		}
		ModelAndView mav = new ModelAndView();
		mav.addObject("totalCount",totalCount);
		mav.addObject("startPage",startPage);
		mav.addObject("endPage",endPage);
		mav.addObject("page",page);
		mav.addObject("pre",pre);
		mav.addObject("next",next);
		mav.addObject("totalPage",totalPage);
		mav.addObject("list",list);
		mav.addObject("search1", search1);
		mav.addObject("keyword", keyword);
		
		mav.setViewName("/board/board");
		return mav;
	}

	@RequestMapping("boardInsertPage.do")
	public ModelAndView boardInsertPage(
			@RequestParam(value="b_level", defaultValue="0")String b_level,
			@RequestParam(value="b_group", required=false)String b_group
			) {
		ModelAndView mav = new ModelAndView();		
		mav.addObject("b_level", b_level);
		mav.addObject("b_group", b_group);
		mav.setViewName("/board/boardInsertPage");
		return mav;
	}

	@RequestMapping("boardInsert.do")
	public String boardInsert(@ModelAttribute BoardVO vo,
			MultipartHttpServletRequest request
			) throws IllegalStateException,
			IOException {
		String path = "/crizel/upload/"; // 경로
		String saveFileName; // 저장되는 파일 이름
		String genId; // 파일 중복명 처리
		String originalfileName; // 본래 파일명

		File file = new File(path);
		if (!file.isDirectory()) {
			file.mkdirs();
		}

		List<MultipartFile> mf = request.getFiles("file");
		service.boardInsert(vo);

		for (int i = 0; i < mf.size(); i++) {
			genId = UUID.randomUUID().toString();
			originalfileName = mf.get(i).getOriginalFilename();
			if (!originalfileName.equals("")) {
				saveFileName = genId + "." + originalfileName;
				vo.setDirectory(path);
				vo.setReal_name(originalfileName);
				vo.setSave_name(saveFileName);
				vo.setB_id(service.searchBId());
				service.fileInsert(vo);
					
				mf.get(i).transferTo(new File(path + saveFileName));
			}
		}
		return "redirect:board.do?pageParam=1";
	}

	@RequestMapping("boardContent.do")
	public ModelAndView boardContent(@ModelAttribute BoardVO vo,
			@RequestParam(value="pageParam", defaultValue="1")String pageParam) {
		BoardVO list = service.boardContent(vo);
		List<BoardVO> file = service.boardContentFile(vo);
		ModelAndView mav = new ModelAndView();
		mav.addObject("list",list);
		mav.addObject("file",file);
		mav.addObject("page", pageParam);
		
		mav.setViewName("/board/boardContent");
		return mav;
	}

	@RequestMapping("boardDelete.do")
	public void boardDelete(@RequestParam int b_id,
			HttpServletResponse response) throws IOException {
		service.boardDelete(b_id);
		response.sendRedirect("/board.do");
	}
	
	@RequestMapping("boardUpdatePage.do")
	public ModelAndView boardUpdatePage(@ModelAttribute BoardVO vo) {
		BoardVO list = service.boardContent(vo);
		List<BoardVO> file = service.boardContentFile(vo);
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("list",list);
		mav.addObject("file",file);
		
		mav.setViewName("/board/boardUpdatePage");
		return mav;
	}
	
	@RequestMapping("boardUpdate.do")
	public void boardUpdate(@ModelAttribute BoardVO vo, HttpServletRequest httpRequest,
			MultipartHttpServletRequest request, HttpServletResponse response) throws IllegalStateException,
			IOException  {
		service.boardUpdate(vo);
		
		String path = "\\crizel\\upload\\"; // 경로
		String saveFileName; // 저장되는 파일 이름
		String genId; // 파일 중복명 처리
		String originalfileName; // 본래 파일명

		File file = new File(path);
		if (!file.isDirectory()) {
			file.mkdirs();
		}
		
		List<MultipartFile> mf = request.getFiles("file");
		
		for (int i = 0; i < mf.size(); i++) {
			genId = UUID.randomUUID().toString();
			originalfileName = mf.get(i).getOriginalFilename();
			if (!originalfileName.equals("")) {
				saveFileName = genId + "." + originalfileName;
				vo.setDirectory(path);
				vo.setReal_name(originalfileName);
				vo.setSave_name(saveFileName);
				service.fileInsert(vo);
				mf.get(i).transferTo(new File(path + saveFileName));

			}
		}
		
		response.sendRedirect("/board.do");
	}
	
	@RequestMapping("boardFileDel.do")
	public void boardFileDel(@ModelAttribute BoardVO vo) {
		service.boardFileDel(vo);
	}

	
	@RequestMapping("download.do")
	public void download(
			@RequestParam(value="directory", required=false) String directory, 
			@RequestParam(value="filename", required=false) String filename, 
			@RequestParam(value="check", required=false) String check,
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String realname = filename;
		
		String docName = URLEncoder.encode(realname, "UTF-8").replaceAll("\\+", " ");
		directory = URLEncoder.encode(directory, "UTF-8").replaceAll("\\+", " ");

		String filePath = directory + realname;
		
		try {
			File file = new File(filePath);
			if (!file.exists()) {
				try {
					throw new Exception();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
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
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
}
