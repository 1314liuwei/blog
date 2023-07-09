# MFA 和 动态令牌（OTP、HOTP、TOTP）

> **多重要素验证**（英语：Multi-factor authentication，缩写为 MFA），又译**多因子认证**、**多因素验证**、**多因素认证**，是一种电脑存取控制的方法，用户要通过两种以上的认证机制之后，才能得到授权。
>
> OTP、HOTP、TOTP都是 MFA 中常用的手段。

## OTP

> **一次性密码**（英语：one-time password，简称**OTP**），又称**动态密码**或**单次有效密码**，是指计算机系统或其他数字设备上只能使用一次的密码，有效期为只有一次登录会话或交易。

## HOTP

> **基于HMAC的一次性密码算法**（英语：HMAC-based One-time Password algorithm，HOTP）是一种基于散列消息验证码（HMAC）的一次性密码（OTP）算法，同时也是开放验证提案的基础（OATH）。

HOTP算法的基本原理如下：

1. 确定一个密钥K和计数器C，其中K是一个共享的密钥，而C是一个递增的计数器，每个用户在使用HOTP算法时都有自己的K和C；
2. 通过HMAC-SHA算法，将K和C结合起来生成一个哈希值H，其中SHA是一种安全哈希算法；
3. 从哈希值H中提取出一个动态密码，通常是取H的末尾几位，并对这个密码进行模运算，得到一个固定长度的数字密码；
4. 将这个数字密码发送给用户，用户输入该数字密码进行身份验证。

由于 HOTP 会依赖于计数器，当用户无意间生成密码，但是又没有使用时，会导致服务端和客户端不同步，这会导致服务端和客户端验证不通过。一般可以采用计算器窗口来解决这个问题。

计数器窗口定义了允许的计数器值范围，客户端和服务器之间的计数器值只需要在该窗口范围内即可被接受。这样，即使客户端和服务器之间存在一定程度的计数器不同步，也可以通过计数器窗口来容忍。

但是如果客户端和服务器之间计数器不同步的差距超过了计数器窗口，那么就需要对客户端和服务端的计数器进行重置来解决这个问题。

### TOTP

> **基于时间的一次性密码算法**（英语：Time-based One-Time Password，简称：**TOTP**）是一种根据预共享的密钥与当前时间计算一次性密码的算法。
>
> TOTP是散列消息认证码（HMAC）当中的一个例子。它结合一个私钥与当前时间戳，使用一个密码散列函数来生成一次性密码。由于网络延迟与时钟不同步可能导致密码接收者不得不尝试多次遇到正确的时间来进行身份验证，时间戳通常以30秒为间隔，从而避免反复尝试。

TOTP算法的原理如下：

1. 客户端和服务器共享一个密钥K；
2. 客户端根据当前时间生成时间戳T，并将T和密钥K作为输入，使用HMAC-SHA算法计算哈希值；
3. 将哈希值截取为4个字节，得到一个32位的整数；
4. 将32位整数对10^d取模，d是TOTP算法中的时间步长，通常为30秒；
5. 将结果补齐为一个固定长度的字符串，例如6位数的动态密码；
6. 将动态密码发送给服务器进行验证。

下面是用 Go 实现的 TOTP Demo：

```go
package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/binary"
	"fmt"
	"time"
)

func generateHOTP(secret []byte, counter uint64, digits int) uint32 {
	// Convert the counter to byte array
	message := make([]byte, 8)
	binary.BigEndian.PutUint64(message, counter)

	// Calculate the HMAC-SHA1
	key := hmac.New(sha1.New, secret)
	key.Write(message)
	hash := key.Sum(nil)

	// Generate the one-time password
	offset := hash[len(hash)-1] & 0x0f
	code := (uint32(hash[offset])&0x7f)<<24 |
		(uint32(hash[offset+1])&0xff)<<16 |
		(uint32(hash[offset+2])&0xff)<<8 |
		(uint32(hash[offset+3]) & 0xff)

	// Truncate the password to the desired number of digits
	mod := uint32(1)
	for i := 0; i < digits; i++ {
		mod *= 10
	}
	code = code % mod

	return code
}

func main() {
	// Example secret key and counter
	secret := []byte("mysecretkey")
	counter := uint64(time.Now().Unix() / 30)

	// Generate the one-time password with 6 digits
	otp := generateHOTP(secret, counter, 6)

	// Print the result
	fmt.Printf("One-Time Password: %06d\n", otp)
}
```

### Google 验证器

Google 开源了一个 `Google Authenticator` APP，这个 APP 支持生成 HOTP 和 TOTP。我们可以使用 Google 验证器帮助我们使用 HOTP 和 TOTP技术。

用户可以在 Google Authenticator 里手动录入 HOTP 和 TOTP 中的 secret，更方便的做法是把密钥转成二维码。Google Authenticator 支持的二维码格式是：

```bash
otpauth://TYPE/LABEL?PARAMETERS
```

`TYPE` 支持 hotp 或 totp；`LABEL` 用来指定用户身份，例如用户名、邮箱或者手机号，前面还可以加上服务提供者，需要做 URI 编码。它是给人看的，不影响最终校验码的生成。

`PARAMETERS` 用来指定参数，它的格式与 URL 的 Query 部分一样，也是由多对 key 和 value 组成，也需要做 URL 编码。可指定的参数有这些：

- **secret**：必须，密钥 K，需要编码为 base32 格式；
- **algorithm**：可选，HMAC 的哈希算法，默认 SHA1。Google Authenticator 不支持这个参数；
- **digits**：可选，校验码长度，6 位或 8 位，默认 6 位。Google Authenticator 不支持这个参数；
- **counter**：可选，指定 HOTP 算法中，计数器 C 的默认值，默认 0；
- **period**：可选，指定 TOTP 算法中的间隔时间 TS，默认 30 秒。Google Authenticator 不支持这个参数；
- **issuer**：可选（强烈推荐），指定服务提供者。这个字段会在 Google Authenticator 客户端中单独显示，在添加了多个服务者提供的 2FA 后特别有用。

另外，Google Authenticator 也不支持指定 TOTP 算法中起始时间戳 T0。下面是两个完整的例子，将他们生成二维码，通过 Google Authenticator 扫描就可以添加进去了：

```
otpauth://hotp/TEST:example@mail.com?secret=IBED6ZJDF4UWST3YKM3DK2ZQHFUDQZZSIRFD6L2FMF3FEN2DINZQ&issuer=ququblog&counter=0
otpauth://totp/TEST:example@mail.com?secret=IBED6ZJDF4UWST3YKM3DK2ZQHFUDQZZSIRFD6L2FMF3FEN2DINZQ&issuer=ququblog
```

有关 Google Authenticator 二维码格式的更多说明，可以参考[官方 wiki](https://github.com/google/google-authenticator/wiki/Key-Uri-Format)。 
