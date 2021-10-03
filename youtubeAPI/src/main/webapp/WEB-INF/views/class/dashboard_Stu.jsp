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
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
</head>
<script>
var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
var active_colors = ["bg-warning", "bg-success", "bg-info", "bg-alternate", ];

$(document).ready(function(){
	var allMyClass = JSON.parse('${allMyClass}');
	
	for(var i=0; i<allMyClass.length; i++){
		//var date = new Date(allMyClass[i].startDate.time); //timestamp -> actural time
		//var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate();
		var classNoticeURL = '#';
		var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + allMyClass[i].id + "'";
		var classAttendanceURL = '#';
		var cardColor = active_colors[i%(active_colors.length)];
		
		var dashboardCard = '<div class="col-sm-6 col-md-4 col-lg-3">'
								+ '<div class="mb-3 card">'
									+ '<div class="card-header ' + cardColor + '">' 
										+ '<div class="col-sm-10">' +  allMyClass[i].className + ' (' + allMyClass[i].days + ' 차시)' + '</div>'
										+ '<a href="void(0);" classID="' + allMyClass[i].id + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link editClassroomBtn">'
											+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
									+ '</div>'
									+ '<div class="card-body">'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지' 
											+ '<span class="badge badge-primary">NEW</span>'
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
		$('.classActive').append(dashboardCard);
	}

});
</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow">
       <jsp:include page="../outer_top_noHamburgur_stu.jsp" flush="true"/>      
               
       <div class="app-main">  
                 <div class="app-main__outer">
                    <div class="app-main__inner">
                        <div class="app-page-title">
                            <div class="page-title-wrapper">
                                <div class="page-title-heading col-sm-12">
                                  	<h2 class="col-sm-10">내 강의실</h2>
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
                        	</div>
                        	<div class="classInActive row col">
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
		               		<p id="displayDescription" class="form-control"></p>
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
