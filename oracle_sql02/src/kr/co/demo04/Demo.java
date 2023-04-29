package kr.co.demo04;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
 


public class Demo {
	
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		
		// Oracle Driver 등록
		Class.forName("oracle.jdbc.driver.OracleDriver"); // throws ClassNotFoundException
		
		// Database Connection 생성
		String url = "jdbc:oracle:thin:@localhost:1521/XEPDB1";
			
		String username = "dev01";
		String password = "dev01";
		
		Connection conn = DriverManager.getConnection(url, username, password);
		
		// Query 작성 
		int empId = 207;
		String jobId = "IT_PROG";
		
		Date hireDate = new Date(new java.util.Date().getTime());
				
		String query = "INSERT INTO EMPLOYEES VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		// Statement 또는 PreparedStatement 객체 생성
		PreparedStatement pstat = conn.prepareStatement(query);
			
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
		
		// Query 전송 후 결과 저장
		int rs = pstat.executeUpdate();
					
		if(rs >= 1) {
			System.out.println(rs + " 개 행이 반영되었습니다.");
		}else {
			System.out.println("0개 행이 반영되었습니다.(쿼리에 문제가 있는 것 같습니다. 다시 확인하세요.)");
		}
		
		pstat.close();
		conn.close();	
		
	}
	
}

