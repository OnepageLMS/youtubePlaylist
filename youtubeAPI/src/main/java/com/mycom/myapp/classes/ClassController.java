package com.mycom.myapp.classes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.member.MemberService;

import net.sf.json.JSONArray;

@Controller
public class ClassController {
	
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private ClassContentService classContentService;
	
	@Autowired
	private MemberService memberService;
	
	private int instructorID = 1;
	
	@RequestMapping(value = "/dashboard",  method = { RequestMethod.GET, RequestMethod.POST })
	public String dashboard(Model model) {
		return "class/dashboard";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") int classID) {
		ClassesVO vo = classService.getClass(classID);
		return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllMyClass", method = RequestMethod.POST)
	public Object getAllNotices(HttpSession session) {
		int instructorID = (Integer)session.getAttribute("login");
		List<ClassesVO> list = classService.getAllMyActiveClass(instructorID);
		List<ClassesVO> inactiveList = classService.getAllMyInactiveClass(instructorID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("active", list);
		map.put("inactive", inactiveList);
		return map;
	}
	
	@RequestMapping(value = "/addDays", method = RequestMethod.POST) 
	public String addContent(ClassesVO vo) {
		if (classService.updateDays(vo) != 0)
			System.out.println("addDays 성공");
		else
			System.out.println("addDays 실패");
		
		return "ok";
	}
	
	// (jw) entryCode 생성에 사용함. 
	@ResponseBody
	@RequestMapping(value = "/createEntryCode", method = RequestMethod.POST)	
	public String createEntryCode() {
		List<String> list = classService.getAllEntryCodes();
		StringBuilder entryCode = new StringBuilder();
		String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ";
		int flag = 1;
		Random rand = new Random();
		
		while(true) {
			for(int i=0; i<6; i++) {
				entryCode.append(chars.charAt(rand.nextInt(36)));
			}
			for(String codes : list) {
				if(codes.toString().equals(entryCode.toString())) {
					flag = 0;
				}
			}
			if(flag == 1) break;
		}
		String result = entryCode.toString();
		
		return result;
	}
	
	@RequestMapping(value="/insertClassroom", method = RequestMethod.POST)
	public String insertClassroom(@ModelAttribute ClassesVO vo, @RequestParam(value = "code") String entryCode) {
		vo.setInstructorID(instructorID);
		vo.setEntryCode(entryCode);

		if (classService.insertClassroom(vo) >= 0) 
			System.out.println("controller 강의실 생성 성공"); 
		else 
			System.out.println("controller 강의실 생성 실패");
		return "class/dashboard";
		
	}
	
	
	@RequestMapping(value="/editClassroom", method = {RequestMethod.GET,RequestMethod.POST})	//classroom 생성 처리
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
	
	@ResponseBody
	@RequestMapping(value="/copyClassroom", method = RequestMethod.POST)
	public int copyClassroom(@RequestParam(value = "id") int classID) {
		
		ClassesVO vo = classService.getClassInfoForCopy(classID);	//Copy할 기존 강의실 데이터 가져오기
		vo.setInstructorID(instructorID);
		String name = vo.getClassName() + "-1";
		vo.setClassName(name);
		
		int newClassID = classService.insertClassroom(vo); //새로 생성된 classID 저장
		if(newClassID >= 0)	//복사한 classContents 각 row에 설정된 nextClassID와 같은지 check
			System.out.println("Class 생성 성공");
		else {
			System.out.println("Class 생성 실패");
			return 0;
		}
	
		// lms_classContent에 기존 classID의 내용 가져오기
			// days, daySeq, title, description, playlistID만 가져오기
		List<ClassContentVO> original = classContentService.getAllClassContentForCopy(classID);
		for (int i=0; i<original.size(); i++) {	
			original.get(i).setClassID(newClassID);	//newClassID 로 설정
			System.out.println(i + " : " + original.get(i).getClassID());
		}	
	
		// 새로 생성된 classID에 다 넣기
		if(classContentService.insertCopiedClassContents(original) != 0) //transaction 필요
			System.out.println("class contents 복사 완료!");
		else {
			System.out.println("class contents 복사 실패!");
			return 0;
		}
		
		return 1;
	}
	


}
