package kr.co.menu.view;

import java.util.ArrayList;

import kr.co.db.vo.EmployeeVO;

public class EmployeeView {
	/*
	 * MVC패턴에서 View : 화면 출력 역할(콘솔, 웹페이지)
	 */
	
	public void print(ArrayList<EmployeeVO> datas) {
		for(EmployeeVO emp: datas) {
			this.print(emp);
		}
	}

	public void print(EmployeeVO data) {
		if(data == null) {
			System.out.println("조회 결과 조건에 해당하는 데이터가 없습니다.");
		}else {
			System.out.println(data);
		}
	}
}
