package com.mycom.myapp.attendance;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceVO;

@Service
public class AttendanceServiceImpl implements AttendanceService {
	@Autowired
	AttendanceDAO attendanceDAO;
	
	@Override
	public int insertAttendance(AttendanceVO vo){
		return attendanceDAO.insertAttendance(vo);
	}
	
	@Override
	public int updateAttendance(AttendanceVO vo) {
		return attendanceDAO.updateAttendance(vo);
	}
	
	@Override
	public int deleteAttendance(int id) {
		return attendanceDAO.deleteAttendance(id);
	}
	
	@Override
	public AttendanceVO getAttendance(int id){
		return attendanceDAO.getAttendance(id);
	}
	
	@Override
	public List<AttendanceVO> getAttendanceList(AttendanceVO vo){
		return attendanceDAO.getAttendanceList(vo);
	}
}
