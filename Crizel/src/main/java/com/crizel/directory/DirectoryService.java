package com.crizel.directory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("DirectoryService")
public class DirectoryService {
	@Autowired
	DirectoryDao dao;
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
	@Autowired
	public DirectoryService(DirectoryDao dao) {
		super();
		this.dao = dao;
	}

	
}
