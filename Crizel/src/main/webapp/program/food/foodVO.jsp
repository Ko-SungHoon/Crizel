<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.springframework.jdbc.core.RowMapper"%>

<%!
public class FoodVO{
	public String rnum = "";
	
	public String sch_no = "";
	public String sch_org_sid = "";
	public String sch_type = "";
	public String sch_id = "";
	public String sch_nm = "";
	public String sch_tel = "";
	public String sch_fax = "";
	public String sch_area = "";
	public String sch_post = "";
	public String sch_addr = "";
	public String sch_found = "";
	public String sch_url = "";
	public String sch_gen = "";
	public String show_flag = "";
	public String reg_date = "";
	public String zone_no = "";
	public String team_no = "";
	public String sch_grade = "";
	public String sch_lv = "";
	public String sch_pw = "";
	public String sch_app_flag = "";
	public String app_date = "";
	public String etc1 = "";
	public String etc2 = "";
	public String etc3 = "";
	
	public String nu_no = "";
	//public String sch_no;
	public String nu_nm = "";
	public String nu_tel = "";
	public String nu_mail = "";
	//public String show_flag;
	
	//public String zone_no = "";
	public String zone_nm = "";
	//public String reg_date = "";
	public String mod_date = "";
	//public String show_flag = "";
	
	//public String team_no = "";
	//public String zone_no = "";
	public String team_nm = "";
	//public String reg_date = "";
	//public String mod_date = "";
	//public String show_flag = "";
	public String order1 = "";
	public String order2 = "";
	public String order3 = "";
	
	public String cnt = "";
	
	public String sid = "";
	public String title = "";
	public String user_nm = "";
	public String addr = "";
	public String tel = "";
	public String area_type = "";
	public String found = "";
	public String coedu = "";
	
	public String cat_no = "";
	public String cat_nm = "";
	//public String reg_date;
	//public String mod_date;
	//public String show_flag;
	public String unit_no = "";
	public String unit_val = "";
	
	public String nm_no = "";
	//public String cat_no;
	public String nm_food = "";
	//public String show_flag;
	//public String reg_date;
	//public String mod_date;
	
	public String dt_no = "";
	//public String cat_no;
	public String dt_nm = "";
	//public String show_flag;
	//public String reg_date;
	//public String mod_date;
	
	public String ex_no = "";
	//public String cat_no;
	public String ex_nm = "";
	//public String show_flag;
	//public String reg_date;
	//public String mod_date;
	
	//public String unit_no;
	public String unit_nm = "";
	public String unit_type = "";
	//public String show_flag;
	//public String reg_date;
	//public String mod_date;
	
	public String upd_no = "";
	//public String sch_no = "";
	//public String nu_no = "";
	public String s_item_no = "";
	public String n_item_code = "";
	public String n_item_nm = "";
	public String n_item_dt_nm = "";
	public String n_item_expl = "";
	public String n_item_unit = "";
	public String upd_flag = "";
	public String upd_reason = "";
	public String sts_flag = "";
	public String rjc_reason = "";
	//public String reg_date = "";
	public String rjc_date = "";
	//public String mod_date = "";
	public String sts_date = "";
	//public String show_flag = "";
	
	public String item_grp_no 		= "";
	public String item_grp_order 	= "";
	public String item_comp_no 		= "";
	public String item_comp_val 	= "";
    
    public String low_ratio = "";
    public String avr_ratio = "";
    public String lb_ratio  = "";
	
	public String item_no = "";
	//public String cat_no = "";
	public String food_nm_1 = "";
	public String food_nm_2 = "";
	public String food_nm_3 = "";
	public String food_nm_4 = "";
	public String food_nm_5 = "";
	public String food_unit = "";
	public String food_dt_1 = "";
	public String food_dt_2 = "";
	public String food_dt_3 = "";
	public String food_dt_4 = "";
	public String food_dt_5 = "";
	public String food_dt_6 = "";
	public String food_dt_7 = "";
	public String food_dt_8 = "";
	public String food_dt_9 = "";
	public String food_dt_10 = "";
	public String food_ep_1 = "";
	public String food_ep_2 = "";
	public String food_ep_3 = "";
	public String food_ep_4 = "";
	public String food_ep_5 = "";
	public String food_ep_6 = "";
	public String food_ep_7 = "";
	public String food_ep_8 = "";
	public String food_ep_9 = "";
	public String food_ep_10 = "";
	public String food_ep_11 = "";
	public String food_ep_12 = "";
	public String food_ep_13 = "";
	public String food_ep_14 = "";
	public String food_ep_15 = "";
	public String food_ep_16 = "";
	public String food_ep_17 = "";
	public String food_ep_18 = "";
	public String food_ep_19 = "";
	public String food_ep_20 = "";
	public String food_ep_21 = "";
	public String food_ep_22 = "";
	public String food_ep_23 = "";
	public String food_ep_24 = "";
	public String food_ep_25 = "";
	public String food_code = "";
	//public String reg_date = "";
	//public String mod_date = "";
	//public String show_flag = "";
	public String uniq_id	=	"";
	public String food_cat_index = "";
	
	public String file_no		=	"";
	public String file_nm		=	"";
	public String file_org_nm	=	"";
	//public String reg_date		=	"";
	//public String mod_date		=	"";
	public String reg_ip		=	"";
	public String reg_id		=	"";
	public String suc_flag		=	"";
	public String fail_reason	=	"";
	public String file_type		=	"";
	
}

public class FoodList implements RowMapper<FoodVO> {
    public FoodVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	FoodVO vo 	= new FoodVO();
    	String column 	= "";
    	for(int i=1; i<=rs.getMetaData().getColumnCount(); i++){		// 컬럼의 총 갯수만큼 반복하며 컬럼명과 같은 변수명에 데이터 입력
    		column = rs.getMetaData().getColumnLabel(i);
    		if("RNUM".equals(column)){					vo.rnum				=	parseNull(rs.getString("RNUM"));			}
    		else if("SCH_NO".equals(column)){			vo.sch_no			=	parseNull(rs.getString("SCH_NO"));			}
    		else if("SCH_ORG_SID".equals(column)){		vo.sch_org_sid		=	parseNull(rs.getString("SCH_ORG_SID"));		}
    		else if("SCH_TYPE".equals(column)){			vo.sch_type			=	parseNull(rs.getString("SCH_TYPE"));		}
    		else if("SCH_ID".equals(column)){			vo.sch_id			=	parseNull(rs.getString("SCH_ID"));			}
    		else if("SCH_NM".equals(column)){			vo.sch_nm			=	parseNull(rs.getString("SCH_NM"));			}
    		else if("SCH_TEL".equals(column)){			vo.sch_tel			=	parseNull(rs.getString("SCH_TEL"));			}
    		else if("SCH_FAX".equals(column)){			vo.sch_fax			=	parseNull(rs.getString("SCH_FAX"));			}
    		else if("SCH_AREA".equals(column)){			vo.sch_area			=	parseNull(rs.getString("SCH_AREA"));		}
    		else if("SCH_POST".equals(column)){			vo.sch_post			=	parseNull(rs.getString("SCH_POST"));		}
    		else if("SCH_ADDR".equals(column)){			vo.sch_addr			=	parseNull(rs.getString("SCH_ADDR"));		}
    		else if("SCH_FOUND".equals(column)){		vo.sch_found		=	parseNull(rs.getString("SCH_FOUND"));		}
    		else if("SCH_URL".equals(column)){			vo.sch_url			=	parseNull(rs.getString("SCH_URL"));			}
    		else if("SCH_GEN".equals(column)){			vo.sch_gen			=	parseNull(rs.getString("SCH_GEN"));			}		
    		else if("SHOW_FLAG".equals(column)){		vo.show_flag		=	parseNull(rs.getString("SHOW_FLAG"));		}
    		else if("REG_DATE".equals(column)){			vo.reg_date			=	parseNull(rs.getString("REG_DATE"));		}
    		else if("ZONE_NO".equals(column)){			vo.zone_no			=	parseNull(rs.getString("ZONE_NO"));			}
    		else if("TEAM_NO".equals(column)){			vo.team_no			=	parseNull(rs.getString("TEAM_NO"));			}
    		else if("SCH_GRADE".equals(column)){		vo.sch_grade		=	parseNull(rs.getString("SCH_GRADE"));		}
    		else if("SCH_LV".equals(column)){			vo.sch_lv			=	parseNull(rs.getString("SCH_LV"));			}
    		else if("SCH_PW".equals(column)){			vo.sch_pw			=	parseNull(rs.getString("SCH_PW"));			}
    		else if("SCH_APP_FLAG".equals(column)){		vo.sch_app_flag		=	parseNull(rs.getString("SCH_APP_FLAG"));	}
    		else if("APP_DATE".equals(column)){			vo.app_date			=	parseNull(rs.getString("APP_DATE"));		}
    		else if("ETC1".equals(column)){				vo.etc1				=	parseNull(rs.getString("ETC1"));			}
    		else if("ETC2".equals(column)){				vo.etc2				=	parseNull(rs.getString("ETC2"));			}
    		else if("ETC3".equals(column)){				vo.etc3				=	parseNull(rs.getString("ETC3"));			}
    		else if("NU_NO".equals(column)){			vo.nu_no			=	parseNull(rs.getString("NU_NO"));			}
    		else if("NU_NM".equals(column)){			vo.nu_nm			=	parseNull(rs.getString("NU_NM"));			}
    		else if("NU_TEL".equals(column)){			vo.nu_tel			=	parseNull(rs.getString("NU_TEL"));			}
    		else if("NU_MAIL".equals(column)){			vo.nu_mail			=	parseNull(rs.getString("NU_MAIL"));			}
    		else if("ZONE_NM".equals(column)){			vo.zone_nm			=	parseNull(rs.getString("ZONE_NM"));			}
			else if("MOD_DATE".equals(column)){			vo.mod_date			=	parseNull(rs.getString("MOD_DATE"));		}
			else if("TEAM_NM".equals(column)){			vo.team_nm			=	parseNull(rs.getString("TEAM_NM"));			}
			else if("ORDER1".equals(column)){			vo.order1			=	parseNull(rs.getString("ORDER1"));			}
			else if("ORDER2".equals(column)){			vo.order2			=	parseNull(rs.getString("ORDER2"));			}
			else if("ORDER3".equals(column)){			vo.order3			=	parseNull(rs.getString("ORDER3"));			}
			else if("CNT".equals(column)){				vo.cnt				=	parseNull(rs.getString("CNT"));				}
			else if("SID".equals(column)){				vo.sid				=	parseNull(rs.getString("SID"));				}
			else if("TITLE".equals(column)){			vo.title			=	parseNull(rs.getString("TITLE"));			}
			else if("USER_NM".equals(column)){			vo.user_nm			=	parseNull(rs.getString("USER_NM"));			}
			else if("ADDR".equals(column)){				vo.addr				=	parseNull(rs.getString("ADDR"));			}
			else if("TEL".equals(column)){				vo.tel				=	parseNull(rs.getString("TEL"));				}
			else if("AREA_TYPE".equals(column)){		vo.area_type		=	parseNull(rs.getString("AREA_TYPE"));		}
			else if("FOUND".equals(column)){			vo.found			=	parseNull(rs.getString("FOUND"));			}
			else if("COEDU".equals(column)){			vo.coedu			=	parseNull(rs.getString("COEDU"));			}
			else if("CAT_NO".equals(column)){			vo.cat_no			=	parseNull(rs.getString("CAT_NO"));			}
			else if("CAT_NM".equals(column)){			vo.cat_nm			=	parseNull(rs.getString("CAT_NM"));			}
			else if("UNIT_NO".equals(column)){			vo.unit_no			=	parseNull(rs.getString("UNIT_NO"));			}
			else if("UNIT_VAL".equals(column)){			vo.unit_val			=	parseNull(rs.getString("UNIT_VAL"));		}
			else if("NM_NO".equals(column)){			vo.nm_no			=	parseNull(rs.getString("NM_NO"));			}
			else if("NM_FOOD".equals(column)){			vo.nm_food			=	parseNull(rs.getString("NM_FOOD"));			}
			else if("DT_NO".equals(column)){			vo.dt_no			=	parseNull(rs.getString("DT_NO"));			}
			else if("DT_NM".equals(column)){			vo.dt_nm			=	parseNull(rs.getString("DT_NM"));			}
			else if("EX_NO".equals(column)){			vo.ex_no			=	parseNull(rs.getString("EX_NO"));			}
			else if("EX_NM".equals(column)){			vo.ex_nm			=	parseNull(rs.getString("EX_NM"));			}
			else if("UNIT_NM".equals(column)){			vo.unit_nm			=	parseNull(rs.getString("UNIT_NM"));			}
			else if("UNIT_TYPE".equals(column)){		vo.unit_type		=	parseNull(rs.getString("UNIT_TYPE"));		}
			else if("UPD_NO".equals(column)){			vo.upd_no			=	parseNull(rs.getString("UPD_NO"));			}
			else if("S_ITEM_NO".equals(column)){		vo.s_item_no		=	parseNull(rs.getString("S_ITEM_NO"));		}
			else if("N_ITEM_CODE".equals(column)){		vo.n_item_code		=	parseNull(rs.getString("N_ITEM_CODE"));		}
			else if("N_ITEM_NM".equals(column)){		vo.n_item_nm		=	parseNull(rs.getString("N_ITEM_NM"));		}
			else if("N_ITEM_DT_NM".equals(column)){		vo.n_item_dt_nm		=	parseNull(rs.getString("N_ITEM_DT_NM"));	}
			else if("N_ITEM_EXPL".equals(column)){		vo.n_item_expl		=	parseNull(rs.getString("N_ITEM_EXPL"));		}
			else if("N_ITEM_UNIT".equals(column)){		vo.n_item_unit		=	parseNull(rs.getString("N_ITEM_UNIT"));		}
			else if("UPD_FLAG".equals(column)){			vo.upd_flag			=	parseNull(rs.getString("UPD_FLAG"));		}
			else if("UPD_REASON".equals(column)){		vo.upd_reason		=	parseNull(rs.getString("UPD_REASON"));		}
			else if("STS_FLAG".equals(column)){			vo.sts_flag			=	parseNull(rs.getString("STS_FLAG"));		}
			else if("RJC_REASON".equals(column)){		vo.rjc_reason		=	parseNull(rs.getString("RJC_REASON"));		}
			else if("RJC_DATE".equals(column)){			vo.rjc_date			=	parseNull(rs.getString("RJC_DATE"));		}
			else if("STS_DATE".equals(column)){			vo.sts_date			=	parseNull(rs.getString("STS_DATE"));		}
			else if("ITEM_NO".equals(column)){			vo.item_no			=	parseNull(rs.getString("ITEM_NO"));			}
			else if("FOOD_NM_1".equals(column)){		vo.food_nm_1		=	parseNull(rs.getString("FOOD_NM_1"));		}
			else if("FOOD_NM_2".equals(column)){		vo.food_nm_2		=	parseNull(rs.getString("FOOD_NM_2"));		}
			else if("FOOD_NM_3".equals(column)){		vo.food_nm_3		=	parseNull(rs.getString("FOOD_NM_3"));		}
			else if("FOOD_NM_4".equals(column)){		vo.food_nm_4		=	parseNull(rs.getString("FOOD_NM_4"));		}
			else if("FOOD_NM_5".equals(column)){		vo.food_nm_5		=	parseNull(rs.getString("FOOD_NM_5"));		}
			else if("FOOD_UNIT".equals(column)){		vo.food_unit		=	parseNull(rs.getString("FOOD_UNIT"));		}
			else if("FOOD_DT_1".equals(column)){		vo.food_dt_1		=	parseNull(rs.getString("FOOD_DT_1"));		}
			else if("FOOD_DT_2".equals(column)){		vo.food_dt_2		=	parseNull(rs.getString("FOOD_DT_2"));		}
			else if("FOOD_DT_3".equals(column)){		vo.food_dt_3		=	parseNull(rs.getString("FOOD_DT_3"));		}
			else if("FOOD_DT_4".equals(column)){		vo.food_dt_4		=	parseNull(rs.getString("FOOD_DT_4"));		}
			else if("FOOD_DT_5".equals(column)){		vo.food_dt_5		=	parseNull(rs.getString("FOOD_DT_5"));		}
			else if("FOOD_DT_6".equals(column)){		vo.food_dt_6		=	parseNull(rs.getString("FOOD_DT_6"));		}
			else if("FOOD_DT_7".equals(column)){		vo.food_dt_7		=	parseNull(rs.getString("FOOD_DT_7"));		}
    		else if("FOOD_DT_8".equals(column)){		vo.food_dt_8		=	parseNull(rs.getString("FOOD_DT_8"));		}
    		else if("FOOD_DT_9".equals(column)){		vo.food_dt_9		=	parseNull(rs.getString("FOOD_DT_9"));		}
    		else if("FOOD_DT_10".equals(column)){		vo.food_dt_10		=	parseNull(rs.getString("FOOD_DT_10"));		}
    		else if("FOOD_EP_1".equals(column)){		vo.food_ep_1		=	parseNull(rs.getString("FOOD_EP_1"));		}
    		else if("FOOD_EP_2".equals(column)){		vo.food_ep_2		=	parseNull(rs.getString("FOOD_EP_2"));		}
    		else if("FOOD_EP_3".equals(column)){		vo.food_ep_3		=	parseNull(rs.getString("FOOD_EP_3"));		}
    		else if("FOOD_EP_4".equals(column)){		vo.food_ep_4		=	parseNull(rs.getString("FOOD_EP_4"));		}
    		else if("FOOD_EP_5".equals(column)){		vo.food_ep_5		=	parseNull(rs.getString("FOOD_EP_5"));		}
    		else if("FOOD_EP_6".equals(column)){		vo.food_ep_6		=	parseNull(rs.getString("FOOD_EP_6"));		}
    		else if("FOOD_EP_7".equals(column)){		vo.food_ep_7		=	parseNull(rs.getString("FOOD_EP_7"));		}
    		else if("FOOD_EP_8".equals(column)){		vo.food_ep_8		=	parseNull(rs.getString("FOOD_EP_8"));		}
    		else if("FOOD_EP_9".equals(column)){		vo.food_ep_9		=	parseNull(rs.getString("FOOD_EP_9"));		}
    		else if("FOOD_EP_10".equals(column)){		vo.food_ep_10		=	parseNull(rs.getString("FOOD_EP_10"));		}
    		else if("FOOD_EP_11".equals(column)){		vo.food_ep_11		=	parseNull(rs.getString("FOOD_EP_11"));		}
    		else if("FOOD_EP_12".equals(column)){		vo.food_ep_12		=	parseNull(rs.getString("FOOD_EP_12"));		}
    		else if("FOOD_EP_13".equals(column)){		vo.food_ep_13		=	parseNull(rs.getString("FOOD_EP_13"));		}
    		else if("FOOD_EP_14".equals(column)){		vo.food_ep_14		=	parseNull(rs.getString("FOOD_EP_14"));		}
    		else if("FOOD_EP_15".equals(column)){		vo.food_ep_15		=	parseNull(rs.getString("FOOD_EP_15"));		}
    		else if("FOOD_EP_16".equals(column)){		vo.food_ep_16		=	parseNull(rs.getString("FOOD_EP_16"));		}
    		else if("FOOD_EP_17".equals(column)){		vo.food_ep_17		=	parseNull(rs.getString("FOOD_EP_17"));		}
    		else if("FOOD_EP_18".equals(column)){		vo.food_ep_18		=	parseNull(rs.getString("FOOD_EP_18"));		}
    		else if("FOOD_EP_19".equals(column)){		vo.food_ep_19		=	parseNull(rs.getString("FOOD_EP_19"));		}
    		else if("FOOD_EP_20".equals(column)){		vo.food_ep_20		=	parseNull(rs.getString("FOOD_EP_20"));		}
    		else if("FOOD_EP_21".equals(column)){		vo.food_ep_21		=	parseNull(rs.getString("FOOD_EP_21"));		}
    		else if("FOOD_EP_22".equals(column)){		vo.food_ep_22		=	parseNull(rs.getString("FOOD_EP_22"));		}
    		else if("FOOD_EP_23".equals(column)){		vo.food_ep_23		=	parseNull(rs.getString("FOOD_EP_23"));		}
    		else if("FOOD_EP_24".equals(column)){		vo.food_ep_24		=	parseNull(rs.getString("FOOD_EP_24"));		}
    		else if("FOOD_EP_25".equals(column)){		vo.food_ep_25		=	parseNull(rs.getString("FOOD_EP_25"));		}
    		else if("FOOD_CODE".equals(column)){		vo.food_code		=	parseNull(rs.getString("FOOD_CODE"));		}
    		else if("UNIQ_ID".equals(column)){			vo.uniq_id			=	parseNull(rs.getString("UNIQ_ID"));			}
    		else if("FILE_NO".equals(column)){			vo.file_no			=	parseNull(rs.getString("FILE_NO"));			}
    		else if("FILE_NM".equals(column)){			vo.file_nm			=	parseNull(rs.getString("FILE_NM"));			}
    		else if("FILE_ORG_NM".equals(column)){		vo.file_org_nm		=	parseNull(rs.getString("FILE_ORG_NM"));		}
    		else if("REG_IP".equals(column)){			vo.reg_ip			=	parseNull(rs.getString("REG_IP"));			}
    		else if("REG_ID".equals(column)){			vo.reg_id			=	parseNull(rs.getString("REG_ID"));			}
    		else if("SUC_FLAG".equals(column)){			vo.suc_flag			=	parseNull(rs.getString("SUC_FLAG"));		}
    		else if("FAIL_REASON".equals(column)){		vo.fail_reason		=	parseNull(rs.getString("FAIL_REASON"));		}
    		else if("FILE_TYPE".equals(column)){		vo.file_type		=	parseNull(rs.getString("FILE_TYPE"));		}
    		else if("FOOD_CAT_INDEX".equals(column)){   vo.food_cat_index   =   parseNull(rs.getString("FOOD_CAT_INDEX"));	}
    		else if("LOW_RATIO".equals(column)){        vo.low_ratio        =   parseNull(rs.getString("LOW_RATIO"));	    }
    		else if("AVR_RATIO".equals(column)){        vo.avr_ratio        =   parseNull(rs.getString("AVR_RATIO"));	    }
    		else if("LB_RATIO".equals(column)){         vo.lb_ratio         =   parseNull(rs.getString("LB_RATIO"));	    }
    		else if("ITEM_GRP_NO".equals(column)){      vo.item_grp_no      =   parseNull(rs.getString("ITEM_GRP_NO"));	    }
    		else if("ITEM_GRP_ORDER".equals(column)){   vo.item_grp_order   =   parseNull(rs.getString("ITEM_GRP_ORDER"));	    }
    		else if("ITEM_COMP_NO".equals(column)){     vo.item_comp_no     =   parseNull(rs.getString("ITEM_COMP_NO"));	    }
    		else if("ITEM_COMP_VAL".equals(column)){    vo.item_comp_val    =   parseNull(rs.getString("ITEM_COMP_VAL"));	    }
            

		}
        return vo;
    }
    public String parseNull(String value){
    	value = value==null?"":value;
    	return value;
    }
}

%>