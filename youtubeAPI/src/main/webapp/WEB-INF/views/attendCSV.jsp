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
	$.ajax({ 
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
	});
	
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
			
			whoIsAttend(csvNameList, stuNameList);
			
			
		}, 
		error : function(err){
			alert("실패");
		}
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

function timeLimit(){
	var start_h = $('#startTimeH').val();
	var start_m = $('#startTimeM').val();
	var end_h = $('#endTimeH').val();
	var end_m = $('#endTimeM').val();
	
	console.log(start_h + " 시 " + start_m + "분 시작, " + end_h + " 시 " + end_m + "분 끝");
	
	for(var i=0; i<attendStu.length; i++){
		if((start_h >= csvStartH[i] && start_m >= csvStartM[i]) && (end_h <= csvEndH[i] && end_m <= csvEndM[i])){
			console.log("출석한 학생은 : " + attendStu[i]);
		}
		else{
			console.log("결석한 학생은 : " + attendStu[i]);
		}
	}
}
	
	
</script>
<body>

	<div class="row">
	
		<div class="col-md-6">
        	<div class="main-card mb-3 card">
                 <div class="card-body"><h5 class="card-title">ZOOM 출석체크 !</h5>
                      <form class="">
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
                                                   
                        <!-- <div class="position-relative form-group">
                         	<label for="exampleText" class="">Text Area</label>
                         	<textarea name="text" id="exampleText" class="form-control"></textarea>
                         </div>
                         
                         <div class="position-relative form-group">
                         	<label for="exampleFile" class="">File</label>
							<input name="file" id="exampleFile" type="file" class="form-control-file">
                                 <small class="form-text text-muted">
                                 	This is some placeholder block-level help text for the above input. It's a bit lighter and easily wraps to a new line.</small>
                         </div> --> 
                         
                         <button  type="submit" class="mt-1 btn btn-primary" onclick="timeLimit();">Submit</button>
                     </form>
                  </div>
             </div>
         </div>
	</div>

</body>


</html>





