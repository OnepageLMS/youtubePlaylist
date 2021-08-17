<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>contentsList</title>
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
	var playlistcheck;
	var playlist;
	var total_runningtime;
	$(document).ready(function(){
		
		var allContents = JSON.parse('${allContents}');
		var weekContents = JSON.parse('${weekContents}');
		playlistcheck = JSON.parse('${playlistCheck}'); //progress bar를 위해
		playlist = JSON.parse('${playlist}'); //total 시간을 위해
		total_runningtime = 0;
		
		var classInfo = document.getElementsByClassName( 'contents' )[0].getAttribute( 'classID' );
		
		console.log("classID는 다음과 같습니다. " + classInfo);
		console.log("length : " +weekContents.length );
		var week;
		
	 		for(var i=0; i<weekContents.length; i++){
	 			console.log("youtubeID : " +weekContents[i].thumbnailID + " / playlistID : " + weekContents[i].playlistID + " week " +  weekContents[i].week + " day " +  weekContents[i].day + " / title : " + weekContents[i].title );
				var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
					week = weekContents[i].week -1 ;
				var day = weekContents[i].day - 1;
				var date = new Date(weekContents[i].startDate.time); //timestamp -> actural time
				
				var result_date = convertTotalLength(date);
				
				
				var startDate = date.getFullYear() + "." + (("00"+(date.getMonth()+1).toString()).slice(-2))+ "." + (("00"+(date.getDate()).toString()).slice(-2)) + " " + (("00"+(date.getHours()).toString()).slice(-2))+ ":" + (("00"+(date.getMinutes()).toString()).slice(-2));
				
				var onclickDetail = "location.href='../contentDetail/" + weekContents[i].playlistID + "/" +weekContents[i].id + "/" +classInfo+  "'";
				
				//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');
				var content = $('.day:eq(' + day + ')');
				//if(i>0){
					if(i==0 || weekContents[i-1].playlistID != weekContents[i].playlistID){ //강의리스트에서는 플레이리스트의 첫번째 영상 썸네일만 보이도록
					content.append("<div class='content' seq='" + weekContents[i].daySeq + "' onclick=" + onclickDetail + " style='cursor: pointer;'><ul class='list-unstyled tutorial-section-list'> <li>"
							+ '<h3 class="title"><i class="fa fa-play-circle-o" aria-hidden="true"></i>'  + " " +weekContents[i].title + ' [' + weekContents[i].totalVideo +  '] ' +'</h3></i>'
							+ '<p><span class = "mr-2 mb-2">'+ convertTotalLength(weekContents[i].totalVideoLength) +'</span></p>'
							+ '<p class="startDate play">' + "시작일: " + startDate + '</p>'
						 + "</li></ul></div>");
					}
				//}
				
				//$("#weekContents").append(thumbnail +'<div> ' + weekContents[j].newTitle + '</div>');
				//이제 클릭했을 때 해당하는 플레이리스트가 띄워지도록!
				//클릭했을 때 ajax를 통해서 playlistID를 넘겨주기 (x) -> 페이지 이동이 일어나야하는데
				//깃헙머지
			}
	 		
	 		
	 		for(var j=0; j<playlist.length; j++){
	 			total_runningtime += parseInt(playlist[j].duration);
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
	
	function toggle(e){
		var idx = $(e).attr('week');
		console.log("idx : " + idx);
		$(e).on("click", function(){
			$('.week:eq(' + (idx-1) + ')').toggle("1000", "linear");
		});
	}
	
	
</script>
<body>	
			<span class="glyphicon glyphicon-search"></span>
			<div class="contents" classID="${classInfo.id}">
				<c:forEach var="j" begin="1" end="${classInfo.days}">
					<div class="day" day="${j}">${j} 차시
						<div class = "row">
							<div class = "col-md-8"></div>
							
						</div>
					</div>
				</c:forEach>
			</div>
			
		
</body>
</html>