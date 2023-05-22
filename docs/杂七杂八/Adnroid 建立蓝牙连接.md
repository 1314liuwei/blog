# Android 建立蓝牙连接

1.  申请蓝牙使用权限

   ```xml
   <uses-permission android:name="android.permission.BLUETOOTH"/>
   <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
   ```

2. 请求打开蓝牙

   ```java
   Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
   startActivityForResult(intent,1);
   ```

3. 获取蓝牙适配器

   ```java
   mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
   ```

4. 通过蓝牙设备地址构造 Device

   ```java
   mDevice = mBlueToothAdapter.getRemoteDevice("XX:XX:XX:XX:XX:XX");
   ```

5. 创建 RFCOMM socket，连接到对端蓝牙指定服务

   ```
   UUID mUUID = UUID.fromString("c7f94713-891e-496a-a0e7-983a0946126e");
   mBluetoothSocket = mDevice.createRfcommSocketToServiceRecord(mUUID);
   mBluetoothSocket.connect();
   ```

6. 使用 socket 进行数据收发

   ```java
   // 获取连接 socket 的输入流
   inputStream = mBluetoothSocket.getInputStream();
   // 读取数据
   inputStream.read(buffer);
   
   // 获取连接 socket 的输出流
   outputStream = mBluetoothSocket.getOutputStream();
   // 写入数据
   outputStream.write(buffer);
   ```

7. 关闭 socket

   ```java
   mBluetoothSocket.close();
   ```

   

