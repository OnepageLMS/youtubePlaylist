<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>contentDetail</title>



	<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/jquery-3.1.1.js" type="text/javascript"></script>
	
	<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script 
	  src="http://code.jquery.com/jquery-3.5.1.js"
	  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	  crossorigin="anonymous"></script>
	  
<style>
	.content{
		padding: 10px;
		width: 50%;
	}
	
	.selectContent{
		padding: 5px;
		border: 2px solid lightgrey;
		width: 60%;
	}
	
	.videoLine{
			border: 1px solid grey;
			width: 95%;
	}
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
  
 <script>
	var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
	var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
	
 	var playlistID = ${vo.id};
 	var playlist;
 	
	$(document).ready(function(){
			displayDates('${vo.startDate}', '.startDate');
			displayDates('${vo.endDate}', '.endDate');
			
			
			$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
	 			  url : "../forVideoInformation",
	 			  type : "post",
	 			  async : false,
	 			  data : {	
	 				 id : playlistID
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
			/*if(playlist[i].watched == 1 && playlist[i].classPlaylistID == classPlaylistID){
				completed = '<div class="col-xs-1 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
			}*/
			
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
	<div class="container">
	        <div class = "row">
	        	
	        	<div class="displayVideo col-12 col-xs-8 col-sm-8 col-md-8 col-lg-8">
	        		<div class="videoTitle col-12 col-md-12 col-lg-12"></div>
	        		
	        		<div>
		        		<div class="endDate" style="display:inline">
							<p style="display:inline">마감일</p>
						</div>
							
						<div class="startDate" style="display:inline"> 
							<p style="display:inline">공개일</p>
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
	        	 	
	        	</div>
	        	
	        	<div id="allVideo" class="col-12 col-xs-4 col-sm-4 col-md-4 col-lg-4">
		        <!--<div id="myProgress">
		  				<div id="myBar"></div>
					</div> -->
					
					<div id="classTitle"></div>
					<div id="total_runningtime"></div>
					<div id="get_view"></div>
		       	</div>

        	</div>
        	
        	<div class = "row">
        		<div class="content col-12 col-xs-8 col-sm-8 col-md-8 col-lg-8">
						<!--  <div class="selectContent">
							<div id="selectedContent">
								<p>playlist 총 재생시간 및 각 비디오시간 출력!</p>
								<p>${vo.playlistID}번 playlist 정보 여기에</p>
							</div>
						</div> -->
						
						<div class="title">
							<p style="font-weight : bold">제목: ${vo.title}</p>
						</div>
						
						<div class="description">
							<p style="font-weight : bold">설명</p>
							<p style="font-style : italic">${vo.description}</p>
						</div>
						
						
				</div>
        	</div>
    </div>
       
</body>
</html>