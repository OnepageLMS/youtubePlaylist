package com.mycom.myapp.student.takes;

public interface Stu_TakesService {
	public int insertStudent(Stu_TakesVO vo); //학생 등록
	public int deleteStudent(int id); //학생 삭제
	public int updateStudent(Stu_TakesVO vo); //학생 정보 업데이트
	public Stu_TakesVO getStudent(int id); // id를 통해 학생 정보 가져오기
}