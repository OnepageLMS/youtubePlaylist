package com.mycom.myapp.member;

import com.mycom.myapp.commons.MemberVO;

public interface MemberService {
	public int insertInstructor(MemberVO vo);
	public int insertStudent(MemberVO vo);
	public String getInstructorName(int id);
	public String getStudentName(int id);
	public MemberVO getInstructor(String email);
	public MemberVO getStudent(String email);

}
