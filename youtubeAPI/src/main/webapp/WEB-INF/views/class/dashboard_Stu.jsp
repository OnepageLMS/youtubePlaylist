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
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
	
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
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
</head>
<style>
	.dashboardClass{
		min-height: 75%;
	}
</style>
<script>
var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
var active_colors = ["bg-warning", "bg-success", "bg-info", "bg-strong-bliss", "bg-arielle-smile", "bg-night-fade", "bg-sunny-morning"];
var inactive_colors = ["border-primary", "border-warning", "border-success", "border-secondary", "border-info", "border-focus", "border-alternate", "border-shadow"];				

$(document).ready(function(){
	getAllMyClass();
	showAlert();
});

function getAllClass(act, order){
	var i = 0;
	var classType;

	if(act == 1) classType = '.activeClassList';
	else classType = '.inactiveClassList';

	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/student/class/getAllClass",
		data: {
			active: act,
			order: order
			},
		success: function(data){
			$(classType).empty();
			list = data.list;

			if(list.length == 0){
				$(classType).append('<p class="col text-center">저장된 강의실이 없습니다.</p>');
				return false;
			}

			$(list).each(function(){
				var classID = this.id;
				var classNoticeURL = "'${pageContext.request.contextPath}/student/notice/" + classID + "'";
				var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
				var classAttendanceURL = "'${pageContext.request.contextPath}/student/attendance/" + classID + "'";
				var newNotice = this.newNotice;
				var html;
				
				if(newNotice == 1)
					newNotice = '<span class="badge badge-primary">NEW</span>';
				else
					newNotice = '';
				
				
				if(act == 1){
					var cardColor = active_colors[i%(active_colors.length)];
					html = '<div class="col-sm-12 col-md-6 col-lg-3">'
						+ '<div class="mb-3 card">'
							+ '<div class="card-header ' + cardColor + '">' 
								+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
								+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
									+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
							+ '</div>'
							+ '<div class="card-body">'
								+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지' 
									+ newNotice
								+ '</button>'
								+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
								+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
                       		+ '</div>'
                       		+ '<div class="card-footer">'
                       			+ '<div class="row w-100">'
                        			+ '<div class="widget-subheading col-12">학습 진행도</div>'
									+ '<div class="col-12">'
										+ '<div class="mb-3 progress">'
                                           	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 75%;">75%</div>'
                                           + '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
                       	'</div>'
                       + '</div>';
				}
				
				else{
					var cardColor = inactive_colors[i%(inactive_colors.length)]; 
					html = '<div class="col-sm-12 col-md-6 col-lg-3">'
											+ '<div class="mb-3 card">'
												+ '<div class="card-header ' + cardColor + '">' 
													+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
													+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
														+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
												+ '</div>'
												+ '<div class="card-body">'
													+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="' + classNoticeURL + '">공지<i class="fa fa-fw pr-4" aria-hidden="true"></i></button>' 
													+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
													+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
								        		+ '</div>'
								        	+ '</div>'
								        + '</div>';
				}
				i++;
				$(classType).append(html);
			});
		},
		error: function(data, status,error){
			console.log('ajax dashboard 가져오기 실패!');
		}
	});
}

function getAllMyClass(){
	var i=0;
	var active, inactive;
	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/student/class/getAllMyClass",
		success: function(data){
			$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
				url : "${pageContext.request.contextPath}/student/class/competePlaylistCount",
				type : "post",
				async : false,
				success : function(data) {
					completePlaylist = data;
				},
				error : function() {
					alert("error");
				}
			})	
			
			$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
				url : "${pageContext.request.contextPath}/student/class/classTotalPlaylistCount",
				type : "post",
				async : false,
				success : function(data) {
					allPlaylist = data;
				},
				error : function() {
					alert("error");
				}
			})
			
			
			 $('.activeClassList').empty();
			active = data.active;
			inactive = data.inactive;
	
			if((active.length + inactive.length) == 0){
				$('.dashboardClass').append('<p class="col text-center">참여중인 강의실이 없습니다.</p>');
				$('.classActive').hide();
				$('.classInactive').hide();
				return false;
			}

			if(active.length == 0)
				$('.activeClassList').append('<p class="col text-center">참여중인 강의실이 없습니다! </p>');
			else{
				$(active).each(function(){
					if(completePlaylist[i] == 0 ){
						percentage = 0;
					}
					else{
						percentage = Math.floor(completePlaylist[i] /  allPlaylist[i] *100);
					}
					
					var classID = this.id;
					var classNoticeURL = "'${pageContext.request.contextPath}/student/notice/" + classID + "'";
					var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
					var classAttendanceURL = "'${pageContext.request.contextPath}/student/attendance/" + classID + "'";
					var cardColor = active_colors[i%(active_colors.length)];
					var newNotice = this.newNotice;
					
					if(newNotice == 1)
						newNotice = '<span class="badge badge-primary">NEW</span>';
					else
						newNotice = '';
					
					var dashboardCard = '<div class="col-sm-6 col-md-3 col-lg-3">'
											+ '<div class="mb-3 card">'
												+ '<div class="card-header ' + cardColor + '">' 
													+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
													+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
														+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
												+ '</div>'
												+ '<div class="card-body">'
													+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지' 
														+ newNotice
													+ '</button>'
													+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
													+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
				                        		+ '</div>'
				                        		+ '<div class="card-footer">'
				                        			+ '<div class="row w-100">'
					                        			+ '<div class="widget-subheading col-12">학습 진행도</div>'
														+ '<div class="col-12">'
															+ '<div class="mb-3 progress">'
				                                            	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: ' + percentage + '%;">' + percentage + '%</div>'
				                                            + '</div>'
														+ '</div>'
													+ '</div>'
												+ '</div>'
				                        	'</div>'
				                        + '</div>';
				   
					$('.activeClassList').append(dashboardCard);
					i++;
				});
			}

			if(inactive.length == 0)
				$('.inactiveClassList').append('<p class="col text-center">종료된 강의실이 없습니다!</p>');
			else{
				i = 0;
				$(inactive).each(function(){
					var classID = this.id;
					var classNoticeURL = "'${pageContext.request.contextPath}/student/notice/" + classID + "'";
					var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
					var classAttendanceURL = '#';
					var cardColor = inactive_colors[i%(inactive_colors.length)]; 

					var dashboardCard = '<div class="col-sm-6 col-md-3 col-lg-3">'
											+ '<div class="mb-3 card">'
												+ '<div class="card-header ' + cardColor + '">' 
													+ '<div class="col-md-10">' +  this.className + ' (' + this.days + ' 차시)</div>' 
													+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
														+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
												+ '</div>'
												+ '<div class="card-body">'
													+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지<i class="fa fa-fw pr-4" aria-hidden="true"></i></button>' 
													+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
													+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
								        		+ '</div>'
								        	+ '</div>'
								        + '</div>';
										
						$('.inactiveClassList').append(dashboardCard);
						i++;
				});
			}
		},
		error: function(data, status,error){
			console.log('ajax dashboard 가져오기 실패!');
		}
	});
}

function showAlert(){
	var flag = '${enroll}';  
	console.log("플래그 값 확인! ==>" + flag);
	if(flag == 1) alert("성공적으로 강의실 신청이 완료되었습니다! :) ");
}

function moveToNotice(id){	//post 방식으로 classID를 넘기며 공지사항으로 이동
	var html = '<input type="hidden" name="classID"  value="' + id + '">';

	var goForm = $('<form>', {
			method: 'post',
			action: '${pageContext.request.contextPath}/student/notice/',
			html: html
		}).appendTo('body'); 

	goForm.submit();
}

$(document).on("click", ".setClassroomBtn", function () {	// set classroom btn 눌렀을 때 modal에 데이터 전송
	var classID = $(this).attr('classID');
	$('#setClassID').val(classID);

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/student/class/getClassInfo',
		data: { 'classID' : classID },
		success: function(data){
			console.log(data);
			$('#displayInstructor').text(data.name);
			$('#displayClassName').text(data.className);
			$('#displayDescription').text(data.description);

		},
		error: function(data, status,error){
			console.log('ajax class 정보 가져오기 실패!');
		}
	});
});

function submitDeleteClassroom(){
	if(confirm('강의실에서 나가시겠습니까? \n다시 복구될 수 없습니다.')){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/class/deleteClassroom',
			data: {'id' : $('#setClassID').val()},
			datatype: 'json',
			success: function(data){
				console.log('강의실 나가기 성공');
			},
			complete: function(data){
				location.reload();
			},
			error: function(data, status,error){
				alert('강의실 나가기 실패! ');
			}
		});
	}
}

</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
       <jsp:include page="../outer_top_stu.jsp" flush="true"/>      
               
       <div class="app-main">  
       		<jsp:include page="../outer_left.jsp" flush="false"></jsp:include>
                <div class="app-main__outer">
                   <div class="app-main__inner">
                       <div class="app-page-title">
                           <div class="page-title-wrapper">
                               <div class="page-title-heading mr-3">
                                 	<h3>내 강의실</h3>
                               </div>
                               <div class="d-inline-block ml-5">
                                   <button type="button" class="btn mr-2 mb-2 btn-primary" data-toggle="modal" data-target="#exampleModalLong">
                                       수강신청대기현황 
                                   </button>
                               </div>
                         </div>
                       </div>          
                      
                       <div class="dashboardClass">
                       	<div class="classActive row">
                       		<div class="col-12 row m-1">
                       			<h4 class="">참여중인 강의실</h4>
                        		<div class="dropdown d-inline-block pl-2">
		                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
		                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
		                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(1, 'regDate');">개설일순</button>
		                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(1, 'className');">이름순</button>
		                           </div>
		                       </div>
                       		</div>
                       		<div class="activeClassList col row"></div>
                       	</div>
                       	<div class="classInactive row">
                       		<div class="col-12 row m-1">
                       			<h4 class="">종료된 강의실</h4>
                        		<div class="dropdown d-inline-block pl-2">
		                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
		                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
		                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(0, 'regDate');">개설일순</button>
		                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(0, 'className');">이름순</button>
		                           </div>
		                       </div>
                       		</div>
                       		<div class="inactiveClassList col row"></div>
                       	</div>
                       	
                            	<!-- 대시보드 안 box 끝 !! -->
        
                    </div>
                   <jsp:include page="../outer_bottom.jsp" flush="true"/>
              </div>
        </div>
    </div>
    </div>
    
    <!-- set classroom modal-->
    <div class="modal fade" id="setClassroomModal" tabindex="-1" role="dialog" aria-labelledby="setClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 정보</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	           
				<div class="modal-body">
					<input type="hidden" id="setClassID" value="">
					<div class="">
						<div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 이름</label> 
		               		<p id="displayClassName" class="form-control"></p>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강사</label> 
		               		<p id="displayInstructor" class="form-control"></p>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 설명</label> 
		               		<textarea id="displayDescription" class="form-control" rows="4"></textarea>
		               </div>
					</div>
					<div class="divider"></div>
					<div class="row border border-danger m-2 p-4">
						<div class="col-md-8"><h6 class="text-danger">Danger Zone</h6></div>
						<div class=" col-md-4">
							<button type="button" class="btn btn-danger" onclick="submitDeleteClassroom();">강의실 나가기</button>
                     	</div>  
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 강의실 대기 현황 모달 -->
	<div class="modal fade show" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" style="display: none;" aria-modal="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Modal title</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
                <c:forEach var="v" items="${allPendingClass }">
                	<div class="row">
                		<c:choose>
	                		<c:when test="${v.status eq 'pending'}">
		                		<div class="col-sm-4 ml-3">
		                			<p> ${v.className} </p>
		                		</div>
		                		<div class="col-sm-1"></div>
		                		<div class="col-sm-6">
		                			<p> 허락 대기중 </p>
		                		</div>
	                		</c:when>
                		</c:choose>
                	</div>
                </c:forEach>
            </div>
            <!-- <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div> -->
        </div>
    </div>
</div>
   
</body>
</html>
