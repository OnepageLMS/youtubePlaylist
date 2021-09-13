package com.mycom.myapp.student.classes;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.classes.ClassesVO;

@Repository
public class Stu_ClassesDAO {
	@Autowired
	SqlSession sqlSession;
	
	public Stu_ClassesVO getClass(int id) {
		Stu_ClassesVO vo = sqlSession.selectOne("Stu_Classes.getClass", id);
		return vo;
	}
	
	public List<Stu_ClassesVO> getAllMyClass(String email){
		List<Stu_ClassesVO> result = sqlSession.selectList("Stu_Classes.getAllMyClass", email);
		return result;
	}
}