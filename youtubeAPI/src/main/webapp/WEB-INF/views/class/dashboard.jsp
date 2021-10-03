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
	
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> 
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
</head>
<script>
var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
var inactive_colors = ["border-primary", "border-warning", "border-success", "border-secondary", "border-info", "border-focus", "border-alternate", "border-shadow"];				
var active_colors = ["bg-warning", "bg-success", "bg-info", "bg-alternate"];

$(document).ready(function(){
	var activeClass = JSON.parse('${allMyClass}');
	var inactiveClass = JSON.parse('${allMyInactiveClass}');

	for(var i=0; i<activeClass.length; i++){	//active classroom card
		var name = activeClass[i].className;
		var classNoticeURL = '#';
		var classContentURL = "'${pageContext.request.contextPath}/class/contentList/" + activeClass[i].id + "'";
		var classAttendanceURL = '#';
		var cardColor = active_colors[i%(active_colors.length)]; 

		var dashboardCard = '<div class="col-sm-12 col-md-6 col-lg-3">'
								+ '<div class="mb-3 card classCard">'
									+ '<div class="card-header ' + cardColor + '">' 
										+ '<div class="col-sm-10">' +  name + ' (' + activeClass[i].days + ' 차시)' + '</div>'
										+ '<a class="col-xs-1" href="void(0);" onclick="shareClassroomFn(' + activeClass[i].id + ');" data-toggle="modal" data-target="#shareClassroomModal" class="nav-link">'
											+ '<i class="nav-link-icon fa fa-share"></i>'
										+ '</a>'
										+ '<a class="col-sm-1" href="void(0)"; onclick="editClassroomFn(' + activeClass[i].id + ');" data-toggle="modal" data-target="#setClassroomModal" class="nav-link">'
											+ '<i class="nav-link-icon fa fa-cog"></i>'
										+ '</a>'
									+ '</div>'
									+ '<div class="card-body">'
										+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '">공지<i class="fa fa-fw pl-2" aria-hidden="true"></i></button>'
										+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '">공지 작성<i class="fa fa-pencil-square-o pl-2" aria-hidden="true"></i></button>'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
										+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
		                        	+ '</div>'
	                        		+ '<div class="divider"></div>'
		                        	+ '<div class="card-body">'
										+ '<div class="row">'
											+ '<div class="widget-subheading col-7">종료일 ' + activeClass[i].closeDate + ' </div>'
											+ '<div class="widget-subheading col-5">참여 **명</div>'
											+ '<div class="col-12">'
												+ '<div class="mb-3 progress">'
								                	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 75%;">75%</div>'
								                + '</div>'
											+ '</div>'
											
										+ '</div>'
									 '</div>'
	                        	+ '</div>'
	                        + '</div>';
							
			$('.classActive').append(dashboardCard);
	}

	for(var i=0; i<inactiveClass.length; i++){	//inactive classroom card
		var name = inactiveClass[i].className;
		var classNoticeURL = '#';
		var classContentURL = "'${pageContext.request.contextPath}/class/contentList/" + inactiveClass[i].id + "'";
		var classAttendanceURL = '#';
		var cardColor = inactive_colors[i%(inactive_colors.length)]; 

		var dashboardCard = '<div class="col-sm-12 col-md-6 col-lg-3">'
								+ '<div class="mb-3 card classCard">'
									+ '<div class="card-header ' + cardColor + '">' 
										+ '<div class="col-sm-10">' +  name + ' (' + inactiveClass[i].days + ' 차시)' + '</div>'
											+ '<a class="col-xs-1" href="void(0);" onclick="shareClassroomFn(' +inactiveClass[i].id + ');" data-toggle="modal" data-target="#shareClassroomModal" class="nav-link">'
											+ '<i class="nav-link-icon fa fa-share"></i>'
										+ '</a>'
										+ '<a class="col-sm-1" href="void(0);" onclick="editClassroomFn(' + inactiveClass[i].id + ');"  data-toggle="modal" data-target="#setClassroomModal" class="nav-link">'
											+ '<i class="nav-link-icon fa fa-cog"></i>'
										+ '</a>'
									+ '</div>'
									+ '<div class="card-body">'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classNoticeURL + '">공지<i class="fa fa-fw pl-2" aria-hidden="true"></i></button>'
										+ '<button class="btn btn-outline-focus col-12 mb-2" onclick="location.href=' + classContentURL + '">강의 컨텐츠</button>'
										+ '<button class="btn btn-outline-focus col-12" onclick="location.href=' + classAttendanceURL + '">출결/학습현황</button>'
	                        		+ '</div>'
								+ '</div>'
	                        	+ '</div>'
	                        + '</div>';
							
			$('.classInactive').append(dashboardCard);
	}
});

$(".addClassroomBtn").click(function () {
	$('#formAddClassroom')[0].reset();
});

function shareClassroomFn(id){	//set the share classroom modal
	$('#shareClassroomID').val(id);
}

function editClassroomFn(id){	//set the edit classroom modal
	$('#formEditClassroom')[0].reset();

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/getClassInfo',
		data: { 'classID' : id },
		success: function(data){
			console.log(data);
			$('#editClassName').val(data.className);
			$('#editDescription').val(data.description);
			$('#editClassDays').val(data.days);
			$('#editClassTag').val(data.tag);
			$('#editCloseDate').val(data.closeDate);

			if(data.active == 0)
				$('#customSwitch2').removeAttr('checked');
			else
				$('#customSwitch2').attr('checked', "");
		},
		error: function(data, status,error){
			console.log('ajax class 정보 가져오기 실패!');
		}
	});
}

function submitAddClassroom(){	//submit the add classroom form 
	if($('#inputClassDays').val() == '')	//int type은 null이 될 수 없어 미리 방지
		$('#inputClassDays').val(0);
	
	if($('#customSwitch1').is(':checked'))
		$('#customSwitch1').val(1);
	else
		$('#customSwitch1').val(0);

	if($('#inputCloseDate').val() == '')
		$('#inputCloseDate').val('9999-12-31');	//null이나 '' 가 들어가면 에러난다. 

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/insertClassroom',
		data: $('#formAddClassroom').serialize(),
		datatype: 'json',
		success: function(data){
			if(data == 'ok')
				console.log('강의실 생성 완료!');
			else
				console.log('강의실 생성 실패! ');
			location.reload();
		},
		error: function(data, status,error){
			alert('강의실 생성 실패! ');
		}
	});	
}

function submitEditClassroom(){	//미완성
	// classDays 현재 강의컨텐츠의 갯수 넘지 않도록 체크
	// closeDate를 현재 이전으로 하면 학생들 어떻게?
	
	if($('#editClassDays').val() == '')	//int type은 null이 될 수 없어 미리 방지
		$('#editClassDays').val(0);
	
	if($('#customSwitch2').is(':checked'))
		$('#customSwitch2').val(1);
	else
		$('#customSwitch2').val(0);

	if($('#editCloseDate').val() == '')
		$('#editCloseDate').val('9999-12-31');
	
	//data: $('#formEditClassroom').serialize() 으로 바꾸기!!
	//mapper 파일에서도 나머지 변수 추가하기
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/editClassroom',
		data: {
				'id' : $('#setClassID').val(),
				'className' : $('#editClassName').val(),
				'description' : $('#editDescription').val(),
				'tag' : $('#editClassTag').val(),
				'active' : $('#customSwitch2').val()
			},
		datatype: 'json',
		success: function(data){
			if(data == 'ok')
				console.log('강의실 수정 완료!');
			else
				console.log('강의실 수정 실패! ');
			location.reload();
		},
		error: function(data, status,error){
			alert('강의실 수정 실패! ');
		}
	});
}

function submitDeleteClassroom(){
	var opt = $('input[name=deleteOpt]:checked').val();

	if(opt == null){
		alert('강의실 삭제 옵션을 선택해 주세요.');
		return false;
	}

	if(opt == 'forMe'){
		if(confirm('나에게만 강의실이 삭제되고 학생들에게는 비공개 강의실로 전환됩니다. \n삭제된 데이터는 다시 복구될 수 없습니다. \n삭제 하시겠습니까?')){
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/deleteForMe',
				data: {'id' : $('#setClassID').val()},
				datatype: 'json',
				success: function(data){
					console.log('나에게만 강의실 삭제 성공');
				},
				complete: function(data){
					location.reload();
				},
				error: function(data, status,error){
					alert('강의실 수정 실패! ');
				}
			});
		}
	}
	else if(opt == 'forAll'){
		if(confirm('강의실의 모든 데이터가 삭제되어 학생들에게도 강의실이 삭제됩니다. \n삭제된 데이터는 다시 복구될 수 없습니다. \n삭제 하시겠습니까?')){
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/deleteForAll',
				data: {'id' : $('#setClassID').val()},
				datatype: 'json',
				success: function(data){
					console.log('강의실 데이터 전체 삭제 성공');
				},
				complete: function(data){
					location.reload();
				},
				error: function(data, status,error){
					alert('강의실 데이터 전체 삭제 실패! ');
				}
			});
		}
	}
}

function submitShareClassroom(){
	alert($('#shareClassroomID').val());
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
                                  	<h2 class="col-sm-10">내 강의실</h2>
                                  	<button class="btn btn-primary float-right" data-toggle="modal" data-target="#addClassroomModal" id="addClassroomBtn">
                                  		<b>+</b> 강의실 생성
                                  	</button>
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
                        </div>	<!-- 대시보드 안 box 끝 !! -->
        
                    </div>
                   <jsp:include page="../outer_bottom.jsp" flush="true"/>
              </div>
        </div>
    </div>
   </div>
   
   <div class="modal fade bd-example-modal-sm" id="shareClassroomModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog modal-sm">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">강의실 복제</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
	               <input id="shareClassroomID" type="hidden" value="">
                        <h6 class="title">복제 데이터 선택</h6>
                        <div class="col">                
                            <div class="form-group">
                                <div class="form-check">
                                    <input id="closeButton" type="checkbox" value="checked" class="form-check-input">
                                    <label class="form-check-label" for="closeButton">
                                        공지
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input id="addBehaviorOnToastClick" type="checkbox" value="checked" class="form-check-input">
                                    <label class="form-check-label" for="addBehaviorOnToastClick">
                                        강의 컨텐츠
                                    </label>
                                </div>
                            </div>
                        </div>
                   
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	                <button type="button" class="btn btn-primary" onclick="submitShareClassroom();">복제</button>
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
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form class="needs-validation was-validated" id="formAddClassroom" method="post" novalidate>
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
				               		<input name="days" placeholder="ex)12" id="inputClassDays" type="number" class="form-control">
			                   </div>
		                   	</div>
		                   	
							<div class="col-md-9">
			                   <div class="position-relative form-group">
				               		<label for="inputClassTag" class="">태그</label>
				               		<input name="tag" placeholder="ex) 21-겨울 캠프, 웹캠프" id="inputTag" type="text" class="form-control">
				               </div>
			               	</div>
	                   </div>
	                   <div class="form-group"> 
			        		<label for="inputCloseDate">강의실 게시 종료일</label>
			        		<input type="date" name="closeDate" class="form-control" id="inputCloseDate"/>
			        	</div> 
	                   <div class="form-group custom-control custom-switch">
				            <input type="checkbox" checked="" name="active" class="custom-control-input" id="customSwitch1">
				            <label class="custom-control-label" for="customSwitch1">강의실 활성화</label>
				        </div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		                <button type="submit" class="btn btn-primary" onclick="submitAddClassroom();">생성</button>
		            </div>
	            </form>
	            
	        </div>
	    </div>
	</div>
	
	<!-- setting classroom modal -->
    <div class="modal fade" id="setClassroomModal" tabindex="-1" role="dialog" aria-labelledby="setClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 설정</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form class="needs-validation was-validated" id="formEditClassroom" method="post" novalidate>
		            <input id="setClassID" name="id" type="hidden" value="">
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 이름</label> 
		               		<input name="className" id="editClassName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">강의실 이름을 입력해주세요</div>	
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editDescription" class="">강의실 설명</label>
		               		<textarea name="description" id="editDescription" class="form-control"></textarea>
		               </div>
		               <div class="form-row">
		               		<div class="col-md-3">
			                   <div class="position-relative form-group">
			                   		<label for="editClassDays" class="">강의 횟수</label>
				               		<input name="days" id="editClassDays" type="number" class="form-control">
			                   </div>
		                   	</div>
		                   	
							<div class="col-md-9">
			                   <div class="position-relative form-group">
				               		<label for="editClassTag" class="">태그</label>
				               		<input name="tag" id="editClassTag" type="text" class="form-control">
				               </div>
			               	</div>
	                   </div>
	                   
	                   <div class="form-group"> 
			        		<label for="inputCloseClassroom">강의실 게시 종료일</label>
			        		<input type="date" name="closeDate" class="form-control" id="editCloseDate"/>
			        	</div> 
			        	<div class="custom-control custom-switch">
				            <input type="checkbox" checked="" name="active" class="custom-control-input" id="customSwitch2">
				            <label class="custom-control-label" for="customSwitch2">강의실 활성화</label>
				        </div>
				    </div>
				    <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		                <button type="submit" class="btn btn-primary" data-dismiss="modal" onclick="submitEditClassroom();">수정완료</button>
		            </div>
	            </form>
	            
                   <div class="modal-body">
			        	<div class=""><h6 class="text-danger">Danger Zone - 강의실 삭제</h6></div>
			        	<div class="border border-danger p-3">
			        		<div class="position-relative form-group">
                                 <div>
                                     <div class="custom-radio custom-control">
                                     	<input type="radio" id="exampleCustomRadio" name="deleteOpt" class="custom-control-input" value="forMe">
                                     	<label class="custom-control-label" for="exampleCustomRadio">나에게만 삭제 - 학생들에게는 비공개 강의실로 보여집니다.</label>
                                     </div>
                                     <div class="custom-radio custom-control">
                                     	<input type="radio" id="exampleCustomRadio2" name="deleteOpt" class="custom-control-input" value="forAll">
                                     	<label class="custom-control-label" for="exampleCustomRadio2">모든 데이터 삭제 - 학생들에게도 강의실이 보이지 않습니다.</label>
                                     </div>
                                 </div>
                             </div>
				
                             <div class="row">
                             	<div class="col-12">
						        	<button type="button" class="btn btn-danger" onclick="submitDeleteClassroom();">강의실 삭제</button>
						        </div>
				        	</div>
                        </div>  
		            </div>
		         </div>
	        </div>
	    </div>

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
</body>
</html>
