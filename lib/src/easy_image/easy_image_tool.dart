extension EasyImageStringExtension on String {
  bool get isNetwork => startsWith('http://') || startsWith('https://');
  bool get isAsset => !contains('/') || startsWith('assets/');
  bool get isFileUri => startsWith('file://');

  /// 将 file:// URI 转换为实际的文件系统路径
  String get normalizeFilePath {
    if (isFileUri) {
      try {
        // 使用 Uri 解析并转换为文件路径
        final uri = Uri.parse(this);
        return uri.toFilePath();
      } catch (e) {
        // 如果 URI 解析失败，尝试手动处理
        // file:///path/to/file -> /path/to/file
        // file://path/to/file -> path/to/file
        if (startsWith('file:///')) {
          return substring(7); // 去掉 'file://'
        } else if (startsWith('file://')) {
          return substring(7); // 去掉 'file://'
        }
        return this;
      }
    }
    return this;
  }
}
