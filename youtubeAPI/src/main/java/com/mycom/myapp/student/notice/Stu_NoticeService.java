package com.mycom.myapp.student.notice;

import java.util.List;

import com.mycom.myapp.commons.NoticeVO;

public interface Stu_NoticeService {
	public List<NoticeVO> getAllNotice(NoticeVO vo);
	public int insertView(NoticeVO vo);
	public int updateViewCount(int id);
	public int countNotice(int classID);
	public int countNoticeCheck(int studentID);
}
