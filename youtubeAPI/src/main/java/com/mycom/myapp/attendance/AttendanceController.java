package com.mycom.myapp.attendance;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
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
import com.mycom.myapp.commons.ClassesVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.attendanceInternalCheck.Stu_AttendanceInternalCheckService;
import com.mycom.myapp.student.classContent.Stu_ClassContentService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckService;
import com.mycom.myapp.student.playlistCheck.Stu_PlaylistCheckVO;
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
	
	@Autowired
	private Stu_PlaylistCheckService playlistcheckService;
	
	
	private int instructorID = 0;
	public int classID;
	
	@RequestMapping(value = "/{classId}", method = RequestMethod.GET)	//???????????? ????????????!!!
	public String attendancehome(@PathVariable("classId") int classId, Model model, HttpSession session) {
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
		
		List<Stu_TakesVO> studentTakes = stu_takesService.getStudentTakes(classID);
		model.addAttribute("takes", JSONArray.fromObject(studentTakes));	
		model.addAttribute("takesNum", studentTakes.size());
		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("classDays", JSONArray.fromObject(classService.getClass(classID).getDays()));
		model.addAttribute("realAllMyClass", JSONArray.fromObject(classContentService.getAllClassContent(classID))); //?????? ?????? 
		model.addAttribute("weekContents", JSONArray.fromObject(classContentService.getWeekClassContent(classID))); 
		
		// ?????? ?????? (jw)
		model.addAttribute("studentInfo", stu_takesService.getStudentInfo(classId));
		
		// attendance csv (hy)
		List<AttendanceVO> id = attendanceService.getAttendanceList(classID); //?????? classID??? ?????? attribute??? ?????? (?????? ???????????? ???????????? ????????? ??????) 
		//List<Stu_TakesVO> takes = stu_takesService.getStudentNum(classID); //?????? classID??? ?????? ????????? ???????????? ?????? ??? 
		List<List<String>> file = new ArrayList<List<String>>();
		List<String> fileList = new ArrayList<String>();
		
		AttendanceCheckVO avo = new AttendanceCheckVO();
		for(int i=0; i<id.size(); i++) { 
			
			int attendanceID = id.get(i).getId(); // 7, 8, 9, 10
			avo.setAttendanceID(attendanceID);
			if(attendanceService.getAttendance(attendanceID).getFileName() == null) 
				continue; 
			List<AttendanceCheckVO> takes = attendanceCheckService.getAttendanceCheckList(attendanceID); 
				for(int j=0; j<takes.size(); j++) { 
						//takes.size()????????? ????????? ?????? ??????, 1???????????? 3?????? ?????? ????????? ????????????????????? ??? ????????? ??????????????? ??? ???????????? -> 4???
						//?????? indexOutOfBoundsException??? ????????????.
						//attendanceCheck?????? id??? ?????? ?????? ???????????? 
					//takeService.getStudentTakes(classID).get(j).getStudentID() -> ??? sutentID??? attendanceCheck
					avo.setStudentID(stu_takesService.getStudentTakes(classID).get(j).getStudentID());
					if(attendanceCheckService.getAttendanceCheck(avo) != null && !attendanceCheckService.getAttendanceCheck(avo).getExternal().equals("") ) {
						System.out.println("studentID : " + stu_takesService.getStudentTakes(classID).get(j).getStudentID());
						fileList.add(attendanceCheckService.getAttendanceCheckList(attendanceID).get(j).getExternal());
						file.add(fileList);
					//????????? ??? student table??? join?????? ?????? ??????????????? ????????? ??? ????????? ?????? 
					}
					else {
						fileList.add("");
					}
				}
		}
		model.addAttribute("file", file);
		
		if(file.size() == 0)
			model.addAttribute("fileNum",file.size());
		else
			model.addAttribute("fileNum", attendanceCheckService.getAttendanceCheckListCount(classID));
		return "class/attendance";
	}	
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {	
		
		return stu_takesService.getStudentTakes(Integer.parseInt(request.getParameter("classID")));
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forDays", method = RequestMethod.POST)
	public List<List<String>> forDays(HttpServletRequest request, Model model) throws Exception { //?????? ???????????? ?????? 
		ClassContentVO ccvo = new ClassContentVO ();
		AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
		List<Stu_TakesVO> takes = stu_takesService.getStudentTakes(classID);  //classID
		List<List<String>> stuAttend = new ArrayList<List<String>>();
		int dayNum = classInsContentService.getClassDaysNum(classID);
		
		ccvo.setClassID(classID);
		aivo.setClassID(classID);
		
		for(int i=0; i<stu_takesService.getStudentNum(classID); i++) {
			List<String> stuOne = new ArrayList<String>();
			
			for(int j=0; j<dayNum; j++) { //????????? ?????? 

				ccvo.setDays(j);
				
				int studentID = takes.get(i).getStudentID();
				//System.out.println("aivo??? ???????????? ?????? " + classID + ", studnetID :" +studentID+ " days : " +j);
				aivo.setStudentID(studentID);
				aivo.setDays(j);
				if(classContentService.getDaySeq(ccvo) == 0) { //?????? ??? ????????? ?????? ??? 
					break;
				}
				
				else if(classContentService.getDaySeq(ccvo) == attendanceInCheckService.getAttendanceInCheckExistedNum(aivo)) {
					//?????? ??? ????????? ?????????, ????????? ????????? ????????? ????????? ?????? ?????? 	
					for(int k=0; k<classContentService.getDaySeq(ccvo); k++) {
						
						if(attendanceInCheckService.getAttendanceInCheckExisted(aivo).get(k).getInternal().equals("??????")) {		
							stuOne.add("??????");
							break;
						}
						else if(attendanceInCheckService.getAttendanceInCheckExisted(aivo).get(k).getInternal().equals("??????")) {
							if(k == classContentService.getDaySeq(ccvo)-1)
								stuOne.add("??????");
							continue;
						}
						else if(attendanceInCheckService.getAttendanceInCheckExisted(aivo).get(k).getInternal().equals("??????")) {
							if(k == classContentService.getDaySeq(ccvo)-1)
								stuOne.add("??????");
							continue;
						}
						else {
							//?????????
							if(k == classContentService.getDaySeq(ccvo)-1)
								stuOne.add("?????????");
							continue;
						}
							
					}
	
					//?????? ????????? ????????? ?????????, db??? ?????? ????????? ???????????????,, 
				}
				else {
					//?????? ??? ????????? ?????????, ????????? ????????? ????????? ????????? ?????? ?????? 
					//classContent???????????? ?????? ?????????, ???????????? 
					//???????????? > ???????????? : ?????????
					//???????????? < ???????????? : ??????
					//??????????????? ???????????? ?????? ?????? ????????? ????????????,, 
					Date now = new Date();
					
					for(int k=0; k<classContentService.getDaySeq(ccvo); k++) {
						if(classInsContentService.getEndDate(ccvo).get(k) == null) { //??????????????? ?????????????????? ?????? ?????? 
							//System.out.println("1??? ????????? ");
							stuOne.add("?????????");
							break;
						}
						
						String endString = classInsContentService.getEndDate(ccvo).get(k).getEndDate();
						endString =  endString.replace("T", " "); 
						Date endDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(endString);
						
						int result = endDate.compareTo(now); 
						
						if(result != 0 && result != 1) {
							stuOne.add("??????");
							break;
						}
						else {
							if(k == classInsContentService.getEndDate(ccvo).size()-1) {
								stuOne.add("?????????");
							}
							continue;
						}
					}
				}
				
				
			}
			stuAttend.add(stuOne);
		}
		
			
		return stuAttend;
	}	
	
	@ResponseBody
	@RequestMapping(value = "/forWatchedCount", method = RequestMethod.POST)
	public List<List<Integer>> forWatchedCount(HttpServletRequest request, Model model) throws Exception { //?????? ????????? 
	    List<List<Integer>> stuWatched = new ArrayList<List<Integer>>();
	    
	    int dayNum = classInsContentService.getClassDaysNum(classID);
	    List<Stu_TakesVO> takes = stu_takesService.getStudentTakes(classID);  //classID
	    ClassContentVO ccvo = new ClassContentVO ();
	    Stu_PlaylistCheckVO pcvo = new Stu_PlaylistCheckVO();
	    
	    ccvo.setClassID(classID);
	    pcvo.setClassID(classID);
	    
	    for(int i=0; i<takes.size(); i++) {
	    	List<Integer> stuOne = new ArrayList<Integer>();
	    	int studentID = takes.get(i).getStudentID();
	    	
	    	for(int j=0; j<dayNum; j++) {
				ccvo.setDays(j);
				pcvo.setStudentID(studentID);
				pcvo.setDays(j);
				 
				if(classContentService.getDaySeq(ccvo) == 0)
					stuOne.add(-1);
				else {
					stuOne.add(playlistcheckService.getCompletePlaylistWithDays(pcvo).size() / classContentService.getDaySeq(ccvo) * 100);
				}
		    }
	    	
	    	stuWatched.add(stuOne);
	    }
	    
		
	    return stuWatched;
	}

	@ResponseBody
	@RequestMapping(value = "/uploadCSV", method = RequestMethod.POST)
	public List<List<String>> uploadCSV(MultipartHttpServletRequest request, Model model) throws Exception {
		//???????????? ???????????? ????????? ????????????, takes??????????????? ???????????? ????????????
		//???????????? ????????? ??? ???????????? ???????????? 
		
		MultipartFile file = request.getFile("file");
		
		int start_h = Integer.parseInt(request.getParameter("start_h"));
		int start_m = Integer.parseInt(request.getParameter("start_m"));
		int end_h = Integer.parseInt(request.getParameter("end_h"));
		int end_m = Integer.parseInt(request.getParameter("end_m"));
		int days = Integer.parseInt(request.getParameter("daySeq"));
		//start_h ~ seq?????? jsp???????????? ???????????? --> done!done!
		
		UUID uuid = UUID.randomUUID();
		String saveName = uuid + "_" + file.getOriginalFilename();

		List<List<String>> csvList = new ArrayList<List<String>>();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/csv/"); //??????????????? ??????????????? ???????????? ?? 
		System.out.println("realPath : " + realPath); 
		File saveFile = new File(realPath, saveName);
		
		try{
			file.transferTo(saveFile);
		}
		catch(IOException e) {
			e.printStackTrace();
			return null;
		}
		
		
		//db(Attendace?????????)??? insert??????
		AttendanceVO avo = new AttendanceVO();
		avo.setClassID(classID);
		avo.setDays(days);
		avo.setFileName(saveName);
		if(attendanceService.getAttendanceID(avo) != null) { //?????? ?????? ????????? ?????? ????????? ???????????????????????? ???????????? 
			System.out.println("already updated!");
			attendanceService.updateAttendance(avo);
		}
		else {
			if(attendanceService.insertAttendance(avo) != 0) { //????????? insert 
				System.out.println("attendance insert??????!");
			}
			else {
				System.out.println("attendance insert??????!");
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
                String[] lineArr = line.split(","); 
                aLine = Arrays.asList(lineArr);
                csvList.add(aLine);
                //idx++;
			}
			
            List<Stu_TakesVO> data = stu_takesService.getStudentTakes(classID); //db?????? ???????????? ???????????? classID????????? ?????? 
            List<String> stuNameArr = new ArrayList<String>();
            for(int i=0; i<data.size(); i++) {
            	stuNameArr.add(data.get(i).getName()); //??? ????????? ?????? ???????????? ????????? ?????? (db??? takes ??????????????????) 
            }
            

    		List<String> attendStu = new ArrayList<String>();
    		List<String> absentStu = new ArrayList<String>();
    		List<String> annonyStu = new ArrayList<String>();
            
    		//int stuNum = 0;
            for(int i=4; i<csvList.size(); i++) {
    			for(int j=0; j<stuNameArr.size(); j++) {
    				if(csvList.get(i).get(0).contains(stuNameArr.get(j)) ) { //csv?????? ?????? ????????? ?????? ????????? ?????????
    					//??????????????? ????????? ????????? ???????????? ?????? ???????????? ????????????
    					attendStu.add(stuNameArr.get(j));
    					
    					csvStartH.add( Integer.parseInt(csvList.get(i).get(2).charAt(11) + "" + csvList.get(i).get(2).charAt(12)));
                    	csvEndH.add( Integer.parseInt(csvList.get(i).get(3).charAt(11) + "" + csvList.get(i).get(3).charAt(12)));
                    	
                    	csvStartM.add( Integer.parseInt(csvList.get(i).get(2).charAt(14) + "" + csvList.get(i).get(2).charAt(15)));
                    	csvEndM.add( Integer.parseInt(csvList.get(i).get(3).charAt(14) + "" + csvList.get(i).get(3).charAt(15)));
                    	
    					//stuNum++;
    				}
    				else { // ????????? ????????? 
    					continue;
    				}
    	
    			}
    		}
            //????????? ???????????? ??????
            int count = 0;
            for(int i=0; i<attendStu.size(); i++) {
            	if(start_h > csvStartH.get(i) ) {
            		if(end_h < csvEndH.get(i)) {
            			continue;
        				//?????? 
        			}
            		
            		else if(end_h == csvEndH.get(i)){ 
            			if(end_m <= csvEndM.get(i)) {
            				continue;
            				// ?????? 
        				}
            			else {
            				//?????? 
            				//???????????? ?????? ????????? ??????
            				// i????????? ????????? attendStu??? list????????? ???????????????.,
            				absentStu.add(attendStu.get(i));
            				attendStu.remove(i);
            				
            			}
            		}
            		
            		else {
    					//?????? 
            			//???????????? ?????? ????????? ?????? 
            			absentStu.add(attendStu.get(i));
            			attendStu.remove(i);
    				}
            	}
            	else if(start_h == csvStartH.get(i)) {
            		if(start_m >= csvStartM.get(i)) {
            			if(end_h < csvEndH.get(i)) {
            				continue;
            				//?????? 
            			}
                		
                		else if(end_h == csvEndH.get(i)){ 
                			if(end_m <= csvEndM.get(i)) {
                				continue;
                				// ?????? 
            				}
                			else {
                				//?????? 
                    			//???????????? ?????? ????????? ?????? 
                				absentStu.add(attendStu.get(i));
                				attendStu.remove(count);
                			}
                		}
                		
                		else {
                			//?????? 
                			//???????????? ?????? ????????? ?????? 
                			absentStu.add(attendStu.get(i));
                			attendStu.remove(i);
            				//absentStu.add(attendStu.get(i));
                		}
            		}
            		
            		else {
            			//?????? 
            			//???????????? ?????? ????????? ?????? 
            			absentStu.add(attendStu.get(i));
            			attendStu.remove(i);
            		}
            		
            	}
            	else {
            		//?????? 
        			//???????????? ?????? ????????? ?????? 
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

		List<Stu_TakesVO> takes = stu_takesService.getStudentTakes(classID);  //classID
		
		for(int i=0; i<finalInternalTakes.length; i++) { //internal??? ????????? 
			AttendanceInternalCheckVO aivo = new AttendanceInternalCheckVO();
			aivo.setStudentID(takes.get(i).getStudentID());
			aivo.setClassID(classID);
			aivo.setDays(days);
			
			for(int j=0; j<classContentService.getDaySeq(ccvo); j++) {
				aivo.setClassContentID(classInsContentService.getClassContentID(ccvo).get(j).getId());
				aivo.setInternal(finalInternalTakes[i]);
				
				if(attendanceInCheckService.getAttendanceInCheckByIDExisted(aivo) == null) {
					attendanceInCheckService.insertAttendanceInCheck(aivo);
					System.out.println("???????????? inner ??????  ");
				}
				else {
					attendanceInCheckService.updateAttendanceInCheck(aivo);
					System.out.println("???????????? inner ??????  ");
				}
			}
		}
		
		for(int i=0; i<finalTakes.length; i++) {//external??? ????????? 
			AttendanceCheckVO avo = new AttendanceCheckVO();
			avo.setAttendanceID(attendanceID);
			avo.setExternal(finalTakes[i]);
			avo.setStudentID(takes.get(i).getStudentID()); //takes??????????????? ????????????????????? ?????? ?????? 
			
			
			if(attendanceCheckService.getAttendanceCheck(avo) != null) {
				attendanceCheckService.updateExAttendanceCheck(avo);
			}
			else {
				System.out.println("insert!");
				attendanceCheckService.insertExAttendanceCheck(avo);
				
			}
		}
		
		
		return 1;
		
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
			return attendanceService.insertAttendanceNoFile(avo); //insert??? ?????? ?????? ?????? Id??? ??????????????? (?????? ??????????????? ??????????????? ????????????) 
		}
		
		
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/getfileName", method = RequestMethod.POST)
	public List<AttendanceVO> getfileName(HttpServletRequest request)  {
		return attendanceService.getAttendanceFileName(classID); //classID
		
	}
	
} 