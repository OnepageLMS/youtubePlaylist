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
	
	<style>
		.navi_ul{
			background-color: #FFDAB9;
			list-style-type: none;
			margin: 0;
			padding: 0;
			overflow: hidden;
		}
		.navi_li{
			float : left;
		}
		.navi_li a{
			display: block;
			background-color: #FFDAB9;
			color : #000000;
			padding: 8px;
			text-decoration: none;
			text-align: center;
			font-weight: bold;
		}
		.navi_li a:hover{
			background-color : #CD853F;
			color: white;
		}
	
	</style>
</head>
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
				var day = weekContents[i].day;
				var date = new Date(weekContents[i].endDate.time); //timestamp -> actural time
				
				var result_date = convertTotalLength(date);
				
				var endDate = date.getFullYear() + "." + (("00"+(date.getMonth()+1).toString()).slice(-2))+ "." + (("00"+(date.getDate()).toString()).slice(-2)) + " " + (("00"+(date.getHours()).toString()).slice(-2))+ ":" + (("00"+(date.getMinutes()).toString()).slice(-2));
				
				var onclickDetail = "location.href='../contentDetail/" + weekContents[i].playlistID + "/" +weekContents[i].id + "/" +classInfo+  "'";
				
				
				//$('.lecture').append(" <a style='display: inline;' name= 'target" + (i+1) + "'>" + (i+1) + "일 강의</a> ");
				var content = $('.day:eq(' + day + ')');
				
				//if(i==0 || weekContents[i-1].playlistID != weekContents[i].playlistID){ //강의리스트에서는 플레이리스트의 첫번째 영상 썸네일만 보이도록
				//console.log(" // " + weekContents[i].playlistID);
				content.append(
					//	"<div class='card-header lecture'> "
					//	+ " <a style='display: inline;' name= 'target" + (i+1) + "'>" + (i+1) + "차시</a> "
							
					//	+ "</div>"
						
						 "<div class='content card col list-group-item' seq='" + weekContents[i].daySeq + ">"
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
                       
                      <!--  <li class="dropdown nav-item">
                            <a href="${pageContext.request.contextPath}/playlist/myPlaylist/yewon.lee@onepage.edu" class="nav-link">
                                <i class="nav-link-icon fa fa-archive"></i>
                                학습컨텐츠 보관함
                            </a>
                        </li> --> 
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
                                        학생
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
                                  	<h4>수업명 띄우기</h4>
                                </div>
                          </div>
                        </div>            
                       
                        <div class="row">
                        
                        	<div class="col-sm-12">
	                        	<ul class = "navi_ul">
	                        		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
										<li class = "navi_li"><a href="#target${j}">  ${j} 차시 </a></li>
									</c:forEach>
	                        	</ul>
                        	</div>
                        
                        	<div class="contents col-sm-12" classID="${classInfo.id}">
				
								<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
									<div class="day card list-group list-group-flush" day="${status.index}">
										 <div class="card-header lecture">
											   <a style="display: inline;" name= "target${j}">${j} 차시</a>  
											
										</div>
									</div>
								</c:forEach>
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
