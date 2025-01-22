// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<FFUploadedFile> pdfSingleImg(FFUploadedFile fileup, String filename,
    String? notes, bool isFirstPageSelected // new boolean parameter
    ) async {
  Uint8List? fileupBytes = fileup.bytes;
  if (fileupBytes != null) {
    // Decode the image
    final decodedImage = img.decodeImage(fileupBytes);

    // Resize to a manageable size
    final resizedImage = img.copyResize(decodedImage!, width: 300);

    // Convert to JPEG to avoid potential issues with PNG metadata
    fileupBytes = img.encodeJpg(resizedImage, quality: 100);
  }

  pw.MemoryImage? image;
  if (fileupBytes != null) {
    image = pw.MemoryImage(fileupBytes);
  }

  final pdf = pw.Document();

  // If first page is selected and notes are not null, add a notes page first
  if (isFirstPageSelected == true && notes != null && notes.isNotEmpty) {
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

  // Add the main page with the image
  pdf.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: pw.EdgeInsets.all(32),
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Divider(thickness: 3),
          pw.SizedBox(height: 10),
          if (image != null) pw.Center(child: pw.Image(image)),
        ],
      );
    },
  ));

  // If first page is not selected and notes are not null, add a notes page at the end
  if (isFirstPageSelected == false && notes != null && notes.isNotEmpty) {
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
