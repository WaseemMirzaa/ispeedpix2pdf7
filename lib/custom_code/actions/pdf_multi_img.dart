// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
//TODO VERSION 1 STABLE
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

        if (isLandscape && selectedIndex == 1) {
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

        if(selectedIndex == 0) {

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

// Future<FFUploadedFile> pdfMultiImg(
//     List<FFUploadedFile> fileupList,
//     String filename,
//     String? notes,
//     bool isFirstPageSelected,
//     String? fit,
//     int? selectedIndex // Nullable parameter for handling landscape images
//     ) async {
//   final pdf = pw.Document(compress: true); // Enable PDF compression
//
//   // Add notes page at the beginning if required
//   if (isFirstPageSelected && notes != null && notes.isNotEmpty) {
//     pdf.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       margin: pw.EdgeInsets.all(32),
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text("Notes",
//                 style: pw.TextStyle(
//                     fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 10),
//             pw.Text(
//               notes,
//               style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
//             ),
//           ],
//         );
//       },
//     ));
//   }
//
//   // Process images in batches to optimize memory usage
//   final int batchSize = 10; // Number of files to process at a time
//   for (int i = 0; i < fileupList.length; i += batchSize) {
//     final batch = fileupList.sublist(
//       i,
//       (i + batchSize > fileupList.length) ? fileupList.length : i + batchSize,
//     );

//     for (var fileup in batch) {
//       Uint8List? fileupBytes = fileup.bytes;
//
//       if (fileupBytes != null) {
//         // Decode the image
//         final decodedImage = img.decodeImage(fileupBytes);
//
//         if (decodedImage != null) {
//           // Determine orientation and process accordingly
//           bool isLandscape = decodedImage.width > decodedImage.height;
//           img.Image? processedImage = decodedImage;
//
//           if (isLandscape && fit != null) {
//             if (fit == 'rotate' || selectedIndex == 1) {
//               // Rotate the image 90 degrees
//               processedImage = img.copyRotate(decodedImage, angle: 90);
//             }
//           }
//
//           // Dynamically resize the image
//           int targetWidth = decodedImage.width > 1024 ? 1024 : decodedImage.width;
//           processedImage = img.copyResize(processedImage, width: targetWidth);
//
//           // Compress image to reduce size
//           fileupBytes = img.encodeJpg(processedImage, quality: 70);
//
//           // Create a MemoryImage from the resized bytes
//           final image = pw.MemoryImage(fileupBytes);
//
//           // Add the image as a page in the PDF
//           pdf.addPage(pw.Page(
//             pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
//             margin: pw.EdgeInsets.all(16),
//             build: (pw.Context context) {
//               return pw.Center(
//                 child: pw.Image(image, fit: pw.BoxFit.contain),
//               );
//             },
//           ));
//
//                   if(selectedIndex == 0) {
//
//           // Add the image as a page in the PDF
//           pdf.addPage(pw.Page(
//             pageFormat: isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
//             margin: pw.EdgeInsets.all(16),
//             build: (pw.Context context) {
//               if (isLandscape && fit == 'contain') {
//                 // Contain the image and align it to the top of the page
//                 return pw.Align(
//                   alignment: pw.Alignment.center,
//                   child: pw.Image(image, fit: pw.BoxFit.fitWidth),
//                 );
//               } else {
//                 // Use cover fit for both rotated or portrait images with margins
//                 return pw.Container(
//                   decoration: pw.BoxDecoration(
//                     image: pw.DecorationImage(
//                       image: image,
//                       fit: pw.BoxFit.contain,
//                       alignment: pw.Alignment.center,
//                     ),
//                   ),
//                   // Additional content (add other widgets here as needed)
//                   // pw.Spacer(),
//                   // ],
//                 );
//               }},
//           ));
//         } else if (selectedIndex == 1) {
//           // Add the image as a page in the PDF
//           pdf.addPage(pw.Page(
//             pageFormat:  PdfPageFormat.a4,
//             margin: pw.EdgeInsets.all(16),
//             build: (pw.Context context) {
//               if (isLandscape && fit == 'contain') {
//                 // Contain the image and align it to the top of the page
//                 return pw.Align(
//                   alignment: pw.Alignment.center,
//                   child: pw.Image(image, fit: pw.BoxFit.contain),
//                 );
//               } else {
//                 // Use cover fit for both rotated or portrait images with margins
//                 return pw.Container(
//                   decoration: pw.BoxDecoration(
//                     image: pw.DecorationImage(
//                       image: image,
//                       fit: pw.BoxFit.contain,
//                       alignment: pw.Alignment.center,
//                     ),
//                   ),
//                   // Additional content (add other widgets here as needed)
//                   // pw.Spacer(),
//                   // ],
//                 );
//               }},
//           ));
//         } else {
//           // Add the image as a page in the PDF
//           pdf.addPage(pw.Page(
//             pageFormat: PdfPageFormat.a4,
//             margin: pw.EdgeInsets.all(16),
//             build: (pw.Context context) {
//               if (isLandscape) {
//                 // Contain the image and align it to the top of the page
//                 return pw.Container(
//                   alignment: pw.Alignment.topCenter, // Ensure top-center alignment
//                   child: pw.Image(
//                     image,
//                     fit: pw.BoxFit.scaleDown, // Scale down to fit the image properly
//                   ),
//                 );
//               } else {
//                 // Use cover fit for both rotated or portrait images with margins
//                 return pw.Container(
//                   alignment: pw.Alignment.topCenter, // Ensure top-center alignment
//                   child: pw.Image(
//                     image,
//                     fit: pw.BoxFit.contain, // Cover the height properly in portrait mode
//                   ),
//                 );
//               }
//             },
//           ));
//         }
//           // Clear memory for the next iteration
//           processedImage = null;
//         }
//       }
//
//       // Add delay to allow garbage collection
//       await Future.delayed(Duration(milliseconds: 100));
//     }
//   }
//
//   // Add notes page at the end if required
//   if (!isFirstPageSelected && notes != null && notes.isNotEmpty) {
//     pdf.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       margin: pw.EdgeInsets.all(32),
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text("Notes",
//                 style: pw.TextStyle(
//                     fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 10),
//             pw.Text(
//               notes,
//               style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
//             ),
//           ],
//         );
//       },
//     ));
//   }
//
//   // Save the PDF
//   final Uint8List pdfBytes = await pdf.save();
//
//   // Return the generated PDF file
//   final uploadedFile = FFUploadedFile(
//     bytes: pdfBytes,
//     name: '$filename.pdf',
//   );
//
//   return uploadedFile;
// }
