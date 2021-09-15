package com.mycom.myapp.student.classContent;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassContentVO;

@Repository
 public class Stu_ClassContentDAO {
 	@Autowired
 	SqlSession sqlSession;
 	
 	public ClassContentVO getOneContent(int id) {
 		ClassContentVO result = sqlSession.selectOne("Stu_ClassContent.getOneContent", id);
 		return result;
 	}
 	
 	public List<ClassContentVO> getWeekClassContent(ClassContentVO vo){
 		List<ClassContentVO> result = sqlSession.selectList("Stu_ClassContent.getWeekClassContent", vo);
 		return result;
 	}
 	
 	public List<ClassContentVO> getSamePlaylistID(ClassContentVO vo) {
 		List<ClassContentVO> result = sqlSession.selectList("Stu_ClassContent.getSamePlaylistID", vo);
 		return result;
 	}
 	
 	public List<ClassContentVO> getAllClassContent(int classID){
 		List<ClassContentVO> result = sqlSession.selectList("Stu_ClassContent.getAllClassContent", classID);
 		return result;
 	}
 	
 	public int getDaySeq(ClassContentVO vo) {
 		int result = sqlSession.selectOne("Stu_ClassContent.getDaySeq", vo);
 		return result;
 	}
 }