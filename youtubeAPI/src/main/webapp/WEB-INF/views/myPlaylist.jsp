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
    <title>MyPlaylist</title>
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
	 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	 <link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	
	<style>
		.playlistPic {
			width: -webkit-fill-available;
		}
		
		.playlist:hover{
			background-color: #F0F0F0;
			cursor: pointer;
		}
		
		.videoIndex {
			cursor: grab;
		}
		
		/*sortable 이동 타켓 */
		.video-placeholder {
			border: 1px dashed grey;
			margin: 0 1em 1em 0;
			height: 150px;
			margin-left:auto;
			margin-right:auto;
			background-color: #E8E8E8;
		}
		
		.videoContent:hover{
			cursor: pointer;
		}
		
		.duration{
			text-align: center;
			margin: 3px;
		}
		
		.videoNewTitle{
			font-size: 16px;
			margin: 3px 0;
			font-weight: bold;
		}
		
		.videoOriTitle {
			font-size: 13px;
			margin: 0;
		}
		
	</style>
</head>
<script>
var email;
$(document).ready(function(){
	email = '${email}'; 
	getAllMyPlaylist(email); //나중에는 사용자 로그인정보로 email 가져와야할듯..
	
	var allMyClass = JSON.parse('${allMyClass}');

	for(var i=0; i<allMyClass.length; i++){
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
	}
});

function getAllMyPlaylist(email){
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getAllMyPlaylist',
		data : {email : email},
		success : function(result){
			playlists = result.allMyPlaylist;

			$('.myPlaylist').empty();

			if (playlists == null)
				$('.myPlaylist').append('저장된 playlist가 없습니다.');

			else{
				var searchHtml = '<div class="searchPlaylist input-group mb-1">'
									+ '<input type="text" class="d-sm-inline-block form-control" name="search" placeholder="playlist 검색" >'
									+ '<div class="input-group-append">'
										+ '<button type="button" class="btn btn-primary d-sm-inline-block">검색</button>'
									+ '</div>'
								+ '</div>';
				//$('.myPlaylist').append(searchHtml);
				var setFormat = '<div class="card">'
									+ '<div class="card-body">'
									+ '<div class="card-title input-group">'
										+ '<div class="input-group-prepend">'
											+ '<button class="btn btn-outline-secondary">전체</button>'
											+ '<button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle dropdown-toggle-split btn btn-outline-secondary"><span class="sr-only">Toggle Dropdown</span></button>'
											+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="top-start" style="position: absolute; transform: translate3d(95px, -128px, 0px); top: 0px; left: 0px; will-change: transform;"><h6 tabindex="-1" class="dropdown-header">Header</h6>'
												+ '<button type="button" tabindex="-1" class="dropdown-item">Playlist 이름</button>'
												+ '<button type="button" tabindex="0" class="dropdown-item">Video 제목</button>'
												+ '<button type="button" tabindex="0" class="dropdown-item">태그</button>'
											+ '</div>'
										+ '</div>'
										+ '<input placeholder="검색어를 입력하세요" type="text" class="form-control">'
										+ ' <div class="input-group-append">'
											+ '<button class="btn btn-secondary">검색</button>'
										+ '</div>'
									+ '</div>'
									+ '<div><ul class="allPlaylist list-group"></div></div>'
								+ '</div>'
							+ '</div>';
				$('.myPlaylist').append(setFormat);
						
				$.each(playlists, function( index, value ){
					var contentHtml = '<button class="playlist list-group-item-action list-group-item" onclick="getPlaylistInfo(' + value.playlistID + ', ' + index 
																					+ ')" playlistID="' + value.playlistID + '" thumbnailID="' + value.thumbnailID + '">'
										+ value.playlistName + ' / ' + convertTotalLength(value.totalVideoLength)
										+ '</button>'

                	$('.allPlaylist').append(contentHtml);
				});
			}
		}, error:function(request,status,error){
			console.log(error);
		}
		
	});
}


function getPlaylistInfo(playlistID, displayIdx){ //선택한 playlistInfo 가져오기
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
		data : {playlistID : playlistID},
		datatype : 'json',
		success : function(result){
			var lastIdx = $('#playlistInfo').attr('displayIdx'); //새로운 결과 출력 위해 이전 저장된 정보 비우기
		    //$('.playlist:eq(' + lastIdx + ')').css("background-color", "unset");
		    //$(".playlist:eq(" + displayIdx + ")").css("background-color", " #F0F0F0;"); //클릭한 playlist 표시
		    $('#playlistInfo').empty(); 
		    $('.playlistName').empty();

		    $('.selectedPlaylist').attr('playlistID', playlistID); //혹시 나중에 사용할 일 있지 않을까?
		    
		    var thumbnail = '<div class="row">'
			    				+ '<div class="col-sm-12">'
				    				+ '<img src="https://img.youtube.com/vi/' + result.thumbnailID + '/0.jpg" class="playlistPic">'
				    			+ '</div>'
				    			+ '<div class="col-sm-12 text-center">'
				    				+ '<button id="playAllVideo" onclick="" class="btn btn-primary btn-sm">playlist 전체재생</button>'
				    			+ '</div>'
			    			+ '</div>';
		    $('#playlistInfo').append(thumbnail);
		    
			var name = '<h4>'
							+ '<p id="displayPlaylistName" style="display:inline";>' + result.playlistName + '</p>'
							+ '<input type="text" id="inputPlaylistName" style="display:none;">'
							+ '<button onclick="showEditPlaylistName()" class="btn btn-info btn-sm" style="display:inline;">수정</button>'
							+ '<div class="editPlaylistNameButtons" style="padding:3px;"></div>'
					+ '</h4>';
		    $('.playlistName').append(name); //중간영역
		    
			var modDate = convertTime(result.modDate);
			var totalVideoLength = convertTotalLength(result.totalVideoLength);
			var description = result.description;
			if (result.description == null)
				description = "설명 없음";

			var info = '<div class="info">' 
							+ '<div>'
								+ '<p class="totalInfo"> 총 영상 <b>' + result.totalVideo + '개</b></p>'
								+ '<p class="totalInfo"> 총 재생시간 <b>' + totalVideoLength + '</b></p>'
							+ '</div>'
							+ '<p> 업데이트 <b>' + modDate + '</b> </p>'
							+ '<div class="description card-border card card-body border-secondary">'
								+ '<p id="displayDescription">' + description + '</p>'
								+ '<input type="text" id="inputDescription" style="display:none";>'
								+ '<button onclick="showEditDescription()" class="btn btn-info btn-sm">수정</button>'
								+ '<div class="editDescriptionButtons" style="padding:3px;"></div>'
							+ '</div>'
						+ '</div>';
						
			$('#playlistInfo').append(info);
		    $('#playlistInfo').attr('displayIdx', displayIdx); //현재 오른쪽에 가져와진 playlistID 저장

			getAllVideo(playlistID); //먼저 playlist info 먼저 셋팅하고 videolist 가져오기
		}
	});
	
}

function getAllVideo(playlistID){ //해당 playlistID에 해당하는 비디오들을 가져온다
	$.ajax({
		type : 'post',
	    url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
	    data : {id : playlistID},
	    success : function(result){
		    videos = result.allVideo;
		    
		    $('#allVideo').empty();
		        
		    $.each(videos, function( index, value ){
			    
		    	var newTitle = value.newTitle;
		    	var title = value.title;
		    	//if (title.length > 45
					//title = title.substring(0, 45) + " ..."; 
				
		    	if (newTitle == null || newTitle == ''){
		    		newTitle = title;
					title = '';
			    }

		    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic img-fluid">';

		    	if (value.tag != null && value.tag.length > 0){
			    	var tags = value.tag.replace(', ', ' #');
		    		tags = '#'+ tags;
		    	}
		    	else 
			    	var tags = ' ';

		    	var address = "'../../video/watch/" + value.playlistID + '/' + value.id + "'";
		    	
		    	if (index == 0){
			    	var forButton = 'location.href=' + address + '';
					$("#playAllVideo").attr("onclick", forButton);
				} 
				
				var html = '<div class="row list-group-item">'
								+ '<div class="video col-sm-12" videoID="' + value.id + '">'
									+ '<div class="videoIndex col-sm-1 d-sm-inline-block align-middle">  <p>' + (value.seq+1) + '</p></div>'
									+ '<div class="videoContent col-sm-10 p-0 d-sm-inline-block" onclick="location.href=' + address + '" videoID="' + value.id + '" youtubeID="' + value.youtubeID + '" >'
										+ '<div class="row">'
											+ '<div class="thumbnailBox col-sm-3 row">' 
												+ thumbnail 
												+ '<p class="duration col-sm-12"> ' + convertTotalLength(value.duration) + '</p>'
											+ '</div>'
											+ '<div class="titles col-sm-9">'
												+ '<div class="row">'
													+ '<p class="col-sm-12 text-primary">' + tags + '</p>'
													+ '<p class="videoNewTitle col-sm-12">' + newTitle + '</p>'
													+ '<p class="videoOriTitle col-sm-12">' + title + '</p>'
												+ '</div>'
											+ '</div>'
										+ '</div>'
									+ '</div>'
									+ '<div class="videoEditBtn col-sm-1 d-sm-inline-block">'
										+ '<button href="#" class="aDeleteVideo btn btn-primary btn-sm align-middle" onclick="deleteVideo(' + value.id + ')">삭제</button>'
									+ '</div>'
									+ '</div>'
								+ '<div class="videoLine"></div>'
							+ '</div>';

				$('#allVideo').append(html); 
			});
		}
	});
}

$(function() { // video 순서 drag&drop으로 순서변경
	$("#allVideo").sortable({
		connectWith: "#allVideo", // 드래그 앤 드롭 단위 css 선택자
		handle: ".videoIndex", // 움직이는 css 선택자
		cancel: ".no-move", // 움직이지 못하는 css 선택자
		placeholder: "video-placeholder", // 이동하려는 location에 추가 되는 클래스
		cursor: "grab",

		update : function(e, ui){ // 이동 완료 후, 새로운 순서로 db update
			changeAllVideo();
		}
	});
		$( "#allVideo" ).disableSelection(); //해당 클래스 하위의 텍스트는 변경x

});

function changeAllVideo(deletedID){ // video 추가, 삭제, 순서변경 뒤 해당 playlist의 전체 video order 재정렬
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var idList = new Array();

	$('.video').each(function(){
		var tmp = $(this)[0];
		var tmp_videoID = tmp.getAttribute('videoID');

		if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬 (db에서 삭제하는것보다 list가 더 빨리 불러와져서 이렇게 해줘야함)
			if (deletedID != tmp_videoID)
				idList.unshift(tmp_videoID); //자꾸 마지막 video부터 가져와져서 배열앞에 push 
		}
		else
			idList.unshift(tmp_videoID);
	});
	
	$.ajax({
	      type: "post",
	      url: "${pageContext.request.contextPath}/video/changeVideosOrder", //새로 바뀐 순서대로 db update
	      data : { changedList : idList },
	      dataType  : "json", 
	      success  : function(data) {
		     	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID); //새로 정렬한 뒤 video 새로 불러와서 출력하기
	  	  		getAllMyPlaylist(email);
	    	  
	      }, error:function(request,status,error){
	    	  	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID);
	  	  		getAllMyPlaylist(email);
	       }
	    });
}

function deleteVideo(videoID){ // video 삭제
	if (confirm("정말 삭제하시겠습니까?")){
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		changeAllVideo(videoID);
		console.log("deleteVideo: " + videoID + ":" + playlistID);
		
		$.ajax({
			'type' : "post",
			'url' : "${pageContext.request.contextPath}/video/deleteVideo",
			'data' : {	videoID : videoID,
						playlistID : playlistID
				},
			success : function(data){
				changeAllVideo(videoID); //삭제한 videoID 넘겨줘야 함.
		
			}, error : function(err){
				alert("video 삭제 실패! : ", err.responseText);
			}

		});
	}
	else 
		false;
}

function savePlaylistName(){ //playlist name 수정
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var name = $("#inputPlaylistName").val();

	$.ajax({
		'type' : 'post',
		'url' : '${pageContext.request.contextPath}/playlist/updatePlaylistName',
		'data' :{
				'playlistID' : playlistID,
				'name' : name
			},
		success :function(data){
			$("#displayPlaylistName").text(data);
			//왼쪽 menu에서도 바뀌도록 변경하기! 
			hideEditPlaylistName();
		}
	});
}

function showEditPlaylistName(){
	$("#displayPlaylistName").css("display", "none");
	$(".playlistName").children('button').css("display", "none");
	
	var value = $("#displayPlaylistName").text();
	
	$("#inputPlaylistName").val(value);
	$("#inputPlaylistName").css("display", "inline");
	
	var buttons = '<button onclick="hideEditPlaylistName()" class="btn btn-info btn-sm">취소</button>' 
					+ '<button onclick="savePlaylistName()" class="btn btn-info btn-sm">확인</button>';
	$(".editPlaylistNameButtons").append(buttons);
}

function hideEditPlaylistName(){
	$(".editPlaylistNameButtons").empty(); 
	$("#inputPlaylistName").css("display", "none");
	
	$("#displayPlaylistName").css("display", "inline");
	$(".playlistName").children('button').css("display", "inline");
}

function saveDescription(){ //description 수정
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var description = $("#inputDescription").val();

	$.ajax({
		'type' : 'post',
		'url' : '${pageContext.request.contextPath}/playlist/updatePlaylistDesciption',
		'data' :{
				'playlistID' : playlistID,
				'description' : description
			},
		success :function(data){
			$("#displayDescription").text(data);
			hideEditDescription();
		}
	});
	
}

function hideEditDescription(){
	$(".editDescriptionButtons").empty();
	$("#inputDescription").css("display", "none");
	
	$("#displayDescription").css("display", "block");
	$(".description").children('button').css("display", "block");
}

function showEditDescription(){ //playlist설명 수정
	$("#displayDescription").css("display", "none");
	$(".description").children('button').css("display", "none");

	var value = $("#displayDescription").text();
	if (value != "설명 없음")
		$("#inputDescription").val(value);

	$("#inputDescription").css("display", "block");
	
	var buttons = '<button onclick="hideEditDescription()" class="btn btn-info btn-sm">취소</button>' 
					+ ' <button onclick="saveDescription()" class="btn btn-info btn-sm">확인</button>';
	$(".editDescriptionButtons").append(buttons);
	
}

function convertTime(timestamp){ //timestamp형식을 사용자에게 보여주기
	var date = new Date(timestamp- 540*60*1000); //GMT로 돼서 강제로 바꿔주기.. 이렇게 안하면 db설정을 바꿔야하는데 우리는 불가함.
	var dd_mm_yyyy = date.toLocaleDateString();
	var yyyy_mm_dd = dd_mm_yyyy.replace(/(\d+)\/(\d+)\/(\d+)/g, "$3-$2-$1");
	/*
	var d = new Date(timestamp), // Convert the passed timestamp to milliseconds
        yyyy = d.getFullYear(),
        mm = ('0' + (d.getMonth() + 1)).slice(-2),  // Months are zero based. Add leading 0.
        dd = ('0' + d.getDate()).slice(-2),         // Add leading 0.
        hh = d.getHours(),
        h = hh,
        min = ('0' + d.getMinutes()).slice(-2),     // Add leading 0.
        ampm = 'AM',
        time;
        
    if (hh > 12) {
        h = hh - 12;
        ampm = 'PM';
    } else if (hh === 12) {
        h = 12;
        ampm = 'PM';
    } else if (hh == 0) {
        h = 12;
    }
    
    // ie: 2013-02-18, 8:35 AM  
    time = yyyy + '년' + mm + '월' + dd + '일' + h + ':' + min + ' ' + ampm;
        */
    return yyyy_mm_dd;
}

function convertTotalLength(seconds){ //duration 변환
	var seconds_hh = Math.floor(seconds / 3600);
	var seconds_mm = Math.floor(seconds % 3600 / 60);
	var seconds_ss = parseInt(seconds % 3600 % 60); //소숫점단위 안보여주기
	var result = "";
	
	if (seconds_hh > 0)
		result = seconds_hh + ":";
	result += seconds_mm + ":" + seconds_ss;
	
	return result;
}
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
            </div>   
            <div class="app-header__content">
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
                       
                        <li class="nav-item">
                            <a href="#" class="nav-link text-primary">
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
                                       		<h6 tabindex="-1" class="dropdown-header">Header</h6>
                                            <button type="button" tabindex="0" class="dropdown-item">User Account</button>
                                            <button type="button" tabindex="0" class="dropdown-item">Settings</button>
                                            <div tabindex="-1" class="dropdown-divider"></div>
                                            <button type="button" tabindex="0" class="dropdown-item">Sign Out</button>
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
                                <div class="widget-content-right header-user-info ml-3">
                                    <button type="button" class="btn-shadow p-1 btn btn-primary btn-sm show-toastr-example">
                                        <i class="fa text-white fa-calendar pr-1 pl-1"></i>
                                    </button>
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
                                </div>
                                 <div class="page-title-actions">
                                 	<button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="text-right mb-2 mr-2 dropdown-toggle btn btn-primary">영상 추가하기</button>
		                             <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
		                                 <button type="button" tabindex="0" class="dropdown-item">Youtube 영상검색 </button>
		                                 <button type="button" tabindex="0" class="dropdown-item">LMS 영상검색 </button>
		                             </div>
                                 </div>
	                       	<%-- <ul class="body-tabs body-tabs-layout tabs-animated body-tabs-animated nav">
			                    <li class="nav-item">
			                        <a role="tab" class="nav-link show active" id="tab-0" data-toggle="tab" href="#" aria-selected="true">
			                            <span>내 Playlist</span>
			                        </a>
			                        
			                    </li>
			                    
			                    <li class="nav-item">
			                    	<a role="tab" class="nav-link show" id="tab-1" href="${pageContext.request.contextPath}/youtube" data-target="#" aria-selected="false">
                                    	<span>Youtube영상검색</span>
                                	</a>	                        
			                    </li>
			                    <li class="nav-item">
			                        <a role="tab" class="nav-link show" id="tab-2" href="${pageContext.request.contextPath}/playlist/searchLms" data-target="#" aria-selected="false">
			                            <span>LMS영상검색</span>
			                        </a>
			                    </li>
	               			 </ul>    --%>
	               			 
	               			 
	               			 
                    	</div>

                        <div class="row">
                           <div class="col-lg-3">
								<div class="myPlaylist"></div>
							</div>
							
							<div class="selectedPlaylist col-lg-9 card">
								<div class="card-body">
									<div class="card-title playlistName"></div>
									<div class="row">
										<div class="col-lg-3">
											<div id="playlistInfo"></div>
										</div>
										<div class="divider"> </div>
										<div class="col-lg-9">
											<div id="allVideo" class="list-group list-group-flush"></div>
										</div>
									</div>
								</div>
							</div>
                        </div>	<!-- 대시보드 안 box 끝 !! -->
        
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
</body>
</html>
