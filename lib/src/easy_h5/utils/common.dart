import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import '../../../easy_ui.dart';

class H5AppItem {
  final String appName;
  final bool showInMarket;
  final String nameEn;
  final String nameZh;
  final String descriptionEn;
  final String descriptionZh;
  final String version;
  final Widget icon;
  final WidgetBuilder builder;
  final String heroTag;

  const H5AppItem({
    required this.appName,
    this.showInMarket = true,
    required this.nameEn,
    required this.nameZh,
    required this.icon,
    required this.builder,
    required this.heroTag,
    this.descriptionEn = '',
    this.descriptionZh = '',
    this.version = '1.0.0',
  });

  // Getter for compatibility, returns the appropriate name based on current locale
  String getName(Locale locale) {
    if (locale.languageCode.toLowerCase() == 'zh') {
      return nameZh.isNotEmpty ? nameZh : nameEn;
    }
    return nameEn;
  }

  // Getter for localized description
  String getDescription(Locale locale) {
    if (locale.languageCode.toLowerCase() == 'zh') {
      return descriptionZh.isNotEmpty ? descriptionZh : "";
    }
    return descriptionEn.isNotEmpty ? descriptionEn : "";
  }
}

/// Get FileType enum for FilePicker based on type string
FileType getFilePickerType(String type) {
  switch (type.toLowerCase()) {
    case 'image':
      return FileType.image;
    case 'video':
      return FileType.video;
    case 'audio':
      return FileType.audio;
    case 'document':
      return FileType.custom;
    case 'all':
    default:
      return FileType.any;
  }
}

/// Get file extensions for specific file type
/// Can handle both file type categories ('image', 'video', etc.) and actual file extensions ('jpg', 'png', etc.)
List<String>? getExtensionsForType(String type) {
  final lowerType = type.toLowerCase();

  // 如果type以点开头（如 '.jpg'），移除点后返回
  if (lowerType.startsWith('.')) {
    return [lowerType.substring(1)];
  }

  // 检查是否是直接的文件扩展名
  final allKnownExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'svg',
    'mp4',
    'avi',
    'mov',
    'mkv',
    'flv',
    'webm',
    'mp3',
    'wav',
    'aac',
    'flac',
    'm4a',
    'ogg',
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt',
    'csv',
    'json',
  };

  if (allKnownExtensions.contains(lowerType)) {
    return [lowerType];
  }

  // 按文件类型分类处理
  switch (lowerType) {
    case 'image':
      return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'];
    case 'video':
      return ['mp4', 'avi', 'mov', 'mkv', 'flv', 'webm'];
    case 'audio':
      return ['mp3', 'wav', 'aac', 'flac', 'm4a', 'ogg'];
    case 'document':
      return ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'csv'];
    case 'all':
    default:
      return null;
  }
}

/// Get MIME type based on file extension
String getMimeType(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();

  // 常见图片格式
  if (['jpg', 'jpeg'].contains(ext)) return 'image/jpeg';
  if (ext == 'png') return 'image/png';
  if (ext == 'gif') return 'image/gif';
  if (ext == 'webp') return 'image/webp';
  if (ext == 'svg') return 'image/svg+xml';
  if (ext == 'bmp') return 'image/bmp';

  // 常见视频格式
  if (ext == 'mp4') return 'video/mp4';
  if (ext == 'avi') return 'video/x-msvideo';
  if (ext == 'mov') return 'video/quicktime';
  if (ext == 'mkv') return 'video/x-matroska';
  if (ext == 'webm') return 'video/webm';

  // 常见音频格式
  if (ext == 'mp3') return 'audio/mpeg';
  if (ext == 'wav') return 'audio/wav';
  if (ext == 'aac') return 'audio/aac';
  if (ext == 'flac') return 'audio/flac';
  if (ext == 'm4a') return 'audio/mp4';

  // 文档格式
  if (ext == 'pdf') return 'application/pdf';
  if (ext == 'txt') return 'text/plain';
  if (ext == 'csv') return 'text/csv';
  if (ext == 'json') return 'application/json';
  if (['doc', 'docx'].contains(ext)) return 'application/msword';
  if (['xls', 'xlsx'].contains(ext)) return 'application/vnd.ms-excel';
  if (['ppt', 'pptx'].contains(ext)) return 'application/vnd.ms-powerpoint';

  // 默认
  return 'application/octet-stream';
}

/// Check if MIME type is allowed
bool isMimeTypeAllowed(String mimeType, List<String> allowedMimes) {
  for (final allowed in allowedMimes) {
    if (allowed == '*/*') return true;
    if (allowed == mimeType) return true;

    // 支持通配符，如 image/*
    if (allowed.endsWith('/*')) {
      final prefix = allowed.substring(0, allowed.length - 2);
      if (mimeType.startsWith(prefix)) return true;
    }
  }
  return false;
}

/// Request necessary permissions for file access
Future<void> requestFileAccessPermissions() async {
  if (Platform.isAndroid) {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }

    if (!storageStatus.isGranted) {
      throw Exception('文件访问权限被拒绝');
    }

    // Android 11+ 需要 MANAGE_EXTERNAL_STORAGE 权限才能访问公共目录
    var manageStatus = await Permission.manageExternalStorage.status;
    if (!manageStatus.isGranted) {
      manageStatus = await Permission.manageExternalStorage.request();
    }

    if (!manageStatus.isGranted) {
      throw Exception('文件访问权限被拒绝');
    }
  } else if (Platform.isIOS) {
    // iOS 不需要特殊权限
  }
}

/// Read file in a separate isolate to avoid blocking the main thread
Future<Uint8List> readFileInIsolate(String path) async {
  return await Isolate.run<Uint8List>(() async {
    return await File(path).readAsBytes();
  });
}

/// Write file in a separate isolate to avoid blocking the main thread
Future<void> writeFileInIsolate(String path, Uint8List data) async {
  return await Isolate.run<void>(() async {
    final file = File(path);
    await file.writeAsBytes(data);
  });
}

/// 扫描应用 获取 assets/apps/ 目录下的所有 .zip 文件（仅文件名，不含后缀）
Future<List<String>> listZipFilesInAppsDir() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  final prefix = 'packages/easy_ui/';
  final manifestMapKeys =
      manifestMap.keys.where((k) => k.startsWith(prefix)).toList();
  print("[listZipFilesInAppsDir] manifestMapKeys :$manifestMapKeys");
  final zipFiles =
      manifestMapKeys
          .where(
            (path) =>
                path.startsWith('packages/easy_ui/assets/apps/') &&
                path.toLowerCase().endsWith('.zip'),
          )
          .map((path) {
            final name =
                path.split('/').last; // intelligent_reagent_dispensing.zip
            return name.replaceAll(
              '.zip',
              '',
            ); // intelligent_reagent_dispensing
          })
          .toList();

  return zipFiles;
}

/// 解压应用
Future<void> syncLocalApps(BuildContext context) async {
  final zipFileNames = await listZipFilesInAppsDir();
  print("zipFileNames====>$zipFileNames");
  try {
    // 1. 获取应用支持目录
    final Directory appSupportDir = await getApplicationSupportDirectory();
    final Directory easyUiAppsDir = Directory(
      '${appSupportDir.path}/easy_ui/apps',
    );

    // 创建appsDir目录（如果不存在）
    if (!await easyUiAppsDir.exists()) {
      await easyUiAppsDir.create(recursive: true);
      ErrorHandler.instance.logSuccess(
        '[MicroApp] apps directory created: ${easyUiAppsDir.path}',
      );
    }

    // 2. 解压assets/apps目录下的zip文件
    for (String appZipFileName in zipFileNames) {
      try {
        // 从assets中读取zip文件
        final ByteData zipData = await rootBundle.load(
          'packages/easy_ui/assets/apps/$appZipFileName.zip',
        );
        final List<int> zipBytes = zipData.buffer.asUint8List();

        // 计算zip文件的SHA-256哈希值
        final String currentHash = sha256.convert(zipBytes).toString();
        final File hashFile = File(
          '${easyUiAppsDir.path}/$appZipFileName.hash',
        );
        final Directory appDir = Directory(
          '${easyUiAppsDir.path}/$appZipFileName',
        );

        // 如果哈希值匹配且应用目录存在，跳过解压
        if (await hashFile.exists() && await appDir.exists()) {
          final String storedHash = await hashFile.readAsString();
          if (storedHash.trim() == currentHash) {
            ErrorHandler.instance.logSuccess(
              '[MicroApp] Skipped (unchanged): $appZipFileName',
            );
            continue;
          }
        }

        // 解压到应用目录
        final Archive archive = ZipDecoder().decodeBytes(zipBytes);

        // 如果应用目录存在直接删除，删除后重新解压
        if (await appDir.exists()) {
          await appDir.delete(recursive: true);
        }
        // 创建应用目录
        await appDir.create(recursive: true);

        // 将zip中的文件提取到应用目录
        for (final file in archive) {
          final String filename = file.name;
          if (file.isFile) {
            final File extractFile = File('${appDir.path}/$filename');
            await extractFile.create(recursive: true);
            await extractFile.writeAsBytes(file.content as List<int>);
          } else {
            final Directory extractDir = Directory('${appDir.path}/$filename');
            await extractDir.create(recursive: true);
          }
        }

        // 解压成功后写入哈希文件
        await hashFile.writeAsString(currentHash);

        ErrorHandler.instance.logSuccess(
          '[MicroApp] Extracted app: $appZipFileName',
        );
      } catch (e) {
        ErrorHandler.instance.logError(
          '[MicroApp] Error extracting app $appZipFileName: $e',
        );
      }
    }
  } catch (e) {
    ErrorHandler.instance.logError('[MicroApp] Error in syncLocalApps: $e');
  }
}

// 读取解压后的应用

Future<List<H5AppItem>> handleGetCacheApps(BuildContext context) async {
  List<H5AppItem> cacheApps = [];
  List<BridgeMethodSpec> extraBridgeMethods = [];
  try {
    // 1. 获取应用支持目录
    final Directory appSupportDir = await getApplicationSupportDirectory();
    final Directory appsDir = Directory('${appSupportDir.path}/easy_ui/apps');

    // 如果appsDir目录不存在，创建一个h5目录并直接返回空列表
    if (!await appsDir.exists()) {
      ErrorHandler.instance.logError(
        '[MicroApp] apps directory does not exist: ${appsDir.path}',
      );
      await appsDir.create(recursive: true);
      ErrorHandler.instance.logSuccess(
        '[MicroApp] apps directory created: ${appsDir.path}',
      );
      return cacheApps;
    }

    // 2. 读取apps目录下的所有子目录
    final List<FileSystemEntity> entities = await appsDir.list().toList();
    for (var entity in entities) {
      if (entity is Directory) {
        final String appName =
            Uri.tryParse(entity.path)?.pathSegments.last ?? '';
        // 检查必需的文件是否都存在
        final File manifestFile = File('${entity.path}/manifest.json');
        final File iconFile = File('${entity.path}/icon.png');
        final File entryFile = File('${entity.path}/dist/index.html');

        bool manifestExists = await manifestFile.exists();
        bool iconExists = await iconFile.exists();
        bool entryExists = await entryFile.exists();

        if (manifestExists && iconExists && entryExists) {
          try {
            // 3. 读取并解析manifest.json
            String manifestContent = await manifestFile.readAsString();
            Map<String, dynamic> manifest = json.decode(manifestContent);

            // 从manifest读取应用信息
            final localizedInfo = getLocalizedAppInfo(manifest);
            String nameEn = localizedInfo['nameEn'] ?? 'Unknown App';
            String nameZh = localizedInfo['nameZh'] ?? '';
            String descriptionEn = localizedInfo['descriptionEn'] ?? '';
            String descriptionZh = localizedInfo['descriptionZh'] ?? '';
            String version = manifest['version'] ?? '1.0.0';
            String heroTag = 'cache-$appName-hero';
            if (appName == 'rich-editor') {}
            // 创建AppItem
            cacheApps.add(
              H5AppItem(
                appName: appName,
                showInMarket: true,
                nameEn: nameEn,
                nameZh: nameZh,
                descriptionEn: descriptionEn,
                descriptionZh: descriptionZh,
                version: version,
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(iconFile, fit: BoxFit.cover),
                ),
                heroTag: heroTag,
                builder:
                    (context) => H5WebView(
                      nameEn: nameEn,
                      nameZh: nameZh,
                      appName: appName,
                      bridge: AppBridge(),
                      // onlineUrl: 'http://localhost:5173',
                      localFilePath: entryFile.path,
                      extraBridgeMethods: extraBridgeMethods,
                      hideTitle: true,
                    ),
              ),
            );

            ErrorHandler.instance.logSuccess(
              '[MicroApp] Loaded cache app: $nameEn',
            );
          } catch (e) {
            ErrorHandler.instance.logError(
              '[MicroApp] Error parsing manifest for $appName: $e',
            );
          }
        } else {
          ErrorHandler.instance.logError(
            '[MicroApp] Skipping $appName - missing required files\n'
            '    manifest.json: $manifestExists\n;'
            '    icon.png: $iconExists\n;'
            '    dist/index.html: $entryExists;',
          );
        }
      }
    }
  } catch (e) {
    ErrorHandler.instance.logError('[MicroApp] Error loading cache apps: $e');
  }

  return cacheApps;
}

/// 从 manifest 中提取本地化的应用名称和描述
Map<String, String> getLocalizedAppInfo(Map<String, dynamic> manifest) {
  final locales = manifest['locales'] as Map<String, dynamic>?;

  // 默认值
  String nameEn = 'Unknown App';
  String nameZh = '';
  String descriptionEn = '';
  String descriptionZh = '';

  // 从 locales 中提取本地化信息
  if (locales != null) {
    // 提取英文信息 (优先检查 'en'，然后 'en-US')
    Map<String, dynamic>? enLocale;
    if (locales.containsKey('en')) {
      enLocale = locales['en'] as Map<String, dynamic>?;
    } else if (locales.containsKey('en-US')) {
      enLocale = locales['en-US'] as Map<String, dynamic>?;
    }

    if (enLocale != null) {
      nameEn = enLocale['name'] as String? ?? 'Unknown App';
      descriptionEn = enLocale['description'] as String? ?? '';
    }

    // 提取中文信息 (优先检查 'zh-CN'，然后 'zh')
    Map<String, dynamic>? zhLocale;
    if (locales.containsKey('zh-CN')) {
      zhLocale = locales['zh-CN'] as Map<String, dynamic>?;
    } else if (locales.containsKey('zh')) {
      zhLocale = locales['zh'] as Map<String, dynamic>?;
    }

    if (zhLocale != null) {
      nameZh = zhLocale['name'] as String? ?? '';
      descriptionZh = zhLocale['description'] as String? ?? '';
    }
  }

  return {
    'nameEn': nameEn,
    'nameZh': nameZh,
    'descriptionEn': descriptionEn,
    'descriptionZh': descriptionZh,
  };
}

Future<String> buildLocalFileUrl(
  String localFilePath,
  LocalhostServerManager serverManager, {
  List<LocalhostProxyRule>? proxyRules,
}) async {
  final file = File(localFilePath);
  if (!await file.exists()) {
    throw Exception('Local file does not exist: $localFilePath');
  }
  final directory = file.parent;
  final fileName = p.basename(file.path);
  final baseUrl = await serverManager.start(
    fileSystemDocumentRoot: directory.path,
    proxyRules: proxyRules,
  );
  final url = '$baseUrl/$fileName';
  return url;
}
