package kr.co.main;
 
import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class OracleConnection {
	
	public static SqlSession getSqlSession() {
		SqlSession sess = null;
		
		try(InputStream is = Resources.getResourceAsStream("mybatis/mybatis-config.xml")) {
			/* 경로는 mybatis-config resources directory경로 */
			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is, "development");
			// (읽은 내용, environment id="development")
			sess = factory.openSession(false);
			// false면 수동commit이고 true면 자동commit임.
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return sess;
		
	}
	
	/*  별도 main 클래스 생성해서 사용하는게 일반적
	public static void main(String[] args) {
		SqlSession session = OracleConnection.getSqlSession();
		String res = session.selectOne("test.hello");
		// "mapper의 namespace.id"
		System.out.println(res);
		session.close();
	}
	*/
}
