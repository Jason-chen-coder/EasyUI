import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../dashboard.dart';

/// Save dashboard to file
Future<void> saveDashboard(Dashboard dashboard) async {
  final appDocDir = await path.getApplicationDocumentsDirectory();
  dashboard.saveDashboard('${appDocDir.path}/FLOWCHART.json');
}

Future<void> saveProtocolData(Dashboard dashboard, dynamic protocolData) async {
  final appDocDir = await path.getApplicationDocumentsDirectory();
  dashboard.saveProtocolData(
    '${appDocDir.path}/PROTOCOLDATA.json',
    protocolData,
  );
}

/// Load dashboard from file
Future<void> loadDashboard(Dashboard dashboard) async {
  final appDocDir = await path.getApplicationDocumentsDirectory();
  dashboard.loadDashboard('${appDocDir.path}/FLOWCHART.json');
}

/// Pick image
Future<Uint8List?> pickImageBytes() async {
  final pickResult = await FilePicker.platform.pickFiles(type: FileType.image);
  if (pickResult == null) return null;
  return File(pickResult.files.single.path!).readAsBytesSync();
}
