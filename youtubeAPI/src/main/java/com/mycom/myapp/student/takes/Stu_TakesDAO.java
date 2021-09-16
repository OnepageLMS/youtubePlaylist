package com.mycom.myapp.student.takes;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class Stu_TakesDAO {
	
	@Autowired
	SqlSession sqlSession;

	public int insertStudent(Stu_TakesVO vo) {
		// TODO Auto-generated method stub
		int result = sqlSession.insert("Takes.insertTakes", vo);
		return result;
	}

	public int deleteStudent(int id) {
		// TODO Auto-generated method stub
		int result = sqlSession.delete("Takes.deleteTakes", id);
		return result;
	}

	public int updateStudent(Stu_TakesVO vo) {
		// TODO Auto-generated method stub
		int result = sqlSession.update("Takes.updateTakes", vo);
		return result;
	}

	public Stu_TakesVO getStudent(int id) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("Takes.getTakes", id);
	}

}
