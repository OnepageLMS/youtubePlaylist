package com.mycom.myapp.classContent;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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

import com.mycom.myapp.attendance.AttendanceService;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.commons.PlaylistVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.member.MemberService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/class")
public class ClassContentController {
	@Autowired
	private ClassesService classService;
	@Autowired
	private ClassContentService classContentService;
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private Stu_PlaylistCheckService playlistCheckService;
	@Autowired
	private AttendanceService attendanceService;
  
	private int instructorID = 0;
	private int classID;
	
	@RequestMapping(value = "/contentList/{classId}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classId") int classId, Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		ClassesVO vo = new ClassesVO();
		vo.setId(classId);
		vo.setInstructorID(instructorID);
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		if(classService.checkAccessClass(vo) == 0) {
			System.out.println("???????????? ??????!");
			return "accessDenied";
		}
		
		classID = classId;
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(classID)));
		model.addAttribute("allFileContents", JSONArray.fromObject(classContentService.getFileClassContent(classID)));
		
		model.addAttribute("realAllContents", JSONArray.fromObject(classContentService.getRealAll(classID))); // ?????? ?????? ?????? ????????? ????????? ???????????????,
		model.addAttribute("className", classService.getClassName(classID));
		return "class/contentsList";
	}
	
	@RequestMapping(value = "/contentDetail", method = {RequestMethod.POST, RequestMethod.GET}) //class contents ?????? ????????????
	public String contentDetail(@RequestParam("id") int id, @RequestParam("daySeq") int daySeq, Model model) {	//post??? ????????????
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //classID ????????? 0 ???????????????.
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		model.addAttribute("id", id);
		model.addAttribute("daySeq", daySeq);
		return "class/contentDetail";
	}
	
	@ResponseBody
	@RequestMapping(value = "/forHowManyWatch", method = RequestMethod.POST)
	public int forHowManyWatch(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		Stu_PlaylistCheckVO spcvo = new Stu_PlaylistCheckVO();
		spcvo.setClassID(classID);
		spcvo.setPlaylistID(playlistID);
		
		return playlistCheckService.getHowMany(spcvo);
	}
	
	@ResponseBody
	@RequestMapping(value = "/forInstructorContentDetail", method = RequestMethod.POST)
	public List<ClassContentVO> forInstructorContentDetail(HttpServletRequest request, Model model) throws Exception {
		
		
		return classContentService.getAllClassContent(classID);
	}
	
	@ResponseBody
	@RequestMapping(value = "/instructorAllContents", method = RequestMethod.POST)
	public List<ClassContentVO> instructorAllContents(HttpServletRequest request, Model model) throws Exception {
		
		
		return classContentService.getRealAll(classID);
	}
	
	@ResponseBody
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<PlaylistVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		
		//playlistmapper??? ?????? playlistID??? ?????? ???????????? ???????????? ???????????????????????? ???????????????. 
		PlaylistVO vo = new PlaylistVO();
	    vo.setId(playlistID);
	    
	    return playlistService.getPlaylistForInstructor(vo);
	}
	
	@ResponseBody
	@RequestMapping(value = "/changeID", method = RequestMethod.POST)
	public ClassContentVO changeID(HttpServletRequest request, Model model) throws Exception {
		ClassContentVO vo = classContentService.getOneContentInstructor(Integer.parseInt(request.getParameter("id")));
	    
	    return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(@ModelAttribute ClassContentVO vo, Model model) throws ParseException {		
		if(vo.getEndDate().equals(""))
			vo.setEndDate(null);
		if(vo.getPlaylistID() != 0) {
			if(classContentService.insertContent(vo) != 0) {
				System.out.println("add classcontent ??????");
				return "ok";
			}
			else return "false";
		}

		else { //playlistID ?????? insert
			if(classContentService.insertURLContent(vo) != 0) {
				System.out.println("add URLclasscontent ??????");
				return "ok";
			}
			else return "false";
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateClassContents", method = RequestMethod.POST)
	public int updateClassContents(@ModelAttribute ClassContentVO ccvo, HttpServletRequest request, Model model) throws Exception {	
		if(ccvo.getEndDate() == "") ccvo.setEndDate(null);
		
		/*ClassContentVO ccvo = new ClassContentVO();
		ccvo.setTitle(request.getParameter("className"));
		ccvo.setDescription(request.getParameter("classDescription"));
		ccvo.setEndDate(endDate);
		ccvo.setId(Integer.parseInt(request.getParameter("classContentID")));
		*/
		
		if( classContentService.updateContent(ccvo) == 0) {
			System.out.println("modal??? ?????? classcontent ???????????? ??????");
			return 0;
		}
		else {
			return 1;
		}
	   
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteClassContent", method = RequestMethod.POST)
	public void deleteClassContent(HttpServletRequest request, Model model) throws Exception {
		
		if( classContentService.deleteContent(Integer.parseInt(request.getParameter("classContentID"))) == 0) {
			System.out.println("classcontent ?????? ??????");
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteDay", method = RequestMethod.POST)
	public int deleteDay(HttpServletRequest request, Model model) throws Exception {
		int class_id = Integer.parseInt(request.getParameter("classID"));
		int days = Integer.parseInt(request.getParameter("days"))-1;
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(class_id);
		ccvo.setDays(days);
		
		if( classContentService.deleteContentList(ccvo) != 0) { //?????? ???????????? ?????? ????????? ?????????
			System.out.println("classContent ?????? ??????!");
			
			AttendanceVO att_vo = new AttendanceVO();
			att_vo.setClassID(class_id);
			att_vo.setDays(days);
			if(attendanceService.deleteAttendance(att_vo) != 0) {
				System.out.println("attendance ?????? ??????!");
			}
		}
		
		if(classService.deleteDay(class_id) == 0) {
			System.out.println("classDay ?????? ??????!");
			return 0;
		}
		
		System.out.println("???????????? ??????!");
		return 1;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/updateDays", method = RequestMethod.POST)
	public int updateDays(HttpServletRequest request, Model model) throws Exception {
		int classID = Integer.parseInt(request.getParameter("classID"));
		ClassesVO cvo = new ClassesVO();
		cvo.setId(classID);
		
		if (classService.updateDays(cvo) == 0) return 0;
		else return 1;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getBiggestUsedDay", method = RequestMethod.POST)
	public int getBiggestUsedDay(@RequestParam(value="classID") int classID)  {	//??? ????????? ?????? ???????????? ???????????? ???????????? ??? ?????? ??? ?????? ?????? ????????????
		int biggestDay = classContentService.getBiggestUsedDay(classID);
		if(biggestDay < 0)
			System.out.println("getBiggestUsedDay ???????????? ??????!");
		else
			System.out.println("getBiggestUsedDay ???????????? ??????!");
		return biggestDay;
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/updatePublished", method = RequestMethod.POST)
	public int updatePublished(HttpServletRequest request, Model model) throws Exception {
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setId(Integer.parseInt(request.getParameter("id")));
		ccvo.setPublished(Integer.parseInt(request.getParameter("published"))); // db?????? tinyint??? ????????????.. VO ????????????
		
		if( classContentService.updatePublished(ccvo) == 0) {
			System.out.println("publish ???????????? ??????!");
			return 0;
		}
		else {
			return 1;
		}  
	}
}
