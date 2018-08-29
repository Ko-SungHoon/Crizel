package com.crizel.football;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("footballDAO")
public class FootballDAO {
	@Autowired
	private SqlSessionTemplate sqlSession;

	public FootballVO lastGame() {
		return sqlSession.selectOne("football.lastGame");
	}

	public FootballVO teamInfo(FootballVO vo) {
		return sqlSession.selectOne("football.teamInfo", vo);
	}

	public void teamInsertAction(FootballVO vo) {
		sqlSession.insert("football.teamInsertAction", vo);
	}

	public void teamUpdateAction(FootballVO vo) {
		sqlSession.update("football.teamUpdateAction", vo);
	}

	public List<FootballVO> teamList(FootballVO vo) {
		return sqlSession.selectList("football.teamList", vo);
	}

	public List<FootballVO> playerList(FootballVO vo) {
		return sqlSession.selectList("football.playerList", vo);
	}

	public FootballVO playerInfo(FootballVO vo) {
		return sqlSession.selectOne("football.playerInfo", vo);
	}

	public List<FootballVO> playerInfoList(FootballVO vo) {
		return sqlSession.selectList("football.playerInfoList", vo);
	}

	public void playerInsertAction(FootballVO vo) {
		sqlSession.insert("football.playerInsertAction", vo);
	}

	public void playerUpdateAction(FootballVO vo) {
		sqlSession.update("football.playerUpdateAction", vo);
	}
}
