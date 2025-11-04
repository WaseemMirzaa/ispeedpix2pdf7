import 'package:flutter/material.dart';
// import 'package:internet_file/internet_file.dart'; // commented: incompatible with http ^1.x
import 'package:ispeedpix2pdf7/helper/PdfDimensionsHelper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FlutterFlowPdfViewer extends StatefulWidget {
  const FlutterFlowPdfViewer({
    super.key,
    this.networkPath,
    this.assetPath,
    this.fileBytes,
    this.width,
    this.height,
    this.horizontalScroll = false,
  }) : assert(
            (networkPath != null) ^ (assetPath != null) ^ (fileBytes != null));

  final String? networkPath;
  final String? assetPath;
  final Uint8List? fileBytes;
  final double? width;
  final double? height;
  final bool horizontalScroll;

  @override
  State<FlutterFlowPdfViewer> createState() => _FlutterFlowPdfViewerState();
}

class _FlutterFlowPdfViewerState extends State<FlutterFlowPdfViewer> {
  bool _isLoading = true;
  String get networkPath => widget.networkPath ?? '';
  String get assetPath => widget.assetPath ?? '';
  Uint8List get fileBytes => widget.fileBytes ?? Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void didUpdateWidget(FlutterFlowPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final height = (widget.width != null)
        ? PdfDimensionsHelper.calculateA4Height(widget.width!)
        : widget.height;

    Widget viewer;
    if (assetPath.isNotEmpty) {
      viewer = SfPdfViewer.asset(
        assetPath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        pageSpacing: 4,
        pageLayoutMode: widget.horizontalScroll
            ? PdfPageLayoutMode.single
            : PdfPageLayoutMode.continuous,
      );
    } else if (networkPath.isNotEmpty) {
      viewer = SfPdfViewer.network(
        networkPath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        pageSpacing: 4,
        pageLayoutMode: widget.horizontalScroll
            ? PdfPageLayoutMode.single
            : PdfPageLayoutMode.continuous,
      );
    } else {
      viewer = SfPdfViewer.memory(
        fileBytes,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        pageSpacing: 4,
        pageLayoutMode: widget.horizontalScroll
            ? PdfPageLayoutMode.single
            : PdfPageLayoutMode.continuous,
      );
    }

    return SizedBox(
      width: widget.width,
      height: height,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(color: const Color(0xFFD3D3D3), child: viewer),
    );
  }
}
