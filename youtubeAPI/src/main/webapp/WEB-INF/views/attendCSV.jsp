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
var stuNameList;
var csvNameList = '';

var csvStartH = new Array();
var csvEndH = new Array();

var csvStartM = new Array();
var csvEndM = new Array();

var attendStu = new Array();

$(document).ready(function(){
	/*$.ajax({ 
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/readCSV",
		'data' : {
			
		},
		success : function(data){
			csvNameList = data;
			console.log(data);
			console.log("length : " + csvNameList.length);
			console.log("csvNameList : " +csvNameList[4][0] );
		}, 
		error : function(err){
			alert("실패");
		}
	});*/
	
	$.ajax({ 
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/attendance/takes",
		'data' : {
			classID : 1
		},
		success : function(data){
			console.log("성공");
			//console.log(data);
			console.log(data);
			
			stuNameList = new Array();
			
			for(var i=0; i<data.length; i++)
				stuNameList.push(data[i].studentName);
			
			for(var i=0;i<stuNameList.length;i++)
			    console.log("잘들어옴!" + stuNameList[i]);
			
		}, 
		error : function(err){
			alert("실패");
		}
	});
	
	$("#button").click(function(event){
		event.preventDefault();
		var form = $("#attendForm");
		var formData = new FormData(form[0]);
		formData.append("file", $("#exampleFile")[0].files[0]);

		$.ajax({
			'url' : "${pageContext.request.contextPath}/uploadCSV",
			'processData' : false,
			'contentType' : false,
			'data' : formData,
			'type' : 'POST',
			success: function(data){
				csvNameList = data;
				alert(data);
				console.log(data);

				whoIsAttend(csvNameList, stuNameList);
				console.log("whoIsAttend실행 ");
				timeLimit();
			},
			error : function(err){
				alert("실패");
			}
		});
	});
	
	
});


function whoIsAttend(csv, stu){
	
	console.log("들어오긴 하니...?");
	console.log("length : " + csv.length + " length : " + stu.length);
	
	for(var i=4; i<csv.length; i++){ //i를 4부터 하는 이유는, zoom csv에서 학생 이름이 idx 4번째부터 있기 때문이다..
		for(var j=0; j<stu.length; j++){

			if(csv[i][0].indexOf(stu[j]) != -1){ //csv파일에 학생 이름이 있을경우 
				attendStu.push(stu[j]); //출석한 학생을 나타내는 배열에 학생 이름 추가 
			
				//학생의 출석시간을 배열에 추가 추후에 시간 비교를 위함
				csvStartH.push(csv[i][2][11] + csv[i][2][12]); 
				csvEndH.push(csv[i][3][11] + csv[i][3][12]);
				
				csvStartM.push(Number("" + csv[i][2][14] + csv[i][2][15]));
				csvEndM.push(Number("" + csv[i][3][14] + csv[i][3][15]));
				
			}
			else {
				continue;
			}
		}
	}
	
	
	
	/*for(var i=0; i<attendStu.length; i++){
		console.log("출석한 학생은 말이지 " + attendStu[i]); 
	}
	
	for(var i=0; i<csvStartH.length; i++){
		console.log("시작 : " +csvStartH[i] + " : "  +csvStartM[i]); 
		console.log(" 끝 : " +csvEndH[i] + " : "  +csvEndM[i]);
	}*/
	
}

function timeLimit(){ //지금은 오전 10시와 오후 1시에 대해서는 시간비교가 잘 안되고 있다. 
	console.log("들어옴!");
	var start_h = $('#startTimeH').val(); // 10
	var start_m = $('#startTimeM').val(); // 5
	var end_h = $('#endTimeH').val(); // 11
	var end_m = $('#endTimeM').val(); // 15  
	var seq = $('#seq').val();
	
	console.log(start_h + " 시 " + start_m + "분 시작, " + end_h + " 시 " + end_m + "분 끝" + "차시 : " + seq);
	
	
	var rows = document.getElementById("stuName").getElementsByTagName("th");
	console.log("rows.length : " + rows.length);
		
	for(var i=0; i<attendStu.length; i++){
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
			
		if(start_h > csvStartH[i] ) {
			if(end_h < csvEndH[i]) {
				console.log("1. 출석한 학생은 : " + attendStu[i]);
			}
			else if(end_h == csvEndH[i]){
				if(end_m <= csvEndM[i]) {
					
					var rows = document.getElementById("stuName").getElementsByTagName("th");
					console.log("rows.length : " + rows.length);
					
					for( var r=0; r<rows.length; r++ ){
					      var name = rows[r];
						  console.log(name.innerText);
						  
						  if(name.innerText == attendStu[i]){
						  		$(".takeZoom"+seq).eq(r).val(1).prop("selected", true); 
						  		break;
						  }
						  console.log(name.data);

					}
					
					
				}
				else {
					console.log("결석한 학생은 : " + attendStu[i]);
				}
			}
			else{
				console.log("결석한 학생은 : " + attendStu[i]);
			}
		}
		else if(start_h == csvStartH[i]){
			if(start_m >= csvStartM[i]) console.log("3. 출석한 학생은 : " +  attendStu[i]);
			else {

				var rows = document.getElementById("stuName").getElementsByTagName("th");
				console.log("rows.length : " + rows.length);
				
				for( var r=0; r<rows.length; r++ ){
				      var name = rows[r];
					  console.log(name.innerText);
					  
					  if(name.innerText == attendStu[i]){
					  		$(".takeZoom"+seq).eq(r).val(3).prop("selected", true); 
					  		break;
					  }
					  console.log(name.data);

				}
				
			}
		}
		else{
			console.log("결석한 학생은 : " + attendStu[i]);
		}
			
		
	}
}
	
	
</script>
<body>

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
	
						<div class="col-md-3">
				        	<div class="main-card mb-3 card">
				                 <div class="card-body"><h5 class="card-title">ZOOM 출석체크 !</h5>
				                      <form id="attendForm" enctype="multipart/form-data">
				                      	  <label for="startTime" class="">출석체크할 차시를 입력하세요 </label>
				                          <div class="position-relative form-group input-group">
				                          	<input name="seq" id="seq" class="form-control"  value="0"> 차시 
				                          </div>
				                          
				                      	  <label for="startTime" class="">출석 인정시간을 입력하세요 </label>
				                          <div class="position-relative form-group input-group">
				                          	<input name="start" id="startTimeH" placeholder="시" class="form-control"  value="0"> 시
				                          	<input name="start" id="startTimeM" placeholder="분" class="form-control"  value="0"> 분
				                          </div>
				                          
				                          <label for="endTime" class="">출석 마감시간을 입력하세요 </label>
				                          <div class="position-relative form-group input-group">
				                          	<input name="end" id="endTimeH" placeholder="시" class="form-control"  value="0"> 시
				                          	<input name="end" id="endTimeM" placeholder="분" class="form-control"  value="0"> 분
				                          </div>
				                          
				                           <div class="position-relative form-group input-group">
				                           	<input name="file" id="exampleFile" type="file" class="form-control-file">
				                           </div>
			
				                         
				                         <button id="button" type="submit" class="mt-1 btn btn-primary">Submit</button>
				                     </form>
				                  </div>
				             </div>
				         </div>
                    	
                    	
                    	<div class="col-lg-9">
                         	<div class="main-card mb-3 card">
                                    <div class="card-body">
                                        <table class="mb-0 table table-bordered takes">
                                            <thead>   
                                            <tr>
                                            	<!-- <th colspan="2"> # </th>-->
                                            	<th width = "10% " rowspan=2 style="padding-bottom : 20px"> 차시 </th>
	                                            <c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
	                                                <th style="text-align:center" colspan=2>${j} 차시 </th>
	                                            </c:forEach>
                                            </tr>
                                            
                                            <tr>
                                            	<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
                                            		<td id="zoomAttend" style="text-align:center">
                                            			<i class="pe-7s-video" style=" color:dodgerblue"> </i>  ZOOM 
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
						                                        <select  class="takeZoom${status2.index+1} form-select"  aria-label="Default select example">
																  <option selected>출결체크</option>
																  <option value="1">출석</option>
																  <option value="2">지각</option>
																  <option value="3">결석</option>
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
        		</div>
        		<jsp:include page="outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>

	
</body>


</html>





