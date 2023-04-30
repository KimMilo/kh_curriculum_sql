package kr.co.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.co.main.OracleConnection;
import kr.co.vo.AccountVO;

public class AccountDAO {

	private SqlSession sess = OracleConnection.getSqlSession();
	
	public List<AccountVO> selectReqAccount(){
		List<AccountVO> result = new ArrayList<AccountVO>();
		result = sess.selectList("test.reqAccount"); 

		return result;
	}
	
	public boolean duplicationCheck(String nickname, String email) {
		int result = sess.selectOne("test.dupCheckNickname", nickname);
		if(result == 1) {
			return false;
		}
		result = sess.selectOne("test.dupCheckEmail", email);
		if(result == 1) {
			return false;
		}
		return true;
	}
	

	public boolean insertReqAccount(AccountVO account) throws Throwable {
		try {
			int result = sess.insert("test.addReqAccount", account);
			if(result == 1) {
				sess.commit();
				return true;
			}
		} catch(org.apache.ibatis.exceptions.PersistenceException e) {
			e.printStackTrace();
			throw e.getCause();
		}
		sess.rollback();
		return false;
	}
	
	public boolean updateReqAccount(int id) {
		int result = sess.update("test.updateReqAccount", id);
		if(result == 1) {
			AccountVO data = sess.selectOne("test.reqAccountId", id);
			data.setPassword("samplepassword");
			result = sess.insert("test.insertAccount", data);
			if(result == 1) {
				sess.commit();
				return true;
			}
		}
		sess.rollback();
		return false;
	}
	
	public AccountVO selectAccount(AccountVO data) {
		AccountVO result = sess.selectOne("test.selectAccount", data);
		
		if(result != null) {
			int cnt = sess.update("test.updateLoginDate", result);
			if(cnt == 1) {
				cnt = sess.insert("test.insertLoginAccessLog", result);
				if(cnt == 1) {
					sess.commit();
				}else {
					sess.rollback();
				}
			}else {
				sess.rollback();
			}
		}
		return result;
	}

	public boolean insertLogoutAccessLog(AccountVO user) {
		int result = sess.insert("test.insertLogoutAccessLog", user);
		if(result == 1) {
			sess.commit();
			return true;
		}
		sess.rollback();
		return false;
	}

	public boolean updateAccountPassword(AccountVO data) {
		int result = sess.update("test.updateAccountPassword", data);
		if(result == 1) {
			result = sess.insert("insertLogoutAccessLog", data);
			if(result == 1) {
				sess.commit();
				return true;
			}
		}
		sess.rollback();
		return false;
	}
}
