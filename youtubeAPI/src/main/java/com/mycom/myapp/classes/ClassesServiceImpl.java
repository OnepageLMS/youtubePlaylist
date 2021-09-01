package com.mycom.myapp.classes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClassesServiceImpl implements ClassesService {
	@Autowired
	ClassesDAO classesDAO;
	
	@Override
	public int updateDays(ClassesVO vo) {
		return classesDAO.updateDays(vo);
	}
	
	@Override
	public ClassesVO getClass(int id) {
		return classesDAO.getClass(id);
	}
	
	@Override
	public List<ClassesVO> getAllMyClass(String instructorEmail){
		return classesDAO.getAllMyClass(instructorEmail);
	}
}

