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
	
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/11.0.2/css/bootstrap-slider.css" integrity="sha512-SZgE3m1he0aEF3tIxxnz/3mXu/u/wlMNxQSnE0Cni9j/O8Gs+TjM9tm1NX34nRQ7GiLwUEzwuE3Wv2FLz2667w==" crossorigin="anonymous" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-slider/11.0.2/bootstrap-slider.min.js" integrity="sha512-f0VlzJbcEB6KiW8ZVtL+5HWPDyW1+nJEjguZ5IVnSQkvZbwBt2RfCBY0CBO1PsMAqxxrG4Di6TfsCPP3ZRwKpA==" crossorigin="anonymous"></script>
	
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

		var key = "AIzaSyC0hiwYHhlDC98F1v9ERNXnziHown0nGjg"; //AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c
		var accessToken = "${accessToken}";
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

	
	// 카트에 영상 담기 할 시에 player 새로고침 되는거 방지하는 코드인데, 작동이 안됨. (21/09/05) 
	$(".searchedVideo fas").click(function(e){
		e.stopPropagation();
	});

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
					'<div class="searchedVideo" onclick="viewVideo(\'' + id.toString()
							+ '\'' + ',\'' + title + '\''
							+ ',\'' + durationCount[i] + '\'' + ',' + i + ');">'
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
	$( function() {
		$( "#slider-range" ).slider({
			range: true,
			min: 0,
			max: 500,
			values: [ 75, 300 ],
			slide: function( event, ui ) {
				$( "#amount" ).val( "시작: " + ui.values[ 0 ] + " - 끝: " + ui.values[ 1 ] );
			}
		});
		$( "#amount" ).val( "시작: " + $( "#slider-range" ).slider( "values", 0 ) + " - 끝: " + $( "#slider-range" ).slider( "values", 1 ) );
	} );
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

		// 이전 index 존재 유무 확인
		var prev_index=null;

		//아래는 youtube-API 공식 문서에서 iframe 사용방법으로 나온 코드.
		tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

		

		function viewVideo(id, title, duration, index) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			//$('.videos').css({'fontWeight' : 'normal'});
			//$('input:checkbox').prop("checked", false); //youtube 검색결과에서 비디오 선택하면 playlist 체크된것 다 초기화 
			//$('.submitBtn').html('추가');

			
			console.log(id, title, duration, index);
			
			// 클릭한 영상 밑에 player 띄우기
			var $div = $('<div id="playerBox" class="text-center list-group-item-success" style="margin: auto;"> <div id="player"></div> </div>'); 
			$div.append('<div class="p-1 m-1 bg-white text-dark" style="width: 700px;">'+ $("#get_view").children().eq(index).children().eq(2).html() + '</div>');
			$div.append('<div id="player_info"></div>');

			// 영상 구간 설정 (jw 아래에서 코드 가져와서 적용되게 함 )
			$div.append($('#setVideoInfo').html());
			$div.append('<div> <i class="fas fa-plus-square" onclick="addToCart(\''+id+ '\'' + ',\'' +title+'\')"> 리스트에 추가 </i></div>');

				var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
				var regex_result = regex.exec(duration); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S
				var hours = parseInt(regex_result[1] || 0);
				var minutes = parseInt(regex_result[2] || 0);
				var seconds = parseInt(regex_result[3] || 0);
	
				/* if(seconds != "00") {
					seconds = parseInt(seconds) - 1;  // 어떤건 1초 적게 나올 수 있음 이게 영상 마다 정의된 총 길이시간이 1초가 더해지기도 안더해지기도 해서 . 
				}	  */
				console.log("check hours here", duration);
				console.log("check hours here", hours);
	
				$('#end_hh').val(hours);
				$("#end_mm").val(minutes);
				$("#end_ss").val(seconds);
	
				var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;
	
				// for validty check: 이제 sliderbar로 만들거라 상관없음...
				limit = parseInt(total_seconds);
				//document.getElementById("maxLength").value = limit;
	
				//이미 다른 영상이 player로 띄워져 있을 때 새로운 id로 띄우기
				//player.loadVideoById(videoId, 0, "large");
	
				document.getElementById("start_hh").value = 0;
				document.getElementById("start_mm").value = 0;
				document.getElementById("start_ss").value = 0;
			
			if(prev_index != null){
				//$("#get_view").children().eq(prev_index).children().eq(0).text() = ""; 
				/* $("#get_view").children().eq(prev_index).children().eq(1).text() = "";
				$("#get_view").children().eq(prev_index).children().eq(2).text() = ""; */

				/* $('#player_info').remove();
				$('#player').remove();
				$('.fa-plus-square').remove(); */
				$('#playerBox').remove();
				
			    //$("#get_view").children().eq(prev_index).attr('style', 'display: block');
			    //$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: none');
			}
			//console.log($("#get_view").children().eq(index).children().eq(2).html());
			
			$("#get_view").children().eq(index).after($div);

			showYoutubePlayer(id, title, index);	

			prev_index = index;		

		}		

		function showYoutubePlayer(id, title, index){
			//$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동

			videoId = id;
			videoTitle = title;

			if(prev_index != null){
				$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: inline-block');
				$("#get_view").children().eq(prev_index).children().eq(1).attr('style', 'display: inline-block');
				$("#get_view").children().eq(prev_index).children().eq(2).attr('style', 'display: inline-block');
				
				console.log("check eq(1) ==> ", $("#get_view").children().eq(prev_index).children().eq(1));
				//$("#get_view").children().eq(prev_index).children().eq(1).attr('style', 'display: inline-block');
			}
			$("#get_view").children().eq(index).children().eq(0).attr('style', 'display: none');
			$("#get_view").children().eq(index).children().eq(1).attr('style', 'display: none');
			$("#get_view").children().eq(index).children().eq(2).attr('style', 'display: none');

			console.log("check videoTitle here", videoTitle);
			
			document.getElementById("player_info").innerHTML = '<p class="m-0"> <span style="font-weight: bold"> 제목: </span> <textarea id="newName" class="videoTitle bg-white p-1" style="border: 1px solid black" name="newName" cols="80" rows="1">' + videoTitle + '</textarea></p>';

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
				height : '360',
				width : '640',
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

		function resizeRightCard(){
			$('#rightCard').css('height', '800px');
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
		function getCurrentPlayTime1() {
			var d = Number(player.getCurrentTime());
			var h = Math.floor(d / 3600);
			var m = Math.floor(d % 3600 / 60);
			var s = d % 3600 % 60;

			document.getElementById("start_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("start_hh").value = h;/* .toFixed(2); */
			document.getElementById("start_mm").value = m;/* .toFixed(2); */
			document.getElementById("start_s").value = parseFloat(d).toFixed(2);
			start_time = parseFloat(d).toFixed(2);
			start_time *= 1.00;
			//console.log("check:", typeof start_time);
		}
		function getCurrentPlayTime2() {
			var d = Number(player.getCurrentTime());
			var h = Math.floor(d / 3600);
			var m = Math.floor(d % 3600 / 60);
			var s = d % 3600 % 60;

			document.getElementById("end_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("end_hh").value = h;/* .toFixed(2); */
			document.getElementById("end_mm").value = m;/* .toFixed(2); */
			document.getElementById("end_s").value = parseFloat(d).toFixed(2);
			end_time = parseFloat(d).toFixed(2);
			end_time *= 1.00;
			//console.log("check", typeof end_time);
		}

		// 재생 구간 유효성 검사: 
		function validation() { //video 추가 form 제출하면 실행되는 함수
			document.getElementById("warning1").innerHTML = "";
			document.getElementById("warning2").innerHTML = "";
			
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss* 1.00;
			
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();

			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			
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

		  	console.log("check hhmmss ==>" , hhmmss);
			//console.log(limit);
			//console.log(end_time - start_time);
			$('#duration').val(end_time - start_time);

			if (start_time > end_time) {
				document.getElementById("warning1").innerHTML = "start time cannot exceed end time";
				document.getElementById("start_ss").focus();
				return false;
			}
			if (end_time > limit) {
				//console.log(end_time,"  ", limit);
				document.getElementById("warning2").innerHTML = "Please insert again";
				document.getElementById("end_ss").focus();
				return false;
			} else {
				/* if ($('#inputVideoID').val() > -1)
					return updateVideo(event); */
					
				// 우측 카트에 hidden tag로 start_s, end_s 넣기 
				/* $('#start_s').val(start_time);
				$('#end_s').val(end_time); */

				$('#start_s').attr("value", start_time);
				/* $('#running_time').append('<span>' + hhmmss + '</span>'); */
				//document.getElementById('running_time').innerHTML += hhmmss; 

				//$('#running_time').html("duration: "+ hhmmss);
				//document.getElementById('running_time').innerHTML = "duration: " + hhmmss; 

				// 아직 카트 element가 생성되기 전이라서 이렇게 변수에 저장해놓은 뒤에 사용할 수 밖에 없음. 
				running_time = hhmmss;

				return true;
			}
		}

		function addToCart(id, title){
			console.log(id, title);
			var thumbnail2 = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg" class="img-fluid">';
			if (title.length > 40) {
				title = title.substring(0,40) + " ...";
			}

			if(!validation()){
				return;
			};

			//1. 
			//var content = thumbnail2 + title;
			//$("#videosInCart").append(content);

			//2.
			if( $('#start_hh').is(':empty') ) {
				var start_time =  $('#start_mm').val() + ":" + $('#start_ss').val();
				var end_time = $('#end_mm').val() + ":" + $('#end_ss').val();
			}
			else {
				var start_time = $('#start_hh').val() + ":" + $('#start_mm').val() + ":" + $('#start_ss').val();
				var end_time = $('#end_hh').val() + ":" + $('#end_mm').val() + ":" + $('#end_ss').val();
			}
				
			var html = '<div class="videoSeq">' 
				+ '<div class="row" videoID="' + id + '" videoTitle="' + title + '">' 
				+ '<div class="custom-control checkbox col-lg-1"> <input type="checkbox" class="custom-control-input" id="selectToSave"></div>'
				+ '<div class="col-lg-4">' + thumbnail2 + '</div>'
				+ '<div class="col-lg-7">'
				+ '<div id="title" style="font-weight: bold;">' + title + '</div>'
				+ '<div id="start_s" style="display:inline"> start ' + start_time + '   </div>'
				+ '<div id="end_s" style="display:inline""> end ' + end_time + '</div>' 
				+ '<div id="duration_s" style="display: none"> duration:' + $('#duration').val() + '</div>'
				+ '<div id="running_time" style="display:inline" > duration ' + running_time + '</div>'
				+ '</div> </div>'; 

			//3. var html = $('#setVideosInCart').html();
			$("#videosInCart").append(html); 


			/* <input type="hidden" name="youtubeID" id="inputYoutubeID"> 
			<input type="hidden" name="start_s" id="start_s"> 
			<input type="hidden" name="end_s" id="end_s"> 
			<input type="hidden" name="title" id="inputYoutubeTitle">
			<input type="hidden" name="maxLength" id="maxLength"> 
			<input type="hidden" name="duration" id="duration"> */
			
			/* <div id="setVideosInCart" style="display: block;">
				<div class="row" videoID="" videoTitle="">
					<div class="col-lg-1">
						<input type="checkbox">
					</div>
					<div class="col-lg-5">
						<img>
					</div>
					<div class="col-lg-6">
						<div class="row-fluid">
							<div class="start"></div>
							<div class="end"></div>
						</div>
					</div>
				</div>
			</div>
			 */
			
		}
				
	</script>
	<div
		class="app-container app-theme-white body-tabs-shadow closed-sidebar">
		<jsp:include page="outer_top.jsp" flush="false" />

		<div class="app-main">
			<jsp:include page="outer_left.jsp" flush="true" />

			<div class="app-main__outer">
				<div class="app-main__inner">
					<h4 id="playlistName" style="display: inline-block">- Youtube
						영상 추가</h4>
					<div class="row">
						<div class="selectedPlaylist col-lg-8 card">
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
											<button onclick="fnGetList(); resizeRightCard()"
												class="btn btn-primary btn-lg">검색</button>
										</form>
									</div>
								</div>

							</div>
							<div class="card-body">

								<div>
									<form action="playlist/player" id="form2" method="post"
										style="display: none">
										<input type="hidden" name="playerId" id="playerId"> <input
											type="hidden" name="playerTitle" id="playerTitle"> <input
											type="hidden" name="playerDuration" id="playerDuration">
									</form>
								</div>

								<div id="get_view"></div>

								<div class="container">
									<div class="row">
										<div id="nav_view"></div>
									</div>
								</div>
							</div>

							<!-- </div> -->
						</div>

						<div class="col-lg-4">
							<div class="main-card card sticky-top" id="rightCard">
								<div class="card-header">선택된 비디오 리스트</div>
								<div class="card-body">
									<div class="scroll-area-sm">
										<div id="videosInCart"
											class="scrollbar-container ps--active-y ps"></div>
									</div>
								</div>
							</div>
						</div>

						<div id="setVideoInfo" style="display: none;">
							<input type="hidden" name="duration" id="duration">
							
							<div class="setTimeRange col row input-group">
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
							</div>
							
							<div>
								<button onclick="getCurrentPlayTime1()" type="button">start time</button>
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
							</div> 


							<div style="">
								<span style="font-weight: bold"> 태그: </span><input type="text"
									id="tag" name="tag">
							</div>
						</div>

					</div>

				</div>
				<jsp:include page="outer_bottom.jsp" flush="false" />
			</div>
		</div>
	</div>

</body>
</html>