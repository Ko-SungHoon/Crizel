/* AJAX연동******************************************************************************** */
$(function() {
	$("#call").click(function() {
		var id = document.getElementById("id").value;
		var pw = document.getElementById("pw").value;
		var str = {
			"id" : id,
			"pw" : pw
		};
		
		alert("TEST");

		$.ajax({
			type : "POST",
			url : "/login.do",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			data : str,
			datatype : "json",
			success : function(data) {
				alert("성공");
			},
			error : function(e) {
				alert("에러발생");
			}
		});
	});
});




/*
 * 모달연동(body에 직접 넣어야 실행이 되지만 일단 여기에도 넣어둠)
 * ********************************************************************************
 */
// Get the modal
var modal = document.getElementById('myModal');

// Get the button that opens the modal
var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

$("#myBtn").click(function(){
	modal.style.display = "block";
});
$("#myModal").click(function(){
	modal.style.display = "block";
});
// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}