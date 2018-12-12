package com.crizel.common;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service("service")
public class CrizelService {
	@Autowired
	CrizelDao dao;
	
	@Autowired
	public CrizelService(CrizelDao dao) {
		super();
		this.dao = dao;
	}

	public List<Object> list(String day) {
		return dao.list(day);
	}

	public List<Map<String,Object>> listDetail(String keyword, String type, String site, String mode) throws Exception {
		return dao.listDetail(keyword,type,site,mode);
	}

	public void listInsert(CrizelVo vo) {
		dao.listInsert(vo);
		
	}
	public void aniDelete(CrizelVo vo) {
		dao.aniDelete(vo);
	}
	public CrizelVo login(CrizelVo vo) {		
		return dao.login(vo);
		
	}
		
	public void register(CrizelVo vo) {
		dao.register(vo);	
		
	}
	public String registerCheck(String re_id) {
		return dao.registerCheck(re_id);
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
	final static int size = 1024;
	public static void fileUrlReadAndDownload(String fileAddress, String localFileName, String downloadDir) {
		OutputStream outStream = null;
		URLConnection uCon = null;
		InputStream is = null;
		try {
			int byteRead;
			int byteWritten = 0;
			URL Url = new URL(fileAddress);
			outStream = new BufferedOutputStream(new FileOutputStream(downloadDir + "\\" + localFileName));
			uCon = Url.openConnection();
			uCon.addRequestProperty("User-Agent", "Mozilla/4.0");
			is = uCon.getInputStream();
			byte[] buf = new byte[size];
			while ((byteRead = is.read(buf)) != -1) {
				outStream.write(buf, 0, byteRead);
				byteWritten += byteRead;
			}
			System.out.println("Download Successfully.");
			System.out.println("File name : " + localFileName);
			System.out.println("of bytes  : " + byteWritten);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
				outStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void fileUrlDownload(String fileAddress, String downloadDir) {
		int slashIndex = fileAddress.lastIndexOf('/');
		int periodIndex = fileAddress.lastIndexOf('.');
		// 파일 어드레스에서 마지막에 있는 파일이름을 취득
		String fileName = fileAddress.substring(slashIndex + 1);
		if (periodIndex >= 1 && slashIndex >= 0
				&& slashIndex < fileAddress.length() - 1) {
			fileUrlReadAndDownload(fileAddress, fileName, downloadDir);
		} else {
			System.err.println("path or file name NG.");
		}
	}

	public CrizelVo aniInfo(String ani_id) {
		return dao.aniInfo(ani_id);
	}

	public void listUpdate(CrizelVo vo) {
		dao.listUpdate(vo);
	}

	public List<Map<String, Object>> onejav(String day) {
		return dao.onejav(day);
	}

}
