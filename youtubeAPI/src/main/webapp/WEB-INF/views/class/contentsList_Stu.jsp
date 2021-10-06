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
    <title>Example</title>
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
</head>
<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
<script>
	var playlistcheck;
	var playlist;
	var total_runningtime;
	
	$(document).ready(function(){
		
		var weekContents = JSON.parse('${weekContents}');
		//console.log("weekContents")
		//playlistcheck = JSON.parse('${playlistCheck}'); //progress bar를 위해 //안쓰고있음
		//playlist = JSON.parse('${playlist}'); //total 시간을 위해 //playlist테이블에서 직접 가져오면 되지 않을까 ?? //엥,, weekContents로 다 할 수 있는디..? 
		//total_runningtime = 0;
		
		var classInfo = document.getElementsByClassName( 'contents' )[0].getAttribute( 'classID' );
		
		//console.log("몇개냐면,, " + weekContents.length);
	 		for(var i=0; i<weekContents.length; i++){
				var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
				var day = weekContents[i].days;
				var date = new Date(weekContents[i].endDate.time); //timestamp -> actural time
				var result_date = convertTotalLength(date);
				var endDate = date.getFullYear() + "." + (("00"+(date.getMonth()+1).toString()).slice(-2))+ "." + (("00"+(date.getDate()).toString()).slice(-2)) + " " + (("00"+(date.getHours()).toString()).slice(-2))+ ":" + (("00"+(date.getMinutes()).toString()).slice(-2));
				
				
				var onclickDetail = "location.href='../contentDetail/" + weekContents[i].playlistID + "/" +weekContents[i].id + "/" +classInfo+ "/" + i +  "'";
				
				var content = $('.day:eq(' + day + ')');
				
				content.append(
						
						 "<div class='list-group-item' seq='" + weekContents[i].daySeq + ">"
									+ '<div class="row">'
										+ '<div class="index col-sm-1 text-center">' + (weekContents[i].daySeq+1) + '. </div>'
										+ '<div class="videoIcon col-sm-1">' + '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; color:dodgerblue;"></i>' + '</div>'
										+ "<div class='col-sm-7 row' onclick=" + onclickDetail + " style='cursor: pointer;'>"
											+ "<div class='col-sm-12'>"
												+ weekContents[i].title  + '  [' + weekContents[i].totalVideo + ']' 
											+ '</div>'
											+ '<div class="col-sm-12">'
													+ '<p class="contentInfo">' + 'Youtube' + '</p>'
													+ '<div class="contentInfoBorder"></div>'
													+ '<p class="videoLength contentInfo"">' + convertTotalLength(weekContents[i].totalVideoLength) + '</p>'
													+ '<div class="contentInfoBorder"></div>'
													+ '<p class="endDate contentInfo"">' + '마감일: ' + endDate + '</p>'
											+ '</div>' 
										+ '</div>'
									+ '</div>'
								+ '</div>');
				}
	 		
	});
	
	function convertTotalLength(seconds){
		var seconds_hh = Math.floor(seconds / 3600);
		var seconds_mm = Math.floor(seconds % 3600 / 60);
		var seconds_ss = Math.floor(seconds % 3600 % 60);
		var result = "";
		
		if (seconds_hh > 0)
			result = ("00"+seconds_hh .toString()).slice(-2)+ ":";
		result += ("00"+seconds_mm.toString()).slice(-2) + ":" + ("00"+seconds_ss .toString()).slice(-2) ;
		
		return result;
	}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top_stu_temp.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left_stu.jsp" flush="false"/>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	${classInfo.className}	<!-- 이부분 이름 바꾸기!! -->
                            </div>
                        </div>
                    </div>    
                            
                    <div class="row">
                       <div class="col-md-12">	 
                          <nav class="" aria-label="Page navigation example"> 
                             	 <ul class="pagination">
                             	 	<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
									<li class="page-item"><a href="#target${j}" class="page-link"> ${j} </a></li>
								</c:forEach>
                             	 </ul>
                           </nav>
                       	</div>
                        
                       	<div class="contents col-sm-12" classID="${classInfo.id}">
							<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
								<!-- <div class="day card list-group list-group-flush" day="${status.index}">
									 <div class="card-header lecture">
										   <a style="display: inline;" name= "target${j}">${j} 차시</a>  
											
									</div>
								</div>-->
								
								<!--  <div class="main-card mb-3 card">
                                	<div class="card-header">
                                		<a style="display: inline;" name= "target${j}">${j} 차시</a> 
                                	</div>
                                    <div class="card-body day" day="${status.index}">
                                        	
                                    </div>
                                </div>-->
                                
                                
                                <div class="main-card mb-3 card">
                                    <div class="card-body">
										<a style="display: inline;" name= "target${j}"><h5> ${j} 차시 </h5></a> 
	                                    <div class="list-group day" day="${status.index}">
	                                        	
	                                    </div>
                                   </div>
                               </div>
                                        
                                        
							</c:forEach>
						</div>
                    	<!-- 여기 기존 jsp파일 내용 넣기 -->
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
</body>
</html>
