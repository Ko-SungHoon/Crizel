package com.crizel.mhw;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("mhwService")
public class MhwService {
	@Autowired
	MhwDAO mhwDAO;

	public List<MhwVO> monsterList(String type) {
		return mhwDAO.monsterList(type);
	}
}
