import 'package:flutter_svg/flutter_svg.dart';

BytesLoader createEasySvgFileLoaderImpl(
  Object file, {
  SvgTheme? theme,
  ColorMapper? colorMapper,
}) {
  return SvgStringLoader(
    '<svg xmlns="http://www.w3.org/2000/svg"></svg>',
    theme: theme,
    colorMapper: colorMapper,
  );
}
