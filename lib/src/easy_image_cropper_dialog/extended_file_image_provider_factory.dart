import 'package:flutter/widgets.dart';

import 'extended_file_image_provider_factory_stub.dart'
    if (dart.library.io) 'extended_file_image_provider_factory_io.dart';

ImageProvider? createExtendedFileImageProvider(FileImage image) {
  return createExtendedFileImageProviderImpl(image);
}
