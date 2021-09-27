package com.mycom.myapp.classes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.commons.ClassesVO;

import net.sf.json.JSONArray;

@Controller
public class ClassController {
	
	@Autowired
	private ClassesService classService;
	
	private int instructorID;
	
	@RequestMapping(value = "/dashboard/{instructorId}", method = RequestMethod.GET)
	public String dashboard(@PathVariable("instructorId") int instructorId, Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		instructorID = instructorId;
		return "class/dashboard";
	}	
	
	@RequestMapping(value = "/allMyClass", method = RequestMethod.GET)	//기존 내 class list 가져오기 --> 나중에 지우기
	public void getAllMyClass(Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
	}
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") String classID) {
		ClassesVO vo = classService.getClass(Integer.parseInt(classID));
		return vo;
	}
	
	@RequestMapping(value = "/addDays", method = RequestMethod.POST) //class days 추가
	public String addContent(ClassesVO vo) {
		if (classService.updateDays(vo) != 0)
			System.out.println("addDays 성공");
		else
			System.out.println("addDays 실패");
		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping(value="/insertClassroom", method = RequestMethod.POST)
	public String insertClassroom(@ModelAttribute ClassesVO vo) {
		vo.setInstructorID(instructorID);//임의로 instructorID 설정 
		
		if (classService.insertClassroom(vo) != 0) {
			System.out.println("controller 강의실 생성 성공");
			return "ok";
		}
		else {
			System.out.println("controller 강의실 생성 실패");
			return "error";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/editClassroom", method = RequestMethod.POST)	//classroom 생성 처리
	public String editClassroom(@ModelAttribute ClassesVO vo) {
		System.out.println(vo.getTag());
		if (classService.updateClassroom(vo) != 0) {
			System.out.println("controller 강의실 수정 성공");
			return "ok";
		}
		else {
			System.out.println("controller 강의실 수정 실패");
			return "error";
		}
		
	}

}
