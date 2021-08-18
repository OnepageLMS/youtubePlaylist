<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page import="java.text.*"%>

<!DOCTYPE html>
<html>
<head>
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
	

	<title>contentsList</title>
<style> 
	.contents{
		padding: 10px;
	}
	
	.content{
		margin: 3px;
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

<script>
$(document).ready(function(){
	var allContents = JSON.parse('${allContents}'); //class에 해당하는 모든 contents 가져오기
	console.log(allContents);

	for(var i=0; i<allContents.length; i++){
		console.log(allContents[i]);
		var day = allContents[i].day - 1;
		var date = new Date(allContents[i].startDate.time); //timestamp -> actural time
		//var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
		var endDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();

		//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');  
		var content = $('.day:eq(' + day + ')'); //한번에 contents를 가져왔기 때문에, 각 content를 해당 주차별 차시 순서에 맞게 나타나도록 
		var onclickDetail = "location.href='../contentDetail/" + allContents[i].id + "'";
		var thumbnail = '<img src="https://img.youtube.com/vi/' + allContents[i].thumbnailID + '/0.jpg" class="inline videoPic">';

		var published;
		
		if (allContents[i].published == true)
			published = '<p class="published badge badge-primary">' + "공개: " + allContents[i].published + '</p>';
		else
			published = '<p class="published badge badge-danger">' + "공개: " + allContents[i].published + '</p>';
				
		content.append("<div class='content row card' seq='" + allContents[i].daySeq + "' onclick=" + onclickDetail + " style='cursor: pointer;'>"
							+ '<div class="index col-sm-1">' + (i+1) + '. </div>'
							+ '<div class="videoIcon col-sm-1">' + '<i class="fa fa-play-circle-o" aria-hidden="true"></i>' + '</div>'
							+ '<div class="col-sm-7 row">'
								+ '<div class="col-sm-12">' 
									+ allContents[i].title  + '  [' + allContents[i].totalVideo + ']' 
								+ '</div>'
								+ '<div class="col-sm-12">'
									+ '<p>' + 'Youtube' + '</p>'
									+ '<p class="videoLength">' + convertTotalLength(allContents[i].totalVideoLength) + '</p>'
									+ '<p class="endDate">' + '마감일: ' + endDate + '</p>'
								+ '</div>' 
							+ '</div>'
							+ '<div class="col-sm-2">' + published + '</div>'
							+ '<div class="contentModBtn col-sm-1">' + '<button class="btn btn-sm">more</button>' 
						 + "</div>");

		
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
	<div class="container card col-sm-8">
		<div class="row">
			<div class="contents col-sm-12" classID="${classInfo.id}">
				<button onclick="" class="btn btn-primary">강의추가</button>
				
				<c:forEach var="j" begin="1" end="${classInfo.days}">
					<div class="day card" day="${j}">
						<h3 class="card-header">${j} 일 강의</h3>
						<a href="../addContent/${classInfo.id}/${j}">+페이지추가</a>
					</div>
				</c:forEach>
			</div>
		</div>
		
	</div>
	
</body>
</html>