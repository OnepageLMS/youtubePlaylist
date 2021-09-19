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
$(document).ready(function(){
	var allMyClass = JSON.parse('${allMyClass}');

	for(var i=0; i<allMyClass.length; i++){
		var name = allMyClass[i].className;
		var date = new Date(allMyClass[i].startDate.time); //timestamp -> actural time
		var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate();
		var classNoticeURL = '#';
		//var classContentURL = "'${pageContext.request.contextPath}/class/contentList/" + allMyClass[i].id + "'";
		var classContentURL = "'${pageContext.request.contextPath}/class/contentList/1'";
		var classAttendanceURL = '#';
		
		var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
							
		var bg_colors = ["bg-warning", "bg-success", "bg-info", "bg-focus", "bg-alternate", "bg-shadow"];
		var dashboardCard = '<div class="col-md-6 col-lg-3">'
								+ '<div class="mb-3 card">'
									+ '<div class="card-header ' + bg_colors[i%(bg_colors.length)] + '">' 
										+ '<div class="col-sm-10">' +  name + ' (' + allMyClass[i].days + ' 차시)' + '</div>'
										+ '<a href="javascript:void(0);" data-toggle="modal" data-target="#setClassroomModal" class="nav-link"><i class="nav-link-icon fa fa-cog"></i></a>'
									+ '</div>'
									+ '<div class="card-body">'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지</button>'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
										+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
	                        		+ '</div>'
	                        		+ '<div class="card-footer">'
	                        			+ '<div class="widget-subheading col-6">시작일 ' + startDate + '</div>'
										+ '<div class="widget-subheading col-6">참여자 **명</div>'
									+ '</div>'
	                        	'</div>'
	                        + '</div>';
		//이건 디자인만 다르게
		var border_colors = ["border-primary", "border-warning", "border-success", "border-secondary", "border-info", "border-focus", "border-alternate", "border-shadow"];
      	var dashboardCard2 = '<div class="col-md-6 col-lg-3">'
								+ '<div class="mb-3 card border ' + border_colors[i%(border_colors.length)] + '">'
									+ '<div class="card-header">' 
										+ '<div class="col-sm-10">' +  name + ' (' + allMyClass[i].days + ' 차시)' + '</div>'
										+ '<a href="javascript:void(0);" data-toggle="modal" data-target="#setClassroomModal" class="nav-link"><i class="nav-link-icon fa fa-cog"></i></a>'
									+ '</div>'
									+ '<div class="card-body">'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지</button>'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
										+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
	                        		+ '</div>'
	                        		+ '<div class="card-footer">'
	                        			+ '<div class="widget-subheading col-6">시작일 ' + startDate + '</div>'
									+ '</div>'
	                        	'</div>'
	                        + '</div>';
		$('.classActive').append(dashboardCard);
		$('.classInactive').append(dashboardCard2);
	}

});

function initForm(){	//강의실 생성 및 수정 form 내용 초기화
	$('#formAddClassroom')[0].reset();
	$('#formEditClassroom')[0].reset();
}

function submitAddClassroom(){	//add classroom form 전송
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/insertClassroom',
		data: $('#formAddClassroom').serialize(),
		success: function(data){
			if(data == 'ok')
				alert('강의실 생성 완료!');
			else
				alert('강의실 생성 실패! ');
		},
		error: function(data){
			alert('controller 강의실 생성 실패! ');
		}
	});
}

function submitEditClassroom(){
	
}
</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow">
        <jsp:include page="../outer_top_noHamburgur.jsp" flush="true"/>       
             
        <div class="app-main">  
                 <div class="app-main__outer">
                    <div class="app-main__inner">
                        <div class="app-page-title">
                            <div class="page-title-wrapper">
                                <div class="page-title-heading col-sm-12">
                                  	<h2 class="col-sm-10">대시보드</h2>
                                  	<button class="btn btn-primary float-right" data-toggle="modal" data-target="#addClassroomModal">
                                  		<b>+</b> 강의실 생성
                                  	</button>
                                </div>
                                
                          </div>
                        </div>            
                       
                        <div class="dashboardClass">
                        	<div class="classActive row col">
                        		<div class="col-12 row">
                        			<h4 class="col-sm-3">활성화된 강의실</h4>
	                        		<div class="dropdown d-inline-block">
			                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
			                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
			                               <button type="button" tabindex="0" class="dropdown-item">개설일순</button>
			                               <button type="button" tabindex="0" class="dropdown-item">이름순</button>
			                           </div>
			                       </div>
                        		</div>
                        		
                        	</div>
                            <div class="classInactive row col">
                            	<div class="col-12 row">
                        			<h4 class="col-sm-3">비활성화된 강의실</h4>
	                        		<div class="dropdown d-inline-block">
			                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
			                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
			                               <button type="button" tabindex="0" class="dropdown-item">개설일순</button>
			                               <button type="button" tabindex="0" class="dropdown-item">이름순</button>
			                           </div>
			                       </div>
                            </div>
                        </div>	<!-- 대시보드 안 box 끝 !! -->
        
                    </div>
                   <jsp:include page="../outer_bottom.jsp" flush="true"/>
              </div>
        </div>
    </div>
   </div>

	<!-- modal for add classroom -->    
	<div class="modal fade" id="addClassroomModal" tabindex="-1" role="dialog" aria-labelledby="addClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 생성</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="initForm();">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form class="needs-validation" id="formAddClassroom" method="post" novalidate>
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="inputClassName" class="">강의실 이름</label>
		               		<input name="className" id="inputClassName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">강의실 이름을 입력해주세요</div>	
		               </div>
		               <div class="position-relative form-group">
		               		<label for="inputDescription" class="">강의실 설명</label>
		               		<textarea name="description" id="inputDescription" class="form-control"></textarea>
		               </div>
		               <div class="form-row">
		               		<div class="col-md-3">
			                   <div class="position-relative form-group">
			                   		<label for="inputClassDays" class="">강의 횟수</label>
				               		<input name="days" placeholder="ex)12" id="inputClassDays" type="text" class="form-control">
			                   </div>
		                   	</div>
		                   	
							<div class="col-md-9">
			                   <div class="position-relative form-group">
				               		<label for="inputClassTag" class="">태그</label>
				               		<input name="tag" placeholder="ex) 21-겨울 캠프, 웹캠프" id="inputClassTag" type="text" class="form-control">
				               </div>
			               	</div>
	                   </div>
	                   <div class="form-group"> 
			        		<label class="custom-control-label" for="inputCloseClassroom">강의실 게시 종료일</label>
			        		<input type="date" name="closeDate" class="form-control" id="inputCloseClassroom"/>
			        	</div> 
	                   <div class="form-group custom-control custom-switch">
				            <input type="checkbox" checked="" name="active" class="custom-control-input" id="customSwitch1">
				            <label class="custom-control-label" for="customSwitch1">강의실 활성화</label>
				        </div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="initForm();">취소</button>
		                <button type="button" class="btn btn-primary" onclick="submitAddClassroom();">생성</button>
		            </div>
	            </form>
	            <script>
	               // Example starter JavaScript for disabling form submissions if there are invalid fields
	               (function() {
	                   'use strict';
	                   window.addEventListener('load', function() {
	                       // Fetch all the forms we want to apply custom Bootstrap validation styles to
	                       var forms = document.getElementsByClassName('needs-validation');
	                       // Loop over them and prevent submission
	                       var validation = Array.prototype.filter.call(forms, function(form) {
	                           form.addEventListener('submit', function(event) {
	                               if (form.checkValidity() === false) {
	                                   event.preventDefault();
	                                   event.stopPropagation();
	                               }
	                               form.classList.add('was-validated');
	                           }, false);
	                       });
	                   }, false);
	               })();
	           </script>
	        </div>
	    </div>
	</div>
	
	<!-- setting classroom modal -->
    <div class="modal fade" id="setClassroomModal" tabindex="-1" role="dialog" aria-labelledby="setClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 설정</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="initForm();">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form class="needs-validation" id="formEditClassroom" method="post" novalidate>
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 이름</label>
		               		<input name="className" id="editClassName" type="text" class="form-control">
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editDescription" class="">강의실 설명</label>
		               		<textarea name="description" id="editDescription" class="form-control"></textarea>
		               </div>
		               <div class="form-row">
		               		<div class="col-md-3">
			                   <div class="position-relative form-group">
			                   		<label for="editClassDays" class="">강의 횟수</label>
				               		<input name="days" id="editClassDays" type="text" class="form-control">
			                   </div>
		                   	</div>
		                   	
							<div class="col-md-9">
			                   <div class="position-relative form-group">
				               		<label for="editClassTag" class="">태그</label>
				               		<input name="tag" id="editClassTag" type="text" class="form-control">
				               </div>
			               	</div>
	                   </div>
	                    <div class="custom-control custom-switch">
				            <input type="checkbox" checked="" name="active" class="custom-control-input" id="customSwitch2">
				            <label class="custom-control-label" for="customSwitch2">강의실 활성화</label>
				        </div>
		            </div>
	            </form>
	            <div class="modal-footer">
	            	<button type="button" class="btn btn-danger">강의실 삭제</button>
	                <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="initForm();">취소</button>
	                <button type="submit" class="btn btn-primary" onclick="submitEditClassroom();">수정완료</button>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>
