<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%!
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
      public String lectdesc;
      public String rcrt_sdate;
      public String rcrt_stime;
      public String rcrt_edate;
      public String rcrt_etime;
      public String rcrt_method;
      public int rcrt_total;
      public int rcrt_online;
      public int rcrt_add;
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
        vo.lectdesc = rs.getString("lectdesc");
        vo.rcrt_sdate = rs.getString("rcrt_sdate");
        vo.rcrt_stime = rs.getString("rcrt_stime");
        vo.rcrt_edate = rs.getString("rcrt_edate");
        vo.rcrt_etime = rs.getString("rcrt_etime");
        vo.rcrt_method = rs.getString("rcrt_method");
        vo.rcrt_total = rs.getInt("rcrt_total");
        vo.rcrt_online = rs.getInt("rcrt_online");
        vo.rcrt_add = rs.getInt("rcrt_Add");
        return vo;
      }
    }

    private class GsndLectureFile {
      public int lectfileno;
      public int lectno;
      public String filename;
      public long filesize;
      public String realname;
      public String regdate;
      public String regtime;
    }
%>

<%
  if( !EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) {
    out.println("권한이 부족합니다.");
    return;
  }
  
  String[] timelist = {"09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"};

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
  
  StringBuilder query = new StringBuilder();
  query.append(" SELECT A1.* FROM GSND_LECTURE A1 WHERE LECTNO = ? ");

  GsndLecture entity = jdbcTemplate.queryForObject(query.toString()
    , new Object[]{ request.getParameter("lectno") }
    , new GsndLectureMapper() );

  List<GsndLectureFile> lectFiles = jdbcTemplate.query(
    "SELECT * FROM GSND_LECTURE_FILE WHERE LECTNO = ?", 
    new Object[]{request.getParameter("lectno")}, 
    new RowMapper<GsndLectureFile>() {
      public GsndLectureFile mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndLectureFile lectfile = new GsndLectureFile();
        int idx = 1;
        lectfile.lectfileno = rs.getInt(idx++);
        lectfile.lectno = rs.getInt(idx++);
        lectfile.filename = rs.getString(idx++);
        lectfile.filesize = rs.getLong(idx++);
        lectfile.realname = rs.getString(idx++);
        lectfile.regdate = rs.getString(idx++);
        lectfile.regtime = rs.getString(idx++);
        return lectfile;
      }
    });
%>

<div class="con">
    <form name="lectWriteForm" action="<%= request.getContextPath() %>/gnlib/lect/lect-modify-do.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name="lectno" value="<%= entity.lectno%>">
        <div class="board">
            <fieldset>
                <legend>게시글 입력</legend>
                <table class="board_write">
                    <caption>게시글에 대한 정보 입력</caption>
                    <colgroup>
                      <col style="width:20%">
                      <col style="width:30%">
                      <col style="width:20%">
                      <col style="width:30%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" class="topline">
                                <label for="title">강좌명</label>
                            </th>
                            <td colspan="3" class="topline">
                                <input type="text" name="title" id="title" class="wps_100" value="<%=entity.title%>">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lecturer">강사</label></th>
                            <td><input type="text" name="lecturer" id="lecturer" class="wps_100" value="<%=entity.lecturer%>"></td>
                            <th scope="row"><label for="attendee">교육대상</label></th>
                            <td><input type="text" name="attendee" id="attendee" class="wps_100" value="<%=entity.attendee%>"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectsdate">교육일시</label></th>
                            <td>
                              <input type="text" name="lectsdate" id="lectsdate" size="10" class="dateinput" readonly value="<%=entity.lectsdate%>">
                              ~
                              <input type="text" name="lectedate" id="lectedate" size="10" class="dateinput" readonly value="<%=entity.lectedate%>">
                            </td>
                            <th scope="row"><label for="course">교육과정</label></th>
                            <td><input type="text" name="course" id="course" class="wps_100" value="<%=entity.course%>"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectloc">강의장소</label></th>
                            <td><input type="text" name="lectloc" id="lectloc" class="wps_100" value="<%=entity.lectloc%>"></td>
                            <th scope="row"><label for="tuition">수강료</label></th>
                            <td><input type="text" name="tuition" id="tuition" class="" value="<%=entity.tuition%>">(0 : 무료)</td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="charge">담당자</label></th>
                            <td><input type="text" name="charge" id="charge" class="wps_100" value="<%=entity.charge%>"></td>
                            <th scope="row"><label for="chargetel">담당자 연락처</label></th>
                            <td><input type="text" name="chargetel" id="chargetel" class="wps_100" value="<%=entity.chargetel%>"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_total">모집인원</label></th>
                            <td>
                              <input type="text" name="rcrt_total" id="rcrt_total" size="2" value="<%=entity.rcrt_total%>">명
                              (온라인:<input type="text" name="rcrt_online" id="rcrt_online" size="2" value="<%=entity.rcrt_online%>">명)
                            </td>
                            <th scope="row"><label for="method">접수방법</label></th>
                            <td>
                              <label><input type="checkbox" name="rcrt_method" value="RCRT_ONLINE" <%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_ONLINE") != -1) { out.print("checked"); } %>>온라인접수</label>
                              <label><input type="checkbox" name="rcrt_method" value="RCRT_VISIT" <%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_VISIT") != -1) { out.print("checked"); } %>>방문접수</label>
                              <label><input type="checkbox" name="rcrt_method" value="RCRT_TEL" <%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_TEL") != -1) { out.print("checked"); } %>>전화접수</label>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_sdate">모집기간</label></th>
                            <td colspan="3">
                              <input type="text" name="rcrt_sdate" id="rcrt_sdate" size="10" class="dateinput" readonly value="<%=entity.rcrt_sdate%>">
                              <select name="rcrt_stime" style="line-height:29px; height:31px">
                                <% for(String time : timelist) { %>
                                <option value="<%= time %>" <%= (time.equals(entity.rcrt_stime)) ? "selected" : "" %>><%= time %></option>
                                <% } %>
                              </select>
                              ~
                              <input type="text" name="rcrt_edate" id="rcrt_edate" size="10" class="dateinput" readonly value="<%=entity.rcrt_edate%>">
                              <select name="rcrt_etime" style="line-height:29px; height:31px">
                                <% for(String time : timelist) { %>
                                <option value="<%= time %>" <%= (time.equals(entity.rcrt_etime)) ? "selected" : "" %>><%= time %></option>
                                <% } %>
                              </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectdesc">강의소개</label></th>
                            <td colspan="3">
                                <textarea name="lectdesc" id="lectdesc" class="wps_100 datacon" rows="5" cols="50" title="강의소개"><%=entity.lectdesc%></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="file1">첨부파일</label></th>
                            <td colspan="3">
                            <% for(GsndLectureFile lectfile : lectFiles) {%>
                                <div>삭제 : <input type="checkbox" name="delfileno" value="<%= lectfile.lectfileno %>"><%= lectfile.filename %> (<%= lectfile.filesize %>)</div>
                            <% } %>
                                <div>
                                    <input type="file" name="file1" id="file1" title="첨부파일">
                                </div>
                                <div>
                                    <input type="file" name="file2" id="file2" title="첨부파일">
                                </div>
                                <div>
                                    <input type="file" name="file3" id="file3" title="첨부파일">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 버튼 영역 -->
                <div class="btn_area">
                    <button type="submit" class="btn medium color1">수정</button>
                    <button type="button" class="btn medium white" onclick="loadLectRead('<%= entity.lectno%>');">취소</button>
                </div>
                <!-- //버튼 영역 끝 -->
            </fieldset>
        </div>
        <!-- //board_write -->
    </form>
    <script language="javascript">
      $(function(){
        $(".dateinput").datepicker({
	      changeMonth: true,
              changeYear: true,
	      dateFormat: 'yy-mm-dd',
	      showMonthAfterYear: true, // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
	      dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
	      monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'] // 월의 한글 형식.
	});

        $("form[name='lectWriteForm']").validate({
          debug: false,
          onkeyup: false,
          onfocusout: false,
          rules: {
            title: { required: true, maxlength: 50 },
            lecturer: { required: true, maxlength: 30 },
            attendee: { required: true, maxlength: 10 },
            lectsdate: { required: true },
            lectedate: { required: true },
            course: { required: true, maxlength: 20 },
            lectloc: { required: true, maxlength: 30 },
            tuition: { required: true, number:true },
            charge: { required: true, maxlength: 20 },
            chargetel: { required: true, maxlength: 30 },
            rcrt_total: { required: true, number: true, range: [1, 50] },
            rcrt_online: { required: true, number: true, range: [0, 50] },
            rcrt_method: { required: true },
            rcrt_sdate: { required: true },
            rcrt_edate: { required: true },
            lectdesc: { required: true }
          }, 
          messages: {
            title: { required: '강좌명은 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            lecturer: { required: '강사는 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            attendee: { required: '교육대상은 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            lectsdate: { required: '교육 시작일자는 필수 입력값 입니다.' },
            lectedate: { required: '교육 종료일자는 필수 입력값 입니다.' },
            course: { required: '교육과정은 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            lectloc: { required: '교육장소는 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            tuition: { required: '수강료는 필수 입력값 입니다.', number: '숫자만 입력해야 합니다.'},
            charge: { required: '담당자는 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            chargetel: { required: '담당자 연락처는 필수 입력값 입니다.', maxlength: $.validator.format("강좌명은 {0} 글자 이상 입력할 수 없습니다.")},
            rcrt_total: { required: '모집인원은 필수 입력값 입니다.', number: '숫자만 입력해야 합니다.'},
            rcrt_online: { required: '온라인 모집인원은 필수 입력값 입니다.', number: '숫자만 입력해야 합니다.'},
            rcrt_method: { required: '접수방법은 필수 입력값 입니다.'},
            rcrt_sdate: { required: '모집기간 시작일은 필수 입력값 입니다.'},
            rcrt_edate: { required: '모집기간 종료일은 필수 입력값 입니다.'},
            lectdesc: { required: '강의소개는 필수 입력값 입니다.'}
          }
        });

        $("form[name='lectWriteForm']").ajaxForm({
          beforeSubmit: function(arr, $form, options) {
            return $("form[name='lectWriteForm']").valid();
          },
          success: function(response,status){
            loadLectRead('<%= entity.lectno%>');
          },
          error: function(response, status){
            alert("강좌 등록중 오류가 발생하였습니다. 입력값을 다시 확인하십시오.");
          }  
        });
      });
    </script>

</div>