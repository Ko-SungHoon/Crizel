package com.crizel.football;

public class FootballVO {
	private String team_no;
	private String team_name; 
	private String team_name2;
  
	private String player_no; 
	//private String team_no;
	private String player_name; 
	private String player_eng_name; 
	private String player_birthday; 
	private String player_number;
	private String player_country;
	
	private String info_no;
	//private String player_no;
	private String season;
	private String goal;
	private String assist;
	  
	private String game_no; 
	//private String team_no;
	private String opponent_no;
	private String game_season; 
	private String game_type; 
	private String game_date;
	private String home_yn;
	private String our_score;
	private String opponent_score;
	  
	private String detail_no; 
	//private String game_no;
	//private String player_no;
	private String detail_type;
	private String goal_time;

	
	public String getTeam_no() {
		return team_no;
	}
	public void setTeam_no(String team_no) {
		if(team_no==null){
			this.team_no = "1";
		}else{
			this.team_no = team_no;
		}
		
	}
	public String getTeam_name() {
		return team_name;
	}
	public void setTeam_name(String team_name) {
		this.team_name = team_name;
	}
	
	public String getTeam_name2() {
		return team_name2;
	}
	public void setTeam_name2(String team_name2) {
		this.team_name2 = team_name2;
	}
	public String getPlayer_no() {
		return player_no;
	}
	public void setPlayer_no(String player_no) {
		this.player_no = player_no;
	}
	public String getPlayer_name() {
		return player_name;
	}
	public void setPlayer_name(String player_name) {
		this.player_name = player_name;
	}
	public String getPlayer_eng_name() {
		return player_eng_name;
	}
	public void setPlayer_eng_name(String player_eng_name) {
		this.player_eng_name = player_eng_name;
	}
	public String getPlayer_birthday() {
		return player_birthday;
	}
	public void setPlayer_birthday(String player_birthday) {
		this.player_birthday = player_birthday;
	}
	public String getPlayer_number() {
		return player_number;
	}
	public void setPlayer_number(String player_number) {
		this.player_number = player_number;
	}
	
	public String getPlayer_country() {
		return player_country;
	}
	public void setPlayer_country(String player_country) {
		this.player_country = player_country;
	}
	public String getInfo_no() {
		return info_no;
	}
	public void setInfo_no(String info_no) {
		this.info_no = info_no;
	}
	public String getSeason() {
		return season;
	}
	public void setSeason(String season) {
		this.season = season;
	}
	public String getGoal() {
		return goal;
	}
	public void setGoal(String goal) {
		this.goal = goal;
	}
	public String getAssist() {
		return assist;
	}
	public void setAssist(String assist) {
		this.assist = assist;
	}
	public String getGame_no() {
		return game_no;
	}
	public void setGame_no(String game_no) {
		this.game_no = game_no;
	}
	public String getOpponent_no() {
		return opponent_no;
	}
	public void setOpponent_no(String opponent_no) {
		this.opponent_no = opponent_no;
	}
	public String getGame_season() {
		return game_season;
	}
	public void setGame_season(String game_season) {
		this.game_season = game_season;
	}
	public String getGame_type() {
		return game_type;
	}
	public void setGame_type(String game_type) {
		this.game_type = game_type;
	}
	public String getGame_date() {
		return game_date;
	}
	public void setGame_date(String game_date) {
		this.game_date = game_date;
	}
	public String getHome_yn() {
		return home_yn;
	}
	public void setHome_yn(String home_yn) {
		this.home_yn = home_yn;
	}
	public String getOur_score() {
		return our_score;
	}
	public void setOur_score(String our_score) {
		this.our_score = our_score;
	}
	public String getOpponent_score() {
		return opponent_score;
	}
	public void setOpponent_score(String opponent_score) {
		this.opponent_score = opponent_score;
	}
	public String getDetail_no() {
		return detail_no;
	}
	public void setDetail_no(String detail_no) {
		this.detail_no = detail_no;
	}
	public String getDetail_type() {
		return detail_type;
	}
	public void setDetail_type(String detail_type) {
		this.detail_type = detail_type;
	}
	public String getGoal_time() {
		return goal_time;
	}
	public void setGoal_time(String goal_time) {
		this.goal_time = goal_time;
	}
	
	
}
