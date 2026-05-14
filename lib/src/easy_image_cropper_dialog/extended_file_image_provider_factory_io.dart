import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';

ImageProvider createExtendedFileImageProviderImpl(FileImage image) {
  return ExtendedFileImageProvider(image.file, cacheRawData: true);
}
