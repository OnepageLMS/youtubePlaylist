package com.mycom.myapp.classes;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
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
	
	private int instructorID = 1;
	
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String dashboard(Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
		
		return "class/dashboard";
	}	
	
	@RequestMapping(value = "/allMyClass", method = RequestMethod.GET)	//기존 내 class list 가져오기
	public void getAllMyClass(Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
	}
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") String classID) {
		ClassesVO vo = classService.getClass(Integer.parseInt(classID));
		return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/allMyClassMap", method = RequestMethod.GET) //outer.jsp에서 ajax로 왼쪽 class list 가져오기
	public Object getAllMyClass_Map(Model model) {
		List<ClassesVO> classes = new ArrayList<ClassesVO>();
		classes = classService.getAllMyClass(instructorID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allMyClass", classes);
		return map;
	}
	
	@RequestMapping(value = "/addDays", method = RequestMethod.POST) //class contents 추가
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
		System.out.println("controller here!!");
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
	@RequestMapping(value="/insertName", method = RequestMethod.POST)	//classroom 생성 처리
	public String insertName(@RequestParam(value = "name") String name) {
		System.out.println("controller here!!");
		
		ClassesVO vo = new ClassesVO();
		vo.setInstructorID(instructorID);//임의로 instructorID 설정 
		vo.setClassName(name);
		
		if (classService.insertClassroom(vo) != 0) {
			System.out.println("controller 강의실 생성 성공");
			return "ok";
		}
		else {
			System.out.println("controller 강의실 생성 실패");
			return "error";
		}
		
	}

}
