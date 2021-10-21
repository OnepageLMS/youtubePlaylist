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
	$("#addStudentModal").on("hidden.bs.modal", function () {
		console.log("hi there");
		$('.entryCode').hide();
	});
});

function displayEntryCode(){
	$('.entryCode').show();
}

function copyToClipboard(element) {
	 navigator.clipboard.writeText($(element).text());
}

function updateStudent(obj){
	/* var studentID = $(obj).parent().parent().children(); */
	var studentID = $(obj).closest("div.row").find("input[id='studentID']").val();
	console.log("check studentID ==>" , studentID);
	/* $.ajax({
		'type' : "POST"
		'url' : $ 
	}); */
}

	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false">
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
	                                                <th style="text-align:center" colspan=2>${j} 차시 </th>
	                                            </c:forEach>
                                            </tr>
                                            
                                            <tr>
                                            	<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
                                            		<td style="text-align:center"><i class="pe-7s-video" style=" color:dodgerblue"> </i>  ZOOM </td>
				                                    <td style="text-align:center"> LMS </td>
				                                </c:forEach>
                                            </tr>
                                            </thead>
                                            
                                            <tbody>
                                            
                                            
	                                             <c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
		                                            <tr>
		                                                <th scope="row${status.index}" rowspan=2>${status.index+1}. ${takes[status.index].studentName}</th>
		                                                
		                                                
			                                            
		                                            </tr>
		                                            
		                                             <tr>
		                                            
		                                            	 <c:forEach var="i" begin="0" end="${classInfo.days-1}" varStatus="status2">
		                                            	 	<td id = "take${status2.index}" style="text-align:center" > 출석 </td>
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
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
	 
	<div class="modal fade" id="addStudentModal" tabindex="-1"
		role="dialog" aria-labelledby="editContentModal" aria-hidden="true"
		style="display: none;">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editContentModalLabel">구성원 관리</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">


					<div class="card-body" style="overflow-y: auto; height: 600px;">
						<div class="row">
							<div class="col-md-2 pr-0">
								<button id="modalSubmit" type="button"
								class="btn-transition btn btn-outline-secondary" onclick="displayEntryCode();">구성원
								추가</button>
							</div>
							<div class="entryCode col-md-8" style="position:relative; display:none;">
								<span id=link style="position: absolute; margin: 0; top:20%;"> 초대링크: www.onepageLMS.com/${classInfo.entryCode} </span>
								<div class="entryCode float-right" style="display:none;">
									<button class="btn btn-transition btn-primary" onclick="copyToClipboard('#link')" data-container="body" data-toggle="popover" data-placement="bottom" data-content="링크가 복사되었습니다!"> 복사하기 </button>
								</div>
							</div>
							
						</div>
						

						<ul class="list-group">
							<p class="text-primary mt-3"> 허락 대기중 인원 </p>
							<c:forEach var="person" items="${studentInfo}" varStatus="status">
                            	<c:if test="${person.status == 'pending'}" >
                            		<li class="list-group-item d-sm-inline-block"  
										style="padding-top: 5px; padding-bottom: 30px">
										<div class="row">
											<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
												<i class="pe-7s-close fa-lg" style="margin-right: 30px"> </i>
											</div>
											<div class="titles col-sm-8 ">
												<div class="row">
													<input type="hidden" id='studentID' value="${person.studentID }" />
													<p class="col-sm-12 mb-0">${person.studentName} </p>
													<p class="col-sm-12 mb-0">${person.email} </p>
													<p class="col-sm-12 mb-0">${person.phone }</p>
												</div>
											</div>
											<div class="col-sm-2"><button class="btn btn-transition btn-primary" onclick="updateStudent(this);"> 추가 </button></div>
										</div> 
                            		</li> 
                            	</c:if>
	                        </c:forEach>  							
							
							 <p class="text-primary mt-3"> 등록된 인원 </p>
							 <c:forEach var="person" items="${studentInfo}" varStatus="status">
							 	<c:if test="${person.status == 'accepted'}" >
							 		<li class="list-group-item d-sm-inline-block"
									style="padding-top: 5px; padding-bottom: 30px"> 
										<div class="row">
											<div class="thumbnailBox col-sm-1 row ml-1 mr-1"></div>
											<div class="titles col-sm-8 ">
											<div class="row">
												<p class="col-sm-12 mb-0">${person.studentName } </p>
												<p class="col-sm-12 mb-0">${person.email } </p>
												<p class="col-sm-12 mb-0">${person.phone } </p></div>
											</div>
											<div class="col-sm-2"><button class="btn btn-transition btn-danger"> 삭제  </button></div>
										</div>	
									</li>
								</c:if>
							</c:forEach>
							</ul>
					</div>
				</div>
				<!-- <div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary">저장</button>
				</div> -->
			</div>
		</div>
	</div>
	
	<%-- <!-- 하영이가 원래 해놓은 부분 -->
   <div class="modal fade" id="addStudentModal" tabindex="-1" role="dialog" aria-labelledby="editContentModal" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editContentModalLabel">구성원 관리</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
                        <div class="card-body" style="overflow-y:auto; height:600px;">
                            <ul class="list-group">
                            	<c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
                            		<li class="list-group-item" style="padding-top : 5px; padding-bottom: 30px">
                            			<i class="pe-7s-close fa-lg" style="margin-right:30px"> </i>
                            			${takes[status.index].studentName}
                            		</li>
	                            </c:forEach>
                            </ul>
                        </div>
	            </div>
	            <div class="modal-footer">
	                <button id="modalSubmit" type="button" class="btn-transition btn btn-outline-secondary" onclick="#">구성원 추가</button>
	            </div>
	        </div>
	    </div>
	</div> --%>
	
    <%-- <div class="modal fade" id="addStudentModal" tabindex="-1" role="dialog" aria-labelledby="editContentModal" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editContentModalLabel">구성원 관리</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
                        <div class="card-body" style="overflow-y:auto; height:600px;">
                            <ul class="list-group">
                            	<!-- 이 부분에서 ${takes[status.index].status} == accepted \\ pending 인지에 따라 따로 구분하여
                            	보여질 수 있도록 하기 . foreach문을ㅡ 2개 만들어서 위에는 pending,. 아래는 accpeted하면 될듯. -->
                            	<c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
                            		<li class="list-group-item" style="padding-top : 5px; padding-bottom: 30px">
                            			<i class="pe-7s-close fa-lg" style="margin-right:30px"> </i>
                            			${takes[status.index].studentName}
                            		</li>
	                            </c:forEach>
                            </ul>
                        </div>
	            </div>
	            <div class="modal-footer">
	                <button id="modalSubmit" type="button" class="btn-transition btn btn-outline-secondary" onclick="#">구성원 추가</button>
	            </div>
	        </div>
	    </div>
	</div> --%>
   	
</body>

	
</html>





