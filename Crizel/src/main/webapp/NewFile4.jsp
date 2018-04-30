<%@ page import="java.util.*" %>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO;" %>
<%   
String nowmenuCD1 = "";
String nowmenuCD2 = "";
MenuVO currentMenuVO1 = cm.getMenuVO(); 
nowmenuCD1 = currentMenuVO1.getMenuCd().substring(0,16); 
nowmenuCD2 = currentMenuVO1.getMenuCd().substring(0,13); 
String menuCD1 = "";   
if(currentMenuVO1 != null) menuCD1 = currentMenuVO1.getMenuCd();   
else menuCD1 = "";   

MenuVO parentMenuVO1 = cm.getMenuCd(menuCD1, 1);

%>

	<aside id="dv_wrap"> 
		<dl>
<%if (nowmenuCD2 .equals("DOM_000000108")) {%>
			<dt class="sub_chief_bg tit"><a class="tt" href="<%=request.getContextPath() %>/index.<%=cm.getUrlExt()%>?menuCd=<%=parentMenuVO1.getMenuCd()%>">소통하는 <br class="nor" />교육감실!</a><a href="#" class="menubtn"><img src="/img/common/aside_plus.png" alt="메뉴열기" /></a></dt>
<%} else if(nowmenuCD2 .equals("DOM_000000106")) {%>
<%-- 			<dt class="tit"><a class="tt" href="<%=request.getContextPath() %>/index.<%=cm.getUrlExt()%>?menuCd=<%=parentMenuVO1.getMenuCd()%>" style="font-size: 22px;"><%=parentMenuVO1.getMenuNm()%><span><%=parentMenuVO1.getMenuHelp()%></span></a><a href="#" class="menubtn"><img src="/img/common/aside_plus.png" alt="메뉴열기" /></a></dt> --%>
			<dt class="tit"><a class="tt" href="<%=request.getContextPath() %>/index.<%=cm.getUrlExt()%>?menuCd=DOM_000000106002000000" style="font-size: 22px;"><%=parentMenuVO1.getMenuNm()%><span><%=parentMenuVO1.getMenuHelp()%></span></a><a href="#" class="menubtn"><img src="/img/common/aside_plus.png" alt="메뉴열기" /></a></dt>	
<%} else {%>
			<dt class="tit"><a class="tt" href="<%=request.getContextPath() %>/index.<%=cm.getUrlExt()%>?menuCd=<%=parentMenuVO1.getMenuCd()%>"><%=parentMenuVO1.getMenuNm()%><span><%//=parentMenuVO1.getMenuHelp()%></span></a><a href="#" class="menubtn"><img src="/img/common/aside_plus.png" alt="메뉴열기" /></a></dt>
<%}%>
			<dd>


<%

ArrayList menuListLeft = (ArrayList)cm.getMenuList(menuCD1, 2);   
MenuVO parentMenuVOLeft = cm.getMenuCd(menuCD1, 1);
int depthLeft = cm.getMainNum();   
    if(depthLeft > 6)   
    {   
        depthLeft = 0;   
    }   
    String menuThemeLeft  = "";   

	    //2차 메뉴 출력   
            if(menuListLeft != null && menuListLeft.size() > 0) {       
%>
				<ul class="depth2">
<%
                for(int i=0; i<menuListLeft.size(); i++) {   
                    MenuVO menuVOLeft = (MenuVO)menuListLeft.get(i);   
                    //로그인 상태에 따른 메뉴 출력 여부   
					 ArrayList menuListLeft2 = (ArrayList)cm.getMenuList(menuVOLeft.getMenuCd(), 3);  
					 if(menuListLeft2 != null && menuListLeft2.size() > 0) { 
					 %>
						<li class="link">

			<%}else{%>
						<li>
			<%}%>


						<%=getLinkleft(menuVOLeft,menuCD1,2,"","","on",cm.getUrlExt(),request.getContextPath())%>





                    <%   
                    //3차메뉴 목록   
                   
                    if(menuListLeft2 != null && menuListLeft2.size() > 0) {   
			String ddopeth = menuVOLeft.getMenuCd().substring(0,16);
                        %>
			<%if(nowmenuCD1.equals(ddopeth)){%>
						<ul class="depth3 open">

			<%}else{%>
						<ul class="depth3" >
			<%}%>
                               <%   
                                for(int j=0; j<menuListLeft2.size(); j++) {   
                                    MenuVO menuVOLeft2 = (MenuVO)menuListLeft2.get(j);   
  
                                %> 
                                
                                
                            <li><%=getLinkleft(menuVOLeft2,menuCD1,3,"","","on",cm.getUrlExt(),request.getContextPath())%></li>
							
							
				<%}%>
						</ul>
			<%}%>


					</li>

<%}%>					


				</ul>


<%}%>



			</dd>
		</dl>
	<%if (parentMenuVO1.getMenuNm().equals("다문화 교육센터")) {%>
		<div class="padT20 mcleft_lang">
			<p class="tit">LANGUAGE</p>
			<ul>
				<li><a href="/multiculture/vie/" target="_blank" title="베트남어홈페이지가 새창으로 열립니다."><img src="/images/multicultural/ico_lang_vie.png" alt="Vietnamese 베트남어"></a></li>				
				<li  class="bg"><a href="/multiculture/chi/" target="_blank" title="중국어홈페이지가 새창으로 열립니다."><img src="/images/multicultural/ico_lang_chi.png" alt="中國語 중국어"></a></li>
				<li class="bg mobg1"><a href="/multiculture/jap/" target="_blank" title="일본어홈페이지가 새창으로 열립니다."><img src="/images/multicultural/ico_lang_jap.png" alt="日本語 일본어"></a></li>
				<li class="mobg2"><a href="/multiculture/eng/" target="_blank" title="영어홈페이지가 새창으로 열립니다."><img src="/images/multicultural/ico_lang_eng.png" alt="ENGLISH 영어"></a></li>
			</ul>
		</div>
	<%}

    if("DOM_000000153".equals(nowmenuCD2) ){%>
        <ul class="main-type-04-left">
           <li><a href="/index.gne?menuCd=DOM_000000153009000000"><img src="/img/record/bn-edu70.png" alt="경남교육 70년사" /></a></li>
        </ul>
    <%}%>
	
	</aside>


<%!   
    //메뉴 링크 작성 함수   
    public static String getLinkleft(MenuVO menuVO,String menuCd,int depth,String id,String classNm,String script,String urlExt,String contextPath)   
    {   
        //메뉴링크   
        String link="";   
        String link2="";
        //메뉴 제목 또는 메뉴 이미지   
        String title="";   
        //메뉴 기본 이미지   
        String img="";   
        //링크주소   
        String url = "";   
	int vv1 = 10+((depth)*3);

	String val1 = menuVO.getMenuCd().substring(0,vv1);
	String val2 = menuCd.substring(0,vv1);
	String nowchkahref = "N";
        if(val1.equals(val2))   
        {   
		nowchkahref = "Y";
        }
  
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
//            link = "<a href=\"#"+menuVO.getMenuCd()+"\" onclick=\""+script+"('"+menuVO.getMenuCd()+"');\" onkeypress=\""+script+"('"+menuVO.getMenuCd()+"');\">";   
            link = "<a href=\"#"+menuVO.getMenuCd()+"\" ";   

            //현재 메뉴와 같거나 상위 메뉴인 경우 over 이미지 처리   
            if( menuCd != null && !"".equals(menuCd))   
            {   
                if(nowchkahref.equals("Y"))   
                {   
	            link += " class = \"on\" ";   
                }else{
				link += " class = \"me_link\" ";   
				}
            } 
            link += " >";   
        }else{   
            url = "/index."+urlExt+"?menuCd=" + menuVO.getMenuCd();    
  
            if("_blank".equals(menuVO.getMenuTg())) {                  
                if(menuVO.getMenuTgOption() != null && !"".equals(menuVO.getMenuTgOption()))   
                {   
                    link =  "<a href=\""+contextPath+url+"\" ";   
                    link += "  title=\""+menuVO.getMenuNm()+"\" ";   

//                    link += " onclick=\"window.open(this.href,'"+menuVO.getMenuCd()+"','"+menuVO.getMenuTgOption()+"');return false;\" title=\""+menuVO.getMenuNm()+"\"";   
//                    link += " onkeypress=\"window.open(this.href,'"+menuVO.getMenuCd()+"','"+menuVO.getMenuTgOption()+"');return false;\" title=\""+menuVO.getMenuNm()+"\">";   
                       
                }else  
                {   
                    link = "<a href=\""+contextPath+url+"\" target=\"_blank\" title=\"새창으로 열립니다.\" ";   
					link2 = " <img src=\"/img/common/open_new.png\" alt=\"새창\" class=\"open_new\" />";
                }   
            }else  
            {   
                link = "<a href=\""+contextPath+url+"\" ";   
            }  
	    

            if( menuCd != null && !"".equals(menuCd))   
            {   
                if(nowchkahref.equals("Y"))   
                {   
	            link += " class = \"on\" ";   
                }
            } 
            link += " >"; 
               
        }   
        link += title+link2+"</a>";   

//                if( (menuVO.getMenuCd().substring(0,(4+((depth-1)*3)))).equals(menuCd.substring(0,(4+((depth-1)*3)))) )   
//                { 
//		}
//	int vv1 = 10+((depth)*3);
//	link += "/"+depth+"/"+menuVO.getMenuCd().substring(0,vv1)+"/"+menuCd.substring(0,vv1);
        return link;   
    }   
%>