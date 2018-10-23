package com.crizel.directory;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DirectoryController {
	DirectoryService service;

	@Autowired
	public DirectoryController(DirectoryService service) {
		super();
		this.service = service;
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}

	@RequestMapping("directory.do")
	public ModelAndView nico(@RequestParam(value="path", required=false, defaultValue="D:/") String path){
		ModelAndView mav = new ModelAndView();	
		DirectoryView directory = new DirectoryView();
		mav.addObject("directory", directory.directory(path));
		mav.addObject("path", path);
		mav.addObject("path2", path.substring(0,1));
		mav.addObject("pathArray", path.split("/"));
		mav.setViewName("/directory/main");
		return mav;
	}
	
	@RequestMapping("videoViewPage")
	public ModelAndView videoViewPage(
			@RequestParam(value="fileValue", required=false)String fileValue,
			@RequestParam(value="type", required=false)String type,
			HttpServletRequest request,HttpServletResponse response) throws Exception{
		ModelAndView mav = new ModelAndView();
		String path = request.getParameter("path")==null?"":request.getParameter("path");
		
		if(!"".equals(path)){
			DirectoryView directory = new DirectoryView();
			List<String> imgList = directory.directAllImg(path);
			mav.addObject("imgList", imgList);
		}else{
			mav.addObject("fileValue", URLEncoder.encode(fileValue, "UTF-8"));
		}
		
		mav.addObject("type", type);
		mav.setViewName("directory/view");
		return mav;
	}
	
	@RequestMapping("videoView")
	public void videoView(
			@RequestParam(value="fileValue", required=false)String fileValue,
			@RequestParam(value="type", required=false)String type,
			HttpServletRequest request,HttpServletResponse response){
		if("video".equals(type)){
			VideoView vv = new VideoView();
			vv.VideoViewStream(fileValue, request, response);
		}else{
			ImageView iv = new ImageView();
			iv.ImageStream(fileValue, request, response);
		}
	}
	
	@RequestMapping("directoryDownload.do")
	public void download(
			@RequestParam(value="directory", required=false) String directory, 
			@RequestParam(value="filename", required=false) String filename, 
			@RequestParam(value="check", required=false) String check,
			HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String realname = filename;
		
		String docName = URLEncoder.encode(realname, "UTF-8").replaceAll("\\+", " ");
		//directory = URLEncoder.encode(directory, "UTF-8").replaceAll("\\+", " ");

		String filePath = directory + "/" + realname;
		
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
	
}
