package com.mycom.myapp.commons;

public class MemberVO {
	private int id;
	private String name;
	private String email;
	private String oauth_code;	//google 로그인시 oauth_code 저장
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getOauth_code() {
		return oauth_code;
	}
	public void setOauth_code(String oauth_code) {
		this.oauth_code = oauth_code;
	}
}
