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
    <title>출결/학습 현황</title>
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
	
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
</head>

<style>



</style>

<script>
var takes;
var takesStudentNum = 0;
$(document).ready(function(){
	/*$.ajax({ 
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/attendance/takes",
		'data' : {
			classID : ${classInfo.id}
		},
		success : function(data){
			takes = data;
			takesStudentNum = data.length;
			console.log("성공");
			console.log(data.length);
		}, 
		error : function(err){
			alert("실패");
		}
	}); */
});
	
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false"/>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<span class="text-primary">${classInfo.className}</span> - 출석/학습현황 
                            	<button class="mb-2 mr-2 btn-transition btn btn-outline-secondary" style="float: right; margin-top:5px"> 
                                	<i class="pe-7s-add-user fa-lg" style="margin-right:5px;"> </i> 구성원 관리
                                </button>
                            </div>
                        </div>
                    </div>  
                    
                    <div class="row">
                    	<div class="col-lg-12">
                         	<div class="main-card mb-3 card">
                                    <div class="card-body"><h5 class="card-title">Table bordered</h5>
                                        <table class="mb-0 table table-bordered takes">
                                            <thead>   
                                            <tr>
                                            	<!-- <th colspan="2"> # </th>-->
                                            	<th width = "10%"> 차시 </th>
	                                            <c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
	                                                <th style="text-align:center" >${j} 차시 </th>
	                                            </c:forEach>
                                            </tr>
                                            </thead>
                                            
                                            <tbody>
                                            
	                                             <c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
		                                            <tr>
		                                                <th scope="row${status.index}">${status.index+1}. ${takes[status.index].studentName}</th>
		                                                
		                                                <c:forEach var="i" begin="0" end="${classInfo.days-1}" varStatus="status2">
		                                                	<td id = "take${status2.index}" style="text-align:center"> 0% </td>
		                                                </c:forEach>
			                                            
		                                            </tr>
	                                            </c:forEach>
                                            
                                            </tbody>
                                        </table>
                                    </div>
                        	</div>
                    	</div>
                    
                    </div>  
                            
                 <!--   <div class="row">
                    	
                    	<div class="col-sm-12">
                           <nav class="" aria-label="Page navigation example">
                           	   <button onclick='updateDays(${classInfo.id})' class="float-right mb-2 mr-2 btn btn-primary">차시 추가</button>
								
                               <ul class="pagination">
                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
										<li class="page-item"><a href="#target${j}" class="page-link"> ${j} 차시 </a></li>
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
												 <button onclick='showAddContentForm(${status.index})' class="mb-2 mr-2 btn-transition btn btn-outline-primary">+페이지추가</button>
												 <button onclick='deleteDay(${classInfo.id}, ${status.index})' class="mb-2 mr-2 btn-transition btn btn-danger float-right" style="float-right;">차시삭제</button>
												 <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="bottom-start" style="position: absolute; transform: translate3d(-207px, 33px, 0px); top: 0px; left: 0px; will-change: transform;">
	                                                <button type="button" tabindex="-1" class="dropdown-item" onclick='showAddContentForm(${status.index})'>+페이지추가</button>
	                                                <button type="button" tabindex="-1" class="dropdown-item">-페이지삭제</button>
	                                            </div> 
	                                    	</div>

		                                    <div class="list-group accordion-wrapper day" day="${status.index}">
		                                        	
		                                    </div>
	                                   </div>
	                               </div>
                                        
                                        
								</c:forEach>
						</div>

                    </div>	--> 
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	
</body>

	
</html>





