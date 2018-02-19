package girls;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("girlsService")
public class GirlsService {
	@Autowired
	GirlsDao dao;
	
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

	public void girlsDownload(String urlStr, String name) throws Exception {
		String file1 = urlStr.split("/")[urlStr.split("/").length-1];
		String file2 = file1.split("[.]")[file1.split("[.]").length-2];
		String ext = file1.split("[.]")[file1.split("[.]").length-1];
		
		int num = 0;
		while(true){
			num++;
			try{
				File file = new File("E://사진/" + name + "." + ext);
				if(file.exists()){
					if(isNumber(name.substring(name.length()-1))){
						num = Integer.parseInt(name.substring(name.length()-1))+1;
						name = name.substring(0, name.length()-1) + Integer.toString(num);
					}else{
						name = name + Integer.toString(num);
					}
				}else{
					break;
				}
			}catch(Exception e){
				System.out.println(e.toString());
			}
		}

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
		fos.close();
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
