<%@ page import="java.util.*" %>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO" %>  
<%
	MenuVO currentMenuVO = cm.getMenuVO();
	String menuCD = "";

	if(currentMenuVO != null) menuCD = currentMenuVO.getMenuCd();
	else menuCD = "";

	ArrayList menuList = (ArrayList)cm.getMenuList(menuCD, 2);

	MenuVO parentMenuVO = cm.getMenuCd(menuCD, 1);

	int depth = cm.getMainNum();
	if(depth > 6)
	{
		depth = 0;
	}
	String menuTheme  = "";
%>
<!-- 서브메뉴 -->
	<aside id="snb">
		<h2><p><%=parentMenuVO.getMenuNm()%></p></h2>
		<ul>

			<%   
			//2차 메뉴 출력
			if(menuList != null && menuList.size() > 0) {				
				for(int i=0; i<menuList.size(); i++) {
					MenuVO menuVO = (MenuVO)menuList.get(i);
					int vv1 = 10+((2)*3);
					String val1 = menuVO.getMenuCd().substring(0,vv1);
					String val2 = menuCD.substring(0,vv1);
					String nowchkahref = "N";
				    if(val1.equals(val2)){   
						nowchkahref = "Y";
				   	}
					//로그인 상태에 따른 메뉴 출력 여부
					%>
					<li <%if(nowchkahref.equals("Y")){%>class="on"<%}%>><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>
						
			
					<%
					//3차메뉴 목록
					ArrayList menuList2 = (ArrayList)cm.getMenuList(menuVO.getMenuCd(), 3);
					if(menuList2 != null && menuList2.size() > 0) {			
						
						%>	
							<div class="depth3">					
							<ul class="litype_cir">
								<%
								for(int j=0; j<menuList2.size(); j++) {
									MenuVO menuVO2 = (MenuVO)menuList2.get(j);

									%>
									<li><%=getLink(menuVO2,menuCD,3,"","","RFCShowMenu2",cm.getUrlExt(),request.getContextPath())%>
									
									</li>
									
									<%
									//4차메뉴 목록
									ArrayList menuList3 = (ArrayList)cm.getMenuList(menuVO2.getMenuCd(), 4);
									if(menuList3 != null && menuList3.size() > 0) {
										%>										
										<!--4depth메뉴-->
										<li id="<%=menuVO2.getMenuCd()%>" style="">

										<!--4depth메뉴-->
											<ul class="sub_sub">
												<%
												for(int k=0; k<menuList3.size(); k++) {
													MenuVO menuVO3 = (MenuVO)menuList3.get(k);
													%>
													<li><%=getLink(menuVO3,menuCD,4,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%></li>
													<%
												}
												%>
											</ul>
										<!-- //4depth메뉴 -->
										</li>
										<%
									}									
								}
								%>
							</ul>
						      </div>
						</li>
						
						<%
					}					
				}
			}
			%>
		</ul>
	<!-- //3depth메뉴 -->
	</aside>
<!-- //서브메뉴 -->
<%!
	//메뉴 링크 작성 함수
	public static String getLink(MenuVO menuVO,String menuCd,int depth,String id,String classNm,String script,String urlExt,String contextPath)
	{
		//메뉴링크
		String link="";
		//메뉴 제목 또는 메뉴 이미지
		String title="";
		//메뉴 기본 이미지
		String img="";
		//링크주소
		String url = "";
		
		

		// 이미지 메뉴 여부 확인
		if(menuVO.getMenuLeftOverimg() == null || "".equals(menuVO.getMenuLeftOverimg()))
		{
			title = menuVO.getMenuNm();
		}else
		{
			//현재 메뉴와 같거나 상위 메뉴인 경우 over 이미지 처리
			if( menuCd != null && !"".equals(menuCd))
			{
				if( (menuVO.getMenuCd().substring(0,(4+((depth-1)*3)))).equals(menuCd.substring(0,(4+((depth-1)*3)))) )
				{
					img = menuVO.getMenuLeftOverimg();
				}else
				{
					img = menuVO.getMenuLeftOutimg();
				}
			}else
			{
				img = menuVO.getMenuLeftOutimg();
			}
			//이미지 태그 및 마우스 오버, 아웃등 처리
			title =  "<img src=\""+img+"\"";
			title += " onfocus=\"this.src='"+menuVO.getMenuLeftOverimg()+"';\" onblur=\"this.src='"+img+"';\"";
			title += " onmouseover=\"this.src='"+menuVO.getMenuLeftOverimg()+"';\" onmouseout=\"this.src='"+img+"';\"";
			title += " alt=\""+menuVO.getMenuNm()+"\" id=\""+id+"\" class=\""+classNm+"\">";
		}
		// 컨텐츠가 없는 메뉴인 경우 하위메뉴 펼침 태그 작성
		if(menuVO.getMenuContentsSid() == 0) {
			//link = "<a href=\"#"+menuVO.getMenuCd()+"\" onclick=\""+script+"('"+menuVO.getMenuCd()+"')\">";
			link = "<a href=\"#"+menuVO.getMenuCd()+"\" onclick=\""+script+"('"+menuVO.getMenuCd()+"');\" onkeypress=\""+script+"('"+menuVO.getMenuCd()+"');\">";
						
		}else{
			url = "/index."+urlExt+"?menuCd=" + menuVO.getMenuCd(); 

			if("_blank".equals(menuVO.getMenuTg())) {				
				if(menuVO.getMenuTgOption() != null && !"".equals(menuVO.getMenuTgOption()))
				{
					link =  "<a href=\""+contextPath+url+"\" ";
					link += " onclick=\"window.open(this.href,'"+menuVO.getMenuCd()+"','"+menuVO.getMenuTgOption()+"');return false;\" title=\""+menuVO.getMenuNm()+"\"";
					link += " onkeypress=\"window.open(this.href,'"+menuVO.getMenuCd()+"','"+menuVO.getMenuTgOption()+"');return false;\" title=\""+menuVO.getMenuNm()+"\">";
					
				}else
				{					
					link = "<a href=\""+contextPath+url+"\" target=\"_blank\" title=\"새창으로 열립니다.\">";					
				}
			}else
			{
				link = "<a href=\""+contextPath+url+"\">";
			}
			
		}
		link += title;
		if("_blank".equals(menuVO.getMenuTg())){
			link += " <img src='/images/juknok/open_new2.png' alt='새창'  />";
		}
		link += "</a>";		
		return link;
	}
%>      