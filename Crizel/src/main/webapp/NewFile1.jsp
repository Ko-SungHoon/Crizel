<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="egovframework.rfc3.iam.manager.ViewManager"%>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%!
  public String formatDate(String str) {
    if( str == null || str.length() < 8 ) return str;
    StringBuilder sb = new StringBuilder(str);
    sb.insert(6, "-");
    sb.insert(4, "-");
    return sb.toString();
  }

  public String formatTime(String str) {
    if( str == null || str.length() < 6 ) return str;
    StringBuilder sb = new StringBuilder(str);
    sb.insert(4, ":");
    sb.insert(2, ":");
    return sb.toString();
  }

  // 수강 접수 여부
  private boolean isRcrtAble(GsndStoryTelling entity) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHH:mm");
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

    private class GsndStoryTelling {
      public String stno;
	  public String titleimg;
      public String title;
      public String lecturer;
      public String attendee;
      public String charge;
      public String chargetel;
      public String stdate;
      public String sttime;
      public String stloc;
      public String status;
      public String stdesc;
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

    private class GsndStoryTellingFile {
      public int stfileno;
      public int stno;
	  public String titleimg;
      public String filename;
      public long filesize;
      public String realname;
      public String regdate;
      public String regtime;
    }

    private class GsndStoryTellingRegister {
      public String stno;
      public String userid;
      public String username;
      public String usertel1;
      public String usertel2;
      public String usertel3;
      public String rgst_method;
      public String regdate;
      public String regtime;
      public String statecd;
      public String moddate;
      public String modtime;

      public String printRgstMethod() {
        if( "VISIT".equals(rgst_method) ) return "방문접수";
        if( "ONLINE".equals(rgst_method) ) return "온라인접수";
        if( "TEL".equals(rgst_method) ) return "전화접수";
        
        return "";
      }

      public String printStatecd() {
        if("RGST".equals(statecd)) return "접수";
        else if("CNCL_USER".equals(statecd)) return "취소(사용자)";
        else if("CNCL_ADMIN".equals(statecd)) return "취소(관리자)";
        else return "";
      }

      public String printUserTel() {
  	    StringBuilder sb = new StringBuilder();
        if( usertel1 != null ) sb.append(usertel1);
        if( usertel2 != null ) sb.append("-").append(usertel2);
        if( usertel3 != null ) sb.append("-").append(usertel3);
        return sb.toString();
      }
    }

    private class GsndStoryTellingMapper implements RowMapper<GsndStoryTelling> {
      public GsndStoryTelling mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndStoryTelling vo = new GsndStoryTelling();
        vo.stno = rs.getString("stno");
        vo.titleimg = rs.getString("titleimg");
        vo.title = rs.getString("title");
        vo.lecturer = rs.getString("lecturer");
        vo.attendee = rs.getString("attendee");
        vo.charge = rs.getString("charge");
        vo.chargetel = rs.getString("chargetel");
        vo.stdate = rs.getString("stdate");
        vo.sttime = rs.getString("sttime");
        vo.stloc = rs.getString("stloc");
        vo.status = rs.getString("status");
        vo.stdesc = rs.getString("stdesc");
        vo.rcrt_sdate = rs.getString("rcrt_sdate");
        vo.rcrt_stime = rs.getString("rcrt_stime");
        vo.rcrt_edate = rs.getString("rcrt_edate");
        vo.rcrt_etime = rs.getString("rcrt_etime");
        vo.rcrt_method = rs.getString("rcrt_method");
        vo.rcrt_total = rs.getInt("rcrt_total");
        vo.rcrt_online = rs.getInt("rcrt_online");
        vo.rcrt_add = rs.getInt("rcrt_add");
        vo.rgst_visit = rs.getInt("rgst_visit");
        vo.rgst_online = rs.getInt("rgst_online");
        vo.rgst_tel = rs.getInt("rgst_tel");
        return vo;
      }
    }

    private class GsndStoryTellingRegisterMapper implements RowMapper<GsndStoryTellingRegister> {
      public GsndStoryTellingRegister mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndStoryTellingRegister vo = new GsndStoryTellingRegister();
        vo.stno = rs.getString("stno");
        vo.userid = rs.getString("userid");
        vo.username = rs.getString("username");
        vo.usertel1 = rs.getString("usertel1");
        vo.usertel2 = rs.getString("usertel2");
        vo.usertel3 = rs.getString("usertel3");
        vo.rgst_method = rs.getString("rgst_method");
        vo.regdate = rs.getString("regdate");
        vo.regtime = rs.getString("regtime");
        vo.statecd = rs.getString("statecd");
        vo.moddate = rs.getString("moddate");
        vo.modtime = rs.getString("modtime");
        return vo;
      }
    }
%>

<%

SessionManager sessionManager = new SessionManager(request);
ViewManager viewManager = new ViewManager(request, response);
boolean isRole = sessionManager.isRoleAdmin() || viewManager.isGranted(request, "DOM_000000203006000000", "WRITE");

  String stno = request.getParameter("stno");
  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
  
  StringBuilder query = new StringBuilder();
  query.append(" SELECT A1.* ");
  query.append("     , (SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STNO = A1.STNO AND RGST_METHOD='VISIT') RGST_VISIT");
  query.append("     , (SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STNO = A1.STNO AND RGST_METHOD='ONLINE') RGST_ONLINE");
  query.append("     , (SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STNO = A1.STNO AND RGST_METHOD='TEL') RGST_TEL");
  query.append("     , (SELECT MAX(STFILENO) FROM GSND_STORY_TELLING_FILE WHERE TITLEIMG = 'Y' AND STNO = A1.STNO) TITLEIMG");
  query.append(" FROM GSND_STORY_TELLING A1 WHERE STNO = ? ");

  GsndStoryTelling entity = jdbcTemplate.queryForObject(query.toString(), new Object[]{ stno }, new GsndStoryTellingMapper() );
  
  List<GsndStoryTellingFile> stFiles = jdbcTemplate.query(
    "SELECT * FROM GSND_STORY_TELLING_FILE WHERE TITLEIMG = 'N' AND STNO = ?", 
    new Object[]{stno}, 
    new RowMapper<GsndStoryTellingFile>() {
      public GsndStoryTellingFile mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndStoryTellingFile stfile = new GsndStoryTellingFile();
        int idx = 1;
        stfile.stfileno = rs.getInt(idx++);
        stfile.stno = rs.getInt(idx++);
        stfile.titleimg = rs.getString(idx++);
        stfile.filename = rs.getString(idx++);
        stfile.filesize = rs.getLong(idx++);
        stfile.realname = rs.getString(idx++);
        stfile.regdate = rs.getString(idx++);
        stfile.regtime = rs.getString(idx++);
        return stfile;
      }
    });

%>

<style>
	label[for] { cursor: default;}
</style>

<div class="con">
    <form id="viewForm" action="lect-write-do.jsp" method="post">
        <input type="hidden" name="stno" value="<%= entity.stno%>">
        <div class="board">
            <fieldset>
                <legend>게시글 입력</legend>
                <table class="board_view">
                    <caption>게시글에 대한 정보 입력</caption>
                    <colgroup>
                      <col style="width:20%">
                      <col style="width:30%">
                      <col style="width:20%">
                      <col style="width:30%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" class="topline"><label for="title">대표이미지</label></th>
                            <td colspan="3" class="topline"><img src="<%=request.getContextPath() %>/index.lib?contentsSid=171&stno=<%= entity.stno %>&stfileno=<%= entity.titleimg %>" id="titleimg" style="width:50% !important;"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="title">강좌명</label></th>
                            <td colspan="3"><%=entity.title%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lecturer">강사</label></th>
                            <td><%=entity.lecturer%></td>
                            <th scope="row"><label for="attendee">교육대상</label></th>
                            <td><%=entity.attendee%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="stdate">교육일시</label></th>
                            <td><%= formatDate( entity.stdate )%> <%= entity.sttime %></td>
                            <th scope="row"><label for="stloc">강의장소</label></th>
                            <td><%=entity.stloc%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="charge">담당자</label></th>
                            <td><%=entity.charge%></td>
                            <th scope="row"><label for="chargetel">담당자 연락처</label></th>
                            <td><%=entity.chargetel%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_total">모집인원</label></th>
                            <td>
                              <%=entity.rcrt_total%>명
                              (온라인:<%=entity.rcrt_online%>명)
                            </td>
                            <th scope="row"><label for="rcrt_method">접수방법</label></th>
                            <td>
							<div class="etc_ico">
							<p class="badge_guide">
								<%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_ONLINE") != -1) { %><span class="badge_i ca1">온라인접수</span> <%	} %>
								<%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_VISIT") != -1) { %><span class="badge_i ca2">방문접수</span> <%	} %>
								<%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_TEL") != -1) { %><span class="badge_i ca3">전화접수</span> <%	} %>
							</p>
							</div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_sdate">모집기간</label></th>
                            <td colspan="3">
                              <%=formatDate( entity.rcrt_sdate )%>
                              <%=entity.rcrt_stime%>
                              ~
                              <%=formatDate( entity.rcrt_edate )%>
                              <%=entity.rcrt_etime%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="stdesc">강의소개</label></th>
                            <td colspan="3" height="200" valign="top">
                                <%=entity.stdesc.replaceAll("\n", "<br>")%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="file1">첨부파일</label></th>
                            <td colspan="3">

                            <% if(stFiles.size() == 0) { %>
                              <div>첨부된 파일이 없습니다.</div>
                            <% } %>

                            <% for(GsndStoryTellingFile stfile : stFiles) {%>
                                <div id="uploadfield">
                                    <p class="file">
                                        <a href="<%=request.getContextPath() %>/index.lib?contentsSid=170&stno=<%= stfile.stno %>&stfileno=<%= stfile.stfileno %>"><%= stfile.filename %></a>
                                        <span class="file_size">(파일크기: <%= (stfile.filesize / 1024) %> kb)</span>
                                    </p>
                                </div>
                            <% } %>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 버튼 영역 -->
                <div class="btn_area">
		<%//if( isRcrtAble(entity) ) { %>
                    <button type="button" class="btn medium color1" onclick="openDialogStoryRegister('<%= entity.stno %>')">접수</button>
		<% //} %>
                    <button type="button" class="btn medium white" onclick="location.hash='list'">목록</button>

                    <% if(isRole) { %>
                    <!-- 수정, 삭제 -->
                    <button type="button" class="btn medium white" onclick="loadModify(<%= entity.stno %>)">수정</button>
                    <button type="button" id="btnLectDelete" class="btn medium white">삭제</button>
                    <% } %>
                </div>
                <!-- //버튼 영역 끝 -->
            </fieldset>
        </div>
        <!-- //board_write -->
    </form>


    <% 
      if(isRole) { 
        String queryRegisters = "SELECT * FROM GSND_STORY_TELLING_REGISTER WHERE STNO = ? ORDER BY REGDATE, REGTIME";
        List<GsndStoryTellingRegister> rgstList = jdbcTemplate.query(queryRegisters, new Object[]{ stno }, new GsndStoryTellingRegisterMapper() );
    %>
    <div>
      <h3 class="bl_h3">수강신청 내역</h3>
      <table class="tb_board lecture">
        <thead>
          <tr>
            <th>번호</th>
            <th>이름(아이디)</th>
            <th>연락처</th>
            <th>등록방법</th>
            <th>등록일자</th>
            <th>등록시간</th>
            <th>상태</th>
            <th>비고</th>
          </tr>
        </thead>
        <tbody>
          <% int i=1; for(GsndStoryTellingRegister rgst : rgstList) { %>
          <tr>
            <td><%= i++ %></td>
            <td><%= rgst.username %> (<%= rgst.userid %>)</td>
            <td><%= rgst.printUserTel() %></td>
            <td><%= rgst.printRgstMethod() %></td>
            <td><%= formatDate( rgst.regdate ) %></td>
            <td><%= formatTime( rgst.regtime ) %></td>
            <td><%= rgst.printStatecd() %></td>
            <td>
            <% if( "RGST".equals(rgst.statecd) ) { %>
              <button type="button" onclick="cancelRegister('<%= rgst.stno %>', '<%= rgst.userid %>')">취소</button>
            <% } %>
            </td>
          </tr>
          <% } %>
	  <% if(rgstList.size() == 0 ) {%>
	  <tr><td colspan="8" height="100" align="center"> 등록된 수강신청 내역이 없습니다.</td></tr>
	  <% } %>
        </tbody>
      </table>
    </div>
    <% } %>
    <!-- 레이어 콘텐츠 -->
</div>

<script language="javascript">
  $(function() {
    if( $("#titleimg").width() > 500 ) {
	$("#titleimg").css("width", 500);
    }

    $("#btnLectDelete").click(function(){
      if( confirm("삭제 하시겠습니까?") ) {
        $.ajax({
          url:"?contentsSid=163&stno=<%= entity.stno %>"
        }).done(function(data){
          loadList();
        });
      }
    });
  });
</script>

<% if(isRole) {  %>
<form name="frmCancelRegister" action="<%= request.getContextPath()%>/index.lib?contentsSid=169">
  <input type="hidden" name="rgstmode" value="ADMIN_CANCEL_REGISTER">
  <input type="hidden" name="stno" value="">
  <input type="hidden" name="userid" value="">
</form>

<script language="javascript">
  $(function() {
  	$("form[name='frmCancelRegister']").ajaxForm({
      beforeSubmit: function(arr, $form, options) {
        return true;
      },
      success: function(response,status){
  		  alert('접수 취소 하였습니다.');
	  	  location.reload();
      },
      error: function(response, status){
        alert("오류가 발생하였습니다. 잠시후 다시 시도 하십시오.");
      }
    });
  });

  function cancelRegister(stno, userid) {
    if( confirm(userid + ' 님의 접수 내역을 취소 하시겠습니까?') ) {
      $("form[name='frmCancelRegister']").find("input[name='stno']").val(stno);
      $("form[name='frmCancelRegister']").find("input[name='userid']").val(userid);
      $("form[name='frmCancelRegister']").submit();
    }
  }
</script>
<% } %>
                  
                                                 