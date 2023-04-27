package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.vo.Book;

public class BookDao {

	public int insertBook(Book b) {
		int result = 0;

		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql = "INSERT INTO BOOK VALUES(?,?,?,?)";

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");

			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "JDBC", "JDBC");
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, b.getBookId());
			pstmt.setString(2, b.getBookName());
			pstmt.setString(3, b.getPublisher());
			pstmt.setInt(4, b.getPrice());

			result = pstmt.executeUpdate();

			if (result > 0) {
				conn.commit();
			} else {
				conn.rollback();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	public ArrayList<Book> bookList() {
		ArrayList<Book> list = new ArrayList<>();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;

		String sql = "SELECT * FROM BOOK";

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "JDBC", "JDBC");
			pstmt = conn.prepareStatement(sql);
			rset = pstmt.executeQuery();

			while (rset.next()) {
				Book b = new Book();

				b.setBookId(rset.getInt("bookid"));
				b.setBookName(rset.getString("bookname"));
				b.setPublisher(rset.getString("publisher"));
				b.setPrice(rset.getInt("price"));

				list.add(b);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rset.close();
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return list;
	}
	
	public int deleteBook(int bookId)  {
		int result = 0;
		
		Connection 		   conn = null;
		PreparedStatement  pstmt = null;
		
		String sql = "DELETE FROM BOOK WHERE BOOKID = ? ";
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, bookId);
			result = pstmt.executeUpdate();
			
			if(result > 0) { 
				conn.commit();
			}else {
				conn.rollback();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
				try {
					pstmt.close();
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return result;
	}
	
	
}
