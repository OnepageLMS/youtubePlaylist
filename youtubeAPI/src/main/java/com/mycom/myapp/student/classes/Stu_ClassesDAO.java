package com.mycom.myapp.student.classes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassesVO;

@Repository
public class Stu_ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public ClassesVO getClass(int id) {
		ClassesVO vo = sqlSession.selectOne("Stu_Classes.getClass", id);
		return vo;
	}
	
	public List<ClassesVO> getAllMyClass(int id){
		List<ClassesVO> result = sqlSession.selectList("Stu_Classes.getAllMyClass", id);
		return result;
	}
}