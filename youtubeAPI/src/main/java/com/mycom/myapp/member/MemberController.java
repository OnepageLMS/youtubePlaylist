package com.mycom.myapp.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.commons.MemberVO;

@Controller
@RequestMapping(value = "/member")
public class MemberController {
	@Autowired
	private MemberServiceImpl memberService;
	
	@ResponseBody
	@RequestMapping(value = "/updateName", method = RequestMethod.POST)
	public void updateName(@RequestParam(value = "name") String name, HttpSession session) {
		MemberVO loginvo = (MemberVO)session.getAttribute("login");
		MemberVO vo = new MemberVO();
		vo.setId((Integer)session.getAttribute("userID"));
		vo.setName(name);
		vo.setMode(loginvo.getMode());
		
		if(memberService.updateName(vo) != 0) {
			System.out.println("이름 업데이트 성공!");
			loginvo.setName(name);
			session.setAttribute("loginvo", loginvo);
		}
			
		else
			System.out.println("이름 업데이트 실패!");
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteMember", method = RequestMethod.POST)	
	public void deleteMember(HttpSession session) {
		MemberVO loginvo = (MemberVO)session.getAttribute("login");
		
		if(memberService.deleteMember(loginvo) != 0) {
			if(loginvo.getMode().equals("lms_instructor")) {
				//class 자동삭제 -> attendance(+check) & classContent & notice(+check) & playlistCheck & videoCheck & takes 자동삭제
				//playlist(+check) 자동삭제 -> video(+check)
				System.out.println("선생남 탈퇴 완료!");
			}
			else {
				//takes & attendanceCK & noticeCK & playlistCK & videoCK 자동삭제
				System.out.println("학생 탈퇴 완료!");
			}
			
		}
	}
}
