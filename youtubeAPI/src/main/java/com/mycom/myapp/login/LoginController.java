package com.mycom.myapp.login;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.social.connect.Connection;
import org.springframework.social.google.api.Google;
import org.springframework.social.google.api.impl.GoogleTemplate;
import org.springframework.social.google.api.plus.Person;
import org.springframework.social.google.api.plus.PlusOperations;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.mycom.myapp.classes.ClassesServiceImpl;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.member.MemberServiceImpl;

@Controller
@PropertySource("classpath:config.properties")
public class LoginController {
	
	final static String GOOGLE_AUTH_BASE_URL = "https://accounts.google.com/o/oauth2/v2/auth";
	final static String GOOGLE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/token";
	final static String GOOGLE_REVOKE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/revoke";
	
	@Autowired
	private MemberServiceImpl memberService;
	
	@Autowired
	private ClassesServiceImpl classesService;
	
	@Value("${oauth.clientID}")
	private String clientID;
	@Value("${oauth.clientSecret}")
	private String clientSecret;
	
	private String loginMode = "";
	private String redirectURL = "http://localhost:8080/myapp/login/oauth2callback";
	// http://localhost:8080/myapp/login/oauth2callback // https://learntube.kr/login/oauth2callback
	
	private String entryCode = null;
	
	//(jw)
	@RequestMapping(value = "/login/{entryCode}", method = RequestMethod.GET)
	public String entry(@PathVariable String entryCode, Model model) {
		this.entryCode = entryCode;
		return "intro/entry";
	}
	
	@RequestMapping(value = "/login/signin", method = RequestMethod.GET)
	public String login() {
		return "intro/signin";
	}
	
	@RequestMapping(value = "/login/google", method = RequestMethod.POST)
	public String google(@RequestParam(value = "mode") String mode) {
		System.out.println(mode);
		loginMode = mode;
			
		String url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + clientID + "&"
							+ "redirect_uri=" + redirectURL + "&response_type=code&scope=email%20profile%20openid&access_type=offline";
		return "redirect:" + url;
	}
	
	@RequestMapping(value = "/login/oauth2callback", method = RequestMethod.GET)
	public String googleAuth(Model model, @RequestParam(value = "code") String authCode, HttpServletRequest request,
			HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
		
		// HTTP Request를 위한 RestTemplate
		RestTemplate restTemplate = new RestTemplate();
	
		// Google OAuth Access Token 요청을 위한 파라미터 세팅
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId(clientID);
		googleOAuthRequestParam.setClientSecret(clientSecret);
		googleOAuthRequestParam.setCode(authCode);
		googleOAuthRequestParam.setRedirectUri(redirectURL); 
		googleOAuthRequestParam.setGrantType("authorization_code");
	
		// JSON 파싱을 위한 기본값 세팅
		// 요청시 파라미터는 스네이크 케이스로 세팅되므로 Object mapper에 미리 설정해준다.
		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.setSerializationInclusion(Include.NON_NULL);
	
		// AccessToken 발급 요청
		ResponseEntity<String> resultEntity = restTemplate.postForEntity(GOOGLE_TOKEN_BASE_URL, googleOAuthRequestParam,
				String.class);
	
		// Token Request
		GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
		});
	
		// ID Token만 추출 (사용자의 정보는 jwt로 인코딩 되어있다)
		String jwtToken = result.getIdToken();
		String requestUrl = UriComponentsBuilder.fromHttpUrl("https://oauth2.googleapis.com/tokeninfo")
				.queryParam("id_token", jwtToken).toUriString();
	
		String resultJson = restTemplate.getForObject(requestUrl, String.class);
	
		Map<String, String> userInfo = mapper.readValue(resultJson, new TypeReference<Map<String, String>>() {
		});
		model.addAllAttributes(userInfo);
		model.addAttribute("token", result.getAccessToken()); //token 저장
        
		String email = userInfo.get("email");
		String name = userInfo.get("family_name") + userInfo.get("given_name");
		
		MemberVO checkvo = new MemberVO();
		MemberVO loginvo = new MemberVO();	//최종 로그인한 유저 정보 저장
		String returnURL = "";
		String mode = "";
		int userID = 0;
        
		if (session.getAttribute("login") != null) { 
			session.removeAttribute("login");
		}
		
		if(loginMode.equals("tea")) {
			mode = "lms_instructor";
			returnURL = "redirect:/dashboard";
		}
		else {
			mode = "lms_student";
			returnURL = "redirect:/student/class/dashboard";
		}
		checkvo.setMode(mode);
		checkvo.setEmail(email);
		
		loginvo = memberService.getMember(checkvo);
		if(loginvo == null) {
			loginvo = new MemberVO();
			loginvo.setName(name);
			loginvo.setEmail(email);
			loginvo.setMode(mode);
			userID = memberService.insertMember(loginvo);
			loginvo.setId(userID);
			if(userID > 0) 
				System.out.println("회원가입 성공:)");
			else {
				System.out.println("회원가입 실패:(");
				return "redirect:/login/signin";
			}
		}
		else {
			loginvo.setMode(mode);
		}
		
		session.setAttribute("userID", loginvo.getId());
		session.setAttribute("login", loginvo);
		
		//(jw)
		if(entryCode != null) {
			
		}
		return returnURL;
	}
	
	@RequestMapping(value = "/login/revoketoken") //토큰 무효화
	public Map<String, String> revokeToken(@RequestParam(value = "token") String token) throws JsonProcessingException {

		Map<String, String> result = new HashMap<>();
		RestTemplate restTemplate = new RestTemplate();
		final String requestUrl = UriComponentsBuilder.fromHttpUrl(GOOGLE_REVOKE_TOKEN_BASE_URL)
				.queryParam("token", token).encode().toUriString();
		
		String resultJson = restTemplate.postForObject(requestUrl, null, String.class);
		result.put("result", "success");
		result.put("resultJson", resultJson);
		return result;
	}
	
	@RequestMapping(value = "/login/signout")
	public String logout(HttpSession session) {
		session.invalidate();
		System.out.println("logged out!");
		return "redirect:/login/signin";
	}
	
	
	
	/*
	@ResponseBody
	@RequestMapping(value = "/deleteMember", method = RequestMethod.POST)
	public void deleteMember(@RequestParam(value = "deleteOpt") String opt, HttpSession session) {
		MemberVO vo = new MemberVO();
		vo.setId((Integer)session.getAttribute("userID"));
		if(loginMode.equals("tea")) vo.setMode("lms_instructor");
		else vo.setMode("lms_student");
		
		선생님의 경우 
		1. lms_instructor 삭제
		case1. 기존 데이터 유지
			2. foreign_key 되어있는곳 null
			lms_class, playlist instructor=null
		
		case2. 기존 데이터 전체 삭제
			lms_class 직접 삭제
				- class 삭제시 아래 자동 삭제됨
					- attendance 삭제 -> attendanceCheck 자동삭제
					- classContent 삭제 -> playlist 삭제?!
					- playlist 삭제 -> video, videoCheck, playlistCheck 자동 삭제
					- notice 삭제 -> noticeCheck 삭제
		
		- 사용중이지 않은 playlist삭제!
		
		if(memberService.deleteMember(vo) != 0) {
			System.out.println("회원 삭제 완료!");
			if(opt == "all") {
				
			}
			else {
				
			}
		}
		else
			System.out.println("회원 삭제 실패!");
	}*/
	
}
