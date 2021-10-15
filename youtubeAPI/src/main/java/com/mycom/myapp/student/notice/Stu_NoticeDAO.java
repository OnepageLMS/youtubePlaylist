package com.mycom.myapp.student.notice;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.NoticeVO;

@Repository
public class Stu_NoticeDAO {
	@Autowired
	SqlSession sqlSession;
	
	public List<NoticeVO> getAllNotice(int id) {
		return sqlSession.selectList("Notice.getAllNotice", id);
	}

}
