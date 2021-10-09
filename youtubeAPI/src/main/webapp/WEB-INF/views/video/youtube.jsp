<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Content-Language" content="en">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Youtube 영상 추가</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
	<meta name="description" content="This is an example dashboard created using build-in elements and components.">
	<meta name="msapplication-tap-highlight" content="no">
	<!--
	    =========================================================
	    * ArchitectUI HTML Theme Dashboard - v1.0.0
	    =========================================================
	    * Product Page: https://dashboardpack.com
	    * Copyright 2019 DashboardPack (https://dashboardpack.com)
	    * Licensed under MIT (https://github.com/DashboardPack/architectui-html-theme-free/blob/master/LICENSE)
	    =========================================================
	    * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	    -->
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="/resources/demos/style.css">
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	
	<!-- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"> -->

<style>
.video {
	padding: 7px;
}
.info {
	font-size: 12px;
}
img {
	width: 128px;
	height: 80px;
	padding: 5px;
}
.playlistSeq {
	background-color: #cecece;
	padding: 10px;
	margin: 5px;
}
.container {
	margin-left: 15px !important;
}
.container-fluid {
	margin: 7px;
	width: 500px;
	float: right;
}
/* 이동 타켓 */
.card-placeholder {
	border: 1px dashed grey;
	margin: 0 1em 1em 0;
	height: 50px;
	margin-left: auto;
	margin-right: auto;
	background-color: #E8E8E8;
}
/* 마우스 포인터을 손가락으로 변경 */
.card:not(.no-move) .card-header {
	cursor: pointer;
}
.card {
	border-radius: 5px;
}
.searchedVideo a:hover{
	background: ligthgray;
	cursor:pointer
}
</style>

</head>
<script>
var email;
$(document).ready(function(){
	email = "yewon.lee@onepage.edu";	//로그인 정보 가져오는걸로 수정하기 !
	
	// 좌측 사이드 바 어떻게 할건지 알고 작업하기 (jw: 2021/09/14)
	
	//getAllMyPlaylist(email); //나중에는 사용자 로그인정보로 email 가져와야할듯..
	
	//var allMyClass = JSON.parse('${allMyClass}');
	/* for(var i=0; i<allMyClass.length; i++){
		var name = allMyClass[i].className;
		var classContentURL = '${pageContext.request.contextPath}/class/contentList/' + allMyClass[i].id;
		var html = '<li>'
						+ '<a href="#">'
							+ '<i class="metismenu-icon pe-7s-notebook"></i>'
							+ name
							+ ' <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>'
						+ '</a>'
						+ '<ul>'
							+ '<li>'
								+ '<a href="#">'
									+ '<i class="metismenu-icon"></i>'
									+ '공지'
								+ '</a>'
							+ '</li>'
							+ '<li>'
								+ '<a href="' + classContentURL + '">'
									+ '<i class="metismenu-icon"></i>'
									+ '학습 컨텐츠'
								+ '</a>'
							+ '</li>'
							+ '<li>'
								+ '<a href="#">'
									+ '<i class="metismenu-icon"></i>'
									+ '성적'
								+ '</a>'
							+ '</li>'
						+ '</ul>'
					+ '</li>';
				
		$('.sideClassList').append(html);
	} */
	// Playlist 이름 보여지게 하기
	//console.log(JSON.stringify(localStorage.getItem("selectedPlaylist")));
	console.log(localStorage.getItem("selectedPlaylistName"));
	$("#playlistName").before('<h4 style="color: blue; display:inline-block">' + localStorage.getItem("selectedPlaylistName") + '</h4>');	
});
</script>

<script>
	var maxResults = "20";
	var idList = [ maxResults ]; //youtube Search 결과 저장 array
	var titleList = [ maxResults ];
	var dateList = [ maxResults ];
	var viewCount = [ maxResults ];
	var likeCount = [ maxResults ];
	var dislikeCount = [ maxResults ];
	var durationCount = [ maxResults ];
	var count = 0;
	function fnGetList(sGetToken) { // youtube api로 검색결과 가져오기 
		count = 0;
		var $getval = $("#search_box").val();
		var $getorder = $("#opt").val();
		if ($getval == "") {
			alert("검색어를 입력하세요.");
			$("#search_box").focus();
			return;
		}
		$("#get_view").empty();
		$("#nav_view").empty();
		var key = "AIzaSyC0hiwYHhlDC98F1v9ERNXnziHown0nGjg"; //"AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c"; //
		//var accessToken = "${accessToken}";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ $getorder
				+ "&q="
				+ encodeURIComponent($getval) //encoding
				+ "&key=" + key
				//+ "&access_token="
				//+ accessToken
				+ "&maxResults="
				+ maxResults
				+ "&type=video";
		if (sGetToken != null) { //이전 or 다음페이지 이동할때 해당 페이지 token
			sTargetUrl += "&pageToken=" + sGetToken + "";
		}
		$.ajax({
					type : "POST",
					url : sTargetUrl, //youtube-search api 
					dataType : "jsonp",
					async : false,
					success : function(jdata) {
						if (jdata.error) { //api 할당량 끝났을 때 에러메세지
							$("#nav_view").append(
									'<p>검색 일일 한도가 초과되었습니다 나중에 다시 시도해주세요!</p>');
						}
						//console.log(jdata);
						$(jdata.items)
								.each(
								function(i) {
									setAPIResultToList(i, this.id.videoId,
											this.snippet.title,
											this.snippet.publishedAt);
								})
								.promise()
								.done($(jdata.items).each(
									function(i) {
										var id = idList[i];
										var getVideo = "https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails&id="
												+ id
												+ "&key=" + key;
												//+ "&access_token="
												//+ accessToken;
	
										$.ajax({
													type : "GET",
													url : getVideo, //youtube-videos api
													dataType : "jsonp",
													success : function(jdata2) {
														//console.log(jdata2);
														setAPIResultDetails(
																i,
																jdata2.items[0].statistics.viewCount,
																jdata2.items[0].statistics.likeCount,
																jdata2.items[0].statistics.dislikeCount,
																jdata2.items[0].contentDetails.duration);
													},
													error : function(xhr, textStatus) {
														console.log(xhr.responseText);
														alert("video detail 에러");
														return;
													}
	
												})
									}));
						if (jdata.prevPageToken) {
							lastAndNext(jdata.prevPageToken, " <-이전 ");
						}
						if (jdata.nextPageToken) {
							lastAndNext(jdata.nextPageToken, " 다음-> ");
						}
					},
					error : function(xhr, textStatus) {
						console.log(xhr.responseText);
						alert("an error occured for searching");
						return;
					}
				});
	}
	
	/* // 카트에 영상 담기 할 시에 player 새로고침 되는거 방지하는 코드인데, 작동이 안됨. (21/09/05) 
	이제 이 코드 없애도 될듯. (jw 21/09/26)
	$(".searchedVideo fas").click(function(e){
		e.stopPropagation();
	}); */
	function viewPlayer(){
		$('.playerForm').css({display: "block"});
		
	}
	
	
	function displayResultList() { //페이지별로 video 정보가 다 가져와지면 이 함수를 통해 결과 list 출력
		for (var i = 0; i < maxResults; i++) {
			var id = idList[i];
			var view = viewCount[i];
			var title = titleList[i].replace("'", "\\'").replace("\"","\\\"");
			
			var thumbnail = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg">';
			//var url = '<a href="https://youtu.be/' + id + '">';
			var link = "'${pageContext.request.contextPath}/player";
			link = link + "?id=" + id.toString();
			link = link + "?title=" + title;
			link = link + "?duration=" + durationCount[i] + "'";
			$("#get_view").append(					
					/* '<div class="searchedVideo" onclick="$(#form2).submit();">' */
					'<div class="searchedVideo mb-2" onclick="changeCardSize(); viewPlayer(); viewVideo2(\'' + id.toString()
							+ '\'' + ',\'' + title + '\''
							+ ',\'' + durationCount[i] + '\'' + ',' + i + '); setSlider();;">'
							+ thumbnail
							+ '<span>' + title + '</span>'
							+ '<div>'
							+ '<span class="info m-0"> published: <b>' + dateList[i]
							+ '</b> view: <b>' + view
							+ '</b> like: <b>' + likeCount[i]
							+ '</b> dislike: <b>' + dislikeCount[i]
							+ '</b> </span>'
							+ '</div></div>');
							/* + '<div style="display:none">'
							+ '<div id="player_info"></div>'
							+ '<div id="player"></div>' 
							+ '</div> </div>'); */
			<!-- <div id="player_info"></div> -->
			<!-- <div id="player"></div> -->
		}
	}
	function lastAndNext(token, direction) { // 검색결과 이전/다음 페이지 이동
		$("#nav_view").append(
				'<a href="javascript:fnGetList(\'' + token + '\');"> '
						+ direction + ' </a>');
	}
	function setAPIResultToList(i, id, title, date) { // search api사용할 때 데이터 저장
		idList[i] = id;
		titleList[i] = title.replace("'", "\\'").replace("\"","\\\""); // 싱글따옴표나 슬래시 들어갼것 따로 처리해줘야함!
		console.log(titleList[i]);
		dateList[i] = date.substring(0, 10);
	}
	function setAPIResultDetails(i, view, like, dislike, duration) { // videos api 사용할 때 디테일 데이터 저장 
		viewCount[i] = convertNotation(view);
		likeCount[i] = convertNotation(like);
		dislikeCount[i] = convertNotation(dislike);
		durationCount[i] = duration;
		count += 1;
		if (count == 20) displayResultList();
	}
	function convertNotation(value) { //조회수 등 단위 변환
		var num = parseInt(value);
		if (num >= 1000000)
			return (parseInt(num / 1000000) + "m");
		else if (num >= 1000)
			return (parseInt(num / 1000) + "k");
		else if (value === undefined)
			return 0;
		else
			return value;
	}
	function moveToMyPlaylist(){
		var myEmail = "yewon.lee@onepage.edu"; //이부분 로그인 구현한뒤 현재 로그인한 사용자 정보로 바꾸기 !!
		location.href = '${pageContext.request.contextPath}/playlist/myPlaylist/' + myEmail;
	}

	
</script>

<script>	//시작, 끝 시간 설정 bar
	var start_hour, start_min, start_sec, end_hour, end_min, end_sec;
	
	$( function() {
		$( "#slider-range" ).slider({
			range: true,
			min: 0,
			max: 500,
			/* values: [ 75, 300 ], */
			slide: function( event, ui ) {
				//$( "#amount" ).val( "시작: " + ui.values[ 0 ] + " - 끝: " + ui.values[ 1 ] );

				start_hour = Math.floor(ui.values[ 0 ] / 3600);
			    start_min = Math.floor(ui.values[ 0 ] % 3600 / 60);
			    start_sec = ui.values[ 0 ] % 60;

			    end_hour = Math.floor(ui.values[ 1 ] / 3600);
			    end_min = Math.floor(ui.values[ 1 ] % 3600 / 60);
			    end_sec = ui.values[ 1 ] % 60;

			    $( "#amount" ).val( "시작: " + start_hour + "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
			}
		}); 
		//$( "#amount" ).val( "시작: " + $( "#slider-range" ).slider( "values", 0 ) + " - 끝: " + $( "#slider-range" ).slider( "values", 1 ) );
	    
	} );

	function setSlider() {
		console.log("limit값 확인 !! ", limit);
		/* $("#slider-range").slider("destroy"); */
		/*var attributes = {
			max: limit
		}
		// update attributes
		$element.attr(attributes);

		// pass updated attributes to rangeslider.js
		$element.rangeslider('update', true); */
		$('#slider-range').slider( "option", "min", 0);
		$('#slider-range').slider( "option", "max", limit);

		$( "#slider-range" ).slider( "option", "values", [ 0, limit ] );
		//$( "#amount" ).val( "시작: " + 0 + " - 끝: " + limit );
		
		start_hour= start_min = start_sec = 0;

	    end_hour = Math.floor(limit / 3600);
	    end_min = Math.floor(limit % 3600 / 60);
	    end_sec = limit % 60;

		
		$( "#amount" ).val( "시작: " +start_hour+ "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
	}
</script>

<body>
	<!-- Youtube video player -->
	<script>
		// 각 video를 클릭했을 때 함수 parameter로 넘어오는 정보들
		var videoId;
		var videoTitle;
		var videoDuration;
		// player api 사용 변수 
		var tag;
		var firstScriptTag;
		var player;
		// (jw) 구간 설정: 유효성 검사시 필요 
		var limit;
		var start_s;
		var end_s;
		var youtubeID;
		var values; // slider handles 
		var d; // var for current playtime

		// 카트 
		var hhmmss; // 카트에서 보여지 시간 
		
		// 이전 index 존재 유무 확인
		var prev_index=null;
	
		//아래는 youtube-API 공식 문서에서 iframe 사용방법으로 나온 코드.
		tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

		//var $element = $('#slider-range');
		
		function viewVideo2(id, title, duration, index) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			console.log(id, title, duration, index);

			// (21/10/06) youtube 플레이어 띄워주고, 제목을 띄워준다. 이 부분은 <div> 태그로 감싸져서 초록색이 나타나게 되는데 영상구간 설정 부분까지 태그로 감싸지게 해야 전체가 초록색 배경이 될듯. 
			var $div = $('<div id="playerBox" class="text-center" style="margin: auto;"> <div class="iframe-container" id="player"></div></div>'
					+ '<form class>'
						+ '<div id="player_info">' 
							+ '<div class="position-relative row form-group">'
							+ '<div class="col-sm-1"> 제목 </div>'
							+ '<div class="col-sm-11"> <input name="newName" id="newName" type="text" class="col-sm-11 form-control" value="'+ title +'"></div>'
						+ '</div>'
						+ '<div id="setVideoInfo"> <input type="hidden" name="duration" id="duration">'
							+ '<div id="delete" >'
								+ '<div class="setTimeRange input-group">'
									+ '<div class="col-md-2 input-group-prepend">'
										+ '<button class="btn btn-outline-secondary" onclick="getCurrentPlayTime(this)">시작</button>'
									+ '</div>'
									+ '<div class="col-md-8"> </div>'
									+ '<div class="col-md-2 input-group-append">' 
										+ '<button class="btn btn-outline-secondary" onclick="getCurrentPlayTime(this)">끝</button>'
									+ '</div>' 
								+ '</div>'
								+ '<div class="position-relative row form-group">'
									+ '<div class="col-sm-2 col-form-label d-flex justify-content-center">'
										+ '<label for="amount"><b>설정된 시간</b></label>'
									+ '</div>' 
									+ '<div class="col-sm-6"> <input type="text" id="amount" class="form-control" readonly style="border:0;"> </div>'
									+ '<div class="col-sm-3"> <div id="warning1"> </div> </div>' 
								+ '</div>' 
							+ '</div>'
							+ '<div> <span style="font-weight: bold"> 태그: </span> <input type="text" id="tag" name="tag"> </div>' 
						+ '</div>'
						+ '<div> <i class="fas fa-plus-square" onclick="addToCart(\''+id+ '\'' + ',\'' +title+'\')"> 리스트에 추가 </i></div>' 
					+'</form>'); 		
					
					

			/*
			<div id="setVideoInfo">
							<input type="hidden" name="duration" id="duration">
							
							<!-- <div class="setTimeRange col row input-group">
									<div class="col-2 input-group-prepend">
										<button class="btn btn-outline-secondary">시작</button>
									</div>
									<div class="col-8">
										<div id="slider-range"></div>
									</div>
									<div class="col-2 input-group-append">
										<button class="btn btn-outline-secondary">끝</button>
									</div>
									<div class="col">
										<label for="amount"><b>설정된 시간</b></label>
										<input type="text" id="amount" readonly style="border:0;">
									</div> 
							</div> -->
							
							<div id="delete" >
                               <div class="setTimeRange input-group">
									<div class="col-md-2 input-group-prepend">
										<button class="btn btn-outline-secondary" onclick="getCurrentPlayTime(this)">시작</button>
									</div>
									<div class="col-md-8">
										<div id="slider-range"></div>
									</div>
									<div class="col-md-2 input-group-append">
										<button class="btn btn-outline-secondary" onclick="getCurrentPlayTime(this)">끝</button>
									</div>
								</div>
									<div class="position-relative row form-group">
									 	<div class="col-sm-2 col-form-label d-flex justify-content-center">
											<label for="amount"><b>설정된 시간</b></label>
										</div>
										<div class="col-sm-6">
											<input type="text" id="amount" class="form-control" readonly style="border:0;">
										</div>
										<div class="col-sm-3">
											<div id="warning1"> </div>
										</div>
									</div>
									
                            </div>
                                            
							<!-- <div>
								<button onclick="getCurrentPlayTime1(this)" type="button">start time</button>
								: <input type="text" id="start_hh" maxlength="2" size="2">
								시 <input type="text" id="start_mm" maxlength="2" size="2">
								분 <input type="text" id="start_ss" maxlength="5" size="5">
								초
								<button onclick="seekTo1()" type="button">위치이동</button>
								<span id=warning1 style="color: red;"></span> <br>
							</div> 

							<div>
								<button onclick="getCurrentPlayTime2()" type="button">end time</button>
								: <input type="text" id="end_hh" max="" maxlength="2" size="2">
								시 <input type="text" id="end_mm" max="" maxlength="2" size="2">
								분 <input type="text" id="end_ss" maxlength="5" size="5">
								초
								<button onclick="seekTo2()" type="button">위치이동</button>
								<span id=warning2 style="color: red;"></span> <br>
							</div>  -->


							<div>
								<span style="font-weight: bold"> 태그: </span><input type="text"
									id="tag" name="tag">
							</div>
							
							<div> <i class="fas fa-plus-square" onclick="addToCart(\''+videoId+ '\'' + ',\'' +videoTitle+'\')"> 리스트에 추가 </i></div>
						</div>
			
			*/
				var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
				var regex_result = regex.exec(duration); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S

				// 영상 총길이 계산 
				// (jw) 만약 Uncaught TypeError: Cannot read properties of null (reading '1') 에러가 뜨면 해당 영상이 실시간 라이브여서 그런거임. 
				var hours = parseInt(regex_result[1] || 0);
				var minutes = parseInt(regex_result[2] || 0);
				var seconds = parseInt(regex_result[3] || 0);

				// 슬라이더 완료되면 지울것 
				$('#end_hh').val(hours);
				$("#end_mm").val(minutes);
				$("#end_ss").val(seconds);
	
				var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;
	
				// (21/10/06) 영상 총길 계산 + slider에서 validity check 을 위해 
				limit = parseInt(total_seconds);
	
				//이미 다른 영상이 player로 띄워져 있을 때 새로운 id로 띄우기
				//player.loadVideoById(videoId, 0, "large");
				
				//(//지워도 되려나..?)
				/* document.getElementById("start_hh").value = 0;
				document.getElementById("start_mm").value = 0;
				document.getElementById("start_ss").value = 0; */
			
			if(prev_index != null){
				$('#playerBox').remove();
				
			    //$("#get_view").children().eq(prev_index).attr('style', 'display: block');
			    //$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: none');
			}
			//console.log($("#get_view").children().eq(index).children().eq(2).html());
			
			// 클릭한 영상 밑에 player 띄우기
			//$("#get_view").children().eq(index).after($div);
			
			// 오른쪽 카드 안에 player 띄우기
			console.log("player폼 확인!!=> " , $(".playerForm").children().eq(0));
			$(".playerForm").children().eq(0).append($div);
			
			showYoutubePlayer(id, title, index);	
			prev_index = index;		
		}
		function showYoutubePlayer(id, title, index){
			//$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동
			videoId = id;
			videoTitle = title;
			if(prev_index != null){
				/* $("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: inline-block');
				$("#get_view").children().eq(prev_index).children().eq(1).attr('style', 'display: inline-block');
				$("#get_view").children().eq(prev_index).children().eq(2).attr('style', 'display: inline-block'); */
				
				$("#get_view").children().eq(prev_index).css("background-color", "white");
				
				console.log("check eq(1) ==> ", $("#get_view").children().eq(prev_index).children().eq(1));
				//$("#get_view").children().eq(prev_index).children().eq(1).attr('style', 'display: inline-block');
			}
			
			/* $("#get_view").children().eq(index).children().eq(0).attr('style', 'display: none');
			$("#get_view").children().eq(index).children().eq(1).attr('style', 'display: none');
			$("#get_view").children().eq(index).children().eq(2).attr('style', 'display: none'); */

			$("#get_view").children().eq(index).css("background-color", "lightgray");
			
			console.log("check videoTitle here", videoTitle);

			
					
			/* <span class="videoTitle bg-white p-1" style="border: 1px solid black"> </span>
			<div>
				<textarea id="newName" name="newName" cols="62" rows="2"> </textarea>
			</div> */
			onYouTubeIframeAPIReady();
			
		}
		// 3. This function creates an <iframe> (and YouTube player)
		//    after the API code downloads. 
		function onYouTubeIframeAPIReady() {
			player = new YT.Player('player', {
				videoId : videoId,
				playerVars: {
					origin: 'https://localhost:8080'
				}, 
				events : {
					'onReady' : onPlayerReady,
					'onStateChange' : onPlayerStateChange
				}
			});
		}
		// 4. The API will call this function when the video player is ready.
		function onPlayerReady() { 
			//player.playVideo();
			
			if(youtubeID == null){
				player.playVideo();
			}
			// 플레이리스트에서 영상 선택시 player가 바로 뜰 수 있도록 함. 
			else { 
				player.loadVideoById({
					'videoId': youtubeID, 
					'startSeconds': start_s, 
					'endSeconds':end_s 
				});
			}
		}
		// (jw) player가 끝시간을 넘지 못하게 만들기 : 일단 임의로 시작 시간으로 되돌리기 했는데, 하영이거에서 마지막 재생 위치에서 부터 다시 재생되게 하면 될듯. 
		function onPlayerStateChange(state) {
		    if (player.getCurrentTime() >= end_s) {
			   player.pauseVideo();
			   //player.seekTo(start_s);
			   player.loadVideoById({
					'videoId': youtubeID, 
					'startSeconds': start_s, 
					'endSeconds':end_s
				});
		    }
		  }
		function selectVideoForm(id, title, duration){
			console.log("check here!!", id);
			
			document.getElementById('playerId').value = id;
			document.getElementById('playerTitle').value = title;
			document.getElementById('playerDuration').value = duration;
			/* $(#videoId).val(id);
			$(#videoTitle).val(title);
			$(#videoDuration).val(duration); */
			
			var playerForm = document.getElementById('form2');
			playerForm.submit();
		}
		// (jw) 여기서 부터 구간 설정 자바스크립트 
		// Youtube player 특정 위치로 재생 위치 이동 : 
		function seekTo1() {
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss
					* 1.00;
			player.seekTo(start_time);
		}
		function seekTo2() {
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val(); 
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			player.seekTo(end_time);
		}
		// 현재 재생위치를 시작,끝 시간에 지정 
		function getCurrentPlayTime(obj) {
			/* var d = Number(player.getCurrentTime());
			d = parseFloat(d).toFixed(2); */

			// Getter for slider handles 
			/* var values = $( "#slider-range" ).slider( "option", "values" );
			
			console.log(values[0]);
			console.log("check here!" , d); */

			values = $( "#slider-range" ).slider( "option", "values" );
			console.log("check initial values =>> ", values[0], values[1]);
			
			if(!validation()){
				return;
			}
			var h = Math.floor(d / 3600);
			var m = Math.floor(d % 3600 / 60);
			var s = parseFloat(d % 3600 % 60).toFixed(2);


			// 시작 버튼 클릭시: 
			if($(obj).text() == "시작"){
				
				
				// Setter 
				$( "#slider-range" ).slider( "option", "values", [ d, values[1] ] );
				start_hour = h;
				start_min = m;
				start_sec = s;

				$( "#amount" ).val( "시작: " + h + "시" + m  + "분" + s + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
				
				start_time = parseFloat(d).toFixed(2);
				start_time *= 1.00;
			}
			
			// 끝 버튼 클릭시: 
			else{

				// Setter 
				$( "#slider-range" ).slider( "option", "values", [ values[0], d ] );
				end_hour = h;
				end_min = m;
				end_sec = s;
				
				$( "#amount" ).val( "시작: " + start_hour + "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + h + "시" + m  + "분" + s + "초"  );

				end_time = parseFloat(d).toFixed(2);
				end_time *= 1.00;
			}

			

			/* document.getElementById("start_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("start_hh").value = h;/* .toFixed(2);
			document.getElementById("start_mm").value = m; .toFixed(2); */

			//(jw) start_s, end_s는 addToCart에서 사용되는것 가튼데 잠시 커멘트 처리 (21/10/04)
			//document.getElementById("start_s").value = parseFloat(d).toFixed(2);
			//start_time = parseFloat(d).toFixed(2);
			//start_time *= 1.00;
			//console.log("check:", typeof start_time);
		}

		// 코드 하나로 합침. 나중에 지워도 됨. (21/10/06)
		function getCurrentPlayTime2() {
			var d = Number(player.getCurrentTime());
			var h = Math.floor(d / 3600);
			var m = Math.floor(d % 3600 / 60);
			var s = d % 3600 % 60;

			// slider 구현 완료시 지우기 
			document.getElementById("end_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("end_hh").value = h;/* .toFixed(2); */
			document.getElementById("end_mm").value = m;/* .toFixed(2); */
			//document.getElementById("end_s").value = parseFloat(d).toFixed(2);
			end_time = parseFloat(d).toFixed(2);
			end_time *= 1.00;
			//console.log("check", typeof end_time);
		}
		
		// 재생 구간 유효성 검사: 
		function validation() { //video 추가 form 제출하면 실행되는 함수
			/* document.getElementById("warning1").innerHTML = "";
			document.getElementById("warning2").innerHTML = ""; */
			
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			/* var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss* 1.00;
			
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00; */

			document.getElementById("warning1").innerHTML = "";
			/* $('#warning1').text("");
			$('#warning2').text(""); */

			d = Number(player.getCurrentTime());
			d = parseFloat(d).toFixed(2);

			// Getter for slider handles 
			values = $( "#slider-range" ).slider( "option", "values" );

			if(d>values[1]){
				document.getElementById("warning1").innerHTML = "시작시간은 끝시간보다 크지 않아야 합니다.";
				//document.getElementById("start_ss").focus();
				return false;
			}
			if(d<values[0]){
				console.log(d+"는 "+values[0]+"보다 작다.. ㅋㅋㅋ 왜 이렇게 나오는데");
				console.log(d, " vs ", values[0]);
				document.getElementById("warning1").innerHTML = "끝시간은 시작시간보다 크게 설정해주세요.";
				return false;
			}

			// running time 구하기 * (다시 하기 ==> 21/10/07)
			start_time = start_hour*3600.00 + start_min*60.00 + start_sec*1.00;
			end_time = end_hour*3600.00 + end_min*60.00 + end_sec*1.00;
			
			const totalSeconds = end_time - start_time;
			const hours = Math.floor(totalSeconds / 3600);
		    const minutes = Math.floor(totalSeconds % 3600 / 60);
		    const seconds = totalSeconds % 60;

		    if(hours!=0){
		    	hhmmss = hours + ':' + minutes + ':' + seconds;
		    }
		    else {
		    	hhmmss = minutes + ':' + seconds;
		    }

		  	console.log("check hhmmss ==>" , hhmmss); // *
		  	
		  	
			//console.log(limit);
			//console.log(end_time - start_time);
			$('#duration').val(totalSeconds);


			// 아래 코드는 없애도 될듯. 
			/* if (start_time > end_time) {
				document.getElementById("warning1").innerHTML = "start time cannot exceed end time";
				//document.getElementById("start_ss").focus();
				return false;
			}
			
			if (end_time > limit) {
				//console.log(end_time,"  ", limit);
				document.getElementById("warning2").innerHTML = "Please insert again";
				//document.getElementById("end_ss").focus();
				return false;
			}  */

			return true;
			
		}
		function addToCart(id, title){
			console.log(id, title);
			var thumbnail2 = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg" class="img-fluid">';
			if (title.length > 40) {
				title = title.substring(0,40) + " ...";
			}
			/* if(!validation()){
				return;
			}; */
			
			//1. 
			//var content = thumbnail2 + title;
			//$("#videosInCart").append(content);
			//2.
	
				//document.getElementById('running_time').innerHTML += hhmmss; 
				//$('#running_time').html("duration: "+ hhmmss);
				//document.getElementById('running_time').innerHTML = "duration: " + hhmmss; 
				// 아직 카트 element가 생성되기 전이라서 이렇게 변수에 저장해놓은 뒤에 사용할 수 밖에 없음. 
				
				//running_time = hhmmss;
			
			var cart_start_time;
			var cart_end_time;

			// 시작, 끝시간을 정할떄 validation을 통과했으면 start_
			
			if( $('#start_hh').is(':empty') ) {
				cart_start_time =  $('#start_mm').val() + ":" + $('#start_ss').val();
				cart_end_time = $('#end_mm').val() + ":" + $('#end_ss').val();
			}
			else {
				cart_start_time = $('#start_hh').val() + ":" + $('#start_mm').val() + ":" + $('#start_ss').val();
				cart_end_time = $('#end_hh').val() + ":" + $('#end_mm').val() + ":" + $('#end_ss').val();
			}
				
			var html = '<div class="videoSeq">' 
				+ '<div class="row" videoID="' + id + '" videoTitle="' + title + '">' 
				+ '<div class="form-check col-lg-1"> <input type="checkbox" id="selectToSave" name="chk"></div>'
				+ '<div class="col-lg-4">' + thumbnail2 + '</div>'
				+ '<div class="col-lg-7">'
				+ '<div id="title" style="font-weight: bold;">' + title + '</div>'
				+ '<div id="start_s" style="display:inline" value="'+cart_start_time+'"> start ' + cart_start_time + '   </div>'
				+ '<div id="end_s" style="display:inline" value="'+cart_end_time+'"> end ' + cart_end_time + '</div>' 
				+ '<div id="duration_s" style="display: none"> duration:' + $('#duration').val() + '</div>'
				+ '<div id="running_time" style="display:inline" value="'+hhmmss+'"> duration ' + hhmmss + '</div>'
				+ '</div> </div>'; 
			//3. var html = $('#setVideosInCart').html();
			$("#videosInCart").append(html); 				
				
		}
		function deleteFromCart(){

			$('input:checkbox:checked').each(function(i){
				console.log($(this).parent().closest('.videoSeq').remove());
			});
			// 전체 선택 체크 해제 
			$("input:checkbox[id='checkAll']").prop("checked", false); /* by ID */ 
			
		}
		function selectAll(selectAll) {
			const checkboxes = document.querySelectorAll('input[type="checkbox"]');
			
			// selectAll 버튼이 눌린 순간, 다른 체크박스들도 다 모두 선택체크 박스와 같은 값을 가지도록 만든다.(on/off);  
			checkboxes.forEach((checkbox) => {
				checkbox.checked = selectAll.checked;
			})
		}
		function changeCardSize(){
			$("#searchArea").children().eq(0).attr('class', 'selectedPlaylist col-lg-6 card');
		}

		// 오른쪽 sidebar 닫기 버튼 클릭시 (jw) 
		function closeSidebar(){
			$('.ui-theme-settings').attr('class', 'ui-theme-settings');
		}
		
	</script>
	<div
		class="app-container app-theme-white body-tabs-shadow closed-sidebar">
		<jsp:include page="../outer_top.jsp" flush="false" />
		
		<!-- (jw ) -->
		<div class="ui-theme-settings">
            <button type="button" id="TooltipDemo" class="btn-open-options btn btn-warning">
                <i class="fa fa-cart-plus fa-w-16 fa-lg"></i>
            </button>
            <div class="theme-settings__inner">
                <div class="scrollbar-container ps ps--active-y">
                    <div class="theme-settings__options-wrapper">
                        <h3 class="themeoptions-heading"> 선택된 비디오 플레이리스트 
	                        <button type="button" class="close ml-auto " aria-label="Close" onclick="closeSidebar();">
			                    <span aria-hidden="true">×</span>
			                </button>
                        </h3>
                      
                        <div id="videosInCart"
											class="scrollbar-container ps--active-y ps"></div>
                    </div>
                <div class="ps__rail-x" style="left: 0px; bottom: 0px;"><div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div></div><div class="ps__rail-y" style="top: 0px; height: 446px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 151px;"></div></div></div>
            </div>
        </div>

		<div class="app-main">
			<jsp:include page="../outer_left.jsp" flush="true" />

			<div class="app-main__outer">
				<div class="app-main__inner">
					<button class="btn row" onclick="history.back();"> 
                    			<i class="pe-7s-left-arrow h3 col-12"></i>
                    			<p class="col-12 m-0" style="font-size:12px; text-align: center;">이전</p>
                 		</button>
					<h4 id="playlistName" style="display: inline-block">- Youtube 영상 추가</h4>
					<div class="row" id="searchArea">
						<div class="selectedPlaylist col-lg-12 card">
							<!-- <div class="card-header"> -->
							<div class="card-title playlistName m-3">

								<div class="row">
									<div class="col-lg-12 ">
										<form class="form-inline" name="form1" method="post"
											onsubmit="return false;">
											<select name="opt" id="opt"
												class="mr-2 dropdown-toggle btn btn-primary btn-lg">
												<option value="relevance">관련순</option>
												<option value="date">날짜순</option>
												<option value="viewCount">조회순</option>
												<option value="title">문자순</option>
												<option value="rating">평가순</option>
											</select> <input type="text" id="search_box"
												class="form-control col-lg-8 mr-2">
											<button onclick="fnGetList();"
												class="btn btn-primary btn-lg">검색</button>
										</form>
									</div>
								</div>

							</div>
							<div class="card-body" style="overflow-y:auto; height:750px;">

								<div>
									<form action="playlist/player" id="form2" method="post"
										style="display: none">
										<input type="hidden" name="playerId" id="playerId"> <input
											type="hidden" name="playerTitle" id="playerTitle"> <input
											type="hidden" name="playerDuration" id="playerDuration">
									</form>
								</div>

								<div id="get_view" style="cursor:pointer"></div>

								<div class="container">
									<div class="row">
										<div id="nav_view"></div>
									</div>
								</div>
							</div> 
						</div>

						<!-- <div class="playerForm col-lg-6" style="display:none;">
							<div class="main-card card sticky-top" id="rightCard">
								<div class="card-title m-0"> 
									<h6 style="font-weight: bold; margin: 10px 20px;"> 선택된 비디오 리스트 </h6>
									<input type="checkbox" style="margin-left: 20px;" id="checkAll" onclick="selectAll(this)"> <label class="form-check-label"> 전체 선택 </label>  
									<button onclick='deleteFromCart()' class="mr-2 btn-transition btn btn-danger float-right" style="float-right;">선택 항목 삭제</button>
								</div>
								<div class="card-footer">
									<div style="overflow: auto; height: 700px;">
										<div id="videosInCart"
											class="scrollbar-container ps--active-y ps"></div>
									</div>
								</div>
							</div>
						</div> -->
						
						
						
						<div class="playerForm col-lg-6 form-class" style="display:none;">
							<div class="main-card card" id="rightCard">
								<!-- form 추가(jw) -->
								
								
								
							</div>
							<div id="slider-range"></div> 
						</div>

						

					</div>

				</div>
				<jsp:include page="../outer_bottom.jsp" flush="false" />
			</div>
		</div>
	</div>

</body>
</html>