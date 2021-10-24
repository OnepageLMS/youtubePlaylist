package com.mycom.myapp.student.takes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class Stu_TakesDAO {
	
	@Autowired
	SqlSession sqlSession;

	public int insertStudent(Stu_TakesVO vo) {
		return sqlSession.insert("Takes.insertTakes", vo);
	}

	public int deleteStudent(Stu_TakesVO vo) {
		return sqlSession.delete("Takes.deleteTakes", vo);
	}

	public int updateStudent(Stu_TakesVO vo) {
		return sqlSession.update("Takes.updateTakes", vo);
	}

	public Stu_TakesVO getStudent(int id) {
		return sqlSession.selectOne("Takes.getTakes", id);
	}
	
	public List<Stu_TakesVO> getStudentNum(int classID) {
		return sqlSession.selectList("Takes.getTakesNum", classID);
	}
	
	public List<Stu_TakesVO> getAllClassStudent(int classID){
		return sqlSession.selectList("Takes.getAllClassStudent", classID);
	}
	
	public List<Stu_TakesVO> getStudentInfo(int classID) {
		return sqlSession.selectList("Takes.getStudentInfo", classID);
	}
	
	public int updateStatus(Stu_TakesVO vo) {
		return sqlSession.update("Takes.updateStatus", vo);
	}


}
