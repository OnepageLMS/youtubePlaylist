package com.mycom.myapp.student.takes;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.video.VideoDAO;

@Service
public class Stu_TakesServiceImpl implements Stu_TakesService {

	@Autowired
	Stu_TakesDAO stu_TakesDAO;
	
	@Override
	public int insertStudent(Stu_TakesVO vo) {
		// TODO Auto-generated method stub
		return stu_TakesDAO.insertStudent(vo);
	}

	@Override
	public int deleteStudent(Stu_TakesVO vo) {
		// TODO Auto-generated method stub
		return stu_TakesDAO.deleteStudent(vo);
	}

	@Override
	public int updateStudent(Stu_TakesVO vo) {
		// TODO Auto-generated method stub
		return stu_TakesDAO.updateStudent(vo);
	}

	@Override
	public List<Stu_TakesVO> getStudent(int studentID) {
		// TODO Auto-generated method stub
		return stu_TakesDAO.getStudent(studentID);
	}
	
	@Override
	public List<Stu_TakesVO> getAcceptedStudent(int studentID){
		return stu_TakesDAO.getAcceptedStudent(studentID);
	}
	
	@Override
	public List<Stu_TakesVO> getStudentNum(int classID) {
		return stu_TakesDAO.getStudentNum(classID);
	}
	
	@Override
	public List<Stu_TakesVO> getAllClassStudent(int classID){
		return stu_TakesDAO.getAllClassStudent(classID);
	}
	
	@Override
	public List<Stu_TakesVO> getStudentInfo(int classID){
		return stu_TakesDAO.getStudentInfo(classID);
	}

	@Override
	public int updateStatus(Stu_TakesVO vo) {
		return stu_TakesDAO.updateStatus(vo);
	}

	@Override
	public Stu_TakesVO checkIfAlreadyEnrolled(Stu_TakesVO vo) {
		return stu_TakesDAO.checkIfAlreadyEnrolled(vo);
	}

}