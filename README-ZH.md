# assets_generator

用于自动生成 assets 配置 (yaml) 以及 consts 的工具，支持单项目和多模块。

[![pub package](https://img.shields.io/pub/v/assets_generator.svg)](https://pub.dartlang.org/packages/assets_generator) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/assets_generator)](https://github.com/fluttercandies/assets_generator/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/assets_generator)](https://github.com/fluttercandies/assets_generator/network) [![GitHub license](https://img.shields.io/github/license/fluttercandies/assets_generator)](https://github.com/fluttercandies/assets_generator/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/assets_generator)](https://github.com/fluttercandies/assets_generator/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

![](assets_generator.gif)

Languages: [English](README.md) | 中文简体

- [assets_generator](#assets_generator)
  - [使用](#使用)
    - [环境准备](#环境准备)
    - [激活 assets_generator](#激活-assets_generator)
    - [操作命令](#操作命令)
      - [帮助命令](#帮助命令)
      - [生成命令的例子](#生成命令的例子)
      - [全部命令](#全部命令)
    - [Dart](#dart)
      - [在单个项目中使用](#在单个项目中使用)
      - [在模块中使用](#在模块中使用)

## 使用

###  环境准备

把 pub bin 的路径放到你的系统路径中。

| Platform       |     Cache  location     |
| -------------- | :---------------------: |
| macOS or Linux |  $HOME/.pub-cache/bin   |
| Windows*       | %APPDATA%\Pub\Cache\bin |

[pub global](https://dart.dev/tools/pub/cmd/pub-global)

### 激活 assets_generator

 执行 `dart pub global activate assets_generator`

### 操作命令

#### 帮助命令

`agen -h`

 #### 生成命令的例子

`agen -t d -s -r lwu`

#### 全部命令

``` markdown
-h, --[no-]help     显示帮助信息
-p, --path          Flutter 项目的根路径
                    (默认 ".")
-f, --folder        assets 文件夹的名字
                    (默认 "assets")
-w, --[no-]watch    是否继续监听 assets 的变化
                    (默认 开启)
-t, --type          pubsepec.yaml 生成配置的类型
                    "d" 代表以文件夹方式生成 "- assets/images/"
                    "f" 代表以文件方式生成   "- assets/images/xxx.jpg"
                    (默认 "d")
-s, --[no-]save     是否保存命令到本地
                    如果执行 "agen" 不带任何命令，将优先使用本地的命令进行执行
-o, --out           const 类放置的位置
                    (默认放置在 "lib" 下面)
-r, --rule          consts 的名字的命名规范
                    "lwu"(小写带下划线) : "assets_images_xxx_jpg"
                    "uwu"(大写带下划线) : "ASSETS_IMAGES_XXX_JPG"
                    "lcc"(小驼峰)      : "assetsImagesXxxJpg"
                    (默认 "lwu")
-c, --class         const 类的名字
                    (默认 "Assets")
    --const-ignore  使用正则表达式忽略一些const(不是全部const都希望生成)
```

### Dart

#### 在单个项目中使用

``` dart
    Image.asset(Assets.assets_images_xxx_jpg);
```

#### 在模块中使用

``` dart
    Image.asset(
      Assets.assets_images_xxx_jpg,
      package: Assets.package,
    );
```