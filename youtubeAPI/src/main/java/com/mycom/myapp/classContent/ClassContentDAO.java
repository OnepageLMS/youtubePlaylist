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
	
	public int updatePublished(ClassContentVO vo) {
		int result = sqlSession.update("ClassContent.updatePublished", vo);
		return result;
	}
	
	public int deleteContent(ClassContentVO vo) { //int id => ClassContentVO vo 수정
		int result = sqlSession.delete("ClassContent.deleteContent", vo);
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
	
	public List<ClassContentVO> getAllClassContentForCopy(int classID){
		List<ClassContentVO> result = sqlSession.selectList("ClassContent.getAllClassContentForCopy", classID);
		return result;
	}
	
	public int insertCopiedClassContents(List<ClassContentVO> list) {
		return sqlSession.insert("ClassContent.insertCopiedClassContents", list);
	}
	
	public int getDaySeq(ClassContentVO vo) {
		return sqlSession.selectOne("ClassContent.getDaySeq", vo);
	}
}
