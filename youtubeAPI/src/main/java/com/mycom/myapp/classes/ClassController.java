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
	
	/*
	@ResponseBody
	@RequestMapping(value="/insertClassroom", method = RequestMethod.POST)	//not working. but should be changed!
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
	}*/
	
	@ResponseBody
	@RequestMapping(value="/insertClassroom", method = RequestMethod.POST)	//classroom 생성 처리
	public String insertClassroom(@RequestParam(value = "className") String className,
									@RequestParam(value = "description") String description,
									@RequestParam(value = "days") int days,
									@RequestParam(value = "tag") String tag,
									@RequestParam(value = "closeDate") Date closeDate,
									@RequestParam(value = "active") boolean active ) {
		ClassesVO vo = new ClassesVO();
		vo.setInstructorID(instructorID);//임의로 instructorID 설정 
		
		vo.setClassName(className);	//아랫부분 form에서 한번에 전송되서 설정되도록 수정하기
		vo.setDescription(description);
		vo.setDays(days);
		vo.setTag(tag);
		vo.setCloseDate(closeDate);
		vo.setActive(active);
		
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
