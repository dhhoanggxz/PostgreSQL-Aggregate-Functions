# THỰC HÀNH PostgreSQL

**Nội dung:**  
**Truy xuất dữ liệu với:**

- **Các hàm tổng hợp: COUNT, MIN, MAX, AVG, SUM**

- ## **GROUP BY clause**

- **HAVING clause**  
- **JOIN**

---

### 1. **ROLE**  
   1. Tạo ROLE: CREATE ROLE admin WITH LOGIN PASSWORD ‘123’;  
   2. Hiển thị các ROLE hiện có: \\du  
   3. Tạo một database tên hr: CREATE DATABASE hrdb WITH OWNER admin;   
   4. Kết nối vào database hr: \\c hrdb;   
   5. Chuyển sang role admin: SET ROLE TO admin;  
   6. Kiểm tra role hiện tại: SELECT current\_role;  
### 2. **SCHEMA**  
   1. Kiểm tra schema hiện tại: SHOW SEARCH\_PATH  
   2. Xem các schema hiện có: \\dn  
   3. Tạo một schema được cấp quyền cho admin : CREATE SCHEMA schema\_name AUTHORIZATION admin;  
   4. Set schema ‘example’ là schema mặc định: SET SEARCH\_PATH \= schema\_name;  
   5. Thay đổi schema của database: 

   ALTER DATABASE db\_name SET search\_path TO schema\_name;

   

\\i forum\_db.sql → chạy file.sql trong command line

![image](https://github.com/user-attachments/assets/08bb6410-7383-48e7-a9d2-86d57e0240eb)

Editable: T, F \-\> boolean

### 3. **LIMIT và OFFSET clause**

SELECT \* FROM categories ORDER  BY id LIMIT 2;  
SELECT \* FROM categories  ORDER BY id OFFSET 1 LIMIT 2;

LIMIT còn được dùng trong việc tạo 1 bảng có cấu trúc với 1 bảng đã có  
CREATE TABLE new\_categories AS select \* from categories LIMIT 0;

### 4. **Hàm tổng hợp:** COUNT(), AVG(), MIN(), MAX(), SUM()

   # 1.1 Hiển thị tổng likes của tác giả có id \=1.

   # SELECT SUM(likes) FROM posts WHERE author=1;

   1.2 Có tất cả bao nhiêu dòng dữ liệu trong bảng posts?  
   1.3 Giá trị likes lớn nhất và nhỏ nhất?

### 5. **GROUP BY, HAVING**  
   SELECT column1, aggregate\_function (column2)   
   FROM table\_name   
   WHERE condition  
   GROUP BY column1   
   HAVING condition;

   SELECT DISTINCT category FROM posts;

SELECT category FROM posts GROUP BY category;  
			 	 	 		  
	Ở bảng posts, mỗi category có bao nhiêu dòng dữ liệu?  
SELECT category, COUNT(\*) AS cat\_count FROM posts GROUP BY category;  
SELECT category, COUNT(\*) AS cat\_count FROM posts GROUP BY 1;  
![image](https://github.com/user-attachments/assets/4af8d85b-be47-4747-90a4-9d6599cfeccd)

SELECT category, COUNT(\*) AS cat\_count FROM posts   
GROUP BY 1  
HAVING COUNT(\*) \> 1;  
![image](https://github.com/user-attachments/assets/104520cd-81d9-4dc8-b4d8-c4ab2baea01d)

### 6. **Subqueries**  
   SELECT id FROM users WHERE email=’enrico@pgtraiing.com ’; \-\> id \= 2  
   SELECT title FROM posts WHERE author=2;  
   \=\> Kết hợp 2 câu SELECT trên thành một câu query:  
   SELECT title FROM posts  
   WHERE author \= ( SELECT id FROM users 

   WHERE email=’enrico@pgtraiing.com ’) ;

   ![image](https://github.com/user-attachments/assets/c5bea366-537a-4f33-ab27-03b9b7a25483)

    **Subqueries và điều kiện IN/NOT IN**  
- **Toán tử IN/ NOT IN**  
- Tìm tất cả dữ liệu trong bảng categories có id \= 1 hoặc id \= 2

  SELECT \* FROM categories WHERE id \= 1 OR id \= 2;

  SELECT \* FROM categories WHERE id IN (1,2);

- NOT IN: ngược lại của IN

  SELECT \* FROM categories WHERE id NOT IN (1,2); 	

- Hiển thị tất cả các post thuộc về catagory ‘Database'  
  SELECT \* FROM posts WHERE category IN 

  (SELECT id FROM categories WHERE title  LIKE '%Database%');  
- Tìm tất cả các post mà catagory không phải là ‘Database'


  **Subqueries và điều kiện EXIST/NOT EXIST**

  SELECT select\_list FROm table1 WHERE EXISTS 

  ( SELECT 1 FROM table2 WHERE condition);

- **Toán tử EXIST/ NOT EXIST:** is a boolean operator that checks the existence of rows in a [subquery](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-subquery/).  
- Hiển thị tất cả các post thuộc về catagory ‘Database'  
  SELECT \* FROM posts WHERE EXISTS 

  (SELECT 1 FROM categories WHERE title \='Database' AND posts.category=id);

    
### 7. **JOINS**

![image](https://github.com/user-attachments/assets/d974587e-663f-480c-aada-4cfdbf0adee9)
 
								Nguồn:[https://www.postgresqltutorial.com/](https://www.postgresqltutorial.com/)  
		 	  
Sử dụng JOIN viết lại các câu truy vấn sau:

1. SELECT c.id, c.title, p.id, p.category, p.title FROM categories c, posts p;

   SELECT c.id, c.title, p.id, p.category, p.title FROM categories c CROSS JOIN posts p;

2. SELECT c.id, c.title, p.id, p.category, p.title FROM categories c, posts p 

   WHERE c.id=p.category;

   SELECT c.id, c.title, p.id, p.category, p.title FROM categories c 

   INNER JOIN posts p ON  c.id=p.category;

3. SELECT c.id,c.title,p.id,p.category,p.title FROM categories c,posts p 

   WHERE c.id=p.category AND c.title='Database’;

   SELECT c.id,c.title,p.id,p.category,p.title 

   FROM categories c

   INNER JOIN posts p ON c.id=p.category 

   WHERE c.title='Database’;

4. SELECT \* FROM categories c 

   WHERE c.id NOT IN (SELECT category FROM posts);

   SELECT c.id, c.title, p.id, p.category, p.title FROM categories c 

   LEFT JOIN posts p ON  c.id=p.category 

   WHERE p.category IS NULL;

LATERAL JOIN : kết hợp 1 bảng với 1 query  
SELECT u.username,q.\* FROM users u JOIN LATERAL (  
SELECT author, title, likes FROM posts p   
WHERE u.id=p.author AND likes \> 2 ) AS q ON TRUE;
