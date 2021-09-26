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
    <title>강의컨텐츠</title>
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
	
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
</head>

<script>
$(document).ready(function(){
	//controller에서 attribute에 저장한 것들 각자 데이터에 따라 함수에서 처리하기
	//setAllMyClass();	//왼쪽 내 class 목록 띄우기
	setAllContents();	//선택한 class의 학습 컨텐츠 리스트 띄우기
	
	$(document).on("click", "button[name='selectPlaylistBtn']", function () {	//playlist 선택버튼 눌렀을 때 modal창 오픈
		var instructorID = 1;	//임의로 설정
		
		$.ajax({
			type : 'post',
			url : '${pageContext.request.contextPath}/playlist/getAllMyPlaylist',
			data : {instructorID : instructorID},
			success : function(result){
				playlists = result.allMyPlaylist;
				
				if (playlists == null)
					$('.myPlaylist').append('저장된 playlist가 없습니다.');

				else{
					$('.myPlaylist').empty();
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
										+ '<form><fieldset class="allPlaylist position-relative form-group"></fieldset></form>'
									+ '</div>'
								+ '</div>';
					$('.myPlaylist').append(setFormat);
							
					$.each(playlists, function( index, value ){
						var contentHtml = '<div class="playlist list-group-item-action list-group-item position-relative form-check">'
											+ '<label class="form-check-label">' 
												+ '<input name="playlist" type="radio" class="form-check-input" value="' + value.id + '">'
												+ value.playlistName + ' / ' + convertTotalLength(value.totalVideoLength) 
											+ '</label>'
										+ '</div>';

	                	$('.allPlaylist').append(contentHtml);
					});
				}
				//$('#selectPlaylistModal').modal('show');
				
			}, error:function(request,status,error){
				console.log(error);
			}
		});
	})
	
});
	
	
	function setAllContents(){
		var allContents = JSON.parse('${allContents}'); //class에 해당하는 모든 contents 가져오기
		console.log("길이 : " + allContents.length);
		for(var i=0; i<allContents.length; i++){
			var day = allContents[i].days;
			var date = new Date(allContents[i].endDate.time); //timestamp -> actural time
			//var endDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
			
			var endDate = date.getFullYear() + "-" + ("00"+(date.getMonth()+1).toString()).slice(-2) + "-" + ("00"+(date.getDate()).toString()).slice(-2) + " " 
					+ ("00"+(date.getHours()).toString()).slice(-2) + ":" + ("00"+(date.getMinutes()).toString()).slice(-2);
			// (jw) endDate 넘겨주기 
			//console.log("check here", endDate);
			localStorage.setItem("endDate", endDate);
			var publishedCheck = allContents[i].published;
			//var nameCheck = "'#exampleCustomCheckbox"+(i+1)+"'";
			var nameCheck = "#exampleCustomCheckbox"+(i+1);
			console.log("nameCheck : " +nameCheck+ "/ publishedCheck:" + publishedCheck);
			if(publishedCheck == 1){
				console.log("1이야" + nameCheck);
				//document.getElementById("'" +nameCheck+ "'").setAttribute("checked", true);
				//eval("'"+optionElement[0]+"'")
				//document.getElementById("exampleCustomCheckbox1").setAttribute("checked", true);
				//document.getElementById(nameCheck).setAttribute("checked", true);
				//$("'" +nameCheck+ "'").prop("checked", true);
				$("#exampleCustomCheckbox"+(i+1)).prop("checked", true);
				console.log("#exampleCustomCheckbox"+(i+1));
			}
			else{
				console.log("0이야");
				//document.getElementById(nameCheck).setAttribute("checked", false);
				//document.getElementById(eval("'"+nameCheck+"'")).setAttribute("checked", false);
				$(nameCheck).prop("checked", false);
			}
			//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');  
			var content = $('.list-group:eq(' + day + ')'); //한번에 contents를 가져왔기 때문에, 각 content를 해당 주차별 차시 순서에 맞게 나타나도록 
			var onclickDetail = "location.href='../contentDetail/" + allContents[i].id + "/" + i + "'";
			var thumbnail = '<img src="https://img.youtube.com/vi/' + allContents[i].thumbnailID + '/0.jpg" class="inline videoPic">';
			var published;

			if (allContents[i].published == true)
				published = '<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" class="custom-control-input" class="switch" name="published">'
								+ '<label class="custom-control-label" for="switch">공개</label>';
			else
				published = '<label class="custom-control-label" for="switch">비공개</label>'
								+ '<input type="checkbox" checked data-toggle="toggle" data-onstyle="danger" class="custom-control-input" class="switch" name="published" >';
			
								
			content.append(
				"<div class='content list-group-item-action list-group-item' seq='" + allContents[i].daySeq + "'>"
						+ '<div class="row col d-flex justify-content-between align-items-center">'
							+ '<div class="index col-sm-1 text-center">' + (allContents[i].daySeq+1) + '. </div>'
							+ '<div class="videoIcon col-sm-1">' + '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; color:dodgerblue;"></i>' + '</div>'
							+ "<div class='col-sm-7 row' onclick=" + onclickDetail + " style='cursor: pointer;'>"
									+ "<div class='col-sm-6 card-title inline-block' style=' height: 50%; font-size: 15px'>"
										+ allContents[i].title + "  [" +convertTotalLength(allContents[i].totalVideoLength) + "]"
									+ '</div>'
													
													
									+ '<div class="col-sm-12">'
										+ '<div class="contentInfoBorder"></div>'
										//+ '<p class="videoLength contentInfo"">' + convertTotalLength(allContents[i].totalVideoLength) + '</p>'
										+ '<div class="contentInfoBorder"></div>'
										+ '<p class="endDate contentInfo"">' + '마감일: ' + endDate + '</p>'
									+ '</div>' 
							+ '</div>'
							//+ '<div class="col-sm-2 text-center d-flex custom-control custom-switch">' 
									//+ published
								+ '<div class=" col-sm-2 text-center d-flex custom-control custom-switch">'
									+ '<input type="checkbox" id="exampleCustomCheckbox' +(i+1) + '" class="custom-control-input" onchange="YNCheck(this, '+allContents[i].id +')">'
										+ '<label class="custom-control-label" for="exampleCustomCheckbox' +(i+1) + '"></label>'
								+ '</div>'
							//+ '</div>'
						+ '</div>'
				+ "</div>");
						/*
						"<div class='content card' seq='" + allContents[i].daySeq + "'>"
						+ '<div class="row mb-3 card-header">'
							//아래부분 바꾸기. data-target 부분!!!
							+ '<button type="button" data-toggle="collapse" data-target="#collapseOne1" aria-expanded="false" aria-controls="collapseOne" class="text-left m-0 p-0 btn btn-link btn-block collapsed">'
								+ '<div class="index col-sm-1 text-center">' + (allContents[i].daySeq+1) + '. </div>'
								+ "<div class='col-sm-7 row' onclick=" + onclickDetail + " style='cursor: pointer;'>"
									+ "<div class='col-sm-12'>"
										+ allContents[i].title  + '  [' + allContents[i].totalVideo + ']' 
									+ '</div>'
									+ '<div class="col-sm-12">'
											+ '<p class="videoLength contentInfo"">' + convertTotalLength(allContents[i].totalVideoLength) + '</p>'
											+ '<div class="contentInfoBorder"></div>'
											+ '<p class="endDate contentInfo"">' + '마감일: ' + endDate + '</p>'
									+ '</div>' 
								+ '</div>'
								+ '<div class="col-sm-2 text-center d-flex custom-control custom-switch">' 
									+ published
								+ '</div>'
		                    + '</button>'
						+ '</div>'
					 + "</div>");*/

		}
	}
	
	function YNCheck(obj, id){
		console.log("id : "+ id);
		var checked = obj.checked;
		var published;
		if(checked){
			obj.value = "Y";
			published = 1;
			console.log("Y" + published);
		}
		else{
			obj.value = "N";
			published = 0;
			console.log("N" + published);
		}
		
		$.ajax({
			type : 'post',
			url : '../updatePublished',
			data : {id : id, published : published}, //id도 같이 보내야함..
			datatype : 'json',
			success : function(result){
				console.log("success!");
			}
		});

	}
	

	function showAddContentForm(day){
		day -= 1; //임의로 조절... 
		console.log('day :' + day);
		
		var htmlGetCurrentTime = "'javascript:getCurrentTime()'";
		
		var addFormHtml = '<div class="addContentForm card-border mb-3 card card-body border-alternate" name="contentForm">'
							+ '<div class="card-header">'
								+ '<h5> 학습페이지 추가 </h5>'
							+ '</div>'
							+ '<form id="addContent" class="form-group card-body" action="${pageContext.request.contextPath}/class/addContentOK" onsubmit="return checkForm(this);" method="post">' 
								+ '<input type="hidden" name="classID" value="${classInfo.id}">'
								+ '<input type="hidden" name="days" value=""/>'
								+ '<input type ="hidden" id="inputPlaylistID" name="playlistID">'
								+ '<div class="selectContent m-3">'
									+ '<p id="playlistTitle" class="d-sm-inline-block font-weight-light text-muted"> Playlist를 선택해주세요 </p>'
									
										//data-toggle="modal" data-target=".selectPlaylistModal"
									+ '<button type="button" id="selectPlaylistBtn" name="selectPlaylistBtn" class="btn mr-2 mb-2 btn-primary float-right" data-toggle="modal" data-target="#selectPlaylistModal">Playlist 가져오기</button>'
									+ '<div id="playlistThumbnail" class="image-area mt-4"></div>'
								+ '</div>'
								+ '<div class="inputTitle input-group col">'
									+ '<div class="input-group-prepend">'
										+ '<label for="title" class="input-group-text">제목</label>'
									+ '</div>'
									+ '<input class="form-control d-sm-inline-block" type="text" name="title">'
								+ '</div>'
								+ '<div class="inputDescription m-3">'
									+ '<textarea name="description" class="form-control" rows="10" id="comment" placeholder="이곳에 내용을 작성해 주세요."></textarea>'
								+ '</div>'
								+ '<div class="m-3">'
									+ '<div class="setEndDate input-group">'
										+ '<div class="input-group-prepend">'
											+ '<label for="endDate" class="input-group-text"> 마감일: </label>'
										+ '</div>'
										+ '<input type="hidden" name="endDate">'
										+ '<input type="date" class="form-control col-sm-8" id="endDate">'
										+ '<input type="number" class="setTime end_h form-control col-sm-2" value="0" min="0" max="23"> 시'
										+ '<input type="number" class="setTime end_m form-control col-sm-2" value="0" min="0" max="59"> 분'
									+ '</div>'
									+ '<div class="setStartDate input-group">'
										+ '<div class="input-group-prepend">'
											+ '<label for="startDate" class="input-group-text">공개일: </label>'
										+ '</div>'
										+ '<input type="hidden" name="startDate">'
										+ '<input type="date" class="form-control col-sm-8" id="startDate">'
										+ '<input type="number" class="setTime start_h form-control col-sm-2" value="0" min="0" max="23"> 시'
										+ '<input type="number" class="setTime start_m form-control col-sm-2" value="0" min="0" max="59"> 분'
										+ '<button type="button" class="btn btn-info btn-sm" onclick="location.href=' + htmlGetCurrentTime + '">지금</button>'
									+ '</div>'
								+ '</div>'
								+ '<div class="text-center m-3">'
									+ '<button type="button" class="btn btn-sm btn-warning" onclick="cancelForm();" >취소</button>'
									+ '<button type="submit" class="btn btn-sm btn-primary">저장</button>'
								+ '</div>'
							+ '</form>'
									
		$('input[name=days]').attr('value', day);
		$('.day:eq(' + day + ')').append(addFormHtml);

		//아래부분 마감일 설정때 나오도록...?
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		endDate.min = date;
		//endDate.value = date;
		startDate.min = date;
		startDate.value = date;

		//페이지 추가 form 영역으로 페이지 스크롤 
		var offset = $('.addContentForm').offset();
		$('html, body').animate({scrollTop : offset.top}, 400);
		
	}

	function getCurrentTime(){
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		startDate.value = date;
		
		var hour = new Date().getHours();
		var min = new Date().getMinutes();
		$('.start_h').val(hour);
		$('.start_m').val(min);
		console.log(hour, min);
	}

	function cancelForm(){
		var a = confirm("작성을 취소하시겠습니까?");
		if (a) {
			$('.addContentForm').remove();
		}
	}

	function popupOpen(){
		if ($('#inputPlaylistID').val() >= 0){
			console.log($('#inputPlaylistID').val());
			if('이미 선택한 Playlist가 있습니다. 새로 바꾸시겠습니까?'){
			}
			else {
				return false;
			}
		}
		
		var myEmail = "yewon.lee@onepage.edu"; //이부분 나중에 로그인 구현하면 로그인한 정보 가져오기
		
		p.focus();
	} 

	function checkForm(item){
		console.log("!!");
		 console.log(item);
	        var date = $('#startDate').val().split("-");
	        var hour = $('.start_h').val();
	        var min = $('.start_m').val();
	        var startDate = new Date(date[0], date[1]-1, date[2], hour, min, 00);

	        if ($('#endDate').val() == null){
				alert("마감일을 설정해주세요!");
				$('#endDate').focus();
		    }

	        var e_date = $('#endDate').val().split("-");
	        var e_hour = $('.end_h').val();
	        var e_min = $('.end_m').val();
	        var endDate = new Date(e_date[0], e_date[1]-1, e_date[2], e_hour, e_min, 00);

	        if(startDate.getTime() >= endDate.getTime()) {
	            alert("컨텐츠 마감일보다 게시일이 빨라야 합니다.");
		        $('#startDate').focus();
	            return false;
	        }

	        if ($('input[name=title]').val() == null){
				alert("제목을 입력해주세요!");
				$('input[name=title]').focus();
				return false;
		    }
		        
	        else{
				$('input[name=endDate]').val(endDate);
				$('input[name=startDate]').val(startDate);
		    }
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
	
	function deleteCheck(classID, id){
		var a = confirm("정말 삭제하시겠습니까?");
		if (a)
			location.href = '../deleteContent/' + classID + "/" + id;
	}

	function selectOK(){	//modal창에서 playlist 선택완료시
		var playlistID = $('input:radio[name="playlist"]:checked').val();
		
		if(playlistID){
			$.ajax({
				type : 'post',
				url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
				data : {playlistID : playlistID},
				datatype : 'json',
				success : function(result){
					var thumbnailID = result.thumbnailID;	
					var name = result.playlistName;
					var totalVideo = result.totalVideo;

					var thumbnail = '<div class="image-area mt-4"><img id="imageResult" src="https://img.youtube.com/vi/' + thumbnailID + '/0.jpg" class="img-fluid rounded shadow-sm mx-auto d-block"></div>';
					var playlistInfo = thumbnail + '<p>총 ' + totalVideo + ' 개의 비디오</p>';
					$('#playlistThumbnail').empty();
					$('#playlistThumbnail').append(playlistInfo);
					
					$('#playlistTitle').text('"' + name + '" 선택됨');
					
					$('#inputPlaylistID').val(playlistID); //부모페이지에 선택한 playlistID 설정
					$('#inputThumbnailID').val(thumbnailID);
					$('#selectPlaylistBtn').text('playlist 다시선택');

					//$('#selectPlaylistModal').modal('hide');
				}
			});
		}
		else {
			alert('playlist를 선택해주세요');
			return false;
		}
	}
	
	/*function addDays(){
		var days = ${classInfo.days};
		days += 1;
		return days;
	}*/
	
	function updateDays(classID){
		$.ajax({
			type : 'post',
			url : '../updateDays',
			data : {classID : classID},
			datatype : 'json',
			success : function(result){
				console.log("성공!");
				location.reload();
			},
			error : function() {
			  	alert("updateDays error");
			}
		});
	}
	
	
	function deleteDay(classID, day){
		console.log("classID는? " + classID);
		$.ajax({
			type : 'post',
			url : '../deleteDay',
			data : {classID : classID,
				days : day},
			datatype : 'json',
			success : function(result){
				console.log("성공!" +result);
				location.reload();
			},
			error : function() {
			  	alert("updateDays error");
			}
		});
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
                            	<span class="text-primary">${classInfo.className}</span>  - 강의컨텐츠<!-- 이부분 이름 바꾸기!! -->
                            </div>
                        </div>
                    </div>    
                            
                    <div class="row">
                    	
                    	<div class="col-sm-12">
                           <nav class="" aria-label="Page navigation example">
                           	   <button onclick='updateDays(${classInfo.id})' class="float-right mb-2 mr-2 btn btn-primary">차시 추가</button>
								
                               <ul class="pagination">
                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
										<li class="page-item"><a href="#target${j}" class="page-link"> ${j} 차시 </a></li>
									</c:forEach>
                              	</ul>
                            </nav>
                       	</div>
                       	
                    	<div class="contents col-sm-12" classID="${classInfo.id}">
								
								<!--<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
									<div class="day main-card mb-3 card" day="${status.index}">
										<div class="card-body">
											<div>
												<h3 class="card-title" style="font-size: 20px;">${j} 차시</h3>
												<button onclick='showAddContentForm(${status.index})' class="btn btn-sm btn-success">+페이지추가</button>
											</div>

											<div>
												<div class="list-group accordion-wrapper"></div>
											</div>
										</div>
									</div>
								</c:forEach>-->
								
								<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
								
                                
	                                <div class="main-card mb-3 card">
	                                    <div class="card-body">
	                                    	<div class="card-title" style="display: inline;" >
	                                    		<a style="display: inline; white-space: nowrap;" name= "target${j}" >
												 <h5 style="display: inline; ">${j} 차시</h5>
												
												</a> 
												 <button onclick='showAddContentForm(${status.index})' class="mb-2 mr-2 btn-transition btn btn-outline-primary">+페이지추가</button>
												 <button onclick='deleteDay(${classInfo.id}, ${status.index})' class="mb-2 mr-2 btn-transition btn btn-danger float-right" style="float-right;">차시삭제</button>
												 <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="bottom-start" style="position: absolute; transform: translate3d(-207px, 33px, 0px); top: 0px; left: 0px; will-change: transform;">
	                                                <button type="button" tabindex="-1" class="dropdown-item" onclick='showAddContentForm(${status.index})'>+페이지추가</button>
	                                                <button type="button" tabindex="-1" class="dropdown-item">-페이지삭제</button>
	                                            </div> 
	                                    	</div>

		                                    <div class="list-group accordion-wrapper day" day="${status.index}">
		                                        	
		                                    </div>
	                                   </div>
	                               </div>
                                        
                                        
								</c:forEach>
						</div>
                    	<!-- 여기 기존 jsp파일 내용 넣기 -->
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	
   	<div class="modal fade" id="selectPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">Playlist 선택</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	            </div>
	            
	            <div class="modal-body">
	               Playlist를 선택해주세요
	               <div class="myPlaylist"></div>
	               
	            </div>
	            <div class="modal-footer">
	            	 <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="selectOK();">선택완료</button>
	            </div>
	        </div>
	    </div>
	</div>
</body>

	<!-- <div class="modal" id="selectPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">Playlist 선택</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	            </div>
	            <div class="modal-body">
	                Playlist를 선택해주세요
	                <div class="myPlaylist"></div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-primary" onclick="selectOK();">선택완료</button>
	            </div>
	        </div>
	    </div>
	</div>-->
	
	
</html>





