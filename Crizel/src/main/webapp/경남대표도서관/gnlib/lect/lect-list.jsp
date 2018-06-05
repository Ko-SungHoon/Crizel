<%@page contentType="text/html;charset=utf-8"%>

<%//   lect-list.jsp   %>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%!
  private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddHH:mm");

  private boolean isRcrtBefore(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date rcrt_sdate = sdf.parse(entity.rcrt_sdate + entity.rcrt_stime);
      result = now.before(rcrt_sdate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 수강 접수 여부
  private boolean isRcrtAble(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date rcrt_sdate = sdf.parse(entity.rcrt_sdate + entity.rcrt_stime);
      java.util.Date rcrt_edate = sdf.parse(entity.rcrt_edate + entity.rcrt_etime);
      result = now.after(rcrt_sdate) && now.before(rcrt_edate) &&  entity.rcrt_total > entity.getRgstTotal();
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 수강 접수 종료
  private boolean isRcrtOver(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date lectsdate = sdf.parse(entity.lectsdate + entity.rcrt_stime);
      java.util.Date rcrt_edate = sdf.parse(entity.rcrt_edate + entity.rcrt_etime);
      result = now.after(rcrt_edate) && now.before(lectsdate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 강의중 여부
  private boolean isLecturing(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date lectsdate = sdf.parse(entity.lectsdate + "00:00");
      java.util.Date lectedate = sdf.parse(entity.lectedate + "24:00");
      result = now.after(lectsdate) && now.before(lectedate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 강의 종료 여부
  private boolean isLectureOver(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date lectedate = sdf.parse(entity.lectedate + "18:00");
      result = now.after(lectedate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }
 
  // 강좌 상태 출력
  private String printLectureStatus(GsndLecture entity) {
    if(isRcrtAble(entity)) return "모집중";

    if(isLecturing(entity)) return "교육중";

    if(isLectureOver(entity)) return "교육 종료";

    if(isRcrtOver(entity)) return "모집 종료";

    return "";
  }

  private class GsndLecture {
    public String lectno;
    public String title;
    public String course;
    public String lecturer;
    public String attendee;
    public String charge;
    public String chargetel;
    public String lectsdate;
    public String lectedate;
    public String tuition;
    public String lectloc;
    public String status;
    public String rcrt_sdate;
    public String rcrt_stime;
    public String rcrt_edate;
    public String rcrt_etime;
    public String rcrt_method;
    public int rcrt_total;
    public int rcrt_online;
    public int rcrt_add;
    public int rgst_visit;
    public int rgst_online;
    public int rgst_tel;

    public int getRgstTotal() {
      return this.rgst_visit + this.rgst_online + this.rgst_tel;
    }
  }

  private class GsndLectureMapper implements RowMapper<GsndLecture> {
    public GsndLecture mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndLecture vo = new GsndLecture();
      vo.lectno = rs.getString("lectno");
      vo.title = rs.getString("title");
      vo.course = rs.getString("course");
      vo.lecturer = rs.getString("lecturer");
      vo.attendee = rs.getString("attendee");
      vo.charge = rs.getString("charge");
      vo.chargetel = rs.getString("chargetel");
      vo.lectsdate = rs.getString("lectsdate");
      vo.lectedate = rs.getString("lectedate");
      vo.tuition = rs.getString("tuition");
      vo.lectloc = rs.getString("lectloc");
      vo.status = rs.getString("status");
      vo.rcrt_sdate = rs.getString("rcrt_sdate");
      vo.rcrt_stime = rs.getString("rcrt_stime");
      vo.rcrt_edate = rs.getString("rcrt_edate");
      vo.rcrt_etime = rs.getString("rcrt_etime");
      vo.rcrt_method = rs.getString("rcrt_method");
      vo.rcrt_total = rs.getInt("rcrt_total");
      vo.rcrt_online = rs.getInt("rcrt_online");
      vo.rcrt_add = rs.getInt("rcrt_Add");
      vo.rgst_visit = rs.getInt("rgst_visit");
      vo.rgst_online = rs.getInt("rgst_online");
      vo.rgst_tel = rs.getInt("rgst_tel");
      return vo;
    }
  }
%>

<%
  request.setCharacterEncoding("UTF-8");
  String course = (request.getParameter("course") == null ) ? "" : request.getParameter("course");
  String where = (request.getParameter("where") == null) ? "" : request.getParameter("where");
  String keyword = (request.getParameter("keyword") == null) ? "" : request.getParameter("keyword"); 

  course = new String(course  .getBytes("iso-8859-1"), "utf-8");
  keyword = new String(keyword .getBytes("iso-8859-1"), "utf-8");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  // paging
  int listSize = 10;
  StringBuilder countQuery = new StringBuilder("SELECT COUNT(*) from GSND_LECTURE WHERE LECTNO > 0");
  if( !"".equals(course) ) countQuery.append(" 	 	  AND COURSE = '").append(course).append("' ");
  if( !"".equals(where) && !"".equals(keyword)) countQuery.append(" 	 	  AND ").append(where).append(" like '%").append(keyword).append("%' ");
  
  int total = jdbcTemplate.queryForObject(countQuery.toString(), Integer.class);
  int currPage = (request.getParameter("currPage") == null) ? 1 : Integer.valueOf(request.getParameter("currPage"));
  int lastPage = total / listSize + 1;

   // listing
  StringBuilder query = new StringBuilder();
  query.append(" SELECT C1.*  ");
  query.append("     , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = C1.LECTNO AND RGST_METHOD='VISIT') RGST_VISIT");
  query.append("     , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = C1.LECTNO AND RGST_METHOD='ONLINE') RGST_ONLINE");
  query.append("     , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = C1.LECTNO AND RGST_METHOD='TEL') RGST_TEL");
  query.append(" FROM ( ");
  query.append(" 	SELECT ROWNUM RNUM, B1.* ");
  query.append(" 	FROM ( ");
  query.append(" 		SELECT A1.*  ");
  query.append(" 		FROM GSND_LECTURE A1 ");
  query.append(" 		WHERE LECTNO > 0 ");
  if( !"".equals(course) ) {
    query.append(" 	 	  AND COURSE = '").append(course).append("' ");
  }
  if( !"".equals(where) && !"".equals(keyword)) {
    query.append(" 	 	  AND ").append(where).append(" like '%").append(keyword).append("%' ");
  }
  query.append(" 		ORDER BY LECTNO DESC ");
  query.append(" 	) B1 ");
  query.append(" 	WHERE ROWNUM <= ? ");
  query.append(" ) C1");
  query.append(" WHERE RNUM > ? ");

  List<GsndLecture> list = jdbcTemplate.query(query.toString(), new Object[]{currPage * listSize, (currPage - 1) * listSize}, new GsndLectureMapper() );

  // course list
  String courseQuery = "SELECT DISTINCT COURSE FROM GSND_LECTURE";
  List<String> courses = jdbcTemplate.query(courseQuery, new RowMapper<String>() {
            public String mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getString("COURSE");
            }
        });

%>

<div class="con">
    <div class="search mb_30">
        <form name="rfc_bbs_searchForm" class="searchForm board_srch" onSubmit="return lectSearch(this);">
            <fieldset>
                <legend>전체검색</legend>
                <label for="course" class="blind">과정</label>
                <select id="course" name="course" class="base small">
                  <option value="">과정</option>
                  <% for(String crs : courses) {%>
                  <option value="<%=crs%>"><%=crs%></option>
                  <% } %>
                </select>
                <label for="where" class="blind">대상</label>
                <select id="where" name="where" class="base small last">
                  <option value="attendee" <%if("attendee".equals(where)) {%> selected <%}%>>대상</option>
                  <option value="title" <%if("title".equals(where)) {%> selected <%}%>>강좌명</option>
                </select>
                <label for="keyword" class="blind">검색</label>
                <input id="keyword" type="text" name="keyword" title="검색단어" class="text_form search" value="<%= keyword %>">
                <button type="submit">검색</button>
            </fieldset>
        </form>
    </div>
    <div class="badge_area">
        <input type="hidden" name="pageNo" value="1">
        <p class="r badge_guide">
            <span class="badge_i ca1">온라인접수</span>
            <span class="badge_i ca2">방문접수</span>
            <span class="badge_i ca3">전화접수</span>
        </p>
    </div>
	<p class="txt_type4">* 수강신청은 강좌명 또는 상세보기를 클릭하세요.</p>
    <p class="total">총 <strong><%= total %></strong>건 [page <%= currPage %>/<%= lastPage %>]</p>
    <table class="tb_board lecture">
        <caption>강좌 수강신청 목록</caption>
        <colgroup>
            <col style="width:10%">
            <col style="width:36%">
            <col style="width:9%">
            <col style="width:10%">
            <col style="width:14%">
            <col style="width:10%">
        </colgroup>
        <thead>
            <tr>
                <th scope="col">과정</th>
                <th scope="col">강좌명</th>
                <th scope="col">대상</th>
                <th scope="col">정원</th>
                <th scope="col">접수방법</th>
                <th scope="col">상태</th>
            </tr>
        </thead>
        <tbody>
            <!-- 검색된 내용이 없을경우 안내  -->
            <% if( list.size() == 0 )  {%>
            <tr>
                <td colspan="6">검색된 내용이 없습니다.</td>
            </tr>
             <% } %>
            <%  for(GsndLecture entity : list) { %>
            <tr>
              <td class="object1"><%= entity.course %></td>
              <td class="left object2">
                <a href="#read" onclick="loadLectRead('<%= entity.lectno %>');">
                  [<%= printLectureStatus(entity) %>] <%= entity.title %><br>
                  모집기간: <%= entity.rcrt_sdate %> <%= entity.rcrt_stime %> ~ <%= entity.rcrt_edate %> <%= entity.rcrt_etime %><br>
                  교육기간: <%= entity.lectsdate %> ~ <%= entity.lectedate %>
                </a>
              </td>
              <td class="etc object3"><%= entity.attendee %></td>
              <td class="left etc">
                <ul>
                  <li>전체 <%= entity.getRgstTotal() %>/<%= entity.rcrt_total %></li>
                  <% if(entity.rcrt_online > 0) {%>
                  <li>온라인 <%= entity.rgst_online %>/<%= entity.rcrt_online %></li>
                  <% } %>
                </ul>
              </td>
              <td class="etc_ico">
                <%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_ONLINE") != -1){%><div><span class="badge_i ca1">온라인접수</span></div> <% } %>
                <%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_VISIT") != -1) { %><div><span class="badge_i ca2">방문접수</span></div> <% } %>
                <%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_TEL") != -1) { %><div><span class="badge_i ca3">전화접수</span></div> <% } %>
              </td>
              <td class="etc2">
                <p><a href="javascript:loadLectRead('<%= entity.lectno %>');" class="btn_type1 btn_type_s">상세보기</a></p>
                <p>
                  <% if(isRcrtBefore(entity)) {%>
                    <span class="btn_type1 btn_type_s">접수전</span>
                  <% } else if(isRcrtAble(entity) && entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_ONLINE") != -1){ %>
                    <button class="btn_type1 btn_type_s color1" lectno="<%= entity.lectno %>" onclick="openDialogLectureRegister('<%= entity.lectno %>')"><%= EgovUserDetailsHelper.isRole("ROLE_ADMIN") ? "접수하기" : "수강신청" %></button>
                  <% } else if(isRcrtOver(entity)) { %>
                    <span class="btn_type1 btn_type_s">접수종료</span>
                  <% } else { %>
                  <% } %></p>
              </td>
            </tr>
            <%  } %>
        </tbody>
    </table>

    <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) { %>
    <div align="right">
      <a href="javascript:loadLectWrite();" class="btn medium color1">강좌 등록</a>
    </div>
    <% } %>

    <!-- 페이징 -->
    <div class="pageing">
        <a href="javascript:jumpPage(1)" class="bt" title="처음페이지">
            &lt;&lt;
        </a>
        <a href="javascript:jumpPage()" id="prev" class="bt" title="이전페이지">&lt;</a>
        <% for(int i=1; i<=lastPage; i++) { %>
        <a href="javascript:jumpPage(<%= i %>)" <%if(i == currPage) { %>class="on" <% } %>><%= i %></a>
        <% } %>
        <a href="javascript:jumpPage()" id="next" class="bt" title="다음페이지">&gt;</a>
        <a href="javascript:jumpPage(lastPage)" class="bt" title="마지막페이지">&gt;&gt;</a>
    </div>
    <!-- //페이징 -->
</div>

<form name="formPage" method="get">
  <input type="hidden" name="currPage" value="<%= request.getParameter("currPage")%>">
  <input type="hidden" name="course" value="<%= course %>">
  <input type="hidden" name="where" value="<%= where %>">
  <input type="hidden" name="keyword" value="<%= keyword %>">
</form>

<script language="javascript">
  $(function(){
  });

  function jumpPage(currPage) {
    document.formPage.currPage.value = currPage;
    loadLectList( $("form[name='formPage']").serialize());
  }

  function lectSearch(frm) {
    document.formPage.currPage.value = 1;
    document.formPage.course.value = frm.course.value;
    document.formPage.where.value = frm.where.value;
    document.formPage.keyword.value = frm.keyword.value;
    loadLectList( $("form[name='formPage']").serialize());

    return false;
  }
</script>
