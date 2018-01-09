<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
.mySlides {display:none}

/* Slideshow container */
.slideshow-container {
  max-width: 1000px;
  position: relative;
  margin: auto;
}

/* Next & previous buttons */
.prev, .next , .play, .pause{
  cursor: pointer;
  position: absolute;
  top: 50%;
  width: auto;
  padding: 16px;
  margin-top: -22px;
  color: white;
  font-weight: bold;
  font-size: 18px;
  transition: 0.6s ease;
  border-radius: 0 3px 3px 0;
}

/* Position the "next button" to the right */
.next {
  right: 0;
  border-radius: 3px 0 0 3px;
}
.prev:hover, .next:hover {
  background-color: rgba(0,0,0,0.8);
}

/* Caption text */
.text {
  color: #f2f2f2;
  font-size: 15px;
  padding: 8px 12px;
  position: absolute;
  bottom: 8px;
  width: 100%;
  text-align: center;
}

/* Number text (1/3 etc) */
.numbertext {
  color: #f2f2f2;
  font-size: 12px;
  padding: 8px 12px;
  position: absolute;
  top: 0;
}

/* On smaller screens, decrease text size */
@media only screen and (max-width: 300px) {
  .prev, .next,.text {font-size: 11px}
}

.titleBtn{
	display: block;
	text-decoration: none;
	line-height: 100px;
	color:black;
	font-weight: bold;
}
</style>
</head>
<body>

<div class="slideshow-container" style="width: 80%; float: left;">

	<div class="mySlides fade">
	  <img src="https://www.w3schools.com/howto/img_nature_wide.jpg" style="width:100%">
	</div>
	
	<div class="mySlides fade">
	  <img src="https://www.w3schools.com/howto/img_fjords_wide.jpg" style="width:100%">
	</div>
	
	<div class="mySlides fade">
	  <img src="https://www.w3schools.com/howto/img_mountains_wide.jpg" style="width:100%">
	</div>
	
	<a class="prev" onclick="plusSlides(-1)">&#10094; </a>
	<!-- <a class="play">&#9654;</a>
	<a class="pause">&#10074;&#10074;</a> -->
	<a class="next" onclick="plusSlides(1)">&#10095;</a>  
</div>
<div style="float: left;">
	<ul style="list-style: none; margin: 0; padding: 0; text-align: center;">
		<li style="height: 100px; width: 300px;">
			<a class="titleBtn" id="currentSlide1" href="http://sports.news.naver.com/wfootball/index.nhn">1번 사이트 & 이미지</a>
		</li>
		<li style="height: 100px; width: 300px;">
			<a class="titleBtn" id="currentSlide2" href="http://bbs.ruliweb.com/family/211/board/300015">2번 사이트 & 이미지</a>  
		</li>
		<li style="height: 100px; width: 300px;">
			<a class="titleBtn" id="currentSlide3" href="http://www.dogdrip.net/">3번 사이트 & 이미지</a>
		</li>
	</ul>
</div>

<script>
$(".titleBtn").hover(function(){
	$(this).css("background", "grey");
	$(this).css("color", "white");
	
	if($(this).attr("id")=="currentSlide1"){
		currentSlide(1);
	}else if($(this).attr("id")=="currentSlide2"){
		currentSlide(2);
	}else if($(this).attr("id")=="currentSlide3"){
		currentSlide(3);
	}
},
function(){
	$(this).css("background", "white");
	$(this).css("color", "black");
});

var slideIndex = 1;
showSlides(slideIndex);
showSlides2();

function plusSlides(n) {
	showSlides(slideIndex += n);
}
	
function currentSlide(n) {
  showSlides(slideIndex = n);
}

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  if (n > slides.length) {slideIndex = 1}    
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";  
  }
  slides[slideIndex-1].style.display = "block";  
}
function showSlides2() {
    var i;
    var slides = document.getElementsByClassName("mySlides");
    for (i = 0; i < slides.length; i++) {
       slides[i].style.display = "none";  
    }
    slideIndex++;
    if (slideIndex> slides.length) {slideIndex = 1}    
    slides[slideIndex-1].style.display = "block";  
    setTimeout(showSlides2, 5000); 
}

</script>

</body>
</html> 
