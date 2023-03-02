# Go 执行 shell 命令
```go
func SystemCall(ctx context.Context, cmd string) error {
	var (
		command *exec.Cmd
		out     bytes.Buffer
		stderr  bytes.Buffer
	)

	log.Printf("exec command: %s \n", cmd)
	// 执行连续的shell命令时, 需要注意指定执行路径和参数, 否则运行出错
    // os.ExpandEnv 可以解析命令中的环境变量
	command = exec.CommandContext(ctx, "/bin/sh", "-c", os.ExpandEnv(cmd))
    
	command.Stdout = &out	  // 获取系统命令执行输出
	command.Stderr = &stderr  // 获取系统命令执行错误时的输出
	if err := command.Run(); err != nil {
		err1 := errors.New(fmt.Sprintf("%s -> %s", err.Error(), stderr.String()))  // 拼接错误
		return err1
	}

	return nil
}
```

