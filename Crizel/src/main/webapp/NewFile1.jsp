<%@ page import="java.util.*" %>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO;" %>
<%   
	String nowmenuCD = "";
    MenuVO currentMenuVO = cm.getMenuVO(); 


	nowmenuCD = currentMenuVO.getMenuCd(); 
	if(nowmenuCD== null){
		nowmenuCD = "DOM_0000000000000";
	}else{
		nowmenuCD = nowmenuCD.substring(0,13); 
	}


    String menuCD = "";   
%>

<nav id="gnb_menu">	
	<ul class="depth1">




		<li id="menu_01"><a href="/index.gne?menuCd=DOM_000000103001001001" id="menu_a_01" <%if(nowmenuCD.equals("DOM_000000103")){%>class="on"<%}%>><span>전자민원마당</span></a>
		<div class="depth2_box" id="menu_sub_01" style="display:none">
				<dl class="mbg_01">
					<dt>전자민원마당</dt>
					<dd>함께 배우며 미래를 열어가는<br /> 민주시민 육성</dd>
				</dl>

<%
menuCD = "DOM_000000103000000000";  
ArrayList menuList = (ArrayList)cm.getMenuList(menuCD, 2);   
MenuVO parentMenuVO = cm.getMenuCd(menuCD, 1);
int depth = cm.getMainNum();   
    if(depth > 6)   
    {   
        depth = 0;   
    }   
    String menuTheme  = "";   

	    //2차 메뉴 출력   
            if(menuList != null && menuList.size() > 0) {       
%>
				<ul class="depth2">
<%
                for(int i=0; i<menuList.size(); i++) {   
                    MenuVO menuVO = (MenuVO)menuList.get(i);   
                    //로그인 상태에 따른 메뉴 출력 여부   
%>





					<li><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>

                    <%   
                    //3차메뉴 목록   
                    ArrayList menuList2 = (ArrayList)cm.getMenuList(menuVO.getMenuCd(), 3);   
                    if(menuList2 != null && menuList2.size() > 0) {   
                        %>
						<ul class="depth3">
                               <%   
                                for(int j=0; j<menuList2.size(); j++) {   
                                    MenuVO menuVO2 = (MenuVO)menuList2.get(j);   
  
                                %> 
							<li><%=getLink(menuVO2,menuCD,3,"","","RFCShowMenu2",cm.getUrlExt(),request.getContextPath())%></li>
				<%}%>
						</ul>
			<%}%>

					</li>


		<%}%>

				</ul>

	<%}%>





				<a href="#menu_01" class="menuclose" id="menu_sub_close_01"><img src="/img/common/menu_close.png" alt="메뉴닫기" /></a>
				<div class="clr"></div>
			</div>
		</li>







		<li id="menu_02"><a href="/board/list.gne?boardId=notice034&menuCd=DOM_000000104002001000&contentsSid=61" id="menu_a_02" <%if(nowmenuCD.equals("DOM_000000104")){%>class="on"<%}%>><span>참여마당</span></a>
		<div class="depth2_box" id="menu_sub_02" style="display:none">
				<dl class="mbg_02">
					<dt>참여마당</dt>
					<dd>함께 배우며 미래를 열어가는<br /> 민주시민 육성</dd>

				</dl>
<%
menuCD = "DOM_000000104000000000";  
menuList = (ArrayList)cm.getMenuList(menuCD, 2);   
parentMenuVO = cm.getMenuCd(menuCD, 1);
depth = cm.getMainNum();   
    if(depth > 6)   
    {   
        depth = 0;   
    }   
    menuTheme  = "";   

	    //2차 메뉴 출력   
            if(menuList != null && menuList.size() > 0) {       
%>
				<ul class="depth2">
<%
                for(int i=0; i<menuList.size(); i++) {   
                    MenuVO menuVO = (MenuVO)menuList.get(i);   
                    //로그인 상태에 따른 메뉴 출력 여부   
%>





					<li><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>

                    <%   
                    //3차메뉴 목록   
                    ArrayList menuList2 = (ArrayList)cm.getMenuList(menuVO.getMenuCd(), 3);   
                    if(menuList2 != null && menuList2.size() > 0) {   
                        %>
						<ul class="depth3">
                               <%   
                                for(int j=0; j<menuList2.size(); j++) {   
                                    MenuVO menuVO2 = (MenuVO)menuList2.get(j);   
  
                                %> 
							<li><%=getLink(menuVO2,menuCD,3,"","","RFCShowMenu2",cm.getUrlExt(),request.getContextPath())%></li>
				<%}%>
						</ul>
			<%}%>

					</li>


		<%}%>

				</ul>

	<%}%>
				<a href="#menu_02" class="menuclose" id="menu_sub_close_02"><img src="/img/common/menu_close.png" alt="메뉴닫기" /></a>
				<div class="clr"></div>
			</div>
		</li>




		<li id="menu_03"><a href="/index.gne?menuCd=DOM_000000105013001000" id="menu_a_03" <%if(nowmenuCD.equals("DOM_000000105")){%>class="on"<%}%>><span>알림마당</span></a>
		<div class="depth2_box" id="menu_sub_03" style="display:none">
				<dl class="mbg_03">
					<dt>알림마당</dt>
					<dd>함께 배우며 미래를 열어가는<br /> 민주시민 육성</dd>
				</dl>
<%
menuCD = "DOM_000000105000000000";  
menuList = (ArrayList)cm.getMenuList(menuCD, 2);   
parentMenuVO = cm.getMenuCd(menuCD, 1);
depth = cm.getMainNum();   
    if(depth > 6)   
    {   
        depth = 0;   
    }   
    menuTheme  = "";   

	    //2차 메뉴 출력   
            if(menuList != null && menuList.size() > 0) {       
%>
				<ul class="depth2">
<%
                for(int i=0; i<menuList.size(); i++) {   
                    MenuVO menuVO = (MenuVO)menuList.get(i);   
                    //로그인 상태에 따른 메뉴 출력 여부   
%>





					<li><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>

                    <%   
                    //3차메뉴 목록   
                    ArrayList menuList2 = (ArrayList)cm.getMenuList(menuVO.getMenuCd(), 3);   
                    if(menuList2 != null && menuList2.size() > 0) {   
                        %>
						<ul class="depth3">
                               <%   
                                for(int j=0; j<menuList2.size(); j++) {   
                                    MenuVO menuVO2 = (MenuVO)menuList2.get(j);   
  
                                %> 
							<li><%=getLink(menuVO2,menuCD,3,"","","RFCShowMenu2",cm.getUrlExt(),request.getContextPath())%></li>
				<%}%>
						</ul>
			<%}%>

					</li>


		<%}%>

				</ul>

	<%}%>
				<a href="#menu_03" class="menuclose" id="menu_sub_close_03"><img src="/img/common/menu_close.png" alt="메뉴닫기" /></a>
				<div class="clr"></div>
			</div>
		</li>



		<li id="menu_04"><a href="/board/list.gne?boardId=notice020&menuCd=DOM_000000106002001000&contentsSid=98" id="menu_a_04" <%if(nowmenuCD.equals("DOM_000000106")){%>class="on"<%}%>><span>정부3.0 정보마당</span></a>
		<div class="depth2_box" id="menu_sub_04" style="display:none">
				<dl class="mbg_04">
					<dt>정부3.0 정보마당</dt>
					<dd>함께 배우며 미래를 열어가는<br /> 민주시민 육성</dd>
				</dl>
<%
menuCD = "DOM_000000106000000000";  
menuList = (ArrayList)cm.getMenuList(menuCD, 2);   
parentMenuVO = cm.getMenuCd(menuCD, 1);
depth = cm.getMainNum();   
    if(depth > 6)   
    {   
        depth = 0;   
    }   
    menuTheme  = "";   

	    //2차 메뉴 출력   
            if(menuList != null && menuList.size() > 0) {       
%>
				<ul class="depth2">
<%
                for(int i=0; i<menuList.size(); i++) {   
                    MenuVO menuVO = (MenuVO)menuList.get(i);   
                    //로그인 상태에 따른 메뉴 출력 여부   
                    if("DOM_000000106016000000".equals(menuVO.getMenuCd())){
                    %>
                    <li>
                    <a href="#findteacher" title="새창이 열립니다." onClick="javascript:window.open('/index.gne?menuCd=DOM_000000106016000000','findteacher','width=650, height=750, top=20, scrollbars=yes, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, resizable=no');"><%=menuVO.getMenuNm()%></a>
                    <% 	
                    }else{
                    	%>
                        <li><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>
                  <% } %>

                    <%   
                    //3차메뉴 목록   
                    ArrayList menuList2 = (ArrayList)cm.getMenuList(menuVO.getMenuCd(), 3);   
                    if(menuList2 != null && menuList2.size() > 0) {   
                        %>
						<ul class="depth3">
                               <%   
                                for(int j=0; j<menuList2.size(); j++) {   
                                    MenuVO menuVO2 = (MenuVO)menuList2.get(j);   
  
                                %> 
							<li><%=getLink(menuVO2,menuCD,3,"","","RFCShowMenu2",cm.getUrlExt(),request.getContextPath())%></li>
				<%}%>
						</ul>
			<%}%>

					</li>


		<%}%>

				</ul>

	<%}%>
				<a href="#menu_04" class="menuclose" id="menu_sub_close_04"><img src="/img/common/menu_close.png" alt="메뉴닫기" /></a>
				<div class="clr"></div>
			</div>
		</li>



		<li id="menu_05" class="last"><a href="/index.gne?menuCd=DOM_000000107001001000" id="menu_a_05" <%if(nowmenuCD.equals("DOM_000000107")){%>class="on"<%}%>><span>교육청안내</span></a>
			<div class="depth2_box" id="menu_sub_05" style="display:none">
				<dl class="mbg_05">
					<dt>교육청 안내</dt>
					<dd>함께 배우며 미래를 열어가는<br /> 민주시민 육성</dd>
				</dl>
<%
menuCD = "DOM_000000107000000000";  
menuList = (ArrayList)cm.getMenuList(menuCD, 2);   
parentMenuVO = cm.getMenuCd(menuCD, 1);
depth = cm.getMainNum();   
    if(depth > 6)   
    {   
        depth = 0;   
    }   
    menuTheme  = "";   

	    //2차 메뉴 출력   
            if(menuList != null && menuList.size() > 0) {       
%>
				<ul class="depth2">
<%
                for(int i=0; i<menuList.size(); i++) {   
                    MenuVO menuVO = (MenuVO)menuList.get(i);   
                    //로그인 상태에 따른 메뉴 출력 여부   
%>





					<li><%=getLink(menuVO,menuCD,2,"","","RFCShowMenu",cm.getUrlExt(),request.getContextPath())%>

                    <%   
                    //3차메뉴 목록   
                    ArrayList menuList2 = (ArrayList)cm.getMenuList(menuVO.getMenuCd(), 3);   
                    if(menuList2 != null && menuList2.size() > 0) {   
                        %>
						<ul class="depth3">
                               <%   
                                for(int j=0; j<menuList2.size(); j++) {   
                                    MenuVO menuVO2 = (MenuVO)menuList2.get(j);   
  
                                %> 
							<li><%=getLink(menuVO2,menuCD,3,"","","RFCShowMenu2",cm.getUrlExt(),request.getContextPath())%></li>
				<%}%>
						</ul>
			<%}%>

					</li>


		<%}%>

				</ul>

	<%}%>
				<a href="#menu_05" class="menuclose" id="menu_sub_close_05"><img src="/img/common/menu_close.png" alt="메뉴닫기" /></a>
				<div class="clr"></div>
			</div>
		</li>





















	</ul>
</nav>

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
	
	// 새창 여부
	boolean new_icon = false;
  
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
		    new_icon = true;
                }   
            }else  
            {   
                link = "<a href=\""+contextPath+url+"\">";   
            }   
               
        }   
        link += title;   
	if(new_icon) {
		link += " <img src=\"/img/common/open_new2.png\" alt=\"새창이 열립니다.\" class=\"open_new\" />";
	}
	link += "</a>";   
        return link;   
    }   
%>