package com.crizel.admin;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service("adminService")
public class AdminService {
	@Resource(name="adminDao")
    private AdminDao dao;

	public List<AdminVO> menuList() {
		return dao.menuList();
	}
}
