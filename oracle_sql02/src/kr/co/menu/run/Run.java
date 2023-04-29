package kr.co.menu.run;

import java.sql.SQLException;

import kr.co.menu.manager.EmployeeManager;

public class Run {

	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		EmployeeManager emp = new EmployeeManager();
		
		
		emp.start();
	}

}

