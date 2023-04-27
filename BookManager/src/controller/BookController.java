package controller;

import java.util.ArrayList;
import model.dao.BookDao;
import model.vo.Book;
import view.MainMenu;

public class BookController {
	public void insertBook(String bookId, String bookName, String publisher, String price) {
		
		Book b = new Book(Integer.parseInt(bookId), bookName, publisher, Integer.parseInt(price));
			
		int result = new BookDao().insertBook(b);	
	
		if (result > 0) {
			new MainMenu().displaySuccess("\n성공적으로 도서 추가되었습니다.");
		} else {
			new MainMenu().displayFail("\n도서 추가에 실패했습니다.");
		}	
	}
	
	public void bookList() {
		ArrayList<Book> list = new BookDao().bookList();
		
		if (list.isEmpty()) { 	
			new MainMenu().displayNoData("\n조회 결과 데이터가 없습니다.");
		} else {
			new MainMenu().displayBookList(list);
		}	
	}
	
	public void deleteBook(int bookId) {
		int result = new BookDao().deleteBook(bookId);
		
		if (result > 0) {
			new MainMenu().displaySuccess("\n도서정보를 성공적으로 삭제했습니다.");
		} else {
			new MainMenu().displayFail("\n도서정보를 삭제하는데 실패했습니다.");
		}
	}
	
	
}
