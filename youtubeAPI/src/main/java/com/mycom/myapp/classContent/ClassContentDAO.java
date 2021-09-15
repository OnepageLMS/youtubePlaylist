package com.mycom.myapp.classContent;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mycom.myapp.commons.ClassContentVO;

@Repository
public class ClassContentDAO {
	@Autowired
	SqlSession sqlSession;
	
	public int insertContent(ClassContentVO vo) {
		int result = sqlSession.insert("ClassContent.insertContent", vo);
		return result;
	}
	
	public int updateContent(ClassContentVO vo) {
		int result = sqlSession.update("ClassContent.updateContent", vo);
		return result;
	}
	
	public int deleteContent(int id) {
		int result = sqlSession.delete("ClassContent.deleteContent", id);
		return result;
	}
	
	public ClassContentVO getOneContent(int id) {
		ClassContentVO result = sqlSession.selectOne("ClassContent.getOneContent", id);
		return result;
	}
	
	public List<ClassContentVO> getAllClassContent(int classID){
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getAllClassContent", classID);
		return result;
	}
	
	public int getDaySeq(ClassContentVO vo) {
		int result = sqlSession.selectOne("ClassContent.getDaySeq", vo);
		return result;
	}
}
