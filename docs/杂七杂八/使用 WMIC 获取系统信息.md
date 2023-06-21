# 使用 WMIC 获取系统信息

> WMI（Windows Management Instrumentation，Windows管理工具）是 Windows 提供的一组管理接口，用户可以使用 WMI 管理本地和远程计算机。

打开 Windows Terminal 输入 `wmic /?` 可以查看 `wmic` 的用法。

下面是一些通过 wmic 获取系统信息的例子：

- 获取磁盘信息：

  ```bash
  wmic diskdrive get /format:list
  ```

- 获取主板信息：

  ```bash
   wmic baseboard get /format:list
  ```

- 获取计算机系统管理信息：

  ```bash
  wmic computersystem get /format:list
  ```

- 获取系统卷信息：

  ```bash
  wmic volume get /format:list
  ```

- 获取 CPU 信息：

  ```bash
  wmic volume get /format:list
  ```

- 获取内存信息：

  ```bash
  wmic memorychip get /format:list
  ```

- 获取已安装系统信息：

  ```bash
  wmic os get /format:list
  ```

- 获取进程管理信息：

  ```bash
  wmic process get /format:list
  ```

- 获取 BIOS 信息：

  ```bash
  wmic bios get /format:list
  ```

















