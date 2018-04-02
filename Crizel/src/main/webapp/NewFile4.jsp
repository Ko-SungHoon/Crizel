<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %><%@ include file="/include/config.jsp" %>
		<jsp:include page="/${siteDetail.site_url}/quick.jsp" />
	</section>
	<footer id="footer">
		<jsp:include page="/${siteDetail.site_url}/foot_menu.jsp" />
		<div class="footWrap">
			<jsp:include page="/${siteDetail.site_url}/user_foot_menu.jsp">
				<jsp:param name="mid" value="${es:SearchXSS(param.mid)}" />
			</jsp:include>
		</div>
	</footer>
</div>
<c:choose>
	<c:when test="${fn:length(es:SearchXSS(param.mid)) == 12}">
<script>
	try { initNavigation('<c:out value="${fn:substring(es:SearchXSS(param.mid), 2, 4)}" />'); } catch (e) { }	// 메인메뉴 활성화
	try { initLeftMenuLI('<c:out value="${fn:substring(es:SearchXSS(param.mid), 2, 6)}" />', '<c:out value="${fn:substring(es:SearchXSS(param.mid), 2, 8)}" />'); } catch (e) { }	// 서브메뉴 활성화
	try { init4DepthMenu('<c:out value="${fn:substring(es:SearchXSS(param.mid), 2, 10)}" />'); } catch (e) { }
	try { init5DepthMenu('<c:out value="${fn:substring(es:SearchXSS(param.mid), 2, 12)}" />'); } catch (e) { }
</script>
	</c:when>
	<c:otherwise>
<script>//try { initNavigation(1, 0); } catch (e) { }</script>
<jsp:include page="/popupCheck.es?sid=${siteDetail.sid}" />
<jsp:include page="/hotissueCheck.es" />
	</c:otherwise>
</c:choose>

<script type="text/javascript">
<!--
$(function(){
	$("#left_menu_top > li").each(function(){
		if($(this).find('ul > li').length > 0) {
			$(this).addClass('has_submenu');
		}
	});
});
//-->
</script>

<%--
<div style="display: none;">
dupInfo : <%=session.getAttribute("dupInfo") %><br/>
di : <%=session.getAttribute("di") %><br/>

dupInfo-2 : <%=request.getParameter("dupInfo") %><br/>
di-2 : <%=request.getParameter("di") %><br/>

sessionStrName : <%=session.getAttribute("strName") %><br/>
child_name : <%=session.getAttribute("child_name") %><br/>
</div>
--%>

</body>
</html>
