package kr.co.menu.controller;

import java.sql.SQLException;
import java.util.ArrayList;

import kr.co.db.vo.JobVO;
import kr.co.menu.dao.JobDAO;
import kr.co.menu.view.JobView;

public class JobController {
	
	private JobView jv = new JobView();
	private JobDAO jobDao;
	
	public JobController () throws ClassNotFoundException, SQLException {		
		this.jobDao = new JobDAO();
		
	}
	
	public void getAll() {
		ArrayList<JobVO> datas = jobDao.selectAll();
		jv.print(datas);
	}
}
