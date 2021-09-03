package com.mycom.myapp.classes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int updateDays(ClassesVO vo){
		int result = sqlSession.update("Classes.updateDays", vo);
		return result;
	}
	
	public ClassesVO getClass(int id) {
		ClassesVO vo = sqlSession.selectOne("Classes.getClass", id);
		return vo;
	}
	
	public List<ClassesVO> getAllMyClass(String email){
		List<ClassesVO> result = sqlSession.selectList("Classes.getAllMyClass", email);
		return result;
	}
}

