// Automatic FlutterFlow imports

import 'package:device_info_plus/device_info_plus.dart';
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
// import 'package:download/download.dart'; // commented: deprecated; not used on mobile
import 'dart:io';

Future<List<dynamic>> downloadFFUploadedFile(
    FFUploadedFile pdfFile, String name) async {
  const String LOG_TAG = "PDF_DOWNLOAD";
  try {
    print('[$LOG_TAG] Starting download for file: $name');
    name = '$name.pdf';
    print('[$LOG_TAG] File name with extension: $name');

    Directory? directory;

    String? filePath;

    if (Platform.isAndroid) {
      try {
        print('[$LOG_TAG] Android platform detected');
        final directory = await getExternalStorageDirectory();
        print('[$LOG_TAG] External storage directory: ${directory?.path}');
        final filePath = '${directory!.path}/$name';
        print('[$LOG_TAG] File will be saved to: $filePath');

        // Write the PDF bytes to the file
        final file = File(filePath);
        print('[$LOG_TAG] Writing ${pdfFile.bytes?.length ?? 0} bytes to file');
        await file.writeAsBytes(pdfFile.bytes!);
        print('[$LOG_TAG] File written successfully');

        // For Android 10+ (API 29+), use MediaStore API
        final androidVersion = int.parse(Platform.version.split('.')[0]);
        print('[$LOG_TAG] Android version: $androidVersion');

        if (int.parse(Platform.version.split('.')[0]) >= 10) {
          print('[$LOG_TAG] Using MediaStore API for Android 10+');
          const MethodChannel channel =
              MethodChannel('com.mycompany.ispeedpix2pdf7/file');

          try {
            // Call the native code (Kotlin) via MethodChannel
            print('[$LOG_TAG] Calling saveToMediaStore method');
            await channel.invokeMethod('saveToMediaStore', {
              'filePath': filePath,
              'fileName': name,
              'mimeType': 'application/pdf'
            });
            print('[$LOG_TAG] File saved to MediaStore successfully');
          } on PlatformException catch (e) {
            print("[$LOG_TAG] Error saving file to MediaStore: ${e.message}");
          }
        }

        // Share the PDF file
        print('[$LOG_TAG] Preparing to share file');
        const MethodChannel channel =
            MethodChannel('com.mycompany.ispeedpix2pdf7/file');
        try {
          print('[$LOG_TAG] Calling shareFile method');
          await channel.invokeMethod('shareFile', {'filePath': filePath});
          print('[$LOG_TAG] File shared successfully');
        } on PlatformException catch (e) {
          print("[$LOG_TAG] Error sharing file: ${e.message}");
        }

        print('[$LOG_TAG] Android download and share completed successfully');
        return [
          {'fileName': name},
          {'filePath': filePath}
        ];
      } catch (e) {
        print('[$LOG_TAG] Error saving PDF: $e');
        rethrow;
      }
    } else {
      print('[$LOG_TAG] iOS platform detected');
      final bool isIpad = await _isIpad();
      print('[$LOG_TAG] Device is iPad: $isIpad');

      if (isIpad) {
        try {
          print('[$LOG_TAG] 📱 Attempting to share on iPad');
          final directory = await getTemporaryDirectory();
          print('[$LOG_TAG] Temporary directory: ${directory.path}');

          // Create the file path
          filePath = '${directory.path}/$name';
          print('[$LOG_TAG] File path: $filePath');

          // Create the file and write bytes to it
          final file = File(filePath!);
          print(
              '[$LOG_TAG] Writing ${pdfFile.bytes?.length ?? 0} bytes to file');
          await file.writeAsBytes(pdfFile.bytes ?? Uint8List(0));
          print('[$LOG_TAG] File written successfully');

          // Check if file exists after writing
          print('[$LOG_TAG] Checking if file exists at path: $filePath');
          if (!await file.exists()) {
            print('[$LOG_TAG] File does not exist after writing: $filePath');
            throw Exception('Failed to write file');
          }

          // Move file to Documents directory for better iOS compatibility
          final documentsDir = await getApplicationDocumentsDirectory();
          print('[$LOG_TAG] Documents directory: ${documentsDir.path}');
          final newFilePath = '${documentsDir.path}/$name';
          print('[$LOG_TAG] Copying file to: $newFilePath');

          // Create the new file by copying
          final newFile = await file.copy(newFilePath);
          print('[$LOG_TAG] File copied successfully');

          // Ensure the new file exists and is readable
          print('[$LOG_TAG] Verifying new file exists');
          if (!await newFile.exists()) {
            print('[$LOG_TAG] New file does not exist at path: $newFilePath');
            throw Exception('Failed to copy file to documents directory');
          }

          const platform = MethodChannel('com.mycompany.ispeedpix2pdf7/share');

          print(
              '[$LOG_TAG] 📱 Invoking shareFileOnIpad method with path: $newFilePath');

          // Handle potential null result from platform channel
          final result = await platform.invokeMethod<bool>('shareFileOnIpad', {
            'filePath': newFilePath,
            'mimeType': 'application/pdf',
            'fileName': name,
          });

          print('[$LOG_TAG] 📱 Share result: $result');

          if (result == null || result == false) {
            print('[$LOG_TAG] Share failed with result: $result');
            throw Exception('Failed to share on iPad: null or false result');
          }

          print('[$LOG_TAG] iPad sharing completed successfully');
        } catch (e) {
          print('[$LOG_TAG] 🔴 Error sharing on iPad: $e');
          // Don't rethrow, just return empty values to handle gracefully
          return [
            {'fileName': name},
            {'filePath': filePath ?? ''}
          ];
        }
        // Use native iOS sharing for iPad
      } else {
        // Save to the temporary directory on iOS
        final directory = await getTemporaryDirectory();

        filePath = '${directory.path}/$name';

        // }

        // Write the PDF bytes to the file
        final file = File(filePath);

        await file.writeAsBytes(pdfFile.bytes!);

        print('[$LOG_TAG] Using Share.shareXFiles for iOS (non-iPad)');
        final xFile = XFile(filePath!);
        print('[$LOG_TAG] Created XFile from path: $filePath');
        await Share.shareXFiles([xFile], subject: '$name');
        print('[$LOG_TAG] File shared successfully via shareXFiles');
      }
    }

    print('[$LOG_TAG] Download and share process completed');
    return [
      {'fileName': name},
      {'filePath': filePath}
    ];

    print('[$LOG_TAG] File saved and ready to share.');
  } catch (e) {
    print('[$LOG_TAG] Error saving or sharing PDF: $e');
    print('[$LOG_TAG] Stack trace: ${StackTrace.current}');

    // Handle errors gracefully
    return [
      {'fileName': ''},
      {'filePath': ''}
    ];
  }
}

Future<bool> _isIpad() async {
  if (!Platform.isIOS) return false;
  final deviceInfo = await DeviceInfoPlugin().iosInfo;
  return deviceInfo.model.toLowerCase().contains('ipad');
}
