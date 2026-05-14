import 'dart:io';
import 'package:flutter/material.dart';

import '../../easy_ui.dart';

String computeInitials(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) return "";
  final List<String> parts = trimmed.split(RegExp(r"\s+"));
  if (parts.length >= 2) {
    final String first = parts[0].isNotEmpty ? parts[0][0] : '';
    final String second = parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }
  // Single word: take first two characters if available
  final String word = parts[0];
  if (word.length >= 2) {
    return (word[0] + word[1]).toUpperCase();
  }
  return word[0].toUpperCase();
}

class EasyAvatar extends StatelessWidget {
  const EasyAvatar({
    super.key,
    this.initials,
    this.src,
    this.size,
    this.backgroundColor,
    this.initialsColor = Colors.white,
    this.showBorder = false,
    this.packageName,
  });

  factory EasyAvatar.withUsername({
    required String src,
    required String username,
    double? size,
    bool showBorder = false,
  }) {
    final initials = computeInitials(username);
    String? realSrc = src.isEmpty ? null : src;
    String? packageName;
    if (src.isEmpty && username.isEmpty) {
      realSrc = 'assets/images/default_user_avatar.png';
      packageName = 'easy_ui';
    }
    return EasyAvatar(
      src: realSrc,
      packageName: packageName,
      size: size,
      showBorder: showBorder,
      initials: initials,
      backgroundColor: EasyAvatarItem.colorFromInitial(initials),
    );
  }

  final Color? initialsColor;
  final String? initials;
  final String? src;
  final double? size;
  final Color? backgroundColor;
  final bool? showBorder;
  final String? packageName;

  ImageProvider? _buildImageProvider(String src) {
    if (src.startsWith('http://') || src.startsWith('https://')) {
      return NetworkImage(src);
    }
    if (src.startsWith('assets/') || !src.contains('/')) {
      return AssetImage(src);
    }
    return FileImage(File(src));
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveSize = size ?? 32.0;
    final Color effectiveBackground =
        backgroundColor ?? const Color(0xFFFFFFFF);

    final ImageProvider? provider =
        (src != null && src!.isNotEmpty) ? _buildImageProvider(src!) : null;
    final String initialsText = initials ?? "";
    final easyTheme = EasyTheme.of(context);
    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: BorderRadius.circular(effectiveSize / 2),
          border: Border.all(
            color: easyTheme.neutralEE,
            width: showBorder == true ? 1 : 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(effectiveSize / 2),
          child:
              src != null
                  ? EasyImage(
                    src: src!,
                    width: effectiveSize,
                    height: effectiveSize,
                    fit: BoxFit.cover,
                    packageName: packageName,
                  )
                  : Center(
                    child: Text(
                      initialsText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: initialsColor,
                        fontSize: effectiveSize * 0.35,
                        height: 1.0,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
