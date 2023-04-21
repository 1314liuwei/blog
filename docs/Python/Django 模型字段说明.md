# Django 模型字段说明

> 在 Django 的 ORM 模型中，有许多内置的模型字段可供开发人员使用，掌握这些字段的作用将帮助开发人员大大节省开发时间

# 字段
- **AutoField:** 一个自动递增的整型字段，添加记录时它会自动增长。AutoField字段通常只用于充当数据表的主键；如果在模型中没有指定主键字段，则Django会自动添加一个AutoField字段；
- **BigIntegerField:** 64位整型字段；
- **BinaryField:** 二进制数据字段，只能通过bytes对其进行赋值；
- **BooleanField:** 布尔字段，相对应的HTML标签是 **\<input type="checkbox">；**
- **CharField:** 字符串字段，用于较短的字符串，相对应的HTML标签是单行输入框 **\<input type="text">；**
- **TextField:** 大容量文本字段，相对应的HTML标签是多行编辑框 **\<textarea>**；
- **CommaSeparatedIntegerField:** 用于存放逗号分隔的整数值，相对于普通的CharField，它有特殊的表单数据验证要求；
- **DateField:** 日期字段，相对应的HTML标签是 **\<input type="text">**、一个JavaScript日历和一个“**Today**”快捷按键。有下列额外的可选参数：**auto_now**，当对象被保存时，将该字段的值设置为当前时间；**auto_now_add**，当对象首次被创建时，将该字段的值设置为当前时间；
- **DateTimeField:** 类似于DateField，但同时支持时间输入；
- **DurationField:** 存储时间周期，用Python的timedelta类型构建；
- **EmailField:** 一个带有检查Email合法性的CharField；
- **FileField:** 一个文件上传字段。在定义本字段时必须传入参数upload_to，用于保存上载文件的服务器文件系统的路径。这个路径必须包含strftime formatting，该格式将被上载文件的date/time替换；
- **FilePathField:** 按目录限制规则选择文件，定义本字段时必须传入参数path，用以限定目录；
- **FloatField:** 浮点型字段。定义本字段时必须传入参数max_digits和decimal_places，用于定义总位数（不包括小数点和符号）和小数位数；
- **ImageField:** 类似于 FileField，同时验证上传对象是否是一个合法图片。它有两个可选参数，即height_field和width_field。如果提供这两个参数，则图片将按提供的高度和宽度规格保存。该字段要求安装Python Imaging库；
- **IntegerField:** 用于保存一个整数；
- **IPAddressField:** 一个字符串形式的IP地址，比如“129.23.250.2”；
- **NullBooleanField:** 类似于BooleanField，但比其多一个None选项；
- **PhoneNumberField:** 带有美国风格的电话号码校验的CharField（格式为×××-×××-××××）；
- **PositiveIntegerField：** 只能输入非负数的IntegerField。
- **SlugField：** 只包含字母、数字、下画线和连字符的输入字段，它通常用于URL；
- **SmallIntegerField:** 类似于IntegerField，但只具有较小的输入范围，具体范围依赖于所使用的数据库；
- **TimeField:** 时间字段，类似于DateTimeField，但只能表达和输入时间；
- **URLField:** 用于保存URL；
- **USStateField:** 美国州名的缩写字段，由两个字母组成；
- **XMLField:** XML字符字段，是具有XML合法性验证的TextField。