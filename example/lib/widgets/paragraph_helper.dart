import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

Widget h1(String text, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8.0),
    child: SelectableText(
      text,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
    ),
  );
}

Widget h2(String text, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
    ),
  );
}

Widget h3(String text, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
    ),
  );
}

Widget h4(String text, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    ),
  );
}

Widget p(String text, {Color? color}) {
  return Builder(
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color:
                color ??
                EasyTheme.of(context).onBackground.withValues(alpha: 0.54),
          ),
        ),
      );
    },
  );
}

Widget div() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: const Divider(),
  );
}

enum TipType { info, success, warning, error }

Widget tip(String text, {TipType type = TipType.info}) {
  Color backgroundColor;
  Color textColor;

  switch (type) {
    case TipType.success:
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      break;
    case TipType.warning:
      backgroundColor = Colors.yellow[100]!;
      textColor = Colors.yellow[800]!;
      break;
    case TipType.error:
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      break;
    case TipType.info:
      backgroundColor = Colors.blue[100]!;
      textColor = Colors.blue[800]!;
      break;
  }

  return Container(
    width: double.maxFinite,
    padding: const EdgeInsets.symmetric(vertical: 12),
    margin: EdgeInsets.only(bottom: 8.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      border: Border(left: BorderSide(color: textColor, width: 4)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: EasyMarkdown(
      text: text,
      pConfig: PConfig(
        textStyle: TextStyle(fontSize: 16, height: 1.55, color: textColor),
      ),
    ),
  );
}

Widget markdown(String text) => EasyMarkdown(text: text);
