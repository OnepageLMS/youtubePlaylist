package com.mycom.myapp.notice;

import java.util.List;

import com.mycom.myapp.commons.NoticeVO;

public interface NoticeService {
	public int insertNotice(NoticeVO vo);
	public int updateNotice(NoticeVO vo);
	public int deleteNotice(int id);
	public List<NoticeVO> getAllNotice(int id);	
	public int insertNoticeCheckRecord(NoticeVO vo);
}
