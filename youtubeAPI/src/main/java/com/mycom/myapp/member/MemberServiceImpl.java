package com.mycom.myapp.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.MemberVO;

@Service
public class MemberServiceImpl implements MemberService{
	@Autowired
	MemberDAO memberDAO;
	
	@Override
	public int insertInstructor(MemberVO vo) {
		return memberDAO.insertInstructor(vo);
	}
	
	@Override
	public int insertStudent(MemberVO vo) {
		return memberDAO.insertStudent(vo);
	}
	
	@Override
	public String getInstructorName(int id) {
		return memberDAO.getInstructorName(id);
	}
	
	@Override
	public String getStudentName(int id) {
		return memberDAO.getStudentName(id);
	}
	
	@Override
	public MemberVO getInstructor(String email) {
		return memberDAO.getInstructor(email);
	}
	
	@Override
	public MemberVO getStudent(String email) {
		return memberDAO.getStudent(email);
	}
}
