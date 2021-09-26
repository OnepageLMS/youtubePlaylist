package com.mycom.myapp.classes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassesVO;

@Repository
public class ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertClassroom(ClassesVO vo) {
		int result = sqlSession.insert("Classes.insertClassroom", vo);
		return result;
	}
	
	public int updateClassroom(ClassesVO vo) {
		int result = sqlSession.update("Classes.updateClassroom", vo);
		return result;
	}
	
	public int updateDays(ClassesVO vo){
		int result = sqlSession.update("Classes.updateDays", vo);
		return result;
	}
	
	public int deleteDay(int id){
		int result = sqlSession.update("Classes.deleteDay", id);
		return result;
	}
	
	public ClassesVO getClass(int id) {
		ClassesVO vo = sqlSession.selectOne("Classes.getClass", id);
		return vo;
	}
	
	public List<ClassesVO> getAllMyActiveClass(int instructorID){
		List<ClassesVO> result = sqlSession.selectList("Classes.getAllMyActiveClass", instructorID);
		return result;
	}
	
	public List<ClassesVO> getAllMyInactiveClass(int instructorID){
		List<ClassesVO> result = sqlSession.selectList("Classes.getAllMyInactiveClass", instructorID);
		return result;
	}
	
	public List<ClassesVO> getAllMyClass(int instructorID){
		List<ClassesVO> result = sqlSession.selectList("Classes.getAllMyClass", instructorID);
		return result;
	}
}

