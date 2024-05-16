# gitlab API 访问数据

## 1. 命令行生成 Personal Access Token

```bash
# 输入以下命令进入控制台
gitlab-rails console

output:
--------------------------------------------------------------------------------
 Ruby:         ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-linux]
 GitLab:       13.6.3 (857c6c6a6a9) FOSS
 GitLab Shell: 13.13.0
 PostgreSQL:   11.9
--------------------------------------------------------------------------------
Loading production environment (Rails 6.0.3.3)
irb(main):001:0> 
```

生成 Token：

```ruby
user = User.find_by_user('Administrator')
token = user.personal_access_tokens.create(scopes: [:api, :sudo], name: 'Automation token')
token.set_token('token-string-here12345')
token.save
```

![image-20220322122124653](https://pic.try-hard.cn/blog/image-20220322122124653.png)

## 2. 使用 API 访问接口

**示例**：

```bash
# 访问所有 project
curl --header "PRIVATE-TOKEN: token-string-here12345" http://127.0.0.1/api/v4/projects | python -m "json.tool"
```

常用接口：

- 查看所有 project： [Projects API | GitLab](https://docs.gitlab.com/ee/api/projects.html#list-all-projects)
- 下载仓库代码：[Projects API | GitLab](https://docs.gitlab.com/ee/api/projects.html#list-all-projects)