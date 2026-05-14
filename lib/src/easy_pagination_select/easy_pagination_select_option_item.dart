import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../easy_avatar/easy_avatar.dart';
import '../easy_menu/easy_list_pop_menu.dart';
import '../easy_menu/easy_menu_anchor.dart';
import '../easy_theme.dart';

/// 单选下拉选项组件
class EasyPaginationSingleSelectOptionItem<T> extends StatelessWidget {
  const EasyPaginationSingleSelectOptionItem({
    super.key,
    required this.index,
    required this.option,
    required this.selected,
    required this.menuController,
    this.onSelectChanged,
    required this.defaultTitleStyle,
  });

  final int index;
  final EasyListPopMenuOption<T> option;
  final bool selected;
  final ValueChanged<T>? onSelectChanged;
  final EasyMenuController menuController;
  final TextStyle defaultTitleStyle;

  @override
  Widget build(BuildContext context) {
    final item = option;
    final easyTheme = EasyTheme.of(context);
    final titleStyle = TextStyle(
      color: selected ? easyTheme.primaryGreen : easyTheme.neutral66,
      fontSize: 16,
      height: 1,
    );
    final contentPadding = EdgeInsets.only(left: 24, right: 16);

    return switch (item) {
      SimpleEasyListPopMenuOption<T>() => ListTile(
        key: ValueKey(item),
        contentPadding: contentPadding,
        title: Text(item.title, style: titleStyle),
        trailing:
            selected
                ? SvgPicture.asset(
                  'assets/svgs/ic_selected.svg',
                  package: 'easy_ui',
                )
                : null,
        onTap:
            selected
                ? null
                : () {
                  if (menuController.isOpen) menuController.close();
                  onSelectChanged?.call(item.value);
                },
      ),
      UserEasyListPopMenuOption<T>() => _UserCheckBoxListTile(
        value: selected,
        avatar: item.avatarUrl,
        title: item.title,
        email: item.email,
        titleStyle: defaultTitleStyle,
        padding: contentPadding,
        checkBoxShape: CircleBorder(),
        onChanged: (_) {
          if (selected) return;
          if (menuController.isOpen) menuController.close();
          onSelectChanged?.call(item.value);
        },
      ),
    };
  }
}

/// 多选下拉选项组件
class EasyPaginationMultipleSelectOptionItem<T> extends StatelessWidget {
  const EasyPaginationMultipleSelectOptionItem({
    super.key,
    required this.index,
    required this.option,
    required this.selected,
    this.onSelectChanged,
    required this.defaultTitleStyle,
  });

  final int index;
  final EasyListPopMenuOption<T> option;
  final bool? selected;
  final ValueChanged<({T option, bool? select})>? onSelectChanged;
  final TextStyle defaultTitleStyle;

  @override
  Widget build(BuildContext context) {
    final item = option;
    final easyTheme = EasyTheme.of(context);

    final contentPadding = EdgeInsets.only(left: 24, right: 16);

    return switch (item) {
      SimpleEasyListPopMenuOption<T>() => CheckboxListTile(
        value: selected,
        contentPadding: contentPadding,
        tristate: true,
        controlAffinity: ListTileControlAffinity.leading,
        side:
            selected == true
                ? BorderSide(color: Colors.transparent)
                : BorderSide(color: easyTheme.neutralEE),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFD9D9D9);
          }
          if (states.contains(WidgetState.selected)) {
            return selected == null
                ? easyTheme.primaryGreen.withAlpha(0x33)
                : easyTheme.primaryGreen;
          }
          return Colors.white;
        }),
        checkColor: selected == null ? easyTheme.primaryGreen : Colors.white,
        title: Tooltip(
          message: item.title,
          preferBelow: false,
          child: Text(
            item.title,
            style: defaultTitleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onChanged: (selectVal) {
          onSelectChanged?.call((option: item.value, select: selectVal));
        },
      ),
      UserEasyListPopMenuOption<T>() => _UserCheckBoxListTile(
        value: selected == true,
        avatar: item.avatarUrl,
        title: item.title,
        email: item.email,
        titleStyle: defaultTitleStyle,
        padding: contentPadding,
        onChanged: (selectVal) {
          onSelectChanged?.call((option: item.value, select: selectVal));
        },
      ),
    };
  }
}

class _UserCheckBoxListTile extends StatelessWidget {
  const _UserCheckBoxListTile({
    required this.value,
    this.onChanged,
    required this.avatar,
    required this.title,
    required this.email,
    required this.titleStyle,
    required this.padding,
    this.checkBoxShape,
  });

  static const double height = 50.0;

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String avatar;
  final String title;
  final String email;
  final TextStyle? titleStyle;
  final EdgeInsets padding;
  final OutlinedBorder? checkBoxShape;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final initials = computeInitials(title);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          onChanged?.call(!value);
        },
        child: Container(
          height: height,
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                shape: checkBoxShape,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return const Color(0xFFD9D9D9);
                  }
                  if (states.contains(WidgetState.selected)) {
                    return easyTheme.primaryGreen;
                  }
                  return Colors.white;
                }),
                checkColor: Colors.white,
                side:
                    value
                        ? BorderSide(color: Colors.transparent)
                        : BorderSide(color: easyTheme.neutralEE),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: EasyAvatar.withUsername(
                  size: 32,
                  src: avatar,
                  username: title,
                ),
              ),
              Expanded(
                child: Tooltip(
                  message: '$title\n$email',
                  preferBelow: false,
                  exitDuration: Duration.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12,
                          color: easyTheme.neutral99,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
