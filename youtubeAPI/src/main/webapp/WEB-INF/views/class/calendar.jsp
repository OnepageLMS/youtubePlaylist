<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Language" content="en">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>강의 캘린더</title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
	<meta name="msapplication-tap-highlight" content="no">
	
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css'rel='stylesheet' />
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
	<script src="https://cdn.jsdelivr.net/npm/@fullcalendar/interaction@4.2.0/main.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>

<script>
	(function() {
		$(function() {
			var calendarEl = $('#calendar1')[0];
			var calendar = new FullCalendar.Calendar(calendarEl, {
				height : '600px', 
				expandRows : true, 
				slotMinTime : '08:00', 
				slotMaxTime : '20:00', 
				headerToolbar : {
					left : 'prev,next today',
					center : 'title',
					right : 'dayGridMonth,listWeek'
				},
				initialView : 'dayGridMonth', 
				navLinks : true, 
				editable : true,
				selectable : true, 
				nowIndicator : true, 
				dayMaxEvents : true, 
				locale : 'ko',
				events : function(info, callback, fail) {
					$.ajax({
							url: '${pageContext.request.contextPath}/calendar/getScheduleList/' + '${classID}',
							method: 'get',
							success : function(result){
									var events = [];
									
									if (result != null){
										$.each(result, function(index, element) {	
				                           	var date=moment(element.date).format('YYYY-MM-DD');
			                                events.push({
				                                   id: element.id,
			                                       title: element.name,
			                                       start: date,
			                                       description: element.memo
			                                       //url: "${pageContext.request.contextPath}/detail.do?seq="+element.seq
			                                       //color:"#6937a1"                                                   
			                                    });
		                                    //memo.append()
					                            
					                       }); 
									}
									callback(events); 
								}
						});
				},
				/*eventAdd : function(obj) { // 이벤트가 추가되면 발생하는 이벤트
					//console.log(obj);
				},*/
				eventDrop: function(arg){
					  //updateModalOpen(arg);		
				 },
				eventChange : function(obj) { // 이벤트가 수정되면 발생하는 이벤트
					//console.log(obj);
				},
				eventRemove : function(obj) { // 이벤트가 삭제되면 발생하는 이벤트
					//console.log(obj);
				},
				eventClick: function(obj) {	//기존 이벤트 보기
					udpateEventModal(obj);
				},
			  select: function (startDate, endDate, jsEvent, view) {	//하나 혹은 드래그 해서 일정을 선택했을 때 
				$('#eventForm')[0].reset();
				$('#modalTitle').text('새로운 일정 등록');
				$('#setDate').val(startDate.startStr);
				$('#setEventModal').modal('show');
			  },
			});
			// 캘린더 랜더링
			calendar.render();
		});
	})();

	function udpateEventModal(obj){
		$('#modalTitle').text('일정 수정');
		$('#setID').val(obj.event.id);
		$('#setName').val(obj.event.title);
		$('#setDate').val(obj.event.startStr);
		$('#setMemo').val(obj.event.extendedProps.description);
		$('#setEventModal').modal('show');
	}

	function setEvent(){
		if($('#setName').val() == '' || $('#setName').val() == null) return;

		if($('#setID').val() != '' && $('#setID').val() != null){
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/calendar/updateEvent',
				data: $('#eventForm').serialize(),
				datatype: 'json',
				success: function(data){
					console.log('event 수정 성공');
					location.reload();	//이부분 바꾸기
				},
				error: function(data, status,error){
					alert('event 수정 실패!');
				}
			});
		}
		else {
			$('#setID').val(0);
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/calendar/insertEvent',
				data: $('#eventForm').serialize(),
				success: function(data){
					console.log('event 생성 성공');
					location.reload();	//이부분 바꾸기
				},
				error: function(data, status,error){
					alert('event 생성 실패!');
				}
			});
		}
		  return false;
	}

	function deleteEvent(){
		if(confirm('일정을 삭제하시겠습니까?')){
			
		}
	}
</script>
<script>
// Disable form submissions if there are invalid fields
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Get the forms we want to add validation styles to
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
<style>
.fc-daygrid-event-harness {
	overflow: hidden;
}
</style>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top.jsp" flush="false" />

		<div class="app-main">
			<jsp:include page="../outer_left.jsp" flush="false">
				<jsp:param name="className" value="${className}" />
				<jsp:param name="menu" value="calendar" />
			</jsp:include>

			<div class="app-main__outer">
				<div class="app-main__inner">
					<div class="app-page-title">
						<div class="page-title-wrapper">
							<div class="page-title-heading mr-3">
								<h4>
									<span class="text-primary displayClassName">${className}</span>
									- 강의 캘린더
								</h4>
							</div>
						</div>
					</div>
					<div class="main-card mb-3 card">
						<div class="card-body">
							<div class="calendar-wrap">
								<div id="calendar1"></div>

							</div>
						</div>
					</div>

					<jsp:include page="../outer_bottom.jsp" flush="false" />
				</div>
			</div>
		</div>
	</div>

<!-- 이벤트 생성 modal -->
<div class="modal fade show" id="setEventModal" tabindex="-1" role="dialog" aria-modal="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">새로운 일정</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <form id="eventForm" class="needs-validation" method="post" novalidate>
	            <div class="modal-body">
	            	<input type="hidden" name="id" id="setID">
	            	<input type="hidden" name="classID" id="setClassID" value="${classID}">
	            	
	                <div class="form-group">
						<label>일정명</label> 
						<input type="text" class="form-control" name="name" id="setName" required>
						<div class="invalid-feedback">일정명을 입력해 주세요</div>
					</div>
					<div class="form-group">
						<label>날짜</label> 
						<input type="date" class="datetimepicker form-control" name="date" id="setDate" required>
					</div>
					<div class="form-group">
						<label>메모</label>
						<textarea class="form-control" name="memo" id="setMemo"></textarea>
					</div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" class="btn btn-primary" onclick="setEvent();">등록</button>
	            </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>