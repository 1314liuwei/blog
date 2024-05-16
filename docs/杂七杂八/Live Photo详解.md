# Live Photo 详解

实况照片是苹果公司首先在 iPhone 6S 上发布的一个功能，后面安也同样发布了类似的功能。

在实况开启之后，相机会自动记录按下快门前后各1.5秒的画面，实况照片默认是静止的，长按实况照片可以显示视频。

## 苹果——Live Photos

苹果拍摄 Live Photos 实际上是包含一个图片文件（开启高效模式为 HEIC 格式，未开启为 JPG 格式）和一个 MOV 的视频文件。

如下测试文件：

MOV 视频：[MOV](https://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/1675405539.MOV)

JGP 图片：[JPG](https://pic.try-hard.cn/blog/2023/02/03/20230203-142744.JPG)

使用 [exiftool](https://exiftool.org/) 查看两个文件的 metadata，图片的元数据中有一个 **Media Group UUID**：

```
Media Group UUID                : 764134D7-D2D7-4B70-99FE-63FCF10E57BC
```

MOV 视频中有一个 **Content Identifier**：

```
Content Identifier              : 764134D7-D2D7-4B70-99FE-63FCF10E57BC
```



**当一个照片文件和一个视频文件名字相同（后缀不一样），且 metadata 中包含各自所需的字段，且两个字段的 UUID 一样时，就可以调用照片应用的 API 将这两个文件关联为一个 Live Photos 资源，关联成功后就会在照片中显示 Live Photos。**

可以发现，苹果的 Live Photos 实际上是苹果的照片应用将视频和图片进行了一个组合显示, 下面是一个使用 swift 导入 Live Photos 的例子:

```swift
func exportLivePhoto () {
	PHPhotoLibrary.shared().performChanges({ () -> Void in
		let creationRequest = PHAssetCreationRequest.forAsset()
		let options = PHAssetResourceCreationOptions()

        // 添加 MOV 
		creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: FilePaths.VidToLive.livePath + "/IMG.MOV"), options: options)
        // 添加 图片
		creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: FilePaths.VidToLive.livePath + "/IMG.JPG"), options: options)
            
		}, completionHandler: { (success, error) -> Void in
		if !success {
			DTLog((error?.localizedDescription)!)
		}
	})
}
```



## 安卓——Motion Photos

Motion Photos 是安卓采用的 Live Photo 方案, Motion Photos 和 苹果的 Live Photos 不同, Motion Photos 是一个 JPG 格式的图片, 他在文件内部嵌入了 Video 的数据, 文件内部结构如下所示: 

![img](https://pic.try-hard.cn/blog/2023/02/03/20230203-145358.png)

<center>Motion Photo structure</center>

下面是一张使用小米手机拍摄的 Motion Photos: [Motion Photos](https://pic.try-hard.cn/blog/2023/02/03/20230203-150007.jpg)

使用 exiftool 查看它的 metadata, 会发现如下信息:

```
Micro Video Version             : 1
Micro Video                     : 1
Micro Video Offset              : 1734313
Micro Video Presentation Timestamp Us: 861243
```

这个就是隐藏在图片中的视频的信息了, 使用 dd 命令提取出视频来: 

```bash
# bs = filesize - Micro Video Offset
dd if=motion.jpg of=video.mp4 bs=2979693 skip=1
```

提取出来的视频如链接所示: [Motion Video](https://blog-img-figure.oss-cn-chengdu.aliyuncs.com/img/2023/02/03/1675408232.mp4)