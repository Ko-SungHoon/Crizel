<%
String o_cd    = parseNull(request.getParameter("o_cd"),"1000004009000"); 	//부서별 코드 입력
%>
<%@ include file="/program/works/workCnt.jsp"%>

<!--<p class="c"><img src="/img/sub/ready.jpg" alt="현재 페이지 준비중입니다. 이용에 불편을 드려 대단히 죄송합니다."></p>-->

<!-- <section class="buseo_juyo">
	<h3>2017년 9월 1일 기준</h3>
	<table class="tbl_type01 c5">
		<caption>2017년 9월 1일 기준 창의인재과의 이름, 전화번호, 담당업무를 나타내고 있습니다.</caption>
		<colgroup><col class="wps_10" /><col class="wps_10" /><col class="wps_15" /><col class="wps_30" /><col class="wps_10" /></colgroup>
		<thead>
			<tr>
				<th scope="col">직위·직급</th>
				<th scope="col">성명</th>
				<th scope="col">전화번호</th>
				<th scope="col">담당업무</th>
				<th scope="col">업무대행자</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>과 장</td>
				<td>권우식</td>
				<td>055-210-5130</td>
				<td class="l">
					<ul class="type02">
					  <li>창의인재과 업무 총괄</li>
					</ul>
				</td>
				<td>김이회</td>
			</tr>
		</tbody>
	</table>
</section>

<section class="buseo_juyo">
	<h3>과학정보교육담당 업무분장</h3>
	<table class="tbl_type01 c5">
		<caption>과학정보교육담당의 직위·직급, 이름, 전화번호, 담당업무를 나타내고 있습니다.</caption>
		<colgroup><col class="wps_10" /><col class="wps_10" /><col class="wps_15" /><col class="wps_30" /><col class="wps_10" /></colgroup>
		<thead>
			<tr>
				<th scope="col">직위·직급</th>
				<th scope="col">성명</th>
				<th scope="col">전화번호</th>
				<th scope="col">담당업무</th>
				<th scope="col">업무대행자</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>장학관</td>
				<td>안태환</td>
				<td>055-210-5131</td>
				<td class="l">
					<ul class="type02">
						<li>과학정보교육 기획 및 관리</li>
					</ul>
				</td>
				<td>조용국</td>
			</tr>
			<tr>
				<td>장학사</td>
				<td>조용국</td>
				<td>055-210-5132</td>
				<td class="l">
					<ul class="type02">
						<li>창의인재과 교육 계획 및 과 주요 업무</li>
						<li>과학교육 일반 및 활성화</li>
						<li>과학과 탐구·실험교육 내실화</li>
						<li>과학교육 교수·학습자료 보급</li>
						<li>과학교사 전문성 신장(연구회, 연수)</li>
						<li>미래형 과학교실 구축·운영</li>
						<li>융합인재(STEAM) 교육</li>
						<li>학교내 무한상상실 운영</li>
						<li>과학중점고등학교 운영</li>
						<li>과학고등학교 운영 지도</li> 
						<li>경남과학교육원 운영 지도 </li>
					</ul>
				</td>
				<td>이중화</td>
			</tr>
			<tr>
				<td>장학사</td>
				<td>임채환</td>
				<td>055-210-5133</td>
				<td class="l">
					<ul class="type02">
						<li>ICT활용 농산어촌 학습여건 개선</li>
						<li>디지털교과서 개발 및 활용 지원</li>
						<li>스마트교육 모델학교 관리</li>
						<li>EBS활용 사회통합 교육멘토링</li>
						<li>정보통신윤리교육 및 인터넷중독예방교육</li>
						<li>수업지원목적 저작물 이용 및 홍보</li>
						<li>인터넷중독예방교육위원회 운영</li>
						<li>스마트폰 없는 건강한 잠자리운동(공약)</li>
						<li>고경력 과학자 멘토링 운영</li>
						<li>과학관련 민간단체 지원</li>
						<li>경남교육연구정보원(사이버학습) 지원</li>
					</ul>
				</td>
				<td>이진숙</td>
			</tr>
			<tr>
				<td>장학사</td>
				<td>이진숙</td>
				<td>055-210-5134</td>
				<td class="l">
					<ul class="type02">
						<li>정보교육 일반 및 활성화</li>
						<li>SW교육 선도학교 운영 </li>
						<li>SW교육 교원역량강화 연수 운영</li>
						<li>SW교육 선도요원 및 자문단 운영</li>
						<li>SW교육 체험실 구축 및 운영 지도</li>
						<li>정보교육 관련 연구회 운영</li>
						<li>교원컴퓨터 프로그래밍 경진대회</li>
						<li>과 소관 연구학교(연구대회) 운영 일반</li>
					</ul>
				</td>
				<td>임채환</td>
			</tr>
			<tr>
				<td>장학사</td>
				<td>이중화</td>
				<td>055-210-5137</td>
				<td class="l">
					<ul class="type02">
						<li>발명 및 영재교육 일반 및 활성화</li>
						<li>영재교육진흥위원회 운영</li>
						<li>영재교육원 및 영재학급 운영</li>
						<li>영재교육 담당교원 직무연수</li>
						<li>영재교육 교수·학습자료·보급</li>
						<li>영재교육대상자 선발 지도</li>
						<li>영재산출물발표대회 및 영재캠프 운영</li>
						<li>영재교육기관 평가 및 컨설팅</li>
						<li>발명교육센터 운영 지도</li>
					</ul>
				</td>
				<td>정인수</td>
			</tr>
						<tr>
				<td>장학사</td>
				<td>정인수</td>
				<td>055-210-5138</td>
				<td class="l">
					<ul class="type02">
						<li>수학교육 일반 및 활성화</li>
						<li>수학문화관 설립·운영 지도</li>
						<li>수학체험센터 설립·운영 지도</li>
						<li>수학교육콘텐츠 제작·보급</li>
						<li>수학체험교실 운영</li>
						<li>수학나눔학교 운영</li>
						<li>수학교사 전문성 신장(연구회, 연수)</li>
						<li>수학체험전 운영 지도</li>
						<li>경남과학수학교육네트워크 홈페이지 운영</li>
						<li>경남학생창의력페스티벌 및 창의력 관련  대회 운영</li>
					</ul>
				</td>
				<td>조용국</td>
			</tr>
			<tr>
				<td>주무관</td>
				<td>강기동</td>

				<td>055-210-5139</td>
				<td class="l">
					<ul class="type02">
						<li>교류협력국(베트남) 교육정보화 지원 사업</li>
						<li>정보화기기(교육용컴퓨터, 교단선진화기기)관리</li>
						<li>신·증설학급 교육용 및 교원용 컴퓨터보급</li>
						<li>민간참여 컴퓨터교육 운영 지도</li>
						<li>정보화 관련 통계(정보교육)</li>
						<li>각종자료 취합 지원(정보교육)</li>
						<li>예산 교부(재배정)·수당지출 지원(수학,정보)</li>
						<li>EBS 수능강의 지원 및 시청 안내</li>
						<li>성과관리</li>
						<li>물품 관리</li>
						<li>수업지원목적 저작물 이용 및 홍보</li>
					</ul>
				</td>
				<td>윤정순</td>
			</tr>
			<tr>
				<td>주무관</td>
				<td>윤정순</td>
				<td>055-210-5136</td>
				<td class="l">
					<ul class="type02">
						<li>과학실험실 폐기물 관리</li>
						<li>과학교구 관리</li>
						<li>교육공무직원 지원·관리 (과학실험원, 전산실무원, 등)</li>
						<li>각종자료 취합 지원(과학영재교육)</li>
						<li>예산 교부(재배정)·수당지출 지원(과학영재)</li>
						<li>보안 및 정보공개 업무(민원업무)</li>
						<li>기록물 관리(문서 배부)</li>
						<li>과 주간 및 월간 계획</li>
						<li>과 서무 업무</li>	
						<li>부서 운영비</li>
						<li>과학정보교육 관련 기타 외부기관 사업 홍보</li>
						<li>과학의날(우수과학교사, 우수과학어린이) 표창업무(미래부)</li>
					</ul>
				</td>
				<td>강기동</td>
			</tr>
			<tr>
				<td>주무관</td>
				<td>정연재</td>
				<td>055-210-5148</td>
				<td class="l">
					<ul class="type02">
						<li> 수학교육 국가시책사업 예산 교부(재배정)</li>
						<li> 수학 관련 각종 연수비, 연구비 예산 집행</li>
						<li> 수학교육 콘텐츠 제작 계약 및 행정 예산 집행</li>
						<li> 수학문화관·수학체험센터, 밀양수학체험마루 예산 집행 및 결산</li>
						<li> 수학교육 관련 기타 행·재정적 업무 추진</li>
						<li> 수학교육 교사, 해설사(보조해설사) 연수 업무</li>
						<li> 수학관련 자료 취합 </li>
						<li> 공문서 배부</li>
						<li> 과학정보교육담당 상장(표창)발급 </li>
						<li> 과학정보 교육담당 업무 지원</li>
					</ul>
				</td>
				<td>강기동</td>
			</tr>
		</tbody>
	</table>
</section>

<section class="buseo_juyo">
	<h3>직업교육담당 업무분장</h3>
	<table class="tbl_type01 c5">
		<caption>직업교육담당의 직위·직급, 이름, 전화번호, 담당업무를 나타내고 있습니다.</caption>
		<colgroup><col class="wps_10" /><col class="wps_10" /><col class="wps_15" /><col class="wps_30" /><col class="wps_10" /></colgroup>
		<thead>
			<tr>
			<th scope="col">직위·직급</th>
				<th scope="col">성명</th>
				<th scope="col">전화번호</th>
				<th scope="col">담당업무</th>
				<th scope="col">업무대행자</th>
			</tr>
		</thead>
		<tbody>
			<tr>
			<td>장학관</td>
			<td>김이회</td>
			<td>055-210-5141</td>
			<td class="l">
				<ul class="type02">
					<li>직업교육 기획 및 관리</li>
				</ul>
			</td>
				<td>송기호</td>
		</tr>
		<tr>
			<td>장학사</td>
			<td>송기호</td>
			<td>055-210-5142</td>
			<td class="l">
				<ul class="type02">
					<li>공업계 학교 운영 지원 </li>
					<li>직업교육 연구학교 운영</li>
					<li>산업수요 맞춤형 마이스터고 운영</li>
					<li>산학일체형 도제학교 운영</li>
					<li>특성화고 직업기초능력평가 추진</li>
					<li>경남·전국 기능경기대회 업무 추진</li>
					<li>해외인턴십 세부계획 및 업무 추진</li>
					<li>공동실습소 운영</li>
					<li>교원 산업체현장 직무연수 계획 및 운영</li>
					<li>특성화고 입시 전형</li>
					<li>일학습 병행제 운영</li>
					<li>특성화고 교원 연구대회 추진 </li>
				</ul>
			</td>
				<td>조규갑</td>
		</tr>
		<tr>
			<td>장학사</td>
			<td>조규갑</td>
			<td>055-210-5143</td>
			<td class="l">
				<ul class="type02">
					<li>취업지원센터 기획·운영 및 현장실습</li>
					<li>특성화고 실습교육 안전관리 및 연수</li>
					<li>취업처 발굴 및 MOU 체결 </li>
					<li>특성화고 입시설명회 및 홍보</li>
					<li>KB 굿잡(취업아카데미, 취업박랍회 등) 추진</li>
					<li>직업체험관 운영 및 취업선배와의 대화 운영</li>
					<li>취업역량강화사업 및 취업지원인력사업 추진</li>
					<li>산학협력 연계지원</li>
					<li>취업역량강화 연수 및 워크숍</li>
					<li>취업동아리 및 중학생 직업체험캠프 운영</li>
					<li>특성화고 중견기업CEO 및 마이스터 특강</li>
					<li>중소기업 특성화고인력양성사업</li>
					<li>HIFIVE 및 취업생 관리</li>
					<li>매력적인 직업계고 육성사업 추진</li>
				</ul>
			</td>
				<td>정선희</td>
		</tr>
		<tr>
			<td>장학사</td>
			<td>정선희</td>
			<td>055-210-5144</td>
			<td class="l">
				<ul class="type02">
					<li>상업·농업·수산·가사계 학교 운영 지원 </li>
					<li>직업교육 선진화사업  </li>
					<li>직업교육 학생비중확대사업  </li>
					<li>특성화고 학과개편 및 컨설팅   </li>
					<li>특성화고 NCS 교육과정 및 연수 추진  </li>
					<li>NCS 수업혁신 추진단 및 수업연구회 </li>
					<li>과정평가형 자격 및 직업기초능력연구학교 </li>
					<li>NCS 선도학교 운영  </li>
					<li>일반고 직업위탁 교육과정 추진 </li>
					<li>경남·전국 상업경진대회 운영 </li>
					<li>경남·전국 FFK전진대회 운영 </li>
					<li>특성화고 교원 연구대회 추진  </li>
					<li>농업계 및 해양계 실습지원  </li>
					<li>특성화고 학점은행제 운영지원 </li>
				</ul>
			</td>
				<td>최태진</td>
		</tr>

		<tr>
			<td>주무관</td>
			<td>최태진</td>
			<td>055-210-5145</td>
			<td class="l">
				<ul class="type02">
					<li>직업교육 예산 및 결산 </li>
					<li>거점특성화고, 공동실습소 예산 지원 </li>
					<li>실습관련 예산지원(시설·설비·기자재·실습비) </li>
					<li>실습기자재 관리 및 점검  </li>
					<li>산업체 우수강사 및 취업지원관 예산 지원 </li>
					<li>직업교육관련 현황 및 통계 </li>
					<li>특성화고 장학금 및 자영고 양성지원 </li>
					<li>급여 업무   </li>
					<li>청렴 관련 업무 </li>
				</ul>
			</td>
				<td>송기호</td>
		</tr>
		<tr>
			<td>취업지원센터<br />취업지원관</td>
			<td>김용중<br/>류정숙<br/>임지윤<br/>정은경</td>
			<td>055-210-5149<br/>055-210-5156<br/>055-210-5157<br/>055-210-5158</td>
			<td class="l">
				<ul class="type02">
					<li>찾아가는 실전모의 면접 강사</li>
					<li>CEO 및 마이스터 특강 지원</li>
					<li>취업지원 자료집 제작 지원</li>
					<li>취업처 발굴 및 MOU 체결 지원 </li>
					<li>각종 취업박람회 지원</li>
					<li>복교생 및 미취업자 취업 프로그램 지원</li>
					<li>취업선배와의 대회 운영 지원</li>
				</ul>
			</td>
				<td>정창민</td>
		</tr>
		
		<tr>
			<td>취업지원센터<br />전담인력</td>
			<td>강나현</td>
			<td>055-210-5147</td>
			<td class="l">
				<ul class="type02">
					<li>직업교육담당 업무 취합 및 보조</li>
					<li>취업지원센터 업무 보조(행사, 연수, 모의면접, 자료제작, 각종 홍보 등)</li>
					<li>HIFIVE 운영 및 취업생 통계 관리</li>
					<li>취업지원 인력풀 등록업무</li>
					<li>우수 취업처 DB 구축 및 관리 업무</li>
				</ul>
			</td>
				<td>조규갑</td>
		</tr>
		</tbody>
	</table>
</section>

<section class="buseo_juyo">
	<h3>도서관독서교육담당 업무분장</h3>
	<table class="tbl_type01 c5">
		<caption>도서관독서교육담당의 직위·직급, 이름, 전화번호, 담당업무를 나타내고 있습니다.</caption>
		<colgroup><col class="wps_10" /><col class="wps_10" /><col class="wps_15" /><col class="wps_30" /><col class="wps_10" /></colgroup>
		<thead>
			<tr>
				<th scope="col">직위·직급</th>
				<th scope="col">성명</th>
				<th scope="col">전화번호</th>
				<th scope="col">담당업무</th>
				<th scope="col">업무대행자</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>사무관</td>
				<td>황현경</td>
				<td>055-210-5150</td>
				<td class="l">
					<ul class="type02">
						<li>도서관독서교육 기획 및 관리</li>
					</ul>	
				</td>
				<td>강홍중</td>
			</tr>
			<tr>
				<td>장학사</td>
				<td>강홍중</td>
				<td>055-210-5151</td>
				<td class="l">
					<ul class="type02">
						<li>독서교육 기획 운영 및 활성화 </li>
						<li>책 읽는 학교 운영  </li>
						<li>인문소양교육 </li>
						<li>독서교육실천연구대회 </li>
						<li>독서교육관련 표창 </li>
						<li>e-NIE 교육 운영 </li>
						<li>독서교육연구회 및 동아리 운영 </li>
						<li>학생 책쓰기 운영</li>
					</ul>
				</td>
				<td>유경영</td>
			</tr>
			<tr>
				<td>주무관</td>
				<td>박현영</td>
				<td>055-210-5152</td>
				<td class="l">
					<ul class="type02">
						<li>공공도서관 발전계획 수립·추진</li>
						<li>공공도서관 독서문화진흥계획 수립·추진</li>
						<li>공공도서관 운영 지도 감독</li>
						<li>공공도서관 공모사업 추진</li>
						<li>도서관독서문화 관련 표창</li>
						<li>평생학습관 운영 지도</li>
						<li>경상남도교육청 북버스 운영 </li>
						<li>공공도서관 예산 및 결산</li>
						<li>공공도서관 통계자료 관리</li>
						<li>학교도서관 업무 지원</li>
					</ul>
				</td>
				<td>이재국</td>
			</tr>
			<tr>
				<td>주무관</td>
				<td>이재국</td>
				<td>055-210-5153</td>
				<td class="l">
					<ul class="type02">
					<li>도민과 함께하는 독서운동 전개</li>		
					<li>공공도서관 정보시스템 운영 지도 감독</li>		
					<li>공공도서관 홈페이지 운영 지도 감독</li>		
					<li>독서교육종합지원시스템 운영 지도 감독</li>		
					<li>공공도서관 관련 국외연수</li>		
					<li>공공도서관 담당자 연수</li>		
					<li>독서교육종합지원시스템 연수</li>		
					<li>북카페 운영 관리</li>		
					<li>인문소양교육운영 지원</li>		
					<li>공공 및 학교도서관 운영 지원</li>					
					</ul>
				</td>
				<td>박현영</td>
			</tr>
			<tr>
				<td>주무관</td>
				<td>박미해</td>
				<td>055-210-5154</td>
				<td class="l">
					<ul class="type02">
						<li>과 예산 및 결산 업무</li>
						<li>국정감사(국회자료)</li>
						<li>행정사무감사 업무</li>
						<li>도의회 업무</li>
						<li>과 여비 업무</li>
						<li>일상경비 집행</li>
 						<li>도서관독서교육담당 업무 지원</li>
					</ul>
				</td>
				<td>박현영</td>
			</tr>	
<tr>
				<td>주무관</td>
				<td>유경영</td>
				<td>055-210-5155</td>
				<td class="l">
					<ul class="type02">
						<li>학교도서관 진흥 시행계획 수립</li>
						<li>학교도서관 지도 감독</li>
						<li>학교도서관 활성화 사업</li>
						<li>학교도서관지원센터 지도 감독</li>
						<li>학교도서관발전위원회 운영</li>
						<li>학교도서관 전담사서 지원 및 관리</li>
						<li>학교도서관 담당자 연수</li>
						<li>학교도서관 관련 예산 및 결산</li>
						<li>학교도서관지원센터 관련 예산 지원</li>
						<li>학교도서관 관련 표창</li>
						<li>학교도서관 통계자료 관리</li>
						<li>공공도서관 업무 지원</li>
					</ul>
				</td>
				<td>강홍중</td>
			</tr>				  			  
		</tbody>
	</table>
</section> -->