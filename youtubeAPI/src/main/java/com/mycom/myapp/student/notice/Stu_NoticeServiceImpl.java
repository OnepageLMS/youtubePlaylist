package com.mycom.myapp.student.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.NoticeVO;

@Service
public class Stu_NoticeServiceImpl implements Stu_NoticeService{
	@Autowired
	Stu_NoticeDAO noticeDAO;
	
	@Override
	public List<NoticeVO> getAllNotice(NoticeVO vo){
		return noticeDAO.getAllNotice(vo);
	}
	
	@Override
	public List<NoticeVO> getAllPin(NoticeVO vo){
		return noticeDAO.getAllPin(vo);
	}
	
	@Override
	public int insertView(NoticeVO vo) {
		return noticeDAO.insertView(vo);
	}
	
	@Override
	public int updateViewCount(int id) {
		return noticeDAO.updateViewCount(id);
	}
	
	@Override
	public int countNotice(int classID) {
		return noticeDAO.countNotice(classID);
	}
	
	@Override
	public int countNoticeCheck(NoticeVO vo) {
		return noticeDAO.countNoticeCheck(vo);
	}

}
