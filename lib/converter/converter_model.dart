import '/flutter_flow/flutter_flow_util.dart';
import 'converter_widget.dart' show ConverterWidget;
import 'package:flutter/material.dart';

class ConverterModel extends FlutterFlowModel<ConverterWidget> {
  ///  Local state fields for this page.

  String? fname = 'No Files Selected';

  FFUploadedFile? pdfFile;

  bool? landscapeExists = false;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  List<FFUploadedFile> uploadedLocalFiles = [];

  // Stores action output result for [Custom Action - filename] action in Container widget.
  String? name;

  // Stores action output result for [Custom Action - checkIfLandscape] action in Container widget.
  bool? checkLandscapeGallery;

  // Stores action output result for [Custom Action - pdfMultiImg] action in Container widget.
  FFUploadedFile? pdf;

  // Stores action output result for [Custom Action - pdfMultiImg] action in Container widget.
  FFUploadedFile? pdf2;

  // State field(s) for filename widget.
  FocusNode? filenameFocusNode;
  TextEditingController? filenameTextController;

  String? Function(BuildContext, String?)? filenameTextControllerValidator;

  // Stores action output result for [Custom Action - generateFormattedDateTime] action in Setting widget.
  String? filenameDefaultDown;

  // Stores action output result for [Custom Action - downloadFFUploadedFile] action in Setting widget.
  List<dynamic>? download;

  // Stores action output result for [Custom Action - generateFormattedDateTime] action in Setting widget.
  String? filenameDefault;

  void clearAllValues() {
    fname = null;
    pdfFile = null;
    landscapeExists = null;

    name = null;
    checkLandscapeGallery = null;
    pdf = null;
    pdf2 = null;

    filenameTextController?.clear(); // Clear text if controller exists
    filenameTextController = null;
    filenameTextControllerValidator = null;
    filenameFocusNode = null;

    filenameDefaultDown = null;
    download = null;
    filenameDefault = null;

    uploadedLocalFiles = []; // Reset list to empty
    isDataUploading = false; // Reset boolean to default state
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    filenameFocusNode?.dispose();
    filenameTextController?.dispose();
  }
}
