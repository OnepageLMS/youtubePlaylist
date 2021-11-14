package com.mycom.myapp.calendar;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mycom.myapp.commons.CalendarVO;

@Repository
public class CalendarDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertEvent(CalendarVO vo) {
		return sqlSession.insert("Calendar.insertEvent", vo);
	}
	
	public int updateEvent(CalendarVO vo) {
		return sqlSession.update("Calendar.updateEvent", vo);
	}
	
	public List<CalendarVO> getScheduleList(int classID){
		return sqlSession.selectList("Calendar.getScheduleList", classID);
	}
}
