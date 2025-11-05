# Yicore

一个 Flutter UI 组件库演示项目，提供丰富且美观的自定义组件。

## 项目简介

Yicore 是一个课表管理工具，支持多种课程表格式导入，支持多种平台。本项目同时也是 Flutter UI 组件库的演示项目，展示了各种自定义组件的使用方法。

## 版本信息

- **当前版本**: 2.1.0+1
- **Flutter SDK**: >=3.5.0 <4.0.0

## 功能特性

### 基础组件

- **YicoreButton** - 自定义按钮（支持主要、次要、轮廓、加载状态）
- **YicoreTextField** - 自定义输入框（支持标签、提示、错误状态）
- **YicoreSwitch** - 自定义开关
- **YicoreSlider** - 自定义滑块
- **YicoreCard** - 自定义卡片容器
- **YicoreFab** - 悬浮窗按钮（支持自定义图标、颜色、大小）

### 设置组件

- **SettingsBlock** - 设置区块容器
- **SettingsItem** - 设置项（支持开关、滑块、文本值、纯文本等类型）

### 对话框组件

- **YicoreAlert** - 提示对话框
- **YicoreConfirm** - 确认对话框
- **YicoreModal** - 模态对话框
- **YicoreAnnouncement** - 公告对话框

### 通知组件

- **Notifications.sonner()** - Sonner 风格通知系统，支持标题、消息、操作按钮

### 导航组件

- **YicoreBottomNavigationBar** - 自定义底部导航栏，带平滑动画效果

### 日期时间组件

- **YicoreDatePicker** - 日期选择器
- **YicoreDatePickerButton** - 日期选择按钮
- **YicoreTimePicker** - 时间范围选择器（底部弹窗，格式：HH:mm-HH:mm）

## 项目结构

```
lib/
├── main.dart              # 主入口和演示页面
├── components.dart         # 基础组件（按钮、输入框、开关、滑块）
├── cards.dart             # 卡片组件
├── settingscard.dart      # 设置相关组件
├── dialogs.dart           # 对话框组件
├── notifications.dart     # 通知组件
├── navigation.dart        # 导航组件
├── datepicker.dart        # 日期选择器
└── timepicker.dart        # 时间范围选择器
```

## 快速开始

### 安装依赖

```bash
flutter pub get
```

### 运行项目

```bash
flutter run
```

### 构建项目

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

## 使用示例

### 按钮组件

```dart
YicoreButton(
  text: '主要按钮',
  onPressed: () {
    // 处理点击事件
  },
)

YicoreButton(
  text: '次要按钮',
  isSecondary: true,
  onPressed: () {},
)

YicoreButton(
  text: '轮廓按钮',
  isOutlined: true,
  onPressed: () {},
)
```

### 日期选择器

```dart
YicoreDatePicker.show(
  context: context,
  initialDate: DateTime.now(),
  onDateSelected: (date) {
    print('选择的日期: $date');
  },
)
```

### 悬浮窗按钮

```dart
// 在 Stack 中使用
Stack(
  children: [
    // 你的内容
    Positioned(
      bottom: 24,
      right: 24,
      child: YicoreFab(
        icon: Icons.add,
        tooltip: '添加',
        onPressed: () {
          // 处理点击事件
        },
      ),
    ),
  ],
)

// 自定义颜色和大小
YicoreFab(
  icon: Icons.favorite,
  size: 56,
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  onPressed: () {},
)
```

### 通知组件

```dart
Notifications.sonner(
  context,
  title: '操作成功',
  message: '您的操作已成功完成',
  actionText: '撤销',
  onAction: () {
    // 处理撤销操作
  },
)
```

### 对话框组件

```dart
// Alert 提示
YicoreAlert.show(
  context,
  title: '提示',
  message: '这是一个提示对话框',
)

// Confirm 确认
final result = await YicoreConfirm.show(
  context,
  title: '确认操作',
  message: '确定要执行此操作吗？',
  onConfirm: () {
    print('用户确认');
  },
)
```

## 依赖项

- `flutter` - Flutter SDK
- `font_awesome_flutter: ^10.7.0` - Font Awesome 图标库

## 开发环境

- Flutter SDK >= 3.5.0
- Dart SDK >= 3.5.0

## 许可证

本项目采用 [Apache License 2.0](LICENSE) 许可证。


## 贡献

欢迎提交 Issue 和 Pull Request！

## 更新日志

### v1.0.1
- 初次创建组件并上传
### v1.0.2
- 增加悬浮按钮
