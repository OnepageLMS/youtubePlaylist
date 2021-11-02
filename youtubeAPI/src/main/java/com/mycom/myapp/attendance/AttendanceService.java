package com.mycom.myapp.attendance;

import java.util.List;

import com.mycom.myapp.commons.AttendanceVO;

public interface AttendanceService {
	public int insertAttendanceNoFile(AttendanceVO vo); 
	public int insertAttendance(AttendanceVO vo);
	public int updateAttendance(AttendanceVO vo);
	public int deleteAttendance(int id);
	public AttendanceVO getAttendance(int id);
	public AttendanceVO getAttendanceID(AttendanceVO vo);
	public List<AttendanceVO> getAttendanceList(int classID);
	public int getAttendanceListCount(int classID);
}
