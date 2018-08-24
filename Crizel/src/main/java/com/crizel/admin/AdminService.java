package com.crizel.admin;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service("adminService")
public class AdminService {
	@Autowired
	private AdminDAO adminDAO;

	public List<AdminVO> menuList() {
		return adminDAO.menuList();
	}
}
