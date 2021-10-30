package com.mycom.myapp.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.MemberVO;

@Repository
public class MemberDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertInstructor(MemberVO vo) {
		int id = sqlSession.insert("Member.insertInstructor", vo);
		return vo.getId();
	}
	
	public int insertStudent(MemberVO vo) {
		int id = sqlSession.insert("Member.insertStudent", vo);
		return vo.getId();
	}
	
	public String getInstructorName(int id) {	//지우기 
		return sqlSession.selectOne("Member.getInstructorName", id);
	}
	
	public String getStudentName(int id) {	//지우기
		return sqlSession.selectOne("Member.getStudentName", id);
	}
	
	public int getInstructorID(String email) {
		return sqlSession.selectOne("Member.getInstructorID", email);
	}
	
	public int getStudentID(String email) {
		return sqlSession.selectOne("Member.getStudentID", email);
	}
	

}
