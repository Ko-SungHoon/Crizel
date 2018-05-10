package com.crizel.controller;

import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.crizel.directory.DirectoryService;
import com.crizel.directory.DirectoryView;
import com.crizel.directory.ImageView;
import com.crizel.directory.VideoView;

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
	public ModelAndView nico(@RequestParam(value="path", required=false, defaultValue="d:/") String path){
		ModelAndView mav = new ModelAndView();	
		DirectoryView directory = new DirectoryView();
		mav.addObject("directory", directory.directory(path));
		mav.addObject("path", path);
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
	
}
