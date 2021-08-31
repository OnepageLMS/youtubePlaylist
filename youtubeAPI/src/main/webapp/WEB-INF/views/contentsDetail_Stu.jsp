<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>VideoCheck</title>
    
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title -->
    <title>Vizew - Blog &amp; Magazine HTML Template</title>

    <!-- Favicon -->
    <link rel="icon" href="${pageContext.request.contextPath}/resources/contentsDetail_Stu/img/core-img/favicon.ico">

    <!-- Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/contentsDetail_Stu/style.css">
    
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	
	<style>
		.container {
  		
	  		padding-right: 15px;
			padding-left: 15px;
		    margin-right: auto;
			margin-left: auto;
  		
		}
	
		.first {
			float: left;	   
		    box-sizing: border-box;
		}
		
		.second{
			display: inline-block; 
		    border: 1px solid green;
		    padding: 10px;
		    margin-left: 1%;
		    box-sizing: border-box;
		}
		
		.videoLine{
			border: 1px solid grey;
			width: 95%;
		}
		
		.video:hover {
		background-color: lightgrey;
		cursor: pointer;
		}

		
	</style>
	
</head>
<body>

	<!--<div>
			<div class="first">
				<p class="videoTitle"></p>
	    		<div id="onepageLMS"></div>
	    		<div id='timerBox' class="timerBox">
					<div id="time" class="time">00:00:00</div>
				</div>
				<div id="myProgress">
  					<div id="myBar"></div>
				</div>
			</div> 
			
	        <div id="myPlaylist" class="second" >
	        	<div id="total_runningtime"></div>
	        	<div id="get_view" ></div>
	        </div>
        </div> -->
        <div class="container">
	        <div class = "row">
	        	
	        	<div class="displayVideo col-12 col-xs-8 col-sm-8 col-md-8 col-lg-8">
	        	 <div class="videoTitle col-12 col-md-12 col-lg-12"></div>
	        	 <div id = "onepageLMS" class="col-12 col-md-12 col-lg-12">
	        	 	<div class="tab-content">
	        	 		<div class="tab-pane fade show active" id="post-1" role="tabpanel" aria-labelledby="post-1-tab">
	        	 			 <div class="single-feature-post video-post bg-img">
	                             
	        	 			 </div>
	        	 		</div>
	        	 	</div>
	        	 </div>
	        	 
	        	 <div class=" col-12 col-md-12 col-lg-12">
		        	 <div id="myProgress" class="progress">
	  					<div id="myBar" class="progress-bar" ></div>
					 </div>
				 </div>
	        	 	
	        	</div>
	        	
	        	<div id="allVideo" class="col-12 col-xs-4 col-sm-4 col-md-4 col-lg-4">
		        <!--<div id="myProgress">
		  				<div id="myBar"></div>
					</div> -->
					
					<div id="total_runningtime"></div>
					<div id="playlistInfo"></div>
					<div id="get_view"></div>
					
					<div id="timeSetting" class="col-12 col-xs-12 col-sm-12 col-md-12 col-lg-12">
		        	 	 <form action = "../../../contentList/<%= request.getAttribute("classID") %>" method="get">
	 						<button type = "submit" class="btn btn-primary" style="float: right"> 나가기 </button>
	 					</form>
 				 	</div>
 				 	
		       	</div>

        </div>
       </div>
       
 		
 		
 		
    <script type="text/javascript">
    	
    	
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
 
        /**
         * onYouTubeIframeAPIReady 함수는 필수로 구현해야 한다.
         * 플레이어 API에 대한 JavaScript 다운로드 완료 시 API가 이 함수 호출한다.
         * 페이지 로드 시 표시할 플레이어 개체를 만들어야 한다.
         This function creates an <iFrame> after the API code downloads.
         */
        //
        var player;
        var playlist;
	 	var playlist_length;
        var studentEmail = ${list.studentEmail};
        var classID = ${classID};
        
        var playerState;
        var time = 0;
		var starFlag = false;
		
		var hour = 0;
		var min = 0;
	    var sec = 0;
		var db_timer = 0;
		var flag = 0;
		var timer;
		
		var howmanytime = 0;
		var watchedFlag = 0;
		
		var lastVideo;
		var playlistID = ${playlistID};
		var classPlaylistID = ${classPlaylistID};
		var ori_index =0;
 		
		var playlistcheck;
		
		var total_runningtime = 0;
		
	 	$(function(){ //db로부터 정보 불러오기!
	 		
	 		playlistcheck = JSON.parse('${playlistCheck}');
	 	
	 		$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax 
	 			  url : "../../../ajaxTest.do",
	 			  type : "post",
	 			  async : false,
	 			  data : {	
	 				 playlistID : playlistcheck[0].playlistID
	 			  },
	 			  success : function(data) {
	 				 playlist = data;
	 				 playlist_length = Object.keys(playlist).length;
	 			  },
	 			  error : function() {
	 			  	alert("error");
	 			  }
	 		})
	 		
	 		lastVideo = playlist[0].id;
	 		myThumbnail();
	 		move();
	 		 
	 	});
	 	
	 	function myThumbnail(){
	 		
	 		for(var i=0; i<playlist_length; i++){
	 			var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[i].youtubeID + '/1.jpg">';
	 			
	 			var newTitle = playlist[i].newTitle;
	 			var title = playlist[i].title;
	 			
	 			if (playlist[i].newTitle == null){
	 				playlist[i].newTitle = playlist[i].title;
	 				playlist[i].title = '';
			    }
	 			
	 			/*if ((playlist[i].newTitle).length > 45){
	 				playlist[i].newTitle = (playlist[i].newTitle).substring(0, 45) + " ..."; 
				}*/
				
				var completed ='';
				if(playlist[i].watched == 1){
					completed = '<div class="col-xs-1 col-lg-1"><span class="badge badge-primary"> 완료 </span></div>';
				}
				
				console.log("completed"  + completed);
				$("#get_view").append('<ul >' +
 						'<li class="nav-item"> <a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' +
 						'<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' +
 							'<div class="post-thumbnail col-xs-4 col-lg-4"> ' + thumbnail + ' </div>' +
 							'<div class="post-content col-xs-7 col-lg-7" onclick="viewVideo(\'' 
		 						+ playlist[i].youtubeID.toString() + '\'' + ',' + playlist[i].id + ',' 
			 					+ playlist[i].start_s + ',' + playlist[i].end_s +  ',' + i + ', this)" >' 
			 					+ 	'<h6 class="post-title">' + playlist[i].newTitle + '</h6>' 
			 					+	'<div class="">'+  convertTotalLength(playlist[i].duration) +'</div>' +
			 				'</div>' 
		 					+ 	completed 
	 					+ '</div></li></ul>'
	 					+ '<div class="videoLine"></div>'
	 			);
				
	 			
	 			total_runningtime += parseInt(playlist[i].duration);
	 		}
	 		
	        
	        $("#total_runningtime").append('<div> total runningTime ' + convertTotalLength(total_runningtime) + '</div>');
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
	 	
	 	function move() { //progress bar 보여주기
         	var percentage;
 			
 			$.ajax({
	 			  url : "../../../ajaxTest2.do",
	 			  type : "post",
	 			  async : false,
	 			  data : {	//하나의 classID내에 같은 PlaylistID를 가진 것들이 여러개 있을 수 있다. 그러니 playlistID뿐만 아니라 
	 				  playlistID : playlistcheck[0].playlistID,
	 				  id : playlistcheck[0].id
	 			  },
	 			  success : function(data) { //playlistID에 맞는 플레이리스트 가져오기 -> playlistCheck테이블에서
	 				 
	 				 if(data.length == 0){ //null값을 리턴받았을 때 , 즉 아직 플레이리스트를 실행하지 않아서 playlsitCheck에 대한 정보가 없을 때
	 				 	//이 때 playlistCheck테이블에 row 추가해주기
	 				 	
		 				 	$.ajax({ //null일 때 totalWatched에 insert해주기
				 			  url : "../../../ajaxTest3.do",
				 			  type : "post",
				 			  async : false,
				 			  data : {	
				 				 studentID : studentEmail,
				 				 playlistID : playlistcheck[0].playlistID,
				 				 classPlaylistID : playlistcheck[0].id,
				 				 classID : classID,
				 				 totalVideo : playlist_length,
				 				 totalWatched : 0.00
				 			  },
				 			  success : function(data) {
				 				console.log(data);
				 				//percentage.totalWatched = 0;
				 			  },
				 			  error : function() {
				 			  	alert("error");
				 			  }
				 		 })
	 				}
	 				 
	 				 else{
	 					console.log("null이 아닌데??");
	 					percentage = data;
		 				percentage_length = Object.keys(playlist).length;
	 				}
	 				
	 			},
	 			error : function() {
	 			  	alert("error");
	 			}
	 		})
	 		
             var elem = document.getElementById("myBar");
             if(!percentage){ //null값을 리턴받았을 때, 즉, totalWatched에 대한정보가 없으면 아직 안봤다는 이야기이기 때문에 0으로 표시한다.
            	 var width = parseInt(0 / total_runningtime * 100);
             }
             else{
            	 console.log("percentage.totalWatched " + percentage.totalWatched );
            	 var width = parseInt(percentage.totalWatched / total_runningtime * 100);
            	 //배열의 형태가 아니라 VO하나만 리턴받는거라서 인덱스 표시하지 않는다.
             }
             
             elem.style.width = width + "%";
             elem.innerHTML = width + "%";
               
         }
	 	
	 	
        function viewVideo(videoID, id, startTime, endTime, index, item) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
 			start_s = startTime;
    		
        	$(".video").css({'background-color' : 'unset'});
        	item.style.background = "lightgrey";
        	
 			$('.videoTitle').text(playlist[index].newTitle); //비디오 제목 정해두기\
        	
 			if (confirm("다른 영상으로 변경하시겠습니까? ") == true){    //확인
 				flag = 0;
 	 			time = 0;
 	 			
 	 			clearInterval(timer); //현재 재생중인 timer를 중지하지 않고, 새로운 youtube를 실행해서 timer 두개가 실행되는 현상으로, 새로운 유튜브를 실행할 때 타이머 중지!
				//이 전에 db에 lastTime, timer 저장하기 ajax를 써봅시다!
				
				$.ajax({ //다른 영상으로 변경할 때 현재 보고있던 영상에 대한 정보를 db에업데이트 시켜둔다.
					'type' : "post",
					'url' : "../../../changevideo",
					'data' : {
								lastTime : player.getCurrentTime(),
								studentID : studentEmail,
								videoID : lastVideo,
								classID : classID,
								playlistID : playlist[ori_index].playlistID,
								classPlaylistID : classPlaylistID,
								timer : db_timer + parseInt(playlist[ori_index].timer)
					},
					success : function(data){
						lastVideo = id; // 보던 비디오 ID에 id를 넣는다
						ori_index = index; // 원래 인덱스에 index를 넣는다.
					}, 
					error : function(err){
						alert("playlist 추가 실패! : ", err.responseText);
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
        
        
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('onepageLMS', {
                height: '480',            // <iframe> 태그 지정시 필요없음
                width: '854',             // <iframe> 태그 지정시 필요없음
                videoId: playlist[0].youtubeID,
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
				'url' : "../../../videocheck",
				'data' : {
							studentID : studentEmail, //학생ID(email)
							videoID : playlist[0].id //현재 재생중인 (플레이리스트 첫번째 영상의 ) id
				},
				success : function(data){
					
					if(playlist[0].lastTime >= 0.0) { //보던 영상이라면 lastTime부터 시작
						player.seekTo(playlist[0].lastTime, true);
					}
					else //처음보는 영상이면 지정된 start_s부터 시작
						player.seekTo(playlsit[0].start_s, true);
			        player.pauseVideo();
					
				}, 
				error : function(err){
					alert("playlist 추가 실패! : ", err.responseText);
				}
			});
            console.log('onPlayerReady 마감');
            
        }
        
		  
        function onPlayerStateChange(event) {
        	
        	/*영상이 시작하기 전에 이전에 봤던 곳부터 이어봤는지 물어보도록!*/
        	if(event.data == -1) {
        		console.log("flag : " +flag+ " /watchedFlag : "+watchedFlag);
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
        	}
        	
        	
        	/*영상이 실행될 때 타이머 실행하도록!*/
        	if(event.data == 1) {
        		
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
        		
        		
        	}
        	
        	/*영상이 일시정지될 때 타이머도 멈추도록!*/
        	if(event.data == 2){
        		 if(time != 0){
        		  console.log("pause!!! timer : " + timer + " time : " + time);
       		      clearInterval(timer);
       		      starFlag = true;
       		    }
        	}
        	
        	/*영상이 종료되었을 때 타이머 멈추도록, 영상을 끝까지 본 경우! (영상의 총 길이가 마지막으로 본 시간으로 들어간다.)*/
        	if(event.data == 0){
        		watchedFlag = 1;
        		
        		$.ajax({
					'type' : "post",
					'url' : "../../../changewatch",
					'data' : {
								lastTime : player.getDuration(), //lastTime에 영상의 마지막 시간을 넣어주기
								studentID : studentEmail, //studentID 그대로
								videoID : playlist[ori_index].id, //videoID 그대로
								timer : time + parseInt(playlist[ori_index].timer), //timer도 업데이트를 위해 필요
								watch : 1, //영상을 다 보았으니 시청여부는 1로(출석) 업데이트!
								playlistID : playlist[0].playlistID,
								classPlaylistID : classPlaylistID,
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
						alert("playlist 추가 실패! : ", err.responseText );
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
    
    
</body>
</html>