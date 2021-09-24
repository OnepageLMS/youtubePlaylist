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
  
	private String email = "yewon@gmail.com";	//임시 이메일. 나중에 로그인한 정보에서 이메일 가져와야 함
	private int instructorID = 1;
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classID") int classID, Model model) {
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(classID)));
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
		
		return "t_contentsList";
		//return "contentsList";
	}

	@RequestMapping(value = "/contentDetail/{id}/{daySeq}", method = RequestMethod.GET) //class contents 전체 보여주기
	public String contentDetail(@PathVariable("id") int id, @PathVariable("daySeq") int daySeq, Model model) {
		//int classID = Integer.parseInt(request.getParameter("classID"));
		
		ClassContentVO vo = classContentService.getOneContent(id);
		model.addAttribute("vo", vo);
		System.out.println(vo.getClassID());
		System.out.println(vo.getClassName());
		
//		// contentDetail 페이지이에서 강의컨텐츠 목록 보여주기 구현중 (21/09/13) 
		model.addAttribute("classInfo", classService.getClass(0)); //여기도 임의로 classID 0 넣어두었다.
		model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(0))); //classID 임의로 0 넣어두었다.
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(instructorID)));
		
		
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
		return "t_contentDetail";
	}
	
	@ResponseBody
	@RequestMapping(value = "/forInstructorContentDetail", method = RequestMethod.POST)
	public Map<Integer, Object> forInstructorContentDetail(HttpServletRequest request, Model model) throws Exception {
		//List<Map<Integer, Object>> listMap = new ArrayList<Map<Integer, Object>>();
		Map<Integer, Object> map = new HashMap<Integer, Object>();
				
		int classID = Integer.parseInt(request.getParameter("classID"));
		
		List<ClassContentVO> VOlist = new ArrayList<ClassContentVO>();
		VOlist = classContentService.getAllClassContent(classID);
				
		for(int i=0; i<VOlist.size(); i++) {
			map.put(i, VOlist.get(i));
		}
		
		return map;
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
	@RequestMapping(value = "/updateClassContents", method = RequestMethod.POST)
	public int updateClassContents(HttpServletRequest request, Model model) throws Exception {
		System.out.println("className : " + request.getParameter("className") + "classDescription : " + request.getParameter("classDescription") + "endDate : " + request.getParameter("endDate") + "id: " +request.getParameter("id"));
		//잘 넘어오는 중! 마감일만 잘 받아서 db에 update하면 된다 //마감일도 잘 받음!
		
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endDate = fm.parse(request.getParameter("endDate"));
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setTitle(request.getParameter("className"));
		ccvo.setDescription(request.getParameter("classDescription"));
		ccvo.setEndDate(endDate);
		ccvo.setId(Integer.parseInt(request.getParameter("id")));
		
		
		if( classContentService.updateContent(ccvo) == 0) {
			System.out.println("modal을 통한 classcontent 업데이트 실패");
			return 0;
		}
		else {
			return 1;
		}
	   
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateDays", method = RequestMethod.POST)
	public int updateDays(HttpServletRequest request, Model model) throws Exception {
		int classID = Integer.parseInt(request.getParameter("classID"));
		//System.out.println("??");
		ClassesVO cvo = new ClassesVO();
		cvo.setId(classID);
		if( classService.updateDays(cvo) == 0) {
			return 0;
		}
		else {
			return 1;
		}
	   
	}
	
	@RequestMapping(value = "/addContent/{classID}/{day}", method = RequestMethod.GET) //사용안함
	public String addContent(@PathVariable("classID") int classID, @PathVariable("day") int day, Model model) {
		
		ClassContentVO vo = new ClassContentVO();
		vo.setClassID(classID);
		vo.setDays(day);
		model.addAttribute("content", vo);
		
		return "addContent";
	}
	
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(ClassContentVO vo) {
		System.out.println("addContentOK!!??");
		int classID = vo.getClassID();
		vo.setDaySeq(classContentService.getDaySeq(vo));
		
		if (classContentService.insertContent(vo) == 0)
			System.out.println("classContents 추가 실패!");
		else
			System.out.println("classContents 추가 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/editContent/{id}", method = RequestMethod.GET)
	public String editContent(@PathVariable("id") int id, Model model) {
		ClassContentVO vo = classContentService.getOneContent(id);
		model.addAttribute("vo", vo);
		return "editContent";
	}
	
	@RequestMapping(value = "/editContentOK", method = RequestMethod.POST)
	public String editContentOK(ClassContentVO vo) {
		int classID = vo.getClassID();
		
		if (classContentService.updateContent(vo) == 0)
			System.out.println("classContent 수정 실패!");
		else
			System.out.println("classContent 수정 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/deleteContent/{classID}/{id}", method = RequestMethod.GET)
	public String deleteContent(@PathVariable("classID") int classID, @PathVariable("id") int id) {
		if (classContentService.deleteContent(id) == 0)
			System.out.println("classContent 삭제 실패!");
		else
			System.out.println("classContent 삭제 성공!");
		
		return "redirect:../../contentList/" + classID;
	}
}
