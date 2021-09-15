package com.mycom.myapp.student.classes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.classes.ClassesVO;

@Service
public class Stu_ClassesServiceImpl implements Stu_ClassesService{
	@Autowired
	Stu_ClassesDAO classesDAO;
	
	@Override
	public Stu_ClassesVO getClass(int id) {
		return classesDAO.getClass(id);
	}
	
	@Override
	public List<Stu_ClassesVO> getAllMyClass(String email){
		return classesDAO.getAllMyClass(email);
	}
	
}
