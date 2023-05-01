package kr.co.demo03;
 
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
			
		int empId = 100;
		String jobId = "IT_PROG";
		 
		String query = "SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE FROM EMPLOYEES";
		query += " WHERE EMPLOYEE_ID = ?";
		
		query += " OR JOB_ID = ?";
	
		PreparedStatement pstat = conn.prepareStatement(query);
		
		pstat.setInt(1, empId);
		pstat.setString(2, jobId);
		
		// Query 전송 후 결과 저장
		ResultSet rs = pstat.executeQuery();
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy년 MM월 dd일");
		
		System.out.println("| ID  |    FIRST_NAME   |    LAST_NAME    | HIRE_DATE      |");
		System.out.println("+-----+-----------------+-----------------+----------------+");
		while(rs.next()) {
			int id = rs.getInt("EMPLOYEE_ID");
			String fName = rs.getString("FIRST_NAME");
			String lName = rs.getString("LAST_NAME");
			Date hireDate = rs.getDate("HIRE_DATE");
			
			System.out.printf("| %d | %15s | %15s | %s |\n", id, fName, lName, df.format(hireDate));
		}

		rs.close();
		pstat.close();
		conn.close();	
		
	}
	
}

