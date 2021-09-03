<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* body {
	padding: 10px;
} */
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
.playlistSeq{
	background-color: #cecece;
	padding: 10px;
	margin: 5px;
}
.container {
	margin-left: 15px!important;
}
.container-fluid{
	margin : 7px;
	width: 500px;
	float: right;
}
/* 이동 타켓 */
.card-placeholder {
	border: 1px dashed grey;
	margin: 0 1em 1em 0;
	height: 50px;
	margin-left:auto;
	margin-right:auto;
	background-color: #E8E8E8;
}
/* 마우스 포인터을 손가락으로 변경 */
.card:not(.no-move) .card-header{
	cursor: pointer;
}
.card{
	border-radius: 5px;
}
.card-header{
	border-bottom: 1px solid;
	margin: 0px -10px;
	padding: 5px 10px;
	padding-top: 0px;
}
.card-body{
	font-size: 13.5px;
}
/* playlist 구간 끝 */

</style>
</head>
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>
	
<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<!-- <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<%
    request.setCharacterEncoding("UTF-8");
%>
<!-- 아래 script는 youtube-search, video API 사용해서 video 검색결과 가져오기. 변경할 때 예원에게 말해주세요!!! -->
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

	function displayResultList() { //페이지별로 video 정보가 다 가져와지면 이 함수를 통해 결과 list 출력
		for (var i = 0; i < maxResults; i++) {
			var id = idList[i];
			var view = viewCount[i];
			var title = titleList[i].replace("'", "\\'").replace("\"","\\\"");
			console.log("display: " + title);
			
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
							+ titleList[i]
							+ '<p class="info"> publised: <b>' + dateList[i]
							+ '</b> view: <b>' + view
							+ '</b> like: <b>' + likeCount[i]
							+ '</b> dislike: <b>' + dislikeCount[i]
							+ '</b> </p>'
							+ '</div>');
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
<!-- <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>	
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  
<body>

	<%-- <div class="nav">
		<button onclick="moveToMyPlaylist();">내 컨텐츠</button>
		<button onclick="#">영상추가</button>
		<button onclick="location.href='${pageContext.request.contextPath}/playlist/searchLms'">LMS내 컨텐츠</button>
	</div> --%>
	
	<ul class="nav nav-tabs" role="tablist">
		<li class="nav-item">
	      <a class="nav-link" href="#" onclick="moveToMyPlaylist();">내 컨텐츠</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link active" href="#">Youtube영상추가</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link" href='${pageContext.request.contextPath}/playlist/searchLms'>LMS 내 컨텐츠</a>
	    </li>
	</ul>
	
	<div class="container">
		<div class="row">
		
		
	<form name="form1" method="post" onsubmit="return false;">
		<select name="opt" id="opt">
			<option value="relevance">관련순</option>
			<option value="date">날짜순</option>
			<option value="viewCount">조회순</option>
			<option value="title">문자순</option>
			<option value="rating">평가순</option>
		</select> <input type="text" id="search_box">
		<button onclick="fnGetList();">검색</button>
	</form>

	<!-- <div id="player_info"></div> -->
	<!-- <div id="player"></div> -->
	
	<div>
		<form action="playlist/player" id="form2" method="post" style="display: none">
			<input type="hidden" name="playerId" id="playerId">
			<input type="hidden" name="playerTitle" id="playerTitle">
			<input type="hidden" name="playerDuration" id="playerDuration">
		</form>
	</div>

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
		var prev_index;

		function viewVideo(id, title, duration, index) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			$('.videos').css({'fontWeight' : 'normal'});
			//$('input:checkbox').prop("checked", false); //youtube 검색결과에서 비디오 선택하면 playlist 체크된것 다 초기화 
			$('.submitBtn').html('추가');
			//document.getElementById("inputVideoID").value = -1; //updateVideo()가 아닌 createVideo()가 실행되도록 초기화!
			
			// 클릭한 영상 밑에 player 띄우기
			/* if(prev_index != null){
				
			}
			console.log(index); */

			<!-- <div id="player_info"></div> -->
			<!-- <div id="player"></div> -->

			// 클릭한 영상 밑에 player 띄우기
			var $div = $('<div id="player_info"></div> <br> <div id="player"></div>');
			
			if(prev_index != null){
				//$("#get_view").children().eq(prev_index).children().eq(0).text() = ""; 
				/* $("#get_view").children().eq(prev_index).children().eq(1).text() = "";
				$("#get_view").children().eq(prev_index).children().eq(2).text() = ""; */

				$('#player_info').remove();
				$('#player').remove();
				
			    //$("#get_view").children().eq(prev_index).attr('style', 'display: block');
			    //$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: none');
			}
			
			$("#get_view").children().eq(index).append($div);
			
			//$("#get_view").children().eq(index).attr('style', 'display: block');
			//$("#get_view").children().eq(index).children().eq(0).attr('style', 'display: block');
				
			
			//$("#get_view")[i].append('<div id="player_info"></div><br><div id="player"></div>');
			
			//이게 맞는건가 모르겠네..:
			//$("#get_view").children().eq(index).append('<div id="player_info"></div><br><div id="player"></div>');
			
			//document.getElementById(item).innerHTML = "<div id='player_info'></div><br><div id='player'></div>";
				
			showYoutubePlayer(id, title, index);	

			prev_index = index;		

			//console.log("check duration", duration); // 직접찍어본 결과 희한하게 영상에 따라 총 영상 길이가 보통 1초가 다 긴데, 어떤건 정확하게 영상 길이만큼 나온다. 

			/*
					var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
					var regex_result = regex.exec(duration); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S
					var hours = parseInt(regex_result[1] || 0);
					var minutes = parseInt(regex_result[2] || 0);
					var seconds = parseInt(regex_result[3] || 0);
		
					/* if(seconds != "00") {
						seconds = parseInt(seconds) - 1;  // 어떤건 1초 적게 나올 수 있음 이게 영상 마다 정의된 총 길이시간이 1초가 더해지기도 안더해지기도 해서 . 
					}	  
		
					document.getElementById("end_hh").value = hours;
					document.getElementById("end_mm").value = minutes;
					document.getElementById("end_ss").value = seconds;
		
					var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;
		
					// for validty check: 
					limit = parseInt(total_seconds);
					document.getElementById("maxLength").value = limit;
		
					// 클릭한 영상의 videoId form에다가 지정. 
					document.getElementById("inputYoutubeID").value = id;
					document.getElementById("inputYoutubeTitle").value = videoTitle;
		
					//이미 다른 영상이 player로 띄워져 있을 때 새로운 id로 띄우기
					//player.loadVideoById(videoId, 0, "large");
		
					document.getElementById("start_hh").value = 0;
					document.getElementById("start_mm").value = 0;
					document.getElementById("start_ss").value = 0;
			*/
		}

		function showYoutubePlayer(id, title, index){
			//$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동

			videoId = id;
			videoTitle = title;

			if(prev_index != null){
				$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: inline-block');
			}
			$("#get_view").children().eq(index).children().eq(0).attr('style', 'display: none');
			
			document.getElementById("player_info").innerHTML = '<h3 class="videoTitle">' + videoTitle + '</h3>';

			//아래는 youtube-API 공식 문서에서 iframe 사용방법으로 나온 코드.
			tag = document.createElement('script');
			tag.src = "https://www.youtube.com/iframe_api";
			firstScriptTag = document.getElementsByTagName('script')[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

			onYouTubeIframeAPIReady();
			
		}

		// 3. This function creates an <iframe> (and YouTube player)
		//    after the API code downloads. 
		function onYouTubeIframeAPIReady() {
			player = new YT.Player('player', {
				height : '360',
				width : '640',
				videoId : videoId,
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
				
	</script>
	
	
	<div id="get_view"></div>
	
	<div class="container">
		<div class="row">
			<div id="nav_view"></div>
		</div>
	</div>
	
	
	</div>
</div>

</body>
</html>

