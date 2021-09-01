package com.mycom.myapp.classes;

import java.util.List;

public interface ClassesService {
	public int updateDays(ClassesVO vo);
	public ClassesVO getClass(int id);
	public List<ClassesVO> getAllMyClass(String instructorEmaill);
}
