package directory;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VideoView {
	public void VideoViewStream(String fileValue, HttpServletRequest request, HttpServletResponse response) {
		String split = (fileValue.split("/")[fileValue.split("/").length-1]);
		String ext = split.split("\\.")[split.split("\\.").length-1];
		
		File file = new File(fileValue);
		InputStream is = null;
		OutputStream os = null;
		long rangeStart = 0;
		long rangeEnd 	= 0;
		boolean isPart	= false;
		try {
			RandomAccessFile randomFile = new RandomAccessFile(file, "r");
			
			long movieSize = randomFile.length();
			String range = request.getHeader("range");
			
			if(range != null){
				if(range.endsWith("-")){
					range = range + (movieSize - 1);
				}
				
				int idxm = range.trim().indexOf("-");
				rangeStart 	= Long.parseLong(range.substring(6,idxm));
				rangeEnd	= Long.parseLong(range.substring(idxm + 1)); 
				
				if(rangeStart > 0){
					isPart = true;
				}
			}else{
				rangeStart = 0;
				rangeEnd = movieSize - 1;
			}
			
			long partSize = rangeEnd - rangeStart + 1;
			
			response.reset();
			
			response.setStatus(isPart ? 206 : 200);
			response.setContentType("video/"+ext);
			response.setHeader("Content-Type", "application/octet-stream");
			response.setHeader("Content-Range", "bytes " + rangeStart + "-" + rangeEnd + "/" + movieSize);
			response.setHeader("Accept-Ranges", "bytes");
			response.setHeader("Content-Length", "" + partSize);
			
			is = new BufferedInputStream(new FileInputStream(file));
			os = response.getOutputStream();
			
			randomFile.seek(rangeStart);

			int bufferSize = 8*1024;
			byte buf[] = new byte[bufferSize];
			
			do{
				int block = partSize > bufferSize ? bufferSize : (int)partSize;
				int len = randomFile.read(buf, 0, block);
				os.write(buf, 0, len);
				partSize -= block;
			}
			while (partSize>0);
			
			os.flush();
			os.close();
			is.close();
			randomFile.close();
			
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		
	}
}

