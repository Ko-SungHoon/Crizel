package com.crizel.diary;

import org.springframework.stereotype.Repository;

@Repository("diaryVO")
public class DiaryVO {
	private int diary_id;
	private String diary_date;
	private String content;
	private String delete_status;
	
	public int getDiary_id() {
		return diary_id;
	}
	public void setDiary_id(int diary_id) {
		this.diary_id = diary_id;
	}
	public String getDiary_date() {
		return diary_date;
	}
	public void setDiary_date(String diary_date) {
		this.diary_date = diary_date;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getDelete_status() {
		return delete_status;
	}
	public void setDelete_status(String delete_status) {
		this.delete_status = delete_status;
	}
	
	
	
}
