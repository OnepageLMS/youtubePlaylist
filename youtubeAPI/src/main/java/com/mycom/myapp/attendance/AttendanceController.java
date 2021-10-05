package com.mycom.myapp.attendance;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.student.takes.Stu_TakesService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/attendance")
public class AttendanceController {
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	private int instructorID = 1;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)
	public String attendancehome(@PathVariable("classId") int classId, Model model) {
		classID = classId;
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		//model.addAttribute("howmany", stu_takesService.getStudentNum(classID));
		return "class/attendance";
	}	
}
