import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';

class PdfViewerScreen extends StatefulWidget {
  final Uint8List? pdfBytes; // PDF file as bytes
  final String? pdfUrl; // URL or local path of the PDF file
  final String title;

  const PdfViewerScreen(
      {super.key, this.pdfBytes, this.pdfUrl, this.title = "PDF Viewer"})
      : assert(pdfBytes != null || pdfUrl != null,
            'Either pdfBytes or pdfUrl must be provided');

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF173F5A),
        title: Text(widget.title),
      ),
      body: widget.pdfBytes != null
          ? SfPdfViewer.memory(
              widget.pdfBytes!,
              key: _pdfViewerKey,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                // Handle document loaded event
                debugPrint("PDF Loaded successfully!");
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                // Handle document load failure
                debugPrint("Failed to load PDF: \${details.description}");
              },
            )
          : SfPdfViewer.network(
              widget.pdfUrl!,
              key: _pdfViewerKey,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                // Handle document loaded event
                debugPrint("PDF Loaded successfully!");
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                // Handle document load failure
                debugPrint("Failed to load PDF: \${details.description}");
              },
            ),
    );
  }
}
