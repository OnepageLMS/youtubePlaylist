package com.mycom.myapp.classes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.ClassesVO;

@Service
public class ClassesServiceImpl implements ClassesService {
	@Autowired
	ClassesDAO classesDAO;
	
	@Override
	public int insertClassroom(ClassesVO vo) {
		return classesDAO.insertClassroom(vo);
	}
	
	@Override
	public int updateClassroom(ClassesVO vo) {
		return classesDAO.updateClassroom(vo);
	}
	
	@Override
	public int updateDays(ClassesVO vo) {
		return classesDAO.updateDays(vo);
	}
	
	@Override
	public int deleteDay(int id) {
		return classesDAO.deleteDay(id);
	}
	
	@Override
	public ClassesVO getClass(int id) {
		return classesDAO.getClass(id);
	}
	
	@Override
	public List<ClassesVO> getAllMyActiveClass(int instructorID){
		return classesDAO.getAllMyActiveClass(instructorID);
	}
	
	@Override
	public List<ClassesVO> getAllMyInactiveClass(int instructorID){
		return classesDAO.getAllMyInactiveClass(instructorID);
	}
	
	@Override
	public List<ClassesVO> getAllMyClass(int instructorID){
		return classesDAO.getAllMyClass(instructorID);
	}
}

