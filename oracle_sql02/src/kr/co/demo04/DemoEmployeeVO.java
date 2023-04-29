package kr.co.demo04;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

import kr.co.db.connection.OracleConnection;
import kr.co.db.vo.EmployeeVO;

public class DemoEmployeeVO {

	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		OracleConnection oc = new OracleConnection("localhost:1521/XEPDB1", "dev01");
		
		EmployeeVO emp = new EmployeeVO();
		emp.setEmpId(207);
		emp.setFirstName("길동");
		emp.setLastName("홍");
		emp.setEmail("HGILDONG");
		emp.setPhoneNumber("515.123.1234");
		emp.setHireDate(new Date());
		emp.setJobId("IT_PROG");
		emp.setSalary(2800);
		emp.setCommission(0);
		emp.setManagerId(103);
		emp.setDeptId(60);
				
		String query = "INSERT INTO EMPLOYEES VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		// Statement 또는 PreparedStatement 객체 생성
		PreparedStatement pstat = oc.getPrepared(query);
		pstat.setInt(1, emp.getEmpId()); // EMPLOYEE_ID
		pstat.setString(2, emp.getFirstName()); // FIRST_NAME
		pstat.setString(3, emp.getLastName()); // LAST_NAME
		pstat.setString(4, emp.getEmail()); // EMAIL
		pstat.setString(5, emp.getPhoneNumber()); // PHONE_NUMBER
		pstat.setDate(6, emp.getHireDate());
		pstat.setString(7, emp.getJobId());
		pstat.setInt(8, emp.getSalary()); // SALARY
		pstat.setDouble(9, emp.getCommission()); // COMMISSION_PCT
		pstat.setInt(10, emp.getManagerId()); // MANAGER_ID
		pstat.setInt(11, emp.getDeptId()); // DEPARTMENT_ID
		
		int rs = oc.sendInsert();
				
		if(rs >= 1) {
			System.out.println(rs + " 개 행이 반영되었습니다.");
		}else {
			System.out.println("0개 행이 반영되었습니다.(쿼리에 문제가 있는 것 같습니다. 다시 확인하세요.)");
		}
		
		oc.close();
		
	}

}
