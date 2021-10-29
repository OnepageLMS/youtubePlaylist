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
	
	/*@RequestMapping(value = "/oauth2callback", method = RequestMethod.GET)
	public String googleAuth(Model model, @RequestParam(value = "code") String authCode, HttpServletRequest request,
			HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
		
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
        AccessGrant accessGrant = oauthOperations.exchangeForAccess(authCode , googleOAuth2Parameters.getRedirectUri(), null);
        
        String accessToken = accessGrant.getAccessToken();
        Long expireTime = accessGrant.getExpireTime();
        
        if (expireTime != null && expireTime < System.currentTimeMillis()) {
            accessToken = accessGrant.getRefreshToken();
            System.out.printf("accessToken is expired. refresh token = {}", accessToken);
        }
        
		String requestUrl = UriComponentsBuilder.fromHttpUrl("https://oauth2.googleapis.com/tokeninfo")
				.queryParam("id_token", accessToken).toUriString();

		String resultJson = restTemplate.getForObject(requestUrl, String.class);

		Map<String, String> userInfo = mapper.readValue(resultJson, new TypeReference<Map<String, String>>() {
		});
		model.addAllAttributes(userInfo);
		
        
        Connection<Google> connection = googleConnectionFactory.createConnection(accessGrant);
        Google google = connection == null ? new GoogleTemplate(accessToken) : connection.getApi();
        
        PlusOperations plusOperations = google.plusOperations();
        Person profile = plusOperations.getGoogleProfile();
        
       
        
        //DB 저장 or check
        String email = profile.getAccountEmail();
        MemberVO checkvo = new MemberVO();
		checkvo.setEmail(email);
		checkvo.setName(profile.getDisplayName());
		checkvo.setOauth_code(profile.getId());
		
		String returnURL = "";
		if (session.getAttribute("login") != null) { 
			session.removeAttribute("login");
		}
		
		if(loginMode == "tea") {		
			if(memberService.getInstructor(email) == null) {
				if(memberService.insertInstructor(checkvo) != 0)
					System.out.println("회원가입 성공:)");
				else {
					System.out.println("회원가입 실패:(");
					return "redirect:/signin";
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
					return "redirect:/signin";
				}		
			}
			returnURL = "redirect:/student/class/dashboard";	
		}
		
		session.setAttribute("login", checkvo);
		
        // set info session userid
        session.setAttribute("info_userid", profile.getAccountEmail());
        session.setAttribute("info_usernname", profile.getDisplayName());
        session.setAttribute("info_userprofile", profile.getImageUrl());
        session.setAttribute("info_oauth", "google");
 
		return returnURL;
	}*/
	
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
		return "redirect:/signin";
	}
	

}
