package nyaa;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import util.Nyaa;

@Service("nyaaService")
public class NyaaService {
	@Autowired
	NyaaDao dao;

	public List<Map<String, Object>> nyaaList(String type, String keyword) throws Exception {
		Nyaa nyaa = new Nyaa();
		return nyaa.nyaaList(type, keyword);
	}
	
}
