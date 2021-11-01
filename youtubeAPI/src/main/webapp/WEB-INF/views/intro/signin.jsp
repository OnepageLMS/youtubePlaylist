<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sign-in</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
<link rel="icon" href="favicon-16.png" sizes="16x16">
<link rel="icon" href="favicon-32.png" sizes="32x32">
<link rel="icon" href="favicon-48.png" sizes="48x48">
<link rel="icon" href="favicon-64.png" sizes="64x64">
<link rel="icon" href="favicon-128.png" sizes="128x128">
<!--favicon 설정 -->

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js"
	crossorigin="anonymous"></script>
</head>
<style>
.divider:after, .divider:before {
	content: "";
	flex: 1;
	height: 1px;
	background: #eee;
}

.h-custom {
	height: calc(100% - 73px);
}

@media ( max-width : 450px) {
	.h-custom {
		height: 100%;
	}
}
</style>
<script>
	function checkLoginMode(){
		if($("input[name='mode']:checked").val() == null) return false;
	}
</script>

<body>
	<section class="vh-100" style="background-color: #F0F0F0;">
		<div class="container py-5 h-100">
			<div
				class="row d-flex justify-content-center align-items-center h-100">
				<div class="col col-xl-10">
					<div class="card" style="border-radius: 1rem;">
						<div class="row g-0">
							<div class="col-md-6 col-lg-5 d-none d-md-block">
								<img src="${pageContext.request.contextPath}/resources/img/Learntube-logos_transparent.png"
									alt="login form" class="img-fluid"
									style="border-radius: 1rem 0 0 1rem;" />
							</div>
							<div class="col-md-6 col-lg-7 d-flex align-items-center">
								<div class="card-body p-4 p-lg-5 text-black">
									<div class="d-flex align-items-center mb-3 pb-1">
										<span class="h1 fw-bold mb-0">Learntube LMS에 오신걸 환영합니다!</span>
									</div>
									<form class="needs-validation" action='${pageContext.request.contextPath}/login/google' onsubmit='checkLoginMode();' method='post' novalidate>
										<fieldset class="position-relative form-group">
											<div class="position-relative form-check">
												<label class="form-check-label"> 
													<input name="mode" type="radio" class="form-check-input" value="tea" required>
													선생님
												</label>
											</div>
											<div class="position-relative form-check">
												<label class="form-check-label"> 
												<input name="mode" type="radio" class="form-check-input" value="stu">
													학생
												</label>
											</div>
										</fieldset>
										<div class="invalid-feedback">로그인 모드를 선택해주세요</div>	
										<div class="pt-1 mb-4">
										<button class="btn btn-lg btn-block btn-danger" type="submit">
											<i class="fab fa-google me-2"></i> Google로 로그인
										</button>
									</div>
									</form>
									
									<p class="small text-muted">&copy;Everyday</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<script>
        // Example starter JavaScript for disabling form submissions if there are invalid fields
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                // Fetch all the forms we want to apply custom Bootstrap validation styles to
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