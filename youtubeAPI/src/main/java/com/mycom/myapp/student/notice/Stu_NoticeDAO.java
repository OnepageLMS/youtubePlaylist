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
	
	public List<NoticeVO> getAllNotice(NoticeVO vo) {
		return sqlSession.selectList("Stu_Notice.getAllNotice", vo);
	}
	
	public int insertView(NoticeVO vo) {
		return sqlSession.insert("Stu_Notice.insertView", vo);
	}
	
	public int updateViewCount(int id) {
		return sqlSession.update("Stu_Notice.updateViewCount", id);
	}

}
