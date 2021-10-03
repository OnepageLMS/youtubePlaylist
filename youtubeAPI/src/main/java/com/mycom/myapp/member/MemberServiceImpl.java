package com.mycom.myapp.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements MemberService{
	@Autowired
	MemberDAO memberDAO;
	
	@Override
	public String getInstructorName(int id) {
		return memberDAO.getInstructorName(id);
	}
	
	@Override
	public String getStudentName(int id) {
		return memberDAO.getStudentName(id);
	}
	
}
