package com.mycom.myapp.playlist;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.PlaylistVO;
import com.mycom.myapp.member.MemberService;

import net.sf.json.JSONArray;


@Controller
@RequestMapping(value="/playlist")
public class PlaylistController {
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private ClassesService classService;
	@Autowired
	private MemberService memberService;
	
	private int instructorID = 1;
	
	@RequestMapping(value = "/myPlaylist", method = RequestMethod.GET) 
	public String myPlaylist(Model model) {
		model.addAttribute("instructorID", instructorID);	//이거 지우기
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		model.addAttribute("myName", memberService.getInstructorName(instructorID));
		return "playlist/myPlaylist";
	}
	
	@RequestMapping(value = "/addPlaylist", method = RequestMethod.POST)
	@ResponseBody
	public void addPlaylist(@ModelAttribute PlaylistVO vo) {
		vo.setInstructorID(instructorID);

		if(playlistService.addPlaylist(vo) != 0) 
			System.out.println("playlist 추가 성공! ");
		else
			System.out.println("playlist 추가 실패! ");
	}
	
	@RequestMapping(value = "/updatePlaylist", method = RequestMethod.POST)
	@ResponseBody
	public void updatePlaylist(@ModelAttribute PlaylistVO vo) {

		if(playlistService.updatePlaylist(vo) != 0) 
			System.out.println("playlist 수정 성공! ");
		else
			System.out.println("playlist 수정 실패! ");
	}
	

	@RequestMapping(value = "/getAllMyPlaylist", method = RequestMethod.POST) 
	@ResponseBody
	public Object getAllMyPlaylist() {
		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
		playlists = playlistService.getAllMyPlaylist(instructorID); //playlist의 모든 video 가져오기
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allMyPlaylist", playlists);
		
		return map;
	}
	
	// LMS내 영상 검색에 사용. 모든 playlist 가져오기
	@RequestMapping(value = "/getAllPlaylist", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllPlaylist() {
		List<PlaylistVO> playlists = playlistService.getAllPlaylist();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allPlaylist", playlists);
		map.put("code", "ok");
		
		return map;
	}
	
	//선택한 playlist의 자세한정보 가져오기
	@RequestMapping(value = "/getPlaylistInfo", method = RequestMethod.POST)
	@ResponseBody
	public PlaylistVO getPlaylistInfo(@RequestParam(value = "playlistID") String playlistID) {
		PlaylistVO vo = playlistService.getPlaylist(Integer.parseInt(playlistID));
		return vo;
	}
	
	@RequestMapping(value = "/player", method = RequestMethod.POST)
	public String player(Model model,
			@RequestParam(required = false) String playerId,
			@RequestParam(required = false) String playerTitle,
			@RequestParam(required = false) String playerDuration,
			@RequestParam(required = false) String keyword) throws Exception{
		
		System.out.println(playerId);
		
		model.addAttribute("id", playerId);
		model.addAttribute("title", playerTitle);
		model.addAttribute("duration", playerDuration);
		
		return "player";
	}
	
	// (jw) 2021/08/16 : 일단 access Token 을 사용해야하니 이건 여기에 냅두고 그 이후에는 Controller 에서 처리하도록 
	@RequestMapping(value = "/searchLms", method = RequestMethod.GET)
	public String searchLms(Model model, String keyword) {													
		return "search";
	}

}

