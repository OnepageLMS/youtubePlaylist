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
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.14.0/css/all.css" integrity="sha384-HzLeBuhoNPvSl5KYnjx0BT+WB0QEEqLprO+NBkkk5gbc67FTaL7XIGa2w1L0Xbgc" crossorigin="anonymous">
</head>
<script>
	var playlistID = ${vo.playlistID};
	var playlist;
		
	$(document).ready(function(){
		/*var allMyClass = JSON.parse('${allMyClass}');
	
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
			
			displayDates('${vo.startDate}', '.startDate');
			displayDates('${vo.endDate}', '.endDate');
			
		}*/
		
		$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
			  url : "../forVideoInformation",
			  type : "post",
			  async : false,
			  data : {	
				 playlistID : playlistID
			  },
			  success : function(data) {
				 console.log(data);
				 playlist = data; //data는 video랑 playlist테이블 join한거 가져온다.
				 playlist_length = Object.keys(playlist).length;
				 //console.log("join 잘됐나? " + data);
				 //console.log("playlist[0].youtubeID" + playlist[0].youtubeID);
			  },
			  error : function() {
			  	alert("playlistID" + playlistID);
			  }
		})
		
		myThumbnail();

		// endDate 설정하기
		$("#endDate").after(localStorage.getItem("endDate"));
	});
	
	
	function displayDates(fulldate, name){
		 var monthToNumber = {'Jan':'01', 'Fab':'02', 'Mar':'03', 'Apr':'04', 'May':'05', 'Jun':'06', 
					'Jul':'07', 'Aug':'08', 'Sep':'09', 'Oct':'10', 'Nov':'11', 'Dec':'12'};
			
		 var end = fulldate.split(' ');
		 var day = end[5] + "-" + monthToNumber[end[1]] + "-" + end[2];
		 var end2 = end[3].split(':');
		 var time = end2[0] + ":" + end2[1];
		 $(name).append('<p style="display:inline; font-weight:bold">' + day + " " + time + '</p>');
	}
	
	
	var tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";
	var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
	
	var player;
	function onYouTubeIframeAPIReady() {
	    player = new YT.Player('contentDetail', {
	        height: '480',            
	        width: '854',             
	        videoId: playlist[0].youtubeID, //여기에 videoID 넣을 수 있도록 !!!
	        playerVars: {             
	            controls: '2'
	        },
	        events: {
	            'onReady': onPlayerReady,         
	        }
	    });
	    
	}
	
	function onPlayerReady(event) { 
	   console.log('onPlayerReady 실행');
	}
	
	var total_runningtime = 0;
	function myThumbnail(){
		
		for(var i=0; i<playlist_length; i++){
			var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[i].youtubeID + '/1.jpg">';
			
			var newTitle = playlist[i].newTitle;
			var title = playlist[i].title;
			
			if (playlist[i].newTitle == null){
				playlist[i].newTitle = playlist[i].title;
				playlist[i].title = '';
		    }
			
			if ((playlist[i].newTitle).length > 30){
				playlist[i].newTitle = (playlist[i].newTitle).substring(0, 30) + " ..."; 
			}
			
			var completed ='';
			if(playlist[i].watched == 1 && playlist[i].classPlaylistID == classPlaylistID){
				completed = '<div class="col-xs-1 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
			}
			
			$("#get_view").append(
						'<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' +
						'<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' +
							'<div class="post-thumbnail col-xs-4 col-lg-4"> ' + thumbnail + ' </div>' +
							'<div class="post-content col-xs-7 col-lg-6" onclick="viewVideo(\'' 
							+ playlist[i].youtubeID.toString() + '\'' + ',' + playlist[i].id + ',' 
		 					+ playlist[i].start_s + ',' + playlist[i].end_s +  ',' + i + ', this)" >' 
		 					+ 	'<h6 class="post-title videoNewTitle">' + playlist[i].newTitle + '</h6>' 
		 					+	'<div>'+  convertTotalLength(playlist[i].duration) +'</div>' 
		 				+'</div>' 
					+ '</div>'
					+ '<div class="videoLine"></div>'
			);
			
			
			total_runningtime += parseInt(playlist[i].duration);
		}
		$("#total_runningtime").append('<div> total runningTime ' + convertTotalLength(total_runningtime) + '</div>');
	}
		
	function viewVideo(videoID, id, startTime, endTime, index, item) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
		start_s = startTime;
	 	$(".video").css({'background-color' : 'unset'});
		item.style.background = "lightgrey";
		$('.videoTitle').text(playlist[index].newTitle); //비디오 제목 정해두기\
	       	
		player.loadVideoById({'videoId': videoID,
			               'startSeconds': startTime,
			               'endSeconds': endTime,
			               'suggestedQuality': 'default'})
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
	
</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
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
                                  	<h4> ${vo.className} - 학습컨텐츠 </h4>
                                </div>
                          </div>
                        </div>            
                       
                        <div class="row">
                            <div class="displayVideo col-12 col-xs-8 col-sm-8 col-md-8 col-lg-8">
				        		<div class="videoTitle col-12 col-md-12 col-lg-12">
				        			<div class="card p-3">
					        			<div class="row">
					        				<div class="title col-9">
												 <h5 class="mb-0"> ${vo.title} </h5>
											</div>
										
							        		<div class="endDate text-right col-2" style="display:inline">
												<p id="endDate" style="display:inline"> 마감일 : </p>
											</div>
											<!-- <div class="startDate" style="display:inline"> 
												<p style="display:inline">공개일</p>
											</div> -->
											<div class="col-1"> 
												<i class="text-right fas fa-ellipsis-v"></i> 
											</div>
					        			</div>
									</div>
				        		</div>
				        		
				        	 
					        	<div id = "contentDetail" class="col-12 col-md-12 col-lg-12">
					        	 	<div class="tab-content">
					        	 		<div class="tab-pane fade show active" id="post-1" role="tabpanel" aria-labelledby="post-1-tab">
					        	 			 <div class="single-feature-post video-post bg-img">
					                             
					        	 			 </div>
					        	 		</div>
					        	 	</div>
					        	</div>
					        	
					        	<div class="content col-12 col-md-12 col-lg-12">
									<!--  <div class="selectContent">
										<div id="selectedContent">
											<p>playlist 총 재생시간 및 각 비디오시간 출력!</p>
											<p>${vo.playlistID}번 playlist 정보 여기에</p>
										</div>
									</div> -->
									
									
									
									<div class="card description p-2">
										<p>${vo.description}</p>
									</div>
									
									
								</div>
				        	 	
				        	</div>
	        	
				        	<div id="allVideo" class="col-12 col-xs-4 col-sm-4 col-md-4 col-lg-4">
					        <!--<div id="myProgress">
					  				<div id="myBar"></div>
								</div> -->
								
								<div id="classTitle">
									<div class="btn-group-toggle" data-toggle="buttons">  
										<label class="btn btn-outline-primary">
											<input type="radio" name="options" id="option1" autocomplete="off">
											1
										</label>
										<label class="btn btn-outline-primary">
											<input type="radio" name="options" id="option2" autocomplete="off">
											2
										</label>
									</div>
								</div>
								<div id="total_runningtime"></div>
								<div id="get_view"></div>
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
