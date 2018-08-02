package com.crizel.girls;

import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("girlsService")
public class GirlsService {
	@Resource(name="girlsDao")
    private GirlsDao dao;
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
	@Autowired
	public GirlsService(GirlsDao dao) {
		super();
		this.dao = dao;
	}

	public List<Object> nameList() {
		return dao.nameList();
	}

	public void girlsInsert(GirlsVO vo) {
		dao.girlsInsert(vo);
	}

	public void girlsDelete(GirlsVO vo) {
		dao.girlsDelete(vo);
	}

	public List<Object> girlsImg(String name) {
		if("".equals(name)){
			name = parseNull(dao.girlsGetName());
		}
		return dao.girlsImg(name);
	}

	public void girlsDownload(String urlStr, String name, HttpServletResponse response) throws Exception {
		/*String file1 = urlStr.split("/")[urlStr.split("/").length-1];
		String file2 = file1.split("[.]")[file1.split("[.]").length-2];
		String ext = file1.split("[.]")[file1.split("[.]").length-1];

		URL url = new URL(urlStr);
		InputStream in = new BufferedInputStream(url.openStream());
		ByteArrayOutputStream outs = new ByteArrayOutputStream();
		byte[] buf = new byte[1024];
		int n = 0;
		while (-1 != (n = in.read(buf))) {
			outs.write(buf, 0, n);
		}
		outs.close();	
		in.close();
		byte[] bytes = outs.toByteArray();

		FileOutputStream fos = new FileOutputStream("E://사진/" + name + "." + ext);
		fos.write(bytes);
		fos.close();*/
		
		String split = (urlStr.split("/")[urlStr.split("/").length-1]);
		String ext = split.split("\\.")[split.split("\\.").length-1];
		
		List<String> extList = new ArrayList<String>();
		extList.add("jpg");
		extList.add("png");
		extList.add("bmp");
		extList.add("jpeg");
		extList.add("gif");
		extList.add("JPG");
		extList.add("PNG");
		extList.add("BMP");
		extList.add("JPEG");
		extList.add("GIF");
		
		if(!extList.contains(ext)){
			ext = "jpg";
		}
		
		response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(name, "UTF-8").replace("+", "%20") + "." + ext);
		response.setHeader("Content-Type", "application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");
		
		double len = 0;
	    byte[] buffer = new byte[1024];
	    BufferedOutputStream outs = null;
	    InputStream inputStream = null;
	    URL url2 = null;
	 
	    try {
	    	url2 = new URL(urlStr); // 요청 url
	        inputStream = url2.openStream();
	        outs = new BufferedOutputStream(response.getOutputStream());
	        while ((len = inputStream.read(buffer)) != -1) {
	            outs.write(buffer, 0, (int) len);
	        }
	    } finally {
	        if(outs != null) {
	            outs.close();
	        }
	        if(inputStream != null) {
	            inputStream.close();
	        }
	    }

	}

	public boolean isNumber(String str){
		boolean bool = false;
		try{
			Integer.parseInt(str);
			bool = true;
		}catch(NumberFormatException e){
			bool = false;
		}
		return bool;
	}
}
