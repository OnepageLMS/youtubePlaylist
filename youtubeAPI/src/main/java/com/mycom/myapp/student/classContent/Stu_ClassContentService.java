package com.mycom.myapp.student.classContent;

import java.util.List;

import com.mycom.myapp.commons.ClassContentVO;

public interface Stu_ClassContentService {
	public ClassContentVO getOneContent(int id);
	public List<ClassContentVO> getWeekClassContent(ClassContentVO vo); //추가
	public List<ClassContentVO> getSamePlaylistID(ClassContentVO vo); //추가
	public List<ClassContentVO> getAllClassContent(int classID);
	public int getDaySeq(ClassContentVO vo);
}
