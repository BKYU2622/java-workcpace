package com.goodee.model.vo;

import java.sql.Date;

// vo(Variable Object): 레코드 단위로 데이터를 담기위한 클래스. 읽기(getter)만 가능
// dto(Data Transfer Object): vo와 비슷한 역할을 하지만 데이터를 읽고 쓸 수 있음
public class Test {
	private int    testNo;
	private String testName;
	private Date   testdate;
	
	// 기본생성자
	public Test() {}

	// 매개변수가 있는 생성자. 매개변수가 있는 생성자 사용시 기본생성자는 자동으로 만들어지지 않음, 따라서 명시적으로 기본생성자를 만들어줘야 함
	public Test(int testNo, String testName, Date testdate) {
		this.testNo   = testNo;
		this.testName = testName;
		this.testdate = testdate;
	}
	
	// getter(읽기)/setter(쓰기) 메서드 생성
	public int getTestNo() {
		return testNo;
	}

	public void setTestNo(int testNo) {
		this.testNo = testNo;
	}

	public String getTestName() {
		return testName;
	}

	public void setTestName(String testName) {
		this.testName = testName;
	}

	public Date getTestdate() {
		return testdate;
	}

	public void setTestdate(Date testdate) {
		this.testdate = testdate;
	}

	@Override
	public String toString() {
		return "Test [testNo=" + testNo + ", testName=" + testName + ", testdate=" + testdate + "]";
	}
	
}
