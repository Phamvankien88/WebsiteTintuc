-- Tạo CSDL với mã hóa utf8mb4 để hỗ trợ tiếng Việt và emoji
CREATE DATABASE IF NOT EXISTS NewsWebsite
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Sử dụng CSDL vừa tạo
USE NewsWebsite;

-- Bảng người dùng
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,                                -- Khóa chính: Mã người dùng
    name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,    -- Họ và tên
    email VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci UNIQUE, -- Email (không trùng lặp)
    password VARCHAR(255),                                                 -- Mật khẩu (đã mã hóa)
    role ENUM('admin', 'author', 'reader') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'reader', -- Vai trò người dùng
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP                          -- Ngày tạo tài khoản
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng thể loại
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,                            -- Khóa chính: Mã thể loại
    category_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci -- Tên thể loại
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng tác giả
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,                              -- Khóa chính: Mã tác giả
    full_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- Họ tên tác giả
    bio TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,             -- Tiểu sử
    avatar VARCHAR(255)                                                    -- Ảnh đại diện
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng bài viết
CREATE TABLE Articles (
    article_id INT AUTO_INCREMENT PRIMARY KEY,                             -- Khóa chính: Mã bài viết
    title VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,   -- Tiêu đề
    summary TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,         -- Tóm tắt nội dung
    content LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,     -- Nội dung chi tiết
    thumbnail VARCHAR(255),                                                -- Hình ảnh đại diện
    publish_date DATETIME DEFAULT CURRENT_TIMESTAMP,                       -- Ngày đăng
    category_id INT,                                                       -- FK đến bảng thể loại
    author_id INT,                                                         -- FK đến bảng tác giả
    status ENUM('draft', 'published', 'hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'published', -- Trạng thái bài viết
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng bình luận
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,                             -- Khóa chính: Mã bình luận
    content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,         -- Nội dung bình luận
    user_id INT,                                                           -- Người bình luận (FK đến Users)
    article_id INT,                                                        -- Bài viết được bình luận
    comment_date DATETIME DEFAULT CURRENT_TIMESTAMP,                       -- Ngày giờ bình luận
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (article_id) REFERENCES Articles(article_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng từ khóa
CREATE TABLE Keywords (
    keyword_id INT AUTO_INCREMENT PRIMARY KEY,                             -- Khóa chính: Mã từ khóa
    keyword VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci UNIQUE -- Từ khóa (không trùng)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng liên kết bài viết - từ khóa (nhiều-nhiều)
CREATE TABLE Article_Keyword (
    article_id INT,                                                        -- Mã bài viết
    keyword_id INT,                                                        -- Mã từ khóa
    PRIMARY KEY (article_id, keyword_id),                                  -- Khóa chính kết hợp
    FOREIGN KEY (article_id) REFERENCES Articles(article_id),
    FOREIGN KEY (keyword_id) REFERENCES Keywords(keyword_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng liên hệ (form contact)
CREATE TABLE Contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,                             -- Mã liên hệ
    full_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- Họ tên người gửi
    email VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,   -- Email người gửi
    subject VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- Tiêu đề
    message TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,         -- Nội dung liên hệ
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP                             -- Thời gian gửi
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng quảng cáo
CREATE TABLE Advertisements (
    ad_id INT AUTO_INCREMENT PRIMARY KEY,                                  -- Mã quảng cáo
    ad_name VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- Tên quảng cáo
    image_url VARCHAR(255),                                                -- Đường dẫn hình ảnh quảng cáo
    target_url VARCHAR(255),                                               -- URL khi click vào quảng cáo
    position ENUM('top', 'right', 'bottom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'right', -- Vị trí hiển thị
    start_date DATE,                                                       -- Ngày bắt đầu hiển thị
    end_date DATE                                                          -- Ngày kết thúc hiển thị
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
