# -*- coding: utf-8 -*-
from docx import Document
from docx.shared import Pt, RGBColor

doc = Document()
style = doc.styles["Normal"]
style.font.name = "Calibri"
style.font.size = Pt(16)
style.paragraph_format.space_after = Pt(10)
style.paragraph_format.line_spacing = 1.15

def heading(text):
    p = doc.add_heading(text, level=1)
    for run in p.runs:
        run.font.color.rgb = RGBColor(0xC4, 0x45, 0x1A)
        run.font.size = Pt(22)

def say(text):
    p = doc.add_paragraph(text)
    for run in p.runs:
        run.font.size = Pt(16)

blocks = [
("Slide 1",
"Hôm nay em nói về cách app chuyển màn. App em làm là Yummy, app đặt đồ ăn. App có nhiều màn: màn đăng nhập, màn danh sách quán, màn đơn hàng, màn tài khoản.\n\n"
"Navigation là việc người dùng đi từ màn này sang màn khác. Ví dụ đang ở màn đăng nhập, bấm Login, thì sang màn danh sách quán.\n\n"
"Mỗi màn em gắn một địa chỉ, gọi là route. Địa chỉ viết bằng dấu gạch chéo, giống đường dẫn trên web. Nhìn địa chỉ là biết app đang đứng ở màn nào.\n\n"
"/login là địa chỉ màn đăng nhập. Chữ login là tên màn đó.\n\n"
"/0 là màn chính, tab đầu tiên, tên Explore, nơi hiện danh sách quán. Số 0 là tab thứ nhất. Em đếm từ 0, nên tab kế tiếp là /1, tab đơn hàng, và /2 là tab tài khoản."),
("Slide 2",
"Em đi sáu ý: cách chuyển màn cũ, cách mới, thư viện go_router, số trên địa chỉ, luật đăng nhập, rồi demo."),
("Slide 3",
"Cách cũ gọi là Navigator 1.0. Có hai lệnh.\n\n"
"Push là đặt thêm một màn lên trên. Đang xem danh sách quán, bấm một quán, trang món được đẩy lên và che danh sách.\n\n"
"Pop là lấy màn trên cùng ra. Đang ở trang món, bấm quay lại, trang món biến mất và danh sách quán hiện lại.\n\n"
"Các trang giống một chồng đĩa. Đĩa mới đặt lên trên. Chỉ đĩa trên cùng là người dùng nhìn thấy.\n\n"
"Cách này ổn với app nhỏ, hoặc một hộp thoại. App của em có đăng nhập, ba tab, rồi còn trang từng quán. Nếu mỗi nút tự push một trang thì đường đi nằm rải nhiều file, khó chỉ cho người khác. Trên web, địa chỉ cũng không đổi theo màn.\n\n"
"App Yummy hiện không dùng push để đi giữa các màn chính. Em đổi địa chỉ, ví dụ từ /0 sang /0/restaurant/2."),
("Slide 4",
"Nên em không rải lệnh mở trang nữa. Em để một danh sách trang ở một chỗ. Bấm nút thì trạng thái đổi, ví dụ vừa đăng nhập xong. Router nhìn trạng thái đó, dựng lại danh sách, rồi hiện đúng trang.\n\n"
"Nhìn địa chỉ là biết đang ở màn nào. Trang nào hiện là do trạng thái quyết định. Đường đi nằm gom một chỗ."),
("Slide 5",
"Em dùng thư viện go_router để giữ danh sách đó, đỡ viết phần router bên dưới. Trong project là bản ^14.0.0. Dòng này nằm trong file pubspec.yaml, là chỗ khai báo thư viện, không phải lệnh chạy lúc mở app. Trong main.dart có dòng import package:go_router/go_router.dart. Thư viện này do đội Flutter giữ.\n\n"
"Mở app từ một link bên ngoài là phần sau, hôm nay em chưa làm."),
("Slide 6",
"Danh sách địa chỉ nằm trong lib/main.dart.\n\n"
"Mở app thì vào /login, tức màn đăng nhập. Bấm Login thì qua /0, tab Explore, màn danh sách quán. /1 là Orders, màn đơn hàng. /2 là Account, màn tài khoản.\n\n"
"Dấu hai chấm là chỗ điền số. restaurant/:id là số của quán, nên một quán có địa chỉ kiểu /0/restaurant/2. Số 0 vẫn là tab Explore, số 2 là quán thứ ba trong danh sách.\n\n"
"MaterialApp.router là dòng gắn danh sách địa chỉ này vào app."),
("Slide 7",
"Lấy /0/restaurant/2 làm ví dụ. Số 0 là tab Explore, màn danh sách quán. Chữ restaurant là đang mở trang một quán. Số 2 là quán Bistro De Paris.\n\n"
"App lấy số 2 từ pathParameters, khóa id, rồi vẽ đúng quán. Lúc demo em bấm đúng quán đó.\n\n"
"Quán số 0 là The Blue Prawn. Quán số 1 là Mama Rosa's Pizza. Đếm từ 0."),
("Slide 8",
"Redirect là luật kiểm tra trước khi cho vào một trang. Hàm tên _appRedirect, gắn trong main.dart.\n\n"
"Chưa đăng nhập thì về /login, tức màn đăng nhập. Đã đăng nhập mà còn đứng ở Login thì đưa vào /0, màn Explore. Còn lại thì ở yên.\n\n"
"Tên với mật khẩu em không kiểm tra, gõ gì cũng vào được. App chỉ nhớ đã đăng nhập hay chưa."),
("Slide 9 — demo",
"Em demo trên Chrome để mọi người thấy địa chỉ đổi trên thanh địa chỉ. Máy ảo là cùng app trên điện thoại, điện thoại không có thanh địa chỉ.\n\n"
"Nếu Chrome không ở Login, bấm Account rồi Log out.\n\n"
"1. Chỉ thanh địa chỉ /login. Nói: đây là màn đăng nhập. Gõ gì cũng được. Bấm Login.\n\n"
"2. Địa chỉ thành /0. Nói: sang tab Explore, danh sách quán. Chỉ máy ảo: bên này là điện thoại, không hiện /0, nhưng bấm Login thì cũng ra màn này.\n\n"
"3. Bấm Orders, thấy /1, màn đơn hàng. Bấm Account, thấy /2, màn tài khoản. Nói: mỗi tab là một số. Về Explore.\n\n"
"4. Bấm Bistro De Paris. Thấy /0/restaurant/2. Nói: số 0 là tab Explore, số 2 là quán này.\n\n"
"5. Chọn một món, Add to Cart, Items in cart, Submit Order. Thành /1. Nói: đặt xong thì em đưa sang màn đơn.\n\n"
"6. Log out, về /login.\n\n"
"7. Gõ /0 rồi Enter. App kéo về Login. Nói: chưa đăng nhập thì không vào các tab được. Phần gõ địa chỉ chỉ làm trên Chrome."),
("Slide 10",
"Em tóm lại. Cách cũ là push với pop, hợp app nhỏ. Cách em dùng là một danh sách trang. go_router giữ danh sách đó. Số trên địa chỉ cho biết tab nào, quán nào. Redirect kéo về đúng trang. MaterialApp.router gắn danh sách vào app."),
("Slide 11",
"Em xin hết."),
]
for title, text in blocks:
    heading(title)
    for para in text.split("\n\n"):
        say(para)

doc.save(r"C:\Users\Thien An\Downloads\Bai-noi-Chapter-8.docx")
print("saved")
