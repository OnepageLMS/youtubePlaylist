package com.mycom.myapp.student.classes;

import java.util.List;

import com.mycom.myapp.commons.ClassesVO;

public interface Stu_ClassesService {
	public ClassesVO getClass(int id);
	public List<ClassesVO> getAllMyClass(int id);
}
