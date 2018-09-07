package com.crizel.board;

import org.springframework.stereotype.Repository;

@Repository("boardVO")
public class BoardVO {
	//게시판
	private int rnum = 0;
	private int b_no = 0;
	private int parent_b_no = 0;
	private int b_level = 0;
	private String title = "";
	private String user_nick = "";
	private String user_id = "";
	private String content = "";
	private int view_count = 0;
	private String notice = "";
	private String secret = "";
	private String password = "";
	private String register_date = "";
	private String modify_date = "";
	private String delete_status = "";
	private String tmp_field1 = "";
	private String tmp_field2 = "";
	private String tmp_field3 = "";
	private String tmp_field4 = "";
	private String tmp_field5 = "";
	private String tmp_field6 = "";
	private String tmp_field7 = "";
	private String tmp_field8 = "";
	private String tmp_field9 = "";
	private String tmp_field10 = "";
	
	//첨부파일
	private int f_no = 0;
	private String directory = "";
	private String save_name = "";
	private String real_name = "";
	
	//댓글
	private int c_no = 0;
	private int c_group = 0;
	private int c_level = 0;
	
	// 검색조건
	private String search1 = "";
	private String search2 = "";
	private String search3 = "";
	private String search4 = "";
	private String search5 = "";
	private String keyword = "";
	private String order1 = "";
	private String order2 = "";
	private String order3 = "";
	
	// 페이징
	private int pageNo = 1;
	private int countList = 10; 	// 한 페이지에 출력될 게시물 수
	private int countPage = 10; 	// 한 화면에 출력될 페이지 수
	private int totalCount = 0;		// 전체 게시물 수
	private int totalPage = 0;		// 전체 페이지
	private int startPage = 0;		// 시작 페이지
	private int endPage = 0;		// 마지막 페이지
	private int startRow = 0;
	private int endRow = 0; 
	
	
	
	public int getPageNo() {
		return pageNo;
	}
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	
	public int getCountList() {
		return countList;
	}
	public void setCountList(int countList) {
		this.countList = countList;
	}
	public int getCountPage() {
		return countPage;
	}
	public void setCountPage(int countPage) {
		this.countPage = countPage;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public int getStartRow() {
		return startRow;
	}
	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}
	public int getEndRow() {
		return endRow;
	}
	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}
	public String getSearch1() {
		return search1;
	}
	public void setSearch1(String search1) {
		this.search1 = search1;
	}
	public String getSearch2() {
		return search2;
	}
	public void setSearch2(String search2) {
		this.search2 = search2;
	}
	public String getSearch3() {
		return search3;
	}
	public void setSearch3(String search3) {
		this.search3 = search3;
	}
	public String getSearch4() {
		return search4;
	}
	public void setSearch4(String search4) {
		this.search4 = search4;
	}
	public String getSearch5() {
		return search5;
	}
	public void setSearch5(String search5) {
		this.search5 = search5;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getOrder1() {
		return order1;
	}
	public void setOrder1(String order1) {
		this.order1 = order1;
	}
	public String getOrder2() {
		return order2;
	}
	public void setOrder2(String order2) {
		this.order2 = order2;
	}
	public String getOrder3() {
		return order3;
	}
	public void setOrder3(String order3) {
		this.order3 = order3;
	}
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getB_no() {
		return b_no;
	}
	public void setB_no(int b_no) {
		this.b_no = b_no;
	}
	public int getParent_b_no() {
		return parent_b_no;
	}
	public void setParent_b_no(int parent_b_no) {
		this.parent_b_no = parent_b_no;
	}
	public int getB_level() {
		return b_level;
	}
	public void setB_level(int b_level) {
		this.b_level = b_level;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getUser_nick() {
		return user_nick;
	}
	public void setUser_nick(String user_nick) {
		this.user_nick = user_nick;
	}
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public void setC_no(int c_no) {
		this.c_no = c_no;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getView_count() {
		return view_count;
	}
	public void setView_count(int view_count) {
		this.view_count = view_count;
	}
	public String getNotice() {
		return notice;
	}
	public void setNotice(String notice) {
		this.notice = notice;
	}
	public String getSecret() {
		return secret;
	}
	public void setSecret(String secret) {
		this.secret = secret;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRegister_date() {
		return register_date;
	}
	public void setRegister_date(String register_date) {
		this.register_date = register_date;
	}
	public String getModify_date() {
		return modify_date;
	}
	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}
	public String getDelete_status() {
		return delete_status;
	}
	public void setDelete_status(String delete_status) {
		this.delete_status = delete_status;
	}
	public String getTmp_field1() {
		return tmp_field1;
	}
	public void setTmp_field1(String tmp_field1) {
		this.tmp_field1 = tmp_field1;
	}
	public String getTmp_field2() {
		return tmp_field2;
	}
	public void setTmp_field2(String tmp_field2) {
		this.tmp_field2 = tmp_field2;
	}
	public String getTmp_field3() {
		return tmp_field3;
	}
	public void setTmp_field3(String tmp_field3) {
		this.tmp_field3 = tmp_field3;
	}
	public String getTmp_field4() {
		return tmp_field4;
	}
	public void setTmp_field4(String tmp_field4) {
		this.tmp_field4 = tmp_field4;
	}
	public String getTmp_field5() {
		return tmp_field5;
	}
	public void setTmp_field5(String tmp_field5) {
		this.tmp_field5 = tmp_field5;
	}
	public String getTmp_field6() {
		return tmp_field6;
	}
	public void setTmp_field6(String tmp_field6) {
		this.tmp_field6 = tmp_field6;
	}
	public String getTmp_field7() {
		return tmp_field7;
	}
	public void setTmp_field7(String tmp_field7) {
		this.tmp_field7 = tmp_field7;
	}
	public String getTmp_field8() {
		return tmp_field8;
	}
	public void setTmp_field8(String tmp_field8) {
		this.tmp_field8 = tmp_field8;
	}
	public String getTmp_field9() {
		return tmp_field9;
	}
	public void setTmp_field9(String tmp_field9) {
		this.tmp_field9 = tmp_field9;
	}
	public String getTmp_field10() {
		return tmp_field10;
	}
	public void setTmp_field10(String tmp_field10) {
		this.tmp_field10 = tmp_field10;
	}
	public int getF_no() {
		return f_no;
	}
	public void setF_no(int f_no) {
		this.f_no = f_no;
	}
	public String getDirectory() {
		return directory;
	}
	public void setDirectory(String directory) {
		this.directory = directory;
	}
	public String getSave_name() {
		return save_name;
	}
	public void setSave_name(String save_name) {
		this.save_name = save_name;
	}
	public String getReal_name() {
		return real_name;
	}
	public void setReal_name(String real_name) {
		this.real_name = real_name;
	}
	public int getC_no() {
		return c_no;
	}
	public int getC_group() {
		return c_group;
	}
	public void setC_group(int c_group) {
		this.c_group = c_group;
	}
	public int getC_level() {
		return c_level;
	}
	public void setC_level(int c_level) {
		this.c_level = c_level;
	}
	
	
	
}
