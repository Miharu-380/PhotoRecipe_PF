Admin.create!(
   email: ENV['ADMIN_USERNAME'],
   password: ENV['ADMIN_PASSWORD']
)

User.create!(
   name: "緑谷出久",
   username: "dekudeku",
   email: "deku@deku.com",
   profile_image: File.open('./app/assets/images/deku.jpg'),
   password: '123456',
   introduction: "プルスウルトラ！"
)
  
User.create!(
   name: "麗日お茶子",
   username: "urabity",
   email: "ocha@ocha.com",
   profile_image: File.open('./app/assets/images/ocha.jpg'),
   password: '123456',
   introduction: "無重力にするのが得意です"
)

User.create!(
   name: "蛙水梅雨",
   username: "tsuyuyu",
   email: "asui@asui.com",
   profile_image: File.open('./app/assets/images/tsuyu.jpg'),
   password: '123456',
   introduction: "海が好き。"
)

User.create!(
   name: "八百万百",
   username: "m0momo",
   email: "momo@momo.com",
   profile_image: File.open('./app/assets/images/momo.jpg'),
   password: '123456',
   introduction: "ディズニーとカフェ巡りが好きです"
)

User.create!(
   name: "爆豪勝己",
   username: "ka_chan",
   email: "baku@gou.com",
   profile_image: File.open('./app/assets/images/bakugou.jpg'),
   password: '123456',
   introduction: "カップル写真をよく撮ります"
)

User.create!(
   name: "轟焦凍",
   username: "shoooooooto",
   email: "todo@roki.com",
   profile_image: File.open('./app/assets/images/shoto.jpg'),
   password: '123456',
   introduction: "多重露光"
)