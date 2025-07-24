-- Tạo cơ sở dữ liệu với hỗ trợ Unicode tiếng Việt và biểu tượng cảm xúc
CREATE DATABASE IF NOT EXISTS DailyNewsWebsite CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE DailyNewsWebsite;

-- Bảng danh mục tin tức
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,           -- Khóa chính: mã danh mục
    name VARCHAR(100) NOT NULL,                           -- Tên danh mục (bắt buộc)
    description TEXT                                      -- Mô tả danh mục
);

-- Bảng tin tức
CREATE TABLE IF NOT EXISTS News (
    news_id INT AUTO_INCREMENT PRIMARY KEY,               -- Khóa chính: mã tin
    title VARCHAR(255) NOT NULL,                          -- Tiêu đề bài viết
    summary TEXT,                                         -- Tóm tắt nội dung
    content TEXT,                                         -- Nội dung chi tiết
    image VARCHAR(255),                                   -- Đường dẫn ảnh minh họa
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,        -- Thời gian tạo
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,      -- Thời gian cập nhật
    author VARCHAR(100),                                  -- Tác giả
    category_id INT,                                      -- Mã danh mục (khóa ngoại)
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL -- Ràng buộc danh mục
);

-- Bảng người dùng
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,               -- Khóa chính: mã người dùng
    username VARCHAR(50) UNIQUE NOT NULL,                 -- Tên đăng nhập (duy nhất)
    password VARCHAR(255) NOT NULL,                       -- Mật khẩu (đã mã hóa)
    email VARCHAR(100),                                   -- Email người dùng
    full_name VARCHAR(100),                               -- Họ tên
    role ENUM('admin', 'editor', 'reader') DEFAULT 'reader', -- Vai trò: quản trị, biên tập, độc giả
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP         -- Thời gian tạo tài khoản
);

-- Bảng bình luận
CREATE TABLE IF NOT EXISTS Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,            -- Khóa chính: mã bình luận
    content TEXT NOT NULL,                                -- Nội dung bình luận
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,        -- Thời gian bình luận
    news_id INT,                                          -- Mã bài viết (khóa ngoại)
    user_id INT,                                          -- Mã người dùng (khóa ngoại)
    FOREIGN KEY (news_id) REFERENCES News(news_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Bảng lượt thích
CREATE TABLE IF NOT EXISTS Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,               -- Khóa chính: mã lượt thích
vnews_id INT,                                          -- Mã bài viết (khóa ngoại)
    user_id INT,                                          -- Mã người dùng (khóa ngoại)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,        -- Thời gian thích
    FOREIGN KEY (news_id) REFERENCES News(news_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE (news_id, user_id)                             -- Mỗi người dùng chỉ thích 1 lần 1 bài
);
