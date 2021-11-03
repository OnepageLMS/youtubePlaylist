package com.mycom.myapp.student.attendanceCheck;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceCheckVO;

@Service
public class Stu_AttendanceCheckServiceImpl {
	@Autowired
	Stu_AttendanceCheckDAO stuAttendanceCheckDAO;
	
	public List<AttendanceCheckVO> getStuAttendanceCheckList(AttendanceCheckVO vo){
		return stuAttendanceCheckDAO.getStuAttendanceCheckList(vo);
	}
}
