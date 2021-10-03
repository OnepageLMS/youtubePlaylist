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
import com.mycom.myapp.member.MemberService;

import net.sf.json.JSONArray;

@Controller
public class ClassController {
	
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private MemberService memberService;
	
	private int instructorID = 1;
	
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String dashboard(Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		model.addAttribute("myName", memberService.getInstructorName(instructorID));
		return "class/dashboard";
	}	
	
	@RequestMapping(value = "/allMyClass", method = RequestMethod.GET)	//기존 내 class list 가져오기 --> 나중에 지우기
	public void getAllMyClass(Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
	}
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") int classID) {
		ClassesVO vo = classService.getClass(classID);
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
		if (classService.updateClassroom(vo) != 0) {
			System.out.println("controller 강의실 수정 성공");
			return "ok";
		}
		else {
			System.out.println("controller 강의실 수정 실패");
			return "error";
		}	
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteForMe", method = RequestMethod.POST)
	public void deleteClassroomForMe(@RequestParam(value = "id") int classID) {
		if(classService.updateInstructorNull(classID) != 0) {
			System.out.println("controller instructor null 성공");
			if(classService.updateActive(classID) != 0) {
				System.out.println("controller class active null 성공");
			}
		}
		else System.out.println("controller delete classroom for me 업데이트 실패");
	}
	
	@ResponseBody
	@RequestMapping(value="/deleteForAll", method = RequestMethod.POST)
	public void deleteClassroomForAll(@RequestParam(value = "id") int classID) {
		// lms_class row 
			//(+ takes, classContent, playlistCheck, videoCheck, attnedance, attendanceCheck 도 한번에) 삭제
		if(classService.deleteClassroom(classID) != 0) 
			System.out.println("controller delete classroom 성공");
		else
			System.out.println("controller delete classroom 실패");
		
	}

}
