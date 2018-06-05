<%@page contentType="text/html;charset=utf-8"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%
  if( !EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) {
    out.println("권한이 부족합니다.");
    return;
  }

  String[] timelist = {"09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"};
%>

<div class="con">
    <form name="lectWriteForm" action="/gnlib/lect/lect-write-do.jsp" method="post" enctype="multipart/form-data">
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
                                <input type="text" name="title" id="title" class="wps_100">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lecturer">강사</label></th>
                            <td><input type="text" name="lecturer" id="lecturer" class="wps_100"></td>
                            <th scope="row"><label for="attendee">교육대상</label></th>
                            <td><input type="text" name="attendee" id="attendee" class="wps_100"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectsdate">교육일시</label></th>
                            <td>
                              <input type="text" name="lectsdate" id="lectsdate" size="8" class="dateinput" readonly>
                              ~
                              <input type="text" name="lectedate" id="lectedate" size="8" class="dateinput" readonly>
                            </td>
                            <th scope="row"><label for="course">교육과정</label></th>
                            <td><input type="text" name="course" id="course" class="wps_100"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectloc">강의장소</label></th>
                            <td><input type="text" name="lectloc" id="lectloc" class="wps_100"></td>
                            <th scope="row"><label for="tuition">수강료</label></th>
                            <td><input type="text" name="tuition" id="tuition" class="" value="0">(0 : 무료)</td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="charge">담당자</label></th>
                            <td><input type="text" name="charge" id="charge" class="wps_100"></td>
                            <th scope="row"><label for="chargetel">담당자 연락처</label></th>
                            <td><input type="text" name="chargetel" id="chargetel" class="wps_100"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_total">모집인원</label></th>
                            <td>
                              <input type="text" name="rcrt_total" id="rcrt_total" size="1">명
                              (온라인:<input type="text" name="rcrt_online" id="rcrt_online" size="1">명)
                            </td>
                            <th scope="row"><label for="method">접수방법</label></th>
                            <td>
                              <label><input type="checkbox" name="rcrt_method" value="RCRT_ONLINE">온라인접수</label>
                              <label><input type="checkbox" name="rcrt_method" value="RCRT_VISIT">방문접수</label>
                              <label><input type="checkbox" name="rcrt_method" value="RCRT_TEL">전화접수</label>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_sdate">모집기간</label></th>
                            <td colspan="3">
                              <input type="text" name="rcrt_sdate" id="rcrt_sdate" size="8" class="dateinput" readonly>
                              <select name="rcrt_stime" style="line-height:29px; height:31px">
                                <% for(String time : timelist) { %>
                                <option value="<%= time %>"><%= time %></option>
                                <% } %>
                              </select>
                              ~
                              <input type="text" name="rcrt_edate" id="rcrt_edate" size="8" class="dateinput" readonly>
                              <select name="rcrt_etime" style="line-height:29px; height:31px">
                                <% for(String time : timelist) { %>
                                <option value="<%= time %>"><%= time %></option>
                                <% } %>
                              </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectdesc">강의소개</label></th>
                            <td colspan="3">
                                <textarea name="lectdesc" id="lectdesc" class="wps_100 datacon" rows="5" cols="50" title="강의소개"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="file1">첨부파일</label></th>
                            <td colspan="3">
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
                    <button type="submit" class="btn medium color1">강좌 등록</button>
                    <button type="button" class="btn medium white" onclick="loadLectList()">취소</button>
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
            console.log("beforeSubmit");
            return $("form[name='lectWriteForm']").valid();
          },
          success: function(response,status){
            loadLectList();
          },
          error: function(response, status){
            alert("강좌 등록중 오류가 발생하였습니다. 입력값을 다시 확인하십시오.");
          }  
        });
      });
    </script>
</div>
