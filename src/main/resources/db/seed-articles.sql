-- ============================================================
-- Derma Insight – Seed Data
-- Categories (9) + Articles (32 = 12 gốc + 20 mới)
-- Chạy: psql -U postgres -d derma_insight -f seed-articles.sql
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. CATEGORIES
-- ────────────────────────────────────────────────────────────
INSERT INTO categories (name, slug, description) VALUES
  ('Bệnh da liễu',          'benh-da-lieu',       'Thông tin về các bệnh da liễu phổ biến và hiếm gặp')
 ,('Triệu chứng',           'trieu-chung',        'Nhận biết và phân loại các triệu chứng trên da')
 ,('Chăm sóc da',           'cham-soc-da',        'Hướng dẫn chăm sóc da đúng cách hàng ngày')
 ,('Điều trị',              'dieu-tri',           'Các phương pháp và công nghệ điều trị da liễu')
 ,('Mỹ phẩm & Hoạt chất',  'my-pham-hoat-chat',  'Phân tích thành phần và hoạt chất trong mỹ phẩm')
 ,('Da liễu trẻ em',        'da-lieu-tre-em',     'Chăm sóc và điều trị da liễu cho trẻ sơ sinh và trẻ nhỏ')
 ,('Da đầu & Tóc',          'da-dau-toc',         'Sức khỏe da đầu và các vấn đề về tóc')
 ,('Hỏi đáp da liễu',       'hoi-dap-da-lieu',    'Giải đáp thắc mắc thường gặp về da liễu')
 ,('Nghiên cứu & Tin tức',  'nghien-cuu-tin-tuc', 'Cập nhật nghiên cứu khoa học và tin tức mới nhất')
ON CONFLICT (slug) DO NOTHING;

-- ────────────────────────────────────────────────────────────
-- 2. HELPER: lưu category_id vào biến tạm
-- ────────────────────────────────────────────────────────────
DO $$
DECLARE
  c_benh        BIGINT; c_trieu       BIGINT; c_cham        BIGINT;
  c_dieu        BIGINT; c_my          BIGINT; c_tre         BIGINT;
  c_toc         BIGINT; c_hoi         BIGINT; c_nghien      BIGINT;
BEGIN
  SELECT id INTO c_benh   FROM categories WHERE slug = 'benh-da-lieu';
  SELECT id INTO c_trieu  FROM categories WHERE slug = 'trieu-chung';
  SELECT id INTO c_cham   FROM categories WHERE slug = 'cham-soc-da';
  SELECT id INTO c_dieu   FROM categories WHERE slug = 'dieu-tri';
  SELECT id INTO c_my     FROM categories WHERE slug = 'my-pham-hoat-chat';
  SELECT id INTO c_tre    FROM categories WHERE slug = 'da-lieu-tre-em';
  SELECT id INTO c_toc    FROM categories WHERE slug = 'da-dau-toc';
  SELECT id INTO c_hoi    FROM categories WHERE slug = 'hoi-dap-da-lieu';
  SELECT id INTO c_nghien FROM categories WHERE slug = 'nghien-cuu-tin-tuc';

  -- ─────────────────────────────────────────────────────────
  -- 3. 12 BÀI GỐC (từ mock-data.ts)
  -- ─────────────────────────────────────────────────────────
  INSERT INTO articles (category_id, title, slug, summary, content, thumbnail_url, status, published_at) VALUES

  (c_benh,
   'Vai trò của hệ vi sinh vật da trong viêm da cơ địa kháng trị',
   'he-vi-sinh-vat-da-viem-da-co-dia',
   'Các nghiên cứu dọc gần đây cho thấy sự đa dạng vi sinh đóng vai trò quan trọng hơn trong phục hồi hàng rào da so với những gì từng được ghi nhận.',
   '<p class="lead">Hệ vi sinh vật da là một quần thể phức tạp ảnh hưởng trực tiếp đến sức khoẻ và khả năng tự phục hồi của làn da.</p>
<p>Hàng rào bảo vệ da (skin barrier) đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Các nghiên cứu gần đây cho thấy thành phần lipid giữa các tế bào sừng — bao gồm ceramide, cholesterol và acid béo tự do — quyết định phần lớn khả năng giữ nước của da. Tỉ lệ mất cân bằng giữa các thành phần này thường gặp ở những người có cơ địa viêm da cơ địa.</p>
<figure><img src="https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800&q=80" alt="Minh hoạ cấu trúc da" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600&q=80',
   'PUBLISHED', '2024-10-24 08:00:00'),

  (c_my,
   'Niacinamide: Vượt ra ngoài chức năng phục hồi hàng rào da',
   'niacinamide-chuc-nang-hang-rao-da',
   'Hiểu về tác dụng hiệp đồng của Vitamin B3 khi kết hợp với retinoid bôi tại chỗ trong các phác đồ chống lão hoá.',
   '<p class="lead">Niacinamide (Vitamin B3) là một trong những hoạt chất được nghiên cứu nhiều nhất với hồ sơ an toàn rất tốt.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế tác động</h2>
<p>Niacinamide hoạt động theo nhiều cơ chế khác nhau: ức chế chuyển melanin, tăng tổng hợp ceramide, chống oxy hoá và giảm viêm. Đây là lý do hoạt chất này được tích hợp trong cả sản phẩm dưỡng ẩm lẫn chống lão hoá.</p>
<figure><img src="https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&q=80" alt="Serum niacinamide" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80',
   'PUBLISHED', '2024-10-21 08:00:00'),

  (c_dieu,
   'Tiến bộ trong điều trị laser xung nhuộm cho tổn thương mạch máu',
   'laser-xung-nhuom-ton-thuong-mach-mau',
   'Đánh giá các công nghệ làm mát mới cho phép tăng năng lượng mà không làm tăng khó chịu hay thời gian phục hồi.',
   '<p class="lead">Laser xung nhuộm (PDL) là tiêu chuẩn vàng trong xử lý các tổn thương mạch máu nông trên da.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Laser PDL hoạt động dựa trên nguyên tắc quang nhiệt chọn lọc, nhắm mục tiêu vào oxyhemoglobin trong các mạch máu. Bước sóng 585–595 nm được hấp thụ mạnh bởi hemoglobin, dẫn đến phá hủy mạch máu bất thường mà không tổn thương mô xung quanh.</p>
<figure><img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=800&q=80" alt="Thiết bị laser" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=600&q=80',
   'PUBLISHED', '2024-10-18 08:00:00'),

  (c_benh,
   'Quản lý mụn trứng cá ở người trưởng thành: phác đồ toàn diện',
   'quan-ly-mun-trung-ca-nguoi-truong-thanh',
   'Tìm hiểu mối liên hệ nội tiết phía sau tình trạng mụn dai dẳng và các can thiệp điều trị hiện đại.',
   '<p class="lead">Mụn trứng cá ở người trưởng thành thường liên quan đến yếu tố nội tiết và đòi hỏi tiếp cận khác với mụn tuổi dậy thì.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Mụn trứng cá người trưởng thành thường do rối loạn nội tiết tố, đặc biệt androgen, dẫn đến tăng tiết bã nhờn. Stress, chế độ ăn và môi trường cũng đóng vai trò quan trọng trong cơ chế bệnh sinh.</p>
<figure><img src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&q=80" alt="Chăm sóc da mặt" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&q=80',
   'PUBLISHED', '2024-10-15 08:00:00'),

  (c_tre,
   'Chàm sữa ở trẻ sơ sinh: các hướng điều trị không corticoid',
   'cham-sua-tre-so-sinh-khong-corticoid',
   'Hướng dẫn cho cha mẹ nhận biết sớm dấu hiệu viêm da cơ địa và kiểm soát các đợt bùng phát một cách an toàn.',
   '<p class="lead">Chàm sữa (viêm da cơ địa ở trẻ nhỏ) cần được chăm sóc nhẹ nhàng với trọng tâm là phục hồi và duy trì hàng rào da.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Viêm da cơ địa ở trẻ em thường biểu hiện rõ từ 2–6 tháng tuổi với các mảng đỏ, ngứa trên mặt và da đầu. Yếu tố di truyền đóng vai trò chính, khoảng 70% trường hợp có tiền sử gia đình.</p>
<figure><img src="https://images.unsplash.com/photo-1519689680058-324335c77eba?w=800&q=80" alt="Chăm sóc da trẻ em" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=600&q=80',
   'PUBLISHED', '2024-10-12 08:00:00'),

  (c_cham,
   'SPF 50 mỗi ngày: giải mã những lầm tưởng về chống nắng',
   'spf-50-lam-tuong-chong-nang',
   'Phá bỏ những hiểu lầm phổ biến về phơi nắng trong ngày âm u và nguy cơ từ ánh sáng xanh trong nhà.',
   '<p class="lead">Chống nắng phổ rộng hằng ngày là biện pháp đơn giản nhưng hiệu quả nhất để phòng ngừa lão hoá và ung thư da.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Tia UVA xuyên qua mây và kính, gây lão hoá và ung thư da ngay cả trong ngày âm u. SPF chỉ đo khả năng chặn UVB; để bảo vệ toàn diện cần dùng kem chống nắng phổ rộng có PA+++ hoặc UVA-PF cao.</p>
<figure><img src="https://images.unsplash.com/photo-1556228852-6d35a585d566?w=800&q=80" alt="Kem chống nắng" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1556228852-6d35a585d566?w=600&q=80',
   'PUBLISHED', '2024-10-09 08:00:00'),

  (c_dieu,
   'Tranexamic acid trong điều trị nám má: bằng chứng cập nhật',
   'tranexamic-acid-dieu-tri-nam-ma',
   'Cơ chế tác động của tranexamic acid đường bôi và đường uống trong kiểm soát tăng sắc tố.',
   '<p class="lead">Tranexamic acid đang trở thành lựa chọn quan trọng trong điều trị nám má nhờ khả năng điều hoà sắc tố.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Tranexamic acid ức chế tương tác giữa keratinocytes và melanocytes, từ đó giảm sản xuất melanin. Nồng độ bôi 2–5% cho thấy hiệu quả rõ rệt sau 8–12 tuần sử dụng đều đặn.</p>
<figure><img src="https://images.unsplash.com/photo-1612817288484-6f916006741a?w=800&q=80" alt="Điều trị nám" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1612817288484-6f916006741a?w=600&q=80',
   'PUBLISHED', '2024-10-05 08:00:00'),

  (c_toc,
   'Rụng tóc androgen: tiếp cận chẩn đoán và điều trị',
   'rung-toc-androgen-chan-doan-dieu-tri',
   'Phân biệt rụng tóc androgen với các nguyên nhân khác và các lựa chọn điều trị có bằng chứng.',
   '<p class="lead">Rụng tóc androgen là dạng rụng tóc phổ biến nhất, liên quan đến yếu tố di truyền và nội tiết.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Rụng tóc androgen xảy ra khi DHT (dihydrotestosterone) gắn vào thụ thể trên nang tóc, khiến chu kỳ tóc ngắn lại và tóc ngày càng mỏng hơn. Minoxidil và finasteride là hai lựa chọn điều trị có bằng chứng mạnh nhất hiện nay.</p>
<figure><img src="https://images.unsplash.com/photo-1595475207225-428b62bda831?w=800&q=80" alt="Sức khoẻ tóc" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1595475207225-428b62bda831?w=600&q=80',
   'PUBLISHED', '2024-10-02 08:00:00'),

  (c_hoi,
   'Khi nào cần đi khám bác sĩ da liễu? 7 dấu hiệu cảnh báo',
   'khi-nao-can-kham-bac-si-da-lieu',
   'Những thay đổi trên da bạn không nên bỏ qua và nên đến gặp chuyên gia da liễu càng sớm càng tốt.',
   '<p class="lead">Nhiều vấn đề da liễu có thể tự cải thiện, nhưng một số dấu hiệu cần được thăm khám chuyên khoa ngay.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>7 dấu hiệu không nên bỏ qua</h2>
<p>Nốt ruồi thay đổi màu sắc, hình dạng hoặc chảy máu; vết loét không lành sau 2 tuần; phát ban lan rộng kèm sốt; mảng da dày bong vảy ngứa dai dẳng là những dấu hiệu cần gặp bác sĩ ngay.</p>
<figure><img src="https://images.unsplash.com/photo-1579684453423-f84349ef60b0?w=800&q=80" alt="Khám da liễu" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1579684453423-f84349ef60b0?w=600&q=80',
   'PUBLISHED', '2024-09-28 08:00:00'),

  (c_trieu,
   'Nhận diện sớm triệu chứng vảy nến: từ mảng đỏ đến bong vảy',
   'nhan-dien-som-trieu-chung-vay-nen',
   'Hướng dẫn nhận biết các biểu hiện đặc trưng của vảy nến và phân biệt với các bệnh da khác.',
   '<p class="lead">Vảy nến là bệnh viêm da mạn tính qua trung gian miễn dịch với biểu hiện lâm sàng đa dạng.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Vảy nến là bệnh tự miễn, tế bào da tái tạo quá nhanh (3–4 ngày thay vì 28–30 ngày bình thường). Các mảng đỏ, bạc, ngứa thường xuất hiện ở khuỷu tay, đầu gối, da đầu và lưng dưới.</p>
<figure><img src="https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80" alt="Triệu chứng vảy nến" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&q=80',
   'PUBLISHED', '2024-09-24 08:00:00'),

  (c_nghien,
   'Cập nhật nghiên cứu: chất ức chế JAK bôi trong vảy nến mảng',
   'chat-uc-che-jak-boi-vay-nen-mang',
   'Chất ức chế Janus kinase đường bôi mở ra hướng tiếp cận nhắm trúng đích cho viêm da mạn tính.',
   '<p class="lead">Chất ức chế JAK đường bôi đại diện cho bước chuyển quan trọng trong điều trị các bệnh da viêm.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Ruxolitinib cream 1.5% đã được FDA phê duyệt cho vảy nến không corticoid ở người lớn và trẻ em từ 12 tuổi. Cơ chế ức chế JAK1/JAK2 làm giảm tín hiệu cytokine viêm, mang lại cải thiện rõ trong 8 tuần.</p>
<figure><img src="https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=800&q=80" alt="Nghiên cứu da liễu" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=600&q=80',
   'PUBLISHED', '2024-09-20 08:00:00'),

  (c_cham,
   'Routine dưỡng da tối giản cho da dầu mụn',
   'routine-duong-da-toi-gian-da-dau-mun',
   'Ba bước cốt lõi giúp kiểm soát dầu và mụn mà không làm tổn thương hàng rào bảo vệ da.',
   '<p class="lead">Một quy trình dưỡng da tối giản nhưng đúng đắn thường hiệu quả hơn nhiều bước phức tạp.</p>
<p>Hàng rào bảo vệ da đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>3 bước cốt lõi</h2>
<p>Bước 1: Làm sạch với sữa rửa mặt pH 5–5.5, không sulfate. Bước 2: Serum niacinamide 5–10% để kiểm soát dầu và làm đều màu da. Bước 3: Kem chống nắng không gây mụn (non-comedogenic) với SPF 50+.</p>
<figure><img src="https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=800&q=80" alt="Skincare routine" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>',
   'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=600&q=80',
   'PUBLISHED', '2024-09-16 08:00:00')

  ON CONFLICT (slug) DO NOTHING;

  -- ─────────────────────────────────────────────────────────
  -- 4. 20 BÀI MỚI
  -- ─────────────────────────────────────────────────────────
  INSERT INTO articles (category_id, title, slug, summary, content, thumbnail_url, status, published_at) VALUES

  -- #13 – Bệnh da liễu
  (c_benh,
   'Viêm da tiếp xúc dị ứng: nguyên nhân và cách phòng ngừa',
   'viem-da-tiep-xuc-di-ung-nguyen-nhan-phong-ngua',
   'Hiểu rõ cơ chế phản ứng dị ứng da để tránh tái phát và lựa chọn sản phẩm phù hợp.',
   '<p class="lead">Viêm da tiếp xúc dị ứng là phản ứng miễn dịch qua trung gian tế bào T xảy ra sau khi da tiếp xúc lặp lại với dị nguyên.</p>
<p>Dị nguyên phổ biến bao gồm nickel (kim loại), nước hoa, chất bảo quản trong mỹ phẩm và cao su latex. Phản ứng thường xuất hiện 24–72 giờ sau tiếp xúc với biểu hiện đỏ, mụn nước, ngứa dữ dội.</p>
<h2>Chẩn đoán</h2>
<p>Test dán (patch test) là tiêu chuẩn vàng để xác định dị nguyên. Bác sĩ sẽ dán các dải chứa dị nguyên tiêu chuẩn lên lưng bệnh nhân trong 48 giờ, sau đó đọc kết quả ở giờ thứ 72–96.</p>
<figure><img src="https://images.unsplash.com/photo-1576086213369-97a306d36557?w=800&q=80" alt="Viêm da tiếp xúc" loading="lazy" /><figcaption>Hình 1. Phản ứng viêm da tiếp xúc điển hình.</figcaption></figure>
<h3>Phòng ngừa</h3>
<ul><li>Tránh tiếp xúc với dị nguyên đã xác định.</li><li>Đọc kỹ thành phần sản phẩm trước khi dùng.</li><li>Đeo găng tay khi làm việc với hóa chất.</li><li>Chọn trang sức và phụ kiện không chứa nickel.</li></ul>
<blockquote>Phòng ngừa tiếp xúc với dị nguyên là biện pháp hiệu quả nhất và duy nhất có thể chữa khỏi hoàn toàn viêm da tiếp xúc dị ứng.</blockquote>',
   'https://images.unsplash.com/photo-1576086213369-97a306d36557?w=600&q=80',
   'PUBLISHED', '2024-09-12 08:00:00'),

  -- #14 – Chăm sóc da
  (c_cham,
   'Retinol và Retinoid: hướng dẫn bắt đầu đúng cách cho người mới',
   'retinol-retinoid-huong-dan-bat-dau-dung-cach',
   'Tránh kích ứng và tận dụng tối đa lợi ích của vitamin A dẫn xuất với lộ trình tăng dần phù hợp.',
   '<p class="lead">Retinoid là nhóm hoạt chất chống lão hoá và điều trị mụn có bằng chứng khoa học mạnh nhất, nhưng cần được sử dụng đúng cách để tránh kích ứng.</p>
<p>Retinol (OTC) chuyển đổi qua 2 bước thành retinoic acid — dạng hoạt tính thực sự. Tretinoin (Rx) là retinoic acid trực tiếp, hiệu quả hơn nhưng kích ứng cao hơn.</p>
<h2>Lộ trình tăng dần</h2>
<p>Bắt đầu với retinol 0.025–0.05%, dùng 1–2 lần/tuần vào buổi tối. Sau 4–6 tuần khi da đã thích nghi, tăng lên 3 lần/tuần, rồi hàng ngày. Luôn dưỡng ẩm sau và dùng SPF vào ban ngày.</p>
<figure><img src="https://images.unsplash.com/photo-1620916297397-a4a5402a3c6c?w=800&q=80" alt="Retinol serum" loading="lazy" /><figcaption>Hình 1. Các sản phẩm retinol cho người mới bắt đầu.</figcaption></figure>
<h3>Lưu ý quan trọng</h3>
<ul><li>Không dùng retinoid khi đang mang thai hoặc cho con bú.</li><li>Không kết hợp với AHA/BHA trong cùng một bước skincare.</li><li>Bảo quản tránh ánh sáng để ngăn oxy hoá.</li></ul>
<blockquote>Kiên nhẫn là chìa khóa — hầu hết lợi ích của retinoid chỉ thấy rõ sau 3–6 tháng sử dụng đều đặn.</blockquote>',
   'https://images.unsplash.com/photo-1620916297397-a4a5402a3c6c?w=600&q=80',
   'PUBLISHED', '2024-09-08 08:00:00'),

  -- #15 – Điều trị
  (c_dieu,
   'Liệu pháp ánh sáng (phototherapy) trong điều trị vảy nến nặng',
   'lieu-phap-anh-sang-phototherapy-vay-nen-nang',
   'Cơ chế tác động của tia UVB băng hẹp và PUVA trong kiểm soát bệnh vảy nến diện rộng.',
   '<p class="lead">Phototherapy sử dụng bước sóng ánh sáng cụ thể để giảm tốc độ tăng sinh tế bào da và ức chế phản ứng miễn dịch cục bộ.</p>
<p>UVB băng hẹp (311 nm) là lựa chọn ưu tiên cho vảy nến diện rộng, ít tác dụng phụ hơn PUVA và không cần uống thuốc psoralen. Phác đồ chuẩn: 3 lần/tuần trong 20–30 phiên điều trị.</p>
<h2>So sánh UVB và PUVA</h2>
<p>PUVA (psoralen + UVA) hiệu quả hơn với vảy nến kháng trị nhưng tăng nguy cơ ung thư da và đục thủy tinh thể khi dùng lâu dài. UVB băng hẹp hiện được ưu tiên cho hầu hết bệnh nhân do hồ sơ an toàn tốt hơn.</p>
<figure><img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=800&q=80" alt="Phòng điều trị ánh sáng" loading="lazy" /><figcaption>Hình 1. Buồng chiếu tia UVB băng hẹp trong điều trị vảy nến.</figcaption></figure>
<h3>Chỉ định và chống chỉ định</h3>
<ul><li>Chỉ định: vảy nến mảng diện rộng, vảy nến giọt lan toả.</li><li>Thận trọng: bệnh lupus, tiền sử ung thư da, dùng thuốc nhạy cảm ánh sáng.</li><li>Theo dõi thường quy với bác sĩ da liễu mỗi 3–6 tháng.</li></ul>
<blockquote>Phototherapy kết hợp với điều trị tại chỗ có thể tăng hiệu quả đáng kể so với dùng đơn độc.</blockquote>',
   'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=600&q=80',
   'PUBLISHED', '2024-09-04 08:00:00'),

  -- #16 – Mỹ phẩm & Hoạt chất
  (c_my,
   'AHA và BHA: chọn đúng acid tẩy tế bào chết cho từng loại da',
   'aha-bha-chon-dung-acid-tay-te-bao-chet',
   'Glycolic, lactic, salicylic — phân tích ưu nhược điểm và cách phối hợp an toàn trong skincare hàng ngày.',
   '<p class="lead">Acid tẩy tế bào chết (chemical exfoliants) hoạt động hiệu quả và nhẹ nhàng hơn scrub vật lý khi sử dụng đúng nồng độ và tần suất.</p>
<p>AHA (alpha hydroxy acid) gồm glycolic, lactic, mandelic acid — tan trong nước, tác động trên bề mặt da, phù hợp làn da khô và cần chống lão hoá. BHA (beta hydroxy acid) chủ yếu là salicylic acid — tan trong dầu, thâm sâu vào lỗ chân lông, lý tưởng cho da dầu và mụn đầu đen.</p>
<h2>Hướng dẫn sử dụng theo loại da</h2>
<p>Da dầu mụn: salicylic acid 0.5–2% hàng ngày. Da khô, lão hoá: glycolic acid 5–10% (2–3 lần/tuần). Da nhạy cảm: mandelic acid 5% hoặc lactic acid 5% (1–2 lần/tuần). Luôn dùng kem chống nắng sau khi sử dụng acid.</p>
<figure><img src="https://images.unsplash.com/photo-1556228852-6d35a585d566?w=800&q=80" alt="Chemical exfoliants" loading="lazy" /><figcaption>Hình 1. Các loại acid tẩy tế bào chết phổ biến.</figcaption></figure>
<h3>Cách tránh kích ứng</h3>
<ul><li>Bắt đầu với nồng độ thấp nhất và tần suất 1 lần/tuần.</li><li>Không kết hợp AHA/BHA với retinoid trong cùng buổi tối.</li><li>Áp dụng kỹ thuật buffer: thoa moisturizer nhẹ trước acid.</li></ul>
<blockquote>Tẩy tế bào chết đúng cách làm tăng hiệu quả hấp thụ của các sản phẩm dưỡng da sử dụng tiếp theo lên đến 30%.</blockquote>',
   'https://images.unsplash.com/photo-1556228852-6d35a585d566?w=600&q=80',
   'PUBLISHED', '2024-08-30 08:00:00'),

  -- #17 – Da liễu trẻ em
  (c_tre,
   'Hăm tã ở trẻ sơ sinh: phân biệt và điều trị đúng phác đồ',
   'ham-ta-tre-so-sinh-phan-biet-dieu-tri',
   'Phân biệt hăm tã thông thường với nhiễm Candida da và hướng xử trí phù hợp cho từng thể bệnh.',
   '<p class="lead">Hăm tã là một trong những vấn đề da liễu phổ biến nhất ở trẻ sơ sinh, ảnh hưởng đến 7–35% trẻ trong giai đoạn mặc tã.</p>
<p>Hăm tã thông thường do kích ứng từ phân, nước tiểu và ma sát, biểu hiện đỏ bề mặt phẳng ở các nếp gấp. Nhiễm Candida da có biểu hiện điển hình: đỏ tươi, bờ rõ, kèm "vệ tinh" — các mụn nhỏ xung quanh vùng tổn thương chính.</p>
<h2>Phân loại và điều trị</h2>
<p>Hăm tã thông thường: thay tã thường xuyên, vệ sinh nhẹ nhàng, dùng zinc oxide 10–40% làm hàng rào bảo vệ. Nhiễm Candida: cần antifungal tại chỗ (nystatin, clotrimazole) và không dùng steroid đơn độc.</p>
<figure><img src="https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=800&q=80" alt="Chăm sóc da trẻ" loading="lazy" /><figcaption>Hình 1. Vùng mặc tã cần được chăm sóc đúng cách.</figcaption></figure>
<h3>Phòng ngừa hiệu quả</h3>
<ul><li>Thay tã ngay khi ướt hoặc bẩn, không để quá 2 giờ.</li><li>Để da thoáng khí 10–15 phút sau mỗi lần thay tã.</li><li>Sử dụng kem barrier chứa zinc oxide mỗi lần thay tã.</li></ul>
<blockquote>Giữ vùng tã khô và thông thoáng là biện pháp phòng ngừa hăm tã hiệu quả nhất.</blockquote>',
   'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=80',
   'PUBLISHED', '2024-08-26 08:00:00'),

  -- #18 – Da đầu & Tóc
  (c_toc,
   'Gàu và viêm da tiết bã: nguyên nhân sâu xa và liệu pháp điều trị',
   'gau-viem-da-tiet-ba-nguyen-nhan-dieu-tri',
   'Vai trò của nấm Malassezia và hướng điều trị kết hợp shampoo y tế với chăm sóc da đầu đúng cách.',
   '<p class="lead">Viêm da tiết bã (seborrheic dermatitis) là bệnh mạn tính phổ biến, ảnh hưởng 1–5% dân số, thường biểu hiện dưới dạng gàu dai dẳng kèm ngứa và đỏ da.</p>
<p>Nguyên nhân chính là sự phát triển quá mức của nấm Malassezia trên da đầu, kết hợp với tăng tiết bã nhờn và phản ứng viêm cục bộ. Stress, thời tiết lạnh và miễn dịch suy giảm có thể làm bùng phát bệnh.</p>
<h2>Phương pháp điều trị</h2>
<p>Shampoo zinc pyrithione (Head & Shoulders), selenium sulfide 1–2.5%, ketoconazole 1–2% hoặc ciclopirox 1% đều có bằng chứng điều trị gàu và viêm da tiết bã. Luân phiên giữa các loại shampoo giúp tránh kháng thuốc.</p>
<figure><img src="https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80" alt="Chăm sóc da đầu" loading="lazy" /><figcaption>Hình 1. Da đầu khoẻ mạnh cần chăm sóc đúng cách.</figcaption></figure>
<h3>Chế độ duy trì</h3>
<ul><li>Dùng shampoo trị gàu 2 lần/tuần trong đợt cấp.</li><li>Duy trì 1 lần/tuần sau khi bệnh được kiểm soát.</li><li>Tránh gãi mạnh và dùng sản phẩm tạo kiểu có cồn cao.</li></ul>
<blockquote>Viêm da tiết bã là bệnh mạn tính — mục tiêu điều trị là kiểm soát triệu chứng, không phải chữa khỏi hoàn toàn.</blockquote>',
   'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80',
   'PUBLISHED', '2024-08-22 08:00:00'),

  -- #19 – Hỏi đáp
  (c_hoi,
   'Mụn đầu đen có nên nặn không? Câu trả lời từ bác sĩ da liễu',
   'mun-dau-den-co-nen-nan-khong',
   'Phân tích nguy cơ khi tự nặn mụn tại nhà và các phương pháp loại bỏ mụn đầu đen an toàn, hiệu quả.',
   '<p class="lead">Mụn đầu đen (comedone hở) hình thành khi lỗ chân lông bị bã nhờn và tế bào chết bịt kín, tiếp xúc không khí làm oxy hoá thành màu đen.</p>
<p>Nặn mụn đầu đen tại nhà không đúng cách có thể gây viêm nhiễm, giãn lỗ chân lông vĩnh viễn và để lại thâm. Nguy cơ cao nhất ở vùng chữ T (trán, mũi, cằm).</p>
<h2>Phương pháp loại bỏ an toàn</h2>
<p>BHA (salicylic acid) là lựa chọn hàng đầu — hoà tan bã nhờn bên trong lỗ chân lông. Retinoid tăng tốc chu kỳ tế bào, ngăn tắc nghẽn tái phát. Extraction chuyên nghiệp tại phòng khám là cách duy nhất an toàn nếu cần lấy cơ học.</p>
<figure><img src="https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=800&q=80" alt="Chăm sóc lỗ chân lông" loading="lazy" /><figcaption>Hình 1. Cấu trúc lỗ chân lông và sự hình thành mụn đầu đen.</figcaption></figure>
<h3>Thói quen phòng ngừa</h3>
<ul><li>Tẩy trang kỹ, đặc biệt sau khi trang điểm.</li><li>Dùng salicylic acid toner 0.5–2% hàng ngày.</li><li>Không dùng pore strip thường xuyên — có thể gây giãn lỗ chân lông.</li></ul>
<blockquote>Kiên nhẫn với liệu trình đúng sẽ thu nhỏ lỗ chân lông hiệu quả hơn bất kỳ mẹo tức thời nào.</blockquote>',
   'https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=600&q=80',
   'PUBLISHED', '2024-08-18 08:00:00'),

  -- #20 – Nghiên cứu
  (c_nghien,
   'Liệu pháp sinh học (biologics) thế hệ mới trong điều trị viêm da cơ địa nặng',
   'lieu-phap-sinh-hoc-biologics-viem-da-co-dia-nang',
   'Dupilumab, tralokinumab và các kháng thể đơn dòng mới nhất đang thay đổi diện mạo điều trị viêm da cơ địa.',
   '<p class="lead">Liệu pháp sinh học nhắm trúng đích mở ra kỷ nguyên mới cho bệnh nhân viêm da cơ địa nặng không đáp ứng điều trị thông thường.</p>
<p>Dupilumab (Dupixent) ức chế IL-4 và IL-13, hai cytokine chính trong đường dẫn truyền tín hiệu Th2. Thử nghiệm lâm sàng LIBERTY AD SOLO cho thấy 38% bệnh nhân đạt IGA 0/1 sau 16 tuần.</p>
<h2>Các biological mới nhất</h2>
<p>Tralokinumab (ức chế IL-13 chọn lọc) và lebrikizumab đã được phê duyệt tại EU và Mỹ. Nemolizumab nhắm vào IL-31 giúp giảm ngứa nhanh chóng — thường trong tuần đầu điều trị.</p>
<figure><img src="https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=800&q=80" alt="Nghiên cứu biologics" loading="lazy" /><figcaption>Hình 1. Cơ chế tác động của liệu pháp sinh học trong viêm da cơ địa.</figcaption></figure>
<h3>Ai phù hợp với biologics?</h3>
<ul><li>Viêm da cơ địa trung bình-nặng (EASI ≥ 16).</li><li>Không đáp ứng hoặc không dung nạp cyclosporin, methotrexate.</li><li>Ảnh hưởng nghiêm trọng đến chất lượng cuộc sống (DLQI ≥ 10).</li></ul>
<blockquote>Biologics không chữa khỏi viêm da cơ địa nhưng có thể giúp bệnh nhân đạt và duy trì da gần như sạch hoàn toàn.</blockquote>',
   'https://images.unsplash.com/photo-1582560475093-ba66accbc424?w=600&q=80',
   'PUBLISHED', '2024-08-14 08:00:00'),

  -- #21 – Triệu chứng
  (c_trieu,
   'Mề đay mạn tính: phân loại và tiếp cận điều trị theo bậc thang',
   'me-day-man-tinh-phan-loai-dieu-tri-bac-thang',
   'Nhận diện mề đay dị ứng, tự phát và vật lý để lựa chọn kháng histamine thế hệ 2 và omalizumab đúng chỉ định.',
   '<p class="lead">Mề đay mạn tính (chronic urticaria) định nghĩa là các sẩn phù và/hoặc phù mạch xảy ra hầu hết các ngày, kéo dài hơn 6 tuần.</p>
<p>Phân loại: mề đay tự phát mạn tính (CSU) chiếm 70–80% ca; mề đay cảm ứng do lạnh, nhiệt, áp lực, ánh sáng. Chỉ 20–30% CSU tìm được nguyên nhân cụ thể.</p>
<h2>Bậc thang điều trị (EAACI 2022)</h2>
<p>Bậc 1: kháng H1 thế hệ 2 liều chuẩn. Bậc 2: tăng liều x4. Bậc 3: add-on omalizumab 300mg/4 tuần. Bậc 4: cyclosporin hoặc liệu pháp thay thế. Corticosteroid toàn thân chỉ dùng ngắn ngày để kiểm soát đợt bùng phát.</p>
<figure><img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=800&q=80" alt="Mề đay" loading="lazy" /><figcaption>Hình 1. Sẩn phù điển hình trong mề đay cấp và mạn tính.</figcaption></figure>
<h3>Theo dõi và tiên lượng</h3>
<ul><li>UAS7 (Urticaria Activity Score 7 ngày) để theo dõi đáp ứng điều trị.</li><li>50% CSU thuyên giảm hoàn toàn sau 1 năm không điều trị.</li><li>Nhật ký triệu chứng giúp phát hiện yếu tố kích hoạt.</li></ul>
<blockquote>Omalizumab hiệu quả ở 60–70% bệnh nhân CSU kháng kháng histamine, đây là bước đột phá lớn nhất trong điều trị mề đay mạn.</blockquote>',
   'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=600&q=80',
   'PUBLISHED', '2024-08-10 08:00:00'),

  -- #22 – Bệnh da liễu
  (c_benh,
   'Rosacea: nhận biết, phân loại và điều trị đa phương thức',
   'rosacea-nhan-biet-phan-loai-dieu-tri',
   'Hướng dẫn toàn diện về 4 phân loại rosacea và cách kết hợp điều trị tại chỗ với laser để đạt kết quả tối ưu.',
   '<p class="lead">Rosacea là bệnh viêm da mạn tính phổ biến ở người da sáng, thường biểu hiện với đỏ mặt kéo dài, giãn mạch và mụn viêm.</p>
<p>4 phân loại: (1) Erythematotelangiectatic — đỏ và giãn mạch; (2) Papulopustular — mụn viêm giống mụn trứng cá; (3) Phymatous — dày da, đặc biệt mũi bulbous (rhinophyma); (4) Ocular — ảnh hưởng mắt.</p>
<h2>Điều trị theo phân loại</h2>
<p>Type 1: kem brimonidine 0.33% hoặc oxymetazoline 1% làm co mạch tạm thời; laser PDL hoặc IPL cho kết quả lâu dài. Type 2: metronidazole, azelaic acid, ivermectin tại chỗ; doxycycline liều thấp đường uống. Type 3: laser CO2 hoặc phẫu thuật cho rhinophyma nặng.</p>
<figure><img src="https://images.unsplash.com/photo-1526758097130-bab247274f58?w=800&q=80" alt="Rosacea" loading="lazy" /><figcaption>Hình 1. Đặc điểm lâm sàng rosacea type erythematotelangiectatic.</figcaption></figure>
<h3>Trigger cần tránh</h3>
<ul><li>Thức ăn cay, rượu, nhiệt độ cực đoan.</li><li>Sản phẩm có cồn, menthol, witch hazel.</li><li>Tia UV và gió mạnh.</li></ul>
<blockquote>Điều trị rosacea cần kiên trì lâu dài và tránh trigger — không có phương pháp nào chữa khỏi hoàn toàn nhưng có thể kiểm soát rất tốt.</blockquote>',
   'https://images.unsplash.com/photo-1526758097130-bab247274f58?w=600&q=80',
   'PUBLISHED', '2024-08-06 08:00:00'),

  -- #23 – Mỹ phẩm & Hoạt chất
  (c_my,
   'Vitamin C trong skincare: dạng nào ổn định và hiệu quả nhất?',
   'vitamin-c-skincare-dang-on-dinh-hieu-qua-nhat',
   'So sánh L-ascorbic acid, ascorbyl glucoside, sodium ascorbyl phosphate và các dẫn xuất Vitamin C về độ ổn định và sinh khả dụng.',
   '<p class="lead">Vitamin C (L-ascorbic acid) là chất chống oxy hoá mạnh nhất trong skincare nhưng kém ổn định — đây là lý do thị trường tràn ngập dẫn xuất với tuyên bố "ổn định hơn".</p>
<p>L-ascorbic acid ở pH 2.5–3.5 hiệu quả nhất nhưng gây kích ứng và dễ oxy hoá. Các dẫn xuất như sodium ascorbyl phosphate (SAP) ổn định hơn nhưng cần enzym da chuyển đổi thành dạng hoạt tính — hiệu quả thường thấp hơn 20–30%.</p>
<h2>Bảng so sánh</h2>
<p>L-ascorbic acid 10–20%: hiệu quả cao nhất, kích ứng trung bình. Ascorbyl glucoside: ổn định tốt, thích hợp da nhạy cảm. Magnesium ascorbyl phosphate: nhẹ nhàng, dưỡng ẩm. Tetrahexyldecyl ascorbate (THD): tan trong dầu, thâm nhập tốt, ổn định cao.</p>
<figure><img src="https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=800&q=80" alt="Vitamin C serum" loading="lazy" /><figcaption>Hình 1. Serum Vitamin C — màu vàng nhạt là dấu hiệu còn tươi.</figcaption></figure>
<h3>Mẹo bảo quản và sử dụng</h3>
<ul><li>Chọn serum màu tối, đóng gói kín khí để bảo quản lâu hơn.</li><li>Nếu serum chuyển màu cam/nâu đậm, hiệu quả giảm đáng kể.</li><li>Dùng buổi sáng trước kem chống nắng để tối ưu bảo vệ.</li></ul>
<blockquote>Vitamin C và SPF là combo chống lão hoá và bảo vệ da hiệu quả nhất mà y khoa hiện đại có thể cung cấp.</blockquote>',
   'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=600&q=80',
   'PUBLISHED', '2024-08-02 08:00:00'),

  -- #24 – Da liễu trẻ em
  (c_tre,
   'Mụn đầu trắng ở trẻ sơ sinh (milia neonatorum): khi nào cần lo lắng?',
   'milia-neonatorum-mun-dau-trang-tre-so-sinh',
   'Phân biệt milia lành tính với các tổn thương mụn nước khác ở trẻ sơ sinh và thời gian chờ tự hết.',
   '<p class="lead">Milia neonatorum là những nốt trắng nhỏ 1–2mm do keratin bị giữ lại dưới da, gặp ở 40–50% trẻ sơ sinh khoẻ mạnh.</p>
<p>Vị trí hay gặp: mặt, mũi, má, trán. Milia tự hết trong 2–4 tuần và không cần điều trị. Cần phân biệt với mụn trứng cá sơ sinh (neonatal acne) thường xuất hiện muộn hơn (2–4 tuần tuổi) và có thành phần viêm.</p>
<h2>Phân biệt milia với các tổn thương khác</h2>
<p>Erythema toxicum neonatorum: dát đỏ kèm mụn mủ nhỏ, tự hết trong 1 tuần. Pustular melanosis: phổ biến hơn ở trẻ da tối, để lại dát thâm sau khi mụn mủ vỡ. Herpes neonatorum: mụn nước cần điều trị cấp cứu acyclovir ngay.</p>
<figure><img src="https://images.unsplash.com/photo-1559839914-17aae19cec71?w=800&q=80" alt="Da trẻ sơ sinh" loading="lazy" /><figcaption>Hình 1. Milia neonatorum — tổn thương lành tính tự hết.</figcaption></figure>
<h3>Khi nào cần đi khám ngay</h3>
<ul><li>Mụn nước lan rộng nhanh, kèm sốt hoặc quấy khóc dữ dội.</li><li>Tổn thương dạng cụm giống chùm nho trên nền da đỏ.</li><li>Trẻ bú kém, li bì sau khi xuất hiện mụn nước.</li></ul>
<blockquote>Hầu hết tổn thương da sơ sinh là lành tính và tự khỏi — nhưng luôn hỏi bác sĩ nếu bạn không chắc.</blockquote>',
   'https://images.unsplash.com/photo-1559839914-17aae19cec71?w=600&q=80',
   'PUBLISHED', '2024-07-28 08:00:00'),

  -- #25 – Chăm sóc da
  (c_cham,
   'Da hỗn hợp: chiến lược chăm sóc từng vùng (multi-masking)',
   'da-hon-hop-chien-luoc-cham-soc-tung-vung',
   'Kỹ thuật multi-masking và layering sản phẩm để cân bằng vùng T dầu và vùng má khô trong cùng một routine.',
   '<p class="lead">Da hỗn hợp — vùng T (trán, mũi, cằm) dầu, vùng má khô hoặc bình thường — đòi hỏi chiến lược chăm sóc linh hoạt, không theo một công thức cứng nhắc.</p>
<p>Sai lầm phổ biến nhất là dùng sản phẩm cho da dầu toàn mặt, làm vùng má càng khô và kích ứng hàng rào da. Ngược lại, sản phẩm quá dưỡng ẩm làm nặng thêm tình trạng dầu vùng T.</p>
<h2>Kỹ thuật layering theo vùng</h2>
<p>Bước làm sạch: sữa rửa mặt pH 5–5.5 cho toàn mặt. Toner: chỉ dùng BHA toner ở vùng T; dùng toner dưỡng ẩm ở vùng má. Serum: niacinamide cho toàn mặt. Moisturizer: gel nhẹ ở vùng T, kem dưỡng ẩm richer ở má và quầng mắt.</p>
<figure><img src="https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&q=80" alt="Multi-masking" loading="lazy" /><figcaption>Hình 1. Kỹ thuật đắp mặt nạ theo từng vùng da.</figcaption></figure>
<h3>Multi-masking cuối tuần</h3>
<ul><li>Vùng T: mặt nạ đất sét kaolin hút dầu trong 10 phút.</li><li>Vùng má và mắt: sheet mask dưỡng ẩm hyaluronic acid.</li><li>Toàn mặt: toner HA để cân bằng sau khi rửa sạch mặt nạ.</li></ul>
<blockquote>Da hỗn hợp cần được đối xử như "hai loại da khác nhau" trên cùng một khuôn mặt.</blockquote>',
   'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=600&q=80',
   'PUBLISHED', '2024-07-24 08:00:00'),

  -- #26 – Điều trị
  (c_dieu,
   'Microneedling và PRP: liệu pháp kết hợp cho tái tạo da',
   'microneedling-prp-lieu-phap-tai-tao-da',
   'Cơ chế kích thích collagen của microneedling và cách PRP tăng cường hiệu quả phục hồi sau thủ thuật.',
   '<p class="lead">Microneedling tạo hàng nghìn vi kênh trong da, kích hoạt cascade phục hồi tự nhiên với sự tham gia của yếu tố tăng trưởng và tổng hợp collagen mới.</p>
<p>Kết hợp với PRP (platelet-rich plasma) — huyết tương giàu tiểu cầu từ chính máu bệnh nhân — tăng cường hiệu quả tái tạo da lên đáng kể. Công thức "vampire facial" phổ biến nhờ kết quả cải thiện sẹo, lỗ chân lông và tông da.</p>
<h2>Quy trình thực hiện</h2>
<p>Lấy 10–20ml máu bệnh nhân, ly tâm tách PRP. Tê cục bộ 30–45 phút. Microneedling với độ sâu 0.5–2.5mm tùy vùng. Thoa PRP ngay sau khi microneedling để PRP thẩm thấu qua vi kênh. Nghỉ ngơi 24–48 giờ.</p>
<figure><img src="https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80" alt="Microneedling" loading="lazy" /><figcaption>Hình 1. Thiết bị microneedling chuyên nghiệp tại phòng khám da liễu.</figcaption></figure>
<h3>Kết quả và số phiên điều trị</h3>
<ul><li>Cải thiện sẹo rỗ: 3–6 phiên, cách nhau 4 tuần.</li><li>Kết quả thấy rõ sau 1–3 tháng do collagen cần thời gian hình thành.</li><li>Duy trì kết quả: 1–2 phiên/năm.</li></ul>
<blockquote>Microneedling + PRP là combo "tự nhiên nhất" trong thẩm mỹ da liễu vì sử dụng chính tế bào máu của người bệnh.</blockquote>',
   'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600&q=80',
   'PUBLISHED', '2024-07-20 08:00:00'),

  -- #27 – Da đầu & Tóc
  (c_toc,
   'Alopecia areata: hiểu đúng về bệnh rụng tóc từng mảng',
   'alopecia-areata-rung-toc-tung-mang',
   'Cơ chế tự miễn dịch của alopecia areata và các lựa chọn điều trị từ corticoid tiêm tại chỗ đến thuốc ức chế JAK.',
   '<p class="lead">Alopecia areata là bệnh tự miễn khiến hệ miễn dịch tấn công nang tóc, gây rụng tóc thành từng mảng hình tròn hoặc bầu dục không có sẹo.</p>
<p>Bệnh ảnh hưởng 2% dân số mọi lứa tuổi. 50% ca tự hồi phục trong 1 năm, nhưng 10–15% tiến triển thành alopecia totalis (mất toàn bộ tóc đầu) hoặc universalis (mất toàn bộ lông cơ thể).</p>
<h2>Phương pháp điều trị</h2>
<p>Tiêm triamcinolone acetonide tại chỗ là tiêu chuẩn vàng cho các mảng rụng nhỏ — hiệu quả 60–70%. Baricitinib (JAK inhibitor) đường uống được FDA phê duyệt 2022 cho AA nặng — tỷ lệ mọc lại tóc đáng kể sau 36 tuần.</p>
<figure><img src="https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=800&q=80" alt="Rụng tóc từng mảng" loading="lazy" /><figcaption>Hình 1. Đặc điểm rụng tóc hình tròn trong alopecia areata.</figcaption></figure>
<h3>Hỗ trợ tâm lý</h3>
<ul><li>Ảnh hưởng tâm lý thường nghiêm trọng, đặc biệt ở trẻ em và phụ nữ.</li><li>Tham vấn tâm lý và nhóm hỗ trợ cộng đồng giúp cải thiện chất lượng sống.</li><li>Tóc giả, trang điểm lông mày có thể giúp bệnh nhân tự tin hơn trong khi điều trị.</li></ul>
<blockquote>Baricitinib đánh dấu bước ngoặt trong điều trị alopecia areata nặng — lần đầu tiên có thuốc được FDA phê duyệt cho bệnh này.</blockquote>',
   'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=600&q=80',
   'PUBLISHED', '2024-07-16 08:00:00'),

  -- #28 – Nghiên cứu
  (c_nghien,
   'Microbiome da và trục ruột-da: nghiên cứu tiên phong 2024',
   'microbiome-da-truc-ruot-da-nghien-cuu-2024',
   'Bằng chứng mới về mối liên hệ hai chiều giữa hệ vi sinh đường ruột và tình trạng viêm da, mở ra hướng điều trị probiotic.',
   '<p class="lead">Trục ruột-da (gut-skin axis) ngày càng được công nhận là yếu tố quan trọng trong sinh bệnh học của nhiều bệnh da liễu mạn tính.</p>
<p>Nghiên cứu 2024 tại NEJM cho thấy bệnh nhân viêm da cơ địa nặng có đa dạng vi sinh đường ruột thấp hơn đáng kể so với nhóm chứng, với tỷ lệ Faecalibacterium prausnitzii — vi khuẩn chống viêm — giảm tới 40%.</p>
<h2>Probiotic trong điều trị da liễu</h2>
<p>Lactobacillus rhamnosus GG và Bifidobacterium longum cho thấy giảm SCORAD 20–30% ở trẻ em viêm da cơ địa trong thử nghiệm ngẫu nhiên. Tuy nhiên, đây vẫn là lĩnh vực đang nghiên cứu và chưa có khuyến cáo chính thức.</p>
<figure><img src="https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80" alt="Microbiome nghiên cứu" loading="lazy" /><figcaption>Hình 1. Hình ảnh vi khuẩn dưới kính hiển vi điện tử — đa dạng vi sinh là chìa khóa sức khoẻ da.</figcaption></figure>
<h3>Ứng dụng lâm sàng tương lai</h3>
<ul><li>Xét nghiệm vi sinh đường ruột có thể trở thành một phần đánh giá bệnh nhân viêm da cơ địa.</li><li>Probiotic tại chỗ bôi lên da đang được nghiên cứu lâm sàng giai đoạn 2.</li><li>Điều chỉnh chế độ ăn để tối ưu vi sinh: nhiều chất xơ, ít đường tinh luyện.</li></ul>
<blockquote>Trục ruột-da là một trong những biên giới nghiên cứu hấp dẫn nhất của da liễu học hiện đại.</blockquote>',
   'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&q=80',
   'PUBLISHED', '2024-07-12 08:00:00'),

  -- #29 – Hỏi đáp
  (c_hoi,
   'Dùng nhiều serum cùng lúc: thứ tự nào và bao nhiêu là đủ?',
   'dung-nhieu-serum-cung-luc-thu-tu-va-so-luong',
   'Nguyên tắc layering serum theo kết cấu và pH để tối đa hoá hấp thụ mà không gây tương tác tiêu cực.',
   '<p class="lead">Skincare layering không phải "nhiều là tốt" — đúng thứ tự và pH mới là chìa khóa để các hoạt chất hoạt động hiệu quả và không triệt tiêu nhau.</p>
<p>Nguyên tắc cơ bản: từ loãng đến đặc (texture), từ acid đến kiềm (pH), từ nước đến dầu. Chờ 60 giây giữa các bước cho sản phẩm trước thẩm thấu trước khi thoa tiếp.</p>
<h2>Thứ tự chuẩn buổi sáng</h2>
<p>1. Vitamin C serum (pH thấp 3.0). 2. Chờ 5 phút. 3. Hyaluronic acid serum. 4. Niacinamide serum. 5. Moisturizer. 6. SPF. Không nên: kết hợp Vitamin C + niacinamide trực tiếp (có thể tạo niacin flush nhẹ, dù không nguy hiểm).</p>
<figure><img src="https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800&q=80" alt="Skincare layering" loading="lazy" /><figcaption>Hình 1. Thứ tự layering sản phẩm skincare đúng cách.</figcaption></figure>
<h3>Giới hạn bao nhiêu serum?</h3>
<ul><li>Tối đa 2–3 serum/lần để tránh pilling và quá tải da.</li><li>Xoay vòng serum theo buổi sáng/tối thay vì dùng tất cả cùng lúc.</li><li>Patch test khi thêm serum mới để phát hiện kích ứng sớm.</li></ul>
<blockquote>Skincare đơn giản và đúng nguyên tắc luôn tốt hơn phức tạp và chồng chéo.</blockquote>',
   'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=600&q=80',
   'PUBLISHED', '2024-07-08 08:00:00'),

  -- #30 – Bệnh da liễu
  (c_benh,
   'Zona thần kinh: nhận biết sớm và điều trị kháng virus hiệu quả',
   'zona-than-kinh-nhan-biet-som-dieu-tri',
   'Tầm quan trọng của chẩn đoán sớm và dùng antiviral trong 72 giờ đầu để ngăn ngừa đau sau zona mạn tính.',
   '<p class="lead">Zona (herpes zoster) do virus varicella-zoster tái hoạt, gây ban mụn nước đau dữ dội theo đường phân phối của một nhánh thần kinh.</p>
<p>Nguy cơ tăng theo tuổi và suy giảm miễn dịch. Biến chứng đáng sợ nhất là đau sau zona (postherpetic neuralgia — PHN) ảnh hưởng 10–20% bệnh nhân, có thể kéo dài nhiều tháng đến nhiều năm.</p>
<h2>Điều trị kháng virus</h2>
<p>Acyclovir 800mg x5 lần/ngày hoặc valacyclovir 1000mg x3 lần/ngày trong 7 ngày. Phải bắt đầu trong 72 giờ từ khi nổi ban để giảm nguy cơ PHN. Gabapentin hoặc pregabalin cho đau thần kinh; amitriptyline liều thấp cho PHN mạn tính.</p>
<figure><img src="https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80" alt="Điều trị zona" loading="lazy" /><figcaption>Hình 1. Phân bố ban mụn nước theo đường thần kinh trong zona.</figcaption></figure>
<h3>Vaccine phòng ngừa</h3>
<ul><li>Shingrix (RZV) hiệu quả >90% ngăn ngừa zona ở người ≥50 tuổi.</li><li>2 liều tiêm cách nhau 2–6 tháng, không cần tiêm nhắc lại.</li><li>Được khuyến cáo ngay cả khi đã từng mắc zona trước đây.</li></ul>
<blockquote>Vaccine Shingrix là một trong những tiến bộ y tế lớn nhất thập kỷ qua trong phòng ngừa bệnh nhiễm trùng ở người cao tuổi.</blockquote>',
   'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80',
   'PUBLISHED', '2024-07-04 08:00:00'),

  -- #31 – Triệu chứng
  (c_trieu,
   'Ngứa toàn thân không rõ nguyên nhân: khi nào là dấu hiệu bệnh nội khoa?',
   'ngua-toan-than-khong-ro-nguyen-nhan-benh-noi-khoa',
   'Phân tích ngứa mạn tính không có tổn thương da nguyên phát và các bệnh nội tạng tiềm ẩn cần loại trừ.',
   '<p class="lead">Ngứa toàn thân mạn tính (chronic pruritus) không kèm tổn thương da là dấu hiệu quan trọng cần đánh giá kỹ lưỡng vì có thể là triệu chứng của bệnh nội tạng.</p>
<p>Các nguyên nhân nội khoa thường gặp: bệnh thận mạn (ngứa uremic), ứ mật (ngứa cholestatic), cường/suy giáp, bệnh Hodgkin lymphoma, đa hồng cầu thực, HIV. Ngứa về đêm ưu thế và sụt cân gợi ý bệnh lý ác tính.</p>
<h2>Quy trình đánh giá</h2>
<p>Xét nghiệm cơ bản: công thức máu, chức năng gan-thận, TSH, đường huyết, LDH, protein điện di. Nếu bình thường và ngứa kéo dài >6 tuần: CT ngực-bụng-chậu, xét nghiệm HIV, sinh thiết hạch nếu có.</p>
<figure><img src="https://images.unsplash.com/photo-1504439468489-c8920d796a29?w=800&q=80" alt="Khám lâm sàng" loading="lazy" /><figcaption>Hình 1. Đánh giá hệ thống ngứa mạn tính cần loại trừ bệnh nội tạng.</figcaption></figure>
<h3>Điều trị triệu chứng trong lúc chờ chẩn đoán</h3>
<ul><li>Kháng histamine thế hệ 2 liều cao.</li><li>Thuốc ức chế thần kinh: gabapentin, mirtazapine.</li><li>Dưỡng ẩm thường xuyên và tránh nước tắm nóng.</li></ul>
<blockquote>Ngứa mạn tính không tổn thương da là một trong những thách thức chẩn đoán khó nhất trong da liễu — đừng bỏ qua yếu tố toàn thân.</blockquote>',
   'https://images.unsplash.com/photo-1504439468489-c8920d796a29?w=600&q=80',
   'PUBLISHED', '2024-06-30 08:00:00'),

  -- #32 – Chăm sóc da
  (c_cham,
   'Chăm sóc da mùa hè: bảo vệ và phục hồi sau tắm nắng',
   'cham-soc-da-mua-he-bao-ve-phuc-hoi-sau-tam-nang',
   'Xây dựng routine mùa hè hoàn chỉnh: chống nắng tối ưu, chống oxy hoá và phục hồi da sau khi tiếp xúc ánh nắng.',
   '<p class="lead">Mùa hè là thời điểm da chịu tổn thương UV cao nhất — một routine đúng đắn có thể giảm đến 80% tác hại của ánh nắng trong dài hạn.</p>
<p>Sai lầm phổ biến: chỉ dùng SPF buổi sáng nhưng không bôi lại mỗi 2 giờ khi ở ngoài nắng. Một liều SPF 50+ thực tế chỉ bảo vệ khoảng 2 giờ hiệu quả dưới ánh nắng trực tiếp.</p>
<h2>Routine mùa hè tối ưu</h2>
<p>Sáng: vitamin C serum (chống oxy hoá) → moisturizer nhẹ → SPF 50+ PA++++. Bôi lại kem chống nắng mỗi 2 giờ nếu ở ngoài trời. Tối: double cleanse → BHA toner → retinol (x2/tuần) → peptide serum → dưỡng ẩm dày hơn.</p>
<figure><img src="https://images.unsplash.com/photo-1470259078422-826894b933aa?w=800&q=80" alt="Chăm sóc da mùa hè" loading="lazy" /><figcaption>Hình 1. Bảo vệ da toàn diện trong mùa hè nắng nóng.</figcaption></figure>
<h3>After-sun care</h3>
<ul><li>Tắm nước mát (không lạnh) để hạ nhiệt da.</li><li>Aloe vera gel tươi hoặc kem dưỡng có centella asiatica để làm dịu.</li><li>Uống đủ nước — da mất nước nhanh hơn trong mùa hè.</li></ul>
<blockquote>Kem chống nắng là đầu tư tốt nhất bạn có thể làm cho da ở tuổi 30, 40, 50 — và mọi tuổi.</blockquote>',
   'https://images.unsplash.com/photo-1470259078422-826894b933aa?w=600&q=80',
   'PUBLISHED', '2024-06-26 08:00:00')

  ON CONFLICT (slug) DO NOTHING;

END $$;

-- Kiểm tra kết quả
SELECT
  c.name AS category,
  COUNT(a.id) AS article_count
FROM categories c
LEFT JOIN articles a ON a.category_id = c.id
GROUP BY c.name
ORDER BY c.name;
