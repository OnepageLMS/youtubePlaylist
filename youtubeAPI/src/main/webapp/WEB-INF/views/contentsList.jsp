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
	
	.content:hover{
		background-color: #F0F0F0;
	}
	
	.contentInfo{
		font-size: 13px;
		color: lightgrey;
		display: inline;
		margin: 0 3px;
	}
	
	.addContentForm{
		padding: 10px;
		background-color: 
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

<script>
$(document).ready(function(){
	var allContents = JSON.parse('${allContents}'); //class에 해당하는 모든 contents 가져오기
	console.log(allContents);
	for(var i=0; i<allContents.length; i++){
		var day = allContents[i].day;
		var date = new Date(allContents[i].startDate.time); //timestamp -> actural time
		//var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
		var endDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();

		//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');  
		var content = $('.day:eq(' + day + ')'); //한번에 contents를 가져왔기 때문에, 각 content를 해당 주차별 차시 순서에 맞게 나타나도록 
		var onclickDetail = "location.href='../contentDetail/" + allContents[i].id + "'";
		var thumbnail = '<img src="https://img.youtube.com/vi/' + allContents[i].thumbnailID + '/0.jpg" class="inline videoPic">';

		var published;
		
		if (allContents[i].published == false)
			published = '<button onclick="CancelPublished()" class="btn btn-sm btn-outline-primary">공개</i>';
		else
			published = '<button onclick="publish()" class="btn btn-sm btn-outline-danger">비공개</i>';
				
		content.append("<div class='content card col list-group-item' seq='" + allContents[i].daySeq + "'>"
							+ '<div class="row">'
								+ '<div class="index col-sm-1 text-center">' + (allContents[i].daySeq+1) + '. </div>'
								+ '<div class="videoIcon col-sm-1">' + '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; color:dodgerblue;"></i>' + '</div>'
								+ "<div class='col-sm-7 row' onclick=" + onclickDetail + " style='cursor: pointer;'>"
									+ "<div class='col-sm-12'>"
										+ allContents[i].title  + '  [' + allContents[i].totalVideo + ']' 
									+ '</div>'
									+ '<div class="col-sm-12">'
											+ '<p class="contentInfo">' + 'Youtube' + '</p>'
											+ '<div class="contentInfoBorder"></div>'
											+ '<p class="videoLength contentInfo"">' + convertTotalLength(allContents[i].totalVideoLength) + '</p>'
											+ '<div class="contentInfoBorder"></div>'
											+ '<p class="endDate contentInfo"">' + '마감일: ' + endDate + '</p>'
									+ '</div>' 
								+ '</div>'
								+ '<div class="col-sm-2 text-center">' + published + '</div>'
								+ '<div class="contentModBtn col-sm-1 text-center">' + '<button class="btn btn-sm btn-info">more</button>' 
							+ '</div>'
						 + "</div>");

		
	}
});
	function showAddContentForm(day){
		day -= 1; //임의로 설정... 
		
		var htmlGetCurrentTime = "'javascript:getCurrentTime()'";
		var htmlAddCancel = "'javascript:addCancel()'";
		
		var addFormHtml = '<div class="addContentForm col">'
							+ '<div>'
								+ '<h5> 학습페이지 추가 </h5>'
							+ '</div>'
							+ '<form id="addContent" class="form-group" action="${pageContext.request.contextPath}/class/addContentOK" onsubmit="return checkForm(this);" method="post">' 
								+ '<input type="hidden" name="classID" value="${classInfo.id}">'
								+ '<input type="hidden" name="day" value="' + day + '"/>'
								+ '<div class="selectContent m-3">'
									+ '<p id="playlistTitle" class="d-sm-inline-block font-weight-light text-muted"> Playlist를 선택해주세요 </p>'
									+ '<button id="selectPlaylistBtn" type="button" class="d-sm-inline-block float-right btn btn-sm btn-primary" onclick="popupOpen();" style="border:none;">'
										+ '선택</button>'
									+ '<div id="playlistThumbnail" class="image-area mt-4"></div>'
								+ '</div>'
								/*
								+ '<div class="selectContent">'
									+ '<div id="selectedContent">'
										+ '<div id="playlistThumbnail"></div>'
										+ '<p id="playlistTitle"> Playlist를 선택해주세요 <p>'
									+ '</div>'
									+ '<button type="button" id="selectPlaylistBtn" onclick="popupOpen();">playlist가져오기</button>'
									+ '<input type="hidden" name="playlistID" id="inputPlaylistID">'
									//+ '<input type="hidden" name="thumbnailID" id="inputThumbnailID" value="">'
								+ '</div>'
								*/
								+ '<div class="inputTitle input-group m-3">'
									+ '<div class="input-group-prepend">'
										+ '<label for="title" class="input-group-text">제목</label>'
									+ '</div>'
									+ '<input class="form-control d-sm-inline-block" type="text" name="title">'
								+ '</div>'
								+ '<div class="inputDescription m-3">'
									+ '<textarea name="description" class="form-control" rows="10" id="comment" placeholder="이곳에 내용을 작성해 주세요."></textarea>'
								+ '</div>'
								+ '<div class="m-3">'
									+ '<div class="setEndDate input-group">'
										+ '<div class="input-group-prepend">'
											+ '<label for="endDate" class="input-group-text"> 마감일: </label>'
										+ '</div>'
										+ '<input type="hidden" name="endDate">'
										+ '<input type="date" class="form-control col-sm-8" id="endDate">'
										+ '<input type="number" class="setTime end_h form-control col-sm-2" value="0" min="0" max="23"> 시'
										+ '<input type="number" class="setTime end_m form-control col-sm-2" value="0" min="0" max="59"> 분'
									+ '</div>'
									+ '<div class="setStartDate input-group">'
										+ '<div class="input-group-prepend">'
											+ '<label for="startDate" class="input-group-text">공개일: </label>'
										+ '</div>'
										+ '<input type="hidden" name="startDate">'
										+ '<input type="date" class="form-control col-sm-8" id="startDate">'
										+ '<input type="number" class="setTime start_h form-control col-sm-2" value="0" min="0" max="23"> 시'
										+ '<input type="number" class="setTime start_m form-control col-sm-2" value="0" min="0" max="59"> 분'
										+ '<button type="button" class="btn btn-info btn-sm" onclick="location.href=' + htmlGetCurrentTime + '">지금</button>'
									+ '</div>'
								+ '</div>'
								+ '<div class="text-center m-3">'
									+ '<button class="btn btn-sm btn-warning" onclick="location.href=' + htmlAddCancel + '" >취소</button>'
									+ '<button type="submit" class="btn btn-sm btn-primary">저장</button>'
								+ '</div>'
							+ '</form>'
									

		$('.day:eq(' + day + ')').append(addFormHtml);

		//아래부분 마감일 설정때 나오도록...?
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		endDate.min = date;
		//endDate.value = date;
		startDate.min = date;
		startDate.value = date;

		//"../addContent/${classInfo.id}/${j}"
	}

	function getCurrentTime(){
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		startDate.value = date;
		
		var hour = new Date().getHours();
		var min = new Date().getMinutes();
		$('.start_h').val(hour);
		$('.start_m').val(min);
		console.log(hour, min);
	}

	function addCancel(daySeq) {
		var a = confirm("등록을 취소하시겠습니까?");
		//if (a)
			
	}

	function popupOpen(){
		if ($('#inputPlaylistID').val() >= 0){
			console.log($('#inputPlaylistID').val());
			if('이미 선택한 Playlist가 있습니다. 새로 바꾸시겠습니까?'){
			}
			else {
				return false;
			}
		}
		
		var myEmail = "yewon.lee@onepage.edu"; //이부분 나중에 로그인 구현하면 로그인한 정보 가져오기
		var url = "${pageContext.request.contextPath}/playlist/myPlaylist/" + myEmail;
		var popOption = "width=500, height=600";
		var p = window.open(url, "myPlaylist", popOption);
		p.focus();
	} 

	function checkForm(item){
		 console.log(item);
	        var date = $('#startDate').val().split("-");
	        var hour = $('.start_h').val();
	        var min = $('.start_m').val();
	        var startDate = new Date(date[0], date[1]-1, date[2], hour, min, 00);

	        if ($('#endDate').val() == null){
				alert("마감일을 설정해주세요!");
				$('#endDate').focus();
		    }

	        var e_date = $('#endDate').val().split("-");
	        var e_hour = $('.end_h').val();
	        var e_min = $('.end_m').val();
	        var endDate = new Date(e_date[0], e_date[1]-1, e_date[2], e_hour, e_min, 00);

	        if(startDate.getTime() >= endDate.getTime()) {
	            alert("컨텐츠 마감일보다 게시일이 빨라야 합니다.");
		        $('#startDate').focus();
	            return false;
	        }

	        if ($('input[name=title]').val() == null){
				alert("제목을 입력해주세요!");
				$('input[name=title]').focus();
				return false;
		    }
		        
	        else{
				$('input[name=endDate]').val(endDate);
				$('input[name=startDate]').val(startDate);
		    }
	}

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
				<button onclick="#" class="btn btn-primary">강의추가</button>
				
				<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
					<div class="day card list-group list-group-flush" day="${status.index}">
						<div class="card-header">
							<h4 style="display: inline;">${j} 일 강의</h4>
							<button onclick='showAddContentForm(${status.index})' class="btn btn-sm btn-success float-right">+페이지추가</button>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
		
	</div>
	
</body>
</html>