// Automatic FlutterFlow imports

import 'package:flutter/services.dart';
// import 'package:flutter_share/flutter_share.dart';

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
    Directory? directory;

    late String filePath;

    if (Platform.isAndroid) {
      // Save to public Downloads directory on Android

      // Get app-specific external storage directory
      directory = await getTemporaryDirectory(); // Scoped storage
      filePath = '${directory!.path}/$name';

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      // String newPath = "";
      // List<String> folders = directory.path.split("/");
      // for (int i = 1; i < folders.length; i++) {
      //   String folder = folders[i];
      //   if (folder != "Android") {
      //     newPath += "/$folder";
      //   } else {
      //     break;
      //   }
      // }
      // newPath +=
      //     "/Download"; // Save to a "Download" folder inside app-specific storage
      // directory = Directory(newPath);
      // filePath = '${directory.path}/$name';
      // else {
      // Fallback to the public Downloads directory
      // directory = Directory('/storage/emulated/0/Download');
      // filePath = '${directory.path}/$name';
      // }
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

    // Share the PDF file using XFil
    // e

    if (Platform.isAndroid) {
      // final Uri uri = Uri.file(file.path);
      // final xFile = XFile(uri.toString());

      const MethodChannel _channel =
          MethodChannel('com.mycompany.ispeedpix2pdf7/file');

      try {
        // Call the native code (Kotlin) via MethodChannel
        await _channel.invokeMethod('shareFile', {'filePath': filePath});
      } on PlatformException catch (e) {
        print("Error sharing file: ${e.message}");
      }
      // );
      // await Share.shareXFiles([xFile], subject: '$name');
    } else {
      final xFile = XFile(filePath);
      await Share.shareXFiles([xFile], subject: '$name');
    }

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
