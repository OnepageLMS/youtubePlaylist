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
<title>출결/학습 현황</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
<meta name="description"
	content="This is an example dashboard created using build-in elements and components.">
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

<link href="${pageContext.request.contextPath}/resources/css/main.css"
	rel="stylesheet">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<script src="http://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
</head>

<style>
</style>

<script>
var takes;
var takesStudentNum = 0;

var attendStu = new Array();
var absentStu = new Array();
var annonyStu = new Array();
var idx = 1;
$(document).ready(function(){
	
	/*$.ajax({
		'url' : "${pageContext.request.contextPath}/getAttendance",
		'processData' : false,
		'contentType' : false,
		'data' : "hello",
		'type' : 'POST',
		success: function(data){
			
			console.log(data.length);
			console.log(data[0]);
			console.log(data[1]);
			 
		},
		error : function(err){
			alert("실패");
		},
	});*/
	
	
	$("#button").click(function(event){
		event.preventDefault();
		var form = $("#attendForm");
		var formData = new FormData(form[0]);
		formData.append("file", $("#exampleFile")[0].files[0]);
		var seq = Number($('#seq').val())+1; //추후에 +1지우기 
		console.log("seq : " + seq);
		var table = document.getElementById('takes');

		$.ajax({
			'url' : "${pageContext.request.contextPath}/test/uploadCSV",
			'processData' : false,
			'contentType' : false,
			'data' : formData,
			'type' : 'POST',
			success: function(data){
				console.log(data);
				for(var i=0; i<data[0].length; i++){
					var rows = document.getElementById("stuName").getElementsByTagName("th");
					for( var r=0; r<rows.length; r++ ){
						var name = rows[r];
						  console.log(data[0][0]);
						  if(name.innerText == data[0][i]){
						  		$(".takeZoom"+seq).eq(r).val(1).prop("selected", true); 
						  		//document.getElementsByClassName('takeZoom'+seq).style.background = "blue";
						  		break;
						  }
						  
					}
					
				}
				

				for(var i=0; i<data[1].length; i++){
					var rows = document.getElementById("stuName").getElementsByTagName("th");
					for( var r=0; r<rows.length; r++ ){
						var name = rows[r];
						 console.log("name : "  +name.innerText+ "/ " +r);
						  if(name.innerText == data[1][i]){
							  	console.log(data[1][0]);
						  		$(".takeZoom"+seq).eq(r).val(3).prop("selected", true);
						  		//document.getElementsByClassName('takeZoom'+seq).style.background = "red";
						  		//console.log("seq : " + seq + " r :" + r);
						  		break;
						  }
						  
					}
					
				}
				
				/*if(idx > 1){
					$("#showAttendance").empty();
				}*/
				
				$("#showAttendance").append('<div> 출석 ' + data[0].length + '명 / 결석 ' + data[1].length + '명 / 미확인 ' + data[2].length + '명 </div>');
				
				
				for(var i=0; i<data[0].length; i++)
					$("#showAttendance").append('<div> 출석 : ' +data[0][i] + '</div>');
				
				for(var i=0; i<data[1].length; i++)
					$("#showAttendance").append('<div> 결석 : ' +data[1][i] + '</div>');
				
				for(var i=0; i<data[2].length; i++)
					$("#showAttendance").append('<div> 미확인 : ' +data[2][i] + '</div>');
				
				$("#showAttendance").show();
				 idx ++;
				 
			},
			error : function(err){
				alert("실패");
			},
		});
	});
	
	
});

//시간에 따른 출석체크
// 정해진 시 >  학생 입장 시 
	// 정해진 시(10) < 학생 퇴장 시 (11) : 출석
	// 정해진 시 = 학생 퇴장시 : 분 확인, 
		// 정해진 분 <= 학생 퇴장 분 : 출석
		// 그렇지 않으면 : 결석 
	// 정해진 시 > 학생 퇴장 (전체 시간 확인해봐야 하는디,,)  : 우선 결석 
// 정해진 시 = 학생 입장 시 (10 = 10)
	// 분 확인, 정해진 분(5) >= 학생 입장 분(0) => 출석 
	// 그렇지 않으면 결석 
// 정해진 시 < 학생 입장 시	
	// (전체 시간 확인해봐야 하는디,,) 우선 결석 

	
function updateAttendance(days){
	//attendanceID를 알아야한다. 그러기 위해서는 classID, days, instructorID가 필요하다.
	console.log("days : " + days);
	//days의 $(".takeZoom"+seq).eq(r).val();을 리스트로 만들면되지 않을까  == //takeZoom(days+1)번째의 value들을 array에 저장하기
	var rows = document.getElementById("stuName").getElementsByTagName("th");
	var finalTakes = [];
	var days = days+1;
	console.log(rows);
	for(var i=0; i<rows.length; i++){
		console.log($(".takeZoom"+days).eq(i).val());
		//if(i==0) 
		finalTakes.push($(".takeZoom"+days).eq(i).val());
	}
	
	for(var i=0; i<finalTakes.length; i++){
		console.log(finalTakes[i]);
	}
	
	$.ajax({ 
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/whichAttendance",
		'data' : { //나중에 수정 
			classID : 1,
			instructorID : 1,
			days : days,
			finalTakes : finalTakes
		},
		success : function(data){
			attendanceID = data;
			
		}, 
		error : function(err){
			alert("실패");
		}
	});
}

/*backgroundCh = function() {
	console.log(document.getElementById('sel'));
	console.log(sel.className);
    var sel = document.getElementById('sel');
    sel.style.backgroundColor = sel.className;
};*/
	
	
</script>

<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="outer_left.jsp" flush="false">
		 		<jsp:param name="className" value="${classInfo.className}"/>	
		 		<jsp:param name="menu"  value="notice"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<span class="text-primary">${classInfo.className}</span> - 출석/학습현황 
                                <a href="javascript:void(0);" data-toggle="modal" data-target="#addStudentModal" class="nav-link editPlaylistBtn" style="display:inline;">       
	                            	<button class="mb-2 mr-2 btn-transition btn btn-outline-secondary" style="float: right; margin-top:5px"> 
	                            		
	                                		<i class="pe-7s-add-user fa-lg" style="margin-right:5px;"> </i>  구성원 관리
	                                </button>
                                </a>
                            </div>
                        </div>
                    </div>  
                    
                    <div class="row">
                    	
                    	<div class="col-lg-12">
                         	<div class="main-card mb-3 card">
                                    <div class="card-body">
                                        <table class="mb-0 table table-bordered takes">
                                            <thead>   
                                            <tr>
                                            	<!-- <th colspan="2"> # </th>-->
                                            	<th width = "10% " rowspan=2 style="padding-bottom : 20px"> 차시 </th>
	                                            <c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
	                                                <th style="text-align:center" colspan=2>${j} 차시
	                                                	<button type="button" class="btn btn-secondary" onclick="updateAttendance(${j}-1)" >업데이트</button>
	                                                 </th>
	                                            </c:forEach>
                                            </tr>
                                             
                                            <tr>
                                            	<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
                                            		<td id="zoomAttend" style="text-align:center">
                                            			<a href="javascript:void(0);" data-toggle="modal" data-target="#editAttendance" class="nav-link" style="display:inline;">
                                            				<i class="pe-7s-video" style=" color:dodgerblue"> </i>  ZOOM 
                                            			</a>
                                            		</td>
				                                    <td  id="lmsAttend" style="text-align:center"> LMS </td>
				                                </c:forEach>
                                            </tr>
                                            </thead>
                                            
                                            <tbody id = "stuName">
                                            
                                            
	                                             <c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
		                                            <tr>
		                                                <th class = "row${status.index}" scope="row${status.index}" rowspan=2>${takes[status.index].studentName}</th>
		                                                
		                                                
			                                            
		                                            </tr>
		                                            
		                                             <tr>
		                                            
		                                            	 <c:forEach var="i" begin="0" end="${classInfo.days-1}" varStatus="status2">
		                                            	 	<td style="text-align:center" > 
						                                        <select  id ="sel" class="takeZoom${status2.index+1} form-select"  aria-label="Default select example" onchange="backgroundCh();">
																  <option selected value="0">출결체크</option>
																  <option value="1" class="blue">출석</option>
																  <option value="2" class="yellow">지각</option>
																  <option value="3" class="red">결석</option>
																</select>
		                                            	 	</td>
		                                                	<td id = "takeLms${status2.index+1}" style="text-align:center"> 0% </td>
		                                                </c:forEach>
		                                            </tr>  
		                                              
		                                            
	                                            </c:forEach>
                                            
                                            </tbody>
                                        </table>
                                    </div>
                        	</div>
                    	</div>
                    
                    </div> 
                    
                   <div>
                   
	                  	<div class="main-card mb-3 card">
	                    	<div id="showAttendance" class="card-body" style="display:none"></div>
	                    </div>
                   </div>
        		</div>
        		<jsp:include page="outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	
   	
   		<!-- edit classContent modal -->
    <div class="modal fade" id="editAttendance" tabindex="-1" role="dialog" aria-labelledby="editAttendance" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editAttendanceLabel">ZOOM 출석체크</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            
	            <form id="attendForm" enctype="multipart/form-data">
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="editAttendanceSequence" class="">출석체크할 차시를 입력하세요 </label>
		               		<input name="seq" id="seq" class="form-control"  value="0"> 차시 
		               </div>
				             
				             <label for="startTime" class="">출석을 인정할 시작시간을 입력하세요</label>             
		               <div class="position-relative form-group">
		               		
		               		<input name="start" id="startTimeH" placeholder="시" class="form-control"> 
		               		<input name="start" id="startTimeM" placeholder="분" class="form-control"> 
		               </div>
		               
		               <div class="position-relative form-group">
		               		<label for="endTime" class="">출석을 인정할 마감시간을 입력하세요</label>
					      	<input name="end" id="endTimeH" placeholder="시" class="form-control"> 
					        <input name="end" id="endTimeM" placeholder="분" class="form-control"> 
		               </div>
		               
		               
					  <div class="position-relative form-group input-group">
					       <input name="file" id="exampleFile" type="file" class="form-control-file">
					  </div>
		               
		               
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		            	<button id="button" type="submit" class="mt-1 btn btn-primary" data-dismiss="modal">Submit</button>
		            </div>
	            
	           </form>
	        </div>
	    </div>
	</div>

	
</body>




</html>





