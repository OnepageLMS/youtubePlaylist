<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
</head>
<body>
	<button onclick="location.href='example'">예시템플릿</button>
	<button onclick="location.href='dashboard'">Teacher(바로 대시보드로이동)</button>
	<button onclick="location.href='student/class/1'">Student1</button>
	<button onclick="location.href='student/class/2'">Student2</button>
	<!-- 나중에는 학생이 join한 class들을 먼저 보여주고, 거기서 선택해서 들어갈 수 있도록하기
	지금은 그냥 임의로 ClassID가 1인 수업으로 들어가고있음! -->

</body>
</html>