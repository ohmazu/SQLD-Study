-- 코드를 입력하세요
SELECT
    b.author_id,
    a.author_name,
    b.category,
    SUM(bs.sales * b.price) AS total_sales
FROM book AS b
JOIN author AS a
  ON a.author_id = b.author_id
JOIN book_sales AS bs
  ON bs.book_id = b.book_id
WHERE bs.sales_date >= DATE '2022-01-01'
  AND bs.sales_date  < DATE '2022-02-01'
GROUP BY
    b.author_id, a.author_name, b.category
ORDER BY
    b.author_id ASC,      -- 저자 ID 오름차순
    b.category  DESC;     -- 동일 저자 내 카테고리 내림차순