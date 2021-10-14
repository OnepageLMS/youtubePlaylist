package com.mycom.myapp.student.notice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Stu_NoticeServiceImpl implements Stu_NoticeService{
	@Autowired
	Stu_NoticeDAO noticeDAO;

}
