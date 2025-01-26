// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:download/download.dart';
import 'dart:io';
import 'package:share/share.dart';

Future<List<dynamic>> downloadFFUploadedFile(
    FFUploadedFile pdfFile, String name) async {
  final fileName = "$name.pdf";

  Directory? appDir;

  // Get the byte stream of the PDF file
  List<int> bytes = pdfFile.bytes!;

  Stream<int> stream = Stream.fromIterable(bytes);

  if (kIsWeb) {
    await download(stream, fileName);
    return [
      {'fileName': fileName},
      {'filePath': fileName}
    ];
  } else if (Platform.isAndroid) {
    appDir = appDir = Directory('/storage/emulated/0/Download');
  } else if (Platform.isIOS) {
    appDir = await getApplicationDocumentsDirectory();
  } else {
    appDir = await getDownloadsDirectory();
  }
  String pathName = appDir?.path ?? "";
  String destinationPath = await getDestinationPathName(fileName, pathName,
      isBackwardSlash: Platform.isWindows);
  await download(stream, destinationPath);


  if (Platform.isIOS) {
    Share.shareFiles(
      [destinationPath],
    );
  }

  print('🔴🔴🔴🔴🔴 ${destinationPath}');

  return [
    {'fileName': fileName},
    {'filePath': destinationPath}
  ];
}

Future<String> getDestinationPathName(String fileName, String pathName,
    {bool isBackwardSlash = true}) async {
  String destinationPath =
      pathName + "${isBackwardSlash ? "\\" : "/"}${fileName}";
  int i = 1;
  bool _isFileExists = await File(destinationPath).exists();
  if(_isFileExists){
    await File(destinationPath).delete();
    _isFileExists = false;
  }
  while (_isFileExists) {
    _isFileExists =
        await File(pathName + "${isBackwardSlash ? "\\" : "/"}($i)${fileName}")
            .exists();
    if (_isFileExists == false) {
      destinationPath =
          pathName + "${isBackwardSlash ? "\\" : "/"}${fileName}";
      break;
    }
    i++;
  }
  return destinationPath;
}
