package girls;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("girlsService")
public class GirlsService {
	@Autowired
	GirlsDao dao;
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	
	@Autowired
	public GirlsService(GirlsDao dao) {
		super();
		this.dao = dao;
	}

	public List<Object> nameList() {
		return dao.nameList();
	}

	public void girlsInsert(GirlsVO vo) {
		dao.girlsInsert(vo);
	}

	public void girlsDelete(GirlsVO vo) {
		dao.girlsDelete(vo);
	}

	public List<Object> girlsImg(String name) {
		if("".equals(name)){
			name = parseNull(dao.girlsGetName());
		}
		return dao.girlsImg(name);
	}

}
