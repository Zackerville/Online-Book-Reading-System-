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

INSERT INTO Admins VALUES (1001, 'Admin 1', TO_DATE('2023-12-01', 'YYYY-MM-DD'), 'admin1@example.com', 1500, 5, 2, 10);
INSERT INTO Admins VALUES (1002, 'Admin 2', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'admin2@example.com', 1600, 3, 1, 5);

INSERT INTO Publishers VALUES ('P0001', 'NXB Tre', 'nxbtre@example.com');
INSERT INTO Publishers VALUES ('P0002', 'NXB Kim Dong', 'kimdong@example.com');

INSERT INTO Books VALUES ('B0000001', 'Cuon sach 1', 'Tac Gia A', 300, '/files/book1.pdf', NULL, NULL, NULL, 'P0001');
INSERT INTO Books VALUES ('B0000002', 'Cuon sach 2', 'Tac Gia B', 250, '/files/book2.pdf', 'Bo 1', 1, NULL, 'P0002');

INSERT INTO Categories VALUES ('C0001', 'Khoa hoc');
INSERT INTO Categories VALUES ('C0002', 'Kinh di');

INSERT INTO Notifications VALUES (100000000000000001, 'Chao mung nguoi dung moi', SYSDATE, 'Y', 1001);
INSERT INTO Notifications VALUES (100000000000000002, 'Thong bao cap nhat sach', SYSDATE, 'N', 1002);

INSERT INTO BookStatistics VALUES ('S0001', 'B0000001', 100, 50);
INSERT INTO BookStatistics VALUES ('S0002', 'B0000002', 80, 30);

INSERT INTO ReadHistory VALUES ('U0000001', 'B0000001', SYSDATE, 120, 50);
INSERT INTO ReadHistory VALUES ('U0000002', 'B0000002', SYSDATE, 90, 25);