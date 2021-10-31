package com.mycom.myapp.student.classes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.mycom.myapp.student.video.Stu_VideoService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.commons.NoticeVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/class")
public class Stu_ClassController{
	@Autowired
	private ClassesService classService;
	
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
	
	@Autowired
	private Stu_NoticeService noticeService;
	
	private int studentId = 0;
	
	@RequestMapping(value = "/test/dashboard/{studentID}",  method = RequestMethod.GET)	//개발 test용. 나중에 지우기!!
	public String dashboard_Test(@PathVariable("studentID") int id, Model model, HttpSession session) {
		String email, name = "";
		if(id == 1) {
			email = "jinwoo@gmail.com";
			name = "TEST1";
		}
		else {
			email = "hayeong@gmail.com";
			name = "TEST2";
		}
		
		MemberVO vo = memberService.getStudent(email);
		session.setAttribute("login", vo);
		session.setAttribute("userName", name);
		session.setAttribute("userID", id);
		studentId = id;
		return "class/dashboard_Stu";
	}
	
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String dashboard(HttpSession session) {
		// select id, className, startDate from lms_class where instructorID=#{instructorID}
		// 여러 선생님의 강의를 듣는 경우에는 어떻게 되는거지?? instructorID가 여러개인 경
		// takes테이블을 통해 가져올 수 있도록 해야겠다..
		studentId = (Integer)session.getAttribute("userID");
		return "class/dashboard_Stu";
	}
	
	@ResponseBody
	@RequestMapping(value = "/getAllMyClass", method = RequestMethod.POST)
	public Object getAllNotices() {
		List<ClassesVO> list = classesService.getAllMyClass(studentId);
		List<ClassesVO> inactiveList = classesService.getAllMyInactiveClass(studentId);
		
		for(int i=0; i<list.size(); i++) {
			int classID = list.get(i).getId();
			NoticeVO tmp = new NoticeVO();
			tmp.setId(classID);
			tmp.setStudentID(studentId);
			
			if(noticeService.countNotice(classID) != noticeService.countNoticeCheck(tmp))
				list.get(i).setNewNotice(1);
			else
				list.get(i).setNewNotice(0);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("active", list);
		map.put("inactive", inactiveList);
		return map;
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/getClassInfo", method = RequestMethod.POST)
	public ClassesVO getClassInfo(@RequestParam(value = "classID") int classID) {	
		//학생의 강의실 상세보기 modal에 띄어질 내용 가져오기
		ClassesVO vo = classesService.getClassInfo(classID);
		return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteClassroom", method = RequestMethod.POST)
	public void deleteClassroom(@RequestParam(value = "id") int id) {	
		ClassesVO vo = new ClassesVO();
		vo.setId(id);
		vo.setStudentID(studentId);
		
		if(classesService.deleteClassroom(vo) != 0)
			System.out.println("강의실 나가기 성공!");
		else
			System.out.println("강의실 나가기 실패!");
		//(jw)
		if(classService.updateTotalStudent(id) == 1)
			System.out.println("totalStudent 업데이트 성공! ");
		else
			System.out.println("totalStudent 업데이트 실패 ");
		
	}
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classID") int classID, Model model) {
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID); //임의로 1번 class 설정*/
		model.addAttribute("classInfo", classesService.getClass(classID)); //class테이블에서 classID가 같은 모든 것을 가져온다.
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		//지금 studentID가 제대로 안들어간다..
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(1)));
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(1)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(1)));
		model.addAttribute("playlistCheck", JSONArray.fromObject(playlistcheckService.getAllPlaylist()));
		model.addAttribute("myName", memberService.getStudentName(1));
		//return "t_contentsList_Stu";
		return "class/contentsList_Stu";
	}
	
	
	@RequestMapping(value = "/contentDetail/{playlistID}/{id}/{classID}/{daySeq}", method = RequestMethod.GET) //class contents 전체 보여주기
	public String contentDetail(@PathVariable("playlistID") int playlistID, @PathVariable("id") int id, @PathVariable("classID") int classID, @PathVariable("daySeq") int daySeq, Model model) {
		
		VideoVO pvo = new VideoVO();
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setPlaylistID(playlistID);
		ccvo.setId(id);
		ccvo.setClassID(classID); //임의로 1번 class 설정
		
		//model.addAttribute("allMyClass", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("classInfo", classesService.getClass(classID)); 
		//model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("vo", classContentService.getOneContent(id));
		model.addAttribute("playlist", JSONArray.fromObject(videoService.getVideoList(pvo)));
		model.addAttribute("playlistSameCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); 
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(1)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classesService.getAllMyInactiveClass(1)));
		model.addAttribute("myName", memberService.getStudentName(1));
		return "class/contentsDetail_Stu";
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/weekContents", method = RequestMethod.POST)
	public List<ClassContentVO> weekContents(HttpServletRequest request, Model model) throws Exception {
		
	    return classContentService.getWeekClassContent(Integer.parseInt(request.getParameter("classID")));
		//return classContentService.getAllClassContent(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/allContents", method = RequestMethod.POST)
	public List<ClassContentVO> allContents(HttpServletRequest request, Model model) throws Exception {
		
	    //return classContentService.getWeekClassContent(Integer.parseInt(request.getParameter("classID")));
		return classContentService.getAllClassContent(Integer.parseInt(request.getParameter("classID")));
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/forStudentContentDetail", method = RequestMethod.POST)
	public Map<Integer, Object> forStudentContentDetail(HttpServletRequest request, Model model) throws Exception {
		//List<Map<Integer, Object>> listMap = new ArrayList<Map<Integer, Object>>();
		Map<Integer, Object> map = new HashMap<Integer, Object>();
		
		int classID = Integer.parseInt(request.getParameter("classID"));
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID);
		List<ClassContentVO> VOlist = new ArrayList<ClassContentVO>();
		VOlist = classContentService.getWeekClassContent(classID);
		
		for(int i=0; i<VOlist.size(); i++) {
			map.put(i, VOlist.get(i));
			//listMap.add(map);
		}
	    return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/changeID", method = RequestMethod.POST)
	public ClassContentVO changeID(HttpServletRequest request, Model model) throws Exception {
		ClassContentVO vo = classContentService.getOneContent(Integer.parseInt(request.getParameter("id")));
	    
	    return vo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<VideoVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		//int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
	    VideoVO vo = new VideoVO();
	    vo.setPlaylistID(playlistID);
	    //Stu_VideoCheckVO vco = new Stu_VideoCheckVO();
	    //vco.setClassPlaylistID(classPlaylistID);
	    //model.addAttribute("totalVideo", playlistcheckService.getTotalVideo(playlistID));
	    //System.out.println("totalVideo 가 잘 나오니? " + playlistcheckService.getTotalVideo(playlistID));
	    
	    return videoService.getVideoList(vo);
	}
	
	@ResponseBody
	@RequestMapping(value = "/forClassInformation", method = RequestMethod.POST)
	public ClassContentVO ajaxTest(HttpServletRequest request, Model model) throws Exception {
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
	   
	    return classContentService.getOneContent(classPlaylistID);
	}
	
	@ResponseBody
	@RequestMapping(value = "/progressbar", method = RequestMethod.POST)
	public Stu_PlaylistCheckVO progressbar(HttpServletRequest request) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("id"));
		//System.out.println()
		
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		pcvo.setPlaylistID(playlistID);
		pcvo.setClassContentID(classPlaylistID);
	   
	  if(playlistcheckService.getPlaylistByPlaylistID(pcvo) != null) {
		  System.out.println("null아니니까");
		  return  playlistcheckService.getPlaylistByPlaylistID(pcvo);
	  }
	  else 
		  return null;
	}
	
	@ResponseBody
	@RequestMapping(value = "/isExisted", method = RequestMethod.POST)
	public String isExisted(HttpServletRequest request) throws Exception { //변수들 하나씩 가져오는거 아니고 json 형식으로 가져올 수 있도록
		int studentID = Integer.parseInt(request.getParameter("studentID"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		int classID = Integer.parseInt(request.getParameter("classID"));
		int totalVideo = Integer.parseInt(request.getParameter("totalVideo"));
		double totalWatched = 0.00;
		
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		pcvo.setStudentID(studentID);
		pcvo.setPlaylistID(playlistID);
		pcvo.setClassContentID(classPlaylistID);
		pcvo.setClassID(classID);
		pcvo.setTotalVideo(totalVideo);
		pcvo.setTotalWatched(totalWatched);
		
		if (playlistcheckService.insertPlaylist(pcvo) == 0) {
			System.out.println("실패");
			return "error";
		}
		else {
			return "Success";
		}
	}
	
	@RequestMapping(value = "/videocheck", method = RequestMethod.POST)
	@ResponseBody
	public Map<Double, Double> videoCheck(HttpServletRequest request) {
		Map<Double, Double> map = new HashMap<Double, Double>();
		int studentID = Integer.parseInt(request.getParameter("studentID"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		
		if (videoCheckService.getTime(vo) != null) {
			map.put(videoCheckService.getTime(vo).getLastTime(), videoCheckService.getTime(vo).getTimer());
		}
		else {
			System.out.println("처음입니다 !!!");
			map.put(-1.0, -1.0); //시간이 음수가 될 수 는 없으니
		}
		return map;
	}
	
	@RequestMapping(value = "/changevideo", method = RequestMethod.POST)
	@ResponseBody
	public List<Stu_VideoCheckVO> changeVideoOK(HttpServletRequest request) {
		double lastTime = Double.parseDouble(request.getParameter("lastTime"));
		double timer = Double.parseDouble(request.getParameter("timer"));
		int studentID = Integer.parseInt(request.getParameter("studentID"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classID = Integer.parseInt(request.getParameter("classID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		
		vo.setLastTime(lastTime);
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		vo.setTimer(timer);
		vo.setPlaylistID(playlistID);
		vo.setClassID(classID);
		vo.setClassContentID(classPlaylistID);
		//System.out.println(vo.getClassID() + " " + vo.getClassPlaylistID());
		if (videoCheckService.updateTime(vo) == 0) {
			System.out.println("데이터 업데이트 실패 ");
			videoCheckService.insertTime(vo);

		}
		else
			System.out.println("데이터 업데이트 성공!!!");
		
		return videoCheckService.getTimeList();
	}
	
	@RequestMapping(value = "/changewatch", method = RequestMethod.POST)
	@ResponseBody
	public String changeWatchOK(HttpServletRequest request) {
		double lastTime = Double.parseDouble(request.getParameter("lastTime"));
		double timer = Double.parseDouble(request.getParameter("timer"));
		int studentID = Integer.parseInt(request.getParameter("studentID"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int watch = Integer.parseInt(request.getParameter("watch"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		int classID = Integer.parseInt(request.getParameter("classID"));
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		
		vo.setLastTime(lastTime);
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		vo.setTimer(timer);
		vo.setClassID(classID);
		vo.setClassContentID(classPlaylistID);
		
		Stu_VideoCheckVO checkVO = videoCheckService.getTime(vo); //위에서 set한 videoID를 가진 정보를 가져와서 checkVO에 넣는다.
		vo.setWatched(watch);
		
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		pcvo.setStudentID(studentID);
		pcvo.setPlaylistID(playlistID);
		//pcvo.setVideoID(videoID);
		//pcvo.setClassContentID(classPlaylistID);
		pcvo.setClassContentID(classPlaylistID);
		pcvo.setClassID(classID);
		//pcvo.set
		
		//우선 현재 db테이블의 getWatched를 가져온다. 이때 가져온 값이 0이다
		//vo.setWatched를 한다.
		//vo.getWatched했는데 1이다.
		//이럴때 playlistcheck테이블의 totalWatched업데이트 시켜주기
		
		
		if (videoCheckService.updateWatch(vo) == 0) { //하나도 안멈추고 처음부터 끝까지 보는 경우
			videoCheckService.insertTime(vo);
			playlistcheckService.updateTotalWatched(pcvo);

		}
		else { //업데이트가 성공하면 
			if(checkVO.getWatched() == 0) { //checkVO의정보가 playlistcheck에 업데이트가 되지 않았면 
				if(vo.getWatched() == 1) { //원래 값은 0이었는데 1로 업뎃된것을 의미
					//System.out.println("값이 뭔데 ? " +vo.getWatchedUpdate());
					//System.out.println("값이 뭔데 ? " +vo.getWatched());
					//System.out.println("값이 뭔디 3 " +pcvo.getStudentID() + " / " + pcvo.getPlaylistID() + " / " + pcvo.getVideoID());
					//playlistcheckService.insertPlaylist(pcvo);
					playlistcheckService.updateTotalWatched(pcvo); //
				}
			}
		}
			
		return "redirect:/"; // 이것이 ajax 성공시 파라미터로 들어가는구만!!
	}



}