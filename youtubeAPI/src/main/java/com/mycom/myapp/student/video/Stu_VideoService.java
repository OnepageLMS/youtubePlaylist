package com.mycom.myapp.student.video;

import java.util.List;

import com.mycom.myapp.commons.VideoVO;

public interface Stu_VideoService {
	
	public VideoVO getVideo(int playlistID);
	//public List<PlaylistVO> getVideoList(int playlistID);
	public List<VideoVO> getVideoList(VideoVO vo);
//	public PlaylistVO getPlaylist(int id);

}