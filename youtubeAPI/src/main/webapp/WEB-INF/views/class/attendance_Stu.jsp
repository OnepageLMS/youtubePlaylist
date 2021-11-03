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
	
});
	
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top_stu_temp.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left_stu.jsp" flush="false">
		 		<jsp:param name="className" value="${classInfo.className}"/>	
		 		<jsp:param name="menu"  value="notice"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<span class="text-primary">${classInfo.className}</span> - 출석/학습현황 
                            </div>
                        </div>
                    </div>  
                    
                    <div class="row">
                    	<div class="col-lg-12">
                         	<div class="main-card mb-3 card">
                                    <div class="card-body"><h5 class="card-title"></h5>
                                        <table class="mb-0 table table-bordered takes" >
                                            <thead>   
                                            <tr>
                                            	<!-- <th colspan="2"> # </th>-->
                                            	<th style="text-align:center" colspan=2> 차시 </th>
	                                            <th style="text-align:center" > 출결 </th>
	                                           
                                            </tr>
                                            </thead>
                                            
                                            <tbody>
                                            
	                                             <c:forEach var="i" begin="0" end="${classInfo.days-1}" varStatus="status">
		                                            <tr>
		                                            
		                                            	<th scope="row${status.index}" style="text-align:center" rowspan=2 > ${status.index+1} 차시 </th>
		                                                
                                                        
                                                    
                                                      	<td style="text-align:center"><i class="pe-7s-video" style=" color:dodgerblue"> </i>  ZOOM </td>
                                                      	
                                                      	<td id = "take${status.index}" style="text-align:center; text-weight:bold" > ${file[status.index]} </td>
		                                              	

		                                            </tr>  
		                                              
		                                            <tr>
		                                            	<td style="text-align:center"> LMS </td>
			                                            <td id = "take${status.index}" style="text-align:center"> 0% </td>
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
   	
</body>

	
</html>





