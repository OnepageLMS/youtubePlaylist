package com.mycom.myapp.attendance;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mycom.myapp.attendanceCheck.AttendanceCheckService;
import com.mycom.myapp.classContent.ClassContentService;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.commons.AttendanceInternalCheckVO;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckService;
import com.mycom.myapp.student.videocheck.Stu_VideoCheckVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/attendance")
public class AttendanceController {
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private ClassContentService classInsContentService;
	
	@Autowired
	private Stu_ClassContentService classContentService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private AttendanceService attendanceService;
	
	@Autowired
	private AttendanceCheckService attendanceCheckService;
	
	@Autowired
	private Stu_AttendanceInternalCheckService attendanceInCheckService;
	
	@Autowired
	private Stu_VideoCheckService videoCheckService;
	
	
	private int instructorID = 0;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)	//접근권한 추가하기!!!
	public String attendancehome(@PathVariable("classId") int classId, Model model, HttpSession session) {
		instructorID = (Integer)session.getAttribute("userID");
		classID = classId;
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allMyClass", JSONArray.fromObject(classService.getAllMyActiveClass(instructorID)));
		model.addAttribute("allMyInactiveClass", JSONArray.fromObject(classService.getAllMyInactiveClass(instructorID)));
		
		model.addAttribute("takes", JSONArray.fromObject(stu_takesService.getStudentNum(classID)));	//이름이 모호함
		model.addAttribute("takesNum", stu_takesService.getStudentNum(classID).size());
		
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //여기 수정 
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		
		// 학생 정보 (jw)
		model.addAttribute("studentInfo", stu_takesService.getStudentInfo(classId));
		
		// attendance csv (hy)
		List<AttendanceVO> id = attendanceService.getAttendanceList(classID); //해당 classID를 가진 attribute의 개수 (해당 수업에서 업로드된 파일의 개수) 
		//List<Stu_TakesVO> takes = stu_takesService.getStudentNum(classID); //해당 classID를 가진 수업을 수강하는 학생 수 
		List<List<String>> file = new ArrayList<List<String>>();
		for(int i=0; i<id.size(); i++) { 
			List<String> fileList = new ArrayList<String>();
			int attendanceID = id.get(i).getId(); // 7, 8, 9, 10
			//System.out.println("attendanceID" + attendanceID+ " id.size() " + id.size() + "takseNum " + stu_takesService.getStudentNum(classID).size());
			List<AttendanceCheckVO> takes = attendanceCheckService.getAttendanceCheckList(attendanceID); 
			//System.out.println(takes.size());
			//System.out.println(takes.get(0).getExternal());
			for(int j=0; j<takes.size(); j++) { //id.size()이면 안되겠는걸.. 
				//takes.size()로하면 에러가 나는 이유, 1차시에는 3명에 대한 출석을 업데이트했는데 그 이후에 학생한명이 더 들어온다 -> 4명
				//그럼 indexOutOfBoundsException이 발생한다.
				//attendanceCheck에서 id가 같은 것들 가져오기 
				//System.out.println(attendanceCheckService.getAttendanceCheckList(attendanceID).get(j).getExternal());
			if(attendanceCheckService.getAttendanceCheckList(attendanceID).size() != 0 || attendanceCheckService.getAttendanceCheckList(attendanceID).get(j) != null)
				//System.out.println("attendanceID" + attendanceID+ " j : " + j + " external : " + attendanceCheckService.getAttendanceCheckList(attendanceID).get(j).getExternal());
				fileList.add(attendanceCheckService.getAttendanceCheckList(attendanceID).get(j).getExternal());
				
			}
			file.add(fileList);
		}
		
		model.addAttribute("file", file);
		model.addAttribute("fileNum", attendanceCheckService.getAttendanceCheckListCount(classID));
		//System.out.println("classID" + classID + "fileNum " + attendanceCheckService.getAttendanceCheckListCount(classID));
		return "class/attendance";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {	//이건 왜 attendance controller에 있는걸까?
		
		return stu_takesService.getStudentNum(Integer.parseInt(request.getParameter("classID")));
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forWatchedCount", method = RequestMethod.POST)
	public int forWatchedCount(HttpServletRequest request, Model model) throws Exception {
		//System.out.println("..?");
		int playlistID = Integer.parseInt(request.getParameter("playlistID")); //이거 지우면 안된다, 
		int classContentID = Integer.parseInt(request.getParameter("classContentID")); //이거 지우면 안된다, 
		int studentID = Integer.parseInt(request.getParameter("studentID"));
		//System.out.println("watch");
		Stu_VideoCheckVO vo = new Stu_VideoCheckVO();
	    vo.setPlaylistID(playlistID);////////////
	    vo.setStudentID(studentID);
	    vo.setClassContentID(classContentID);
	    
	    int count = 0;
	    for(int i=0; i<videoCheckService.getWatchedCheck(vo).size(); i++) {
	    	if(videoCheckService.getWatchedCheck(vo).get(i).getWatched() == 1)
	    		count++;
	    }
	    return count;
	}

	@ResponseBody
	@RequestMapping(value = "/uploadCSV", method = RequestMethod.POST)
	public List<List<String>> uploadCSV(MultipartHttpServletRequest request, Model model) throws Exception {
		//업로드된 파일에서 리스트 뽑은거랑, takes테이블에서 학생이름 가져오기
		//데이터는 함수를 또 만들어서 넘겨주기 
		System.out.println("!!!");
		MultipartFile file = request.getFile("file");
		
		int start_h = Integer.parseInt(request.getParameter("start_h"));
		int start_m = Integer.parseInt(request.getParameter("start_m"));
		int end_h = Integer.parseInt(request.getParameter("end_h"));
		int end_m = Integer.parseInt(request.getParameter("end_m"));
		int days = Integer.parseInt(request.getParameter("daySeq"));
		int classID = Integer.parseInt(request.getParameter("classID"));
		//start_h ~ seq모두 jsp파일에서 받아오기 --> done!done!
		
		UUID uuid = UUID.randomUUID();
		String saveName = uuid + "_" + file.getOriginalFilename();
		System.out.println("saveName : " + saveName);

		List<List<String>> csvList = new ArrayList<List<String>>();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/csv/"); //이런식으로 경로지정을 하는건지 ?? 
		// realPath는 무슨 경로인가 ?  --> tomcat서버에서 어디에 저장이 되는지 
		// 저장이 되면 realPath에 저장이 된다는거 아닌가 ? --> 맞아 
		// 그럼 /myapp/resource/csv/,,, 이 주소와 다른점이 무엇일까 ? --> 이거는 내 WORkspace 
		// 그럼 저장된 파일은 어떻게 불러오는거지,, --> 	파일 이름을 Db에  저장을 해두고 나중에 그 링크로 이동할 수 있도록 
		File saveFile = new File(realPath, saveName);
		
		try{
			file.transferTo(saveFile);
		}
		catch(IOException e) {
			e.printStackTrace();
			return null;
		}
		
		
		//db(Attendace테이블)에 insert하기
		AttendanceVO avo = new AttendanceVO();
		avo.setClassID(classID);
		avo.setDays(days);
		avo.setFileName(saveName);
		System.out.println("classID : " + classID + " days :" + days + " saveName : " + saveName);
		//System.out.println(attendanceService.getAttendanceList(classID));
		if(attendanceService.getAttendanceID(avo) != null) { //이미 해당 날짜에 대한 파일이 업로드되어있으면 업데이트 
			System.out.println("already updated!");
			attendanceService.updateAttendance(avo);
		}
		else {
			if(attendanceService.insertAttendance(avo) != 0) { //없으면 insert 
				System.out.println("attendance insert성공!");
			}
			else {
				System.out.println("attendance insert실패!");
			}
		}
		
		List<Integer> csvStartH = new ArrayList<Integer>();
		List<Integer> csvStartM = new ArrayList<Integer>();
		List<Integer> csvEndH = new ArrayList<Integer>();
		List<Integer> csvEndM = new ArrayList<Integer>();
		List<List<String>> finalTakes = new ArrayList<List<String>>();
		 
		File dir = new File(realPath);
		if(!dir.exists()) dir.mkdirs();
		try {
			String line;
			BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), "UTF-8"));
			//int idx = 0;
			while((line=br.readLine()) != null) { 
				List<String> aLine = new ArrayList<String>();
                String[] lineArr = line.split(","); // 파일의 한 줄을 ,로 나누어 배열에 저장 후 리스트로 변환한다.
                //System.out.println(lineArr[idx]);
               /*if(idx > 3) {
                	//System.out.println("lineArr: "  + Integer.parseInt(lineArr[2].charAt(11) + "" + lineArr[2].charAt(12))); 
                	csvStartH.add( Integer.parseInt(lineArr[2].charAt(11) + "" + lineArr[2].charAt(12)));
                	csvEndH.add( Integer.parseInt(lineArr[3].charAt(11) + "" + lineArr[3].charAt(12)));
                	
                	csvStartM.add( Integer.parseInt(lineArr[2].charAt(14) + "" + lineArr[2].charAt(15)));
                	csvEndM.add( Integer.parseInt(lineArr[3].charAt(14) + "" + lineArr[3].charAt(15)));
                
                }*/
                //System.out.println("lineArr: "  + Integer.parseInt(lineArr[2].charAt(11) + "" + lineArr[2].charAt(12))); 
               // csvStartH.add()
                aLine = Arrays.asList(lineArr);
                csvList.add(aLine);
                //idx++;
			}
			
			/*for(int i=0; i<csvStartH.size(); i++) {
				System.out.println(csvStartH.get(i));
			}*/
			
            List<Stu_TakesVO> data = stu_takesService.getStudentNum(classID); //db에서 학생정보 가져오기 classID임의로 넣음 
            List<String> stuNameArr = new ArrayList<String>();
            for(int i=0; i<data.size(); i++) {
            	stuNameArr.add(data.get(i).getName()); //이 수업을 듣는 학생들의 목록을 조회 (db의 takes 테이블로부터) 
            }
            

    		List<String> attendStu = new ArrayList<String>();
    		List<String> absentStu = new ArrayList<String>();
    		List<String> annonyStu = new ArrayList<String>();
            
    		//int stuNum = 0;
            for(int i=4; i<csvList.size(); i++) {
    			for(int j=0; j<stuNameArr.size(); j++) {
    				if(csvList.get(i).get(0).contains(stuNameArr.get(j)) ) { //csv파일 내에 이름이 있는 학생의 경우와
    					//결석보다는 출석한 학생이 많으므로 우선 출석으로 넣어두고
    					attendStu.add(stuNameArr.get(j));
    					
    					csvStartH.add( Integer.parseInt(csvList.get(i).get(2).charAt(11) + "" + csvList.get(i).get(2).charAt(12)));
                    	csvEndH.add( Integer.parseInt(csvList.get(i).get(3).charAt(11) + "" + csvList.get(i).get(3).charAt(12)));
                    	
                    	csvStartM.add( Integer.parseInt(csvList.get(i).get(2).charAt(14) + "" + csvList.get(i).get(2).charAt(15)));
                    	csvEndM.add( Integer.parseInt(csvList.get(i).get(3).charAt(14) + "" + csvList.get(i).get(3).charAt(15)));
                    	
    					//stuNum++;
    				}
    				else { // 미확인 학생들 
    					continue;
    				}
    	
    			}
    		}
            //분으로 환산해서 하기
            //System.out.println("출석학생 : " +attendStu.size());
            int count = 0;
            for(int i=0; i<attendStu.size(); i++) {
            	if(start_h > csvStartH.get(i) ) {
            		if(end_h < csvEndH.get(i)) {
            			System.out.println("1");
            			continue;
        				//출석 
        			}
            		
            		else if(end_h == csvEndH.get(i)){ 
            			if(end_m <= csvEndM.get(i)) {
            				System.out.println("2" + start_h + " / " + csvStartH.get(i));
            				continue;
            				// 출석 
        				}
            			else {
            				//결석 
            				//출석에서 빼고 결석에 넣기
            				// i번째의 학생이 attendStu의 list에서는 몇번재인지.,
            				System.out.println("3");
            				absentStu.add(attendStu.get(i));
            				attendStu.remove(i);
            				//absentStu.add(attendStu.get(i));
            				
            			}
            		}
            		
            		else {
    					//결석 
            			//출석에서 빼고 결석에 넣기 
            			System.out.println("4");
            			absentStu.add(attendStu.get(i));
            			attendStu.remove(i);
        				//absentStu.add(attendStu.get(i));
    				}
            	}
            	else if(start_h == csvStartH.get(i)) {
            		if(start_m >= csvStartM.get(i)) {
            			if(end_h < csvEndH.get(i)) {
            				System.out.println("5");
            				continue;
            				//출석 
            			}
                		
                		else if(end_h == csvEndH.get(i)){ 
                			if(end_m <= csvEndM.get(i)) {
                				System.out.println("6");
                				continue;
                				// 출석 
            				}
                			else {
                				//결석 
                    			//출석에서 빼고 결석에 넣기 
                				System.out.println("7");
                				System.out.println("attendStu.length " + attendStu.size());
                				absentStu.add(attendStu.get(i));
                				attendStu.remove(count);
                				//absentStu.add(attendStu.get(count));
                				System.out.println("attendStu.length " + attendStu.size());
                			}
                		}
                		
                		else {
                			//결석 
                			//출석에서 빼고 결석에 넣기 
                			System.out.println("8");
                			absentStu.add(attendStu.get(i));
                			attendStu.remove(i);
            				//absentStu.add(attendStu.get(i));
                		}
            		}
            		
            		else {
            			//결석 
            			//출석에서 빼고 결석에 넣기 
            			System.out.println("9");
            			System.out.println("attendStu.length " + attendStu.size());
            			absentStu.add(attendStu.get(i));
            			attendStu.remove(i);
        				//absentStu.add(attendStu.get(i));
        				System.out.println("attendStu.length " + attendStu.size());
            		}
            		
            	}
            	else {
            		//결석 
        			//출석에서 빼고 결석에 넣기 
            		System.out.println("10");
            		absentStu.add(attendStu.get(i));
            		attendStu.remove(i);
    				//absentStu.add(attendStu.get(i));
            	}
            	
            	count++;
            }
            
            for(int i=0; i<stuNameArr.size(); i++) {
            	if(!attendStu.contains(stuNameArr.get(i)) && !absentStu.contains(stuNameArr.get(i)))
            		annonyStu.add(stuNameArr.get(i));
            	else
            		continue;
            }
           /* System.out.println(attendStu.size() + ", " + absentStu.size() + " , " + annonyStu.size());
            for(int i=0; i<attendStu.size(); i++) {
            	System.out.println(attendStu.get(i));
            }
            for(int i=0; i<absentStu.size(); i++) {
            	System.out.println(absentStu.get(i));
            }
            for(int i=0; i<annonyStu.size(); i++) {
            	System.out.println(annonyStu.get(i));
            }*/
            finalTakes.add(attendStu);
            finalTakes.add(absentStu);
            finalTakes.add(annonyStu);
            
			br.close();
			
			file.transferTo(new File(realPath, file.getOriginalFilename()));
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return finalTakes;
	}

	@RequestMapping(value = "/entryCode", method = RequestMethod.GET)
	public String entry(Model model) {

		return "entryCode";
	}
	
	@ResponseBody
	@RequestMapping(value = "/whichAttendance", method = RequestMethod.POST)
	public int whichAttendance(HttpServletRequest request, @RequestParam(value="finalTakes[]")String[] finalTakes, @RequestParam(value="finalInternalTakes[]")String[] finalInternalTakes)  {
		int attendanceID = Integer.parseInt(request.getParameter("attendanceID"));
		int days = Integer.parseInt(request.getParameter("days"));
		
		ClassContentVO ccvo = new ClassContentVO();
		ccvo.setClassID(classID);
		ccvo.setDays(days);
		
		int classContentID = classInsContentService.getClassContentID(ccvo).getId();
		
		System.out.println("classContentID " + classContentID);

		List<Stu_TakesVO> takes = stu_takesService.getStudentNum(classID);  //classID
		
		for(int i=0; i<finalTakes.length; i++) {
			AttendanceCheckVO avo = new AttendanceCheckVO();
			avo.setAttendanceID(attendanceID);
			avo.setExternal(finalTakes[i]);
			avo.setStudentID(takes.get(i).getStudentID()); //takes테이블에서 바로가져오도록 하면 될듯 
			
			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setInternal(finalInternalTakes[i]);
			aivo.setStudentID(takes.get(i).getStudentID());
			aivo.setClassContentID(classContentID);
			
			if(attendanceCheckService.getAttendanceCheck(avo) != null) {
				attendanceCheckService.updateExAttendanceCheck(avo);
			}
			else {
				System.out.println("insert!");
				attendanceCheckService.insertExAttendanceCheck(avo);
				
			}
			
			
			//System.out.println("null이라고,,?? " + attendanceInCheckService.getAttendanceInCheck(aivo).getStudentID());
			if(attendanceInCheckService.getAttendanceInCheck(aivo) != null) {
				attendanceInCheckService.updateAttendanceInCheck(aivo);
				System.out.println("선생님이 inner 수정  ");
			}
			else {
				attendanceInCheckService.insertAttendanceInCheck(aivo);
				System.out.println("선생님이 inner 삽입  ");
			}
		}
		
		//classID와  days를 통해 classContentID를 가져오기 
		//classContentID와 studentID를 통해 
		
		return 1;
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/forInnerWatched", method = RequestMethod.POST)
	public AttendanceInternalCheckVO forInnerWatched(HttpServletRequest request)  {
		int classContentID = Integer.parseInt(request.getParameter("classContentID"));
		int studentID = Integer.parseInt(request.getParameter("studentID"));
		
		System.out.println("studentID : " + studentID + " / classContentID : " + classContentID);
		AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
		aivo.setClassContentID(classContentID);
		aivo.setStudentID(studentID);
		
		if(attendanceInCheckService.getAttendanceInCheck(aivo) != null)
			return attendanceInCheckService.getAttendanceInCheck(aivo);
		else {
			return null; //insert를 해서 그에 대한 Id를 가져와보기 (파일 업로드없이 출결사항을 업데이트) 
		}
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/forAttendance", method = RequestMethod.POST)
	public int forAttendance(HttpServletRequest request)  {
		//int classID = Integer.parseInt(request.getParameter("classID"));
		int days = Integer.parseInt(request.getParameter("days"));
		AttendanceVO avo = new AttendanceVO();
		avo.setClassID(classID);
		avo.setDays(days);
		
		if(attendanceService.getAttendanceID(avo) != null)
			return attendanceService.getAttendanceID(avo).getId();
		else {
			return attendanceService.insertAttendanceNoFile(avo); //insert를 해서 그에 대한 Id를 가져와보기 (파일 업로드없이 출결사항을 업데이트) 
		}
		
		
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/getfileName", method = RequestMethod.POST)
	public List<AttendanceVO> getfileName(HttpServletRequest request)  {
		return attendanceService.getAttendanceFileName(classID); //classID
		
	}
	
} 
