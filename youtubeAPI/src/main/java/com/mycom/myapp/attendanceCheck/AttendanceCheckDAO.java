package com.mycom.myapp.attendanceCheck;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassesVO;

@Repository
public class AttendanceCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.insert("AttendanceCheck.insertAttendanceCheck", vo);
		return result;
	}
	
	public int updateExAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.update("AttendanceCheck.updateExAttendanceCheck", vo);
		return result;
	}
	
	public int updateInAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.update("AttendanceCheck.updateInAttendanceCheck", vo);
		return result;
	}
	
	public int updateAttendanceCheck(AttendanceCheckVO vo) {
		int result = sqlSession.update("AttendanceCheck.updateAttendanceCheck", vo);
		return result;
	}
	
	public int deleteAttendanceCheck(int id){
		int result = sqlSession.update("AttendanceCheck.deleteAttendanceCheck", id);
		return result;
	}
	
	public AttendanceCheckVO getAttendanceCheck(int id) {
		AttendanceCheckVO vo = sqlSession.selectOne("AttendanceCheck.getAttendanceCheck", id);
		return vo;
	}
	
	/*public List<AttendanceVO> getAttendanceList(AttendanceVO vo){
		List<AttendanceVO> result = sqlSession.selectList("Attendance.getAttendanceList", vo);
		return result;
	}*/
	
}