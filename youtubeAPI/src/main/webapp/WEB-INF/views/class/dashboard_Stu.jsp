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
    
    <!--favicon 설정 -->
    <link rel=" shortcut icon" href="resources/img/favicon.ico" type="image/x-icon">
	<link rel="icon" href="resources/img/favicon.png" type="image/x-icon">
	
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
<script>
var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
var active_colors = ["bg-warning", "bg-success", "bg-info", "bg-alternate", ];
var inactive_colors = ["border-primary", "border-warning", "border-success", "border-secondary", "border-info", "border-focus", "border-alternate", "border-shadow"];				

$(document).ready(function(){
	getAllMyClass();
});

function getAllMyClass(){
	var i=0;
	var active, inactive;
	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/student/class/getAllMyClass",
		success: function(data){
			 $('.activeClassList').empty();
			active = data.active;
			inactive = data.inactive;
			
			$(active).each(function(){
				var classID = this.id;
				var classNoticeURL = 'moveToNotice(' + classID + ')';
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
												+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn">'
													+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
											+ '</div>'
											+ '<div class="card-body">'
												+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="' + classNoticeURL + '">공지' 
													+ newNotice
												+ '</button>'
												+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
												+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
			                        		+ '</div>'
			                        		+ '<div class="card-footer">'
			                        			+ '<div class="row col">'
				                        			+ '<div class="widget-subheading col-12">학습 진행</div>'
													+ '<div class="col-12">'
														+ '<div class="mb-3 progress">'
			                                            	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 75%;">75%</div>'
			                                            + '</div>'
													+ '</div>'
												+ '</div>'
											+ '</div>'
			                        	'</div>'
			                        + '</div>';
			   
				$('.activeClassList').append(dashboardCard);
				i++;
			});
			
			i = 0;
			$(inactive).each(function(){
				var classID = this.id;
				var classNoticeURL = 'moveToNotice(' + classID + ')';
				var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
				var classAttendanceURL = '#';
				var cardColor = inactive_colors[i%(inactive_colors.length)]; 

				var dashboardCard = '<div class="col-sm-6 col-md-3 col-lg-3">'
										+ '<div class="mb-3 card">'
											+ '<div class="card-header ' + cardColor + '">' 
												+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
												+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn">'
													+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
											+ '</div>'
											+ '<div class="card-body">'
												+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="' + classNoticeURL + '">공지<i class="fa fa-fw pr-4" aria-hidden="true"></i></button>' 
												+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
												+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
							        		+ '</div>'
							        	+ '</div>'
							        + '</div>';
									
					$('.classInactive').append(dashboardCard);
					i++;
			});
			
		},
		error: function(data, status,error){
			console.log('ajax dashboard 가져오기 실패!');
		}
	});
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
    <div class="app-container app-theme-white body-tabs-shadow">
       <jsp:include page="../outer_top_noHamburgur_stu.jsp" flush="true"/>      
               
       <div class="app-main">  
                <div class="app-main__outer">
                   <div class="app-main__inner">
                       <div class="app-page-title">
                           <div class="page-title-wrapper">
                               <div class="page-title-heading mr-3">
                                 	<h3>내 강의실</h3>
                               </div>
                               <div class="search-wrapper">
			                    <div class="input-holder">
			                        <input type="text" class="search-input" placeholder="강의실 검색">
			                        <button class="search-icon"><span></span></button>
			                    </div>
			                    <button class="close"></button>
			                </div>
                         </div>
                       </div>            
                      
                       <div class="dashboardClass">
                       	<div class="classActive row col">
                       		<div class="col-12 row">
                       			<h4 class="col-sm-5 col-md-2">활성화된 강의실</h4>
                        		<div class="dropdown d-inline-block">
		                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
		                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
		                               <button type="button" tabindex="0" class="dropdown-item">개설일순</button>
		                               <button type="button" tabindex="0" class="dropdown-item">이름순</button>
		                           </div>
		                       </div>
                       		</div>
                       		<div class="activeClassList col row"></div>
                       	</div>
                       	<div class="classInactive row col">
                       		<div class="col-12 row">
                       			<h4 class="col-sm-5 col-md-2">비활성화된 강의실</h4>
                        		<div class="dropdown d-inline-block">
		                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
		                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
		                               <button type="button" tabindex="0" class="dropdown-item">개설일순</button>
		                               <button type="button" tabindex="0" class="dropdown-item">이름순</button>
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
   
</body>
</html>
