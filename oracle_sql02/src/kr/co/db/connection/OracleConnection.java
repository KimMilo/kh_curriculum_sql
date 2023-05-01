package kr.co.db.connection;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class OracleConnection {
	/* 연결용 클래스 만들기 */
	
	private final static String ORACLE_DRIVER = "oracle.jdbc.driver.OracleDriver";
	private final static String JDBC_URL = "jdbc:oracle:thin:@";
	
	private Connection conn;
	private PreparedStatement pstat;
	private ResultSet rs;
	
	/**
	 * 계정명과 패스워드가 동일한 경우 사용할 수 있다.
	 * 
	 * @param url
	 * @param username : 계정명이지만 패스워드에도 동일하게 사용한다. 
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public OracleConnection(String url, String username) 
											throws ClassNotFoundException, SQLException {
		this(url, username, username);
	}
	
	public OracleConnection(String url, String username, String password) 
											throws ClassNotFoundException, SQLException {
		Class.forName(ORACLE_DRIVER);
		
		this.conn = DriverManager.getConnection(JDBC_URL + url, username, password);
	}
	
	public PreparedStatement getPrepared(String query) throws SQLException {
		this.pstat = this.conn.prepareStatement(query);
		return this.pstat;
	}
	
	public ResultSet sendSelect() throws SQLException {
		this.rs = this.pstat.executeQuery();
		return this.rs;
		//close 메서드에서 rs도 닫게 하려고
		// return this.pstat.executeQuery();
		// --> this.rs = this.pstat.executeQuery(); return this.rs; 바꾸고 rs필드 설정
		// 
	}
	
	public int sendInsert() throws SQLException {
		return this.pstat.executeUpdate();
	}
	
	public int sendUpdate() throws SQLException {
		return this.pstat.executeUpdate();
	}
	
	public int sendDelete() throws SQLException {
		return this.pstat.executeUpdate();
	}
	
	public void close() throws SQLException {
		if(this.rs != null) {
			this.rs.close();
		}
		
		if(this.pstat != null) {
			this.pstat.close();
		}
		
		if(this.conn != null) {
			this.conn.close();
		}
	}
}
