#! :label-width(80) label-position(right) style(width:500px)

- 用户名 : username / 请输入用户名
~ !! on('blur') / 必填项

- 密码 : password / 请输入密码
~ !! on('change') / 密码是必填项
~ min(6) max(10) / 长度必须在6到10位之间

- 手机号码 : phone / 请输入手机号码
~ !! on('blur') / 手机号码是必填项
