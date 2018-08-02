<form id="webLogout" name="webLogout" action="<%= request.getContextPath() %>/j_spring_security_logout?returnUrl=/" method="get">
</form>

<script>
var webLogout = document.webLogout;
webLogout.submit();
</script>