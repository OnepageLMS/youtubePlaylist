package com.mycom.myapp.student.attendanceCheck;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mycom.myapp.commons.AttendanceCheckVO;

@Repository
public class Stu_AttendanceCheckDAO {
	@Autowired
	SqlSession sqlSession;
	
	public List<AttendanceCheckVO> getStuAttendanceCheckList(AttendanceCheckVO vo) {
		List<AttendanceCheckVO> result = sqlSession.selectList("AttendanceCheck.getStuAttendanceCheckList", vo);
		//System.out.println("dao : " +result.size());
		return result;
	}
}
