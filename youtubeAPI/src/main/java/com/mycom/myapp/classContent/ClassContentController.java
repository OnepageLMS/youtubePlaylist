package com.mycom.myapp.classContent;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
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
	private MemberService memberService;
  
	private int instructorID = 1;
	private int classID;
	
	@RequestMapping(value = "/contentList/{classId}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classId") int classId, Model model) {
		classID = classId;
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(classID)));
		model.addAttribute("allFileContents", JSONArray.fromObject(classContentService.getFileClassContent(classID)));
		
		model.addAttribute("realAllContents", JSONArray.fromObject(classContentService.getRealAll(classID))); // 그냥 모든 강의 컨텐츠 우선은 가져오려고,
			
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		model.addAttribute("className", classService.getClassName(classID));
		return "class/contentsList";
	}

	@RequestMapping(value = "/contentDetail/{id}/{daySeq}", method = RequestMethod.GET) //class contents 전체 보여주기
	public String contentDetail(@PathVariable("id") int id, @PathVariable("daySeq") int daySeq, Model model) {
		//int classID = Integer.parseInt(request.getParameter("classID"));
		
		//ClassContentVO vo = classContentService.getOneContent(id);
		//model.addAttribute("vo", vo);
		// contentDetail 페이지이에서 강의컨텐츠 목록 보여주기 구현중 (21/09/13) 
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //classID 임의로 0 넣어두었다.
		//model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		/*VideoVO pvo = new VideoVO();
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		ClassContentVO ccvo = new ClassContentVO();
		
		ccvo.setPlaylistID(playlistID);
		ccvo.setId(id);
		ccvo.setClassID(classID); //임의로 1번 class 설정
		
		model.addAttribute("classInfo", classesService.getClass(classID)); 
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("vo", classContentService.getOneContent(id));
		model.addAttribute("playlist", JSONArray.fromObject(videoService.getVideoList(pvo)));
		model.addAttribute("playlistSameCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); */
		//return "t_contentsList_Stu2";
		return "class/contentDetail";
	}
	
	@ResponseBody
	@RequestMapping(value = "/forInstructorContentDetail", method = RequestMethod.POST)
	public List<ClassContentVO> forInstructorContentDetail(HttpServletRequest request, Model model) throws Exception {
		
		
		return classContentService.getAllClassContent(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/instructorAllContents", method = RequestMethod.POST)
	public List<ClassContentVO> instructorAllContents(HttpServletRequest request, Model model) throws Exception {
		
		
		return classContentService.getRealAll(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<PlaylistVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		
		//playlistmapper를 통해 playlistID에 맞는 영상들을 가져와서 리턴해주는역할을 해야한ㄷㅏ. 
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
	

	
	/*
	@ResponseBody
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(@ModelAttribute ClassContentVO vo) {
		System.out.println("addContentOK!!??");
		//int classID = vo.getClassID();
		vo.setDaySeq(classContentService.getDaySeq(vo));
		
		if (classContentService.insertContent(vo) == 0) {
			System.out.println("classContents 추가 실패!");
			return "ok";
		}
		else
			System.out.println("classContents 추가 성공!");
		return "false";
	}*/
	
	@ResponseBody
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(HttpServletRequest request, Model model) {
		ClassContentVO vo = new ClassContentVO();
		
		System.out.println(request.getParameter("playlistID"));
		vo.setClassID(Integer.parseInt(request.getParameter("id")));
		vo.setDays(Integer.parseInt(request.getParameter("days")));
		vo.setTitle(request.getParameter("title"));
		vo.setDescription(request.getParameter("description"));
		vo.setStartDate(request.getParameter("startDate"));
		
		String endDate = request.getParameter("endDate");
		String playlistID = request.getParameter("playlistID");
		if(endDate != "")
			vo.setEndDate(endDate);
		if(Integer.parseInt(playlistID) != 0) { //playlist와 함께 insert 
			vo.setPlaylistID(Integer.parseInt(playlistID));
			
			if(classContentService.insertContent(vo) != 0) {
				System.out.println("add classcontent 성공");
				return "ok";
			}
			else {
				return "false";
			}
		}
		else { // url만 insert 
			if(classContentService.insertURLContent(vo) != 0) {
				System.out.println("add URLclasscontent 성공");
				return "ok";
			}
			else {
				return "false";
			}
		}
			
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateClassContents", method = RequestMethod.POST)
	public int updateClassContents(HttpServletRequest request, Model model) throws Exception {	
		//SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//Date endDate = fm.parse(request.getParameter("endDate"));
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setTitle(request.getParameter("className"));
		ccvo.setDescription(request.getParameter("classDescription"));
		ccvo.setEndDate(request.getParameter("endDate"));
		ccvo.setId(Integer.parseInt(request.getParameter("classContentID")));
		
		
		if( classContentService.updateContent(ccvo) == 0) {
			System.out.println("modal을 통한 classcontent 업데이트 실패");
			return 0;
		}
		else {
			return 1;
		}
	   
	}
	
	/*@ResponseBody
	@RequestMapping(value = "/deleteClassContents", method = RequestMethod.POST)
	public void deleteClassContents(HttpServletRequest request, Model model) throws Exception {
		
		if( classContentService.deleteContent(Integer.parseInt(request.getParameter("classContentID"))) == 0) {
			System.out.println("modal을 통한 classcontent 삭제 실패");
		}
	}*/
	
	
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
	@RequestMapping(value = "/deleteDay", method = RequestMethod.POST)
	public int deleteDay(HttpServletRequest request, Model model) throws Exception {
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(Integer.parseInt(request.getParameter("classID")));
		ccvo.setDays(Integer.parseInt(request.getParameter("days"))-1);
		
		if( classContentService.deleteContent(ccvo) == 0) { //강의 컨텐츠가 없는 차시를 지울때
			if(classService.deleteDay(Integer.parseInt(request.getParameter("classID"))) == 0) { 
				return 0;
			}
			else {
				return 1;
			}
		}
		else { //강의 컨텐츠가 있는 차시 지울 
			if(classService.deleteDay(Integer.parseInt(request.getParameter("classID"))) == 0) { 
				return 0;
			}
			else {
				return 1;
			}
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/updatePublished", method = RequestMethod.POST)
	public int updatePublished(HttpServletRequest request, Model model) throws Exception {
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setId(Integer.parseInt(request.getParameter("id")));
		ccvo.setPublished(Integer.parseInt(request.getParameter("published"))); // db에는 tinyint로 되어있음.. VO 수정하기
		
		if( classContentService.updatePublished(ccvo) == 0) {
			System.out.println("publish 업데이트 실패!");
			return 0;
		}
		else {
			return 1;
		}  
	}

	/*@RequestMapping(value = "/deleteContent/{classID}/{id}", method = RequestMethod.GET)
	public String deleteContent(@PathVariable("classID") int classID, @PathVariable("id") int id) {
		if (classContentService.deleteContent(id) == 0)
			System.out.println("classContent 삭제 실패!");
		else
			System.out.println("classContent 삭제 성공!");
		
		return "redirect:../../contentList/" + classID;
	}*/
}
