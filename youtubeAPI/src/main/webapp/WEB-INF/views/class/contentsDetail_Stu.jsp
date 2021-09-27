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
    <title>Example</title>
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
</head>
<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
<script>
var studentEmail = 1; //우선 임의로 넣기
//var classPlaylistID = 0;
var classID =  ${classInfo.id};
var playlistSameCheck = ${playlistSameCheck};
var ori_index =0;
//var classPlaylistID = ${classPlaylistID};
var classContentID = 1;
var information;
var videoIdx;
var playlist; 

$(document).ready(function(){
	console.log("학생페이지입니ㅏㄷ!");
	$.ajax({ 
		  url : "../../../../forStudentContentDetail",
		  type : "post",
		  async : false,
		  data : {	
			 classID : classID //현재 class의 id를 보낸다.
		  },
		  dataType : "json",
		  success : function(data) {
			information = data;
			videoIdx = ${daySeq};
			//console.log("daySeq" + daySeq);
		  },
		  error : function() {
		  	alert("error");
		  }
	})
	
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
		  url : "../../../../forVideoInformation",
		  type : "post",
		  async : false,
		  data : {	
			  playlistID : information[videoIdx].playlistID
			 //playlistID : playlistSameCheck[0].playlistID //contentsList에서 선택한 주차의 첫번째 영상 보여주기
		  },
		  success : function(data) {
			 playlist = data; //data는 video랑 videocheck테이블 join한거 가져온다
			 playlist_length = Object.keys(playlist).length;
		  },
		  error : function() {
		  	alert("error");
		  }
	})
	
	var weekContents = JSON.parse('${weekContents}'); //이게 하나의 playlist에 대한 정보들만 가지고 있음

	var playlistLen = JSON.parse('${playlist}'); //total 시간을 위해
	
	for(var i=0; i<weekContents.length; i++){
		var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
		var day = weekContents[i].days;
		var date = new Date(weekContents[i].endDate.time); //timestamp -> actural time
			
		var result_date = convertTotalLength(date);
			
		var endDate = date.getFullYear() + "." + (("00"+(date.getMonth()+1).toString()).slice(-2))+ "." + (("00"+(date.getDate()).toString()).slice(-2)) + " " + (("00"+(date.getHours()).toString()).slice(-2))+ ":" + (("00"+(date.getMinutes()).toString()).slice(-2));
			
		var onclickDetail = "location.href='../contentDetail/" + weekContents[i].playlistID + "/" +weekContents[i].id + "/" +classID+  "'";
		classContentID = weekContents[i].id; // classContent의 id //여기 수정
		
		
			
		
		if(i == videoIdx){
			console.log("i / videoIdx" + videoIdx);
			var area_expanded = true;
			var area_labelledby = 'aria-labelledby="heading' + (i+1) + '"';
			var showing = 'class="collapse show"';
		}
		else{
			var area_expanded = false;
			var area_labelledby = '';
			var showing = 'class="collapse"';
		}
		
		//weekContents는 하나의 playlistID를 가지고 있는거니까 당연히 이렇게 나오지...
		
		
		
		var innerText ='';
		for(var j=0; j<playlist_length; j++){
			
			var newTitle = playlist[j].newTitle;
			var title = playlist[j].title;
			
			if (playlist[j].newTitle == null){
				playlist[j].newTitle = playlist[j].title;
				playlist[j].title = '';
	    	}
			
			if ((playlist[j].newTitle).length > 30){
				playlist[j].newTitle = (playlist[j].newTitle).substring(0, 30) + " ..."; 
			}
			
			var completed ='';
			if(playlist[j].watched == 1 && playlist[j].classContentID == classContentID){
				completed = '<div class="col-xs-1 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
			}
			
			
			var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[j].youtubeID + '/1.jpg">';
			
			innerText += '<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
						+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' 
						+ '<div class="post-thumbnail col-xs-4 col-lg-5"> ' + thumbnail + ' </div>' 
						+ '<div class="post-content col-xs-7 col-lg-5" onclick="viewVideo(\'' 
							+ playlist[j].youtubeID.toString() + '\'' + ',' + playlist[j].id + ',' 
							+ 	playlist[j].start_s + ',' + playlist[j].end_s +  ',' + j + ', this)" >' 
							+ 	'<h6 class="post-title videoNewTitle">' + playlist[j].newTitle + '</h6>' 
							+	'<div class="">'+  convertTotalLength(playlist[j].duration) +'</div>' +
							'</div>' 
							+ 	completed 
					+ '</div>'
		}
		
		var content = $('.day:eq(' + day + ')');
		content.append("<div id=\'heading" +(i+1)+ "\' >"
	               + '<button type="button" onclick="showLecture('
					+ information[i].playlistID + ',' + weekContents[i].id + ',' + classID + ',' + (i+1) +')"'
	 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
		               + "<div class='content card ' seq='" + weekContents[i].daySeq + ">"
						+ '<div>'
							+ '<div class="index col-sm-1 text-center">' + (weekContents[i].daySeq+1) + '. </div>'
								
							+ "<div class='col-sm-7' style='cursor: pointer;'>"
								+ "<div class='col-sm-12'>"
								+ weekContents[i].title  + '  [' + weekContents[i].totalVideo + ']' 
								+ '</div>'
								+ '<div class="col-sm-12">'
									+ '<p style="display:inlne">' + 'Youtube' + '</p>'
									+ '<div class="contentInfoBorder"></div>'
									+ '<p class="videoLength contentInfo" style="display:inlne">' + convertTotalLength(weekContents[i].totalVideoLength) + '</p>'
									+ '<div class="contentInfoBorder"></div>'
									+ '<p class="endDate contentInfo">' + '마감일: ' + endDate + '</p>'
								+ '</div>' 
							+ '</div>'
								
						+ '</div>'
					+ '</div>'
	   			+ '</button>'
			+ '</div>'
				
				+ '<div data-parent="#accordion" id="collapse' + (i+1) + '"' + area_labelledby + showing + '>'
	    			+ '<div class="card-body" day="' +(i+1)+ '"> '
				
				    	+ '<div id="allVideo" class="col-12 col-xs-12 col-sm-12 col-md-12 col-lg-12">'
							
							+ '<div id="classTitle"></div>'
							+ '<div id="classDescription"> </div>'
							+ '<div id="total_runningtime"></div>'
							+ '<div id="get_view'+ (i+1) +'">'
								
								+ innerText
												
							+ '</div>'
							 	
				       	+ '</div>'
				       	+'</div>'
					+ '</div>'
  			+ '</div>');
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

var n ;
var playlistVideo;
function showLecture(playlistID, id, classInfo, idx){
	n = idx;
	playlistSameCheck = JSON.parse('${playlistSameCheck}');
	
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
		  url : "../../../../forVideoInformation",
		  type : "post",
		  async : false,
		  data : {	
			  playlistID : playlistID
			// playlistID : playlistSameCheck[0].playlistID //contentsList에서 선택한 주차의 첫번째 영상 보여주기
		  },
		  success : function(data) {
			 playlist = data; //data는 video랑 videocheck테이블 join한거 가져온다
			 playlist_length = Object.keys(playlist).length;
			 
			 console.log("길이 : " + playlist[0].youtubeID);
			 console.log("forVideoInformation 성공!");
			 
		  },
		  error : function() {
		  	alert("error");
		  }
	})
	
	
	$.ajax({
		url : "../../../../forClassInformation",
		type : "post",
		async : false,
		data : {
			classPlaylistID : classInfo
		},
		success : function(classPlaylistInfo){
			$("#classTitle").empty();
			$("#classDescription").empty();
			$("#classTitle").append('<div style = " margin: 0; padding-top: 10px; padding-bottom: 10px; font-size: 25px;">"' + classPlaylistInfo.title + '"</div>');
			$("#classDescription").append('<div>' + classPlaylistInfo.description + '</div>');
		},
		error : function() {
			alert("error forClassInformation");
		}
	})
	
	lastVideo = playlist[0].id;
	myThumbnail(id, idx);
}

function myThumbnail(classContentID, idx){
	console.log("myThumbnail입니다");
	var className = '#get_view' + idx;
	$(className).empty();
	
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
		if(playlist[i].watched == 1 && playlist[i].classContentID == classContentID){
			completed = '<div class="col-xs-1 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
		}
		
		$(className).append( //stu//stu
					'<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' +
					'<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' +
						'<div class="post-thumbnail col-xs-4 col-lg-5"> ' + thumbnail + ' </div>' +
						'<div class="post-content col-xs-7 col-lg-5" onclick="viewVideo(\'' 
							+ playlist[i].youtubeID.toString() + '\'' + ',' + playlist[i].id + ',' 
	 					+ playlist[i].start_s + ',' + playlist[i].end_s +  ',' + i + ', this)" >' 
	 					+ 	'<h6 class="post-title videoNewTitle">' + playlist[i].newTitle + '</h6>' 
	 					+	'<div class="">'+  convertTotalLength(playlist[i].duration) +'</div>' +
	 					'</div>' 
						+ 	completed 
					+ '</div>'
					+ '<div class="videoLine"></div>'
		);
		
	}
	
}

function viewVideo(videoID, id, startTime, endTime, index, item) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
	start_s = startTime;
	$(".video").css({'background-color' : 'unset'});
	item.style.background = "lightgrey";
	$('.videoTitle').text(playlist[index].newTitle); //비디오 제목 정해두기\

	if (confirm("다른 영상으로 변경하시겠습니까? ") == true){    //확인
		flag = 0;
		time = 0;
		//console.log("getCurrentTime : " + player.getCurrentTime());
		//clearInterval(timer); //현재 재생중인 timer를 중지하지 않고, 새로운 youtube를 실행해서 timer 두개가 실행되는 현상으로, 새로운 유튜브를 실행할 때 타이머 중지!
		
		//ytplayer.getCurrentTime();
		$.ajax({ //다른 영상으로 변경할 때 현재 보고있던 영상에 대한 정보를 db에업데이트 시켜둔다.
			'type' : "post",
			'url' : "../../../../changevideo",
			'data' : {
						lastTime : 30, //player.getCurrentTime(),
						studentID : studentEmail, //studentEmail
						videoID : lastVideo, //playlist[0].id; 원래 비디오 id
						classID : classID, //classID
						playlistID : playlist[ori_index].playlistID,
						classPlaylistID : classContentID,
						timer : 0
			},
			success : function(data){
				lastVideo = id; // 보던 비디오 ID에 id를 넣는다
				ori_index = index; // 원래 인덱스에 index를 넣는다.
			}, 
			error : function(err){
				alert("changevideo playlist 추가 실패! : ", err.responseText);
			}
		}); //보던 영상 정보 저장
		//보던 영상에 대해 start_s, end_s 업데이트 해두기
	
		if(playlist[index].lastTime >= 0.0){ //이미 보던 영상이다.
			startTime = playlist[index].lastTime;
			howmanytime = playlist[index].timer;
			watchedFag = 1;
		}
		
		player.loadVideoById({'videoId': videoID,
             'startSeconds': startTime,
             'endSeconds': endTime,
             'suggestedQuality': 'default'})
    
	
	//이 영상을 처음보는 것이 아니라면 이전에 보던 시간부터 startTime을 설정해두기
		
	}

	else{   //취소
		return;
	}
}

//youtube 영상 띄울것입니다.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;

function onYouTubeIframeAPIReady() { 
	//var playerID = 'onepageLMS' + n;
		
	player = new YT.Player('onepageLMS', {
	       height: '480',            // <iframe> 태그 지정시 필요없음
	       width: '854',             // <iframe> 태그 지정시 필요없음
	       videoId: information[videoIdx].thumbnailID,
	       playerVars: {             // <iframe> 태그 지정시 필요없음
	           controls: '2'
	       },
	       events: {
	           'onReady': onPlayerReady,               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
	           'onStateChange': onPlayerStateChange    // 플레이어의 상태가 변경될 때마다 실행
	       }
	   });
	    
}


function onPlayerReady(event) { 
	//이거는 플레이리스트의 첫번째 영상이 실행되면서 진행되는 코드 (영상클릭없이 페이지 딱 처음 로딩되었을 )
  console.log('onPlayerReady 실행');
  $('.videoTitle').text(playlist[ori_index].newTitle);
  $.ajax({
		'type' : "post",
		'url' : "../../../../videocheck",
		'data' : {
					studentID : studentEmail, //학생ID(email)
					videoID : playlist[0].id //현재 재생중인 (플레이리스트 첫번째 영상의 ) id
		},
		success : function(data){
			// 여기 Playlist로 해둬야하는거 아닌가?
			if(playlist[0].lastTime >= 0.0) { //보던 영상이라면 lastTime부터 시작
				player.seekTo(playlist[0].lastTime, true);
			}
			else //처음보는 영상이면 지정된 start_s부터 시작
				player.seekTo(playlsit[0].start_s, true);
	        player.pauseVideo();
			
		}, 
		error : function(err){
			alert(" videocheck playlist 추가 실패! : ", err.responseText);
		}
	});
  console.log('onPlayerReady 마감');
  
}


function onPlayerStateChange(event) {
	
	/*영상이 시작하기 전에 이전에 봤던 곳부터 이어봤는지 물어보도록!*/
	/*if(event.data == -1) {
		//console.log("flag : " +flag+ " /watchedFlag : "+watchedFlag);
		if(flag == 0 && watchedFlag != 1){ //아직 끝까지 안봤을 때만 물어보기! //처음볼때는 물어보지 않기
			
			if (confirm("이어서 시청하시겠습니까?") == true){    
				flag = 1;
				player.playVideo();
  		}
  		
  		else{   //취소
  			player.seekTo(playlist[ori_index].start_s, true);
  			flag = 1;
  			player.playVideo();
  			return;
  		}
		}
	}*/
	
	
	/*영상이 실행될 때 타이머 실행하도록!*/
	/*if(event.data == 1) {
		
		//console.log(event.data);
		
		starFlag = false;
		timer = setInterval(function(){
			if(!starFlag){
				
	    		
		       	min = Math.floor(time/60);
		        hour = Math.floor(min/60);
		        sec = time%60;
		        min = min%60;
		
		        var th = hour;
		        var tm = min;
		        var ts = sec;
		        
		        if(th<10){
		        	th = "0" + hour;
		        }
		        if(tm < 10){
		        	tm = "0" + min;
		        }
		        if(ts < 10){
		        	ts = "0" + sec;
		        }
				
		        
		        document.getElementById("time").innerHTML = th + ":" + tm + ":" + ts;
		        db_timer = time;
		        time++;
			}
	      }, 1000);
		
		
	}*/
	
	/*영상이 일시정지될 때 타이머도 멈추도록!*/
	/*
		 if(time != 0){
		  console.log("pause!!! timer : " + timer + " time : " + time);
		      clearInterval(timer);
		      starFlag = true;
		    }
	}*/
	
	/*영상이 종료되었을 때 타이머 멈추도록, 영상을 끝까지 본 경우! (영상의 총 길이가 마지막으로 본 시간으로 들어간다.)*/
	if(event.data == 0){
		watchedFlag = 1;
		
		$.ajax({
			'type' : "post",
			'url' : "../../../../changewatch",
			'data' : {
						lastTime : player.getDuration(), //lastTime에 영상의 마지막 시간을 넣어주기
						studentID : studentEmail, //studentID 그대로
						videoID : playlist[ori_index].id, //videoID 그대로
						timer : time + parseInt(playlist[ori_index].timer), //timer도 업데이트를 위해 필요
						watch : 1, //영상을 다 보았으니 시청여부는 1로(출석) 업데이트!
						playlistID : playlist[0].playlistID,
						classPlaylistID : classContentID,
						classID : classID
			},
			
			success : function(data){
				//영상을 잘 봤다면, 다음 영상으로 자동재생하도록
				console.log("ori_index : " +ori_index + "videoID : " + playlist[ori_index].youtubeID +" id : " +playlist[ori_index].id);
				ori_index++;
				$('.videoTitle').text(playlist[ori_index].newTitle);
				
				if(playlist[ori_index].lastTime >= 0.0){//보던 영상이라는 의미
					player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
			               'startSeconds': playlist[ori_index].lastTime,
			               'endSeconds': playlist[ori_index].end_s,
			               'suggestedQuality': 'default'})
				}
				else{
					player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
			               'startSeconds': playlist[ori_index].start_s,
			               'endSeconds': playlist[ori_index].end_s,
			               'suggestedQuality': 'default'})
				}
				move(); //영상 다 볼 때마다 시간 업데이트 해주기
			}, 
			error : function(err){
				alert(" changewatch playlist 추가 실패! : ", err.responseText );
				//console.log("실패했는데 watch : " + watch);
				
			}
		});
		
		
		
 		 if(time != 0){
 		  	console.log("stop!!");
		    clearInterval(timer);
		    starFlag = true;
		    time = 0;
		    
		  
	  	}
		}

	
  // 재생여부를 통계로 쌓는다.
  collectPlayCount(event.data);
}

var played = false;
function collectPlayCount(data) {
  if (data == YT.PlayerState.PLAYING && played == false) {
      // todo statistics
      played = true;
      console.log('statistics');
  }
}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false"/>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<span class="text-primary">${classInfo.className}</span>  - 강의컨텐츠	<!-- 이부분 이름 바꾸기!! -->
                            </div>
                        </div>
                    </div>    
                            
                    <div class="row">
                    
                    
                    	<div class="main-card mb-3 card card col-8 col-md-8 col-lg-8">
							<div class="card-body" style="margin : 0px; padding:0px; height:auto">
								<div class="card-header"><h3 >${vo.title }</h3></div>
                            	<div id = "onepageLMS" class="col-12 col-md-12 col-lg-12" style="margin : 0px; padding:0px;">
								</div>
								<div class="card-footer"><h5>${vo.description }</h5></div>
                            </div>
                        </div>
                                    
					        
						<div class="contents col-4 col-md-4 col-lg-4" classID="${classInfo.id}">
							<div class="col-sm-12">
	                           <nav class="" aria-label="Page navigation example">
	                               <ul class="pagination">
	                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
											<li class="page-item"><a href="#target${j}" class="page-link"> ${j} </a></li>
										</c:forEach>
	                                   
	                              	</ul>
	                            </nav>
	                       	</div>
	                       	
	                       	<div class="main-card mb-3 card">
                                    <div class="card-body">
                                        <div class="scroll-area-lg">
                                            <div class="scrollbar-container ps--active-y">
                                            	<div id="accordion" class="accordion-wrapper mb-3">
													<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
														<div class="main-card mb-3 card">
						                                   <!--<div class="card-body">-->
																<a style="display: inline;" name= "target${j}"><h5> ${j} 차시 </h5></a> 
							                                    <div class="list-group day" day="${status.index}">
							                                        	
							                                    </div>
						                                  <!-- </div>-->
						                               </div>
													</c:forEach>
												</div>
                                            </div>
                                        </div>
                                    </div>
                           	</div>
	                       	
							
							
						</div>
                    	<!-- 여기 기존 jsp파일 내용 넣기 -->
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
</body>
</html>