package com.mycom.myapp.student.attendanceCheck;

import java.util.List;

import com.mycom.myapp.commons.AttendanceCheckVO;

public interface Stu_AttendanceCheckService {
	public List<AttendanceCheckVO> getStuAttendanceCheckList(AttendanceCheckVO vo);
}
