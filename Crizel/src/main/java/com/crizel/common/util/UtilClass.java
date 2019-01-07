package com.crizel.common.util;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class UtilClass {
	public String testSHA256(String str){
		String SHA = ""; 
		try{
			MessageDigest sh = MessageDigest.getInstance("SHA-256"); 
			sh.update(str.getBytes()); 
			byte byteData[] = sh.digest();
			StringBuffer sb = new StringBuffer(); 
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			SHA = sb.toString();
		}catch(NoSuchAlgorithmException e){
			e.printStackTrace(); 
			SHA = null; 
		}
		return SHA;
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
	public void downImage(String addr, String name) throws Exception{
		URL url = new URL(addr);
	    InputStream in = new BufferedInputStream(url.openStream());
	    ByteArrayOutputStream out = new ByteArrayOutputStream();
	    byte[] buf = new byte[1024];
	    int n = 0;
	    while (-1 != (n = in.read(buf))) {
	        out.write(buf, 0, n);
	    }
	    out.close();
	    in.close();
	    byte[] response = out.toByteArray();
		
		File file = new File("/tomcat/images/" + name);
	    if(!file.exists()){
	    	file.mkdirs();
	    }
	    
	    boolean fileCheck = true;
	    int fileNo = 0;
	    FileOutputStream fos = null;
	    while(fileCheck){
	    	fileNo++;
	    	file = new File("/tomcat/images/" + name + "/" + addr.replaceAll("/", "") + ".jpg");	
	    	if(!file.exists()){
	    		fos = new FileOutputStream("/tomcat/images/" + name + "/" + addr.replaceAll("/", "") + ".jpg");
	    		fos.write(response);
	    	    fos.close();
	    		fileCheck = false;
	    	}
	    }
	}
}
