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
    <title>강의 캘린더</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
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
</head>

<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<script>
  (function(){
    $(function(){
      var calendarEl = $('#calendar1')[0];
      // full-calendar 생성하기
      var calendar = new FullCalendar.Calendar(calendarEl, {
        height: '600px', // calendar 높이 설정
        expandRows: true, // 화면에 맞게 높이 재설정
        slotMinTime: '08:00', // Day 캘린더에서 시작 시간
        slotMaxTime: '20:00', // Day 캘린더에서 종료 시간
        // 해더에 표시할 툴바
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        },
        initialView: 'dayGridMonth', // 초기 로드 될때 보이는 캘린더 화면(기본 설정: 달)
        navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
        editable: true, 
        selectable: true, // 달력 일자 드래그 설정가능
        nowIndicator: true, // 현재 시간 마크
        dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)
        locale: 'ko',
        events: function (info, callback, fail){
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
        eventClick: function() {
			jQuery('#modal-view-event-add').modal();
		},
        eventAdd: function(obj) { // 이벤트가 추가되면 발생하는 이벤트
          console.log(obj);
        },
        eventChange: function(obj) { // 이벤트가 수정되면 발생하는 이벤트
          console.log(obj);ƒm
        },
        eventRemove: function(obj){ // 이벤트가 삭제되면 발생하는 이벤트
          console.log(obj);
        },
        select: function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
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
        }
      });
      // 캘린더 랜더링
      calendar.render();
    });
  })();
</script>
<style>
	.fc-daygrid-event-harness{
		overflow: hidden;
	}
</style>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false">
		 		<jsp:param name="className" value="${className}"/>	
		 		<jsp:param name="menu"  value="calendar"/>
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
                   
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
        		</div>
	   		</div>
	   	</div>
   	</div>
   	<!-- calendar modal -->
<div id="modal-view-event" class="modal modal-top fade calendar-modal">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body">
					<h4 class="modal-title"><span class="event-icon"></span><span class="event-title"></span></h4>
					<div class="event-body"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

<div id="modal-view-event-add" class="modal modal-top fade calendar-modal">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form id="add-event">
        <div class="modal-body">
        <h4>Add Event Detail</h4>        
          <div class="form-group">
            <label>Event name</label>
            <input type="text" class="form-control" name="ename">
          </div>
          <div class="form-group">
            <label>Event Date</label>
            <input type='text' class="datetimepicker form-control" name="edate">
          </div>        
          <div class="form-group">
            <label>Event Description</label>
            <textarea class="form-control" name="edesc"></textarea>
          </div>
          <div class="form-group">
            <label>Event Color</label>
            <select class="form-control" name="ecolor">
              <option value="fc-bg-default">fc-bg-default</option>
              <option value="fc-bg-blue">fc-bg-blue</option>
              <option value="fc-bg-lightgreen">fc-bg-lightgreen</option>
              <option value="fc-bg-pinkred">fc-bg-pinkred</option>
              <option value="fc-bg-deepskyblue">fc-bg-deepskyblue</option>
            </select>
          </div>
          <div class="form-group">
            <label>Event Icon</label>
            <select class="form-control" name="eicon">
              <option value="circle">circle</option>
              <option value="cog">cog</option>
              <option value="group">group</option>
              <option value="suitcase">suitcase</option>
              <option value="calendar">calendar</option>
            </select>
          </div>        
      </div>
        <div class="modal-footer">
        <button type="submit" class="btn btn-primary" >Save</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>        
      </div>
      </form>
    </div>
  </div>
  </div>
</body>
</html>
