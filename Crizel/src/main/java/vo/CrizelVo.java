package vo;

import org.springframework.stereotype.Repository;

@Repository("vo")
public class CrizelVo {
	private String title;
	private String day;
	private String name;
	private String addr;
	private String id;
	private String ani_time;
	private int ani_id;
	private String keyword;	
	private String autoTitle;
	private int chapter;
	private String site;
	
	private String pw;
	private String email;
	private String phone;
	private String nick;
	private String register;
	
	private int board_id;
	private String subject;
	private String content;
	private String write_date;
	private int cnt;
	private int rownum;
	private int rnum;
	private String file_directory;
	private String realFile;
	private String saveFile;
	private int file_id;
	
	
	
	public String getSite() {
		return site;
	}
	public void setSite(String site) {
		this.site = site;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public String getAutoTitle() {
		return autoTitle;
	}
	public void setAutoTitle(String autoTitle) {
		this.autoTitle = autoTitle;
	}
	public int getChapter() {
		return chapter;
	}
	public void setChapter(int chapter) {
		this.chapter = chapter;
	}
	
	public String getFile_directory() {
		return file_directory;
	}
	public void setFile_directory(String file_directory) {
		this.file_directory = file_directory;
	}
	public String getRealFile() {
		return realFile;
	}
	public void setRealFile(String realFile) {
		this.realFile = realFile;
	}
	public String getSaveFile() {
		return saveFile;
	}
	public void setSaveFile(String saveFile) {
		this.saveFile = saveFile;
	}
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getBoard_id() {
		return board_id;
	}
	public void setBoard_id(int board_id) {
		this.board_id = board_id;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWrite_date() {
		return write_date;
	}
	public void setWrite_date(String write_date) {
		this.write_date = write_date;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getNick() {
		return nick;
	}
	public void setNick(String nick) {
		this.nick = nick;
	}
	public String getRegister() {
		return register;
	}
	public void setRegister(String register) {
		this.register = register;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getAni_time() {
		return ani_time;
	}
	public void setAni_time(String ani_time) {
		this.ani_time = ani_time;
	}
	public int getAni_id() {
		return ani_id;
	}
	public void setAni_id(int ani_id) {
		this.ani_id = ani_id;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	
}
