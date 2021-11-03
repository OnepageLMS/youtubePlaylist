package com.mycom.myapp.attendanceCheck;

import java.util.List;

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

import com.mycom.myapp.attendance.AttendanceService;
import com.mycom.myapp.attendanceCheck.AttendanceCheckService;
import com.mycom.myapp.commons.AttendanceCheckVO;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.commons.AttendanceVO;
import com.mycom.myapp.commons.ClassContentVO;
import com.mycom.myapp.member.MemberService;
import com.mycom.myapp.student.takes.Stu_TakesService;
import com.mycom.myapp.student.takes.Stu_TakesVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/attendance")
public class AttendanceCheckController {
	@Autowired
	private ClassesService classService;
	
	@Autowired
	private Stu_TakesService stu_takesService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private AttendanceService attendanceService;
	
	@Autowired
	private AttendanceCheckService attendanceCheckService;
	
	
	private int instructorID = 0;
	public int classID;
	
	@ResponseBody
	@RequestMapping(value = "/takes", method = RequestMethod.POST)
	public List<Stu_TakesVO> takes(HttpServletRequest request, Model model) throws Exception {
		
		return stu_takesService.getStudentNum(Integer.parseInt(request.getParameter("classID")));
	}
	
	@ResponseBody
	@RequestMapping(value = "/whichAttendance", method = RequestMethod.POST)
	public int whichAttendance(HttpServletRequest request, @RequestParam(value="finalTakes[]")String[] finalTakes)  {
		int attendanceID = Integer.parseInt(request.getParameter("attendanceID"));
		List<Stu_TakesVO> takes = stu_takesService.getStudentNum(classID);  //classID
		
		for(int i=0; i<finalTakes.length; i++) {
			AttendanceCheckVO avo = new AttendanceCheckVO();
			avo.setAttendanceID(attendanceID);
			avo.setExternal(finalTakes[i]);
			avo.setStudentID(takes.get(i).getStudentID()); //takes테이블에서 바로가져오도록 하면 될듯 
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
			return attendanceService.insertAttendanceNoFile(avo); //insert를 해서 그에 대한 Id를 가져와보기 (파일 업로드없이 출결사항을 업데이트) 
		}
		
		
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/getfileName", method = RequestMethod.POST)
	public List<AttendanceVO> getfileName(HttpServletRequest request)  {
		return attendanceService.getAttendanceFileName(classID); //classID
		
	}
	
} 
