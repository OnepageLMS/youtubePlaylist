package com.mycom.myapp.classes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import net.sf.json.JSONArray;

@Controller
public class ClassController {
	
	@Autowired
	private ClassesService classService;
	
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String dashboard(Model model) {
		String email = "yewon.lee@onepage.edu";	//로그인 정보 가져오는걸로 수정하기 !
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(email)));
		
		return "dashboard";
	}	
	
	@RequestMapping(value = "/dashboard2", method = RequestMethod.GET)
	public String t_dashboard(Model model) {
		String email = "yewon.lee@onepage.edu";	//로그인 정보 가져오는걸로 수정하기 !
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(email)));
		
		return "class/dashboard";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/allMyClass", method = RequestMethod.GET)	//outer.jsp에서 ajax로 왼쪽 class list 가져오기
	public void getAllMyClass(Model model) {
		String email = "yewon.lee@onepage.edu";	//로그인 정보 가져오는걸로 수정하기 !
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(email)));
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
