import 'package:flutter/material.dart';

import 'easy_dropdown_textfield.dart';
import 'easy_tooltip_widget.dart';

class EasyMultiSelection2 extends StatefulWidget {
  const EasyMultiSelection2({
    super.key,
    required this.onChanged,
    required this.dropDownList,
    required this.list,
    required this.height,
    this.buttonColor,
    this.buttonText,
    this.buttonTextStyle,
    required this.listTileHeight,
    required this.listPadding,
    this.listTextStyle,
    this.checkBoxProperty,
    this.hintText,
  });
  final List<DropDownValueModel> dropDownList;
  final ValueSetter onChanged;
  final List<bool> list;
  final double height;
  final Color? buttonColor;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final double listTileHeight;
  final TextStyle? listTextStyle;
  final ListPadding listPadding;
  final CheckBoxProperty? checkBoxProperty;
  final String? hintText;

  @override
  _MultiSelectionState2 createState() => _MultiSelectionState2();
}

class _MultiSelectionState2 extends State<EasyMultiSelection2> {
  List<bool> multiSelectionValue = [];

  @override
  void initState() {
    multiSelectionValue = List.from(widget.list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 10, left: 10, top: 10),
                child: Text(
                  widget.hintText ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: widget.height,
          child: Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.dropDownList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: widget.listTileHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.listPadding.bottom,
                      top: widget.listPadding.top,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          multiSelectionValue[index] =
                              !multiSelectionValue[index];
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: multiSelectionValue[index],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  multiSelectionValue[index] = value;
                                });
                              }
                            },
                            tristate:
                                widget.checkBoxProperty?.tristate ?? false,
                            mouseCursor: widget.checkBoxProperty?.mouseCursor,
                            activeColor: widget.checkBoxProperty?.activeColor,
                            fillColor: widget.checkBoxProperty?.fillColor,
                            checkColor: widget.checkBoxProperty?.checkColor,
                            focusColor: widget.checkBoxProperty?.focusColor,
                            hoverColor: widget.checkBoxProperty?.hoverColor,
                            overlayColor: widget.checkBoxProperty?.overlayColor,
                            splashRadius: widget.checkBoxProperty?.splashRadius,
                            materialTapTargetSize:
                                widget.checkBoxProperty?.materialTapTargetSize,
                            visualDensity:
                                widget.checkBoxProperty?.visualDensity,
                            focusNode: widget.checkBoxProperty?.focusNode,
                            autofocus:
                                widget.checkBoxProperty?.autofocus ?? false,
                            shape: widget.checkBoxProperty?.shape,
                            side: widget.checkBoxProperty?.side,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.dropDownList[index].name,
                                      style: widget.listTextStyle,
                                    ),
                                  ),
                                  if (widget.dropDownList[index].toolTipMsg !=
                                      null)
                                    EasyToolTipWidget(
                                      msg:
                                          widget
                                              .dropDownList[index]
                                              .toolTipMsg!,
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
              },
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 8.0,
                  top: 15,
                  bottom: 10,
                ),
                child: InkWell(
                  onTap: () => widget.onChanged(multiSelectionValue),
                  child: Container(
                    height: widget.listTileHeight * 0.9,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: widget.buttonColor ?? Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Align(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.buttonText ?? "Ok",
                          style:
                              widget.buttonTextStyle ??
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
