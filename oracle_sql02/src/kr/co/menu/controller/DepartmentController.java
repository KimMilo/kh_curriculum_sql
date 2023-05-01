package kr.co.menu.controller;
 
import java.sql.SQLException;
import java.util.ArrayList;

import kr.co.db.vo.DepartmentVO;
import kr.co.menu.dao.DepartmentDAO;
import kr.co.menu.view.DepartmentView;

public class DepartmentController {
	
	private DepartmentView dv = new DepartmentView();
	private DepartmentDAO deptDao;
	
	public DepartmentController() throws ClassNotFoundException, SQLException {
		this.deptDao = new DepartmentDAO();
	}

	public void getAll() {
		ArrayList<DepartmentVO> datas = deptDao.selectAll();
		dv.print(datas);
	}

}
