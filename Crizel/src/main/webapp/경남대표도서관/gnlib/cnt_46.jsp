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
<!-- ����޴� -->
	<aside id="snb">
		<h2><p><%=parentMenuVO.getMenuNm()%></p></h2>
		<ul>

			<%   
			//2�� �޴� ���
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
					//�α��� ���¿� ���� �޴� ��� ����
					%>
					<li <%if(nowchkahref.equals("Y")){%>class="on"<%}%>><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>
						
			
					<%
					//3���޴� ���
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
									//4���޴� ���
									ArrayList menuList3 = (ArrayList)cm.getMenuList(menuVO2.getMenuCd(), 4);
									if(menuList3 != null && menuList3.size() > 0) {
										%>										
										<!--4depth�޴�-->
										<li id="<%=menuVO2.getMenuCd()%>" style="">

										<!--4depth�޴�-->
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
										<!-- //4depth�޴� -->
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
	<!-- //3depth�޴� -->
	</aside>
<!-- //����޴� -->
<%!
	//�޴� ��ũ �ۼ� �Լ�
	public static String getLink(MenuVO menuVO,String menuCd,int depth,String id,String classNm,String script,String urlExt,String contextPath)
	{
		//�޴���ũ
		String link="";
		//�޴� ���� �Ǵ� �޴� �̹���
		String title="";
		//�޴� �⺻ �̹���
		String img="";
		//��ũ�ּ�
		String url = "";
		
		

		// �̹��� �޴� ���� Ȯ��
		if(menuVO.getMenuLeftOverimg() == null || "".equals(menuVO.getMenuLeftOverimg()))
		{
			title = menuVO.getMenuNm();
		}else
		{
			//���� �޴��� ���ų� ���� �޴��� ��� over �̹��� ó��
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
			//�̹��� �±� �� ���콺 ����, �ƿ��� ó��
			title =  "<img src=\""+img+"\"";
			title += " onfocus=\"this.src='"+menuVO.getMenuLeftOverimg()+"';\" onblur=\"this.src='"+img+"';\"";
			title += " onmouseover=\"this.src='"+menuVO.getMenuLeftOverimg()+"';\" onmouseout=\"this.src='"+img+"';\"";
			title += " alt=\""+menuVO.getMenuNm()+"\" id=\""+id+"\" class=\""+classNm+"\">";
		}
		// �������� ���� �޴��� ��� �����޴� ��ħ �±� �ۼ�
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
					link = "<a href=\""+contextPath+url+"\" target=\"_blank\" title=\"��â���� �����ϴ�.\">";					
				}
			}else
			{
				link = "<a href=\""+contextPath+url+"\">";
			}
			
		}
		link += title;
		if("_blank".equals(menuVO.getMenuTg())){
			link += " <img src='/images/juknok/open_new2.png' alt='��â'  />";
		}
		link += "</a>";		
		return link;
	}
%>      