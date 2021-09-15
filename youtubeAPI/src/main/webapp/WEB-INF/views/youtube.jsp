<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Dashboard</title>
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
	<link href="./resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="./resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>

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


</style>

</head>
<script>
var email;
$(document).ready(function(){
	//email = '${email}'; 
	email = "yewon.lee@onepage.edu";	//로그인 정보 가져오는걸로 수정하기 !
	console.log(email);

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
	$("#playlistName").before('<h4>' + localStorage.getItem("selectedPlaylistName") + '</h4>');	
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
							+ '<p class="info"> published: <b>' + dateList[i]
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

		function addToCart(id, title){
			console.log(id, title);
			var thumbnail2 = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg">';
			var content = thumbnail2 + title;
			$("#videosInCart").append(content);
			
		}

		function viewVideo(id, title, duration, index) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			//$('.videos').css({'fontWeight' : 'normal'});
			//$('input:checkbox').prop("checked", false); //youtube 검색결과에서 비디오 선택하면 playlist 체크된것 다 초기화 
			//$('.submitBtn').html('추가');
			
			console.log(id, title, duration, index);
			
			// 클릭한 영상 밑에 player 띄우기
			var $div = $('<div id="player_info"></div><div id="player"></div><div> <i class="fas fa-plus-square" onclick="addToCart(\''+id+ '\'' + ',\'' +title+'\')"> 카트에 영상 담기 </i></div>'); 
			
			if(prev_index != null){
				//$("#get_view").children().eq(prev_index).children().eq(0).text() = ""; 
				/* $("#get_view").children().eq(prev_index).children().eq(1).text() = "";
				$("#get_view").children().eq(prev_index).children().eq(2).text() = ""; */

				$('#player_info').remove();
				$('#player').remove();
				$('.fa-plus-square').remove();
				
			    //$("#get_view").children().eq(prev_index).attr('style', 'display: block');
			    //$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: none');
			}

			$("#get_view").children().eq(index).append($div);

			showYoutubePlayer(id, title, index);	

			prev_index = index;		

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
	
		
    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
        <div class="app-header header-shadow">
            <div class="app-header__logo">
                <div class="logo-src"></div>
                <div class="header__pane ml-auto">
                    <div>
                        <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                            <span class="hamburger-box">
                                <span class="hamburger-inner"></span>
                            </span>
                        </button>
                    </div>
                </div>
            </div>
            <div class="app-header__mobile-menu">
                <div>
                    <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                        <span class="hamburger-box">
                            <span class="hamburger-inner"></span>
                        </span>
                    </button>
                </div>
            </div>
            <div class="app-header__menu">
                <span>
                    <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                        <span class="btn-icon-wrapper">
                            <i class="fa fa-ellipsis-v fa-w-6"></i>
                        </span>
                    </button>
                </span>
            </div>    <div class="app-header__content">
                <div class="app-header-left">
                    <div class="search-wrapper">
                        <div class="input-holder">
                            <input type="text" class="search-input" placeholder="Type to search">
                            <button class="search-icon"><span></span></button>
                        </div>
                        <button class="close"></button>
                    </div>
                    <ul class="header-menu nav">
                        <li class="nav-item">
                            <a href="#" class="nav-link">
                                <i class="nav-link-icon fa fa-home"> </i>
                                대시보드
                            </a>
                        </li>
                       
                        <li class="dropdown nav-item">
                            <a href="${pageContext.request.contextPath}/playlist/myPlaylist/yewon.lee@onepage.edu" class="nav-link">
                                <i class="nav-link-icon fa fa-archive"></i>
                                학습컨텐츠 보관함
                            </a>
                        </li>
                    </ul>        
                </div>
                <div class="app-header-right">
                    <div class="header-btn-lg pr-0">
                        <div class="widget-content p-0">
                            <div class="widget-content-wrapper">
                                <div class="widget-content-left">
                                    <div class="btn-group">
                                        <a data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="p-0 btn">
                                            <img width="42" class="rounded-circle" src="assets/images/avatars/1.jpg" alt="">
                                            <i class="fa fa-angle-down ml-2 opacity-8"></i>
                                        </a>
                                        <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right">
                                            <button type="button" tabindex="0" class="dropdown-item">User Account</button>
                                            <button type="button" tabindex="0" class="dropdown-item">Settings</button>
                                            <h6 tabindex="-1" class="dropdown-header">Header</h6>
                                            <div tabindex="-1" class="dropdown-divider"></div>
                                            <button type="button" tabindex="0" class="dropdown-item">Dividers</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="widget-content-left  ml-3 header-user-info">
                                    <div class="widget-heading">
                                        홍길동
                                    </div>
                                    <div class="widget-subheading">
                                        교수
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>        
                </div>
            </div>
        </div>              
        <div class="app-main">
                <div class="app-sidebar sidebar-shadow">
                    <div class="app-header__logo">
                        <div class="logo-src"></div>
                        <div class="header__pane ml-auto">
                            <div>
                                <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                                    <span class="hamburger-box">
                                        <span class="hamburger-inner"></span>
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="app-header__mobile-menu">
                        <div>
                            <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                                <span class="hamburger-box">
                                    <span class="hamburger-inner"></span>
                                </span>
                            </button>
                        </div>
                    </div>
                    <div class="app-header__menu">
                        <span>
                            <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                                <span class="btn-icon-wrapper">
                                    <i class="fa fa-ellipsis-v fa-w-6"></i>
                                </span>
                            </button>
                        </span>
                    </div>    
                    <div class="scrollbar-sidebar ">	<!-- side menu 시작! -->
                        <div class="app-sidebar__inner">
                            <ul class="vertical-nav-menu sideClassList">
                                <li class="app-sidebar__heading">내 수업</li>
                                <!-- 로그인한 사용자의 class 이자리에 추가됨 !! -->
                            </ul>
                        </div>
                    </div>
                </div>   
                 <div class="app-main__outer">
                    <div class="app-main__inner">
                        <div class="app-page-title">
                            <div class="page-title-wrapper">
                                <div class="page-title-heading">
                                  	<h4 id="playlistName">  - Youtube 영상 추가 </h4>
                                </div>
                          </div>
                        </div>            
                       
                       <div class="row">
                       		<!-- <div class="col-lg-3">
								<div class="myPlaylist"></div>
							</div> -->
                       		
                       		<div class="selectedPlaylist col-lg-8 card">
								<div class="card-body">
									<div class="card-title playlistName"></div>					
											<div class="row">
												<div class="col-lg-8 ">
														<form class="card mb-3 widget-content bg-midnight-bloom" name="form1" method="post" onsubmit="return false;" >
															<select name="opt" id="opt" class="mr-2 dropdown-toggle btn btn-primary btn-lg">
																<option value="relevance">관련순</option>
																<option value="date">날짜순</option>
																<option value="viewCount">조회순</option>
																<option value="title">문자순</option>
																<option value="rating">평가순</option>
															</select> 
															<input type="text" id="search_box" class="form-control">
															<button onclick="fnGetList();" class="btn btn-primary">검색</button>
														</form>
												</div>
											</div>
											
											<div>
												<form action="playlist/player" id="form2" method="post" style="display: none">
													<input type="hidden" name="playerId" id="playerId">
													<input type="hidden" name="playerTitle" id="playerTitle">
													<input type="hidden" name="playerDuration" id="playerDuration">
												</form>
											</div>
				                            
				                            <div id="get_view"></div>
					
											<div class="container">
												<div class="row">
													<div id="nav_view"></div>
												</div>
											</div>

								</div>
							</div>	
							
							 <div class="col-lg-4">
	                            	<div class="main-card mb-3 card">
	                            		<div class="card-header">
	                            			카트에 담긴 영상들 
	                            		</div>
	                            		<div class="card-body">
	                            			<div class="scroll-area-sm"> 
	                            				<div id="videosInCart" class="scrollbar-container ps--active-y ps">	                            					
	                            				</div>
	                            			</div>
	                            		</div>
	                            	</div>
                            </div>					
                    </div>	
                       		
                       
                    </div>
                    <div class="app-wrapper-footer">
                        <div class="app-footer">
                            <div class="app-footer__inner">
                                <div class="app-footer-left">
                                    <ul class="nav">
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">
                                                Footer Link 1
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="app-footer-right">
                                    <ul class="nav">
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">
                                                Footer Link 3
                                            </a>
                                        </li>  
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>    
              </div>
        </div>
    </div>
    
    
    <script>



    </script>
</body>
</html>