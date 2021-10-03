package com.mycom.myapp.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAO {
	@Autowired
	SqlSession sqlSession;
	
	public String getInstructorName(int id) {
		String result = sqlSession.selectOne("Member.getInstructorName", id);
		return result;
	}
	
	public String getStudentName(int id) {
		String result = sqlSession.selectOne("Member.getStudentName", id);
		return result;
	}
	
	

}
