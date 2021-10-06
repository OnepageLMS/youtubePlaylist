package com.mycom.myapp.notice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.member.MemberService;


@Controller
public class NoticeController {
	private int instructorID = 1;
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping(value="/notice", method = RequestMethod.POST)
	public String notice(@RequestParam(value="classID") int id, Model model) {
		
		model.addAttribute("classID", id);
		model.addAttribute("allMyClass", classService.getAllMyActiveClass(instructorID));
		model.addAttribute("allMyInactiveClass", classService.getAllMyInactiveClass(instructorID));
		model.addAttribute("myName", memberService.getInstructorName(instructorID));
		return "class/notice";
	}
}
