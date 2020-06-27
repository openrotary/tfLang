!form :label-width(80) label-position(80)

- username / 用户名 : 请输入用户名

- password / 密码 : 请输入密码
> type password
    >> Icon type(ios-person-outline) slot(prepend)

- code / 验证码 : 请输入验证码
~ !('blur') : 验证码不可为空
~ mix(2) type('string') max(10) : 长度不符合要求
> number

@select
- city / 城市 : 请选择你所在的城市
> 1 / 北京
> 2 / 上海
> 3 / 广州
> 4 / 深圳

@radio
- sex
~ !('blur') : 性别不可为空
> 1 / 男
> 0 / 女

@checkbox
- hobby / 爱好 : 请选择你的爱好
> Eat, sleep, run, movie

@my
- * / 日期时间
> Row 
    >> Col span(12) 
        >>> - date / * : Select date
            / :style color:#fff
    >> Col span(2) style(text-align: center) : -
    >> Col span(11) 
        >>> - time / * : Select Time