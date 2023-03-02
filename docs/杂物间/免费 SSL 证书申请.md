# 免费 SSL 证书申请

## [Let's Encrypt ](https://letsencrypt.org/)

> Let’s Encrypt 是一家免费、开放、自动化的证书颁发机构（CA），为公众的利益而运行。 它是一项由 [Internet Security Research Group (ISRG)](https://www.abetterinternet.org/) 提供的服务。

由于 Let’s Encrypt 使用 ACME 协议来验证给定域名的控制权并向颁发证书。因此要获得 Let’s Encrypt 证书，就需要选择一个 ACME 客户端软件进行申请： [ACME 客户端 - Let's Encrypt - 免费的SSL/TLS证书 (letsencrypt.org)](https://letsencrypt.org/zh-cn/docs/client-options/)。

| 能力描述     | 支持情况                                                     |
| ------------ | ------------------------------------------------------------ |
| 是否需要登录 | ×                                                            |
| 单域名证书   | √                                                            |
| 多域名证书   | √                                                            |
| 泛域名证书   | √                                                            |
| 证书有效期   | 90 天                                                        |
| Email 验证   | ×                                                            |
| HTTP 验证    | √                                                            |
| DNS 验证     | √                                                            |
| 证书数量限制 | 接近于无：[https://letsencrypt.org/zh-cn/docs/rate-limits/](https://letsencrypt.org/zh-cn/docs/rate-limits/) |

**注意**：在国内使用 Let’s Encrypt 加密证书时，可能会遇到 OSCP 问题：[Problem with OSCP timeout flag - Help - Let's Encrypt Community Support (letsencrypt.org)](https://community.letsencrypt.org/t/problem-with-oscp-timeout-flag/142752)

## [ZeroSSL](https://zerossl.com/)

[ZeroSSL](https://zerossl.com/) 支持 Web 界面管理证书，并同时提供了 [RESTful](https://zerossl.com/documentation/api/) 和 [ACME](https://zerossl.com/documentation/acme/)接口。

| 能力描述     | 支持情况 |
| ------------ | -------- |
| 是否需要登录 | √        |
| 单域名证书   | √        |
| 多域名证书   | ×        |
| 泛域名证书   | ×        |
| 证书有效期   | 90 天    |
| Email 验证   | √        |
| HTTP 验证    | √        |
| DNS 验证     | √        |
| 证书数量限制 | 3        |

## [FreeSSL](https://freessl.org/home.html)

[FreeSSL](https://freessl.org/home.html) 支持 Web 界面管理证书，并同时提供了 [RESTful](https://zerossl.com/documentation/api/) 和 [ACME](https://zerossl.com/documentation/acme/)接口。

| 能力描述     | 支持情况 |
| ------------ | -------- |
| 是否需要登录 | √        |
| 单域名证书   | √        |
| 多域名证书   | ×        |
| 泛域名证书   | ×        |
| 证书有效期   | 90 天    |
| Email 验证   | √        |
| HTTP 验证    | √        |
| DNS 验证     | √        |
| 证书数量限制 | 无       |

## [CloudFlare](https://www.cloudflare.com/zh-cn/)

CloudFlare 源证书是免费的，但是仅对 Cloudflare 与源服务器之间的加密有效，源证书有效期 15 年。通用证书需要付费。

## [华为云](https://www.huaweicloud.com/)

[华为云](https://www.huaweicloud.com/) 支持 Web 界面管理证书，并提供了 [RESTful](https://zerossl.com/documentation/api/) 接口。

| 能力描述     | 支持情况 |
| ------------ | -------- |
| 是否需要登录 | √        |
| 单域名证书   | √        |
| 多域名证书   | ×        |
| 泛域名证书   | ×        |
| 证书有效期   | 1 年     |
| Email 验证   | ×        |
| HTTP 验证    | ×        |
| DNS 验证     | √        |
| 证书数量限制 | 20       |

## [JoySSL](https://www.joyssl.com/index.html)

[JoySSL](https://www.joyssl.com/index.html) 仅支持 Web 界面管理证书。

| 能力描述     | 支持情况 |
| ------------ | -------- |
| 是否需要登录 | √        |
| 单域名证书   | √        |
| 多域名证书   | √        |
| 泛域名证书   | √        |
| 证书有效期   | 90 天    |
| Email 验证   | ×        |
| HTTP 验证    | √        |
| DNS 验证     | √        |
| 证书数量限制 | 无       |