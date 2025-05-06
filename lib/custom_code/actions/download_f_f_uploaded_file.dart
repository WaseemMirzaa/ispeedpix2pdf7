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
import 'package:download/download.dart';
import 'dart:io';

Future<List<dynamic>> downloadFFUploadedFile(
    FFUploadedFile pdfFile, String name) async {
  try {
    name = '$name.pdf';

    Directory? directory;

    String? filePath;

    if (Platform.isAndroid) {
       try {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$name';
      
      // Write the PDF bytes to the file
      final file = File(filePath);
      await file.writeAsBytes(pdfFile.bytes!);
      
      // For Android 10+ (API 29+), use MediaStore API
      if (int.parse(Platform.version.split('.')[0]) >= 10) {
        const MethodChannel channel = MethodChannel('com.mycompany.ispeedpix2pdf7/file');
        
        try {
          // Call the native code (Kotlin) via MethodChannel
          await channel.invokeMethod('saveToMediaStore', {
            'filePath': filePath,
            'fileName': name,
            'mimeType': 'application/pdf'
          });
        } on PlatformException catch (e) {
          print("Error saving file to MediaStore: ${e.message}");
        }
      }
      
      // Share the PDF file
      const MethodChannel channel = MethodChannel('com.mycompany.ispeedpix2pdf7/file');
      try {
        await channel.invokeMethod('shareFile', {'filePath': filePath});
      } on PlatformException catch (e) {
        print("Error sharing file: ${e.message}");
      }
      
      return [
        {'fileName': name},
        {'filePath': filePath}
      ];
    } catch (e) {
      print('Error saving PDF: $e');
      rethrow;
    }
    //   directory = await getTemporaryDirectory();
    //   filePath = '${directory.path}/$name';

    //   if (!await directory.exists()) {
    //     await directory.create(recursive: true);
    //   }

    //   final file = File(filePath);
    //   if (await file.exists()) {
    //     await file.delete();
    //   }
    // } else if (Platform.isIOS) {
    //   // Save to the temporary directory on iOS
    //   final directory = await getTemporaryDirectory();

    //   filePath = '${directory.path}/$name';
    // }

    // // Write the PDF bytes to the file
    // final file = File(filePath);

    // await file.writeAsBytes(pdfFile.bytes!);

    // // Log file path for debugging
    // print('🟢 PDF saved to: $filePath');

    // // Share the PDF file using XFile

    // if (Platform.isAndroid) {
    //   // final Uri uri = Uri.file(file.path);
    //   // final xFile = XFile(uri.toString());

    //   const MethodChannel channel =
    //       MethodChannel('com.mycompany.ispeedpix2pdf7/file');

    //   try {
    //     // Call the native code (Kotlin) via MethodChannel
    //     await channel.invokeMethod('shareFile', {'filePath': filePath});
    //   } on PlatformException catch (e) {
    //     print("Error sharing file: ${e.message}");
    //   }
    } else {
      final bool isIpad = await _isIpad();

      if (isIpad) {

        try {
          print('📱 Attempting to share on iPad');

          final file = File(filePath!);
          if (!await file.exists()) {
            // LogHelper.logErrorMessage(
            // 'iPad Sharing', 'File does not exist at path: $filePath');
            throw Exception('File does not exist');
          }

          // Move file to Documents directory for better iOS compatibility
          final documentsDir = await getApplicationDocumentsDirectory();
          final newFilePath = '${documentsDir.path}/$name';
          await file.copy(newFilePath);

          // LogHelper.logMessage('iPad Sharing', 'File copied to: $newFilePath');

          // Ensure the file exists and is readable
          // final file = File(newFilePath);
          if (!await file.exists()) {
            throw Exception('File does not exist at path: $newFilePath');
          }

          const platform = MethodChannel('com.mycompany.ispeedpix2pdf7/share');

          print('📱 Invoking shareFileOnIpad method with path: $newFilePath');

          final bool result = await platform.invokeMethod('shareFileOnIpad', {
            'filePath': newFilePath,
            'mimeType': 'application/pdf',
            'fileName': name,
          });

          print('📱 Share result: $result');

          if (!result) {
            throw Exception('Failed to share on iPad');
          }
        } catch (e) {
          print('🔴 Error sharing on iPad: $e');
          throw Exception('Failed to share on iPad: $e');
        }
        // Use native iOS sharing for iPad

      } else {
        final xFile = XFile(filePath!);
        await Share.shareXFiles([xFile], subject: '$name');
      }
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

Future<bool> _isIpad() async {
  if (!Platform.isIOS) return false;
  final deviceInfo = await DeviceInfoPlugin().iosInfo;
  return deviceInfo.model.toLowerCase().contains('ipad');
}
