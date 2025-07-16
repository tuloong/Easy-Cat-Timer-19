# Easy Cat Timer NSIS 安装程序

## 概述
这个NSIS脚本用于创建Easy Cat Timer的Windows安装程序。

## 系统要求
- Windows 7 或更高版本
- .NET 8.0 运行时（已包含在自包含包中）
- NSIS 3.0 或更高版本

## 安装NSIS
1. 访问 [NSIS官网](https://nsis.sourceforge.io/Download)
2. 下载最新版本的NSIS安装程序
3. 按照提示完成安装

## 构建安装程序

### 方法1：使用批处理文件（推荐）
1. 打开命令提示符或PowerShell
2. 导航到项目根目录
3. 运行：
   ```
   build-installer.bat
   ```

### 方法2：手动构建
1. 首先发布应用程序：
   ```
   dotnet publish "CatTimer WpfProject\CatTimer WpfProject.csproj" -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:PublishReadyToRun=true -p:IncludeNativeLibrariesForSelfExtract=true -o "bin\Release\net8.0-windows\publish\win-x64"
   ```

2. 然后编译NSIS脚本：
   ```
   makensis EasyCatTimerInstaller.nsi
   ```

## 安装程序功能

### 安装特性
- ✅ 自动检测旧版本并卸载
- ✅ 创建开始菜单快捷方式
- ✅ 创建桌面快捷方式（可选）
- ✅ 注册到Windows添加/删除程序
- ✅ 支持静默安装（/S参数）
- ✅ 中文和英文界面支持

### 安装路径
- 默认：C:\Program Files\Easy Cat Timer
- 可自定义安装路径

### 创建的文件
- 主程序：Easy Cat Timer.exe
- 卸载程序：uninstall.exe
- 配置文件：Easy Cat Timer.dll.config
- 资源文件（音频、图片、字体等）

### 注册表项
- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Easy Cat Timer

## 使用命令行参数

### 静默安装
```
EasyCatTimer-v1.0.0-Setup.exe /S
```

### 指定安装目录
```
EasyCatTimer-v1.0.0-Setup.exe /D=C:\MyApps\EasyCatTimer
```

## 卸载程序

### 方法1：通过控制面板
1. 打开控制面板
2. 选择"程序和功能"
3. 找到"Easy Cat Timer"
4. 点击"卸载"

### 方法2：通过开始菜单
1. 打开开始菜单
2. 找到"Easy Cat Timer"文件夹
3. 点击"卸载"

### 方法3：通过命令行
```
"C:\Program Files\Easy Cat Timer\uninstall.exe" /S
```

## 故障排除

### 常见问题
1. **NSIS未找到**：确保已安装NSIS并将其添加到系统PATH
2. **发布失败**：检查是否已安装.NET 8.0 SDK
3. **文件未找到**：确保项目已成功发布到指定目录

### 调试NSIS脚本
1. 使用NSIS的调试模式：
   ```
   makensis /V4 EasyCatTimerInstaller.nsi
   ```

2. 检查日志文件：
   - 安装日志：%TEMP%\nsis.log
   - 卸载日志：%TEMP%\nsis-uninstall.log

## 自定义安装程序

### 修改应用名称和版本
编辑NSIS脚本顶部的宏定义：
```nsis
!define APP_NAME "您的应用名称"
!define APP_VERSION "1.2.3"
!define APP_PUBLISHER "您的公司"
```

### 添加额外文件
在Section "主程序"中添加：
```nsis
File "额外文件路径\*.*"
```

### 修改安装路径
更改默认安装路径：
```nsis
InstallDir "$PROGRAMFILES\您的应用名称"
```