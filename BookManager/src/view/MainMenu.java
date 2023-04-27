package view;

import java.util.ArrayList;
import java.util.Scanner;
import controller.BookController;
import model.vo.Book;

public class MainMenu {
	private Scanner sc = new Scanner(System.in);
	
	private BookController bc = new BookController();
	
public void mainMenu() {
		
		while(true) {
			System.out.println("\n==도서 관리 프로그램==");
			System.out.println("1. 도서 추가");
			System.out.println("2. 도서 전체 조회");
			System.out.println("3. 도서 삭제");
			System.out.println("0. 프로그램 종료");
			
			System.out.println(">> 메뉴 선택 : ");
			int menu = sc.nextInt();
			sc.nextLine();
			
			switch(menu) {
			case 1: insertBook(); break;  					
			case 2: bc.bookList(); break;     				
			case 3: bc.deleteBook(inputBookId()); break;    
			case 0: System.out.println("이용해 주셔서 감사합니다."); return;
			default : System.out.println("메뉴를 잘못입력했습니다. 다시 입력해주세요.");
			}
		}
	}

	public void insertBook() {

		System.out.println("\n== 도서 추가 ==");

		System.out.println("도서번호: ");
		String bookId = sc.nextLine();

		System.out.println("도서명: ");
		String bookName = sc.nextLine();

		System.out.println("출판사: ");
		String publisher = sc.nextLine();

		System.out.println("가격: ");
		String price = sc.nextLine();


		bc.insertBook(bookId, bookName, publisher, price);
	}
	
	public int inputBookId() {
		System.out.println("\n도서번호 입력: ");
		return sc.nextInt();
	}
	
	public void displaySuccess(String message) {
		System.out.println("\n서비스 요청 성공\n" + message);
	}
	
	public void displayFail(String message) {
		System.out.println("\n서비스 요청 실패" + message);
	}
	
	public void displayNoData(String message) {
		System.out.println("\n" + message);
	}
	
	public void displayBookList(ArrayList<Book> list) {
		System.out.println("\n조회된 데이터는 다음과 같습니다.\n");
		
		for(Book b: list) {
			System.out.println(b);
		}
	}
	
	public void displayBook(Book b) {
		System.out.println("\n조회된 데이터는 다음과 같습니다.");
		System.out.println(b);
	}
	
	
}
