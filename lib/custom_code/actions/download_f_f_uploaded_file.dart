// Automatic FlutterFlow imports

import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:download/download.dart';
import 'dart:io';

Future<List<dynamic>> downloadFFUploadedFile(
    FFUploadedFile pdfFile, String name) async {
  try {
    name = '$name.pdf';
    late String filePath;

    if (Platform.isAndroid) {
      // Save to public Downloads directory on Android
      final directory = Directory('/storage/emulated/0/Download');
      filePath = '${directory.path}/$name';
    } else if (Platform.isIOS) {
      // Save to the temporary directory on iOS
      final directory = await getTemporaryDirectory();
      filePath = '${directory.path}/$name';
    }

    // Write the PDF bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(pdfFile.bytes!);

    // Log file path for debugging
    print('🟢 PDF saved to: $filePath');

    // Share the PDF file using XFile
    final xFile = XFile(filePath);

    await Share.shareXFiles([xFile], subject: '$name');

    return [
      {'fileName': name},
      {'filePath': filePath}
    ];

    print('File saved and ready to share.');
  } catch (e) {
    print('Error saving or sharing PDF: $e');

    // Handle errors gracefully
    return [
      {'fileName': ''},
      {'filePath': ''}
    ];
  }
}
