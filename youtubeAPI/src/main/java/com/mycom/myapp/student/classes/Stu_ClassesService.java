package com.mycom.myapp.student.classes;

import java.util.List;

public interface Stu_ClassesService {
	public Stu_ClassesVO getClass(int id);
	public List<Stu_ClassesVO> getAllMyClass(String email);
}
