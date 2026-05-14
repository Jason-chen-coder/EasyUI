import 'package:flutter_svg/flutter_svg.dart';

import 'easy_svg_file_loader_stub.dart'
    if (dart.library.io) 'easy_svg_file_loader_io.dart';

BytesLoader createEasySvgFileLoader(
  Object file, {
  SvgTheme? theme,
  ColorMapper? colorMapper,
}) {
  return createEasySvgFileLoaderImpl(
    file,
    theme: theme,
    colorMapper: colorMapper,
  );
}
