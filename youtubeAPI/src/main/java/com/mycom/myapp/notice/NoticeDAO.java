package com.mycom.myapp.notice;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.NoticeVO;

@Repository
public class NoticeDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertNotice(NoticeVO vo) {
		return sqlSession.insert("Notice.insertNotice", vo);
	}
	
	public int updateNotice(NoticeVO vo) {
		return sqlSession.update("Notice.updateNotice", vo);
	}
	
	public int deleteNotice(int id) {
		return sqlSession.delete("Notice.deleteNotice", id);
	}
	
	public List<NoticeVO> getAllNotice(int id) {
		return sqlSession.selectList("Notice.getAllNotice", id);
	}
	
	
}
