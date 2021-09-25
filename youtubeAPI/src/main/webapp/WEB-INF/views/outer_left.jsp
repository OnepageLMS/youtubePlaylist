<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
               		
                   <li class="app-sidebar__heading">활성화된 강의실</li>
                   		<c:forEach var="v" items="${allMyClass}">
							<li>
	                           <a href="#">
	                               <i class="metismenu-icon pe-7s-notebook"></i>
	                               ${v.className}
	                               <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>
	                           	</a>
	                           	<ul class="mm-collapse">
									<li>
										<a href="#">
	                                   		<i class="metismenu-icon"></i>
	                                   		공지
	                              		</a>
	                               	</li>
	                               	<li>
	                                	<a href="${pageContext.request.contextPath}/class/contentList/${v.id}">
	                                       <i class="metismenu-icon"></i>
	                                       	학습컨텐츠
	                                   	</a>
	                               	</li>
	                               	<li>
	                                   <a href="#">
	                                       <i class="metismenu-icon"></i>
	                                      	출결/학습 현황
	                                   </a>
	                               	</li>
	                           	</ul>
	                       	</li>
						</c:forEach>
				 		
						<li class="app-sidebar__heading">비활성화된 강의실</li>
						<c:forEach var="u" items="${allMyInactiveClass}">
							<li>
	                           <a href="#">
	                               <i class="metismenu-icon pe-7s-notebook"></i>
	                               ${u.className}
	                               <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>
	                           	</a>
	                           	<ul class="mm-collapse">
									<li>
										<a href="#">
	                                   		<i class="metismenu-icon"></i>
	                                   		공지
	                              		</a>
	                               	</li>
	                               	<li>
	                                	<a href="${pageContext.request.contextPath}/class/contentList/${u.id}">
	                                       <i class="metismenu-icon"></i>
	                                       	학습컨텐츠
	                                   	</a>
	                               	</li>
	                               	<li>
	                                   <a href="#">
	                                       <i class="metismenu-icon"></i>
	                                      	출결/학습 현황
	                                   </a>
	                               	</li>
	                           	</ul>
	                       	</li>
					</c:forEach>
               </ul>
           </div>
       </div>
   </div>   