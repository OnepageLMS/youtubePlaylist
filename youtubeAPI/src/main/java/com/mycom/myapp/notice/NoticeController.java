package com.mycom.myapp.notice;

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

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.member.MemberService;


@Controller
public class NoticeController {
	private int instructorID = 1;
	
	@Autowired
	private NoticeService noticeService;
	@Autowired
	private ClassesService classService;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping(value="/notice", method = RequestMethod.POST)
	public String notice(@RequestParam(value="classID") int id, Model model) {
		model.addAttribute("classID", id);
		model.addAttribute("allMyClass", classService.getAllMyActiveClass(instructorID));
		model.addAttribute("allMyInactiveClass", classService.getAllMyInactiveClass(instructorID));
		model.addAttribute("myName", memberService.getInstructorName(instructorID));
		model.addAttribute("className", classService.getClassName(id));
		
		model.addAttribute("allNotices", noticeService.getAllNotice(id));
		return "class/notice";
	}
	
	@RequestMapping(value = "/addNotice", method = RequestMethod.POST)
	@ResponseBody
	public void addNotice(@ModelAttribute NoticeVO vo) {
		if(noticeService.insertNotice(vo) != 0) 
			System.out.println("notice 추가 성공! ");
		else
			System.out.println("notice 추가 실패! ");
	}
	
	@RequestMapping(value = "/updateNotice", method = RequestMethod.POST)
	@ResponseBody
	public void updateNotice(@ModelAttribute NoticeVO vo) {
		System.out.println(vo.getId());
		if(noticeService.updateNotice(vo) != 0) 
			System.out.println("notice 업데이트 성공! ");
		else
			System.out.println("notice 업데이트 실패! ");
	}
	
	@RequestMapping(value = "/deleteNotice", method = RequestMethod.POST)
	@ResponseBody
	public void deleteNotice(@RequestParam(value="classID") int id) {
		if(noticeService.deleteNotice(id) != 0) 
			System.out.println("notice 삭제 성공! ");
		else
			System.out.println("notice 삭제 실패! ");
	}
	
	@RequestMapping(value = "/getAllNotice", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllNotices(@RequestParam(value="classID") int id) {
		List<NoticeVO> list = noticeService.getAllNotice(id);
		
		if(list != null) 
			System.out.println("notice list가져오기 성공!");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("notices", list);
		
		return map;
	}
}