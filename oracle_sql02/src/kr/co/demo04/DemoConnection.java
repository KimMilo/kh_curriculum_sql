package kr.co.demo04;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import kr.co.db.connection.OracleConnection;

public class DemoConnection {
	/*
	 * OracleConnection 클래스 활용하기
	 */
	
	
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		OracleConnection oc = new OracleConnection("localhost:1521/XEPDB1", "dev01");
				
		int empId = 207;
		String jobId = "IT_PROG";
		Date hireDate = new Date(new java.util.Date().getTime());
	
				
		String query = "INSERT INTO EMPLOYEES VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		// Statement 또는 PreparedStatement 객체 생성
		PreparedStatement pstat = oc.getPrepared(query);
		pstat.setInt(1, empId); // EMPLOYEE_ID
		pstat.setString(2, "길동"); // FIRST_NAME
		pstat.setString(3, "홍"); // LAST_NAME
		pstat.setString(4, "HGILDONG"); // EMAIL
		pstat.setString(5, "515.123.1234"); // PHONE_NUMBER
		pstat.setDate(6, hireDate);
		pstat.setString(7, jobId);
		pstat.setInt(8, 2800); // SALARY
		pstat.setDouble(9, 0); // COMMISSION_PCT
		pstat.setInt(10, 103); // MANAGER_ID
		pstat.setInt(11, 60); // DEPARTMENT_ID
		
		int rs = oc.sendInsert();
				
		if(rs >= 1) {
			System.out.println(rs + " 개 행이 반영되었습니다.");
		}else {
			System.out.println("0개 행이 반영되었습니다.(쿼리에 문제가 있는 것 같습니다. 다시 확인하세요.)");
		}
		
		oc.close();
		
	}
	
}
