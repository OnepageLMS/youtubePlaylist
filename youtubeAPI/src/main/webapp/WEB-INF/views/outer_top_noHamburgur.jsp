<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script>
	function checkUpdateName(){
		if($('#editName') == '' || $('#editName') == null) return false;
	}
	function leaveSite(){
		
	}
</script>
	<div class="app-header header-shadow">
		<div class="app-header__logo">
			<div class="logo-src" style="background: url('${pageContext.request.contextPath}/resources/img/logo_Learntube.png')"></div>
       </div>
            
        <div class="app-header__menu">
            <span>
                <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                    <span class="btn-icon-wrapper">
                        <i class="fa fa-ellipsis-v fa-w-6"></i>
                    </span>
                </button>
            </span>
        </div>    
        <div class="app-header__content">
            <div class="app-header-left">
                <ul class="header-menu nav">
                    <li class="nav-item">
                        <a href="#" class="nav-link text-primary">	<!-- 상단의 대시보드/학습컨텐츠보관함의 파랑색글씨 설정 class -->
                            <i class="nav-link-icon fa fa-home"> </i>
                            대시보드
                        </a>
                    </li>
                   
                    <li class="nav-item">
                    	<!-- url에서 /myplaylist 뒤에 {instructorID} 없는걸로 수정됨 (9/20)-->
                        <a href="${pageContext.request.contextPath}/playlist/myPlaylist" class="nav-link">
                            <i class="nav-link-icon fa fa-archive"></i>
                            학습컨텐츠 보관함
                        </a>
                    </li>
                </ul>  
            </div>
            <div class="app-header-right">
                <div class="header-btn-lg pr-0">
                    <div class="widget-content p-0">
                        <div class="widget-content-wrapper">
                            <div class="widget-content-left">
                                <div class="btn-group">
                                    <a data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="p-0 btn">
                                        <i class="fa fa-angle-down ml-2 opacity-8"></i>
                                    </a>
                                    <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right">
                                        <button type="button" tabindex="0" class="dropdown-item" data-toggle="modal" data-target="#editUserModal">회원정보 관리</button>
                                        <button type="button" tabindex="0" class="dropdown-item" onclick="location.href='${pageContext.request.contextPath}/login/signout'">로그아웃</button>
                                    </div>
                                </div>
                            </div>
                            <div class="widget-content-left  ml-3 header-user-info">
                                <div class="widget-heading">
                                   ${login.name}
                                </div>
                                <div class="widget-subheading">
                                    선생님
                                </div>
                            </div>
                        </div>
                    </div>
                </div>        
            </div>
        </div>
    </div>              
	
	<div class="modal fade bd-example-modal-sm" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog modal-sm">
	    	<form method="post" action="" novalidate>
		        <div class="modal-content">
		            <div class="modal-header">
		                <h5 class="modal-title" id="exampleModalLongTitle">회원정보 관리</h5>
		                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		                    <span aria-hidden="true">×</span>
		                </button>
		            </div>
		            <div class="modal-body">
		               <div class="position-relative form-group">
							<label for="exampleEmail" class="">사용자 이름</label>
		               		<input name="name" id="editName" type="text" value="${login.name}" class="form-control" required>
		               </div>
		               <p>이메일 <b>${login.email}</b></p>
	                   <p>회원가입 <b>${login.regDate}</b></p>
		            </div>
		            <div class="divider m-0"></div>
		            <button class="btn btn-sm btn-danger m-2" onclick="leaveSite();">회원탈퇴</button>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
		                <button type="submit" class="btn btn-primary">저장</button>
		            </div>
		        </div>
	        </form>
	    </div>
	</div>
	