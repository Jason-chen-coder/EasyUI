import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class LocalNotificationDemo extends StatelessWidget {
  const LocalNotificationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyLocalNotifications 本地通知组件'),
        h2('EasyLocalNotifications 组件概述'),
        p(
          'EasyLocalNotifications 是一个功能丰富的本地通知管理类，支持多平台通知的初始化、权限请求、通知显示以及打开系统通知设置页面等功能。',
        ),
        p('下面是使用示例：'),
        h2('1. 初始化'),
        p('初始化步骤必须进行，建议在应用启动完成后立即调用'),
        WidgetHighlight(
          builder:
              (_) => EasyButton2(
                child: Text('点击初始化'),
                onPressed: () async {
                  await EasyLocalNotifications().initialize(
                    macOSPackageName: 'com.example.example',
                    windowsAUMID: 'com.example.example',
                    windowsGUID: '960ea9b9-20af-4f08-b332-43a0363f4104',
                    windowsIconPath: 'assets/images/app_icon.png',
                    androidSoundChannelTitle: '有声音通知',
                    androidSilentChannelTitle: '无声音通知',
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('初始化完成')));
                },
              ),
          codeSnippet: '''
```dart
await EasyLocalNotifications().initialize(
  packageName: 'com.example.example',
  windowsIconPath: 'assets/images/app_icon.png',
  androidSoundChannelTitle: '有声音通知',
  androidSilentChannelTitle: '无声音通知',
);
```
''',
        ),
        h2('2. 请求通知权限'),
        p('在显示通知之前，需要先请求通知权限(Windows 平台可以忽略此步骤)'),
        WidgetHighlight(
          builder:
              (_) => EasyButton2(
                child: Text('请求通知权限'),
                onPressed: () => EasyLocalNotifications().requestPermissions(),
              ),
          codeSnippet:
              '```dart\nEasyLocalNotifications().requestPermissions();\n```',
        ),
        h2('3. 监听通知点击事件并检查是否由通知启动应用'),
        tip('注意：每次点击都会创建一个新的监听器'),
        WidgetHighlight(
          builder:
              (_) => EasyButton2(
                child: Text('监听通知点击事件'),
                onPressed: () {
                  EasyLocalNotifications().stream.listen((
                    NotificationResponse response,
                  ) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('通知被点击，负载数据：${response.payload}')),
                    );
                  });
                  // 发送启动通知，应该在监听通知后执行，否则会错过事件
                  EasyLocalNotifications().emitLaunchedNotification();
                },
              ),
          codeSnippet: '''```dart
EasyLocalNotifications().stream.listen((
  NotificationResponse response,
) {
  // TODO 处理通知点击事件
});

// 发送启动通知，应该在监听通知后执行，否则会错过事件
EasyLocalNotifications().emitLaunchedNotification();
```''',
        ),
        h2('4. 发送通知'),
        p('可以通过 `playSound` 参数来控制是否播放声音'),
        WidgetHighlight(
          builder:
              (_) => Row(
                spacing: 16,
                children: [
                  EasyButton2(
                    child: Text('发送有声通知'),
                    onPressed: () {
                      EasyLocalNotifications().showNotification(
                        title: '这里是通知标题',
                        body: '这里是通知body区域，这条通知会有声音',
                        payload: '有声通知的自定义负载数据',
                      );
                    },
                  ),
                  EasyButton2(
                    child: Text('发送静音通知'),
                    onPressed: () {
                      EasyLocalNotifications().showNotification(
                        title: '这里是通知标题',
                        body: '这里是通知body区域，这条通知是静音的',
                        payload: '静音通知的自定义负载数据',
                        playSound: false,
                      );
                    },
                  ),
                ],
              ),
          codeSnippet: '''
```dart
// 发送有声通知
EasyLocalNotifications().showNotification(
  title: '这里是通知标题',
  body: '这里是通知body区域，这条通知会有声音',
  payload: '有声通知的自定义负载数据',
);
// 发送静音通知
EasyLocalNotifications().showNotification(
  title: '这里是通知标题',
  body: '这里是通知body区域，这条通知是静音的',
  payload: '静音通知的自定义负载数据',
  playSound: false,
);
```
''',
        ),
        h2('5. 取消通知'),
        p('取消所有已经发送的通知'),
        WidgetHighlight(
          builder:
              (_) => EasyButton2(
                child: Text('取消所有通知'),
                onPressed: () {
                  EasyLocalNotifications().cancelAll();
                },
              ),
          codeSnippet: '''
```dart
EasyLocalNotifications().cancelAll();
```
''',
        ),
        h2('6. 打开系统通知设置页面'),
        WidgetHighlight(
          builder:
              (_) => EasyButton2(
                child: Text('打开通知设置'),
                onPressed: () {
                  EasyLocalNotifications().openNotificationSettings();
                },
              ),
          codeSnippet:
              '```dart\nEasyLocalNotifications().openNotificationSettings();\n```',
        ),
        h2('7. 清理资源'),
        p('当不再需要使用 EasyLocalNotifications 时，可以调用下面的方法来释放资源'),
        p('建议和初始化时成对使用，避免内存泄漏'),
        WidgetHighlight(
          builder:
              (_) => EasyButton2(
                child: Text('清理资源'),
                onPressed: () {
                  EasyLocalNotifications().dispose();
                },
              ),
          codeSnippet: '```dart\nEasyLocalNotifications().dispose();\n```',
        ),
      ],
    );
  }
}
