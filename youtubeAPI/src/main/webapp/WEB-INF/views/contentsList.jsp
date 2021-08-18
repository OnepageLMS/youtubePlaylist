<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page import="java.text.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
<!-- bootstrap -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/fonts/icomoon/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/fonts/brand/style.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/jquery.fancybox.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/aos.css">

    <!-- MAIN CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsList/css/style.css">
    
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>

	<title>contentsList</title>
<style>
	.contents{
		padding: 10px;
	}
	
	.week{
		border: 2px solid lightslategrey;
		padding: 5px;
		margin: 5px;
		width: 50%;
	}
	
	.content{
		border: 1px solid lightslategrey;
		margin: 3px;
		padding-left: 5px;
	}
	
	.videoPic {
		width: 120px;
		height: 70px;
		padding: 5px;
		display: inline;
	}
	
	.title {
		font-size: 16px;
	}
	
	a{
		text-decoration: none;
	}
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script>
$(document).ready(function(){
	var allContents = JSON.parse('${allContents}'); //class에 해당하는 모든 contents 가져오기
	console.log(allContents);

	for(var i=0; i<allContents.length; i++){
		console.log(allContents[i]);
		var day = allContents[i].day - 1;
		var date = new Date(allContents[i].startDate.time); //timestamp -> actural time
		var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();

		//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');  
		var content = $('.day:eq(' + day + ')'); //한번에 contents를 가져왔기 때문에, 각 content를 해당 주차별 차시 순서에 맞게 나타나도록 
		var onclickDetail = "location.href='../contentDetail/" + allContents[i].id + "'";
		var thumbnail = '<img src="https://img.youtube.com/vi/' + allContents[i].thumbnailID + '/0.jpg" class="inline videoPic">';
		
		if(allContents[i].published == true){
			content.append("<div class='content' seq='" + allContents[i].daySeq + "' onclick=" + onclickDetail + " style='cursor: pointer;'>"
					+ '<ul class="list-unstyled tutorial-section-list"><li>'
					+ '<h3 class="title"><i class="fa fa-play-circle-o" aria-hidden="true"></i>'  
					+ allContents[i].title  + '  [' + allContents[i].totalVideo + ']</h3>'
					+ '<p><span class="mr-2 mb-2">' +  convertTotalLength(allContents[i].totalVideoLength) + '</span></p>'
					+ '<p class="published badge badge-primary">' + "공개: " + allContents[i].published + '</p>'
					+ '<p class="startDate">' + "시작일: " + startDate + '</p>'
				 	+ "</li></ul></div>");
		}
		else{
			content.append("<div class='content' seq='" + allContents[i].daySeq + "' onclick=" + onclickDetail + " style='cursor: pointer;'>"
					+ '<ul class="list-unstyled tutorial-section-list"><li>'
					+ '<h3 class="title"><i class="fa fa-play-circle-o" aria-hidden="true"></i>'  
					+ allContents[i].title  + '  [' + allContents[i].totalVideo + ']</h3>'
					+ '<p><span class="mr-2 mb-2">' +  convertTotalLength(allContents[i].totalVideoLength) + '</span></p>'
				 	+ '<p class="published badge badge-danger">' + "공개: " + allContents[i].published + '</p>'
				 	+ '<p class="startDate">' + "시작일: " + startDate + '</p>'
				 	+ "</li></ul></div>");
		}
	}
});

	function convertTotalLength(seconds){
		var seconds_hh = Math.floor(seconds / 3600);
		var seconds_mm = Math.floor(seconds % 3600 / 60);
		var seconds_ss = Math.floor(seconds % 3600 % 60);
		var result = "";
		
		if (seconds_hh > 0)
			result = ("00"+seconds_hh .toString()).slice(-2)+ ":";
		result += ("00"+seconds_mm.toString()).slice(-2) + ":" + ("00"+seconds_ss .toString()).slice(-2) ;
		
		return result;
	}
	
	function deleteCheck(classID, id){
		var a = confirm("정말 삭제하시겠습니까?");
		if (a)
			location.href = '../deleteContent/' + classID + "/" + id;
	}
	

</script>
<body>
	
	<div class="contents" classID="${classInfo.id}">
		<button onclick="">강의추가</button>
		<c:forEach var="j" begin="1" end="${classInfo.days}">
			<div class="day" day="${j}">
				<h3>${j} 일 강의</h3>
				<a href="../addContent/${classInfo.id}/${j}">+페이지추가</a>
			</div>
		</c:forEach>

	</div>
</body>
</html>