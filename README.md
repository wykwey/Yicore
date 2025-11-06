# Yicore

一个 Flutter UI 组件库演示项目，提供丰富且美观的自定义组件。

## 项目简介

Yicore 是一个课表管理工具，支持多种课程表格式导入，支持多种平台。本项目同时也是 Flutter UI 组件库的演示项目，展示了各种自定义组件的使用方法。

## 版本信息

- **当前版本**: 1.0.4
- **Flutter SDK**: >=3.5.0 <4.0.0

## 功能特性

### 基础组件

- **YicoreButton** - 自定义按钮（支持主要、次要、轮廓、加载状态）
- **YicoreTextField** - 自定义输入框（支持标签、提示、错误状态）
- **YicoreSwitch** - 自定义开关
- **YicoreSlider** - 自定义滑块
- **YicoreCard** - 自定义卡片容器
- **YicoreFab** - 悬浮窗按钮（支持拖动、展开菜单、自定义图标）
- **YicoreDropdown** - 下拉选择器（支持图标、搜索、错误状态）
- **YicoreSegmentedControl** - 分段控制器（支持多尺寸、边框选项、平滑动画）

### 设置组件

- **SettingsBlock** - 设置区块容器
- **SettingsItem** - 设置项（支持开关、滑块、分段控制器、文本值、纯文本等类型）

### 对话框组件

- **YicoreAlert** - 提示对话框
- **YicoreConfirm** - 确认对话框
- **YicoreModal** - 模态对话框
- **YicoreAnnouncement** - 公告对话框
- **YicoreScheduleManager** - 课表管理器（支持新建、编辑、删除课表）

### 通知组件

- **Notifications.sonner()** - Sonner 风格通知系统，支持标题、消息、操作按钮

### 导航组件

- **YicoreBottomNavigationBar** - 自定义底部导航栏，带平滑动画效果
- **YicoreAppBar** - 自定义应用栏（支持标题、返回按钮、操作按钮、上部圆角）

### 日期时间组件

- **YicoreDatePicker** - 日期选择器（静态方法调用，弹窗选择）
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
├── navigation.dart        # 导航组件（底部导航栏）
├── appbar.dart            # 应用栏组件
├── segmented_control.dart # 分段控制器组件
├── datepicker.dart        # 日期选择器
├── timepicker.dart        # 时间范围选择器
├── dropdown.dart          # 下拉选择器
├── fab.dart               # 悬浮窗按钮
└── schedule_manager.dart  # 课表管理器

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

### v1.0.4
- 新增 YicoreAppBar 应用栏组件
- 新增 YicoreSegmentedControl 分段控制器组件
- SettingsItem 新增 segmented 类型支持
- 优化分段控制器动画效果和样式配置
- 优化底部导航栏样式和动画
- 改进设置组件的禁用状态显示

### v1.0.3
- 新增 YicoreDropdown 下拉选择器组件
- 新增 YicoreScheduleManager 课表管理器
- 重构 YicoreFab，支持可拖动和展开菜单

### v1.0.2
- 增加悬浮按钮

### v1.0.1
- 初次创建组件并上传
