package com.crizel.admin;

import org.springframework.stereotype.Repository;

@Repository("adminVO")
public class AdminVO {
	private int menu_no;
	private String menu_title;
	private int parent_menu_no;
	private int menu_level;
	private int menu_order;
	private int content_no;
	private String view_yn;
	private String register_date;
	private String modify_date;
	
	//private int content_no;
	private String content_title;
	private String content_type;
	private String content_link;
	//private String register_date;
	//private String modify_date;
	
	public int getMenu_no() {
		return menu_no;
	}
	public void setMenu_no(int menu_no) {
		this.menu_no = menu_no;
	}
	public String getMenu_title() {
		return menu_title;
	}
	public void setMenu_title(String menu_title) {
		this.menu_title = menu_title;
	}
	public int getParent_menu_no() {
		return parent_menu_no;
	}
	public void setParent_menu_no(int parent_menu_no) {
		this.parent_menu_no = parent_menu_no;
	}
	public int getMenu_level() {
		return menu_level;
	}
	public void setMenu_level(int menu_level) {
		this.menu_level = menu_level;
	}
	public int getMenu_order() {
		return menu_order;
	}
	public void setMenu_order(int menu_order) {
		this.menu_order = menu_order;
	}
	public int getContent_no() {
		return content_no;
	}
	public void setContent_no(int content_no) {
		this.content_no = content_no;
	}
	public String getView_yn() {
		return view_yn;
	}
	public void setView_yn(String view_yn) {
		this.view_yn = view_yn;
	}
	public String getRegister_date() {
		return register_date;
	}
	public void setRegister_date(String register_date) {
		this.register_date = register_date;
	}
	public String getContent_title() {
		return content_title;
	}
	public void setContent_title(String content_title) {
		this.content_title = content_title;
	}
	public String getContent_type() {
		return content_type;
	}
	public void setContent_type(String content_type) {
		this.content_type = content_type;
	}
	public String getContent_link() {
		return content_link;
	}
	public void setContent_link(String content_link) {
		this.content_link = content_link;
	}
	public String getModify_date() {
		return modify_date;
	}
	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}
	
	
	
}
