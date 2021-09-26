package com.mycom.myapp.classContent;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.ClassContentVO;

@Service
public class ClassContentServiceImpl implements ClassContentService{

	@Autowired
	ClassContentDAO ClassContentDAO;
	
	@Override
	public int insertContent(ClassContentVO vo) {
		return ClassContentDAO.insertContent(vo);
	}
	
	@Override
	public int updateContent(ClassContentVO vo) {
		return ClassContentDAO.updateContent(vo);
	}
	
	@Override
	public int deleteContent(ClassContentVO vo) {
		return ClassContentDAO.deleteContent(vo); //int id => ClassContentVO vo 수정
	}
	
	@Override
	public ClassContentVO getOneContent(int id) {
		return ClassContentDAO.getOneContent(id);
	}
	@Override
	public List<ClassContentVO> getAllClassContent(int classID){
		return ClassContentDAO.getAllClassContent(classID);
	}
	
	@Override
	public int getDaySeq(ClassContentVO vo) {
		return ClassContentDAO.getDaySeq(vo);
	}
}
