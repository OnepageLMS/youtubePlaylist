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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
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
	private Stu_ClassesService classService_stu;
	
	@Autowired
	private Stu_ClassContentService classContentService;
	
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	
	@Autowired
	private Stu_VideoService videoService;
	
	private int studentID = 0;
	private int classID = 0;
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)	
	public String contentList(@PathVariable("classID") int classId, Model model, HttpSession session) {
		studentID = (Integer)session.getAttribute("userID");
		classID = classId;
		ClassesVO vo = new ClassesVO();
		vo.setId(classID);
		vo.setStudentID(studentID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(studentID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(studentID)));
		
		if(classService_stu.checkTakeClass(vo) == 0) {
			System.out.println("수강중인 과목이 아님!");
			return "accessDenied_stu";
		}
		
		//ClassContentVO ccvo = new ClassContentVO();
		//ccvo.setClassID(classID); 
		model.addAttribute("classInfo", classService_stu.getClass(classID)); //class테이블에서 classID가 같은 모든 것을 가져온다.
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		//지금 studentID가 제대로 안들어간다..
		//해당 플레이리스트에서 watched가 1인거 ..
		
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //여기 수정 
		
		model.addAttribute("playlistCheck", JSONArray.fromObject(playlistcheckService.getAllPlaylist()));
		model.addAttribute("className", classService.getClassName(classID));
		return "class/contentsList_Stu";
	}
	
	@RequestMapping(value = "/contentDetail", method = RequestMethod.POST) //class contents 전체 보여주기
	public String contentDetail(@RequestParam("playlistID") int playlistID, 
								@RequestParam("id") int id, 
								@RequestParam("daySeq") int day, Model model) {

		//아래는 Stu_ClassController에 이함수가 있을 때 있떤건데 없어도될것같다
		//playlistID = playlistId;
		//id = ID;
		//classID = classId;
		//daySeq = day;
		
		VideoVO pvo = new VideoVO();
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setPlaylistID(playlistID);
		ccvo.setId(id);
		ccvo.setClassID(classID); 
		
		//model.addAttribute("allMyClass", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("classInfo", classService_stu.getClass(classID)); 
		//model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("vo", classContentService.getOneContent(id));
		model.addAttribute("playlist", JSONArray.fromObject(videoService.getVideoList(pvo)));
		model.addAttribute("playlistSameCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); 
		model.addAttribute("allMyClass", JSONArray.fromObject(classService_stu.getAllMyClass(classID))); // 1=>classID
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService_stu.getAllMyInactiveClass(classID))); 
		return "class/contentsDetail_Stu";
		
	}
	
	
}
