import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class EasyUserListTile extends StatelessWidget {
  const EasyUserListTile({
    super.key,
    required this.userAvatar,
    required this.userName,
    required this.userEmail,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.avatarSize = 32,
    this.userNameTextStyle,
    this.userEmailTextStyle,
    this.userEmailMaxLines = 2,
    this.showTooltip = true,
  });

  factory EasyUserListTile.large({
    required String userAvatar,
    required String userName,
    required String userEmail,
    int userEmailMaxLines = 2,
  }) {
    return EasyUserListTile(
      userAvatar: userAvatar,
      userName: userName,
      userEmail: userEmail,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      avatarSize: 40,
      userNameTextStyle: const TextStyle(
        fontSize: 16,
        height: 1,
        overflow: TextOverflow.ellipsis,
      ),
      userEmailTextStyle: const TextStyle(
        fontSize: 14,
        height: 1.2,
        overflow: TextOverflow.ellipsis,
      ),
      userEmailMaxLines: userEmailMaxLines,
    );
  }

  final String userAvatar;
  final String userName;
  final String userEmail;
  final EdgeInsets contentPadding;
  final double avatarSize;
  final TextStyle? userNameTextStyle;
  final TextStyle? userEmailTextStyle;
  final int userEmailMaxLines;
  final bool showTooltip;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context).style;
    return Padding(
      padding: contentPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectionContainer.disabled(
            child: EasyAvatar.withUsername(
              src: userAvatar,
              size: avatarSize,
              username: userName,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: defaultTextStyle.copyWith(
                    fontSize: 14,
                    color: easyTheme.neutral66,
                    height: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  child:
                      showTooltip
                          ? Tooltip(
                            message: userName,
                            child: Text(userName, style: userNameTextStyle),
                          )
                          : Text(userName, style: userNameTextStyle),
                ),
                DefaultTextStyle(
                  style: defaultTextStyle.copyWith(
                    fontSize: 12,
                    color: easyTheme.neutral99,
                    height: 1.33,
                    overflow: TextOverflow.ellipsis,
                  ),
                  child:
                      showTooltip
                          ? Tooltip(
                            message: userEmail,
                            child: Text(
                              userEmail.split('').join('\u{200b}'),
                              style: userEmailTextStyle,
                              maxLines: userEmailMaxLines,
                            ),
                          )
                          : Text(
                            userEmail.split('').join('\u{200b}'),
                            style: userEmailTextStyle,
                            maxLines: userEmailMaxLines,
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
