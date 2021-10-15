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
	public List<NoticeVO> getAllNotice(int id){
		return noticeDAO.getAllNotice(id);
	}

}
