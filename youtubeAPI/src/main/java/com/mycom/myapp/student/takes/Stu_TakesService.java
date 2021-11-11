package com.mycom.myapp.student.takes;

import java.util.List;

public interface Stu_TakesService {
	public int insertStudent(Stu_TakesVO vo); //학생 등록
	public int deleteStudent(Stu_TakesVO vo); //학생 삭제
	public Stu_TakesVO checkIfAlreadyEnrolled(Stu_TakesVO vo); // 이미 등록된 경우, 학생ID값을 반환한다 
	public List<Stu_TakesVO> getStudent(int studentID); // id를 통해 학생 정보 가져오기
	public List<Stu_TakesVO> getAcceptedStudent(int studentID); //accepted된 학생 정보 가져오기 
	public List<Stu_TakesVO> getStudentNum(int classID); //classID수강중인 학생 수 가져오기
	public List<Stu_TakesVO> getAllClassStudent(int classID);	//class에 속한 학생 리스
	public List<Stu_TakesVO> getStudentInfo(int classID);
	public int updateStatus(Stu_TakesVO vo);
}
