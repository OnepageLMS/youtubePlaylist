<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Notice</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="description" content="This is an example dashboard created using build-in elements and components.">
    <meta name="msapplication-tap-highlight" content="no">
	
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> 
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
</head>
<style>
	.text-black{
		color: #495057;
	}
</style>
<script>
	var classID = ${classID};
	var notices;
	
	$(document).ready(function(){
		getAllPin();
	});

	function getAllPin(){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/getAllPin',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				$('.noticeList').empty();

				$.each(data, function( index, value){
					var collapseID = "collapse" + index;
					var regDate = value.regDate.split(" ")[0];
					var important = value.important;
					var viewCheck = value.studentID;	//학생이 읽지 않은 공지는 색상 다르게
					var viewdClass = '';
					var updateView = '';

					if (important == 1)	important = '<span class="text-danger"> [중요] </span>';	//지금 사용안하는 버전
					else important = '';
					
					if (viewCheck == 0 || viewCheck == null) {
						viewCheck = '<span class="badge badge-primary viewCheck">NEW</span>';
						updateView = 'onclick="updateView(' + index + ',' + value.id + ');" ';
					}
					else {
						viewCheck = '';
						viewdClass = 'viewClass';
					}

					var html = '<div class="col-md-12 col-lg-10 col-sm-12 col-auto ">'
						+ '<div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">'
							+ '<div class="card">'
								+ '<div id="headingOne" class="card-header">'
									+ '<button type="button" ' + updateView + 'class="col-9 text-left m-0 p-0 btn btn-link btn-block collapsed" '
													+ 'data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne">'
										+ '<h5 class="title m-0 p-0 ' + viewdClass + '" id="' + value.id + '"><i class="pe-7s-pin"></i> ' + value.title + viewCheck + '</h5>'
									+ '</button>'
									+ '<div>작성일 ' + regDate + '</div>'
								+ '</div>'
								+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
									+ '<div class="card-body">' + value.content + '</div>'
								+ '</div>'
							+ '</div>'
						+ '</div>'
					+ '</div>';

					$('.noticeList').append(html);
				});
				getAllNotices(data.length);
			}
		});
	}

	function getAllNotices(last){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/getAllNotice',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				notices = data.notices;

				if (notices.length == 0) 
					$('.noticeList').append('게시된 공지사항이 없습니다.');

				else {
					$.each(notices, function(idx, value){
						var index = last + idx;
						var collapseID = "collapse" + index;
						var regDate = value.regDate.split(" ")[0];
						var important = value.important;
						var viewCheck = value.studentID;	//학생이 읽지 않은 공지는 색상 다르게
						var updateView = '';
						var viewdClass = '';
						
						if (important == 1)	important = '<span class="text-danger"> [중요] </span>';
						else important = '';
						
						if (viewCheck == 0 || viewCheck == null) {
							updateView = 'onclick="updateView(' + index + ',' + value.id + ');" ';
							viewCheck = '<span class="badge badge-primary viewCheck">NEW</span>';
						}
						else {
							viewCheck = '';
							viewdClass = 'viewClass';
						}
						var html = '<div class="col-md-12 col-lg-10 col-sm-12 col-auto ">'
							+ '<div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">'
								+ '<div class="card">'
									+ '<div id="headingOne" class="card-header">'
										+ '<button type="button" ' + updateView + 'class="col-9 text-left m-0 p-0 btn btn-link btn-block collapsed" '
														+ 'data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne">'
											+ '<h5 class="title text-black m-0 p-0 ' + viewdClass + '" id="' + value.id + '">' + value.title + viewCheck + '</h5>'
										+ '</button>'
										+ '<div>작성일 ' + regDate + '</div>'
									+ '</div>'
									+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
										+ '<div class="card-body">' + value.content + '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
						+ '</div>';

						$('.noticeList').append(html);
					});
				}
			},
			error: function(data, status,error){
				alert('공지 가져오기 실패!');
			}
		});
	}

	function updateView(index, noticeID){
		if($('.title:eq(' + index + ')').hasClass('viewdClass') == true) 
			return false;
		
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/insertView',
			data: {noticeID: noticeID},
			datatype: 'json',
			success: function(data){
				console.log('update view 완료!');
					$('.title:eq(' + index + ')').addClass('viewdClass');

					var element = $('.title:eq(' + index + ')');
					$('.title:eq(' + index + ')').children('span').remove();
					
					var elements = $('.title');
					$.each(elements, function(idx, value){	//같은 공지사항이 있으면 같이 'new' 뱃지 제거
						if(value.getAttribute('id') == noticeID && value != $('.title:eq(' + index + ')')){
							$('.title:eq(' + index + ')').addClass('viewdClass');

							var element = $('.title:eq(' + index + ')');
							$('.title:eq(' + index + ')').children('span').remove();
							
							var elements = $('.title');
							$.each(elements, function(idx, value){	//같은 공지사항이 있으면 같이 'new' 뱃지 제거
								if(value.getAttribute('id') == noticeID && value != $('.title:eq(' + index + ')'))
									$('.title:eq(' + idx + ')').addClass('viewdClass');
									$('.title:eq(' + idx + ')').children('span').remove();
							});
							return false;
						}
							
					});
				},
				error: function(data, status,error){
					alert('공지 가져오기 실패!');
				}
			});
	}
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top_stu_temp.jsp" flush="false"/>

		<div class="app-main">
			<!-- outer_left.jsp에 데이터 전송 -->
		 	<jsp:include page="../outer_left_stu.jsp" flush="false">
		 		<jsp:param name="className" value="${className}"/>	
		 		<jsp:param name="menu"  value="notice"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper align-items-center ">
                        	<div class="page-title-heading mr-3">
                            	<h3><span class="text-primary">${className}</span> - 내 강의실</h3>	
                            </div>
                            <div class="search-wrapper ml-3">
			                    <div class="input-holder">
			                        <input type="text" class="search-input" placeholder="공지 검색">
			                        <button class="search-icon"><span></span></button>
			                    </div>
			                    <button class="close"></button>
			                </div>
                        </div>
                    </div>            
                    <div class="row">
                    	<div class="col-12 row justify-content-center noticeList">
                    		<!--  
                    		<c:forEach var="item" items="${allNotices}" varStatus="status">
                    			<div class="col-md-12 col-lg-10 col-md-12 col-auto ">
	                             <div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">
	                                 <div class="card">
	                                     <div id="headingOne" class="card-header">
	                                     	<c:set var="num" value="${fn:length(allNotices) - status.index}" />
	                                         <button type="button" data-toggle="collapse" data-target="#collapse${status.index}" aria-expanded="false" aria-controls="collapseOne" class="text-left m-0 p-0 btn btn-link btn-block collapsed">
	                                             <h5 class="m-0 p-0"><b>#<c:out value="${num}" /> </b><c:out value="${item.title}" /></h5>
	                                         </button>
	                                     </div>
	                                     <div data-parent="#accordion" id="collapse${status.index}" aria-labelledby="headingOne" class="collapse" style="">
	                                         <div class="card-body"><c:out value="${item.content}" /></div>
	                                     </div>
	                                 </div>
	                             </div>
	                         </div>
                    		</c:forEach>
                    		-->
                    	</div>
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>

</body>
</html>