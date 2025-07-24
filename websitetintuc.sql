-- Tạo cơ sở dữ liệu hỗ trợ tiếng Việt và emoji
CREATE DATABASE IF NOT EXISTS DailyNewsWebsite 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Sử dụng cơ sở dữ liệu vừa tạo
USE DailyNewsWebsite;

-- Bảng danh mục tin tức (Category)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY, -- Mã danh mục (tự tăng)
    name VARCHAR(100) NOT NULL,                 -- Tên danh mục
    description TEXT                            -- Mô tả danh mục
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng tác giả (Author)
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Mã tác giả (tự tăng)
    name VARCHAR(100) NOT NULL,                 -- Tên tác giả
    email VARCHAR(100) UNIQUE,                  -- Email (duy nhất)
    bio TEXT,                                   -- Tiểu sử
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Ngày tạo tài khoản
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng bài viết (News)
CREATE TABLE news (
    news_id INT AUTO_INCREMENT PRIMARY KEY,     -- Mã bài viết
    title VARCHAR(255) NOT NULL,                -- Tiêu đề
    summary TEXT,                               -- Tóm tắt
    content TEXT,                               -- Nội dung
    image VARCHAR(255),                         -- Ảnh đại diện
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày tạo
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- Ngày cập nhật
    author_id INT,                              -- Mã tác giả
    category_id INT,                            -- Mã danh mục
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE SET NULL, -- Xóa tác giả -> đặt NULL
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL -- Xóa danh mục -> đặt NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng từ khóa (Keywords)
CREATE TABLE keywords (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Mã từ khóa
    keyword VARCHAR(100) NOT NULL UNIQUE,       -- Từ khóa (duy nhất)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Ngày tạo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng liên kết bài viết - từ khóa (Nhiều - Nhiều)
CREATE TABLE article_keyword (
    article_id INT,                             -- Mã bài viết
    keyword_id INT,                             -- Mã từ khóa
    PRIMARY KEY (article_id, keyword_id),       -- Khóa chính kết hợp
    FOREIGN KEY (article_id) REFERENCES news(news_id) ON DELETE CASCADE,   -- Xóa bài viết -> xóa liên kết
    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE     -- Xóa từ khóa -> xóa liên kết
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng người dùng (Users)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,     -- Mã người dùng
    username VARCHAR(50) UNIQUE NOT NULL,       -- Tên đăng nhập (duy nhất)
    password VARCHAR(255) NOT NULL,             -- Mật khẩu đã mã hóa (hash)
    email VARCHAR(100),                         -- Email người dùng
    full_name VARCHAR(100),                     -- Họ tên đầy đủ
    role ENUM('admin', 'editor', 'reader') DEFAULT 'reader', -- Vai trò
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Ngày đăng ký
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng bình luận (Comments)
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,  -- Mã bình luận
    content TEXT NOT NULL,                      -- Nội dung bình luận
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày bình luận
    news_id INT,                                -- Mã bài viết
    user_id INT,                                -- Mã người dùng
    FOREIGN KEY (news_id) REFERENCES news(news_id) ON DELETE CASCADE,  -- Xóa bài viết -> xóa bình luận
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL -- Xóa người dùng -> đặt NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng lượt thích (Likes)
CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,     -- Mã lượt thích
    news_id INT,                                -- Mã bài viết
    user_id INT,                                -- Mã người dùng
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày thích
    FOREIGN KEY (news_id) REFERENCES news(news_id) ON DELETE CASCADE,  -- Xóa bài viết -> xóa lượt thích
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE, -- Xóa người dùng -> xóa lượt thích
    UNIQUE (news_id, user_id)                   -- Mỗi người chỉ được thích 1 bài viết 1 lần
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng liên hệ người dùng (Contact Form)
CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Mã liên hệ
    name VARCHAR(100) NOT NULL,                 -- Tên người gửi
    email VARCHAR(100) NOT NULL,                -- Email người gửi
    subject VARCHAR(255),                       -- Tiêu đề liên hệ
    message TEXT NOT NULL,                      -- Nội dung liên hệ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Ngày gửi
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng quảng cáo (Advertisements)
CREATE TABLE advertisements (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Mã quảng cáo
    title VARCHAR(255) NOT NULL,                -- Tiêu đề quảng cáo
    image VARCHAR(255),                         -- Hình ảnh quảng cáo
    link VARCHAR(255),                          -- Liên kết (URL)
    start_date DATE,                            -- Ngày bắt đầu hiển thị
    end_date DATE,                              -- Ngày kết thúc
    status ENUM('active', 'inactive') DEFAULT 'active', -- Trạng thái
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Ngày tạo quảng cáo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
