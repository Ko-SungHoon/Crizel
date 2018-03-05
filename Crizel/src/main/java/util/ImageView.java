package util;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ImageView {
	public void ImageStream(String fileValue, HttpServletRequest request, HttpServletResponse response) {
		File file = new File(fileValue);
		InputStream is = null;
		OutputStream os = null;
		int read;
		try {
			response.setContentType("image/jpg");
			response.setHeader("Accept-Ranges", "bytes");
			response.setContentLength((int) file.length());
			
			is = new BufferedInputStream(new FileInputStream(file));
			os = response.getOutputStream();

			int bufferSize = 8*1024;
			byte buf[] = new byte[bufferSize];
			
			while ((read = is.read(buf, 0, 4096)) != -1) {
				os.write(buf, 0, read);
			}
			
			os.flush();
			os.close();
			is.close();
			
		} catch (Exception e) {
			e.toString();
		}
		
	}
}

