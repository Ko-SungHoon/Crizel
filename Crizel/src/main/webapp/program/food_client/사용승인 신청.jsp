<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
String foodRole		= 	"ROLE_000094";		//운영서버:ROLE_000094 , 테스트서버:ROLE_000012

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);

String moveUrl		=	"/index.gne?contentsSid=2299";					//액션페이지	운영서버:2299, 테스트서버:648
String moveUrlMain	=	"/index.gne?menuCd=DOM_000002101000000000";		//메인페이지	운영서버:DOM_000002101000000000, 테스트서버:DOM_000000127000000000

int actType			=	Integer.parseInt(parseNull(request.getParameter("actType"), "0"));	//0 : 신규신청, 1 : 정보수정, 2 : 2차 로그인
int viewYN			=	0;		//1일경우 페이지 정상 작동

//정보 수정
if(actType == 1){
	if("Y".equals(session.getAttribute("foodLoginChk"))){
		viewYN	=	1;
	}else{
		out.print("<script> 						\n");
		out.print("alert('2차 로그인 후 이용하실 수 있습니다.');	\n");
		out.print("history.back(); 					\n");
		out.print("</script> 						\n");
	}
}
//2차 로그인
else if(actType == 2){
	if("N".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					\n");
		out.print("alert('승인대기중인 계정입니다.');		\n");
		out.print("history.back(); 				\n");
		out.print("</script> 					\n");
	}else if("S".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					\n");
		out.print("alert('승인신청하지 않은 계정입니다.');	\n");
		out.print("history.back(); 				\n");
		out.print("</script> 					\n");
	}else{
		viewYN	=	1;
	}
}
//신규 신청
else if(actType == 0){
	if("Y".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					\n");
		out.print("alert('이미 승인된 계정입니다.');		\n");
		out.print("history.back(); 				\n");
		out.print("</script> 					\n");
	}else if("N".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					\n");
		out.print("alert('승인 대기중인 계정입니다.');	\n");
		out.print("history.back(); 				\n");
		out.print("</script> 					\n");
	}else{
		viewYN	=	1;
	}
}


StringBuffer sql 		= 	null;
int resultCnt 	=	0;
int cnt			= 	0;

FoodVO foodVO			=	new FoodVO();
List<FoodVO> regList	=	null;
List<FoodVO> zoneList	=	null;
List<FoodVO> userNmList	=	null;
List<FoodVO> searchList	=	null;
List<FoodVO> teamList	=	null;
List<FoodVO> areaList	=	null;
List<FoodVO> joList		=	null;
List<FoodVO> nuList		=	null;

List<String> setWhere	=	new ArrayList<String>();
Object[] setObject		=	null;

//parameter
String schId		=	sManager.getId();
String schName		=	sManager.getName();
String groupId		=	sManager.getGroupId();
String userCheck	= 	(String)session.getAttribute("foodUserChk");
String schoolTail	=	"";
String orgSid		=	"";
String selectType	=	"";
int schNameSize		=	schName.length();

String teamNo		=	"";
String teamName		=	"";	

//텍스트 변환
String name		=	"";
String selType	=	"";
String tel		=	"";
String addr		=	"";
String caption	=	"";

//학교계정일 때
if("GRP_000009".equals(groupId)){
	name	=	"학교명";
	selType	=	"학교 단위";
	tel		=	"급식소 연락처";
	addr	=	"학교 주소";
	caption	=	"학교아이디, 학교명, 학교주소 등 회원신청과 관련된 테이블입니다.";
}
//그 외
else{
	name 	=	"기관명";
	selType	=	"기관 단위";
	tel		=	"연락처";
	addr	=	"주소";
	caption	=	"기관아이디, 기관명, 주소 등 회원신청과 관련된 테이블입니다.";
}

//학교정보 검색에 필요.
if("GRP_000009".equals(groupId)){		//학교 그룹일 때
	if(actType == 0){					//신규 신청일 때
		if("초".equals(schName.substring(schNameSize-1, schNameSize)) || 
				"고".equals(schName.substring(schNameSize-1, schNameSize))){
			schoolTail	=	"등학교";
		}else if("중".equals(schName.substring(schNameSize-1, schNameSize))){
			schoolTail	=	"학교";
		}	
	}
}

//학교일 경우 출력할 학교단위
String[] schTypeO	=	{"A", "B", "C", "D", "E", "F", "G", "H", "I"};
String[] schTypeT	=	{"유치원", "초등학교", "중학교", "고등학교", "대안학교", "특수학교", "고등기술학교", "고등공민학교", "외국인학교"};

//기관일 경우 출력할 기관단위
String[] selTypeO	=	{"Z", "Y", "X", "V"};
String[] selTypeT	=	{"도교육청(본청)", "직속기관", "소속기관", "교육지원청"};

if(viewYN == 1){
	try{
		//권역 Select
		sql		=	new StringBuffer();
		sql.append(" SELECT 				\n");
		sql.append(" ZONE_NO, 				\n");
		sql.append(" ZONE_NM				\n");
		sql.append(" FROM FOOD_ZONE			\n");
		sql.append(" WHERE SHOW_FLAG = 'Y' 	\n");
		
		zoneList	=	jdbcTemplate.query(sql.toString(), new FoodList());
		
		//지역 Select
		sql		=	new StringBuffer();
		sql.append(" SELECT 				\n");
		sql.append(" AREA_NO, 				\n");
		sql.append(" AREA_NM 				\n");
		sql.append(" FROM FOOD_AREA 		\n");
		sql.append(" WHERE SHOW_FLAG = 'Y' 	\n");
		
		areaList	=	jdbcTemplate.query(sql.toString(), new FoodList());
		
		//신규 신청
		if(actType == 0){
			//--------------- 학교 그룹일 경우 ----------------------//
			if("GRP_000009".equals(groupId)){		
				
				sql		=	new StringBuffer();
				sql.append(" SELECT 						\n");
				sql.append(" USER_NM  						\n");
				sql.append(" FROM RFC_COMVNUSERMASTER 		\n");
				sql.append(" WHERE GROUP_ID = 'GRP_000009'	\n");
				sql.append(" AND USER_ID = ?				\n");
				
				userNmList = jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{schId});
				
				if(userNmList != null && userNmList.size() > 0){
					sql = new StringBuffer();
			   	 	sql.append(" SELECT					\n");
			   	 	sql.append(" SID,					\n");
			   	 	sql.append(" TITLE,					\n");
			   	 	sql.append(" ADDR,					\n");
			   	 	sql.append(" TEL,					\n");
			   	 	sql.append(" AREA_TYPE,				\n");
			   	 	sql.append(" CATE2 AS FOUND,		\n");
			   	 	sql.append(" COEDU					\n");
			   	 	sql.append(" FROM SCHOOL_SEARCH		\n");
			    	sql.append(" WHERE 1=1 				\n");
		    		sql.append(" AND	(				\n");
		    		
			    	for(int i=0; i<userNmList.size(); i++){
			    		FoodVO ob 	= 	userNmList.get(i);
			    		if(i < userNmList.size()-1)	sql.append(" TITLE = ? OR		\n");
			    		else		    			sql.append(" TITLE = ? 			\n");
			    		setWhere.add(ob.user_nm + schoolTail);
			    	}
			    	
			    	sql.append("		)											\n");
		    		
			    	setObject 	= 	new Object[setWhere.size()];
				    for(int i=0; i<setWhere.size(); i++){
				    	setObject[i]	= 	setWhere.get(i);
				    }
					searchList 	= 	jdbcTemplate.query(sql.toString(), new FoodList(), setObject);
			    }
				
				if(searchList == null && userNmList != null && userNmList.size() > 0){
					sql		= 	new StringBuffer();
					sql.append(" SELECT						\n");
					sql.append(" SID, 						\n");
					sql.append(" SCHOOL_NAME AS TITLE,		\n");
					sql.append(" SCHOOL_ADDR AS ADDR, 		\n");
					sql.append(" '남여공학' AS COEDU,			\n");
					sql.append(" SCHOOL_TEL AS TEL,			\n");
					sql.append(" SCHOOL_AREA AS AREA_TYPE,	\n");
					sql.append(" FOUND_TYPE AS FOUND,		\n");
					sql.append(" FROM AD_PRESCHOOL			\n");
					sql.append(" WHERE 1=1 					\n");
		    		sql.append(" AND	(					\n");
		    		
			    	for(int i=0; i<userNmList.size(); i++){
			    		FoodVO ob = userNmList.get(i);
			    		if(i < userNmList.size()-1)	sql.append("SCHOOL_NAME = ? OR		\n");
			    		else		    			sql.append("SCHOOL_NAME = ? 		\n");
			    		
			    		setWhere.add(ob.user_nm + schoolTail);
			    	}
			    	sql.append("		)												\n");
		    		
			    	setObject = new Object[setWhere.size()];
				    for(int i=0; i<setWhere.size(); i++){
				    	setObject[i] = setWhere.get(i);
				    }
					searchList = jdbcTemplate.query(sql.toString(), new FoodList(), setObject);
				}
				
				if(searchList != null && searchList.size() > 0){
					foodVO.sid			=	searchList.get(0).sid;
					foodVO.sch_nm		=	searchList.get(0).title;
					foodVO.sch_addr		=	searchList.get(0).addr;
					foodVO.coedu		=	searchList.get(0).coedu;
					foodVO.sch_tel		=	searchList.get(0).tel;
					foodVO.sch_area		=	searchList.get(0).area_type;
					foodVO.sch_found	=	searchList.get(0).found;
				}else{
					foodVO.sch_nm		=	schName + schoolTail;
				}
			}
			//------------------- 그 외 그룹일 경우 ------------------//
			else{		
				sql		=	new StringBuffer();
				sql.append(" SELECT 						\n");
				sql.append(" USER_NM,  						\n");
				sql.append(" UNIQ_ID 						\n");
				sql.append(" FROM RFC_COMVNUSERMASTER 		\n");
				sql.append(" WHERE (						\n");
				sql.append(" GROUP_ID = 'GRP_000008'		\n");	
				sql.append(" OR GROUP_ID = 'GRP_000007'		\n");
				sql.append(" OR GROUP_ID = 'GRP_000006'		\n");
				sql.append(" OR GROUP_ID = 'GRP_000005'		\n");
				if(sManager.isRoleAdmin() || sManager.isRole(foodRole)){
					sql.append(" OR GROUP_ID = 'GRP_000001' \n");
				}
				sql.append(" ) 								\n");		
				sql.append(" AND USER_ID = ?				\n");
				
				userNmList = jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{schId});
				
				if(userNmList != null && userNmList.size() > 0){
					foodVO.uniq_id	=	userNmList.get(0).uniq_id;
					foodVO.sch_nm	=	userNmList.get(0).user_nm;
				}
			}		
		}
		//정보수정
		else if(actType == 1){
			//학교 및 기관 정보
			sql		=	new StringBuffer();
			sql.append(" SELECT 					\n");
			sql.append(" SCH_NO, 					\n");
			sql.append(" SCH_TYPE, 					\n");
			sql.append(" SCH_NM,  					\n");
			sql.append(" SCH_TEL, 					\n");
			sql.append(" SCH_AREA, 					\n");
			sql.append(" SCH_ADDR, 					\n");
			sql.append(" ZONE_NO, 					\n");
			sql.append(" TEAM_NO, 					\n");
			sql.append(" AREA_NO, 					\n");
			sql.append(" JO_NO						\n");
			sql.append(" FROM FOOD_SCH_TB			\n");
			sql.append(" WHERE SCH_ID = ?			\n");
			sql.append(" AND SHOW_FLAG = 'Y' 		\n");
			
			regList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{schId});
			
			if(regList != null && regList.size() > 0){
				
				foodVO.sch_no	=	regList.get(0).sch_no;
				foodVO.sch_type	=	regList.get(0).sch_type;
				foodVO.sch_nm	=	regList.get(0).sch_nm;
				foodVO.sch_tel	=	regList.get(0).sch_tel;
				foodVO.sch_area	=	regList.get(0).sch_area;
				foodVO.sch_addr	=	regList.get(0).sch_addr;
				foodVO.zone_no	=	regList.get(0).zone_no;
				foodVO.team_no	=	regList.get(0).team_no;
				foodVO.area_no	=	regList.get(0).area_no;
				foodVO.jo_no	=	regList.get(0).jo_no;				
			}
			
			//학교일 때
			if("GRP_000009".equals(groupId)){
				
				//영양사 정보
				sql		=	new StringBuffer();
				sql.append(" SELECT  				\n");
				sql.append(" NU_NO, 				\n");
				sql.append(" NU_NM, 				\n");
				sql.append(" NU_TEL, 				\n");
				sql.append(" NU_MAIL 				\n");
				sql.append(" FROM FOOD_SCH_NU 		\n");
				sql.append(" WHERE SCH_NO = ? 		\n");
				sql.append(" AND SHOW_FLAG = 'Y' 	\n");
				
				nuList	= jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{foodVO.sch_no});				
				
				//팀 Select
				sql		=	new StringBuffer();
				sql.append(" SELECT								\n");
				sql.append(" TEAM_NO,							\n");
				sql.append(" TEAM_NM							\n");
				sql.append(" FROM FOOD_TEAM						\n");
				sql.append(" WHERE ZONE_NO = ?					\n");
				sql.append(" AND SHOW_FLAG = 'Y'				\n");
				sql.append(" ORDER BY ORDER1, ORDER2, ORDER3	\n");
				
				teamList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{foodVO.zone_no});
				
				//조 Select
				sql		=	new StringBuffer();
				sql.append(" SELECT								\n");
				sql.append(" JO_NO,								\n");
				sql.append(" JO_NM								\n");
				sql.append(" FROM FOOD_JO						\n");
				sql.append(" WHERE TEAM_NO = ?					\n");
				sql.append(" ORDER BY ORDER1, ORDER2, ORDER3	\n");
				
				joList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{foodVO.team_no});
				
			}
		}
	}catch(Exception e){
		out.println(e.toString());
	}
%>

<div class="contMax1 box_02 magB20">
	<p class="red fb fsize_120 padB10">&#8251; 주의사항</p>
	<ul class="type01">
		<li>본 시스템 사용을 위해서 반드시 회원 등록을 해주시기 바랍니다.</li>
		<li>입력하신 2차 인증 비밀번호를 꼭 기억해주시기 바랍니다.</li>
	</ul>
</div>

<form name="registerForm" id="registerForm" method="post" action="<%=moveUrl%>" onsubmit="return formSubmit();" class="contMax1">
	<%
	if(foodVO.sid != null && !"".equals(foodVO.sid))
		{	orgSid	=	foodVO.sid;		}
	else
		{	orgSid	=	foodVO.uniq_id;	}
	%>
	<input type="hidden" name="actType" id="actType" value="<%=actType%>">
	<input type="hidden" name="schOrgSid" id="schOrgSid" value="<%=parseNull(orgSid)%>">
	<input type="hidden" name="schArea" id="schArea" value="<%=parseNull(foodVO.area_type)%>">
	<input type="hidden" name="coedu" id="coedu" value="<%=parseNull(foodVO.coedu)%>">
	<input type="hidden" name="schFound" id="schFound" value="<%=parseNull(foodVO.found)%>">
	<input type="hidden" name="schNo" id="schNo" value="<%=parseNull(foodVO.sch_no)%>">

	<h3>신청기관 정보</h3>
	<fieldset class="magB20">
		<legend>신청기관 정보 입력</legend>
		<table class="table_skin01 td-l">
		<caption><%=caption%></caption>
		<colgroup>
			<col style="width:18%;">
			<col />
			<col style="width:18%;">
			<col />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row"><label for="schId">아이디 <span class="fsize_90 red">(필수)</span></label></th>
				<td><input type="text" name="schId" id="schId" value="<%=sManager.getId()%>" class="wps_80" readonly></td>
				<th scope="row"><label for="schName"><%=name%> <span class="fsize_90 red">(필수)</span></label></th>
				<td><input type="text" name="schName" id="schName" value="<%=foodVO.sch_nm%>" class="wps_80" required></td>
			</tr>
			<tr>
				<th scope="row"><label for="schType"><%=selType%> <span class="fsize_90 red">(필수)</span></label></th>
				<td>
					<select name="schType" id="schType" title="<%=selType%>를 선택해주세요." class="wps_80" required>
						<option value=""><%=selType%> 선택</option>
						<!-- 학교일 경우  -->
						<%if("GRP_000009".equals(groupId)){
							for(int i=0; i<schTypeO.length; i++){
								out.print(printOption(schTypeO[i], schTypeT[i], parseNull(foodVO.sch_type)));
							}
						%>
						
						<!-- 그 외 -->
						<%}else{
							for(int i=0; i<selTypeO.length; i++){
								out.print(printOption(selTypeO[i], selTypeT[i], parseNull(foodVO.sch_type)));
							}
						%>
					</select>				
				<%}%>
				</td>
				<th scope="row"><label for="schTel"><%=tel%><span class="fsize_90 red">(필수)</span></label></th>
				<td><input type="text" name="schTel" id="schTel" value="<%=parseNull(foodVO.sch_tel)%>" placeholder="숫자만 입력하세요." class="wps_80" required></td>
			</tr>
			<!-- 지역, 권역, 팀, 조선택 : 학교 아이디일 경우에만 노출 -->
			<%if("GRP_000009".equals(groupId)){%>
			<tr>
				<th scope="row"><label for="areaNo">지역 <span class="fsize_90 red">(필수)</span></label></th>
				<td>
					<select name="areaNo" id="areaNo" title="지역을 선택해주세요." class="wps_50" required>
						<option value="">지역 선택</option>
						<%
						if(areaList != null && areaList.size() > 0){
							for(int i=0; i<areaList.size(); i++){
								out.print(printOption(areaList.get(i).area_no, areaList.get(i).area_nm, foodVO.area_no));
							}
						}%>
					</select>
				</td>
				<th scope="row"><label for="zoneNo">권역</label></th>
				<td>
					<select name="zoneNo" id="zoneNo" title="권역을 선택해주세요." onchange="javascript:teamSelect(this.value);" class="wps_50">
						<option value="">권역 선택</option>
						<%
						if(zoneList != null && zoneList.size() > 0){
							for(int i=0; i<zoneList.size(); i++){
								out.print(printOption(zoneList.get(i).zone_no, zoneList.get(i).zone_nm, foodVO.zone_no));
							}
						}%>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row"><label for="teamNo">팀</label></th>
				<td>
					<select name="teamNo" id="teamNo" title="팀을 선택해주세요." onchange="javascript:joSelect(this.value);" class="wps_50">
						<option value="">팀 선택</option>
						<!-- 정보 수정 페이지일 시 -->
						<%
						if(actType == 1 && teamList != null && teamList.size() > 0){
							for(int i=0; i<teamList.size(); i++){
								out.print(printOption(teamList.get(i).team_no, teamList.get(i).team_nm, parseNull(foodVO.team_no)));
							}
						}%>
					</select>
				</td>
				<th scope="row"><label for="joNo">조</label></th>
				<td>
					<select name="joNo" id="joNo" title="조를 선택해주세요." class="wps_50">
						<option value="">조 선택</option>
						<!-- 정보 수정 페이지일 시 -->
						<%
						if(actType == 1 && joList != null && joList.size() > 0){
							for(int i=0; i<joList.size(); i++){
								out.print(printOption(joList.get(i).jo_no, joList.get(i).jo_nm, parseNull(foodVO.jo_no)));
							}
						}%>
					</select>
				</td>
			</tr>
			<%}%>
			<!-- // 권역,팀 선택  끝 -->
			<tr>
				<th scope="row"><label for="schAddr">주소</label></th>
				<td colspan="3"><input type="text" name="schAddr" id="schAddr" value="<%=parseNull(foodVO.sch_addr)%>" class="wps_90" required></td>
			</tr>
			</tbody>
		</table>
	</fieldset>


	<!-- 영양사정보 : 학교 아이디일 경우에만 노출 -->
	<%if("GRP_000009".equals(groupId)){%>
	<h3>영양(교)사 정보</h3>
	<fieldset class="magB20">
		<legend>영양(교)사 정보 입력 (학교일 경우)</legend>
		<table class="table_skin01">
			<caption>영양사명, 휴대폰번호, 이메일 정보 입력</caption>
			<colgroup>
				<col span="3"/>
				<col style="width:12%" />
				<col style="width:12%" />
			</colgroup>
		<thead>
			<tr>
				<th scope="col">영양(교)사명 <span class="red fsize_90">(필수)</span></th>
				<th scope="col">휴대폰 <span class="red fsize_90">(필수)</span></th>
				<th scope="col">이메일 <span class="red fsize_90">(필수)</span></th>
				<th scope="col">개인정보<br/>동의</th>
				<th scope="col"><a href="javascript:addNDel('1', '0')" class="btn small edge mako w_70">+ 추가</a></th>
			</tr>
		</thead>
		<tbody id="inputNu">

		<!-- 정보수정 페이지일 때 -->
		<%if(actType == 1){
			if(nuList != null && nuList.size() > 0){
				for(int i=0; i<nuList.size(); i++){
					%>
					<tr id="nuItem_<%=i+1%>">
						<td>
							<input type="text" name="nuName" id="nuName_<%=i+1%>" value="<%=parseNull(nuList.get(i).nu_nm)%>" required placeholder="이름을 입력하세요.">
							<input type="hidden" name="nuNo" id="nuNo_<%=i+1%>" value="<%=nuList.get(i).nu_no%>">
						</td>
						<td><input type="text" name="nuTel"  id="nuTel_<%=i+1%>"  value="<%=parseNull(nuList.get(i).nu_tel)%>"  required placeholder="숫자만 입력하세요."></td>
						<td><input type="text" name="nuMail" id="nuMail_<%=i+1%>" value="<%=parseNull(nuList.get(i).nu_mail)%>" required  placeholder="이메일주소를 입력하세요."></td>
						<td><input type="checkbox" name="nuChk" id="nuChk_<%=i+1%>" class="initialism slide_open openLayer" onclick="nuChkPopup('nuChk_<%=i+1%>');" required></td>
						<td>
							<a href="javascript:addNDel('2', '<%=i+1%>');" class="btn small edge red w_70">- 삭제</a>
						</td>
					</tr>
				<%}
			}%>
		<!-- 신규 승인신청 페이지일 때 -->
		<%}else{ %>			
			<tr id="nuItem_1">
				<td><input type="text" name="nuName" id="nuName_1"  value="" required placeholder="이름을 입력하세요."></td>
				<td><input type="text" name="nuTel"  id="nuTel_1"   value="" required placeholder="숫자만 입력하세요."></td>
				<td><input type="text" name="nuMail" id="nuMail_1>" value="" required placeholder="이메일주소를 입력하세요."></td>
				<td><input type="checkbox" name="nuChk" id="nuChk_1" onclick="nuChkPopup('nuChk_1');" class="initialism slide_open openLayer" required></td>
				<td><a href="javascript:addNDel('2', '1');" class="btn small edge red w_70">- 삭제</a></td>
			</tr>
		<%}%>
		</tbody>
		</table>
	</fieldset>
	<%}%>
	<!-- //영양사 정보 입력 끝 -->

	<h3>2차 인증 비밀번호 <span class="fsize_90 red">(필수)</span></h3>
	<fieldset class="magB20">
		<legend>2차 인증 비밀번호 입력</legend>
		<table class="table_skin01 td-l">
			<caption>2차 인증 비밀번호 입력표: 비밀번호, 비밀번호 재확인 입력</caption>
			<colgroup>
				<col style="width:20%" />
				<col />
			</colgroup>
			<tbody>
			
			<!-- 정보수정시 노출되는 항목 -->
			<%
			if(actType == 1){%>
				<tr>
					<th scope="row"><label for="currentPw">비밀번호</label></th>
					<td><input type="password" name="currentPw" id="currentPw" required placeholder="기존 비밀번호를 입력해주세요" class="wps_40"> <span class="red">&#8251; 정보수정을 위해 사용중인 2차 비밀번호를 입력하세요.</span></td>
				</tr>
			<!-- 신규 신청시 노출되는 항목 -->
			<%}else{%>
				<tr>
					<th scope="row"><label for="schPw">비밀번호</label></th>
					<td><input type="password" name="schPw" id="schPw" required placeholder="비밀번호를 입력해주세요" class="wps_40"></td>
				</tr>
				<tr>
					<th scope="row"><label for="schPwR">비밀번호 재확인</label></th>
					<td><input type="password" name="schPwR" id="schPwR" required placeholder="비밀번호를 입력해주세요" class="wps_40"></td>
				</tr>
			<%}%>
			</tbody>
		</table>
	</fieldset>
	
	<%if("GRP_000009".equals(groupId)){%>
	<!-- 개인정보 이용동의 -->
	<div id="slide" style="display:none; width:600px; height:400px;" class="modal">
	<input type="hidden" name="nuChkHidden" id="nuChkHidden" value="nuChk_1" />
	<div class="topbar">
	<h3>개인정보 수집 및 이용동의 <span class="fsize_90 red">(필수)</span></h3>
	</div>
	<fieldset>
			<label for="policy">
				<textarea id="policy" class="wps_100 h250" rows="10">
1. 개인정보의 수집·이용 목적
우리 기관은 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용목적이 변경될 시에는 별도 공지할 예정입니다.
- 수집·이용목적: 학교급식거래실례조사시스템 사용 승인 신청 및 확인

2. 수집하는 개인정보의 항목
우리 기관은 본 서비스에서 아래와 같은 개인정보를 수집하고 있습니다.
- 수집항목: 신청자명, 연락처, 이메일

3. 개인정보의 보유 및 이용기간
이용자의 개인정보는 2년간 보유되며 기간이 만료되면 지체 없이 파기됩니다.

※ 개인정보 수집·이용에 대하여 동의를 원하지 않을 경우 동의를 거부할 수 있으며, 동의 거부시 본 서비스를 이용할 수 없습니다.
				</textarea>
			</label>
		<div class="c magT10">
			<input type="checkbox" name="nuChkPop" id="nuChkPop" value=""> <label for="nuChkPop">개인정보 수집 및 이용에 대한 안내를 이해하였으며 동의합니다.</label>
		</div>
	</fieldset>
	<div class="btn_area c">
		<button class="btn medium darkMblue" onclick="nuChkClose();">개인정보 수집 및 이용에 대한 안내를 이해하였으며 동의합니다.</button>
	</div>
	</div>
	<%}%>
	<div class="btn_area c">
		<button type="submit" class="btn medium darkMblue"><%if(actType == 0){%>사용승인 신청<%}else{%>정보 수정<%}%></button>
		<a href="<%=moveUrlMain%>" class="btn medium white">취소</a>
	</div>
</form>
<%}%>

<script>

	//영양사 정보 추가/삭제 버튼
	function addNDel(type, number){
		var strHtml		=	"";
		var paramCnt	=	$("input:text[name='nuName']").length;
		if(type == 1){
			strHtml	=	"<tr id=\"nuItem_" + (paramCnt + 1) + "\">";
			strHtml	+=	"<td><input type=\"text\" name=\"nuName\" id=\"nuName_" + (paramCnt + 1) + "\" value=\"\" required placeholder=\"이름을 입력하세요.\"></td>";
			strHtml	+=	"<td><input type=\"text\" name=\"nuTel\"  id=\"nuTel_"  + (paramCnt + 1) + "\" value=\"\" required placeholder=\"숫자만 입력하세요.\"></td>";
			strHtml	+=	"<td><input type=\"text\" name=\"nuMail\" id=\"nuMail_" + (paramCnt + 1) + "\" value=\"\" required placeholder=\"이메일주소를 입력하세요.\"></td>";
			strHtml	+=	"<td><input type=\"checkbox\" name=\"nuChk\" id=\"nuChk_" + (paramCnt + 1) + "\" class=\"initialism slide_open openLayer\" onclick=\"nuChkPopup(\'nuChk_" + (paramCnt + 1) + "\');\" required></td>";
			strHtml +=	"<td><a href=\"javascript:addNDel('2', '" + (paramCnt + 1) + "');\" class=\"btn small edge red w_70\">- 삭제</a></td>";
			strHtml +=	"</tr>"
			$("#inputNu").append(strHtml);
		}else if(type == 2){
			$("#inputNu #nuItem_" + number).remove();
		}
	}
	
	//정보수정시 영양사 삭제
	function nuDelAction(nuNo, number){
		var actType = "3";
		if(confirm("삭제하시면 다시 되돌릴 수 없습니다. 정말 삭제하시겠습니까?") == true){
			$.ajax({
				type : "POST",
				url : "<%=moveUrl%>",
				data : {"nuNo" : nuNo, "actType" : actType},
				success : function(data){						//삭제성공
					alert(data.trim());
					$("#inputNu #nuItem_" + number).remove();
				},
				error : function(){
			       	alert("오류가 발생하였습니다.");
				}
			});
		}
	}
	
	//권역선택시 팀select 노출
	function teamSelect(value){
		var zone_no = value;
		$.ajax({
			type : "POST",
			url : "/program/food/research/team_list.jsp",
			data : {"zone_no" : zone_no, "mode" : "team"},
			async : false,
			success : function(data){
				$("#teamNo").html("<option value=\"\">팀 선택</option>" + data.trim());
			},
			error : function(request, status, error){
			}
		}); 
	}
	
	//팀 선택시 조select 노출
	function joSelect(value){
		var team_no = value;
		$.ajax({
			type : "POST",
			url : "/program/food/research/team_list.jsp",
			data : {"team_no" : team_no, "mode" : "jo"},
			async : false,
			success : function(data){
				$("#joNo").html("<option value=\"\">조 선택</option>" + data.trim());
			},
			error : function(request, status, error){
			}
		}); 
	}
	
	//submit
	function formSubmit(){
		var pwChkMsg	=	"";	
	
		<%if(actType == 0){%>
			pwChkMsg	=	"비밀번호가 일치하지 않습니다.";
		<%}else if(actType == 1){%>
			pwChkMsg	=	"변경할 비밀번호가 일치하지 않습니다.";
		<%}%>
		
		//영양사 등록여부 체크
		<%if("GRP_000009".equals(groupId)){%>
		if($("input:text[name='nuName']").length == 0 || $("input:text[name='nuTel']").length == 0 || 
				$("input:text[name='nuMail']").length == 0){
			alert("영양사는 한명 이상 등록되어야 합니다.");
			return false;
		}
		<%}%>
		
		//패스워드 일치여부 체크
		if($("#schPw").val() != $("#schPwR").val()){
			alert(pwChkMsg);
			$("#schPwR").focus();
			return false;
		}		
		else{
			return true;
		}
	}
	
	//동의여부 체크시 modal창 열기
	function nuChkPopup(id){
		if($("input:checkbox[id='" + id + "']").is(":checked") == true){
			$("#nuChkHidden").val(id);		//nuChkHidden (type=hidden) 값에 기존 체크박스의 id를 넣는다.
			$("#slide").popup({
				focusdelay: 400,
		 		 outline: true,
		 		 vertical: 'middle'
			});
		}
	}
	
	//동의여부 체크후 버튼 클릭시 modal창 닫으면서 nuChk 체크하기
	function nuChkClose(){
		if($("input:checkbox[id='nuChkPop']").is(":checked")){
			$("input:checkbox[id='nuChkPop']").prop("checked", false);
			
			//nuChkHidden (type=hidden) 값(기존 체크박스의 id)을 가져와서 해당체크박스를 체크한다.
			$("input:checkbox[id='" + $("#nuChkHidden").val() + "']").prop("checked", true);
			$("#slide").popup("hide");
		}else{
			alert("동의여부에 체크해주세요.");
			$("#nuChkPop").focus();
			return;
		}
	}
		
</script>