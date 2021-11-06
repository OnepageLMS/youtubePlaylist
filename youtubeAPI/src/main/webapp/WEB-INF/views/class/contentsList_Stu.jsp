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
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
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
		var allMyClass = JSON.parse('${realAllMyClass}');
		//console.log("weekContents")
		//playlistcheck = JSON.parse('${playlistCheck}'); //progress bar를 위해 //안쓰고있음
		//playlist = JSON.parse('${playlist}'); //total 시간을 위해 //playlist테이블에서 직접 가져오면 되지 않을까 ?? //엥,, weekContents로 다 할 수 있는디..? 
		//total_runningtime = 0;
		
		var classInfo = document.getElementsByClassName( 'contents' )[0].getAttribute( 'classID' );
		
		//console.log("몇개냐면,, " + weekContents.length);
		console.log("length : " + allMyClass.length);
		console.log(allMyClass);
			for(var i=0; i<allMyClass.length; i++){
				//if(allMyClass[i].playist == 0){
					
				//}
				//var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
				var day = allMyClass[i].days;
				var endDate = allMyClass[i].endDate; //timestamp -> actural time
				var videoLength = '';
				//var result_date = convertTotalLength(date);
				//var endDate = date.getFullYear() + "." + (("00"+(date.getMonth()+1).toString()).slice(-2))+ "." + (("00"+(date.getDate()).toString()).slice(-2)) + " " + (("00"+(date.getHours()).toString()).slice(-2))+ ":" + (("00"+(date.getMinutes()).toString()).slice(-2));
				
				var symbol;
				if(allMyClass[i].playlistID == 0){ //playlist없이 description만 올림 
					symbol = '<i class="pe-7s-note2 fa-lg" > </i>'
					videoLength = '';
				}
				else{ //playlist 올림 
					symbol = '<i class="pe-7s-film fa-lg" style=" color:dodgerblue"> </i>'
					
					for(var j=0; j<weekContents.length; j++){
							if(allMyClass[i].playlistID == weekContents[j].playlistID)
							videoLength = "[" + convertTotalLength(weekContents[j].totalVideoLength) + "]";
					}
				}
				var onclickDetail = "location.href='../contentDetail/" + allMyClass[i].playlistID + "/" + allMyClass[i].id + "/" +classInfo+ "/" + i +  "'";
				
				var content = $('.day:eq(' + day + ')');
				
				content.append(
						 "<div class='content list-group-item-action list-group-item' seq='" + allMyClass[i].daySeq + "'>"
									//+ '<div class="row col d-flex justify-content-between align-items-center">'
									+ '<div class="row col d-flex align-items-center">'
										+ '<div class="index col-sm-1 ">' + (allMyClass[i].daySeq+1) + '. </div>'
										+ '<div class="videoIcon col-sm-1">' + symbol + '</div>' //playlist인지 url인지에 따라 다르게
										+ "<div class='col-sm-8 row align-items-center'  onclick=" + onclickDetail + " style='cursor: pointer;'>"
											+ "<div class='col-sm-12 card-title align-items-center' style=' height: 50%; font-size: 15px; padding: 15px 0px 0px;'>"
												+ allMyClass[i].title + " " + videoLength  
											+ '</div>'
											
											+ '<div class="col-sm-12 align-items-center" style=" height: 50%; font-size: 15px; padding: 5px 0px 0px;">'
												+ '<div class="contentInfoBorder"></div>'
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
		 	<jsp:include page="../outer_left_stu.jsp" flush="false">
		 		<jsp:param name="className" value="${className}"/>	
		 		<jsp:param name="menu"  value="contentList"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<span class="text-primary">${classInfo.className}</span> - 강의컨텐츠
                            </div>
                        </div>
                    </div>    
                            
                    <div class="row">
                       <div class="col-md-12">	 
                          <nav class="" aria-label="Page navigation example"> 
                             	 <ul class="pagination">
                             	 	<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
									<li class="page-item"><a href="#target${j}" class="page-link"> ${j}차시 </a></li>
								</c:forEach>
                             	 </ul>
                           </nav>
                       	</div>
                        
                       	<div class="contents col-sm-12" classID="${classInfo.id}">
							<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">                                
                                
                                <div class="main-card mb-3 card">
                                    <div class="card-body">
                                    	<div class="card-title" style="display: inline;" >
                                    		<a style="display: inline; white-space: nowrap;" name= "target${j}" >
											 <h5 style="display: inline; ">${j} 차시</h5>
											</a> 
                                    	</div>

	                                    <div class="list-group accordion-wrapper day" day="${status.index}">
	                                        	
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
