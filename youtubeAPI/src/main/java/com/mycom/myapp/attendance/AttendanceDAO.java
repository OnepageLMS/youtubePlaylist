package com.mycom.myapp.attendance;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassesVO;

@Repository
public class AttendanceDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertAttendance(AttendanceVO vo) {
		int result = sqlSession.insert("Attendance.insertAttendance", vo);
		return result;
	}
	
	public int updateAttendance(AttendanceVO vo) {
		int result = sqlSession.update("Attendance.updateAttendance", vo);
		return result;
	}
	
	public int deleteAttendance(int id){
		int result = sqlSession.update("Attendance.deleteAttendance", id);
		return result;
	}
	
	public AttendanceVO getAttendance(int id) {
		AttendanceVO vo = sqlSession.selectOne("Attendance.getAttendance", id);
		return vo;
	}
	
	public List<AttendanceVO> getAttendanceList(AttendanceVO vo){
		List<AttendanceVO> result = sqlSession.selectList("Attendance.getAttendanceList", vo);
		return result;
	}
	
}