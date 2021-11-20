package com.mycom.myapp.student.attendanceInternalCheck;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesVO;

@Repository
public class Stu_AttendanceInternalCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return sqlSession.insert("AttendanceInternalCheck.insertAttendanceInCheck", vo);
	}
	
	public int updateAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return sqlSession.update("AttendanceInternalCheck.updateAttendanceInCheck", vo);
	}
	
	public int deleteAttendanceInCheck(AttendanceInternalCheckVO vo) {
		return sqlSession.delete("AttendanceInternalCheck.deleteAttendanceInCheck", vo);
	}
	
	public List<AttendanceInternalCheckVO> getAttendanceInCheck(AttendanceInternalCheckVO vo) {
		List<AttendanceInternalCheckVO> result = sqlSession.selectList("AttendanceInternalCheck.getAttendanceInCheck", vo);
		return result;
	}
	
	public AttendanceInternalCheckVO getAttendanceInCheckByID(AttendanceInternalCheckVO vo) {
		AttendanceInternalCheckVO result = sqlSession.selectOne("AttendanceInternalCheck.getAttendanceInCheckByID", vo);
		return result;
	}
}
