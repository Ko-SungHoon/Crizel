package com.crizel.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("adminService")
public class AdminService {
	@Autowired
	AdminDAO adminDAO;

	public List<AdminVO> menuList() {
		return adminDAO.menuList();
	}
}
