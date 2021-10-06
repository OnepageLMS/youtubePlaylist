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
<script>
	$(".addClassroomBtn").click(function () {
		$('#formAddClassroom')[0].reset();
	});

	function publishNotice(){
		
	}
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false"/>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<h4>Class이름 - 공지</h4>	
                            </div>
                        </div>
                    </div>            
                    <div class="row">
                    	<div class="col-12 row mb-3 ml-5">
                   			<button type="button" class="btn mr-2 mb-2 btn-primary" data-toggle="modal" data-target=".bd-example-modal-lg">공지 작성</button>
                    	</div>
                  		<div class="col-md-12">
                             <div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">
                                 <div class="card">
                                     <div id="headingOne" class="card-header">
                                         <button type="button" data-toggle="collapse" data-target="#collapseOne1" aria-expanded="false" aria-controls="collapseOne" class="text-left m-0 p-0 btn btn-link btn-block collapsed">
                                             <h5 class="m-0 p-0">Collapsible Group Item #1</h5>
                                         </button>
                                     </div>
                                     <div data-parent="#accordion" id="collapseOne1" aria-labelledby="headingOne" class="collapse" style="">
                                         <div class="card-body">1. Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa
                                             nesciunt
                                             laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt
                                             sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable
                                             VHS.
                                         </div>
                                     </div>
                                 </div>
                             </div>
                         </div>
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" style="display: none;">
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
                            <form class="needs-validation" id="inputNoticeForm" novalidate>
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
                                    	<textarea name="text" id="content" name="content" class="form-control"></textarea>
                                    </div>
                                </div>
                                <div class="position-relative row form-group"><label for="checkbox2" class="col-sm-2 col-form-label">중요 공지</label>
                                    <div class="col-sm-10 mt-2">
                                        <div class="position-relative form-check"><input id="checkbox2" type="checkbox" class="form-check-input"></div>
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