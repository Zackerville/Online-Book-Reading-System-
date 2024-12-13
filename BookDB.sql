CREATE TABLE Users 
(
    user_id VARCHAR2(8) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    join_date DATE DEFAULT SYSDATE,
    total_read_days NUMBER CHECK (total_read_days >= 0),
    account VARCHAR2(50),
    password VARCHAR2(50),
    purpose VARCHAR2(100),
    CONSTRAINT chk_user_type CHECK (
        (account IS NOT NULL AND password IS NOT NULL AND purpose IS NULL) OR 
        (account IS NULL AND password IS NULL AND purpose IS NOT NULL)
    )
);

CREATE TABLE Admins 
(
    admin_id NUMBER(4) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    start_date DATE DEFAULT SYSDATE,
    email VARCHAR2(100) UNIQUE NOT NULL,
    base_salary NUMBER CHECK (base_salary > 0),
    book_count NUMBER DEFAULT 0,
    category_count NUMBER DEFAULT 0,
    notification_count NUMBER DEFAULT 0
);

CREATE TABLE Books 
(
    book_id VARCHAR2(8) PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    author VARCHAR2(100) NOT NULL,
    page_count NUMBER CHECK (page_count > 0),
    file_path VARCHAR2(200),
    series_name VARCHAR2(200),
    series_order NUMBER,
    publication_type VARCHAR2(50),
    publisher_id VARCHAR2(5) NOT NULL,
    CONSTRAINT fk_publisher FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

CREATE TABLE Categories 
(
    category_id VARCHAR2(5) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL
);

CREATE TABLE Publishers 
(
    publisher_id VARCHAR2(5) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE FavoriteLists 
(
    favorite_id VARCHAR2(8) PRIMARY KEY,
    user_id VARCHAR2(8) NOT NULL,
    CONSTRAINT fk_user_favorite FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE FavoriteListBooks 
(
    favorite_id VARCHAR2(8),
    book_id VARCHAR2(8),
    PRIMARY KEY (favorite_id, book_id),
    CONSTRAINT fk_favorite_list FOREIGN KEY (favorite_id) REFERENCES FavoriteLists(favorite_id),
    CONSTRAINT fk_book_favorite FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE BookCategories 
(
    book_id VARCHAR2(8),
    category_id VARCHAR2(5),
    PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES Books(book_id),
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Notifications 
(
    notification_id NUMBER(18) PRIMARY KEY,
    content VARCHAR2(1000) NOT NULL,
    send_date DATE DEFAULT SYSDATE,
    is_limited CHAR(1) CHECK (is_limited IN ('Y', 'N')),
    admin_id NUMBER(4) NOT NULL,
    CONSTRAINT fk_admin_notification FOREIGN KEY (admin_id) REFERENCES Admins(admin_id)
);

CREATE TABLE BookStatistics 
(
    stats_id VARCHAR2(10) PRIMARY KEY,
    book_id VARCHAR2(8) UNIQUE NOT NULL,
    total_readers NUMBER DEFAULT 0,
    total_favorites NUMBER DEFAULT 0,
    CONSTRAINT fk_book_statistics FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE ReadHistory 
(
    user_id VARCHAR2(8),
    book_id VARCHAR2(8),
    read_date DATE DEFAULT SYSDATE,
    total_time_spent NUMBER CHECK (total_time_spent >= 0),
    last_read_page NUMBER CHECK (last_read_page >= 0),
    PRIMARY KEY (user_id, book_id),
    CONSTRAINT fk_read_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_read_book FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE AdminManages 
(
    admin_id NUMBER(4),
    book_id VARCHAR2(8),
    PRIMARY KEY (admin_id, book_id),
    CONSTRAINT fk_admin_manages FOREIGN KEY (admin_id) REFERENCES Admins(admin_id),
    CONSTRAINT fk_book_managed FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE AdminCategories 
(
    admin_id NUMBER(4),
    category_id VARCHAR2(5),
    PRIMARY KEY (admin_id, category_id),
    CONSTRAINT fk_admin_category FOREIGN KEY (admin_id) REFERENCES Admins(admin_id),
    CONSTRAINT fk_category_managed FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);



INSERT INTO Users VALUES ('U0000001', 'Nguyen Van A', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 10, 'nguyena', '123456', NULL);
INSERT INTO Users VALUES ('U0000002', 'Le Thi B', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 5, 'lethib', 'abcdef', NULL);
INSERT INTO Users VALUES ('U0000003', 'Tran Van C', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 2, NULL, NULL, 'Reading Books');
INSERT INTO Users VALUES ('U0000004', 'Tran Quang Thien', TO_DATE('2024-05-23', 'YYYY-MM-DD'), 2, NULL, NULL, 'Buy Books');
INSERT INTO Users VALUES ('U0000005', 'Pham Minh D', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 8, 'phamminhd', 'password123', NULL);
INSERT INTO Users VALUES ('U0000006', 'Vo Thi E', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 4, 'vothie', 'password456', NULL);
INSERT INTO Users VALUES ('U0000007', 'Hoang Van F', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 6, NULL, NULL, 'Borrow Books');
INSERT INTO Users VALUES ('U0000008', 'Le Quang G', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 10, 'lequangg', 'securepass', NULL);
INSERT INTO Users VALUES ('U0000009', 'Nguyen Thi H', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 3, NULL, NULL, 'Study Materials');
INSERT INTO Users VALUES ('U0000010', 'Tran Van I', TO_DATE('2024-04-18', 'YYYY-MM-DD'), 7, 'tranvani', 'mypassword', NULL);
INSERT INTO Users VALUES ('U0000011', 'Nguyen Anh J', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 2, NULL, NULL, 'Explore Books');
INSERT INTO Users VALUES ('U0000012', 'Pham Thi K', TO_DATE('2024-05-05', 'YYYY-MM-DD'), 9, 'phamthik', 'abc12345', NULL);


INSERT INTO Admins VALUES (1001, 'Admin 1', TO_DATE('2023-12-01', 'YYYY-MM-DD'), 'admin1@example.com', 1500, 5, 2, 10);
INSERT INTO Admins VALUES (1002, 'Admin 2', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'admin2@example.com', 1600, 3, 1, 5);
INSERT INTO Admins VALUES (1003, 'Admin 3', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'admin3@example.com', 1700, 7, 3, 12);
INSERT INTO Admins VALUES (1004, 'Admin 4', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'admin4@example.com', 1800, 10, 4, 20);
INSERT INTO Admins VALUES (1005, 'Admin 5', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'admin5@example.com', 2000, 15, 6, 25);


INSERT INTO Publishers VALUES ('P0001', 'NXB Tre', 'nxbtre@example.com');
INSERT INTO Publishers VALUES ('P0002', 'NXB Kim Dong', 'kimdong@example.com');
INSERT INTO Publishers VALUES ('P0003', 'NXB Giao Duc', 'giaoduc@example.com');
INSERT INTO Publishers VALUES ('P0004', 'NXB Thanh Nien', 'thanhnien@example.com');
INSERT INTO Publishers VALUES ('P0005', 'NXB Y Hoc', 'yhoc@example.com');
INSERT INTO Publishers VALUES ('P0006', 'NXB Cong Nghe', 'congnghe@example.com');
INSERT INTO Publishers VALUES ('P0007', 'NXB Nong Nghiep', 'nongnghiep@example.com');
INSERT INTO Publishers VALUES ('P0008', 'NXB Tam Ly', 'tamly@example.com');
INSERT INTO Publishers VALUES ('P0009', 'NXB Giao Duc', 'giaoduc@example.com');



INSERT INTO Books VALUES ('B0000001', 'Cuon sach 1', 'Tac Gia A', 300, '/files/book1.pdf', NULL, NULL, NULL, 'P0001');
INSERT INTO Books VALUES ('B0000002', 'Cuon sach 2', 'Tac Gia B', 250, '/files/book2.pdf', 'Bo 1', 1, NULL, 'P0002');
INSERT INTO Books VALUES ('B0000003', 'Cuon sach 3', 'Tac Gia C', 320, '/files/book3.pdf', 'Bo 2', 1, NULL, 'P0003');
INSERT INTO Books VALUES ('B0000004', 'Cuon sach 4', 'Tac Gia D', 200, '/files/book4.pdf', 'Bo 2', 2, NULL, 'P0004');
INSERT INTO Books VALUES ('B0000005', 'Cuon sach 5', 'Tac Gia E', 280, '/files/book5.pdf', NULL, NULL, NULL, 'P0001');
INSERT INTO Books VALUES ('B0000006', 'Cuon sach 6', 'Tac Gia F', 310, '/files/book6.pdf', NULL, NULL, 'Ebook', 'P0002');
INSERT INTO Books VALUES ('B0000007', 'Cuon sach 7', 'Tac Gia G', 250, '/files/book7.pdf', NULL, NULL, 'Ebook', 'P0003');
INSERT INTO Books VALUES ('B0000008', 'Cuon sach 8', 'Tac Gia H', 300, '/files/book8.pdf', NULL, NULL, NULL, 'P0001');
INSERT INTO Books VALUES ('B0000009', 'Cuon sach 9', 'Tac Gia I', 280, '/files/book9.pdf', 'Bo 3', 1, NULL, 'P0002');
INSERT INTO Books VALUES ('B0000010', 'Cuon sach 10', 'Tac Gia J', 350, '/files/book10.pdf', NULL, NULL, 'Ebook', 'P0003');
INSERT INTO Books VALUES ('B0000011', 'Cuon sach 11', 'Tac Gia K', 400, '/files/book11.pdf', NULL, NULL, NULL, 'P0004');
INSERT INTO Books VALUES ('B0000012', 'Cuon sach 12', 'Tac Gia L', 220, '/files/book12.pdf', NULL, NULL, 'Ebook', 'P0001');



INSERT INTO Categories VALUES ('C0001', 'Khoa hoc');
INSERT INTO Categories VALUES ('C0002', 'Kinh di');
INSERT INTO Categories VALUES ('C0003', 'Van hoc');
INSERT INTO Categories VALUES ('C0004', 'Lich su');
INSERT INTO Categories VALUES ('C0005', 'Thieu nhi');
INSERT INTO Categories VALUES ('C0006', 'Cong nghe');
INSERT INTO Categories VALUES ('C0007', 'Tam ly');
INSERT INTO Categories VALUES ('C0008', 'Giao duc');
INSERT INTO Categories VALUES ('C0009', 'Trinh tham');
INSERT INTO Categories VALUES ('C0010', 'Y hoc');



INSERT INTO Notifications VALUES (100000000000000001, 'Chao mung nguoi dung moi', SYSDATE, 'Y', 1001);
INSERT INTO Notifications VALUES (100000000000000002, 'Thong bao cap nhat sach', SYSDATE, 'N', 1002);
INSERT INTO Notifications VALUES (100000000000000003, 'Thong bao mo khoa hoc moi', SYSDATE, 'Y', 1003);
INSERT INTO Notifications VALUES (100000000000000004, 'Cap nhat he thong doc sach', SYSDATE, 'N', 1004);
INSERT INTO Notifications VALUES (100000000000000005, 'Thong bao giam gia thang 6', SYSDATE, 'N', 1003);
INSERT INTO Notifications VALUES (100000000000000006, 'Cap nhat danh muc sach moi', SYSDATE, 'Y', 1004);
INSERT INTO Notifications VALUES (100000000000000007, 'Su kien ra mat tac gia moi', SYSDATE, 'N', 1005);
INSERT INTO Notifications VALUES (100000000000000008, 'Thong bao nghi le', SYSDATE, 'Y', 1001);
INSERT INTO Notifications VALUES (100000000000000009, 'Su kien thang doc sach', SYSDATE, 'Y', 1002);



INSERT INTO BookStatistics VALUES ('S0001', 'B0000001', 100, 50);
INSERT INTO BookStatistics VALUES ('S0002', 'B0000002', 80, 30);
INSERT INTO BookStatistics VALUES ('S0006', 'B0000008', 120, 60);
INSERT INTO BookStatistics VALUES ('S0007', 'B0000009', 150, 80);
INSERT INTO BookStatistics VALUES ('S0008', 'B0000010', 200, 100);
INSERT INTO BookStatistics VALUES ('S0009', 'B0000011', 180, 90);
INSERT INTO BookStatistics VALUES ('S0010', 'B0000012', 250, 120);


INSERT INTO ReadHistory VALUES ('U0000001', 'B0000001', SYSDATE, 120, 50);
INSERT INTO ReadHistory VALUES ('U0000002', 'B0000002', SYSDATE, 90, 25);
INSERT INTO ReadHistory VALUES ('U0000005', 'B0000003', SYSDATE, 200, 100);
INSERT INTO ReadHistory VALUES ('U0000006', 'B0000004', SYSDATE, 150, 80);
INSERT INTO ReadHistory VALUES ('U0000007', 'B0000005', SYSDATE, 180, 90);
INSERT INTO ReadHistory VALUES ('U0000008', 'B0000006', SYSDATE, 220, 110);
INSERT INTO ReadHistory VALUES ('U0000009', 'B0000008', SYSDATE, 150, 75);
INSERT INTO ReadHistory VALUES ('U0000010', 'B0000009', SYSDATE, 200, 120);
INSERT INTO ReadHistory VALUES ('U0000011', 'B0000010', SYSDATE, 180, 90);
INSERT INTO ReadHistory VALUES ('U0000012', 'B0000011', SYSDATE, 240, 160);
INSERT INTO ReadHistory VALUES ('U0000005', 'B0000012', SYSDATE, 300, 150);


-- Trigger: Prevent inserting into ReadHistory if User account is NULL
CREATE OR REPLACE TRIGGER prevent_null_account
BEFORE INSERT ON ReadHistory
FOR EACH ROW
DECLARE
    user_account_status VARCHAR2(50);
BEGIN
    SELECT account INTO user_account_status
    FROM Users
    WHERE user_id = :NEW.user_id;

    IF user_account_status IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot insert into history: User account is NULL');
    END IF;
END;
/

-- Procedure: Get details of a book by its ID
CREATE OR REPLACE PROCEDURE GetBookDetailsByID(book_id_input IN VARCHAR2)
IS
    book_id_out Books.book_id%TYPE;
    title_out Books.title%TYPE;
    author_out Books.author%TYPE;
    page_count_out Books.page_count%TYPE;
    file_path_out Books.file_path%TYPE;
    series_name_out Books.series_name%TYPE;
    series_order_out Books.series_order%TYPE;
    publication_type_out Books.publication_type%TYPE;
    publisher_name_out Publishers.name%TYPE;
    publisher_email_out Publishers.email%TYPE;
    categories_out VARCHAR2(4000);
BEGIN
    SELECT 
        b.book_id, b.title, b.author, b.page_count, b.file_path, b.series_name, b.series_order, 
        b.publication_type, p.name, p.email,
        LISTAGG(c.name, ', ') WITHIN GROUP (ORDER BY c.name)
    INTO 
        book_id_out, title_out, author_out, page_count_out, file_path_out, series_name_out, 
        series_order_out, publication_type_out, publisher_name_out, publisher_email_out, categories_out
    FROM 
        Books b
    LEFT JOIN 
        Publishers p ON b.publisher_id = p.publisher_id
    LEFT JOIN 
        BookCategories bc ON b.book_id = bc.book_id
    LEFT JOIN 
        Categories c ON bc.category_id = c.category_id
    WHERE 
        b.book_id = book_id_input
    GROUP BY 
        b.book_id, b.title, b.author, b.page_count, b.file_path, b.series_name, b.series_order, 
        b.publication_type, p.name, p.email;
    
    -- Optional: Output the result for debugging or returning in a cursor
    DBMS_OUTPUT.PUT_LINE('Book Details Retrieved Successfully');
END;
/

-- Procedure: Get a user's book reading history
CREATE OR REPLACE PROCEDURE GetUserBookHistory(user_id_input IN VARCHAR2)
IS
    book_id_out Books.book_id%TYPE;
    title_out Books.title%TYPE;
    author_out Books.author%TYPE;
    last_read_date_out ReadHistory.read_date%TYPE;
    total_time_spent_out ReadHistory.total_time_spent%TYPE;
    last_read_page_out ReadHistory.last_read_page%TYPE;
BEGIN
    SELECT 
        b.book_id, b.title, b.author, rh.read_date, rh.total_time_spent, rh.last_read_page
    INTO 
        book_id_out, title_out, author_out, last_read_date_out, total_time_spent_out, last_read_page_out
    FROM 
        Books b
    LEFT JOIN 
        ReadHistory rh ON b.book_id = rh.book_id
    WHERE 
        rh.user_id = user_id_input;
    
    -- Optional: Output the result for debugging or returning in a cursor
    DBMS_OUTPUT.PUT_LINE('User Book History Retrieved Successfully');
END;
/




