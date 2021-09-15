package com.mycom.myapp.student.video;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycom.myapp.commons.VideoVO;

@Service
public class Stu_VideoServiceImpl implements Stu_VideoService{
	
	@Autowired
	Stu_VideoDAO videoDAO;
	
	@Override
	public VideoVO getVideo(int playlistID) {
		return videoDAO.getVideo(playlistID);
	}
	
	@Override
	public List<VideoVO> getVideoList(VideoVO vo) {
		return videoDAO.getVideoList(vo);
	}
}