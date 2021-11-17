package com.mycom.myapp.student.attendanceInternalCheck;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Service
public class Stu_AttendanceInternalCheckServiceImpl implements Stu_AttendanceInternalCheckService{
	@Autowired
	Stu_AttendanceInternalCheckDAO stuAttendanceCheckDAO;
	
	@Override
	public int insertAttendanceInCheck(AttendanceInternalCheckVO vo){
		return stuAttendanceCheckDAO.insertAttendanceInCheck(vo);
	}
	
	@Override
	public int updateAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.updateAttendanceInCheck(vo);
	}
	
	@Override
	public int deleteAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return stuAttendanceCheckDAO.deleteAttendanceInCheck(vo);
	}
	
	@Override
	public AttendanceInternalCheckVO getAttendanceInCheck(AttendanceInternalCheckVO vo)  {
		return stuAttendanceCheckDAO.getAttendanceInCheck(vo);
	}
	
	
	
}