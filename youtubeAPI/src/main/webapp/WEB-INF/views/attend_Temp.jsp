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
	<button class="mb-2 mr-2 btn-transition btn btn-outline-secondary"
		data-toggle="modal" data-target="#addStudentModal"
		style="float: right; margin-top: 5px">
		<i class="pe-7s-add-user fa-lg" style="margin-right: 5px;"> </i> 구성원
		관리
	</button>

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
						<button id="modalSubmit" type="button"
							class="btn-transition btn btn-outline-secondary" onclick="#">구성원
							추가</button>

						<ul class="list-group">

							<%-- <c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
                            		
                            		<li class="list-group-item" style="padding-top : 5px; padding-bottom: 30px">
                            			<i class="pe-7s-close fa-lg" style="margin-right:30px"> </i>
                            			${takes[status.index].studentName}
                            		</li>
	                            </c:forEach> --%>
	                        <p class="text-primary mt-3"> 허락 대기중 인원 </p>
							<li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
										<i class="pe-7s-close fa-lg" style="margin-right: 30px"> </i>
									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0">이진우</p>
											<p class="col-sm-12 mb-0">jinwoo@gmail.com</p>
										<p class="col-sm-12 mb-0">010-8687-5813</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-primary"> 추가 </button></div>
								</div>	
							</li>
							
							<li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
										<i class="pe-7s-close fa-lg" style="margin-right: 30px"> </i>
									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0"> 조하영 </p>
											<p class="col-sm-12 mb-0">hayeong@gmail.com</p>
										<p class="col-sm-12 mb-0">010-3588-7863</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-primary"> 추가 </button></div>
								</div>	
							</li>
							
							<li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
										<i class="pe-7s-close fa-lg" style="margin-right: 30px"> </i>
									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0"> 홍길동 </p>
											<p class="col-sm-12 mb-0">gildong@gmail.com</p>
										<p class="col-sm-12 mb-0">010-1234-9999</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-primary"> 추가 </button></div>
								</div>	
							</li>
							
							
							
							 <p class="text-primary mt-3"> 등록된 인원 </p>
							 <li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">

									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0">이용철 </p>
											<p class="col-sm-12 mb-0">jinwoo@gmail.com</p>
										<p class="col-sm-12 mb-0">010-8571-1453</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-danger"> 삭제  </button></div>
								</div>	
							</li>
							
							<li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
										
									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0"> 김하늘 </p>
											<p class="col-sm-12 mb-0">sky@gmail.com</p>
										<p class="col-sm-12 mb-0">010-4568-7863</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-danger"> 삭제  </button></div>
								</div>	
							</li>
							
							<li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
										
									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0"> 박주원 </p>
											<p class="col-sm-12 mb-0">joowon@naver.com</p>
										<p class="col-sm-12 mb-0">010-7895-6677</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-danger"> 삭제  </button></div>
								</div>	
							</li>
							
							<li class="list-group-item d-sm-inline-block"
								style="padding-top: 5px; padding-bottom: 30px">
								
								<div class="row">
									<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
										
									</div>
									<div class="titles col-sm-8 ">
										<div class="row">
											<p class="col-sm-12 mb-0"> 박다인 </p>
											<p class="col-sm-12 mb-0">allin@gmail.com</p>
										<p class="col-sm-12 mb-0">010-9988-7766</p></div>
									</div>
									<div class="col-sm-2"><button class="btn btn-transition btn-danger"> 삭제  </button></div>
								</div>	
							</li>

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


</body>


</html>




