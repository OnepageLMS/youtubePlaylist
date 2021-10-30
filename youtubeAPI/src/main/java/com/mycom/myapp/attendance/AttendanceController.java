package com.mycom.myapp.attendance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/attendance")
public class AttendanceController {
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private MemberService memberService;
	
	private int instructorID = 1;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)
	public String attendancehome(@PathVariable("classId") int classId, Model model) {
		classID = classId;
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		model.addAttribute("myName", memberService.getInstructorName(instructorID));
		
		model.addAttribute("takes", stu_takesService.getStudentNum(classID));
		model.addAttribute("takesNum", stu_takesService.getStudentNum(classID).size());
		// 학생 email, phone 정보 (jw)
		model.addAttribute("studentInfo", stu_takesService.getStudentInfo(classId));
		return "class/attendance";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {
		
		return stu_takesService.getStudentNum(Integer.parseInt(request.getParameter("classID")));
	}
	
	//(jw) 
	@ResponseBody
	@RequestMapping(value ="/allowTakes", method = RequestMethod.POST)
	public int allowTakes(@RequestBody Stu_TakesVO vo) {
		int result = stu_takesService.updateStatus(vo);
		
		if(classService.updateTotalStudent(vo.getClassID()) == 1) 
			System.out.println("totalStudent 업데이트 성공!");
		else 
			System.out.println("totalStudent 업데이트 실패 ");

		return result;
	}
	
	@ResponseBody
	@RequestMapping(value ="/deleteTakes" , method = RequestMethod.POST)
	public int deleteTakes(@RequestBody Stu_TakesVO vo) {
		System.out.println(vo.getClassID() + vo.getStudentID());
		int result = stu_takesService.deleteStudent(vo);
		
		if(classService.updateTotalStudent(vo.getClassID()) == 1) 
			System.out.println("totalStudent 업데이트 성공!");
		else
			System.out.println("totalStudent 업데이트 실패 ");	
				
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/updateTakesList", method = RequestMethod.GET)
	public Object updateList(@RequestParam(value = "classID") int classID, Model model) {
//		model.addAttribute("classInfo", classService.getClass(classID));
//		model.addAttribute("studentInfo", stu_takesService.getStudentInfo(classID));
		
		List<Stu_TakesVO> takesList = new ArrayList<Stu_TakesVO>();
		takesList = stu_takesService.getStudentInfo(classID);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("studentInfo", takesList);

		return map; 
	}
	
} 
























