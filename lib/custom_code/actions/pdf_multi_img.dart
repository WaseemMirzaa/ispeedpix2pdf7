import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;
import '/flutter_flow/flutter_flow_util.dart';

// //TODO VERSION 1 STABLE
Future<FFUploadedFile> pdfMultiImg(
    List<FFUploadedFile> fileupList,
    String filename,
    String? notes,
    bool isFirstPageSelected,
    String? fit,
    int? selectedIndex// Nullable parameter for handling landscape images
    ) async {

  final pdf = pw.Document();

  // If first page is selected and notes are not null, add a notes page first
  if (isFirstPageSelected && notes != null && notes.isNotEmpty) {

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
              notes,
              style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
            ),
          ],

        );
      },
    ));
  }

  // Iterate through the list of uploaded files and add each as an image
  for (var fileup in fileupList) {

    Uint8List? fileupBytes = fileup.bytes;

    if (fileupBytes != null) {
      // Decode the image
      var decodedImage = img.decodeImage(fileupBytes);

      if (decodedImage != null) {
        // Check the orientation of the image
        bool isLandscape = decodedImage.width > decodedImage.height;
        img.Image processedImage = decodedImage;

        if (isLandscape) {

          processedImage = img.copyRotate(
            decodedImage,
            angle: 90,
            interpolation: img.Interpolation.nearest,
          );

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

        if(selectedIndex == 0) {

          // Add the image as a page in the PDF
          pdf.addPage(pw.Page(
            pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(16),
            build: (pw.Context context) {
              if (isLandscape && fit == 'contain') {
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
                      fit: pw.BoxFit.contain,
                      alignment: pw.Alignment.center,
                    ),
                  ),
                  // Additional content (add other widgets here as needed)
                  // pw.Spacer(),
                  // ],
                );
              }},
          ));
        } else if (selectedIndex == 1) {
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
                      fit: pw.BoxFit.contain,
                      alignment: pw.Alignment.center,
                    ),
                  ),
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
                    fit: pw.BoxFit.contain, // Cover the height properly in portrait mode
                  ),
                );
              }
            },
          ));
        }

        // Add a small delay to allow garbage collection and avoid memory overload (optimized)
      }
      decodedImage = null;
      // image = null;
      await Future.delayed(Duration(milliseconds: 50));

    }

  }

  // If first page is not selected and notes are not null, add a notes page at the end
  if (!isFirstPageSelected && notes != null && notes.isNotEmpty) {

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
              notes,
              style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
            ),
          ],
        );
      },
    ));

  }

  final Uint8List pdfBytes = await pdf.save();

  await Future.delayed(const Duration(milliseconds: 50));

  final uploadedFile = FFUploadedFile(
    bytes: pdfBytes,
    name: '$filename.pdf',
  );

  return uploadedFile;

}

//todo using isolate

// Define a parameter class for isolate communication
class PdfMultiImgParams {
  final List<FFUploadedFile> fileupList;
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
}

// Wrap the existing function for isolate usage
Future<FFUploadedFile> pdfMultiImgIsolate(PdfMultiImgParams params) async {
  return await compute(_pdfMultiImgWorker, params);
}

// Original function logic inside the isolate worker
Future<FFUploadedFile> _pdfMultiImgWorker(PdfMultiImgParams params) async {
  return await pdfMultiImg(
    params.fileupList,
    params.filename,
    params.notes,
    params.isFirstPageSelected,
    params.fit,
    params.selectedIndex,
  );
}
