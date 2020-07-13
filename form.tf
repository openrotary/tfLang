#! :label-width(80) label-position(left)

- username / 用户名 : 请输入用户名
~ !('blur') : 必填项

- password / 密码 : 请输入密码
~ !('change') : 密码是必填项
~ min(6) max(23) : 长度必须在6到24位之间
> type password
    >> Icon type(ios-person-outline) slot(prepend)

