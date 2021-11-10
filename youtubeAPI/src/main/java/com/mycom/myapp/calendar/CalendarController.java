package com.mycom.myapp.calendar;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassesVO;

@Controller
public class CalendarController {
	
	@Autowired
	private ClassesService classService;
	
	private int instructorID = 0;
	
	@RequestMapping(value="/calendar/{classID}", method = {RequestMethod.GET, RequestMethod.POST})
	public String calendar(@PathVariable(value="classID") int classID, Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setInstructorID(instructorID);
		
		if(classService.checkAccessClass(vo) == 0) {
			System.out.println("접근권한 없음!");
			return "accessDenied";
		}
		model.addAttribute("classID", classID);
		model.addAttribute("allMyClass", classService.getAllMyActiveClass(instructorID));
		model.addAttribute("allMyInactiveClass", classService.getAllMyInactiveClass(instructorID));
		model.addAttribute("className", classService.getClassName(classID));
		return "class/calendar";
	}

}
