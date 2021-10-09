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
	#module {
	  font-size: 1rem;
	  line-height: 1.5;
	}
	
	
	#module #collapseExample.collapse:not(.show) {
	  display: block;
	  height: 3rem;
	  overflow: hidden;
	}
	
	#module #collapseExample.collapsing {
	  height: 3rem;
	}
	
	#module a.collapsed::after {
	  content: '+ Show More';
	}
	
	#module a:not(.collapsed)::after {
	  content: '- Show Less';
	}
</style>
<script>
	$(document).ready(function(){
		getAllNotices(${classID});
	});

	var notices;

	function getAllNotices(classID){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/getAllNotice',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				notices = data.notices;
				$('.noticeList').empty();

				var length = notices.length;

				if (length == 0) 
					$('.noticeList').append('게시된 공지사항이 없습니다.');

				else {
					$.each(notices, function( index, value){
						var num = length - index;
						var collapseID = "collapse" + num;
						var regDate = value.regDate;

						var html = '<div class="col-md-12 col-lg-10 col-sm-12 col-auto ">'
							+ '<div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">'
								+ '<div class="card">'
									+ '<div id="headingOne" class="card-header">'
										+ '<button type="button" data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne" '
																														+ 'class="text-left m-0 p-0 btn btn-link btn-block collapsed">'
											+ '<h5 class="m-0 p-0"><b>#' + num + '</b> ' + value.title + ' </h5>'
										+ '</button>'
										+ '<div>작성일 ' + value.regDate + '</div>'
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

	function setEditNotice(index){	//공지수정 modal data 설정
		var id = notices[index].id;
		var title = notices[index].title;
		var content = notices[index].content;
		var important = notices[index].important;
		$('#setID').val(id);
		$('#editTitle').val(title);
		$('#editContent').val(content);

		if(important == 1)
			$('#editImportant').attr('checked', '');
		else
			$('#editImportant').removeAttr('checked');
	}
		
	function publishNotice(){	//공지등록
		if($('#inputTitle').val() == '' ) return false;

		if ($('#inputImportant').val() == 'on')
			$('#inputImportant').val(1);

		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/addNotice',
			data: $('#inputNoticeForm').serialize(),
			datatype: 'json',
			success: function(data){
				console.log('공지 생성 성공');
				location.reload();
			},
			error: function(data, status,error){
				console.log('공지 생성 실패!');
			}
		});
	}

	function editNotice(){	//공지수정
		if($('#editTitle').val() == '' ) return false;

		if ($('#editImportant').val() == 'on')
			$('#editImportant').val(1);

		console.log($('#editNoticeForm').serialize());
/*
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/updateNotice',
			data: $('#editNoticeForm').serialize(),
			datatype: 'json',
			success: function(data){
				console.log('공지 수정 성공');
				location.reload();
			},
			error: function(data, status,error){
				console.log('공지 수정 실패!');
			}
		});
		*/
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
                            	<h4><span class="text-primary">${className}</span> - 공지</h4>	
                            </div>
                            <div class="search-wrapper">
			                    <div class="input-holder">
			                        <input type="text" class="search-input" placeholder="검색어를 입력하세요">
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