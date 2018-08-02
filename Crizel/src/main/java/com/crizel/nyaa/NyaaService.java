package com.crizel.nyaa;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("nyaaService")
public class NyaaService {
	@Autowired
	NyaaDao dao;

	public List<Map<String, Object>> nyaaList(String type, String keyword) throws Exception {
		NyaaUtil nyaa = new NyaaUtil();
		return nyaa.NyaaList(type, keyword);
	}
	
}
