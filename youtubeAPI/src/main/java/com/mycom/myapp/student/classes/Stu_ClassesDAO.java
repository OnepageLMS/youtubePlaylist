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
	
	public ClassesVO getClassInfo(int id) {
		ClassesVO result = sqlSession.selectOne("Stu_Classes.getClassInfo", id);
		return result;
	}
	
	public List<ClassesVO> getAllMyClass(int id){
		List<ClassesVO> result = sqlSession.selectList("Stu_Classes.getAllMyClass", id);
		return result;
	}
	
	public List<ClassesVO> getAllMyInactiveClass(int id){
		List<ClassesVO> result = sqlSession.selectList("Stu_Classes.getAllMyInactiveClass", id);
		return result;
	}
	
	public int deleteClassroom(ClassesVO vo) {
		int result = sqlSession.delete("Stu_Classes.deleteClassroom", vo);
		return result;
	}
}