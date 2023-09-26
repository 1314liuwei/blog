# L2CAP COC 调研

iOS提供了两种蓝牙通讯方式：GATT 和 L2CAP Channels。L2CAP Channels 适合传输大数据的流式的，GATT 只能一次取出单个数据。

[712_whats_new_in_core_bluetooth.pdf](https://drive.weixin.qq.com/s?k=AF4AIgfmAHU660Xm9fATkAHgY5ADg) （WWDC17 - What’s New in Core Bluetooth）

> 注：L2CAP Channels 全称应该是 L2CAP Connection-Oriented Channel，一般缩写为 L2CAP CoC。这是一项 BR/EDR（Bluetooth Classic）上的特性，蓝牙4.1版本在 LE (Low Energy) 中支持了这个特性。单独的 L2CAP (Logical Link Control and Adaptation Protocol) 一词是指底层的链路层协议，而不是 Channel 。BLE上除了CID 5处理Advertising是Connectionless以外，其余的Channel都是Connction-Oriented。在BLE上，ATT使用CID 4。
>
> L2CAP is packet-based but follows a communication model based on channels. A channel represents a data flow between L2CAP entities in remote devices. Channels may be connection-oriented or connectionless. All channels other than the L2CAP connectionless channel (CID 0x0002) and the two L2CAP signaling channels (CIDs 0x0001 and 0x0005) are connection-oriented.

Host 通过 HCI_Set_Connection_Encryption 告诉 LM 需要加密，双方 LM 通过 LMP_encryption_mode_req 协商是否启用加密。当后续连接建立时，将触发配对。

Host 通过 HCI_Set_Connection_Encryption 告诉 LM 需要加密，双方 LM 通过 LMP_encryption_mode_req 协商是否启用加密。当后续连接建立时，将触发配对。

# **iOS**

扫描：

iOS 通过 CoreBluetooth 框架进行扫描到的所有蓝牙设备都是在进行 BLE 广播的设备。

CoreBluetooth 扫描到的设备都会有一个 UUID，这个 UUID 是基于设备 MAC + 时间戳生成，和 Android 上直接扫描到设备的 MAC 不同。

```swift
func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?,options: [String : Any]? = nil)
```

监听：

```swift
// CBPeripheralManager 
func publishL2CAPChannel(withEncryption encryptionRequired: Bool)
```

[publishL2CAPChannel(withEncryption:) | Apple Developer Documentation](https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/2880160-publishl2capchannel)

连接：

```swift
// CBPeripheral
func openL2CAPChannel(_ PSM: CBL2CAPPSM)
```

[CBPeripheralManager | Apple Developer Documentation](https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager?language=objc)

以上API，iOS11 支持。

# **Android**

监听：

```swift
// BluetoothAdapter
public BluetoothServerSocket listenUsingInsecureL2capChannel ()
public BluetoothServerSocket listenUsingL2capChannel ()
```

[BluetoothAdapter | Android Developers](https://developer.android.com/reference/android/bluetooth/BluetoothAdapter#listenUsingInsecureL2capChannel())

连接：

```
BluetoothDevice
public BluetoothSocket createInsecureL2capChannel (int psm)
public BluetoothSocket createL2capChannel (int psm)
```

[BluetoothDevice | Android Developers](https://developer.android.com/reference/android/bluetooth/BluetoothDevice#createInsecureL2capChannel(int))

以上API，API Level 29 支持。

# **Linux**

Linux 上 [bluez](http://www.bluez.org/) 服务对底层接口进行了封装，bluez 提供了 DBus 接口对蓝牙服务进行管理，bluez 相关 DBus 接口文档地址：https://github.com/bluez/bluez/tree/master/doc



通过 bluez 进行 BLE 广播：https://github.com/bluez/bluez/blob/master/test/example-advertisement

使用 bluez 提供  GATT server：https://github.com/bluez/bluez/blob/master/test/example-gatt-server

使用 bluez 提供 L2CAP COC server （官方尚未实现）：[Proper way to  create Custom LE Profile using LE COC over Bluez DBUS API · Issue #183 · bluez/bluez · GitHub](https://github.com/bluez/bluez/issues/183)



使用 bluer-tools 提供的 l2cat 命令实现 L2CAP COC server：https://github.com/bluez/bluer/blob/master/bluer-tools/src/l2cat.rs

具体内部实现逻辑需要查看对应的 Rust 源码

# **待调研**

## **跨系统连接**

**Q**: iOS / Android 是否能连接上 Linux 监听的 L2CAP Channel ？

注：Berty 使用了未加密的 Channel，在 Android 和 iOS 之间应该是可连通的。

[GitHub - berty/berty: Berty is a secure peer-to-peer messaging app that works with or without internet access, cellular data or trust in the network](https://github.com/berty/berty)

**A**: 使用非安全通道可以进行联通，安全通道尚未进行尝试。

![img](http://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/09/26/20230926-213300)