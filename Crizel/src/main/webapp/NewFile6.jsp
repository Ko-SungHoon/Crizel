<%@page import="org.jsoup.select.Elements"%>
<%@page import="org.jsoup.*"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="egovframework.rfc3.popup.web.PopupManager"%>
<%@page import="egovframework.rfc3.popup.vo.PopupVO"%>
<%@page import="egovframework.rfc3.board.web.BoardManager"%>
<%@page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%@ page import="egovframework.rfc3.menu.vo.*, java.util.*"%>
<%@page import="egovframework.rfc3.board.vo.BoardFileVO"%>

<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/gnlib/xml-parser-seatmate.jsp"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.9/vue.js"></script>

<%!

public List<String> getWeekendsDate(String year, String month){
	int yyyy = Integer.parseInt(year);
	int mm = Integer.parseInt(month);
	Calendar cal = Calendar.getInstance();
	List<String> friday	= new ArrayList<String>();
	
	cal.set(yyyy, mm-1, 1);
	int maxDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	
	for(int i=1; i<maxDate+1; i++){
		cal.clear();
		cal.set(yyyy, mm-1, i);
	switch(cal.get(cal.DAY_OF_WEEK)){
	case java.util.Calendar.FRIDAY:
		if(i<10){
			friday.add("0"+i); 
		}else{
			friday.add(""+i);
		}
	}
	 cal.clear();
	}
	return friday;
}

public class HolyDayVO{
	String month;
	String date;
	String name;
	String type;
}

public List<HolyDayVO> holyDay(){
	List<HolyDayVO> holyList	=	new ArrayList<HolyDayVO>();
	String json = "";
	HolyDayVO	holyDayVO		=	null;

	try {
		
		org.jsoup.nodes.Document document = Jsoup.connect("https://apis.sktelecom.com/v1/eventday/days?month=&year=&type=h&day=")
		.userAgent("Mozilla")
		.ignoreContentType(true)
		.header("TDCProjectKey", "61816f66-5e21-42aa-9d76-eed601aa42d5")
		.header("referer", "https://developers.sktelecom.com/projects/project_53742147/services/EventDay/Analytics/")
		.header("Accept", "application/json")
		.get();
		
		Elements elem = document.select("body");

	    for (org.jsoup.nodes.Element e : elem) {
	    	json += e.text();
		}
		
	    JSONParser jsonparse 	= 	new JSONParser();
		JSONObject	jsonObj		=	(JSONObject) jsonparse.parse(json);	
		JSONArray	jsonArr		=	(JSONArray)jsonObj.get("results");
		
		for(int i=0; i<jsonArr.size(); i++){
			JSONObject jObj = (JSONObject)jsonArr.get(i);
			holyDayVO	=	new HolyDayVO();
			holyDayVO.month	= (String)jObj.get("month");
			holyDayVO.date	= (String)jObj.get("day");
			holyDayVO.name	= (String)jObj.get("name");
			holyDayVO.type	= (String)jObj.get("type");
			holyList.add(holyDayVO);
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	return holyList;
}
%>
<%
	/** 휴관일 **/
	Calendar cal = Calendar.getInstance();
	Date date = new Date();
	List<HolyDayVO> holyList	=	holyDay();

	//현재 년월
	SimpleDateFormat holyYearFormat = new SimpleDateFormat("yyyy");
	SimpleDateFormat holyMonthFormat = new SimpleDateFormat("MM");
	String holyYear  = holyYearFormat.format(date);
	String holyMonth = holyMonthFormat.format(date);

	//휴관일 계산
	List<String> holyDayList = getWeekendsDate(holyYear, holyMonth);
	for(int i=0; i<holyList.size(); i++){
		if(holyMonth.equals(holyList.get(i).month)){
			if(!holyDayList.contains(holyList.get(i).date)){
				holyDayList.add(holyList.get(i).date);
			}
		}
	}
	
	//날짜순 정렬
	Collections.sort(holyDayList);

	/** 팝업존(인포존) **/
	List<PopupVO>
    popupVOList1 = null;
    PopupManager pm = new PopupManager(request);
    popupVOList1 = pm.getPopupList("info",cm.getDomainId(),200,false);
    String popupPath1 = pm.getFilePath(cm.getDomainId(),"info");


    /** 공지사항 **/
    List<BoardDataVO>
        boardDataVOList1 = null;
        BoardManager bm = new BoardManager(request);
        String noticeBdId = "BBS_0000001";						//해당게시판 BOARD_ID
        String noticeBdCd = "DOM_000000204001000000";			//해당게시판 MENU_CD
        boardDataVOList1 = bm.getBoardDataList(noticeBdId, 5);	//해당게시판 BOARD_ID와 출력할 갯수

        %>
        <!-- container -->
        <div id="container" class="clearfix">
            <!-- content -->
            <div id="contents" class="main_con1">
                <div class="dv_wrap">
                    <h1 class="blind">메인 콘텐츠</h1>

                    <!-- main visual -->
                    <section class="ma_visual">
                        <script type="text/javascript">
                            $(document).ready(function () {
                                $('.slider').bxSlider({
                                    pager: true,
                                    auto: true,
                                    controls: true,
                                    autoControls: true,
                                    speed: 600,
                                    pause: 5000,
                                    //mode:'fade'
                                });
                            });
                        </script>
                        <div class="visual_box">
                            <ul class="slider">
                                <li class="sl01">
                                    <span class="slider_area">
                                        <a href="/index.lib?menuCd=DOM_000000202007000000">
                                            <img src="/images/main/visual01_t1.png" alt="경남대표도서관을 찾아주신 여러분, 진심으로 환영합니다." />
                                            <span class="more">시설이용 안내</span>
                                        </a>
                                    </span>
                                </li>
                                <li class="sl02">
                                    <span class="slider_area">
                                        <a href="#">
<img src="/images/main/visual01_t2.png" alt="책 읽는 경남 만들기에 앞장서는 경남대표도서관이 되겠습니다." />
<span class="more">시설이용 안내</span>
</a>
                                    </span>
                                </li>
                                <!--<li class="sl03">
                                    <span class="slider_area">
                                        <a href="#"><img src="/images/main/visual01_t1.png" alt="책과 함께 행복한 미래를 열어갑니다." /></a>
                                    </span>
                                </li>
                                <li class="sl04">
                                    <span class="slider_area">
                                        <a href="#"><img src="/images/main/visual01_t1.png" alt="책과 함께 행복한 미래를 열어갑니다." /></a>
                                    </span>
                                </li>-->
                            </ul>
                        </div>
                    </section>
                    <!-- //main visual -->
                    <!-- 오늘의 책, 새로나온 책, 인기 도서 -->
                    <div class="book_board">
                        <!-- tab1_신착도서 -->
                        <div class="tab-on">
                            <!-- tab-on -->
                            <strong><a href="#brd-1">신착도서</a></strong>
                            <ul class="book_list" id="new-book-main">
                                <li v-for="(record, index) in records.LIST_DATA" v-if="index > 0">
                                   <a :href="'/index.lib?menuCd=DOM_000000201005000000&breg_no='+record.REG_NO">
                                        <p><api-image 
                                                :api-url="'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/getbookinfo?manage_code=MA&book_type=BOOK&'+'reg_no='+record.REG_NO"
                                                inline-style="width: 108px; height: 138px;"
                                            >
                                            </api-image></p>
                                        <span class="txt_item">{{record.TITLE_INFO}}</span>
                                    </a>
                                </li>
                            </ul>
                            <div class="bx-controls-direction">
                                <a class="bx-next" href="/index.lib?menuCd=DOM_000000201002000000">더보기</a>
                            </div>
                        </div>



                        <div>
                            <strong><a href="#brd-1">인기대출도서</a></strong>
                            <ul class="book_list" id="best-book-main" style="display:none;">
                                <li v-for="(record, index) in records.LIST_DATA">
                                    <a :href="'/index.lib?menuCd=DOM_000000201005000000&breg_no='+record.REG_NO">
                                        <p><api-image 
                                                :api-url="'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/getbookinfo?manage_code=MA&book_type=BOOK&'+'reg_no='+record.REG_NO"
                                                inline-style="width: 108px; height: 138px;"
                                            >
                                            </api-image></p>
                                        <span class="txt_item">{{record.TITLE}}</span>
                                    </a>
                                </li>
                            </ul>
                            <!-- <a href="#" class="more" title="인기대출도서 더보기"><img src="/images/main/ico_more03.gif" class="ico_more03" alt="자세히보기">더보기</a> -->

                            <div class="bx-controls-direction">
                                <a class="bx-next" href="/index.lib?menuCd=DOM_000000201004000000">더보기</a>
                            </div>
                        </div>

				<div id="spinner">
                                    <vue-simple-spinner
                                        size="big" message="로딩중..."
                                        v-show="loading"
                                    ></vue-simple-spinner>
				</div>

                    </div>


                    <!-- 공지사항/창업지원센터 탭메뉴 자바스크립트 -->
                    <script type="text/javascript">
                            function tab(num) {
                                for (i = 1; i <= 19; i++) {
                                    if (num == i) {
                                        document.getElementById("tab" + i).className = "on";
                                        document.getElementById("tab" + i).style.display = "block";
                                    } else {
                                        document.getElementById("tab" + i).className = "";
                                        document.getElementById("tab" + i).style.display = "none";
                                    }
                                }
                            }
                    </script>

                    <!-- // 오늘의 책, 새로나온 책, 인기 도서 -->
		
 <!-- 공지사항 -->
                    <div class="board-area">
                        <h2 class="blind">공지사항 &amp; 창업지원정보</h2>
                        <ul class="m_tab">
                            <li class="on" id="t_notice1">
                                <a href="#notice1_more" onclick="changemTab02(1);return false;" onfocus="changemTab02(1);" class="tab_txt">공지사항</a>
                                <div id="v_notice1" class="board_con" style="display: block;">
                                    <ul class="notice_list">
                                        <%for(BoardDataVO bdVO : boardDataVOList1){%>
                                        <li><a href="/board/view.<%=cm.getUrlExt()%>?boardId=<%=noticeBdId%>&amp;menuCd=<%=noticeBdCd%>&amp;startPage=1&amp;dataSid=<%=bdVO.getDataSid()%>"><%=strCut(bdVO.getDataTitle(), null, 32, 0, true, true)%></a><span class="date"><%=bdVO.getRegister_str()%></span></li>
                                        <%}%>
                                    </ul>
                                </div>
                                <a href="/board/list.lib?boardId=BBS_0000001&menuCd=DOM_000000204001000000&contentsSid=22" id="notice1_more" style="display: block;" class="more_btn">공지사항 더보기</a>
                            </li>
                        </ul>
                    </div>
<!-- //공지사항 -->
   
<!-- 팝업존 -->
                    <div class="popup_zone" id="popupzone">
                        <h2 class="blind">팝업존</h2>
                        <div class="control">
                            <span><em>1</em>/1</span>
                            <p>
                                <a href="" data-control="prev">이전</a>
                                <a href="" data-control="stop">멈춤</a>
                                <a href="" data-control="play" style="display: none;">시작</a>
                                <a href="" data-control="next">다음</a>
                            </p>
                        </div>
                        <ul class="obj">
                            <%if(popupVOList1.size() > 0){
                            for (PopupVO popupVO : popupVOList1) {
                            String popUrl = popupVO.getPopupUrl() == null ? "#" : popupVO.getPopupUrl();
                            String popScroll = popupVO.getPopupScroll().equals("Y") ? "yes" : "no";
                            int popWidth = popupVO.getPopupWidth()+5;
                            int popHeight = popupVO.getPopupHeight()+5;
                            String pop_target = popupVO.getPopupTarget();
                            if(pop_target == "_parent"){
                            pop_target = "_blank";
                            }
                            String aPopupTitle = "";
                            if("_blank".equals(pop_target)){
                            aPopupTitle = " title=\"새창이 열립니다.\"";
                            }
                            %>
                            <li class="item item_height">
                                <a href="<%=popUrl%>" target="<%=pop_target%>" <%=aPopupTitle%>>
                            <img src="<%=popupPath1%>/<%=popupVO.getPopupFile() %>" alt="<%=popupVO.getPopupSummary()%>" class="item_height" <%if(popupVO.getPopupSummary()!=null){%> title="<%=popupVO.getPopupSummary()%><%}%>">
                        </a>
                            </li>

                            <%}
                            }else{%>
                            <li class="item item_height">
                                <a href="#" target="_blank">
                                    <img src="/images/main/banner02.jpg" alt="2" class="item_height">
                                </a>
                            </li>
                            <%} %>
                        </ul>
                    </div>
                    <!-- //팝업존  -->
                    <!-- 팝업존 자바스크립트 -->
                    <script type="text/javascript">
                            var param = "#popupzone";
                            var btn = ".control";
                            var obj = ".item";
                            var auto = true;
                            var f = 1000;
                            var s = 5000;
                            var p = { use: true, type: 1, path: ".control span" };
                            var h = true;
                            popzone(param, btn, obj, auto, f, s, p, h);
                    </script>


                    <!-- 대표도서관 휴관일 안내 -->
                    <div class="banner_guide">
                        <a href="/index.lib?menuCd=DOM_000000204002000000">
                            <img src="/images/main/ico01.png" alt="">
                            <h2><strong><%=holyMonth%>월 휴관일</strong> <strong><span> 
                            <%for(int i=0; i<holyDayList.size(); i++){
                            	if(i==holyDayList.size()-1){
                            		out.print(holyDayList.get(i) + "일");
                            		if((i+1) % 4 == 0){
                            			out.print("<br/>");
                            		}
                            	}
                            	else{
                            		out.print(holyDayList.get(i) + "일, ");
                            		if((i+1) % 4 == 0){
                            			out.print("<br/>");
                            		}
                            	}
                            }%>
                            </span></strong></h2>
                        </a>
                    </div>
                    <!-- // 대표도서관 휴관일 안내 -->
                    <!-- 아이콘 메뉴 -->
                    <div class="banner_ico">
                        <h2 class="blind">메뉴모음</h2>
                        <ul>
                            <li class="menu01"><a href="/index.lib?menuCd=DOM_000000202008001000">책이음</a></li>
                            <li class="menu02"><a href="/index.lib?menuCd=DOM_000000202001000000">이용안내</a></li>
                            <li class="menu03"><a href="/index.lib?menuCd=DOM_000000205006000000">오시는 길</a></li>
                            <li class="menu04"><a href="/index.lib?menuCd=DOM_000000205007000000">경상남도<br>도서관</a></li>
                        </ul>
                    </div>
                    <!-- // 아이콘 메뉴 -->

 <!-- 좌석/실 잔여 현황 -->
                    <div class="banner_seat">
                        <a href="#" class="mo1">
                            <img src="/images/main/ico02.png" alt="">
                            <h2>디지털자료실<span>좌석예약</span></h2>
                        </a>
                        <h2 class="pc1">좌석/실 잔여 현황</h2>
                        <p class="pc1">경남대표도서관</p>
                        <ul class="pc1">
                            <% seatParser seatParser = new seatParser(); 
                                String seatmateUrl = "http://27.101.166.45:8800/seatmate/index.php";
                                String[] seats = seatParser.displayDocument(seatmateUrl);
                            %>                 
                            <li class="ico01">청소년학습실 (남)<span><%= seats[6] %>/<%= seats[4] %></span></li>
                            <li class="ico02">청소년학습실 (여)<span><%= seats[11] %>/<%= seats[9] %></span></li>
                            <li class="ico03">디지털자료실 <span class="link"><a href="http://27.101.166.45:8800/libmate/LibMate.php" target="_blank" title="새창 열림">예약</a></span></li>
                        </ul>
                    </div>
                    <!-- // 좌석/실 잔여 현황 -->
                </div>

            </div>
            <!--// content -->
            <!-- 자추찾는메뉴 -->
            <div class="main_con2">
                <div id="mquick">
                    <h2>자주 찾는 메뉴</h2>
                    <ul class="mquick_menu">
                    <% if( EgovUserDetailsHelper.isRole("ROLE_USER") ) { //로그인 되어 있으면 %>    
                        <li><a href="/index.lib?menuCd=DOM_000000206001001000" class="ico1"><p>대출조회 및 반납연기</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000206001003000" class="ico2"><p>대출예약도서</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000206001004000" class="ico3"><p>희망도서 신청</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000203003000000" class="ico4"><p>자원봉사 신청</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000203002000000" class="ico5"><p>도서관 견학신청</p></a></li>
                    <%} else { %>
                        <li><a href="/index.lib?menuCd=DOM_000000217001000000&return=/index.lib?menuCd=DOM_000000206001001000" class="ico1"><p>대출조회 및 반납연기</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000217001000000&return=/index.lib?menuCd=DOM_000000206001003000" class="ico2"><p>대출예약도서</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000217001000000&return=/index.lib?menuCd=DOM_000000206001004000" class="ico3"><p>희망도서 신청</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000217001000000&return=/index.lib?menuCd=DOM_000000203003000000" class="ico4"><p>자원봉사 신청</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000217001000000&return=/index.lib?menuCd=DOM_000000203002000000" class="ico5"><p>도서관 견학신청</p></a></li>
                    <%} %>
                        <li><a href="/index.lib?menuCd=DOM_000000204006000000" class="ico6"><p>도서기증 안내</p></a></li>
                        <li><a href="/board/list.lib?boardId=BBS_0000003&menuCd=DOM_000000204002000000&contentsSid=23" class="ico7"><p>도서관 일정</p></a></li>
                        <li><a href="/index.lib?menuCd=DOM_000000204005000000" class="ico8"><p>사서에게 물어보세요.</p></a></li>
                    </ul>
                    <div class="clear"></div>
                </div>
            </div>
            <!-- // 자추찾는메뉴 -->

        </div><!--// container -->

	<script src="/gnlib/lcms/component/vue-simple-spinner.min.js"></script>
        <script src="/gnlib/lcms/main-new-best.js"></script>
	<script src="/gnlib/lcms/component/api-image.js"></script>
<!--팝업띄우기-->
<script type="text/javascript" src="<%=request.getContextPath()%>/js/egovframework/rfc3/popup/popup.js"></script>
<%
	String poprecnum1="";
	String poprecnum2="";
	List<PopupVO> popupVOList=null;
	List<PopupVO> popupVOGroupList=null;
	PopupManager popupManager=new PopupManager(request);
	popupVOList=popupManager.getPopupList("pop",cm.getDomainId(),4);
	popupVOGroupList=popupManager.getPopupList("pop",cm.getDomainId(),1,true);
	PopupVO pv = new PopupVO();
	String popupPath=popupManager.getFilePath(cm.getDomainId(),"pop");
%>                  

<!--일반팝업띄우기-->
<script>
<%
	int iheights=0;
	String popupSid="";
	for(int i=0; i<popupVOList.size(); i++){
		pv=(PopupVO)popupVOList.get(i);
		popupSid=""+pv.getPopupSid();
		poprecnum2 = getCookie(request, "POPUPEACH"+popupSid,cm.getDomainId());

		if ( poprecnum2.equals(cm.getDomainId()) ) {
			iheights=pv.getPopupHeight();
			boolean scroll=pv.getPopupScroll() != null && "Y".equals(pv.getPopupScroll()) ? true : false;
			String scroll_str="";
			if(scroll) {
				scroll_str="yes";
			} else {
				scroll_str="no";
			}
%>
		  ShowOpenWin('EventPopEachUP<%=pv.getPopupSid()%>', '<%=request.getContextPath()%>/userView.<%=cm.getUrlExt()%>?popupSid=<%=pv.getPopupSid()%>&command=individual', '<%=pv.getPopupLeft()%>', '<%=pv.getPopupTop()%>', '<%=pv.getPopupWidth()%>', '<%=iheights+25%>','<%=scroll_str%>' ,'7');
<%
		}
	}
%>
</script>                                      
<%!
	public String getCookie(HttpServletRequest request, String keyname, String domainId) throws Exception {
		Cookie [] cookies = request.getCookies();		    //-- 1. 배열로 쿠키를 몽땅 로드한다.
		//String value = "";								//-- 2. 키값을 리턴하기 위한 변수 선언.
		String value = domainId;								//-- 2. 키값을 리턴하기 위한 변수 선언.
		if(cookies!=null) {
			for(int j=0;j<cookies.length;j++) {				//-- 3. 배열을 돌면서 해당 키가 나올때까지 루프!!
				if(keyname.equals(cookies[j].getName())) {
					value = cookies[j].getValue();
					break;
				}
			}
		}
		return value;
	}
%>                                                                                                                                                                                                                                               