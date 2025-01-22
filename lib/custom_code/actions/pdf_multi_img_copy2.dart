// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:image/image.dart' as img;


Future<FFUploadedFile> pdfMultiImgCopy2(List<FFUploadedFile> fileupList,
    String filename, String? notes, bool isFirstPageSelected) async {
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
      final decodedImage = img.decodeImage(fileupBytes);

      // Resize to a manageable size
      img.Image resizedImage = decodedImage!;
      /* if (decodedImage != null) {
        if (decodedImage.width > decodedImage.height) {
          // Landscape orientation: Resize based on width 
      resizedImage = img.copyResize(decodedImage!, height: 800); //3508
        } else {
          // Portrait orientation: Resize based on height
          resizedImage = img.copyResize(decodedImage!, width: 500); //2480
        }
      }*/

      // Convert to JPEG to avoid potential issues with PNG metadata
      fileupBytes = img.encodeJpg(resizedImage, quality: 100);

      // Create a MemoryImage from the resized image bytes
      final image = pw.MemoryImage(fileupBytes);

      // Add the image as a page in the PDF
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(16), // Remove margin for full-page image
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Image(
              image,
              fit: pw.BoxFit.cover,
            ),
          );
        },
      ));
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
  final uploadedFile = FFUploadedFile(
    bytes: pdfBytes,
    name: '$filename.pdf',
  );

  return uploadedFile;
}
