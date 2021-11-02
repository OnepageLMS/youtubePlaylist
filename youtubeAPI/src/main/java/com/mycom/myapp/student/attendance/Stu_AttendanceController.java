package com.mycom.myapp.student.attendance;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/attendance")
public class Stu_AttendanceController {
	@Autowired
	private Stu_ClassesService classesService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private MemberService memberService;
	
	private int instructorID = 1;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)
	public String attendancehome(@PathVariable("classId") int classId, Model model) {
		classID = classId;
		model.addAttribute("classInfo", classesService.getClass(classID)); 
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(1)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(1)));
		
		model.addAttribute("takes", stu_takesService.getStudentNum(classID));
		model.addAttribute("takesNum", stu_takesService.getStudentNum(classID).size());
		return "class/attendance_Stu";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {
		
		return stu_takesService.getStudentNum(Integer.parseInt(request.getParameter("classID")));
	}
}
