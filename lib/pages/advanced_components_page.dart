import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../components.dart';
import '../notifications.dart';
import '../dialogs.dart';
import '../datepicker.dart';
import '../timepicker.dart';
import '../schedule_manager.dart';
import '../course_selector.dart';
import '../segmented_control.dart';
import '../dropdown.dart';
import '../system_notifications.dart';

// ================== 进阶组件页面 ==================
class AdvancedComponentsPage extends StatefulWidget {
  @override
  _AdvancedComponentsPageState createState() => _AdvancedComponentsPageState();
}

class _AdvancedComponentsPageState extends State<AdvancedComponentsPage> {
  DateTime? _selectedDate;
  TimeRange? _selectedRange;
  List<Schedule> _schedules = [
    Schedule(id: '1', name: '课表1'),
    Schedule(id: '2', name: '课表2'),
  ];
  String? _currentScheduleId = '1';
  
  // 课程选择器演示数据
  List<CourseItem> _courses = [
    CourseItem(id: '1', name: '高等数学'),
    CourseItem(id: '2', name: '大学英语'),
    CourseItem(id: '3', name: '计算机科学'),
  ];
  String? _currentCourseId = '1';
  
  // 分段控制器状态
  String _selectedSegment = 'type';
  String _selectedSegmentSmall = 'type';
  String _selectedSegmentLarge = 'type';
  
  // 下拉组件状态
  String? _selectedLanguage;
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildSegmentedControlDemo(),
          SizedBox(height: 50),
          _buildDropdownDemo(),
          SizedBox(height: 50),
          _buildNotificationDemo(),
          SizedBox(height: 50),
          _buildSystemNotificationDemo(),
          SizedBox(height: 50),
          _buildDialogDemo(),
          SizedBox(height: 50),
          _buildDatePickerDemo(),
          SizedBox(height: 50),
          _buildTimeRangePickerDemo(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  // ================== 通知组件演示 ==================
  Widget _buildNotificationDemo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '通知组件',
            subtitle: 'Sonner 通知系统演示',
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              YicoreButton(
                text: '带标题和按钮',
                onPressed: () => Notifications.sonner(
                  context,
                  title: '操作成功',
                  message: '您的操作已成功完成',
                  actionText: '撤销',
                  onAction: () {
                    Notifications.sonner(
                      context,
                      message: '操作已撤销',
                    );
                  },
                ),
              ),
              YicoreButton(
                text: '带操作按钮',
                onPressed: () => Notifications.sonner(
                  context,
                  title: '发生错误',
                  message: '操作失败，请重试',
                  actionText: '重试',
                  onAction: () {
                    Notifications.sonner(
                      context,
                      message: '正在重试...',
                    );
                  },
                ),
              ),
              YicoreButton(
                text: '仅消息',
                onPressed: () => Notifications.sonner(
                  context,
                  message: '这是一条简单的通知消息',
                ),
              ),
              YicoreButton(
                text: '仅标题',
                onPressed: () => Notifications.sonner(
                  context,
                  title: '通知标题',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================== 对话框组件演示 ==================
  Widget _buildDialogDemo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '对话框组件',
            subtitle: 'Alert、Confirm、Modal、课表管理、课程选择',
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              YicoreButton(
                text: '课表管理',
                onPressed: () {
                  YicoreScheduleManager.show(
                    context,
                    schedules: _schedules,
                    currentScheduleId: _currentScheduleId,
                    onSchedulesChanged: (updatedSchedules) {
                      setState(() {
                        _schedules = updatedSchedules;
                      });
                    },
                  );
                },
              ),
              YicoreButton(
                text: '课程选择',
                onPressed: () async {
                  final selectedId = await YicoreCourseSelector.show(
                    context,
                    courses: _courses,
                    currentCourseId: _currentCourseId,
                    title: '选择课程',
                  );
                  if (selectedId != null && mounted) {
                    setState(() {
                      _currentCourseId = selectedId;
                    });
                    final selectedCourse = _courses.firstWhere((c) => c.id == selectedId);
                    Notifications.sonner(
                      context,
                      title: '已选择课程',
                      message: selectedCourse.name,
                    );
                  }
                },
              ),
              YicoreButton(
                text: 'Alert 提示',
                onPressed: () => YicoreAlert.show(
                  context,
                  title: '提示',
                  message: '这是一个 Alert 对话框示例',
                  onConfirm: () {
                    print('Alert 确认');
                  },
                ),
              ),
              YicoreButton(
                text: 'Confirm 确认',
                onPressed: () async {
                  final result = await YicoreConfirm.show(
                    context,
                    title: '确认操作',
                    message: '确定要执行此操作吗？',
                    onConfirm: () {
                      print('Confirm 确认');
                    },
                    onCancel: () {
                      print('Confirm 取消');
                    },
                  );
                  if (mounted && result) {
                    Notifications.sonner(
                      context,
                      message: '已确认操作',
                    );
                  }
                },
              ),
              YicoreButton(
                text: 'Modal 模态',
                onPressed: () => YicoreModal.show(
                  context,
                  title: '模态对话框',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '这是一个模态对话框示例',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '可以在这里放置任何内容，如表单、列表、图片等。',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  footer: Builder(
                    builder: (dialogContext) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        YicoreButton(
                          text: '取消',
                          isOutlined: true,
                          onPressed: () {
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext, rootNavigator: true).pop();
                            }
                          },
                        ),
                        SizedBox(width: 12),
                        YicoreButton(
                          text: '确定',
                          onPressed: () {
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext, rootNavigator: true).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              YicoreButton(
                text: '公告对话框',
                onPressed: () => YicoreAnnouncement.show(
                  context,
                  title: '系统公告',
                  message: '本周末将进行系统维护，期间可能出现短暂不可用。给您带来不便，敬请谅解。',
                  primaryText: '我知道了',
                  secondaryText: '稍后提醒',
                  onPrimary: () {
                    Notifications.sonner(
                      context,
                      message: '已确认公告',
                    );
                  },
                  onSecondary: () {
                    Notifications.sonner(
                      context,
                      message: '将稍后提醒',
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================== 日期选择器演示 ==================
  Widget _buildDatePickerDemo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '日期选择器',
            subtitle: '日期选择组件演示',
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                              : '请选择日期',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedDate != null ? Colors.black : Colors.grey[400],
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              YicoreButton(
                text: '选择',
                onPressed: () async {
                  final DateTime? picked = await YicoreDatePicker.show(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                  );
                  if (picked != null && mounted) {
                    setState(() {
                      _selectedDate = picked;
                    });
                    Notifications.sonner(
                      context,
                      message: '已选择日期：${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
                    );
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================== 时间范围选择器演示 ==================
  Widget _buildTimeRangePickerDemo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '时间范围选择器',
            subtitle: '底部弹窗，格式 xx:xx-xx:xx',
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Text(
                    _selectedRange != null
                        ? _selectedRange!.format()
                        : '未选择',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedRange != null ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              YicoreButton(
                text: '选择时间',
                onPressed: () async {
                  final picked = await YicoreTimeRangePicker.show(
                    context: context,
                    initial: _selectedRange,
                  );
                  if (picked != null && mounted) {
                    setState(() => _selectedRange = picked);
                    Notifications.sonner(
                      context,
                      message: '已选择 ${picked.format()}',
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================== 切换控制器演示 ==================
  Widget _buildSegmentedControlDemo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '切换控制器',
            subtitle: '分段控制器组件',
          ),
          SizedBox(height: 20),
          Text(
            '小尺寸（带边框）',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          YicoreSegmentedControl(
            size: SegmentedControlSize.small,
            showBorder: true,
            items: [
              SegmentedItem(label: '类型', value: 'type'),
              SegmentedItem(label: '视图', value: 'view'),
              SegmentedItem(label: '示例', value: 'example'),
            ],
            selectedValue: _selectedSegmentSmall,
            onChanged: (value) {
              setState(() {
                _selectedSegmentSmall = value;
              });
              Notifications.sonner(
                context,
                message: '小尺寸：已切换到：${value == 'type' ? '类型' : value == 'view' ? '视图' : '示例'}',
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            '中等尺寸（无边框）',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          YicoreSegmentedControl(
            size: SegmentedControlSize.medium,
            showBorder: false,
            items: [
              SegmentedItem(label: '类型', value: 'type'),
              SegmentedItem(label: '视图', value: 'view'),
              SegmentedItem(label: '示例', value: 'example'),
            ],
            selectedValue: _selectedSegment,
            onChanged: (value) {
              setState(() {
                _selectedSegment = value;
              });
              Notifications.sonner(
                context,
                message: '中等尺寸：已切换到：${value == 'type' ? '类型' : value == 'view' ? '视图' : '示例'}',
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            '大尺寸（带边框）',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          YicoreSegmentedControl(
            size: SegmentedControlSize.large,
            showBorder: true,
            items: [
              SegmentedItem(label: '类型', value: 'type'),
              SegmentedItem(label: '视图', value: 'view'),
              SegmentedItem(label: '示例', value: 'example'),
            ],
            selectedValue: _selectedSegmentLarge,
            onChanged: (value) {
              setState(() {
                _selectedSegmentLarge = value;
              });
              Notifications.sonner(
                context,
                message: '大尺寸：已切换到：${value == 'type' ? '类型' : value == 'view' ? '视图' : '示例'}',
              );
            },
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              '当前选择（中等）：${_selectedSegment == 'type' ? '类型' : _selectedSegment == 'view' ? '视图' : '示例'}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================== 下拉组件演示 ==================
  Widget _buildDropdownDemo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '下拉组件',
            subtitle: '自定义下拉选择样式',
          ),
          SizedBox(height: 20),
          YicoreDropdown<String>(
            labelText: '选择语言',
            hintText: '请选择语言',
            value: _selectedLanguage,
            items: [
              YicoreDropdownItem(
                value: 'zh',
                label: '简体中文',
                icon: Icons.language,
              ),
              YicoreDropdownItem(
                value: 'en',
                label: 'English',
                icon: Icons.language,
              ),
              YicoreDropdownItem(
                value: 'ja',
                label: '日本語',
                icon: Icons.language,
              ),
              YicoreDropdownItem(
                value: 'ko',
                label: '한국어',
                icon: Icons.language,
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
              Notifications.sonner(
                context,
                message: '已选择: ${value == 'zh' ? '简体中文' : value == 'en' ? 'English' : value == 'ja' ? '日本語' : '한국어'}',
              );
            },
          ),
          SizedBox(height: 16),
          YicoreDropdown<String>(
            labelText: '选择国家',
            hintText: '请选择国家',
            value: _selectedCountry,
            items: [
              YicoreDropdownItem(
                value: 'cn',
                label: '中国',
                icon: Icons.flag,
              ),
              YicoreDropdownItem(
                value: 'us',
                label: '美国',
                icon: Icons.flag,
              ),
              YicoreDropdownItem(
                value: 'jp',
                label: '日本',
                icon: Icons.flag,
              ),
              YicoreDropdownItem(
                value: 'kr',
                label: '韩国',
                icon: Icons.flag,
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
              });
              Notifications.sonner(
                context,
                message: '已选择国家',
              );
            },
          ),
          SizedBox(height: 16),
          YicoreDropdown<String>(
            labelText: '禁用状态',
            hintText: '此下拉框已禁用',
            value: 'zh',
            enabled: false,
            items: [
              YicoreDropdownItem(
                value: 'zh',
                label: '简体中文',
              ),
              YicoreDropdownItem(
                value: 'en',
                label: 'English',
              ),
            ],
            onChanged: (value) {},
          ),
          SizedBox(height: 16),
          YicoreDropdown<String>(
            labelText: '错误状态',
            hintText: '请选择选项',
            errorText: '此字段为必填项',
            items: [
              YicoreDropdownItem(
                value: 'option1',
                label: '选项1',
              ),
              YicoreDropdownItem(
                value: 'option2',
                label: '选项2',
              ),
            ],
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  // ================== 系统通知演示 ==================
  Widget _buildSystemNotificationDemo() {
    // 设置 context 供 Web 平台使用
    systemNotifications.setContext(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: '系统通知',
            subtitle: kIsWeb 
                ? '页面内通知（Web）' 
                : '本地系统通知（Android/iOS/macOS）',
          ),
          SizedBox(height: 12),
          YicoreButton(
            text: '请求通知权限',
            onPressed: () async {
              final granted = await systemNotifications.requestPermission();
              if (!context.mounted) return;
              Notifications.sonner(
                context,
                title: granted ? '权限已授予' : '权限未授予',
                message: kIsWeb
                    ? 'Web 平台无需权限'
                    : (granted ? '通知权限已成功授予' : '通知权限未授予'),
              );
            },
          ),
          SizedBox(height: 12),
          YicoreButton(
            text: '简单通知',
            isOutlined: true,
            onPressed: () async {
              await systemNotifications.show(
                id: 1,
                title: 'Yicore 通知',
                body: '这是一条通知',
              );
              if (!kIsWeb) {
                if (!context.mounted) return;
                Notifications.sonner(
                  context,
                  title: '已发送',
                  message: '系统通知已发送',
                );
              }
            },
          ),
          SizedBox(height: 12),
          YicoreButton(
            text: '定时通知（5秒后）',
            isOutlined: true,
            onPressed: () async {
              Notifications.sonner(
                context,
                title: '已设置',
                message: '通知将在 5 秒后显示',
              );
              
              await systemNotifications.schedule(
                id: 2,
                title: 'Yicore 定时通知',
                body: '这是一条 5 秒前设置的通知',
                delay: Duration(seconds: 5),
              );
            },
          ),
          SizedBox(height: 12),
          YicoreButton(
            text: '带按钮的定时通知（10秒后）',
            isOutlined: true,
            onPressed: () async {
              Notifications.sonner(
                context,
                title: '已设置',
                message: kIsWeb 
                    ? '通知将在 10 秒后显示'
                    : '带按钮的通知将在 10 秒后显示（仅Android）',
              );
              
              await systemNotifications.scheduleWithActions(
                id: 3,
                title: 'Yicore 操作通知',
                body: '这是一条 10 秒前设置的定时操作通知',
                delay: Duration(seconds: 10),
              );
            },
          ),
          if (!kIsWeb) ...[
            SizedBox(height: 12),
            YicoreButton(
              text: '即时操作通知',
              isOutlined: true,
              onPressed: () async {
                await systemNotifications.showWithActions(
                  id: 4,
                  title: '即时操作通知',
                  body: '这是一条即时发送的带操作按钮通知',
                );
                if (!context.mounted) return;
                Notifications.sonner(
                  context,
                  title: '已发送',
                  message: '带操作按钮的通知已发送（仅Android）',
                );
              },
            ),
            SizedBox(height: 12),
            YicoreButton(
              text: '清除所有通知',
              isOutlined: true,
              onPressed: () async {
                await systemNotifications.cancelAll();
                if (!context.mounted) return;
                Notifications.sonner(
                  context,
                  title: '已清除',
                  message: '所有通知已清除',
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

// ================== 节标题组件 ==================
class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({
    required this.title,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 0.3,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

