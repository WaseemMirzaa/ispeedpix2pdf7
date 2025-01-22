import '/flutter_flow/flutter_flow_util.dart';
import 'nav_bar_with_middle_button_widget.dart'
    show NavBarWithMiddleButtonWidget;
import 'package:flutter/material.dart';

class NavBarWithMiddleButtonModel
    extends FlutterFlowModel<NavBarWithMiddleButtonWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
