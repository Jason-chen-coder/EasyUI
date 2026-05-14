import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';

BytesLoader createEasySvgFileLoaderImpl(
  Object file, {
  SvgTheme? theme,
  ColorMapper? colorMapper,
}) {
  return SvgFileLoader(file as File, theme: theme, colorMapper: colorMapper);
}
