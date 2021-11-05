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
	var totalStudent = 0;
	
	$(document).ready(function(){
		getClassInfo();
		
		$("#publishNoticeBtn").click(function () {
			$('#inputNoticeForm')[0].reset();
		});
	});

	function getClassInfo(){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/getClassInfo',
			data: {classID, classID},
			datatype: 'json',
			success: function(data){
				totalStudent = data.totalStudent;
				getAllPin();
				},
			error: function(data, status,error){
				console.log('강의실 정보 가져오기 실패!');
			}
				
			});
	}

	function getAllPin(){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/getAllPin',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				$('.noticeList').empty();
				$.each(data, function( index, value){
					var collapseID = "collapse" + index;
					var regDate = value.regDate.split(" ")[0];
					var viewCount = value.viewCount;

					if (viewCount == null)	viewCount = '0';
					else {
						viewCount = (viewCount/totalStudent) * 100;
					}
						
					var html = '<div class="col-md-12 col-lg-10 col-sm-12 col-auto ">'
						+ '<div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">'
							+ '<div class="card">'
								+ '<div id="headingOne" class="card-header">'
									+ '<button type="button" data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne" '
																													+ 'class="col-6 text-left m-0 p-0 btn btn-link btn-block collapsed">'
										+ '<h5 class="m-0 p-0"><i class="pe-7s-pin"></i> ' + value.title + ' </h5>'
									+ '</button>'
									+ '<div class="text-success col-2 pl-5 pr-0">' + viewCount + '% 읽음</div>'
									+ '<div class="col-3">작성일 ' + regDate + '</div>'
									+ '<button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="col-1 btn">'
										+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
									+ '</button>'
									+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="left-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(-341px, 0px, 0px);">'
										+ '<button type="button" class="dropdown-item" onclick="unsetPin(' + value.id + ');">상단고정 해재</button>' 
                                       	+ '<button type="button" class="dropdown-item" onclick="setEditNotice(' + index + ');" data-toggle="modal" data-target="#setNoticeModal">수정</button>' 
                                        + '<button type="button" class="dropdown-item" onclick="deleteNotice(' + value.id + ')"><p class="text-danger">삭제</p></button>'
                                   	+ '</div>'
								+ '</div>'
								+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
									+ '<div class="card-body">' 
										
										+ '<div>' + value.content + '</div>'
									+ '</div>'
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
			url: '${pageContext.request.contextPath}/getAllNotice',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				notices = data.notices;

				if (notices.length == 0) 
					$('.noticeList').append('게시된 공지사항이 없습니다.');

				else {
					$.each(notices, function( idx, value ){
						var index = last + idx;
						var collapseID = "collapse" + index;
						var regDate = value.regDate.split(" ")[0];
						var pin = value.pin;
						var viewCount = value.viewCount;

						if(pin != 1) pin = 'onclick="setPin(' + value.id + ');">상단고정';
						else pin = 'onclick="unsetPin(' + value.id + ');">상단고정 해재';

						if (viewCount == null)	viewCount = '0';
						else {
							viewCount = (viewCount/totalStudent) * 100;
						}
							
						var html = '<div class="col-md-12 col-lg-10 col-sm-12 col-auto ">'
							+ '<div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">'
								+ '<div class="card">'
									+ '<div id="headingOne" class="card-header">'
										+ '<button type="button" data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne" '
																														+ 'class="col-6 text-left m-0 p-0 btn btn-link btn-block collapsed">'
											+ '<h5 class="m-0 p-0 text-black">' + value.title + ' </h5>'
										+ '</button>'
										+ '<div class="text-success col-2 pl-5 pr-0">' + viewCount + '% 읽음</div>'
										+ '<div class="col-3">작성일 ' + regDate + '</div>'
										+ '<button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="col-1 btn">'
											+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
										+ '</button>'
										+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="left-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(-341px, 0px, 0px);">'
											+ '<button type="button" class="dropdown-item"' + pin + '</button>' 
	                                       	+ '<button type="button" class="dropdown-item" onclick="setEditNotice(' + index + ');" data-toggle="modal" data-target="#setNoticeModal">수정</button>' 
	                                        + '<button type="button" class="dropdown-item" onclick="deleteNotice(' + value.id + ')"><p class="text-danger">삭제</p></button>'
                                    	+ '</div>'
									+ '</div>'
									+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
										+ '<div class="card-body">' 
											+ '<div>' + value.content + '</div>'
										+ '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
						+ '</div>';

						$('.noticeList').append(html);
					});
				}
			},
			error: function(data, status,error){
				console.log('공지 생성 실패!');
			}
		});
	}

	function setPin(id){	//상단 pin고정
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/setPin',
			data: {id: id},
			datatype: 'json',
			success: function(data){
				getAllPin();
			},
			error: function(data, status,error){
				console.log('pin 설정 실패!');
			}
		});
	}

	function unsetPin(id){	//상단 pin고정 해재
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/unsetPin',
			data: {id: id},
			datatype: 'json',
			success: function(data){
				getAllPin();
			},
			error: function(data, status,error){
				console.log('pin 해재 실패!');
			}
		});
	}

	function setEditNotice(index){	//공지수정 modal data 설정
		var id = notices[index].id;
		var title = notices[index].title;
		var content = notices[index].content;
		var pin = notices[index].pin;
		$('#setID').val(id);
		$('#editTitle').val(title);
		$('#editContent').val(content);

		if(pin == 1)
			$('#editImportant').attr('checked', '');
		else
			$('#editImportant').removeAttr('checked');
	}
		
	function publishNotice(){	//공지등록
		if($('#inputTitle').val() == '' ) return false;

		if ($('#inputImportant').val() == 'on')
			$('#inputImportant').val(1);
		else
			$('#inputImportant').val(0);

		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/addNotice',
			data: $('#inputNoticeForm').serialize(),
			datatype: 'json',
			success: function(data){
				console.log('공지 생성 성공');
			},
			complete: function(data){
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
		else
			$('#editImportant').val(0);

		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/updateNotice',
			data: $('#editNoticeForm').serialize(),
			datatype: 'json',
			success: function(data){
				console.log('공지 수정 성공');
			},
			complete: function(data){
				location.reload();
			},
			error: function(data, status,error){
				console.log('공지 수정 실패!');
			}
		});
	}

	function deleteNotice(id){
		if(confirm('공지글을 삭제하시겠습니까?')){
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/deleteNotice',
				data: {id: id},
				success: function(data){
					console.log('공지 삭제 성공');
				},
				complete: function(data){
					location.reload();
				},
				error: function(data, status,error){
					console.log('공지 삭제 실패!');
				}
			});
		}
	}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
			<!-- outer_left.jsp에 데이터 전송 -->
		 	<jsp:include page="../outer_left.jsp" flush="false">
		 		<jsp:param name="className" value="${className}"/>	
		 		<jsp:param name="menu"  value="notice"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper align-items-center">
                        	<div class="page-title-heading mr-3">
                            	<h4><span class="text-primary displayClassName">${className}</span> - 공지</h4>	
                            </div>
                            <div class="search-wrapper">
			                    <div class="input-holder">
			                        <input type="text" class="search-input" placeholder="공지 검색">
			                        <button class="search-icon"><span></span></button>
			                    </div>
			                    <button class="close"></button>
			                </div>
			                <button type="button" id="publishNoticeBtn" class="btn mr-2 mb-2 btn-primary float-right" data-toggle="modal" data-target=".publishNoticeModal">공지 작성</button>
                        </div>
                    </div>            
                    <div class="row">
                    	<div class="col-12">
                    		<div class="col-10">
                    		</div>
                    	</div>
                    	<div class="col-12 row justify-content-center noticeList"></div>
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	
   	<!-- 게시글 작성 modal -->
   	<div class="modal fade publishNoticeModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog modal-lg">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">새로운 공지 작성</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">  
	                <div class="main-card">
						<div class="card-body">
                            <form class="needs-validation" id="inputNoticeForm" method="post" novalidate>
                            	<input type="hidden" name="classID" value="${classID}"/>
                                <div class="position-relative row form-group">
                                	<label for="inputTitle" class="col-sm-2 col-form-label">제목</label>
                                    <div class="col-sm-10">
                                    	<input name="title" id="inputTitle" placeholder="제목을 입력하세요" type="text" class="form-control" required>
                                    	<div class="invalid-feedback">제목을 입력해 주세요</div>
                                    </div>
                                </div>
                                <div class="position-relative row form-group">
                                	<label for="content" class="col-sm-2 col-form-label">내용</label>
                                    <div class="col-sm-10">
                                    	<textarea id="inputContent" name="content" class="form-control" rows="7"></textarea>
                                    </div>
                                </div>
                                <div class="position-relative row form-group"><label for="checkbox2" class="col-sm-2 col-form-label">상단고정</label>
                                    <div class="col-sm-10 mt-2">
                                        <div class="position-relative form-check"><input id="inputImportant" name="pin" type="checkbox" class="form-check-input"></div>
                                    </div>
                                </div>
                            </form>
                          </div>
                      </div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" form="inputNoticeForm" class="btn btn-primary" onclick="publishNotice();">등록</button>
	            </div>
	        </div>
	    </div>
	</div>
	
		<!-- 게시글 수정 modal -->
   	<div class="modal fade bd-example-modal-lg" id="setNoticeModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog modal-lg">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">공지 수정</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">  
	                <div class="main-card">
						<div class="card-body">
                            <form class="needs-validation" id="editNoticeForm" method="post" novalidate>
                            	<input type="hidden" name="id" id="setID" value=""/>
                                <div class="position-relative row form-group">
                                	<label for="editTitle" class="col-sm-2 col-form-label">제목</label>
                                    <div class="col-sm-10">
                                    	<input name="title" id="editTitle" type="text" class="form-control" required>
                                    	<div class="invalid-feedback">제목을 입력해 주세요</div>
                                    </div>
                                </div>
                                <div class="position-relative row form-group">
                                	<label for="content" class="col-sm-2 col-form-label">내용</label>
                                    <div class="col-sm-10">
                                    	<textarea id="editContent" name="content" class="form-control" rows="7"></textarea>
                                    </div>
                                </div>
                                <div class="position-relative row form-group"><label for="checkbox2" class="col-sm-2 col-form-label">상단고정</label>
                                    <div class="col-sm-10 mt-2">
                                        <div class="position-relative form-check">
                                        	<input id="editImportant" name="pin" type="checkbox" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                            </form>
                          </div>
                      </div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" form="editNoticeForm" class="btn btn-primary" onclick="editNotice(); return false;">수정</button>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
// Disable form submissions if there are invalid fields
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Get the forms we want to add validation styles to
    var forms = document.getElementsByClassName('needs-validation');
    // Loop over them and prevent submission
    var validation = Array.prototype.filter.call(forms, function(form) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    });
  }, false);
})();
</script>
</body>
</html>