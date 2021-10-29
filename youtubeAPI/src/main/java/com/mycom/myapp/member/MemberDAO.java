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
		return sqlSession.insert("Member.insertInstructor", vo);
	}
	
	public int insertStudent(MemberVO vo) {
		return sqlSession.insert("Member.insertStudent", vo);
	}
	
	public String getInstructorName(int id) {
		return sqlSession.selectOne("Member.getInstructorName", id);
	}
	
	public String getStudentName(int id) {
		return sqlSession.selectOne("Member.getStudentName", id);
	}
	
	public MemberVO getInstructor(String email) {
		return sqlSession.selectOne("Member.getInstructor", email);
	}
	
	public MemberVO getStudent(String email) {
		return sqlSession.selectOne("Member.getStudent", email);
	}
	

}
