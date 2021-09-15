package com.mycom.myapp.classes;

import java.util.List;

import com.mycom.myapp.commons.ClassesVO;

public interface ClassesService {
	public int updateDays(ClassesVO vo);
	public ClassesVO getClass(int id);
	public List<ClassesVO> getAllMyClass(int instructorID);
}
