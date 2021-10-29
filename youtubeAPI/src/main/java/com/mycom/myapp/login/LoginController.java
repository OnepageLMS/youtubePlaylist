package com.mycom.myapp.login;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.mycom.myapp.commons.MemberVO;
import com.mycom.myapp.member.MemberServiceImpl;
import com.mycompany.myapp.member.GoogleOAuthRequest;
import com.mycompany.myapp.member.GoogleOAuthResponse;

@Controller
@RequestMapping(value = "/login")
public class LoginController {
	
	final static String GOOGLE_AUTH_BASE_URL = "https://accounts.google.com/o/oauth2/v2/auth";
	final static String GOOGLE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/token";
	final static String GOOGLE_REVOKE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/revoke";
	
	@Autowired
	private MemberServiceImpl memberService;
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;
	
	private String loginMode = "";
	
	@RequestMapping(value = "/signin", method = RequestMethod.GET)
	public String login() {
		return "intro/signin";
	}
	
	@RequestMapping(value = "/google", method = RequestMethod.POST)
	public String google(@RequestParam(value = "mode") String mode) {
		System.out.println(mode);
		loginMode = mode;
			
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();	//구글 code 발행 
		String url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);	//google 로그인페이지 이동 url생성
		return "redirect:" + url;
	}
	
	@RequestMapping(value = "/oauth2callback", method = RequestMethod.GET)
	public String googleAuth(Model model, @RequestParam(value = "code") String authCode, HttpServletRequest request,
			HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
		
		// HTTP Request를 위한 RestTemplate
		RestTemplate restTemplate = new RestTemplate();
	
		// Google OAuth Access Token 요청을 위한 파라미터 세팅
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId("681590312169-uqt06gfeq64jmh1unlprnc3toq97sv9j.apps.googleusercontent.com");
		googleOAuthRequestParam.setClientSecret("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");
		googleOAuthRequestParam.setCode(authCode);
		googleOAuthRequestParam.setRedirectUri("http://localhost:8080/myapp/login/oauth2callback"); 
		// http://localhost:8080/myapp/login/oauth2callback // https://yewonproj.herokuapp.com/login/oauth2callback
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
		model.addAttribute("token", result.getAccessToken()); //토큰 token에 저장!!
		
        //DB 저장 or check
        String email = userInfo.get("email");
        MemberVO checkvo = new MemberVO();
		checkvo.setEmail(email);
		checkvo.setName(userInfo.get("family_name") + userInfo.get("given_name"));
		
		String returnURL = "";
		if (session.getAttribute("login") != null) { 
			session.removeAttribute("login");
		}
		System.out.println(email);
		
		if(loginMode.equals("tea")) {		
			if(memberService.getInstructor(email) == null) {
				if(memberService.insertInstructor(checkvo) != 0)
					System.out.println("회원가입 성공:)");
				else {
					System.out.println("회원가입 실패:(");
					return "redirect:/login/signin";
				}
					
			}
			returnURL = "redirect:/dashboard";
		}
		else if(loginMode == "stu") {
			if(memberService.getStudent(email) == null) {
				if(memberService.insertStudent(checkvo) != 0)
					System.out.println("회원가입 성공!");
				else {
					System.out.println("회원가입 실패:(");
					return "redirect:/login/signin";
				}		
			}
			returnURL = "redirect:/student/class/dashboard";
		}
		
		session.setAttribute("login", checkvo);
		
        // set info session userid
		/*
        session.setAttribute("info_userid", profile.getAccountEmail());
        session.setAttribute("info_usernname", profile.getDisplayName());
        session.setAttribute("info_userprofile", profile.getImageUrl());
        session.setAttribute("info_oauth", "google");
        */
 
		return returnURL;
	}
	
	@RequestMapping(value = "/revoketoken") //토큰 무효화
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
	
	@RequestMapping(value = "/signout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login/signin";
	}
	

}
