package com.mycom.myapp.calendar;

import java.util.List;

import com.mycom.myapp.commons.CalendarVO;

public interface CalendarService {
	public int insertEvent(CalendarVO vo);
	public int updateEvent(CalendarVO vo);
	public List<CalendarVO> getScheduleList(int classID);
}
