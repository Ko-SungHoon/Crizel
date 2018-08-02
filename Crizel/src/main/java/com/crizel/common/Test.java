package com.crizel.common;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class Test {
	@RequestMapping("test.do")
	public void test(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String path = "E:\\test.txt";					//	명령어 임시 저장 파일 경로
		String text = request.getParameter("text");		//	사용자 계정, 패스워드와 명령어를 조합(추후 구현 예정)
		
		response.setHeader("Content-Disposition", "attachment;filename=test.sh");	//	.sh 파일로 다운로드
		response.setHeader("Content-Type", "application/octet-stream");
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");

		BufferedInputStream bis = null;
		OutputStream os = null;
		File file = null;

		BufferedWriter bw = null;

		int read;
		byte readByte[] = new byte[4096];
		try {
			bw = new BufferedWriter(new FileWriter(path));		//	명령어 임시 저장 파일 경로에
			bw.write(text);										//	사용자 계정, 패스워드와 명령어를 조합한 텍스트를 저장
			bw.flush();
			bw.close();
		    
			file = new File(path);
		    
			bis = new BufferedInputStream(new FileInputStream(file));
			os = response.getOutputStream();

			while ((read = bis.read(readByte, 0, 4096)) != -1) {	//	저장된 파일을 .sh 확장자로 다운로드
				os.write(readByte, 0, read);
			}
			
			bw = new BufferedWriter(new FileWriter(path));			//	서버에 저장된 임시 파일의 내용을 공백으로 수정
			bw.write("");
			bw.flush();
			bw.close();
			
		} finally {
			os.flush();
			os.close();
			bis.close();
		}
	}
	
	@RequestMapping("test2.do")
	public String test2(){
		return "../../index";
	}
}
