package com.mycom.myapp.student.notice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/notice")
public class Stu_NoticeController {
	private int studentId = 1;
	
	@Autowired
	private Stu_NoticeService noticeService;
	@Autowired
	private ClassesService classService;
	@Autowired
	private Stu_ClassesService classService_stu;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping(value="/", method = {RequestMethod.GET, RequestMethod.POST})
	public String studentNotice(@RequestParam(value="classID") int id, Model model) {
		model.addAttribute("classID", id);
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(studentId)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(studentId)));
		model.addAttribute("myName", memberService.getStudentName(studentId));
		model.addAttribute("className", classService.getClassName(id));
		return "class/notice_Stu";
	}
	
	@RequestMapping(value = "/getAllNotice", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllNotices(@RequestParam(value="classID") int id) {
		NoticeVO vo = new NoticeVO();
		vo.setClassID(id);
		vo.setStudentID(studentId);
		List<NoticeVO> list = noticeService.getAllNotice(vo);
		
		if(list != null) 
			System.out.println("notice list가져오기 성공!");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("notices", list);
		
		return map;
	}
	
	@RequestMapping(value = "/insertView", method = RequestMethod.POST)
	@ResponseBody
	public void updateView(@RequestParam(value="noticeID") int id) {
		NoticeVO vo = new NoticeVO();
		vo.setId(id);
		vo.setStudentID(studentId);
		if(noticeService.insertView(vo) != 0) {
			System.out.println("insert view 성공!");
			if(noticeService.updateViewCount(id) != 0)	//pass the noticeID
				System.out.println("viewCount업데이트 성공!");
		}
	}
	
}
