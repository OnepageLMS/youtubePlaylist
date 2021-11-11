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
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
<meta name="msapplication-tap-highlight" content="no">
</head>
<link href="${pageContext.request.contextPath}/resources/css/main.css"
	rel="stylesheet">
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
<script>
	(function() {
		$(function() {
			var calendarEl = $('#calendar1')[0];
			// full-calendar 생성하기
			var calendar = new FullCalendar.Calendar(calendarEl, {
				height : '600px', // calendar 높이 설정
				expandRows : true, // 화면에 맞게 높이 재설정
				slotMinTime : '08:00', // Day 캘린더에서 시작 시간
				slotMaxTime : '20:00', // Day 캘린더에서 종료 시간
				// 해더에 표시할 툴바
				headerToolbar : {
					left : 'prev,next today',
					center : 'title',
					right : 'dayGridMonth,listWeek' //+ timeGridWeek,timeGridDay,
				},
				initialView : 'dayGridMonth', // 초기 로드 될때 보이는 캘린더 화면(기본 설정: 달)
				navLinks : true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
				editable : true,
				selectable : true, // 달력 일자 드래그 설정가능
				nowIndicator : true, // 현재 시간 마크
				dayMaxEvents : true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)
				locale : 'ko',
				events : function(info, callback, fail) {
					/*$.ajax({
							url: '${pageContext.request.contextPath}/calendar/getScheduleList',
							success : function(result){
									print(result);
									var events = [];
									
									if (result != null){
										$.each(result, function(index, element) {
					                           var enddate=element.enddate;
					                            if(enddate==null){
					                                enddate=element.startdate;
					                            }
					                            
					                            var startdate=moment(element.startdate).format('YYYY-MM-DD');
					                            var enddate=moment(enddate).format('YYYY-MM-DD');
					                            var realmname = element.realmname;
					                            
					                            // realmname (분야) 분야별로 color 설정
					                            if (realmname == "기타"){
					                                events.push({
					                                       title: element.title,
					                                       start: startdate,
					                                       end: enddate,
					                                          url: "${pageContext.request.contextPath }/detail.do?seq="+element.seq,
					                                          color:"#6937a1"                                                   
					                                    }); //.push()
					                            }
					                                                                
					                            else if (realmname == "무용"){
					                                events.push({
					                                       title: element.title,
					                                       start: startdate,
					                                       end: enddate,
					                                          url: "${pageContext.request.contextPath }/detail.do?seq="+element.seq,
					                                          color:"#f7e600"                                                   
					                                    }); //.push()
					                            }
					                            
					                            else if (realmname == "미술"){
					                                events.push({
					                                       title: element.title,
					                                       start: startdate,
					                                       end: enddate,
					                                          url: "${pageContext.request.contextPath }/detail.do?seq="+element.seq,
					                                          color:"#2a67b7"                                                   
					                                    }); //.push()
					                            }
					                            
					                            else if (realmname == "연극"){
					                                events.push({
					                                       title: element.title,
					                                       start: startdate,
					                                       end: enddate,
					                                          url: "${pageContext.request.contextPath }/detail.do?seq="+element.seq,
					                                          color:"#008d62"                                                   
					                                    }); //.push()
					                            }
					                            
					                       }); 
										console.log(events);
									}
									successCallback(events); 
								}
						});*/
				},
				
				eventAdd : function(obj) { // 이벤트가 추가되면 발생하는 이벤트
					console.log(obj);
				},
				eventChange : function(obj) { // 이벤트가 수정되면 발생하는 이벤트
					console.log(obj);
					
				},
				eventRemove : function(obj) { // 이벤트가 삭제되면 발생하는 이벤트
					console.log(obj);
				},
				eventClick: function() {
					
				},
			  select: function (startDate, endDate, jsEvent, view) {
				console.log(startDate, endDate);
				$('#setDate').val(startDate.startStr);
				
				$('#modal-view-event-add').modal('show');
			    /*$(".fc-body").unbind('click');
			    $(".fc-body").on('click', 'td', function (e) {

			      $("#contextMenu")
			        .addClass("contextOpened")
			        .css({
			          display: "block",
			          left: e.pageX,
			          top: e.pageY
			        });
			      return false;
			    });

			    var today = moment();

			    if (view.name == "month") {
			      startDate.set({
			        hours: today.hours(),
			        minute: today.minutes()
			      });
			      startDate = moment(startDate).format('YYYY-MM-DD HH:mm');
			      endDate = moment(endDate).subtract(1, 'days');

			      endDate.set({
			        hours: today.hours() + 1,
			        minute: today.minutes()
			      });
			      endDate = moment(endDate).format('YYYY-MM-DD HH:mm');
			    } else {
			      startDate = moment(startDate).format('YYYY-MM-DD HH:mm');
			      endDate = moment(endDate).format('YYYY-MM-DD HH:mm');
			    }

			    //날짜 클릭시 카테고리 선택메뉴
			    var $contextMenu = $("#contextMenu");
			    $contextMenu.on("click", "a", function (e) {
			      e.preventDefault();

			      //닫기 버튼이 아닐때
			      if ($(this).data().role !== 'close') {
			        newEvent(startDate, endDate, $(this).html());
			      }

			      $contextMenu.removeClass("contextOpened");
			      $contextMenu.hide();
			    });

			    $('body').on('click', function () {
			      $contextMenu.removeClass("contextOpened");
			      $contextMenu.hide();
			    });*/

			  },
				  /*select : function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
				$('#modal-view-event-add').modal('show');

				var title = prompt('Event Title:');
				if (title) {
				  calendar.addEvent({
				    title: title,
				    start: arg.start,
				    end: arg.end,
				    allDay: arg.allDay
				  })
				}
				calendar.unselect()
				}*/
			});
			// 캘린더 랜더링
			calendar.render();
		});
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
<div class="modal fade bd-example-modal-lg show" id="modal-view-event-add" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-modal="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">새로운 일정</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <form id="add-event">
	            <div class="modal-body">
	                <div class="form-group">
						<label>일정명</label> 
						<input type="text" class="form-control" name="ename">
					</div>
					<div class="form-group">
						<label>날짜</label> 
						
						<input type="date" class="datetimepicker form-control" name="date" id="setDate">
					</div>
					<div class="form-group">
						<label>메모</label>
						<textarea class="form-control" name="edesc"></textarea>
					</div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" class="btn btn-primary">등록</button>
	            </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>