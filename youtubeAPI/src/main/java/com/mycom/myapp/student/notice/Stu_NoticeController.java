package com.mycom.myapp.student.notice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;

import net.sf.json.JSONArray;

@Controller
public class Stu_NoticeController {
	private int studentId = 1;
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private Stu_ClassesService classService_stu;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping(value="/student/notice", method = {RequestMethod.GET, RequestMethod.POST})
	public String studentNotice(@RequestParam(value="classID") int id, Model model) {
		model.addAttribute("classID", id);
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(studentId)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(studentId)));
		model.addAttribute("myName", memberService.getStudentName(studentId));
		model.addAttribute("className", classService.getClassName(id));
		return "class/notice_Stu";
	}
}
