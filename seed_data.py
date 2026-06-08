d#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Seed script for derma_insight PostgreSQL database.
Uses psycopg2 to insert categories and articles with correct UTF-8 encoding.
Run: python seed_data.py
"""
import psycopg2
import sys

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "derma_insight",
    "user": "postgres",
    "password": "postgres",
}

THUMB_BASE = "https://images.unsplash.com/photo"

CATEGORIES = [
    ("Bệnh da liễu", "benh-da-lieu", "Thông tin về các bệnh da liễu phổ biến và hiếm gặp"),
    ("Triệu chứng", "trieu-chung", "Nhận biết và phân loại các triệu chứng trên da"),
    ("Chăm sóc da", "cham-soc-da", "Hướng dẫn chăm sóc da đúng cách hàng ngày"),
    ("Điều trị", "dieu-tri", "Các phương pháp và công nghệ điều trị da liễu"),
    ("Mỹ phẩm & Hoạt chất", "my-pham-hoat-chat", "Phân tích thành phần và hoạt chất trong mỹ phẩm"),
    ("Da liễu trẻ em", "da-lieu-tre-em", "Chăm sóc và điều trị da liễu cho trẻ sơ sinh và trẻ nhỏ"),
    ("Da đầu & Tóc", "da-dau-toc", "Sức khỏe da đầu và các vấn đề về tóc"),
    ("Hỏi đáp da liễu", "hoi-dap-da-lieu", "Giải đáp thắc mắc thường gặp về da liễu"),
    ("Nghiên cứu & Tin tức", "nghien-cuu-tin-tuc", "Cập nhật nghiên cứu khoa học và tin tức mới nhất"),
]

def make_content(lead: str, img_url: str) -> str:
    return f"""<p class="lead">{lead}</p>
<p>Hàng rào bảo vệ da (skin barrier) đóng vai trò trung tâm trong việc duy trì độ ẩm và ngăn cản các tác nhân gây kích ứng từ môi trường. Khi lớp này bị tổn thương, da trở nên nhạy cảm, khô ráp và dễ viêm hơn.</p>
<h2>Cơ chế sinh học</h2>
<p>Các nghiên cứu gần đây cho thấy thành phần lipid giữa các tế bào sừng — bao gồm ceramide, cholesterol và acid béo tự do — quyết định phần lớn khả năng giữ nước của da. Tỉ lệ mất cân bằng giữa các thành phần này thường gặp ở những người có cơ địa viêm da cơ địa.</p>
<figure><img src="{img_url}" alt="Minh hoạ" loading="lazy" /><figcaption>Hình 1. Minh hoạ các lớp cấu trúc của da và quá trình giữ ẩm.</figcaption></figure>
<p>Việc phục hồi hàng rào da cần kết hợp dưỡng ẩm đúng cách, tránh các chất tẩy rửa mạnh và bảo vệ da khỏi tia UV. Quá trình này thường mất từ 4 đến 8 tuần để thấy cải thiện rõ rệt.</p>
<h3>Khuyến nghị thực hành</h3>
<ul><li>Dùng sữa rửa mặt dịu nhẹ, độ pH gần với da (5.5).</li><li>Thoa kem dưỡng chứa ceramide ngay sau khi rửa mặt.</li><li>Sử dụng kem chống nắng phổ rộng SPF 30+ mỗi ngày.</li></ul>
<blockquote>Phục hồi hàng rào da là nền tảng của hầu hết các phác đồ điều trị da liễu hiện đại.</blockquote>
<p>Bệnh nhân nên tham khảo ý kiến bác sĩ da liễu trước khi bắt đầu bất kỳ hoạt chất mạnh nào như retinoid hoặc acid tẩy tế bào chết, đặc biệt khi da đang trong giai đoạn kích ứng.</p>"""

# (category_slug, title, slug, summary, content_lead, img_id, date)
ARTICLES = [
    # 12 bài gốc
    ("benh-da-lieu", "Vai trò của hệ vi sinh vật da trong viêm da cơ địa kháng trị",
     "he-vi-sinh-vat-da-viem-da-co-dia",
     "Các nghiên cứu dọc gần đây cho thấy sự đa dạng vi sinh đóng vai trò quan trọng hơn trong phục hồi hàng rào da so với những gì từng được ghi nhận.",
     "Hệ vi sinh vật da là một quần thể phức tạp ảnh hưởng trực tiếp đến sức khoẻ và khả năng tự phục hồi của làn da.",
     "1576091160550-2173dba999ef?w=800&q=80", "1576091160550-2173dba999ef?w=600&q=80", "2024-10-24 08:00:00"),
    ("my-pham-hoat-chat", "Niacinamide: Vượt ra ngoài chức năng phục hồi hàng rào da",
     "niacinamide-chuc-nang-hang-rao-da",
     "Hiểu về tác dụng hiệp đồng của Vitamin B3 khi kết hợp với retinoid bôi tại chỗ trong các phác đồ chống lão hoá.",
     "Niacinamide (Vitamin B3) là một trong những hoạt chất được nghiên cứu nhiều nhất với hồ sơ an toàn rất tốt.",
     "1620916566398-39f1143ab7be?w=800&q=80", "1620916566398-39f1143ab7be?w=600&q=80", "2024-10-21 08:00:00"),
    ("dieu-tri", "Tiến bộ trong điều trị laser xung nhuộm cho tổn thương mạch máu",
     "laser-xung-nhuom-ton-thuong-mach-mau",
     "Đánh giá các công nghệ làm mát mới cho phép tăng năng lượng mà không làm tăng khó chịu hay thời gian phục hồi.",
     "Laser xung nhuộm (PDL) là tiêu chuẩn vàng trong xử lý các tổn thương mạch máu nông trên da.",
     "1643916861217-d059f7f81b85?w=800&q=80", "1643916861217-d059f7f81b85?w=600&q=80", "2024-10-18 08:00:00"),
    ("benh-da-lieu", "Quản lý mụn trứng cá ở người trưởng thành: phác đồ toàn diện",
     "quan-ly-mun-trung-ca-nguoi-truong-thanh",
     "Tìm hiểu mối liên hệ nội tiết phía sau tình trạng mụn dai dẳng và các can thiệp điều trị hiện đại.",
     "Mụn trứng cá ở người trưởng thành thường liên quan đến yếu tố nội tiết và đòi hỏi tiếp cận khác với mụn tuổi dậy thì.",
     "1540555700478-4be289fbecef?w=800&q=80", "1540555700478-4be289fbecef?w=600&q=80", "2024-10-15 08:00:00"),
    ("da-lieu-tre-em", "Chàm sữa ở trẻ sơ sinh: các hướng điều trị không corticoid",
     "cham-sua-tre-so-sinh-khong-corticoid",
     "Hướng dẫn cho cha mẹ nhận biết sớm dấu hiệu viêm da cơ địa và kiểm soát các đợt bùng phát một cách an toàn.",
     "Chàm sữa (viêm da cơ địa ở trẻ nhỏ) cần được chăm sóc nhẹ nhàng với trọng tâm là phục hồi và duy trì hàng rào da.",
     "1519689680058-324335c77eba?w=800&q=80", "1519689680058-324335c77eba?w=600&q=80", "2024-10-12 08:00:00"),
    ("cham-soc-da", "SPF 50 mỗi ngày: giải mã những lầm tưởng về chống nắng",
     "spf-50-lam-tuong-chong-nang",
     "Phá bỏ những hiểu lầm phổ biến về phơi nắng trong ngày âm u và nguy cơ từ ánh sáng xanh trong nhà.",
     "Chống nắng phổ rộng hằng ngày là biện pháp đơn giản nhưng hiệu quả nhất để phòng ngừa lão hoá và ung thư da.",
     "1556228578-dd7d6e5e6872?w=800&q=80", "1556228578-dd7d6e5e6872?w=600&q=80", "2024-10-09 08:00:00"),
    ("dieu-tri", "Tranexamic acid trong điều trị nám má: bằng chứng cập nhật",
     "tranexamic-acid-dieu-tri-nam-ma",
     "Cơ chế tác động của tranexamic acid đường bôi và đường uống trong kiểm soát tăng sắc tố.",
     "Tranexamic acid đang trở thành lựa chọn quan trọng trong điều trị nám má nhờ khả năng điều hoà sắc tố.",
     "1612817288484-6f916006741a?w=800&q=80", "1612817288484-6f916006741a?w=600&q=80", "2024-10-05 08:00:00"),
    ("da-dau-toc", "Rụng tóc androgen: tiếp cận chẩn đoán và điều trị",
     "rung-toc-androgen-chan-doan-dieu-tri",
     "Phân biệt rụng tóc androgen với các nguyên nhân khác và các lựa chọn điều trị có bằng chứng.",
     "Rụng tóc androgen là dạng rụng tóc phổ biến nhất, liên quan đến yếu tố di truyền và nội tiết.",
     "1595475207225-428b62bda831?w=800&q=80", "1595475207225-428b62bda831?w=600&q=80", "2024-10-02 08:00:00"),
    ("hoi-dap-da-lieu", "Khi nào cần đi khám bác sĩ da liễu? 7 dấu hiệu cảnh báo",
     "khi-nao-can-kham-bac-si-da-lieu",
     "Những thay đổi trên da bạn không nên bỏ qua và nên đến gặp chuyên gia da liễu càng sớm càng tốt.",
     "Nhiều vấn đề da liễu có thể tự cải thiện, nhưng một số dấu hiệu cần được thăm khám chuyên khoa ngay.",
     "1579684453423-f84349ef60b0?w=800&q=80", "1579684453423-f84349ef60b0?w=600&q=80", "2024-09-28 08:00:00"),
    ("trieu-chung", "Nhận diện sớm triệu chứng vảy nến: từ mảng đỏ đến bong vảy",
     "nhan-dien-som-trieu-chung-vay-nen",
     "Hướng dẫn nhận biết các biểu hiện đặc trưng của vảy nến và phân biệt với các bệnh da khác.",
     "Vảy nến là bệnh viêm da mạn tính qua trung gian miễn dịch với biểu hiện lâm sàng đa dạng.",
     "1559757148-5c350d0d3c56?w=800&q=80", "1559757148-5c350d0d3c56?w=600&q=80", "2024-09-24 08:00:00"),
    ("nghien-cuu-tin-tuc", "Cập nhật nghiên cứu: chất ức chế JAK bôi trong vảy nến mảng",
     "chat-uc-che-jak-boi-vay-nen-mang",
     "Chất ức chế Janus kinase đường bôi mở ra hướng tiếp cận nhắm trúng đích cho viêm da mạn tính.",
     "Chất ức chế JAK đường bôi đại diện cho bước chuyển quan trọng trong điều trị các bệnh da viêm.",
     "1582560475093-ba66accbc424?w=800&q=80", "1582560475093-ba66accbc424?w=600&q=80", "2024-09-20 08:00:00"),
    ("cham-soc-da", "Routine dưỡng da tối giản cho da dầu mụn",
     "routine-duong-da-toi-gian-da-dau-mun",
     "Ba bước cốt lõi giúp kiểm soát dầu và mụn mà không làm tổn thương hàng rào bảo vệ da.",
     "Một quy trình dưỡng da tối giản nhưng đúng đắn thường hiệu quả hơn nhiều bước phức tạp.",
     "1556228453-efd6c1ff04f6?w=800&q=80", "1556228453-efd6c1ff04f6?w=600&q=80", "2024-09-16 08:00:00"),

    # 20 bài mới
    ("benh-da-lieu", "Viêm da tiếp xúc dị ứng: nguyên nhân và cách phòng ngừa",
     "viem-da-tiep-xuc-di-ung-nguyen-nhan-phong-ngua",
     "Hiểu rõ cơ chế phản ứng dị ứng da để tránh tái phát và lựa chọn sản phẩm phù hợp.",
     "Viêm da tiếp xúc dị ứng là phản ứng miễn dịch qua trung gian tế bào T xảy ra sau khi da tiếp xúc lặp lại với dị nguyên.",
     "1588776814546-1ffbb2bfc39b?w=800&q=80", "1588776814546-1ffbb2bfc39b?w=600&q=80", "2024-09-12 08:00:00"),
    ("cham-soc-da", "Retinol và Retinoid: hướng dẫn bắt đầu đúng cách cho người mới",
     "retinol-retinoid-huong-dan-bat-dau-dung-cach",
     "Tránh kích ứng và tận dụng tối đa lợi ích của vitamin A dẫn xuất với lộ trình tăng dần phù hợp.",
     "Retinoid là nhóm hoạt chất chống lão hoá và điều trị mụn có bằng chứng khoa học mạnh nhất, nhưng cần được sử dụng đúng cách để tránh kích ứng.",
     "1620916297397-a4a5402a3c6c?w=800&q=80", "1620916297397-a4a5402a3c6c?w=600&q=80", "2024-09-08 08:00:00"),
    ("dieu-tri", "Liệu pháp ánh sáng (phototherapy) trong điều trị vảy nến nặng",
     "lieu-phap-anh-sang-phototherapy-vay-nen-nang",
     "Cơ chế tác động của tia UVB băng hẹp và PUVA trong kiểm soát bệnh vảy nến diện rộng.",
     "Phototherapy sử dụng bước sóng ánh sáng cụ thể để giảm tốc độ tăng sinh tế bào da và ức chế phản ứng miễn dịch cục bộ.",
     "1559839734-2b71ea197ec2?w=800&q=80", "1559839734-2b71ea197ec2?w=600&q=80", "2024-09-04 08:00:00"),
    ("my-pham-hoat-chat", "AHA và BHA: chọn đúng acid tẩy tế bào chết cho từng loại da",
     "aha-bha-chon-dung-acid-tay-te-bao-chet",
     "Glycolic, lactic, salicylic — phân tích ưu nhược điểm và cách phối hợp an toàn trong skincare hàng ngày.",
     "Acid tẩy tế bào chết (chemical exfoliants) hoạt động hiệu quả và nhẹ nhàng hơn scrub vật lý khi sử dụng đúng nồng độ và tần suất.",
     "1556228852-6d35a585d566?w=800&q=80", "1556228852-6d35a585d566?w=600&q=80", "2024-08-30 08:00:00"),
    ("da-lieu-tre-em", "Hăm tã ở trẻ sơ sinh: phân biệt và điều trị đúng phác đồ",
     "ham-ta-tre-so-sinh-phan-biet-dieu-tri",
     "Phân biệt hăm tã thông thường với nhiễm Candida da và hướng xử trí phù hợp cho từng thể bệnh.",
     "Hăm tã là một trong những vấn đề da liễu phổ biến nhất ở trẻ sơ sinh, ảnh hưởng đến 7–35% trẻ trong giai đoạn mặc tã.",
     "1555252333-9f8e92e65df9?w=800&q=80", "1555252333-9f8e92e65df9?w=600&q=80", "2024-08-26 08:00:00"),
    ("da-dau-toc", "Gàu và viêm da tiết bã: nguyên nhân sâu xa và liệu pháp điều trị",
     "gau-viem-da-tiet-ba-nguyen-nhan-dieu-tri",
     "Vai trò của nấm Malassezia và hướng điều trị kết hợp shampoo y tế với chăm sóc da đầu đúng cách.",
     "Viêm da tiết bã (seborrheic dermatitis) là bệnh mạn tính phổ biến, ảnh hưởng 1–5% dân số, thường biểu hiện dưới dạng gàu dai dẳng kèm ngứa và đỏ da.",
     "1522337360788-8b13dee7a37e?w=800&q=80", "1522337360788-8b13dee7a37e?w=600&q=80", "2024-08-22 08:00:00"),
    ("hoi-dap-da-lieu", "Mụn đầu đen có nên nặn không? Câu trả lời từ bác sĩ da liễu",
     "mun-dau-den-co-nen-nan-khong",
     "Phân tích nguy cơ khi tự nặn mụn tại nhà và các phương pháp loại bỏ mụn đầu đen an toàn, hiệu quả.",
     "Mụn đầu đen (comedone hở) hình thành khi lỗ chân lông bị bã nhờn và tế bào chết bịt kín, tiếp xúc không khí làm oxy hoá thành màu đen.",
     "1616394584738-fc6e612e71b9?w=800&q=80", "1616394584738-fc6e612e71b9?w=600&q=80", "2024-08-18 08:00:00"),
    ("nghien-cuu-tin-tuc", "Liệu pháp sinh học (biologics) thế hệ mới trong điều trị viêm da cơ địa nặng",
     "lieu-phap-sinh-hoc-biologics-viem-da-co-dia-nang",
     "Dupilumab, tralokinumab và các kháng thể đơn dòng mới nhất đang thay đổi diện mạo điều trị viêm da cơ địa.",
     "Liệu pháp sinh học nhắm trúng đích mở ra kỷ nguyên mới cho bệnh nhân viêm da cơ địa nặng không đáp ứng điều trị thông thường.",
     "1631815588090-d4bfec5b7e8e?w=800&q=80", "1631815588090-d4bfec5b7e8e?w=600&q=80", "2024-08-14 08:00:00"),
    ("trieu-chung", "Mề đay mạn tính: phân loại và tiếp cận điều trị theo bậc thang",
     "me-day-man-tinh-phan-loai-dieu-tri-bac-thang",
     "Nhận diện mề đay dị ứng, tự phát và vật lý để lựa chọn kháng histamine thế hệ 2 và omalizumab đúng chỉ định.",
     "Mề đay mạn tính (chronic urticaria) định nghĩa là các sẩn phù và/hoặc phù mạch xảy ra hầu hết các ngày, kéo dài hơn 6 tuần.",
     "1612349317150-e413f6a5b16d?w=800&q=80", "1612349317150-e413f6a5b16d?w=600&q=80", "2024-08-10 08:00:00"),
    ("benh-da-lieu", "Rosacea: nhận biết, phân loại và điều trị đa phương thức",
     "rosacea-nhan-biet-phan-loai-dieu-tri",
     "Hướng dẫn toàn diện về 4 phân loại rosacea và cách kết hợp điều trị tại chỗ với laser để đạt kết quả tối ưu.",
     "Rosacea là bệnh viêm da mạn tính phổ biến ở người da sáng, thường biểu hiện với đỏ mặt kéo dài, giãn mạch và mụn viêm.",
     "1526758097130-bab247274f58?w=800&q=80", "1526758097130-bab247274f58?w=600&q=80", "2024-08-06 08:00:00"),
    ("my-pham-hoat-chat", "Vitamin C trong skincare: dạng nào ổn định và hiệu quả nhất?",
     "vitamin-c-skincare-dang-on-dinh-hieu-qua-nhat",
     "So sánh L-ascorbic acid, ascorbyl glucoside, sodium ascorbyl phosphate và các dẫn xuất Vitamin C về độ ổn định và sinh khả dụng.",
     "Vitamin C (L-ascorbic acid) là chất chống oxy hoá mạnh nhất trong skincare nhưng kém ổn định — đây là lý do thị trường tràn ngập dẫn xuất với tuyên bố 'ổn định hơn'.",
     "1587854692152-cbe660dbde88?w=800&q=80", "1587854692152-cbe660dbde88?w=600&q=80", "2024-08-02 08:00:00"),
    ("da-lieu-tre-em", "Mụn đầu trắng ở trẻ sơ sinh (milia neonatorum): khi nào cần lo lắng?",
     "milia-neonatorum-mun-dau-trang-tre-so-sinh",
     "Phân biệt milia lành tính với các tổn thương mụn nước khác ở trẻ sơ sinh và thời gian chờ tự hết.",
     "Milia neonatorum là những nốt trắng nhỏ 1–2mm do keratin bị giữ lại dưới da, gặp ở 40–50% trẻ sơ sinh khoẻ mạnh.",
     "1559839914-17aae19cec71?w=800&q=80", "1559839914-17aae19cec71?w=600&q=80", "2024-07-28 08:00:00"),
    ("cham-soc-da", "Da hỗn hợp: chiến lược chăm sóc từng vùng (multi-masking)",
     "da-hon-hop-chien-luoc-cham-soc-tung-vung",
     "Kỹ thuật multi-masking và layering sản phẩm để cân bằng vùng T dầu và vùng má khô trong cùng một routine.",
     "Da hỗn hợp — vùng T (trán, mũi, cằm) dầu, vùng má khô hoặc bình thường — đòi hỏi chiến lược chăm sóc linh hoạt, không theo một công thức cứng nhắc.",
     "1571781926291-c477ebfd024b?w=800&q=80", "1571781926291-c477ebfd024b?w=600&q=80", "2024-07-24 08:00:00"),
    ("dieu-tri", "Microneedling và PRP: liệu pháp kết hợp cho tái tạo da",
     "microneedling-prp-lieu-phap-tai-tao-da",
     "Cơ chế kích thích collagen của microneedling và cách PRP tăng cường hiệu quả phục hồi sau thủ thuật.",
     "Microneedling tạo hàng nghìn vi kênh trong da, kích hoạt cascade phục hồi tự nhiên với sự tham gia của yếu tố tăng trưởng và tổng hợp collagen mới.",
     "1570172619644-dfd03ed5d881?w=800&q=80", "1570172619644-dfd03ed5d881?w=600&q=80", "2024-07-20 08:00:00"),
    ("da-dau-toc", "Alopecia areata: hiểu đúng về bệnh rụng tóc từng mảng",
     "alopecia-areata-rung-toc-tung-mang",
     "Cơ chế tự miễn dịch của alopecia areata và các lựa chọn điều trị từ corticoid tiêm tại chỗ đến thuốc ức chế JAK.",
     "Alopecia areata là bệnh tự miễn khiến hệ miễn dịch tấn công nang tóc, gây rụng tóc thành từng mảng hình tròn hoặc bầu dục không có sẹo.",
     "1559757175-0eb30cd8c063?w=800&q=80", "1559757175-0eb30cd8c063?w=600&q=80", "2024-07-16 08:00:00"),
    ("nghien-cuu-tin-tuc", "Microbiome da và trục ruột-da: nghiên cứu tiên phong 2024",
     "microbiome-da-truc-ruot-da-nghien-cuu-2024",
     "Bằng chứng mới về mối liên hệ hai chiều giữa hệ vi sinh đường ruột và tình trạng viêm da, mở ra hướng điều trị probiotic.",
     "Trục ruột-da (gut-skin axis) ngày càng được công nhận là yếu tố quan trọng trong sinh bệnh học của nhiều bệnh da liễu mạn tính.",
     "1559757148-5c350d0d3c56?w=800&q=80", "1559757148-5c350d0d3c56?w=600&q=80", "2024-07-12 08:00:00"),
    ("hoi-dap-da-lieu", "Dùng nhiều serum cùng lúc: thứ tự nào và bao nhiêu là đủ?",
     "dung-nhieu-serum-cung-luc-thu-tu-va-so-luong",
     "Nguyên tắc layering serum theo kết cấu và pH để tối đa hoá hấp thụ mà không gây tương tác tiêu cực.",
     "Skincare layering không phải 'nhiều là tốt' — đúng thứ tự và pH mới là chìa khóa để các hoạt chất hoạt động hiệu quả và không triệt tiêu nhau.",
     "1598440947619-2c35fc9aa908?w=800&q=80", "1598440947619-2c35fc9aa908?w=600&q=80", "2024-07-08 08:00:00"),
    ("benh-da-lieu", "Zona thần kinh: nhận biết sớm và điều trị kháng virus hiệu quả",
     "zona-than-kinh-nhan-biet-som-dieu-tri",
     "Tầm quan trọng của chẩn đoán sớm và dùng antiviral trong 72 giờ đầu để ngăn ngừa đau sau zona mạn tính.",
     "Zona (herpes zoster) do virus varicella-zoster tái hoạt, gây ban mụn nước đau dữ dội theo đường phân phối của một nhánh thần kinh.",
     "1584308666744-24d5c474f2ae?w=800&q=80", "1584308666744-24d5c474f2ae?w=600&q=80", "2024-07-04 08:00:00"),
    ("trieu-chung", "Ngứa toàn thân không rõ nguyên nhân: khi nào là dấu hiệu bệnh nội khoa?",
     "ngua-toan-than-khong-ro-nguyen-nhan-benh-noi-khoa",
     "Phân tích ngứa mạn tính không có tổn thương da nguyên phát và các bệnh nội tạng tiềm ẩn cần loại trừ.",
     "Ngứa toàn thân mạn tính (chronic pruritus) không kèm tổn thương da là dấu hiệu quan trọng cần đánh giá kỹ lưỡng vì có thể là triệu chứng của bệnh nội tạng.",
     "1504439468489-c8920d796a29?w=800&q=80", "1504439468489-c8920d796a29?w=600&q=80", "2024-06-30 08:00:00"),
    ("cham-soc-da", "Chăm sóc da mùa hè: bảo vệ và phục hồi sau tắm nắng",
     "cham-soc-da-mua-he-bao-ve-phuc-hoi-sau-tam-nang",
     "Xây dựng routine mùa hè hoàn chỉnh: chống nắng tối ưu, chống oxy hoá và phục hồi da sau khi tiếp xúc ánh nắng.",
     "Mùa hè là thời điểm da chịu tổn thương UV cao nhất — một routine đúng đắn có thể giảm đến 80% tác hại của ánh nắng trong dài hạn.",
     "1470259078422-826894b933aa?w=800&q=80", "1470259078422-826894b933aa?w=600&q=80", "2024-06-26 08:00:00"),
]


def main():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.set_client_encoding("UTF8")
    cur = conn.cursor()

    print("Inserting categories...")
    cat_id_map = {}
    for name, slug, desc in CATEGORIES:
        cur.execute(
            "INSERT INTO categories (name, slug, description) VALUES (%s, %s, %s) "
            "ON CONFLICT (slug) DO UPDATE SET name=EXCLUDED.name RETURNING id",
            (name, slug, desc)
        )
        cat_id = cur.fetchone()[0]
        cat_id_map[slug] = cat_id
        print(f"  [{cat_id}] {name}")

    print(f"\nInserting {len(ARTICLES)} articles...")
    for art in ARTICLES:
        cat_slug, title, slug, summary, lead, img_full, img_thumb, pub_date = art
        cat_id = cat_id_map.get(cat_slug)
        if not cat_id:
            print(f"  SKIP: unknown category {cat_slug}")
            continue
        content = make_content(lead, f"https://images.unsplash.com/photo-{img_full}")
        thumb_url = f"https://images.unsplash.com/photo-{img_thumb}"
        cur.execute(
            """INSERT INTO articles (category_id, title, slug, summary, content,
               thumbnail_url, status, published_at)
               VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
               ON CONFLICT (slug) DO NOTHING""",
            (cat_id, title, slug, summary, content, thumb_url, "PUBLISHED", pub_date)
        )
        print(f"  OK: {title[:60]}")

    conn.commit()
    cur.close()
    conn.close()

    print("\nDone! Verifying...")
    conn2 = psycopg2.connect(**DB_CONFIG)
    conn2.set_client_encoding("UTF8")
    c2 = conn2.cursor()
    c2.execute("SELECT COUNT(*) FROM categories")
    print(f"Categories: {c2.fetchone()[0]}")
    c2.execute("SELECT COUNT(*) FROM articles")
    print(f"Articles:   {c2.fetchone()[0]}")
    c2.execute("SELECT title FROM articles LIMIT 2")
    for row in c2.fetchall():
        print(f"  Sample: {row[0]}")
    c2.close()
    conn2.close()


if __name__ == "__main__":
    main()
