package com.mycom.myapp.classContent;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.playlist.PlaylistVO;
import com.mycom.myapp.student.video.Stu_VideoVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/class")
public class ContentsController {
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private ClassContentsService classContentsService;
	@Autowired
	private PlaylistService playlistService;
  
	private String email = "yewon.lee@onepage.edu";	//임시 이메일. 나중에 로그인한 정보에서 이메일 가져와야 함

	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classID") int classID, Model model) {
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentsService.getAllClassContents(classID)));
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyClass(email)));
		return "contentsList";
	}

	@RequestMapping(value = "/contentDetail/{id}", method = RequestMethod.GET) //class contents 전체 보여주기
	public String contentDetail(@PathVariable("id") int id, Model model) {
		ClassContentsVO vo = classContentsService.getOneContent(id);
		model.addAttribute("vo", vo);
		System.out.println("???여기는?");
		return "t_contentDetail";
	}
	
	@ResponseBody
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<PlaylistVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		System.out.println("here!");
		//playlistmapper를 통해 playlistID에 맞는 영상들을 가져와서 리턴해주는역할을 해야한ㄷㅏ. 
		PlaylistVO vo = new PlaylistVO();
	    vo.setPlaylistID(playlistID);
	    
	    return playlistService.getPlaylistForInstructor(vo);
	}
	
	@RequestMapping(value = "/addContent/{classID}/{day}", method = RequestMethod.GET) //사용안함
	public String addContent(@PathVariable("classID") int classID, @PathVariable("day") int day, Model model) {
		
		ClassContentsVO vo = new ClassContentsVO();
		vo.setClassID(classID);
		vo.setDay(day);
		model.addAttribute("content", vo);
		
		return "addContent";
	}
	
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(ClassContentsVO vo) {
		int classID = vo.getClassID();
		vo.setDaySeq(classContentsService.getDaySeq(vo));
		
		if (classContentsService.insertContent(vo) == 0)
			System.out.println("classContents 추가 실패!");
		else
			System.out.println("classContents 추가 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/editContent/{id}", method = RequestMethod.GET)
	public String editContent(@PathVariable("id") int id, Model model) {
		ClassContentsVO vo = classContentsService.getOneContent(id);
		model.addAttribute("vo", vo);
		return "editContent";
	}
	
	@RequestMapping(value = "/editContentOK", method = RequestMethod.POST)
	public String editContentOK(ClassContentsVO vo) {
		int classID = vo.getClassID();
		
		if (classContentsService.updateContent(vo) == 0)
			System.out.println("classContents 수정 실패!");
		else
			System.out.println("classContents 수정 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/deleteContent/{classID}/{id}", method = RequestMethod.GET)
	public String deleteContent(@PathVariable("classID") int classID, @PathVariable("id") int id) {
		if (classContentsService.deleteContent(id) == 0)
			System.out.println("classContents 삭제 실패!");
		else
			System.out.println("classContents 삭제 성공!");
		
		return "redirect:../../contentList/" + classID;
	}
	
}

