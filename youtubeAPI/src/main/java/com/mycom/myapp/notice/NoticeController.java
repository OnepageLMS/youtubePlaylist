package com.mycom.myapp.notice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;

import net.sf.json.JSONArray;

@Controller
public class NoticeController {
	private int instructorID = 1;
	
	@Autowired
	private NoticeService noticeService;
	@Autowired
	private ClassesService classService;
	@Autowired
	private MemberService memberService;
	@Autowired
	private Stu_TakesService takesService;
	
	private int classID;
	
	@RequestMapping(value="/notice", method = {RequestMethod.GET, RequestMethod.POST})
	public String notice(@RequestParam(value="classID") int classID, Model model) {
		model.addAttribute("classID", classID);
		model.addAttribute("allMyClass", classService.getAllMyActiveClass(instructorID));
		model.addAttribute("allMyInactiveClass", classService.getAllMyInactiveClass(instructorID));
		model.addAttribute("myName", memberService.getInstructorName(instructorID));
		model.addAttribute("className", classService.getClassName(classID));
		return "class/notice";
	}
	
	@RequestMapping(value = "/addNotice", method = RequestMethod.POST)
	@ResponseBody
	public void addNotice(@ModelAttribute NoticeVO vo) {
		int noticeID = noticeService.insertNotice(vo);
		
		if(noticeID > 0) {
			System.out.println(noticeID + " notice 추가 성공! ");
			
			//noticeCheck에 record 생성
			int noticeClassID = vo.getClassID();
			List<Stu_TakesVO> students = takesService.getAllClassStudent(noticeClassID);	//수강 학생 리스트 가져오기
			for(int i=0; i<students.size(); i++) {
				NoticeVO newRecord = new NoticeVO();
				int studentID = students.get(i).getStudentID();
				newRecord.setId(noticeID);
				newRecord.setStudentID(studentID);
				if(noticeService.insertNoticeCheckRecord(newRecord) != 0)
					System.out.println(studentID + ":" + i + " noticeCheck record생성됨!");
			}
		}
			
		else
			System.out.println("notice 추가 실패! ");
	}
	
	@RequestMapping(value = "/updateNotice", method = RequestMethod.POST)
	@ResponseBody
	public void upateNotice(@ModelAttribute NoticeVO vo) {
		if(noticeService.updateNotice(vo) != 0) 
			System.out.println("notice 추가 성공! ");
		else
			System.out.println("notice 추가 실패! ");
	}
	
	
	@RequestMapping(value = "/deleteNotice", method = RequestMethod.POST)
	@ResponseBody
	public void deleteNotice(@RequestParam(value="id") int id) {
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
