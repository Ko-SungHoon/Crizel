<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
var scale = 1;
function zoomIn() {
	scale *= 1.2;
	zoom();
}

function zoomOut() {
	if((scale / 1.2) < 1){
		alert("더이상 축소할수없습니다.");
		return false;
		}
	scale /= 1.2;
	zoom();
}

function zoom() {
	document.body.style.zoom = scale;
}

$(".menubtn").on("click", function(){
    // if($(this).text()=="직업분류 닫기")
    // {
    //     $(this).text("직업분류 열기");
    // } else {
    //     $(this).text("직업분류 닫기");
    // }
    $("#dv_wrap dd").toggle();
    return false;
	});
	
</script>
<script title="스크롤시 상단으로 가기">
    // To Top - 페이지 상단으로
    jQuery(document).ready(function ($) {
        var offset = 200,
            offset_opacity = 1200,
            scroll_top_duration = 700,
            $back_to_top = $('.cd-top');

        //hide or show the "back to top" link
        $(window).scroll(function () {
            ($(this).scrollTop() > offset) ? $back_to_top.addClass('cd-is-visible') : $back_to_top.removeClass('cd-is-visible cd-fade-out');
            if ($(this).scrollTop() > offset_opacity) {
                $back_to_top.addClass('cd-fade-out');
            }
        });

        //smooth scroll to top
        $back_to_top.on('click', function (event) {
            event.preventDefault();
            $('body,html').animate({
                scrollTop: 0
            }, scroll_top_duration
            );
        });
    });
</script>

<script src="/js/printThis.js"></script>

