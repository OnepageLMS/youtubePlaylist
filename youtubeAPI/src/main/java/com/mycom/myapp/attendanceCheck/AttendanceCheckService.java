package com.mycom.myapp.attendanceCheck;

import java.util.List;

import com.mycom.myapp.commons.AttendanceVO;

public interface AttendanceCheckService {
	public int insertAttendanceCheck(AttendanceCheckVO vo);
	public int updateExAttendanceCheck(AttendanceCheckVO vo);
	public int updateInAttendanceCheck(AttendanceCheckVO vo);
	public int updateAttendanceCheck(AttendanceCheckVO vo);
	public int deleteAttendanceCheck(int id);
	public AttendanceCheckVO getAttendanceCheck(int id);
	
}
