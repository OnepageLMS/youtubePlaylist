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
    <title>내 컨텐츠</title>
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
	
	<style>
		.videoPic {
			width: 120px;
			height: 70px;
			padding: 5px;
			display: inline;
		}
		
		#slider-div {
		  display: flex;
		  flex-direction: row;
		  margin-top: 30px;
		}
		
		#slider-div>div {
		  margin: 8px;
		}
		
		.slider-label {
		  position: absolute;
		  background-color: #eee;
		  padding: 4px;
		  font-size: 0.75rem;
		}
	</style>
</head>
<script>
var videoId;
var videoTitle;
var videoDuration;

// player api 사용 변수 
var tag;
var firstScriptTag;
var player;

// player과 비디오 정보 수정 폼에 전달할 변수들
var limit;
var start_s;
var end_s;
var youtubeID;
var title;
var newTitle;
var videoTag;
$(document).ready(function(){
	var allMyClass = JSON.parse('${allMyClass}');

	for(var i=0; i<allMyClass.length; i++){
		var name = allMyClass[i].className;
		var classContentURL = '${pageContext.request.contextPath}/class/contentList/' + allMyClass[i].id;
		
		//classInfo 가져오려면 controller에서 classID필요한데, 컨트롤러에 classID에 대한 정보가 없음. 추가해주어야함
		if ('${classInfo.className}' == name){ 
			var li = '<li class="mm-active">'
			var contentMenu = '<a href="' + classContentURL + '" class="mm-active">';
		}
		else {
			var li = '<li>';
			var contentMenu = '<a href="' + classContentURL + '">';
		}

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
	}
	getPlaylistInfo(${playlistID});
	getAllVideo(${playlistID}, ${videoID}); //이전 페이지에서 사용자가 선택한 playlistID 및 처음 띄워야 할 비디오ID

});

function getPlaylistInfo(playlistID){
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
		data : {playlistID : playlistID},
		datatype : 'json',
		success : function(result){
			var playlistName = result.playlistName;
			var totalVideo = result.totalVideo;
			var totalVideoLength = result.totalVideoLength;

			$('.displayPlaylistName').append(playlistName);

			$('#allVideo').attr('playlistID', playlistID);

			$('.playlistInfo').empty();
			var html = '<div class="numOfVideos">'
							+ '<p class="numOfNow" style="display:inline"></p>'
							+ ' / '
							+ '<p class="numOfTotal" style="display:inline">' + totalVideo + '</p>'
						+ '</div>'
						+ '<p class="totalVideoLength"> [총 길이 ' + convertTotalLength(totalVideoLength) + ']</p>';
			$('.playlistInfo').append(html);
		}
	});
}

function getAllVideo(playlistID, defaultVideoID){ //해당 playlistID에 해당하는 비디오 list를 가져온다
	$.ajax({
		type : 'post',
	    url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
	    data : {id : playlistID},
	    success : function(result){
		    videos = result.allVideo;
		    
		    $('.videos').empty();
		        
		    $.each(videos, function( index, value ){ 
		    	var tmp_newTitle = value.newTitle;
		    	var tmp_title = value.title;
		    	if (tmp_title.length > 30)
					tmp_title = tmp_title.substring(0, 30) + " ..."; 
				
		    	if (tmp_newTitle == null || tmp_newTitle == ''){
		    		tmp_newTitle = tmp_title;
		    		tmp_title = '';
			    }

		    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic">';

				var tmp_tags = '';
		    	if (value.tag != null && value.tag.length > 0){
			    	tmp_tags = value.tag.replace(', ', ' #');
		    		tmp_tags = '#'+ tmp_tags;
		    	}

		    	if (value.id == defaultVideoID){ //처음으로 띄울 video player설정
		    		$('.displayVideo').attr('videoID', value.id);
			    	start_s = value.start_s;
			    	end_s = value.end_s;
			    	limit = value.maxLength;
			    	youtubeID = value.youtubeID;
			    	newTitle = value.newTitle;
			    	title = value.title;
			    	videoTag = value.tag;
			    	
					setYouTubePlayer();
			    	setDisplayVideoInfo(index); //player 제외 선택한 video 표시 설정
				
					var addStyle = ' style="background-color:lightgrey;" ';
			    }
		    	else 
		    		var addStyle = '';
			    
		    	var html = '<div class="video row post-content single-blog-post style-2 d-flex align-items-center" onclick="playVideoFromPlaylist(this)"'
								+ ' seq="' + index //이부분 seq로 바꿔야할듯?
								+ '" videoID="' + value.id 
								+ '" youtubeID="' + value.youtubeID 
								+ '" start_s="' + value.start_s
								+ '" end_s="' + value.end_s
								+ '" maxLength="' + value.maxLength + '"'
								+ addStyle
							+ '>'
							//+ '<div class="videoSeq ">' + (index+1) + '</div>'
							+ '<div class="post-thumbnail col-lg-4">'
							+ 	'<div class="videoSeq ">' + (index+1) + thumbnail + '</div>'
							+ 	'<div class="tag" tag="' + value.tag + '">' + tmp_tags + '</div>'
							+'</div>'
							+ '<div class="col-lg-7">' 
							+ 	'<h6 class="post-title ">' + tmp_newTitle + '</h6>'
							+ 	'<div class="videoOriTitle" style = "color :#a6a6a6; font-size: 0.1em;">' + tmp_title + '</div>'
							+ 	'<div class="duration"> ' + convertTotalLength(value.duration) + '</div>'
							+'</div>'
							+ '<a href="#" class="aDeleteVideo col-lg-1 badge badge-danger" onclick="deleteVideo(' + value.id + ')"> 삭제</a>'
						+ '</div>'
						+ '<div class="videoLine"></div>';
				$('.videos').append(html); 
			});
		}
	});
}

function playVideoFromPlaylist(item){ //오른쪽 playlist에서 비디오 클릭했을 때 실행 (처음 이 페이지가 불러와질때 제외)
//console.log(item);
	$('.displayVideo').attr('videoID', item.getAttribute('videoID'));
	
	$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동 
	$('.video').css({'background-color' : 'unset'});
	item.style.background = "lightgrey"; //클릭한 video 표시

	youtubeID = item.getAttribute('youtubeID');
	start_s = item.getAttribute('start_s');
	end_s = item.getAttribute('end_s');
	limit = item.getAttribute('maxLength');

	var childs = item.childNodes;
	
	newTitle = childs[1].childNodes[0].innerText;
	title = childs[1].childNodes[1].innerText;
	videoTag = childs[0].childNodes[1].attributes[1].value;

	setDisplayVideoInfo(item.getAttribute('seq'));
	
	player.loadVideoById({
		'videoId' : youtubeID,
		'startSeconds' : start_s,
		'endSeconds' : end_s
	});
}

function setDisplayVideoInfo(index){ //비디오 플레이어가 뜰 때 같이 사용자에게 나타내야 할 부분 설정

	if (newTitle == null || newTitle == '' || newTitle == title){
		newTitle = title;
		title = '';
	}
	$('.videoTitle').empty();
	var html =  '<input type="text" name="newTitle" class="form-control" id="inputNewTitle" value="' + newTitle+ '">'
				+ '<p class="originalTitle">' + title + '</p>';
	$('.videoTitle').append(html);
	
	showForm();

	$('.numOfNow').text(Number(index)+1); //클릭한 video순서 상단에 표시
			
	var start_hh = Math.floor(start_s / 3600);
	var start_mm = Math.floor(start_s % 3600 / 60);
	var start_ss = start_s % 3600 % 60;

	document.getElementById("start_hh").value = start_hh;
	document.getElementById("start_mm").value = start_mm;
	document.getElementById("start_ss").value = start_ss;

	var end_hh = Math.floor(end_s / 3600);
	var end_mm = Math.floor(end_s % 3600 / 60);
	var end_ss = end_s % 3600 % 60;

	document.getElementById("end_hh").value = end_hh;
	document.getElementById("end_mm").value = end_mm;
	document.getElementById("end_ss").value = end_ss;
	
	var tmp_videoID = $('.displayVideo').attr('videoID');
	$("#inputVideoID").val( tmp_videoID *= 1 );
	
	if (videoTag != null && videoTag != ''){
		$("#inputTag").val(videoTag);
		console.log("not null");
	}
	else
		$("#inputTag").val('');
}

function setYouTubePlayer() { //한번만 실행되도록 
	tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";
	firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

// This function creates an <iframe> (and YouTube player)
//    after the API code downloads. 
function onYouTubeIframeAPIReady() {
	player = new YT.Player('player', {
		height : '480',
		width : '854',
		videoId : videoId,
		events : {
			'onReady' : onPlayerReady,
			'onStateChange' : onPlayerStateChange
		}
	});
}
// The API will call this function when the video player is ready.
function onPlayerReady() {
	if (youtubeID == null) {
		player.playVideo();
	}
	// 플레이리스트에서 영상 선택시 player가 바로 뜰 수 있도록 함. 
	else {
		player.loadVideoById({
			'videoId' : youtubeID,
			'startSeconds' : start_s,
			'endSeconds' : end_s
		});
	}
}
// player가 끝시간을 넘지 못하게 만들기 --> 선생님한테는 끝시간을 넘길수있도록 수정해야 함
function onPlayerStateChange(state) {
	if (player.getCurrentTime() >= end_s) {
		player.pauseVideo();
		player.loadVideoById({
			'videoId' : youtubeID,
			'startSeconds' : start_s,
			'endSeconds' : end_s
		});
	}
}

// 구간 설정 자바스크립트 
// 영상 검색과 함께 영상 구간 설정을 위한 form (원래 숨겨있던 것) 보여주기:
function showForm() {
	var saveForm = document.getElementById("videoForm");
	saveForm.style.display = "block";
}

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
function validation(event) { //video 추가 form 제출하면 실행되는 함수
	event.preventDefault();
	document.getElementById("warning1").innerHTML = "";
	document.getElementById("warning2").innerHTML = "";
	
	// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
	var start_hh = $('#start_hh').val();
	var start_mm = $('#start_mm').val();
	var start_ss = $('#start_ss').val();
	start_time = start_hh * 3600 + start_mm * 60 + start_ss* 1;
	$('#start_s').val(start_time);
	console.log(start_time);
	
	var end_hh = $('#end_hh').val();
	var end_mm = $('#end_mm').val();
	var end_ss = $('#end_ss').val();
	end_time = end_hh * 3600 + end_mm * 60 + end_ss * 1;
	$('#end_s').val(end_time);
	console.log(end_time);
	
	$('#duration').val(parseInt(end_time - start_time));
	
	if (start_time > end_time) {
		document.getElementById("warning1").innerHTML = "시작시간은 끝시간보다 크지 않아야 합니다.";
		document.getElementById("start_ss").focus();
		return false;
	}
	if (end_time > limit) {
		document.getElementById("warning2").innerHTML = "끝시간은 영상 길이보다 크지 않아야 합니다.";
		document.getElementById("end_ss").focus();
		return false;
	} 
	else 
		return updateVideo(event);
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

function updateVideo(){ // video 정보 수정		
	event.preventDefault(); // avoid to execute the actual submit of the form.
	
	var tmp_videoID = $('.displayVideo').attr('videoID');
	var tmp_playlistID = $('#allVideo').attr('playlistID');

	$('#inputPlaylistID').val(tmp_playlistID);

	$.ajax({
		'type': "POST",
		'url': "${pageContext.request.contextPath}/video/updateVideo",
		'data': $("#videoForm").serialize(),
		success: function(data) {
			console.log("ajax video 수정 완료!");
			getPlaylistInfo(tmp_playlistID);
			getAllVideo(tmp_playlistID, tmp_videoID);
		},
		error: function(error) {
			//getAllPlaylist(videoID); 
			console.log("ajax video 수정 실패!" + error);
		}

	});
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
                            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
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
                    <div class="scrollbar-sidebar">	<!-- side menu 시작! -->
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
                                	<button class="btn" onclick="history.back();"><i class="pe-7s-left-arrow"></i> <-이전</button>
                                	<h3 class="displayPlaylistName"></h3>
                                </div>
                          </div>
                        </div>            
                       
                       
                        <div class="row">
                            <div class="displayVideo col-lg-8">
								<div id="player" class="embed-responsive embed-responsive-4by3 card">
									<div class="tab-content">
					        	 		<div class="tab-pane fade show active" id="post-1" role="tabpanel" aria-labelledby="post-1-tab">
					        	 			 <div class="single-feature-post video-post bg-img"></div>
					        	 		</div>
					        	 	</div>
					        	 </div>
								
								<div class="card main-card">
									<form id="videoForm" onsubmit="return validation(event)" style="display: none">
										<div id="timeSetting" class="col-12 col-md-12 col-lg-12">
											<input type="hidden" name="start_s" id="start_s">
											<input type="hidden" name="end_s" id="end_s">
										 	<input type="hidden" name="duration" id="duration">
										 	<input type="hidden" name="id" id="inputVideoID">
										 	<input type="hidden" name="playlistID" id="inputPlaylistID">
										 </div>
									</form>
										 	
									<div class="card-body">
										<div class="card-title">
											<h5>저장된 비디오 수정</h5>
										</div>
										
										<div class="divider"></div>
										
										<div class="videoTitle"></div>
										
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
										
										<div class="col">
											태그추가<input type="text" id="inputTag" class="form-control" name="tag">
											<button form="videoForm" type="submit" class="btn btn-sm btn-primary">업데이트</button>
										</div>
										
										<div>
											<button onclick="getCurrentPlayTime1()" type="button" class="btn btn-sm btn-light"> start time </button> : 
											<input type="text" id="start_hh" maxlength="2" size="2" style="border: none; background: transparent;"> 시 
											<input type="text" id="start_mm" maxlength="2" size="2" style="border: none; background: transparent;"> 분 
											<input type="text" id="start_ss" maxlength="5" size="2" style="border: none; background: transparent;"> 초 
											<button onclick="seekTo1()" type="button" class="btn btn-sm btn-light"> <i class="fa fa-share" aria-hidden="true"></i> </button>
											<span id=warning1 style="color:red;"></span> <br>
										</div>
												
										<div>
											<button onclick="getCurrentPlayTime2()" type="button" class="btn btn-sm btn-light"> end time </button> : 
											<input type="text" id="end_hh" max="" maxlength="2" size="2" style="border: none; background: transparent;"> 시 
											<input type="text" id="end_mm" max="" maxlength="2" size="2" style="border: none; background: transparent;"> 분 
											<input type="text" id="end_ss" maxlength="5" size="2" style="border: none; background: transparent;"> 초     
											<button onclick="seekTo2()" type="button" class="btn btn-sm btn-light"> <i class="fa fa-share" aria-hidden="true"></i> </button> 
											<span id=warning2 style="color:red;"></span> <br>
										</div>
									</div>
									
							</div>
							
                        </div>
                        
                        <div id="allVideo" class="col-lg-4 card">
                        	<div class="card-body">
								<div class="playlistInfo"></div>
								<div class="videos"></div>
							</div>
						</div>
 
                    </div><!-- 대시보드 안 box 끝 !! -->
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
</body>
</html>