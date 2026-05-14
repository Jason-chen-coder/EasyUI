import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

/// 本地通知管理类
class EasyLocalNotifications {
  EasyLocalNotifications._();
  static EasyLocalNotifications? _instance;

  factory EasyLocalNotifications() {
    _instance ??= EasyLocalNotifications._();
    return _instance!;
  }

  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  final _notificationController =
      StreamController<NotificationResponse>.broadcast();

  static const tag = 'EasyLocalNotifications';

  int _notificationId = 0;

  /// macOS应用包名
  late final String _macOSPackageName;

  static const _soundChannelId = 'easy_local_notifications_sound_channel';
  static const _silentChannelId = 'easy_local_notifications_silent_channel';
  late final AndroidNotificationChannel _androidSoundChannel;
  late final AndroidNotificationChannel _androidSilentChannel;

  /// 打开系统通知设置页面
  void openNotificationSettings() async {
    try {
      if (Platform.isAndroid) {
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
      } else if (Platform.isWindows) {
        final uri = Uri.parse('ms-settings:notifications');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          final Uri homeUri = Uri.parse('ms-settings:');
          if (await canLaunchUrl(homeUri)) {
            await launchUrl(homeUri);
          }
        }
      } else if (Platform.isMacOS) {
        final String url =
            'x-apple.systempreferences:com.apple.preference.notifications?id=$_macOSPackageName';
        final Uri uri = Uri.parse(url);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          final Uri homeUri = Uri.parse('x-apple.systempreferences:');
          if (await canLaunchUrl(homeUri)) {
            await launchUrl(homeUri);
          }
        }
      }
    } catch (e) {
      log(
        ' [$tag] [openNotificationSettings] Error: Failed to open notification settings. $e',
      );
    }
  }

  bool _isInitialized = false;

  /// 初始化本地通知插件
  /// [macOSPackageName] macOS 平台应用包名
  /// [windowsGUID] Windows 应用GUID（生成一个uuid即可）
  /// [windowsAUMID] Windows 平台应用包名
  /// [windowsIconPath] Windows 平台图标路径
  /// [androidSoundChannelTitle] Android 平台有声通知渠道名称
  /// [androidSilentChannelTitle] Android 平台静音通知渠道名称
  Future<void>? _initializeFuture;
  Future<void> initialize({
    required String macOSPackageName,
    required String windowsGUID,
    required String windowsAUMID,
    required String windowsIconPath,
    required String androidSoundChannelTitle,
    required String androidSilentChannelTitle,
  }) {
    _initializeFuture ??= _doInitialize(
      macOSPackageName: macOSPackageName,
      windowsGUID: windowsGUID,
      windowsAUMID: windowsAUMID,
      windowsIconPath: windowsIconPath,
      androidSoundChannelTitle: androidSoundChannelTitle,
      androidSilentChannelTitle: androidSilentChannelTitle,
    );
    return _initializeFuture!;
  }

  Future<void> _doInitialize({
    required String macOSPackageName,
    required String windowsGUID,
    required String windowsAUMID,
    required String windowsIconPath,
    required String androidSoundChannelTitle,
    required String androidSilentChannelTitle,
  }) async {
    /// 保存包名
    _macOSPackageName = macOSPackageName;

    /// 初始化 Android 通知 channel
    _androidSoundChannel = AndroidNotificationChannel(
      _soundChannelId,
      androidSoundChannelTitle,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    _androidSilentChannel = AndroidNotificationChannel(
      _silentChannelId,
      androidSilentChannelTitle,
      importance: Importance.high,
      playSound: false,
      enableVibration: false,
    );

    // Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // 应用图标
    );
    // macOS
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    // Windows
    final windowsSettings = WindowsInitializationSettings(
      appName: 'αLab Studio',
      appUserModelId: windowsAUMID,
      guid: windowsGUID,
      iconPath: WindowsImage.getAssetUri(windowsIconPath).toFilePath(),
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      macOS: darwinSettings,
      windows: windowsSettings,
    );
    try {
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _notificationController.add,
      );
      _isInitialized = true;
      if (Platform.isAndroid) await _createAndroidChannels();
    } catch (e) {
      log(
        '[$tag] [initialize] Error: Notification plugin initialization failed!. $e',
      );
    }
  }

  /// 检查插件是否初始化，如果未初始化则记录错误日志并返回 false
  /// 由于通知不影响应用的正常运行，因此不抛出异常
  bool _checkInitialize() {
    if (!_isInitialized) {
      log(
        '[$tag] [checkInitialize] Error: Notification plugin is not initialized!',
      );
      return false;
    }
    return true;
  }

  bool _androidChannelInitialized = false;

  /// 创建 Android 通知渠道
  Future<void> _createAndroidChannels() async {
    if (!_checkInitialize()) return;
    if (_androidChannelInitialized) return;
    try {
      final androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      if (androidPlugin == null) {
        log(
          ' [$tag] [_createAndroidChannels] Unable to get Android notifications plugin instance',
        );
        return;
      }
      await androidPlugin.createNotificationChannel(_androidSoundChannel);
      await androidPlugin.createNotificationChannel(_androidSilentChannel);
      _androidChannelInitialized = true;
    } catch (e) {
      log(
        ' [$tag] [_createAndroidChannels] Configuring Android notification channels failed: $e',
      );
    }
  }

  /// 请求通知权限
  Future<void> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin =
            _notificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        await androidPlugin?.requestNotificationsPermission();
        return;
      }
      if (Platform.isMacOS) {
        final macPlugin =
            _notificationsPlugin
                .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin
                >();
        await macPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return;
      }
    } catch (e) {
      log(
        '[$tag] [requestPermissions] Error: Notification plugin request permissions failed!. $e',
      );
    }
  }

  /// 显示本地通知
  /// [title] 标题
  /// [body] 内容
  /// [payload] 负载数据
  /// [playSound] 是否有声音
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    bool playSound = true,
  }) async {
    if (!_checkInitialize()) return;

    final AndroidNotificationChannel selectedChannel =
        playSound ? _androidSoundChannel : _androidSilentChannel;
    if (Platform.isAndroid && !_androidChannelInitialized) {
      await _createAndroidChannels();
    }

    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        selectedChannel.id,
        selectedChannel.name,
        channelDescription: selectedChannel.description,
        importance: selectedChannel.importance,
        priority: Priority.max,
        playSound: playSound,
        enableVibration: playSound,
        channelAction: AndroidNotificationChannelAction.update,
        onlyAlertOnce: false,
        category: AndroidNotificationCategory.alarm,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
      ),
      windows: WindowsNotificationDetails(
        audio: playSound ? null : WindowsNotificationAudio.silent(),
      ),
    );

    try {
      await _notificationsPlugin.show(
        _notificationId++,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      log(' [$tag] [showNotification] Error: Failed to show notification. $e');
    }
  }

  /// 取消所有通知
  Future<void> cancelAll() async {
    if (_checkInitialize()) {
      await _notificationsPlugin.cancelAll();
    }
  }

  bool _isLaunched = false;

  /// 发射应用启动时的通知事件
  /// 如果应用是通过点击通知启动的，则会触发一次通知响应事件
  /// 建议应用启动时先监听通知流，否则会错过该事件
  void emitLaunchedNotification() async {
    if (!_checkInitialize()) return;
    if (!_isLaunched) {
      final appLaunchDetails =
          await _notificationsPlugin.getNotificationAppLaunchDetails();
      if (appLaunchDetails?.didNotificationLaunchApp ?? false) {
        _notificationController.add(appLaunchDetails!.notificationResponse!);
      }
      _isLaunched = true;
    }
  }

  /// 通知响应流
  Stream<NotificationResponse> get stream => _notificationController.stream;

  /// 释放资源
  /// 关闭通知响应流
  void dispose() {
    _notificationController.close();
    _instance = null;
  }
}
