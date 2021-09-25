package com.mycom.myapp.classes;

import java.util.List;

import com.mycom.myapp.commons.ClassesVO;

public interface ClassesService {
	public int insertClassroom(ClassesVO vo);
	public int updateClassroom(ClassesVO vo);
	public int updateDays(ClassesVO vo);
	public ClassesVO getClass(int id);
	public List<ClassesVO> getAllMyActiveClass(int instructorID);
	public List<ClassesVO> getAllMyInactiveClass(int instructorID);
	public List<ClassesVO> getAllMyClass(int instructorID);
}
