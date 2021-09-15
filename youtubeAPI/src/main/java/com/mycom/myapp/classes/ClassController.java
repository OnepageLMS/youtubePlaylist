package com.mycom.myapp.classes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.commons.ClassesVO;

import net.sf.json.JSONArray;

@Controller
public class ClassController {
	
	@Autowired
	private ClassesService classService;
	
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String dashboard(Model model) {
		int instructorID = 1;	//로그인 정보 가져오는걸로 수정하기 !
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
		
		return "dashboard";
	}	
	
	@RequestMapping(value = "/allMyClass", method = RequestMethod.GET)	//기존 내 class list 가져오기
	public void getAllMyClass(Model model) {
		int instructorID = 1;	//로그인 정보 가져오는걸로 수정하기 !
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
	}
	
	@ResponseBody
	@RequestMapping(value = "/allMyClassMap", method = RequestMethod.GET) //outer.jsp에서 ajax로 왼쪽 class list 가져오기
	public Object getAllMyClass_Map(Model model) {
		int instructorID = 1;	//로그인 정보 가져오는걸로 수정하기 !
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
	

}
