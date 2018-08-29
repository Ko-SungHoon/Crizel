package com.crizel.football;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FootballController {
	@Autowired
	FootballService footballService;
	
	@RequestMapping("/football/main")
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		FootballVO lastGame = footballService.lastGame();
		
		mav.addObject("lastGame", lastGame);
		mav.setViewName("/football/main");
		
		return mav;
	}
	
	@RequestMapping("/football/team")
	public ModelAndView team(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		List<FootballVO> teamList = footballService.teamList(vo);	
		
		mav.addObject("teamList", teamList);
		mav.setViewName("/football/team");
		return mav;
	}
	
	@RequestMapping("/football/teamInsertPage")
	public ModelAndView teamInsertPage(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		if(vo.getTeam_no()!=null){
			FootballVO teamInfo = footballService.teamInfo(vo);
			mav.addObject("teamInfo", teamInfo);
		}
		
		mav.setViewName("/football/teamInsertPage");
		return mav;
	}
	
	@RequestMapping("/football/teamInsertAction")
	public ModelAndView teamInsertAction(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		if(vo.getTeam_no()!=null){
			footballService.teamUpdateAction(vo);
		}else{
			footballService.teamInsertAction(vo);
		}
		
		return team(request, response, session, vo);
	}
	
	@RequestMapping("/football/player")
	public ModelAndView player(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		List<FootballVO> playerList = footballService.playerList(vo);
		
		mav.addObject("team_no", vo.getTeam_no());
		mav.addObject("playerList", playerList);
		mav.setViewName("/football/player");
		return mav;
	}
	
	@RequestMapping("/football/playerInsertPage")
	public ModelAndView playerInsertPage(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		if(vo.getPlayer_no()!=null){
			FootballVO playerInfo = footballService.playerInfo(vo);
			mav.addObject("playerInfo", playerInfo);
		}
		mav.addObject("team_no", vo.getTeam_no());
		mav.setViewName("/football/playerInsertPage");
		return mav;
	}
	
	@RequestMapping("/football/playerInsertAction")
	public ModelAndView playerInsertAction(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		if(vo.getPlayer_no()!=null){
			footballService.playerUpdateAction(vo);
		}else{
			footballService.playerInsertAction(vo);
		}
		
		return player(request, response, session, vo);
	}
	
	@RequestMapping("/football/playerInfo")
	public ModelAndView playerInfo(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		
		FootballVO playerInfo = footballService.playerInfo(vo);
		mav.addObject("playerInfo", playerInfo);
		
		List<FootballVO> playerInfoList = footballService.playerInfoList(vo);
		mav.addObject("playerInfoList", playerInfoList);
		
		mav.setViewName("/football/playerInfo");
		return mav;
	}
	
	@RequestMapping("/football/result")
	public ModelAndView result(HttpServletRequest request, HttpServletResponse response, HttpSession session, FootballVO vo){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/football/result");
		return mav;
	}
}
