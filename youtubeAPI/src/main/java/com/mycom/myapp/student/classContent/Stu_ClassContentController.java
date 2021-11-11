package com.mycom.myapp.student.classContent;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.video.Stu_VideoService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/class")
public class Stu_ClassContentController {
	@Autowired
	private ClassesService classService;	//나중에 아래랑 이름 구분하기! 
	
	@Autowired
	private Stu_ClassesService classesService;
	
	@Autowired
	private Stu_ClassContentService classContentService;
	
	@Autowired
	private Stu_VideoService videoService;
	
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	
	@Autowired
	private MemberService memberService;
	
	private int studentID = 0;
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)	
	public String contentList(@PathVariable("classID") int classID, Model model, HttpSession session) {
		studentID = (Integer)session.getAttribute("userID");
		System.out.println("studentID ?? " + studentID);
		//권한 가지고 있는지 check!!
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID); 
		model.addAttribute("classInfo", classesService.getClass(classID)); //class테이블에서 classID가 같은 모든 것을 가져온다.
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		//지금 studentID가 제대로 안들어간다..
		//해당 플레이리스트에서 watched가 1인거 ..
		
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //여기 수정 
		System.out.println("playlistID : " + classContentService.getAllClassContent(classID).get(2).getPlaylistID());
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(studentID)));
		model.addAttribute("playlistCheck", JSONArray.fromObject(playlistcheckService.getAllPlaylist()));
		model.addAttribute("className", classService.getClassName(classID));
		return "class/contentsList_Stu";
	}
	
	
}
