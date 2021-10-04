package com.mycom.myapp.attendance;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/attendance")
public class AttendanceController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String attendancehome() {
		
	
		return "class/attendance";
	}	
}
