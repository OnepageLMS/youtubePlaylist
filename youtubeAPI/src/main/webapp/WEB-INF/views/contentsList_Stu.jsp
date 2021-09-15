<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>contentsList</title>
	<meta charset="UTF-8">
	<!-- bootstrap template-->
    
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" 
    					integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    
<style>
	.contents{
		padding: 10px;
	}
	
	.content:hover{
		background-color: #F0F0F0;
	}
	
	.contentInfo{
		font-size: 13px;
		color: lightgrey;
		display: inline;
		margin: 0 3px;
	}
	
	.contentInfoBorder{
		border: 0.5px solid lightgrey;
		display: inline;
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
		
	 		for(var i=0; i<weekContents.length; i++){
				var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
				var day = weekContents[i].days;
				var date = new Date(weekContents[i].endDate.time); //timestamp -> actural time
				
				var result_date = convertTotalLength(date);
				
				var endDate = date.getFullYear() + "." + (("00"+(date.getMonth()+1).toString()).slice(-2))+ "." + (("00"+(date.getDate()).toString()).slice(-2)) + " " + (("00"+(date.getHours()).toString()).slice(-2))+ ":" + (("00"+(date.getMinutes()).toString()).slice(-2));
				
				var onclickDetail = "location.href='../contentDetail/" + weekContents[i].playlistID + "/" +weekContents[i].id + "/" +classInfo+  "'";
				
				//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');
				var content = $('.day:eq(' + day + ')');
				
				//if(i==0 || weekContents[i-1].playlistID != weekContents[i].playlistID){ //강의리스트에서는 플레이리스트의 첫번째 영상 썸네일만 보이도록
				console.log(" // " + weekContents[i].playlistID);
				content.append("<div class='content card col list-group-item' seq='" + weekContents[i].daySeq + ">"
									+ '<div class="row">'
										+ '<div class="index col-sm-1 text-center">' + (weekContents[i].daySeq+1) + '. </div>'
										+ '<div class="videoIcon col-sm-1">' + '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; color:dodgerblue;"></i>' + '</div>'
										+ "<div class='col-sm-7 row' onclick=" + onclickDetail + " style='cursor: pointer;'>"
											+ "<div class='col-sm-12'>"
												+ weekContents[i].title  + '  [' + weekContents[i].totalVideo + ']' 
											+ '</div>'
											+ '<div class="col-sm-12">'
													+ '<p class="contentInfo">' + 'Youtube' + '</p>'
													+ '<div class="contentInfoBorder"></div>'
													+ '<p class="videoLength contentInfo"">' + convertTotalLength(weekContents[i].totalVideoLength) + '</p>'
													+ '<div class="contentInfoBorder"></div>'
													+ '<p class="endDate contentInfo"">' + '마감일: ' + endDate + '</p>'
											+ '</div>' 
										+ '</div>'
									+ '</div>'
								+ '</div>');
				//}

									/*
									+ "<div class='content card col list-group-item' seq='" + weekContents[i].daySeq + "' onclick=" + onclickDetail 
										+ " style='cursor: pointer;'><ul class='list-unstyled tutorial-section-list'> <li>"
										+ '<h3 class="title"><i class="fa fa-play-circle-o" aria-hidden="true"></i>'  + " " +weekContents[i].title + ' [' + weekContents[i].totalVideo +  ']</h3>'
										+ '<p><span class = "mr-2 mb-2">'+ convertTotalLength(weekContents[i].totalVideoLength) +'</span></p>'
										+ '<p class="startDate play">' + "시작일: " + startDate + '</p>'
									 + "</li></ul></div>");*/
					
				
				//$("#weekContents").append(thumbnail +'<div> ' + weekContents[j].newTitle + '</div>');
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
	<div class="container card">
		<div class="row">
			<div class="contents col-sm-12" classID="${classInfo.id}">
				
				<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
					<div class="day card list-group list-group-flush" day="${status.index}">
						<div class="card-header">
							<h4 style="display: inline;">${j} 일 강의</h4>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<!--
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
			-->
		
</body>
</html>