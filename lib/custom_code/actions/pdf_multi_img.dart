// Automatic FlutterFlow imports
import 'dart:isolate';

import '/flutter_flow/flutter_flow_util.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
//TODO VERSION 1 STABLE

// Modified class to serialize data
class SerializableFile {
  final Uint8List bytes;
  final String name;

  SerializableFile(this.bytes, this.name);

  Map<String, dynamic> toMap() {
    return {'bytes': bytes, 'name': name};
  }

  static SerializableFile fromMap(Map<String, dynamic> map) {
    return SerializableFile(map['bytes'], map['name']);
  }
}

Future<FFUploadedFile> pdfMultiImgWithIsolate(PdfMultiImgParams params) async {
  // Create a ReceivePort for isolate communication
  final receivePort = ReceivePort();

  // Spawn an isolate
  await Isolate.spawn(pdfMultiImg, receivePort.sendPort);

  // Send data to the isolate
  final sendPort = await receivePort.first as SendPort;
  final response = ReceivePort();
  sendPort.send([params.toMap(), response.sendPort]);

  // Wait for the result from the isolate
  final result = await response.first as FFUploadedFile;

  return result;
}


Future<void> pdfMultiImg(SendPort sendPort// Nullable parameter for handling landscape images
) async {

  final port = ReceivePort();
  sendPort.send(port.sendPort);

  await for (final message in port) {

    final params = PdfMultiImgParams.fromMap(message[0]);
    final replyTo = message[1] as SendPort;

    final pdf = pw.Document();

    // If first page is selected and notes are not null, add a notes page first
    if (params.isFirstPageSelected && params.notes != null && params.notes!.isNotEmpty) {
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Notes",
                  style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(
                params.notes!,
                style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
              ),
            ],
          );
        },
      ));
    }

    // Iterate through the list of uploaded files and add each as an image
    for (var fileup in params.fileupList) {

      final serializableFile = SerializableFile.fromMap(fileup);

      Uint8List? fileupBytes = serializableFile.bytes;

      if (fileupBytes != null) {
        // Decode the image
        var decodedImage = img.decodeImage(fileupBytes);

        if (decodedImage != null) {
          // Check the orientation of the image
          bool isLandscape = decodedImage.width > decodedImage.height;
          img.Image processedImage = decodedImage;

          if (isLandscape && params.selectedIndex == 1) {
            // Handle landscape images based on the 'fit' parameter
            // if (fit == 'rotate' || selectedIndex == 1) {
            // Rotate the image 90 degrees
            processedImage = img.copyRotate(
              decodedImage,
              angle: 90,
              interpolation: img.Interpolation.nearest,
            );
            // }
          }

          const int pdfPageWidth = 595; // A4 width in points at 72 dpi
          const int pdfPageHeight = 842; // A4 height in points at 72 dpi
          // Resize the image to reduce memory usage (optimized)
          // processedImage = img.copyResize(processedImage,
          //     width: pdfPageWidth, height: pdfPageHeight); // Resize to 1024px width

          // print('-----🔴🔴🔴 Decoded Width ${decodedImage.width}  height: ${decodedImage.height}');
          // double scaleFactor = 0.95; // Reduce size by 50%
          // int targetWidth = (decodedImage.width * scaleFactor).round();
          // int targetHeight = (decodedImage.height * scaleFactor).round();
          //
          // print('-----🔴🔴🔴 Targeted Width ${targetWidth}  height: ${targetHeight}');
          //
          // processedImage = img.copyResize(processedImage, width: targetWidth, height: targetHeight);

          // Convert to JPEG to avoid potential issues with PNG metadata and lower the quality (optimized)
          fileupBytes = img.encodeJpg(processedImage,
              quality:90); // Reduce quality to 100%

          // Create a MemoryImage from the resized image bytes
          var image = pw.MemoryImage(fileupBytes);

          if(params.selectedIndex == 0) {

            // Add the image as a page in the PDF
            pdf.addPage(pw.Page(
              pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
              margin: pw.EdgeInsets.all(16),
              build: (pw.Context context) {
                if (isLandscape) {
                  // Contain the image and align it to the top of the page
                  return pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Image(image, fit: pw.BoxFit.fitWidth),
                  );
                } else {
                  // Use cover fit for both rotated or portrait images with margins
                  return pw.Container(
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        image: image,
                        fit: pw.BoxFit.fitWidth,
                        alignment: pw.Alignment.center,
                      ),
                    ),
                    // Additional content (add other widgets here as needed)
                    // pw.Spacer(),
                    // ],
                  );
                }},
            ));
          } else if (params.selectedIndex == 1) {
            // Add the image as a page in the PDF
            pdf.addPage(pw.Page(
              pageFormat:  PdfPageFormat.a4,
              margin: pw.EdgeInsets.all(16),
              build: (pw.Context context) {
                if (isLandscape) {
                  // Contain the image and align it to the top of the page
                  return pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Image(image, fit: pw.BoxFit.fitWidth),
                  );
                } else {
                  // Use cover fit for both rotated or portrait images with margins
                  return pw.Container(
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        image: image,
                        fit: pw.BoxFit.fitWidth,
                        alignment: pw.Alignment.topCenter,
                      ),
                    ),
                    // Additional content (add other widgets here as needed)
                    // pw.Spacer(),
                    // ],
                  );
                }},
            ));
          } else {
            // Add the image as a page in the PDF
            pdf.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: pw.EdgeInsets.all(16),
              build: (pw.Context context) {
                if (isLandscape) {
                  // Contain the image and align it to the top of the page
                  return pw.Container(
                    alignment: pw.Alignment.topCenter, // Ensure top-center alignment
                    child: pw.Image(
                      image,
                      fit: pw.BoxFit.scaleDown, // Scale down to fit the image properly
                    ),
                  );
                } else {
                  // Use cover fit for both rotated or portrait images with margins
                  return pw.Container(
                    alignment: pw.Alignment.topCenter, // Ensure top-center alignment
                    child: pw.Image(
                      image,
                      fit: pw.BoxFit.fitWidth, // Cover the height properly in portrait mode
                    ),
                  );
                }
              },
            ));
          }
          decodedImage = null;
          // image = null;
          await Future.delayed(Duration(milliseconds: 50));


          // Add a small delay to allow garbage collection and avoid memory overload (optimized)
        }
      }
    }

    // If first page is not selected and notes are not null, add a notes page at the end
    if (!params.isFirstPageSelected && params.notes != null && params.notes!.isNotEmpty) {
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Notes",
                  style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(
                params.notes ?? '',
                style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
              ),
            ],
          );
        },
      ));
    }

    final Uint8List pdfBytes = await pdf.save();

    final uploadedFile = FFUploadedFile(
      bytes: pdfBytes,
      name: '${params.filename}.pdf',
    );

    replyTo.send(FFUploadedFile(
      bytes: pdfBytes,
      name: '${params.filename}.pdf',
    ));
  }

}

//todo using isolate

// Define a parameter class for isolate communication
class PdfMultiImgParams {
  final List<Map<String, dynamic>> fileupList; // Use serialized form
  final String filename;
  final String? notes;
  final bool isFirstPageSelected;
  final String? fit;
  final int? selectedIndex;


  PdfMultiImgParams({
    required this.fileupList,
    required this.filename,
    this.notes,
    required this.isFirstPageSelected,
    this.fit,
    this.selectedIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'fileupList': fileupList,
      'filename': filename,
      'notes': notes,
      'isFirstPageSelected': isFirstPageSelected,
      'fit': fit,
      'selectedIndex': selectedIndex,
    };
  }

  static PdfMultiImgParams fromMap(Map<String, dynamic> map) {
    return PdfMultiImgParams(
      fileupList: List<Map<String, dynamic>>.from(map['fileupList']),
      filename: map['filename'],
      notes: map['notes'],
      isFirstPageSelected: map['isFirstPageSelected'],
      fit: map['fit'],
      selectedIndex: map['selectedIndex'],
    );
  }
}


