<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script>
$(document).ready(function(){
	$.ajax({
		type : 'get',
		url : '${pageContext.request.contextPath}/allMyClassMap',
		success : function(result){
			var allMyClass = result.allMyClass;

			$('.sideClassList').empty();

			if (allMyClass == null)
				 $('.sideClassList').append('생성된 강의실이 없습니다');
			 
			else {
				$.each(allMyClass, function(index, value) {
					var name = value.className;
					var classContentURL = '${pageContext.request.contextPath}/class/contentList/' + value.id;
					var html = '<li>'
									+ '<a href="#">'
										+ '<i class="metismenu-icon pe-7s-notebook"></i>'
										+ name
										+ ' <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>'
									+ '</a>'
									+ '<ul>'
										+ '<li>'
											+ '<a href="#">'
												+ '<i class="metismenu-icon"></i>'
												+ '공지'
											+ '</a>'
										+ '</li>'
										+ '<li>'
											+ '<a href="' + classContentURL + '">'
												+ '<i class="metismenu-icon"></i>'
												+ '학습 컨텐츠'
											+ '</a>'
										+ '</li>'
										+ '<li>'
											+ '<a href="#">'
												+ '<i class="metismenu-icon"></i>'
												+ '성적'
											+ '</a>'
										+ '</li>'
									+ '</ul>'
								+ '</li>';
							
					$('.sideClassList').append(html);
				});
			}
		}, error:function(request,status,error){
			console.log(error);
		}
	});
});
</script>

	<div class="app-sidebar sidebar-shadow">
       <div class="app-header__logo">
           <div class="header__pane ml-auto">
               <div>
                   <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                       <span class="hamburger-box">
                           <span class="hamburger-inner"></span>
                       </span>
                   </button>
               </div>
           </div>
       </div>
       <div class="app-header__mobile-menu">
           <div>
               <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                   <span class="hamburger-box">
                       <span class="hamburger-inner"></span>
                   </span>
               </button>
           </div>
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
       <div class="scrollbar-sidebar">	<!-- side menu 시작! -->
           <div class="app-sidebar__inner">
               <ul class="vertical-nav-menu">
                   <li class="app-sidebar__heading">내 수업</li>
                   <li class="sideClassList"></li><!-- 로그인한 사용자의 강의실 list 여기에 추가됨 !! -->
               </ul>
           </div>
       </div>
   </div>   