import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notifications.dart';

/// 系统通知服务
/// 
/// 支持平台：
/// - Web: 使用 Sonner（页面内通知）
/// - Android/iOS/macOS: 使用原生系统通知
/// 
/// 功能：
/// - 即时通知（简单/带按钮）
/// - 定时通知（简单/带按钮，支持后台）
class SystemNotifications {
  SystemNotifications._();
  static final instance = SystemNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  BuildContext? _context;

  // ==================== 初始化 ====================
  
  Future<void> _ensureInitialized() async {
    if (_initialized || kIsWeb) return;

    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios, macOS: ios),
    );

    _initialized = true;
  }

  /// 设置上下文（Web 平台需要用于显示 Sonner）
  void setContext(BuildContext context) => _context = context;

  // ==================== 权限管理 ====================

  /// 请求通知权限
  Future<bool> requestPermission() async {
    if (kIsWeb) return true;

    await _ensureInitialized();

    // Android
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    // iOS/macOS
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return true;
  }

  // ==================== 即时通知 ====================

  /// 显示简单通知
  Future<void> show({
    required String title,
    required String body,
    int id = 0,
  }) async {
    if (kIsWeb) {
      _showSonner(title, body);
      return;
    }

    await _ensureInitialized();

    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: _androidDetails(),
        iOS: _iosDetails(),
        macOS: _iosDetails(),
      ),
    );
  }

  /// 显示带操作按钮的通知（仅 Android）
  Future<void> showWithActions({
    required String title,
    required String body,
    int id = 0,
  }) async {
    if (kIsWeb) return;

    await _ensureInitialized();

    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: _androidDetailsWithActions(),
      ),
    );
  }

  // ==================== 定时通知（后台支持）====================

  /// 定时通知
  Future<void> schedule({
    required String title,
    required String body,
    required Duration delay,
    int id = 0,
  }) async {
    if (kIsWeb) {
      Future.delayed(delay, () => _showSonner(title, body));
      return;
    }

    await _ensureInitialized();

    final time = tz.TZDateTime.now(tz.local).add(delay);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      time,
      NotificationDetails(
        android: _androidDetails(),
        iOS: _iosDetails(),
        macOS: _iosDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 定时通知（带操作按钮，仅 Android）
  Future<void> scheduleWithActions({
    required String title,
    required String body,
    required Duration delay,
    int id = 0,
  }) async {
    if (kIsWeb) {
      Future.delayed(delay, () => _showSonner(title, body));
      return;
    }

    await _ensureInitialized();

    final time = tz.TZDateTime.now(tz.local).add(delay);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      time,
      NotificationDetails(
        android: _androidDetailsWithActions(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ==================== 取消通知 ====================

  /// 取消指定通知
  Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id);
  }

  /// 取消所有通知
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  // ==================== 私有辅助方法 ====================

  void _showSonner(String title, String body) {
    if (_context != null && _context!.mounted) {
      Notifications.sonner(_context!, title: title, message: body);
    }
  }

  AndroidNotificationDetails _androidDetails() {
    return const AndroidNotificationDetails(
      'yicore_channel',
      'Yicore 通知',
      channelDescription: 'Yicore 组件库通知频道',
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  AndroidNotificationDetails _androidDetailsWithActions() {
    return const AndroidNotificationDetails(
      'yicore_actions_channel',
      'Yicore 操作通知',
      channelDescription: 'Yicore 带操作按钮的通知频道',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction('accept', '接受'),
        AndroidNotificationAction('decline', '拒绝'),
      ],
    );
  }

  DarwinNotificationDetails _iosDetails() {
    return const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  }
}

// ==================== 全局实例 ====================
final systemNotifications = SystemNotifications.instance;
