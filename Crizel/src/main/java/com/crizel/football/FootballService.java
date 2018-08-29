package com.crizel.football;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("liverpoolService")
public class FootballService {
	@Autowired
	FootballDAO footballDAO;

	public FootballVO lastGame() {
		return footballDAO.lastGame();
	}

	public FootballVO teamInfo(FootballVO vo) {
		return footballDAO.teamInfo(vo);
	}

	public void teamInsertAction(FootballVO vo) {
		footballDAO.teamInsertAction(vo);
	}

	public void teamUpdateAction(FootballVO vo) {
		footballDAO.teamUpdateAction(vo);
	}

	public List<FootballVO> teamList(FootballVO vo) {
		return footballDAO.teamList(vo);
	}

	public List<FootballVO> playerList(FootballVO vo) {
		return footballDAO.playerList(vo);
	}

	public FootballVO playerInfo(FootballVO vo) {
		return footballDAO.playerInfo(vo);
	}

	public List<FootballVO> playerInfoList(FootballVO vo) {
		return footballDAO.playerInfoList(vo);
	}

	public void playerInsertAction(FootballVO vo) {
		footballDAO.playerInsertAction(vo);
	}

	public void playerUpdateAction(FootballVO vo) {
		footballDAO.playerUpdateAction(vo);
	}
}
