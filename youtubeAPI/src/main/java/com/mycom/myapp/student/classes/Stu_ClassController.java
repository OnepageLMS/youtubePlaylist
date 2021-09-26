package com.mycom.myapp.student.classes;

import java.util.ArrayList;
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

import com.mycom.myapp.student.video.Stu_VideoService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/class")
public class Stu_ClassController{
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
	
	private int studentId;
	
	@RequestMapping(value = "/{studentID}", method = RequestMethod.GET)
	public String studentDashboard(@PathVariable("studentID") int studentID, Model model) {
		//int studentID = 1;	//이부분 나중에 학생걸로 가져오기	 --> mapper 새로 만들기
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentID)));
		studentId = studentID;
		// select id, className, startDate from lms_class where instructorID=#{instructorID}
		// 여러 선생님의 강의를 듣는 경우에는 어떻게 되는거지?? instructorID가 여러개인 경
		// takes테이블을 통해 가져올 수 있도록 해야겠다..
		
		return "class/dashboard_Stu";
	}
	
	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)	// 9/24 studentID url에서 지운 버전(yewon)
	public String dashboard (Model model) {
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentId)));
		
		return "class/dashboard_Stu";
	}
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classID") int classID, Model model) {
		/*classID = 1;//임의로 1번 class 설정
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID); //임의로 1번 class 설정*/
		model.addAttribute("classInfo", classesService.getClass(classID)); //class테이블에서 classID가 같은 모든 것을 가져온다.
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));  //객체 아니고 그냥 classID보내면 안되나 ..?
		//classContents테이블에서 가져온다. 해당 classID의 특정 playlistID를 가진 것을 가져온다. (주차별로 가져오는 느낌) - allContents있는데 이게 굳이 필요..?
		// 아니,, allContents가 아니라 weekContents를 가져와야한다
		model.addAttribute("allMyClass", JSONArray.fromObject(classesService.getAllMyClass(studentId)));
		//VideoVO pvo = new VideoVO();
		//model.addAttribute("list", videoCheckService.getTime(176)); //studentID가 1로 설정되어있음
	    //model.addAttribute("playlist", JSONArray.fromObject(videoService.getVideoList(pvo))); 
		model.addAttribute("playlistCheck", JSONArray.fromObject(playlistcheckService.getAllPlaylist()));
		//model.addAttribute("playlistSameCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); 
		//return "t_contentsList_Stu";
		return "contentsList_Stu";
	}
	
	
	@RequestMapping(value = "/contentDetail/{playlistID}/{id}/{classID}/{daySeq}", method = RequestMethod.GET) //class contents 전체 보여주기
	public String contentDetail(@PathVariable("playlistID") int playlistID, @PathVariable("id") int id, @PathVariable("classID") int classID, @PathVariable("daySeq") int daySeq, Model model) {
		//playlistID : playlistID, id : id (classPlaylist테이블의 id/ 혹시 playlistID가 같은 경우를 대비함), classInfo : classID
		//VideoVO vo = new VideoVO();
		VideoVO pvo = new VideoVO();
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		ClassContentVO ccvo = new ClassContentVO();
		
		//pvo.setPlaylistID(playlistID);
		ccvo.setPlaylistID(playlistID);
		ccvo.setId(id);
		ccvo.setClassID(classID); //임의로 1번 class 설정
		
		model.addAttribute("allMyClass", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("classInfo", classesService.getClass(classID)); 
		//model.addAttribute("allContents", JSONArray.fromObject(classContentService.getAllClassContent(classInfo)));
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID)));
		model.addAttribute("vo", classContentService.getOneContent(id));
		//model.addAttribute("playlistID", playlistID);
		//model.addAttribute("classPlaylistID", id);
		//model.addAttribute("classID", classInfo);
		//model.addAttribute("list", videoCheckService.getTime(200)); //studentID가 3으로 설정되어있음
		//model.addAttribute("playlist", JSONArray.fromObject(playlistcheckService.getVideoList(pvo)));  //Video와 videocheck테이블을 join해서 두 테이블의 정보를 불러오기 위함
		//System.out.println("~~playlistID : " + pvo.getPlaylistID());
		model.addAttribute("playlist", JSONArray.fromObject(videoService.getVideoList(pvo)));
		//model.addAttribute("playlistCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); //선택한 PlaylistID에 맞는 row를 playlistCheck테이블에서 가져오기 위함 , playlistCheck가 아니라 classPlaylistCheck에서 가져와야하거 같은디
		model.addAttribute("playlistSameCheck", JSONArray.fromObject(classContentService.getSamePlaylistID(ccvo))); 
		//return "t_contentsList_Stu2";
		return "contentsDetail_Stu";
		
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
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<VideoVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		//int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
	    VideoVO vo = new VideoVO();
	    vo.setPlaylistID(playlistID);
	    System.out.println("playlistID : " + playlistID);
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
		pcvo.setClassPlaylistID(classPlaylistID);
	   
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
		pcvo.setClassPlaylistID(classPlaylistID);
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
		System.out.println(studentID + " / " + videoID);
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
		vo.setClassPlaylistID(classPlaylistID);
		System.out.println(vo.getClassID() + " " + vo.getClassPlaylistID());
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
		vo.setClassPlaylistID(classPlaylistID);
		
		Stu_VideoCheckVO checkVO = videoCheckService.getTime(vo); //위에서 set한 videoID를 가진 정보를 가져와서 checkVO에 넣는다.
		vo.setWatched(watch);
		
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		pcvo.setStudentID(studentID);
		pcvo.setPlaylistID(playlistID);
		pcvo.setVideoID(videoID);
		pcvo.setClassPlaylistID(classPlaylistID);
		
		//우선 현재 db테이블의 getWatched를 가져온다. 이때 가져온 값이 0이다
		//vo.setWatched를 한다.
		//vo.getWatched했는데 1이다.
		//이럴때 playlistcheck테이블의 totalWatched업데이트 시켜주기
		
		
		if (videoCheckService.updateWatch(vo) == 0) { //하나도 안멈추고 처음부터 끝까지 보는 경우에!!! 업데이ㅡ가 안되자나!!
			System.out.println("데이터 업데이트 실패 ======= ");
			videoCheckService.insertTime(vo);
			playlistcheckService.updateTotalWatched(pcvo);

		}
		else { //업데이트가 성공하면 
			if(checkVO.getWatched() == 0) { //checkVO의정보가 playlistcheck에 업데이트가 되지 않았면 
				if(vo.getWatched() == 1) { //원래 값은 0이었는데 1로 업뎃된것을 의미
					System.out.println("값이 뭔데 ? " +vo.getWatchedUpdate());
					System.out.println("값이 뭔데 ? " +vo.getWatched());
					System.out.println("값이 뭔디 3 " +pcvo.getStudentID() + " / " + pcvo.getPlaylistID() + " / " + pcvo.getVideoID());
					playlistcheckService.updateTotalWatched(pcvo); //
				}
			}
		}
			
		return "redirect:/"; // 이것이 ajax 성공시 파라미터로 들어가는구만!!
	}



}