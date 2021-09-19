package com.mycom.myapp.classContent;

import java.util.List;

import com.mycom.myapp.commons.ClassContentVO;

public interface ClassContentService {
	public int insertContent(ClassContentVO vo);
	public int updateContent(ClassContentVO vo);
	public int deleteContent(int id);
	public ClassContentVO getOneContent(int id);
	public List<ClassContentVO> getAllClassContent(int classID);
	public int getDaySeq(ClassContentVO vo);
}