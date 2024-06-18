'''Implement a Student Library System using OOPs where students can borrow books from the list of books.
Program must be menu driven'''

class Library:
    def __init__(self, listOfBooks):
        self.books = listOfBooks

    def displayAvailableBooks(self):
        print("Books present in the Library are: ")
        for books in self.books:
            print(f"*{books}")
    def borrowBooks(self, bookname):
        if bookname in self.books:
            print(f"You have been issued {bookname}. Please keep it safe and return within 30 days.")
            self.books.remove(bookname)
            return True
        elif bookname == '':
            print("Enter the name of the book you want to borrow.")
        else:
            print('''Sorry this book is either not available or has already been issued to someone else. 
                  Please wait until the book is available.''')
            return False
    def returnBooks(self, bookname):
        if bookname == '':
            print("Please enter valid book name!")
        else:
            self.books.append(bookname)
            print("Thanks for returning this book. Hope you enjoyed reading it. Have a great day ahead!")

class Student:
    def requestBook(self):
        self.book = input("Enter the name of the book you want to request: ")
        return self.book
    def returnBook(self):
        self.book = input("Enter the name of the book you want to return: ")
        return self.book
if __name__ == "__main__":
    n = int(input("Enter the range of list: "))
    centralLibrary = Library([input("Enter list of books: ") for i in range(n)])
    student = Student()
    # centralLibrary.displayAvailableBooks()
    while(True):
        welcomemsg = '''\n====Welcome To Central Library====
        Please choose an option:
        1. List all the books available
        2. Request/Borrow a book
        3. Return a book
        4. Exit the library'''
        print(welcomemsg)
        option = int(input("Choose an option: "))
        if option == 1:
            centralLibrary.displayAvailableBooks()
        elif option == 2:
            centralLibrary.borrowBooks(student.requestBook())
        elif option == 3:
            centralLibrary.returnBooks(student.returnBook())
        elif option == 4:
            print("Thank You for visiting Central Library. Have a great day ahead!")
            exit()
        else:
            print("Invalid choice!")