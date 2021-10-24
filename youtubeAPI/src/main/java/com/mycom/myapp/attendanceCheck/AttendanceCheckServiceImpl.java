package com.mycom.myapp.attendanceCheck;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceVO;

@Service
public class AttendanceCheckServiceImpl implements AttendanceCheckService {
	@Autowired
	AttendanceCheckDAO attendanceCheckDAO;
	
	@Override
	public int insertAttendanceCheck(AttendanceCheckVO vo){
		return attendanceCheckDAO.insertAttendanceCheck(vo);
	}
	
	@Override
	public int updateExAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.updateExAttendanceCheck(vo);
	}
	
	@Override
	public int updateInAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.updateInAttendanceCheck(vo);
	}
	
	@Override
	public int updateAttendanceCheck(AttendanceCheckVO vo) {
		return attendanceCheckDAO.updateAttendanceCheck(vo);
	}
	
	@Override
	public int deleteAttendanceCheck(int id) {
		return attendanceCheckDAO.deleteAttendanceCheck(id);
	}
	
	@Override
	public AttendanceCheckVO getAttendanceCheck(int id){
		return attendanceCheckDAO.getAttendanceCheck(id);
	}
	
	/*@Override
	public List<AttendanceVO> getAttendanceList(AttendanceVO vo){
		return attendanceCheckDAO.getAttendanceList(vo);
	}*/
}