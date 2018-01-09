package board;

import org.springframework.stereotype.Repository;

@Repository("boardVO")
public class BoardVO {
	//게시판
	private int rnum;
	private int b_id;
	private int b_group;
	private int b_level;
	private String title;
	private String user_nick;
	private String content;
	private int view_count;
	private String notice;
	private String secret;
	private String password;
	private String register_date;
	private String modify_date;
	private String delete_status;
	private String tmp_field1;
	private String tmp_field2;
	private String tmp_field3;
	private String tmp_field4;
	private String tmp_field5;
	private String tmp_field6;
	private String tmp_field7;
	private String tmp_field8;
	private String tmp_field9;
	private String tmp_field10;
	
	//첨부파일
	private int f_id;
	private String directory;
	private String save_name;
	private String real_name;
	
	//댓글
	private int c_id;
	private int c_group;
	private int c_level;
	
	
	
	
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getB_id() {
		return b_id;
	}
	public void setB_id(int b_id) {
		this.b_id = b_id;
	}
	public int getB_group() {
		return b_group;
	}
	public void setB_group(int b_group) {
		this.b_group = b_group;
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
	public int getF_id() {
		return f_id;
	}
	public void setF_id(int f_id) {
		this.f_id = f_id;
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
	public int getC_id() {
		return c_id;
	}
	public void setC_id(int c_id) {
		this.c_id = c_id;
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
