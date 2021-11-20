package com.mycom.myapp.student.classContent;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.commons.VideoVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classes.Stu_ClassesService;
import com.mycom.myapp.student.notice.Stu_NoticeService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
import com.mycom.myapp.student.video.Stu_VideoService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;
import com.mycom.myapp.video.VideoService;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/student/class")
public class Stu_ClassContentController {
	@Autowired
	private ClassesService classService;	
	@Autowired
	private Stu_ClassesService classService_stu;
	@Autowired
	private Stu_ClassContentService classContentService;
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	@Autowired
	private Stu_VideoService videoService;
	@Autowired
	private VideoService insVideoService;
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInCheckService;
	
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
								@RequestParam("daySeq") int day, Model model, HttpSession session) {

		//아래는 Stu_ClassController에 이함수가 있을 때 있떤건데 없어도될것같다
		//playlistID = playlistId;
		//id = ID;
		//classID = classId;
		//daySeq = day;
		
		studentID = (Integer)session.getAttribute("userID");
		
		
		VideoVO pvo = new VideoVO();
		
		//여기서 playlistID==0이면 playlistCHeck테이블에 넣어주기 
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		pcvo.setStudentID(studentID);
		pcvo.setClassContentID(id);
		pcvo.setClassID(classID);
		pcvo.setDays(classContentService.getOneContent(id).getDays());
		pcvo.setTotalVideo(0);
		
		System.out.println("id : " + id + " days : " + day);
		if(playlistID == 0 && playlistcheckService.getPlaylistByContentStu(pcvo) == null) {
			if(playlistcheckService.insertNoPlaylistID(pcvo) != 0) {
				System.out.println("playlistID 0 insert success!");
			}
			

			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setClassContentID(id);
			aivo.setStudentID(studentID);
			
			System.out.println(attendanceInCheckService.getAttendanceInCheckByID(aivo));
			if(attendanceInCheckService.getAttendanceInCheckByID(aivo) == null) {
				aivo.setInternal("출석"); //넣을 때 시간 비교해서 넣어야함 ..... 
				aivo.setClassID(classID);
				aivo.setDays(classContentService.getOneContent(id).getDays());
				if( attendanceInCheckService.insertAttendanceInCheck(aivo) != 0)
					System.out.println("playlistID 0 insert sucess AttendanceInternal");
			}
			//해단 id를가지고  classID, 
		}
		
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
		
		model.addAttribute("id", id);
		model.addAttribute("daySeq", day);
		return "class/contentsDetail_Stu";	
	}
	
	@ResponseBody
	@RequestMapping(value = "/weekContents", method = RequestMethod.POST)
	public List<ClassContentVO> weekContents(HttpServletRequest request, Model model) throws Exception {
		System.out.println("classID : " + classID);
	    return classContentService.getWeekClassContent(classID); // 정해진 classID를 가지고 Publish된 수업들 가져오기 (classContent와 Playlist테이블 join)
		//return classContentService.getAllClassContent(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/forVideoInformation", method = RequestMethod.POST)
	public List<VideoVO> forVideoInformation(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		//int id = Integer.parseInt(request.getParameter("id"));
	    VideoVO vo = new VideoVO();
	    vo.setPlaylistID(playlistID);
	    //vo.setId(id);
	    System.out.println("size : " +videoService.getVideoList(vo).size() + "playlistID : " + playlistID);
	    return insVideoService.getVideoList(playlistID);
	}
	
	@ResponseBody
	@RequestMapping(value = "/forWatched", method = RequestMethod.POST)
	public List<VideoVO> forWatched(HttpServletRequest request, Model model) throws Exception {
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		int classContentID = Integer.parseInt(request.getParameter("classContentID")); //이거 지우면 안된다, 
		//System.out.println("watch" + classContentID);
		
		Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
		
		pcvo.setStudentID(studentID);
		pcvo.setClassContentID(classContentID);
		pcvo.setClassID(classID);
		System.out.println("classCOntentID " + classContentID + " " + classContentService.getOneContent(classContentID).getDays());
		pcvo.setDays(classContentService.getOneContent(classContentID).getDays());
		pcvo.setTotalVideo(0);
		
		System.out.println("id : " + classContentID);
		if(playlistID == 0 && playlistcheckService.getPlaylistByContentStu(pcvo) == null) {
			if(playlistcheckService.insertNoPlaylistID(pcvo) != 0) {
				System.out.println("changing, playlistID 0 insert success!");
			}
			

			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setClassContentID(classContentID);
			aivo.setStudentID(studentID);
			
			System.out.println(attendanceInCheckService.getAttendanceInCheckByID(aivo));
			if(attendanceInCheckService.getAttendanceInCheckByID(aivo) == null) {
				aivo.setInternal("출석");
				aivo.setClassID(classID);
				aivo.setDays(classContentService.getOneContent(classContentID).getDays());
				if( attendanceInCheckService.insertAttendanceInCheck(aivo) != 0)
					System.out.println("changing, playlistID 0 insert sucess AttendanceInternal");
			}
			//해단 id를가지고  classID, 
		}
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
	    vo.setPlaylistID(playlistID);
	    vo.setStudentID(studentID);
	    vo.setClassContentID(classContentID);
	    System.out.println("하나의 classContent , playlist내 영상 개수 : "+ videoService.getVideoCheckList(vo).size());
	    return videoService.getVideoCheckList(vo);
	} //이렇게하면 videoCheck에 없는 영상에 대한 정보는 가져오지 못함 ..... ..
	

	@ResponseBody
	@RequestMapping(value = "/changeID", method = RequestMethod.POST)
	public ClassContentVO changeID(HttpServletRequest request, Model model) throws Exception {
		ClassContentVO vo = classContentService.getOneContent(Integer.parseInt(request.getParameter("id")));
	    
	    return vo;////
	}
	
	@RequestMapping(value = "/changevideo", method = RequestMethod.POST)
	@ResponseBody
	public List<Stu_VideoCheckVO> changeVideoOK(HttpServletRequest request) {
		double lastTime = Double.parseDouble(request.getParameter("lastTime"));
		double timer = Double.parseDouble(request.getParameter("timer"));
		//int studentID = Integer.parseInt(request.getParameter("studentID"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		//int classID = Integer.parseInt(request.getParameter("classID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		System.out.println("lastTime : " + lastTime + " ,timer " + timer + " ,videoID : " + videoID + " ,playlistID : " + playlistID + " , classID : " + classID + " classPlaylistID : " + classPlaylistID); 
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
			System.out.println("데이터 업데이트 실패 -> insert할 것 ");
			videoCheckService.insertTime(vo);

		}
		else
			System.out.println("데이터 업데이트 성공!!!");
		
		return videoCheckService.getTimeList();
	}
	
	@RequestMapping(value = "/videocheck", method = RequestMethod.POST)
	@ResponseBody
	public double videoCheck(HttpServletRequest request) {
		//Map<Double, Double> map = new HashMap<Double, Double>();
		//int studentID = Integer.parseInt(request.getParameter("studentID"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		//System.out.println("videoID : " + videoID + " ,studentID : " + studentId);
		if (videoCheckService.getTime(vo) != null) {
			//map.put(videoCheckService.getTime(vo).getLastTime(), videoCheckService.getTime(vo).getTimer());
			System.out.println(videoCheckService.getTime(vo).getLastTime());
			return videoCheckService.getTime(vo).getLastTime();
		}
		else {
			System.out.println("처음입니다 !!!");
			//map.put(-1.0, -1.0); //시간이 음수가 될 수 는 없으니
			return -1.0;
		}
	}
	
	@RequestMapping(value = "/changewatch", method = RequestMethod.POST)
	@ResponseBody
	public String changeWatchOK(HttpServletRequest request) {
		double lastTime = Double.parseDouble(request.getParameter("lastTime"));
		double timer = Double.parseDouble(request.getParameter("timer"));
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int watch = Integer.parseInt(request.getParameter("watch"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		int classPlaylistID = Integer.parseInt(request.getParameter("classPlaylistID"));
		int totalVideo = Integer.parseInt(request.getParameter("totalVideo"));
		
		
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
		vo.setLastTime(lastTime);
		vo.setStudentID(studentID);
		vo.setvideoID(videoID);
		vo.setTimer(timer);
		vo.setClassID(classID);
		vo.setClassContentID(classPlaylistID);
		vo.setPlaylistID(playlistID);
		vo.setWatched(watch);
		
		//우선 현재 db테이블의 getWatched를 가져온다. 이때 가져온 값이 0이다
		//vo.setWatched를 한다.
		//vo.getWatched했는데 1이다.
		//이럴때 playlistcheck테이블의 totalWatched업데이트 시켜주기
		//totalVideo랑 playlist의 개수가 똑같고, watch가 모두 1이면 ==> playlistCheck insert 
		
		if (videoCheckService.updateWatch(vo) == 0) { //하나도 안멈추고 처음부터 끝까지 보는 경우
			videoCheckService.insertTime(vo);	
		}
		else { //업데이트가 성공하면 
			System.out.println("changeWatch 업데이트 성공 ");
		}
		
		System.out.println("이거 playlist에 영상 몇개있냐면 ,,, " + playlistService.getPlaylist(playlistID).getTotalVideo());
		int count = 0;
		//if(totalVideo == playlistService.getPlaylist(playlistID).getTotalVideo()) {
			//System.out.println("이거 출력되면 안돼,,,,,,,,"); //이거 출력되면 watch 1인거 다 확인해주어야 함 
		for(int i= 0; i<videoCheckService.getWatchedCheck(vo).size(); i++) {
			if(videoCheckService.getWatchedCheck(vo).get(i).getWatched() == 1) {
				System.out.println(videoCheckService.getWatchedCheck(vo).get(i).getID());
				count++;
			}
			else {
				System.out.println(videoCheckService.getWatchedCheck(vo).get(i).getID());
				break;
			}
		}
			
		if(count == playlistService.getPlaylist(playlistID).getTotalVideo()) {
			System.out.println("오퀴 이제 playlistCheck insert!");
			Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
			
			pcvo.setStudentID(studentID);
			pcvo.setPlaylistID(playlistID);
			//pcvo.setVideoID(videoID);
			//pcvo.setClassContentID(classPlaylistID);
			pcvo.setClassContentID(classPlaylistID);
			pcvo.setClassID(classID);
			pcvo.setDays(classContentService.getOneContent(classPlaylistID).getDays());
			pcvo.setTotalVideo(playlistService.getPlaylist(playlistID).getTotalVideo());
			pcvo.setTotalWatched(0.0);
			
			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setClassContentID(classPlaylistID);
			aivo.setStudentID(studentID);
			aivo.setInternal("출석");
			
			if(playlistcheckService.getPlaylist(playlistID) == null) {
				if(playlistcheckService.insertPlaylist(pcvo) != 0) {
					System.out.println("changewatch good insert");
					//playlistCheck에 insert될 때, attendanceInternalCheck에도 insert시키기 
					//get했을 때 null이면 insert, 
					//마감일보다 playlistCheck에 insert된 시간이 먼저거나 갘으면 true(출석)
					//그렇지 않으면 결석 
					
					//마감일 
					/*ClassContentVO ccvo = new ClassContentVO();
					ccvo.setClassID(classID);
					ccvo.setPlaylistID(playlistID);
					
					classContentService.getCompleteClassContent(ccvo);*/
					//playlistCheck에서 classID, days, studentID가 같은 것의 개수와
					//classContent에서 classID, days가 같은 것의 개수가 같을 때
					ClassContentVO ccvo = new ClassContentVO();
					ccvo.setClassID(classID);
					ccvo.setDays(classContentService.getOneContent(classPlaylistID).getDays()); //추후에 수정하기 
					ccvo.setPlaylistID(playlistID);
					System.out.println("개수 ㅣ : " + classContentService.getDaySeq(ccvo));
					System.out.println("개수 : "  + playlistcheckService.getCompletePlaylist(pcvo).size());
					System.out.println("ccvo - classID : " + ccvo.getClassID() + " , days  " + ccvo.getDays());
					System.out.println("pcvo - classID : " + pcvo.getClassID() + " , days  " + pcvo.getDays() + ", studentID " + pcvo.getStudentID());
					//attendanceInCheckService에 insert한다 
					
					//0 이거나 1이면 출석 (endDate >= stuCompleteDate) 기간 내에 들음, 아니면 결석 
					//System.out.println("0 이거나 1이면 출석 , 아니면 결석 " + result);
					System.out.println("count : " + classContentService.getDaySeq(ccvo) + " , count : " + playlistcheckService.getCompletePlaylistWithDays(pcvo).size());
					if(classContentService.getDaySeq(ccvo) == playlistcheckService.getCompletePlaylistWithDays(pcvo).size()) {
						System.out.println(classContentService.getOneContent(classPlaylistID).getEndDate());
						String endString = classContentService.getOneContent(classPlaylistID).getEndDate();
						//playlistCheck테이블에서 classContentID와 studentID가 같은 regDate가져오기 
						System.out.println(playlistcheckService.getPlaylistByPlaylistID(pcvo).getRegdate());
						String stuCompleteString = playlistcheckService.getPlaylistByPlaylistID(pcvo).getRegdate();
						
						
						SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
						
						Date endDate = null;
						try {
							endDate = format.parse(endString);
						} catch (ParseException e) {
							e.printStackTrace();
						}
						
						Date stuCompleteDate = null;
						try {
							stuCompleteDate = format.parse(stuCompleteString);
						} catch (ParseException e) {
							e.printStackTrace();
						}

						int result = endDate.compareTo(stuCompleteDate); 
						
						System.out.println("마감시간 : " + endDate);
						System.out.println("현재시간 : " + stuCompleteDate);
						
						if(attendanceInCheckService.getAttendanceInCheck(aivo) == null) {
							AttendanceInternalCheckVO aic = new AttendanceInternalCheckVO();
							aic.setClassContentID(classPlaylistID);
							aic.setStudentID(studentID);
							

							if(result == 0 || result == 1)
								aic.setInternal("출석");
							else //-1 
								aic.setInternal("결석");
							attendanceInCheckService.insertAttendanceInCheck(aic);
							System.out.println("출석도 잘넣어보았다 ");
							
							
						}
						
					}
					
				}
				else
					System.out.println("changewatch insert 실패");
			}
			else {
				System.out.println("추후에 시간 업데이트가 일어날 수 있도록 ,, ");
			}
		}
		else {
			System.out.println("아직은,,,, count : " + count  );
		}
		//}
		
		return "redirect:/"; // 이것이 ajax 성공시 파라미터로 들어가는구만!!
	}
	
	
}
