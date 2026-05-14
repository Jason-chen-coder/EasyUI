import 'package:easy_ui/src/easy_file_drag_area/easy_file_drag_area.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EasyFileDragAreaFormField extends FormField<List<EasyFileDraggedItem>> {
  EasyFileDragAreaFormField({
    super.key,
    super.autovalidateMode,
    super.onSaved,
    super.validator,
    super.restorationId,
    FileType type = FileType.any,
    bool allowMultiple = false,
    List<String>? allowedExtensions,
    bool showFileList = false,
    ValueChanged<List<EasyFileDraggedItem>>? onFilesChanged,
  }) : super(
         initialValue: null,
         forceErrorText: null,
         enabled: true,
         builder: (state) {
           return EasyFileDragArea(
             type: type,
             allowMultiple: allowMultiple,
             allowedExtensions: allowedExtensions,
             showFileList: showFileList,
             onFilesChanged: (items) {
               state.didChange(items);
               onFilesChanged?.call(items);
             },
             error: state.hasError ? state.errorText : null,
           );
         },
       );
}
