//
// import 'package:ispeedpix2pdf7/screens/preview_pdf_screen.dart';
//
// import '../custom_code/actions/pdf_multi_img.dart';
// import '/flutter_flow/flutter_flow_animations.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/flutter_flow/upload_data.dart';
// import 'dart:ui';
// import '/custom_code/actions/index.dart' as actions;
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'converter_model.dart';
// export 'converter_model.dart';
//
// class ConverterWidget extends StatefulWidget {
//
//   const ConverterWidget({super.key});
//
//   @override
//   State<ConverterWidget> createState() => _ConverterWidgetState();
// }
//
// class _ConverterWidgetState extends State<ConverterWidget> with TickerProviderStateMixin {
//
//   late ConverterModel _model;
//
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   final animationsMap = <String, AnimationInfo>{};
//
//   List<SelectedFile>? selectedMedia;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _model = createModel(context, () => ConverterModel());
//
//     _model.filenameTextController ??= TextEditingController();
//     _model.filenameFocusNode ??= FocusNode();
//
//     animationsMap.addAll({
//       'textOnPageLoadAnimation': AnimationInfo(
//         trigger: AnimationTrigger.onPageLoad,
//         effectsBuilder: () => [
//           ScaleEffect(
//             curve: Curves.easeInOut,
//             delay: 0.0.ms,
//             duration: 600.0.ms,
//             begin: const Offset(3.0, 3.0),
//             end: const Offset(1.0, 1.0),
//           ),
//         ],
//       ),
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
//
//   }
//
//   // PLEASE: DROP DOWN NAMEs AND ORDER CHANGE
//   // PDF-Non.Oriented > REPLACE WITH = DEFAULT - Mixed Orientation
//   // PDF-Fixed.Portrait > REPLACE WITH = Pages Fixed - Portrait
//   // PDF-DEFAULT.Portrait Consistency > REPLACE WITH = Pages Portrait - Landscape Photos = Top Aligned for easy viewing
//
//   String _selectedOrientation = 'DEFAULT - Mixed Orientation';  // Default selection
//
//   // List of options for the dropdown
//   final List<String> _orientationOptions = ['DEFAULT - Mixed Orientation', 'Pages Fixed - Portrait', 'Landscape Photos - Top Aligned for easy viewing'];
//
//   @override
//   void dispose() {
//     _model.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         body: SafeArea(
//           top: true,
//           child: Align(
//             alignment: const AlignmentDirectional(0.0, 0.0),
//             child: Padding(
//               padding: const EdgeInsets.all(14.0),
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: const BoxDecoration(),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         width: 120.0,
//                         height: 120.0,
//                         clipBehavior: Clip.antiAlias,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Image.asset(
//                           'assets/images/70769789-ECA9-4E75-AE97-86FF559889DF.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                         const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
//                         child: Text(
//                           'iSpeedPix2PDF',
//                           textAlign: TextAlign.center,
//                           style: FlutterFlowTheme.of(context)
//                               .displayMedium
//                               .override(
//                             fontFamily: 'Poppins',
//                             color: FlutterFlowTheme.of(context).primaryText,
//                             fontSize: 24.0,
//                             letterSpacing: 0.0,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ).animateOnPageLoad(
//                             animationsMap['textOnPageLoadAnimation']!),
//                       ),
//                       Padding(
//                         padding:
//                         const EdgeInsetsDirectional.fromSTEB(4, 0, 4.0, 0.0),
//                         child: Container(
//                             width:
//                             MediaQuery.sizeOf(context).width * 1.0,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                               color: FlutterFlowTheme.of(context)
//                                   .secondaryBackground,
//                               borderRadius: const BorderRadius.only(
//                                 bottomLeft: Radius.circular(0.0),
//                                 bottomRight: Radius.circular(0.0),
//                                 topLeft: Radius.circular(0.0),
//                                 topRight: Radius.circular(0.0),
//                               ),
//                               shape: BoxShape.rectangle,
//                               border: Border.all(
//                                 color: FlutterFlowTheme.of(context)
//                                     .secondaryText,
//                                 width: 2.0,
//                               ),
//                             ),
//                           child: Padding(
//                             padding: const EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
//                             child: DropdownButton<String>(
//                               underline: Container(),
//                               value: _selectedOrientation,
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _selectedOrientation = newValue!;
//                                   try {
//                                     createPDF();
//                                   } catch (e) {
//                                     print('🔴🔴🔴Error While Creating PDF: $e');
//                                   }
//                                 });
//                               },
//                               items: _orientationOptions.map<DropdownMenuItem<String>>((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(
//                                     value,
//                                     style: FlutterFlowTheme.of(context).bodyMedium.override(
//                                       fontFamily: 'Inter',
//                                       color: Colors.black,
//                                       fontSize: 12.0,
//                                       letterSpacing: 0.0,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               isExpanded: true,  // Makes the dropdown button fill the available width
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                             const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Flexible(
//                               child: Padding(
//                                 padding: const EdgeInsetsDirectional.fromSTEB(
//                                     4.0, 0.0, 4.0, 0.0),
//                                 child: InkWell(
//                                   splashColor: Colors.transparent,
//                                   focusColor: Colors.transparent,
//                                   hoverColor: Colors.transparent,
//                                   highlightColor: Colors.transparent,
//                                   onTap: () async {
//
//                                     // LoadingDialog.show(context);
//
//                                     try {
//
//                                       var media = await selectMedia(
//                                         maxWidth: 880.00,
//                                         maxHeight: 660.00,
//                                         imageQuality: 100,
//                                         includeDimensions: true,
//                                         mediaSource: MediaSource.photoGallery,
//                                         multiImage: true,
//
//                                       );
//
//                                       if(media != null) {
//
//                                         selectedMedia = media;
//
//                                       }
//
//                                       createPDF();
//
//                                     } catch (e) {
//
//                                       print('🔴🔴🔴Error While Creating PDF: $e');
//
//                                     }
//
//                                   },
//                                   child: Container(
//                                     width:
//                                         MediaQuery.sizeOf(context).width * 1.0,
//                                     height: 60.0,
//                                     decoration: BoxDecoration(
//                                       color: FlutterFlowTheme.of(context)
//                                           .secondaryBackground,
//                                       borderRadius: const BorderRadius.only(
//                                         bottomLeft: Radius.circular(0.0),
//                                         bottomRight: Radius.circular(0.0),
//                                         topLeft: Radius.circular(0.0),
//                                         topRight: Radius.circular(0.0),
//                                       ),
//                                       shape: BoxShape.rectangle,
//                                       border: Border.all(
//                                         color: FlutterFlowTheme.of(context)
//                                             .secondaryText,
//                                         width: 2.0,
//                                       ),
//                                     ),
//                                     child: Align(
//                                       alignment: const AlignmentDirectional(0.0, 0.0),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsetsDirectional.fromSTEB(
//                                                     4.0, 0.0, 0.0, 0.0),
//                                             child: Container(
//                                               width: 100.0,
//                                               height: 40.0,
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     FlutterFlowTheme.of(context)
//                                                         .secondaryText,
//                                                 borderRadius:
//                                                     BorderRadius.circular(30.0),
//                                               ),
//                                               child: Align(
//                                                 alignment: const AlignmentDirectional(
//                                                     0.0, 0.0),
//                                                 child: Text(
//                                                   'Choose Files',
//                                                   style: FlutterFlowTheme.of(
//                                                           context)
//                                                       .bodyMedium
//                                                       .override(
//                                                         fontFamily: 'Inter',
//                                                         color:
//                                                             FlutterFlowTheme.of(
//                                                                     context)
//                                                                 .secondary,
//                                                         fontSize: 14.0,
//                                                         letterSpacing: 0.0,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsetsDirectional.fromSTEB(
//                                                     8.0, 0.0, 0.0, 0.0),
//                                             child: Text(
//                                               valueOrDefault<String>(
//                                                 _model.fname,
//                                                 'no files selected',
//                                               ),
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyMedium
//                                                       .override(
//                                                         fontFamily: 'Inter',
//                                                         letterSpacing: 0.0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ],),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                             const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
//                         child: TextFormField(
//                           controller: _model.filenameTextController,
//                           focusNode: _model.filenameFocusNode,
//                           autofocus: true,
//                           obscureText: false,
//                           decoration: InputDecoration(
//                             labelText: 'Filename',
//                             labelStyle: FlutterFlowTheme.of(context)
//                                 .labelMedium
//                                 .override(
//                                   fontFamily: 'Inter',
//                                   letterSpacing: 0.0,
//                                 ),
//                             hintText: 'Enter custom file name (optional)',
//                             hintStyle: FlutterFlowTheme.of(context)
//                                 .labelMedium
//                                 .override(
//                                   fontFamily: 'Inter',
//                                   letterSpacing: 0.0,
//                                 ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).alternate,
//                                 width: 2.0,
//                               ),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).primary,
//                                 width: 2.0,
//                               ),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).error,
//                                 width: 2.0,
//                               ),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: FlutterFlowTheme.of(context).error,
//                                 width: 2.0,
//                               ),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             filled: true,
//                           ),
//                           style:
//                               FlutterFlowTheme.of(context).bodyMedium.override(
//                                     fontFamily: 'Inter',
//                                     letterSpacing: 0.0,
//                                   ),
//                           validator: _model.filenameTextControllerValidator
//                               .asValidator(context),
//                         ),
//                       ),
//                       Column(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           if (_model.pdfFile != null &&
//                               (_model.pdfFile?.bytes?.isNotEmpty ?? false))
//                             Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(
//                                   8.0, 12.0, 8.0, 0.0),
//                               child: FFButtonWidget(
//                                 onPressed: () async {
//                                   _model.filenameDefaultDown =
//                                       await actions.generateFormattedDateTime();
//                                   _model.download =
//                                       await actions.downloadFFUploadedFile(
//                                     _model.pdfFile!,
//                                     _model.filenameTextController
//                                                     .text !=
//                                                 ''
//                                         ? _model.filenameTextController.text
//                                         : _model.filenameDefaultDown!,
//                                   );
//
//                                   safeSetState(() {});
//                                 },
//                                 text: 'Download PDF',
//                                 icon: const Icon(
//                                   Icons.sim_card_download_sharp,
//                                   size: 20.0,
//                                 ),
//                                 options: FFButtonOptions(
//                                   width: double.infinity,
//                                   height: 50.0,
//                                   padding: const EdgeInsetsDirectional.fromSTEB(
//                                       24.0, 0.0, 24.0, 0.0),
//                                   iconPadding: const EdgeInsetsDirectional.fromSTEB(
//                                       0.0, 0.0, 0.0, 0.0),
//                                   color: const Color(0xFF4A90E2),
//                                   textStyle: FlutterFlowTheme.of(context)
//                                       .titleLarge
//                                       .override(
//                                         fontFamily: 'Readex Pro',
//                                         color:
//                                             FlutterFlowTheme.of(context).info,
//                                         fontSize: 18.0,
//                                         letterSpacing: 0.0,
//                                       ),
//                                   borderSide: BorderSide(
//                                     color: FlutterFlowTheme.of(context).primary,
//                                     width: 2.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                             ),
//                           if (_model.pdfFile != null &&
//                               (_model.pdfFile?.bytes?.isNotEmpty ?? false))
//                             Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(
//                                   8.0, 0.0, 8.0, 0.0),
//                               child: FFButtonWidget(
//                                 onPressed: () async {
//
//                                   if (_model.filenameTextController.text != '') {
//
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>  PdfViewerScreen(pdfBytes:  _model.pdfFile!.bytes,
//                                           title:  _model.filenameDefault!,
//                                         ),
//                                       ),
//                                     );
//
//                                   } else {
//
//                                     _model.filenameDefault = await actions.generateFormattedDateTime();
//
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>  PdfViewerScreen(pdfBytes:  _model.pdfFile!.bytes, title: _model.filenameDefault!
//                                         ),
//                                       ),
//                                     );
//                                   }
//
//                                   safeSetState(() {});
//                                 },
//                                 text: 'View PDF',
//                                 icon: const Icon(
//                                   Icons.visibility,
//                                   size: 20.0,
//                                 ),
//                                 options: FFButtonOptions(
//                                   width: double.infinity,
//                                   height: 50.0,
//                                   padding: const EdgeInsetsDirectional.fromSTEB(
//                                       24.0, 0.0, 24.0, 0.0),
//                                   iconPadding: const EdgeInsetsDirectional.fromSTEB(
//                                       0.0, 0.0, 0.0, 0.0),
//                                   color: const Color(0xFF4A90E2),
//                                   textStyle: FlutterFlowTheme.of(context)
//                                       .titleLarge
//                                       .override(
//                                         fontFamily: 'Readex Pro',
//                                         color:
//                                             FlutterFlowTheme.of(context).info,
//                                         fontSize: 18.0,
//                                         letterSpacing: 0.0,
//                                       ),
//                                   elevation: 0.0,
//                                   borderSide: BorderSide(
//                                     color: FlutterFlowTheme.of(context).primary,
//                                     width: 2.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                             ), Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(
//                                   8.0,16.0, 8.0, 0.0),
//                               child: FFButtonWidget(
//                                 onPressed: () async {
//                                   context.pushNamed('Mainmenu');
//                                 },
//                                 text: 'Main Menu',
//                                 // icon: const Icon(
//                                 //   Icons.men,
//                                 //   size: 20.0,
//                                 // ),
//                                 options: FFButtonOptions(
//                                   width: double.infinity,
//                                   height: 50.0,
//                                   padding: const EdgeInsetsDirectional.fromSTEB(
//                                       24.0, 0.0, 24.0, 0.0),
//                                   iconPadding: const EdgeInsetsDirectional.fromSTEB(
//                                       0.0, 0.0, 0.0, 0.0),
//                                   color: const Color(0xFF4A90E2),
//                                   textStyle: FlutterFlowTheme.of(context)
//                                       .titleLarge
//                                       .override(
//                                         fontFamily: 'Readex Pro',
//                                         color:
//                                             FlutterFlowTheme.of(context).info,
//                                         fontSize: 18.0,
//                                         letterSpacing: 0.0,
//                                       ),
//                                   elevation: 0.0,
//                                   borderSide: BorderSide(
//                                     color: FlutterFlowTheme.of(context).primary,
//                                     width: 2.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                             ),
//
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(8,20,8,8),
//                             child: Container(
//                               width: double.infinity,
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFF094300),
//                               ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Align(
//                                     alignment: const AlignmentDirectional(0.0, 0.0),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: RichText(
//                                         textScaler:
//                                             MediaQuery.of(context).textScaler,
//                                         text: TextSpan(
//                                           children: [
//                                             TextSpan(
//                                               text: 'Data Collection:',
//                                               style: FlutterFlowTheme.of(context)
//                                                   .bodyMedium
//                                                   .override(
//                                                     fontFamily: 'Inter',
//                                                     color: Colors.white,
//                                                     fontSize: 12.0,
//                                                     letterSpacing: 0.0,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                             ),
//                                             const TextSpan(
//                                               text:
//                                                   ' We do not collect, store, or process any personal data from users. All data, including images and notes, is handled locally on your device. This means:',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10.0,
//                                               ),
//                                             ),
//                                             const TextSpan(
//                                               text:
//                                                   '\n- No images are uploaded to a server.\n- No personal data is collected, stored, or shared by our mobile app.',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                               ),
//                                             )
//                                           ],
//                                           style: FlutterFlowTheme.of(context)
//                                               .bodyMedium
//                                               .override(
//                                                 fontFamily: 'Inter',
//                                                 fontSize: 12.0,
//                                                 letterSpacing: 0.0,
//                                               ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ].divide(const SizedBox(height: 12.0)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> createPDF() async {
//
//     if(selectedMedia == null) {
//
//       // LoadingDialog.hide(context);
//
//       return;
//
//     }
//
//     try {
//
//       if (selectedMedia != null && selectedMedia!.every((m) => validateFileFormat(m.storagePath, context))) {
//
//         safeSetState(() => _model.isDataUploading = true);
//
//         var selectedUploadedFiles = <FFUploadedFile>[];
//
//         try {
//
//           selectedUploadedFiles = selectedMedia!
//               .map((m) => FFUploadedFile(
//             name: m.storagePath
//                 .split('/')
//                 .last,
//             bytes: m.bytes,
//             height: m.dimensions?.height,
//             width: m.dimensions?.width,
//             blurHash: m.blurHash,
//           )).toList();
//
//         } finally {
//
//           _model.isDataUploading = false;
//
//         }
//
//         if (selectedUploadedFiles.length == selectedMedia!.length) {
//
//           safeSetState(() {
//
//             _model.uploadedLocalFiles = selectedUploadedFiles;
//
//           });
//
//         } else {
//
//           safeSetState(() {});
//
//           // LoadingDialog.hide(context);
//
//           return;
//
//         }
//       }
//
//       if (_model.uploadedLocalFiles.length > 1) {
//
//         _model.fname = '${_model.uploadedLocalFiles.length.toString()} Files Selected';
//
//         safeSetState(() {});
//
//       } else {
//
//         _model.name = await actions.filename(_model.uploadedLocalFiles.firstOrNull!,);
//
//         _model.fname = _model.name;
//
//         safeSetState(() {});
//
//       }
//
//       _model.checkLandscapeGallery = await actions.checkIfLandscape(_model.uploadedLocalFiles.toList(),);
//
//       if (_model.checkLandscapeGallery!) {
//
//         final params = PdfMultiImgParams(
//           fileupList: _model.uploadedLocalFiles.toList(),
//           filename: valueOrDefault<String>(
//             _model.filenameTextController.text,
//             'file',
//           ),
//           notes: _model.filenameTextController.text,
//           isFirstPageSelected: true, // Hardcoded 'true' as per the example
//           fit: 'contain', // Hardcoded 'contain' as per the example
//           selectedIndex: _orientationOptions.indexOf(_selectedOrientation), // Get the index of the selected orientation
//         );
//
//         // LoadingDialog.hide(context);
//
//         _model.pdf2 = await pdfMultiImgIsolate(params);
//         _model.pdfFile = _model.pdf2;
//
//         _model.landscapeExists =
//             _model.checkLandscapeGallery;
//
//         safeSetState(() {});
//
//       } else {
//
//         final params = PdfMultiImgParams(
//           fileupList: _model.uploadedLocalFiles.toList(),
//           filename: valueOrDefault<String>(
//             _model.filenameTextController.text,
//             'file',
//           ),
//           notes: _model.filenameTextController.text,
//           isFirstPageSelected: true, // Pass 'true' as specified
//           fit: 'contain', // Pass 'contain' as specified
//           selectedIndex: _orientationOptions.indexOf(_selectedOrientation), // Use the index of the selected orientation
//         );
//
//         _model.pdf2 = await pdfMultiImgIsolate(params);
//
//         // LoadingDialog.hide(context);
//
//         _model.pdfFile = _model.pdf2;
//         _model.landscapeExists =
//             _model.checkLandscapeGallery;
//
//         safeSetState(() {});
//       }
//
//       safeSetState(() {});
//
//     } catch (e) {
//
//       print('🔴🔴🔴Error While Creating PDF: $e');
//
//       // LoadingDialog.hide(context);
//
//     }
//
//
//   }
//
//   // Future<void> createPDFView() async {
//   //   print('🟡 Starting createPDFView...');
//   //
//   //   // 🟡 Allow user to select media files from the photo gallery
//   //   final selectedMedia = await selectMedia(
//   //     imageQuality: 100,
//   //     includeDimensions: true,
//   //     mediaSource: MediaSource.photoGallery,
//   //     multiImage: true,
//   //   );
//   //   print('🟡 Media selected: ${selectedMedia?.length ?? 0} items.');
//   //
//   //   // 🟡 Check if media selection is valid and all files are of supported formats
//   //   if (selectedMedia != null &&
//   //       selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
//   //     print('🟡 Valid media files selected. Proceeding to upload.');
//   //
//   //     // 🟡 Indicate that data upload is in progress
//   //     safeSetState(() => _model.isDataUploading = true);
//   //     print('🟡 Data upload started.');
//   //
//   //     // 🟡 Initialize a list to hold uploaded files
//   //     var selectedUploadedFiles = <FFUploadedFile>[];
//   //     print('🟡 Initialized list for uploaded files.');
//   //
//   //     // 🟡 Process and rotate selected media for correct orientation
//   //     var rotationCorrectedImages = await processAndRotateMedia(selectedMedia);
//   //     print('🟡 Media processed and rotated. Count: ${rotationCorrectedImages.length}');
//   //
//   //     try {
//   //       // 🟡 Map processed media to the uploaded file format
//   //       selectedUploadedFiles = rotationCorrectedImages
//   //           .map((m) => FFUploadedFile(
//   //         name: m.storagePath.split('/').last, // Extract the file name
//   //         bytes: m.bytes, // Include image bytes
//   //         height: m.dimensions?.height, // Image height
//   //         width: m.dimensions?.width, // Image width
//   //         blurHash: m.blurHash, // Optional blur hash
//   //       ))
//   //           .toList();
//   //       print('🟡 Uploaded files prepared. Count: ${selectedUploadedFiles.length}');
//   //     } finally {
//   //       // 🟡 Reset upload status regardless of the outcome
//   //       _model.isDataUploading = false;
//   //       print('🟡 Data upload status reset.');
//   //     }
//   //
//   //     // 🟡 Verify if all selected media files were processed and uploaded
//   //     if (selectedUploadedFiles.length == selectedMedia.length) {
//   //       print('🟡 All files uploaded successfully.');
//   //       safeSetState(() {
//   //         _model.uploadedLocalFiles = selectedUploadedFiles; // Store uploaded files
//   //       });
//   //     } else {
//   //       // 🟡 Handle incomplete upload scenario
//   //       print('🟡 Upload incomplete. Uploaded: ${selectedUploadedFiles.length}, Selected: ${selectedMedia.length}');
//   //       safeSetState(() {});
//   //       return;
//   //     }
//   //   } else {
//   //     print('🟡 No valid media files selected or unsupported format.');
//   //   }
//   //
//   //   // 🟡 Update file display details based on the number of uploaded files
//   //   if (_model.uploadedLocalFiles.length > 1) {
//   //     _model.fname = '${_model.uploadedLocalFiles.length.toString()} Files Selected';
//   //     print('🟡 Multiple files selected. File name: ${_model.fname}');
//   //     safeSetState(() {});
//   //   } else {
//   //     // 🟡 Retrieve and store the filename for a single uploaded file
//   //     _model.name = await actions.filename(_model.uploadedLocalFiles.firstOrNull!);
//   //     print('🟡 Single file selected. File name: ${_model.name}');
//   //     _model.fname = _model.name;
//   //     safeSetState(() {});
//   //   }
//   //
//   //   // 🟡 Check if any of the uploaded files are in landscape orientation
//   //   _model.checkLandscapeGallery = await actions.checkIfLandscape(
//   //     _model.uploadedLocalFiles.toList(),
//   //   );
//   //   print('🟡 Landscape orientation check: ${_model.checkLandscapeGallery}');
//   //
//   //   // 🟡 Generate a PDF file based on the orientation of the images
//   //   // if (_model.checkLandscapeGallery!) {
//   //   //   // 🟡 Handle landscape-oriented files
//   //   //   print('🟡 Generating PDF for landscape images...');
//   //   //   _model.pdf = await actions.pdfMultiImg(
//   //   //     _model.uploadedLocalFiles.toList(),
//   //   //     valueOrDefault<String>(
//   //   //       _model.filenameTextController.text,
//   //   //       'file',
//   //   //     ),
//   //   //     _model.filenameTextController.text,
//   //   //     true,
//   //   //     'contain',
//   //   //   );
//   //   //   print('🟡 PDF generated for landscape images.');
//   //   //   _model.pdfFile = _model.pdf;
//   //   //   _model.landscapeExists = _model.checkLandscapeGallery;
//   //   //   safeSetState(() {});
//   //   // } else {
//   //     // 🟡 Handle portrait-oriented files
//   //     print('🟡 Generating PDF for portrait images...');
//   //     _model.pdf2 = await actions.pdfMultiImg(
//   //       _model.uploadedLocalFiles.toList(),
//   //       valueOrDefault<String>(
//   //         _model.filenameTextController.text,
//   //         'file',
//   //       ),
//   //       _model.filenameTextController.text,
//   //       true,
//   //       'contain',
//   //     );
//   //     print('🟡 PDF generated for portrait images.');
//   //     _model.pdfFile = _model.pdf2;
//   //     _model.landscapeExists = _model.checkLandscapeGallery;
//   //     safeSetState(() {});
//   //   // }
//   //
//   //   // 🟡 Final update of the UI state after processing is complete
//   //   print('🟡 Finalizing UI updates...');
//   //   safeSetState(() {});
//   //   print('🟡 PDF generation and file processing completed.');
//   // }
//   //
//   // Future<void> createPDFView() async {
//   //
//   //
//   //   print('🟡 Starting createPDFView...');
//   //
//   //   // 🟡 Allow user to select media files from the photo gallery
//   //   final selectedMedia = await selectMedia(
//   //     imageQuality: 100,
//   //     includeDimensions: true,
//   //     mediaSource: MediaSource.photoGallery,
//   //     multiImage: true,
//   //   );
//   //
//   //   print('🟡 Media selected: ${selectedMedia?.length ?? 0} items.');
//   //
//   //   LoadingDialog.show(context, message: 'Uploading');
//   //
//   //   if (selectedMedia != null &&
//   //       selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
//   //     print('🟡 Valid media files selected. Processing begins...');
//   //
//   //     // 🟡 Indicate that data upload is in progress
//   //     safeSetState(() => _model.isDataUploading = true);
//   //     print('🟡 Data upload state set to true.');
//   //
//   //     var selectedUploadedFiles = <FFUploadedFile>[];
//   //
//   //     try {
//   //       // 🟡 Process and rotate selected media for correct orientation
//   //       // var rotationCorrectedImages = await processAndRotateMedia(selectedMedia);
//   //       print('🟡 Media processed and rotated successfully.');
//   //
//   //       // 🟡 Map processed media to the uploaded file format
//   //       selectedUploadedFiles = selectedMedia
//   //           .map((m) => FFUploadedFile(
//   //         name: m.storagePath.split('/').last,
//   //         bytes: m.bytes,
//   //         height: m.dimensions?.height,
//   //         width: m.dimensions?.width,
//   //         blurHash: m.blurHash,
//   //       ))
//   //           .toList();
//   //       print('🟡 Uploaded files prepared. Count: ${selectedUploadedFiles.length}');
//   //
//   //     } catch (e, stackTrace) {
//   //       print('🔴 Error during media processing or upload: $e');
//   //       print(stackTrace);
//   //     } finally {
//   //       // 🟡 Reset upload status
//   //       safeSetState(() => _model.isDataUploading = false);
//   //       print('🟡 Data upload state reset.');
//   //     }
//   //
//   //     // 🟡 Verify upload completeness
//   //     if (selectedUploadedFiles.length == selectedMedia.length) {
//   //       safeSetState(() {
//   //         _model.uploadedLocalFiles = selectedUploadedFiles;
//   //       });
//   //       print('🟡 All files uploaded successfully.');
//   //     } else {
//   //       print('🔴 Upload incomplete. Aborting process.');
//   //       safeSetState(() {});
//   //       return;
//   //     }
//   //
//   //     // 🟡 Update filename display
//   //     if (_model.uploadedLocalFiles.length > 1) {
//   //       _model.fname = '${_model.uploadedLocalFiles.length.toString()} Files Selected';
//   //       print('🟡 Multiple files selected. Display name updated: ${_model.fname}');
//   //     } else {
//   //       _model.name = await actions.filename(_model.uploadedLocalFiles.firstOrNull!);
//   //       _model.fname = _model.name;
//   //       print('🟡 Single file selected. Display name: ${_model.fname}');
//   //     }
//   //
//   //     // 🟡 Check for landscape orientation among uploaded files
//   //     _model.checkLandscapeGallery = await actions.checkIfLandscape(_model.uploadedLocalFiles.toList());
//   //     print('🟡 Landscape orientation check result: ${_model.checkLandscapeGallery}');
//   //
//   //     try {
//   //       // 🟡 Generate PDF based on orientation
//   //       if (_model.checkLandscapeGallery!) {
//   //         print('🟡 Generating PDF for landscape images...');
//   //         _model.pdf = await actions.pdfMultiImg(
//   //           _model.uploadedLocalFiles.toList(),
//   //           valueOrDefault<String>(
//   //             _model.filenameTextController.text,
//   //             'file',
//   //           ),
//   //           _model.filenameTextController.text,
//   //           true,
//   //           'contain',
//   //         );
//   //         _model.pdfFile = _model.pdf;
//   //         _model.landscapeExists = _model.checkLandscapeGallery;
//   //         print('🟡 PDF generated for landscape images.');
//   //       } else {
//   //         print('🟡 Generating PDF for portrait images...');
//   //         _model.pdf2 = await actions.pdfMultiImg(
//   //           _model.uploadedLocalFiles.toList(),
//   //           valueOrDefault<String>(
//   //             _model.filenameTextController.text,
//   //             'file',
//   //           ),
//   //           _model.filenameTextController.text,
//   //           true,
//   //           'contain',
//   //         );
//   //         _model.pdfFile = _model.pdf2;
//   //         _model.landscapeExists = _model.checkLandscapeGallery;
//   //         print('🟡 PDF generated for portrait images.');
//   //       }
//   //     } catch (e, stackTrace) {
//   //       print('🔴 Error during PDF generation: $e');
//   //       print(stackTrace);
//   //     }
//   //
//   //     // 🟡 Final UI update
//   //     safeSetState(() {});
//   //     print('🟡 PDF generation process completed.');
//   //   } else {
//   //     print('🔴 No valid media files selected or unsupported format.');
//   //   }
//   //
//   //   Navigator.of(context).pop();
//   // }
//
// // Future<void> createPDFView() async {
//   //
//   //   final selectedMedia = await selectMedia(
//   //     // maxWidth: 880.00,
//   //     // maxHeight: 660.00,
//   //     imageQuality: 100,
//   //     includeDimensions: true,
//   //     mediaSource: MediaSource.photoGallery,
//   //     multiImage: true,
//   //   );
//   //
//   //   if (selectedMedia != null &&
//   //       selectedMedia.every((m) =>
//   //           validateFileFormat(
//   //               m.storagePath, context))) {
//   //
//   //     safeSetState(
//   //             () => _model.isDataUploading = true);
//   //
//   //     var selectedUploadedFiles =
//   //     <FFUploadedFile>[];
//   //
//   //     var rotationCorrectedImages = await processAndRotateMedia(selectedMedia);
//   //     //uploading selected files
//   //
//   //     try {
//   //       selectedUploadedFiles = rotationCorrectedImages
//   //           .map((m) => FFUploadedFile(
//   //         name: m.storagePath
//   //             .split('/')
//   //             .last,
//   //         bytes: m.bytes,
//   //         height: m.dimensions?.height,
//   //         width: m.dimensions?.width,
//   //         blurHash: m.blurHash,
//   //
//   //       ))
//   //           .toList();
//   //     } finally {
//   //       _model.isDataUploading = false;
//   //     }
//   //     if (selectedUploadedFiles.length ==
//   //         selectedMedia.length) {
//   //       safeSetState(() {
//   //         _model.uploadedLocalFiles =
//   //             selectedUploadedFiles;
//   //       });
//   //     } else {
//   //       safeSetState(() {});
//   //       return;
//   //     }
//   //   }
//   //
//   //   if (_model.uploadedLocalFiles.length > 1) {
//   //     _model.fname =
//   //     '${_model.uploadedLocalFiles.length.toString()} Files Selected';
//   //     safeSetState(() {});
//   //   } else {
//   //     _model.name = await actions.filename(
//   //       _model.uploadedLocalFiles.firstOrNull!,
//   //     );
//   //     _model.fname = _model.name;
//   //     safeSetState(() {});
//   //   }
//   //
//   //   _model.checkLandscapeGallery =
//   //       await actions.checkIfLandscape(
//   //     _model.uploadedLocalFiles.toList(),
//   //   );
//   //   if (_model.checkLandscapeGallery!) {
//   //     _model.pdf = await actions.pdfMultiImg(
//   //       _model.uploadedLocalFiles.toList(),
//   //       valueOrDefault<String>(
//   //         _model.filenameTextController.text,
//   //         'file',
//   //       ),
//   //       _model.filenameTextController.text,
//   //       true,
//   //       'contain',
//   //     );
//   //     _model.pdfFile = _model.pdf;
//   //     _model.landscapeExists =
//   //         _model.checkLandscapeGallery;
//   //     safeSetState(() {});
//   //   } else {
//   //     _model.pdf2 = await actions.pdfMultiImg(
//   //       _model.uploadedLocalFiles.toList(),
//   //       valueOrDefault<String>(
//   //         _model.filenameTextController.text,
//   //         'file',
//   //       ),
//   //       _model.filenameTextController.text,
//   //       true,
//   //       'contain',
//   //     );
//   //     _model.pdfFile = _model.pdf2;
//   //     _model.landscapeExists =
//   //         _model.checkLandscapeGallery;
//   //     safeSetState(() {});
//   //   }
//   //
//   //   safeSetState(() {});
//   // }
// }
// //
// // Future<List<SelectedFile>> processAndRotateMedia(List<SelectedFile> selectedMedia) async {
// //   List<SelectedFile> rotatedMedia = [];
// //
// //   for (var media in selectedMedia) {
// //
// //
// //     File rotatedImage =
// //     await FlutterExifRotation.rotateAndSaveImage(path: media.storagePath);
// //
// //     try {
// //       print('🔴 Processing file: ${media.storagePath}');
// //
// //       Uint8List? bytes = media.bytes;
// //       if (bytes == null) {
// //         print('🔴 No bytes found for file: ${media.storagePath}');
// //         continue;
// //       }
// //
// //       // Read EXIF metadata
// //       print('🔴 Reading EXIF metadata for file: ${media.storagePath}');
// //       final tags = await readExifFromBytes(bytes);
// //       final orientation = tags['Image Orientation'];
// //       print('🔴 EXIF metadata read. Orientation: ${orientation?.values ?? "Not found"}');
// //
// //       if (orientation != null) {
// //         final orientationValue = orientation.values.firstAsInt();
// //
// //         // Decode the image
// //         print('🔴🟢 Tags image: ${tags}');
// //         print('🔴 Decoding image: ${media.storagePath}');
// //         print('🔴🔴🔴🔴---🔴 Decoding Orientation: ${orientationValue}');
// //         img.Image? image = img.decodeImage(bytes);
// //         if (image == null) {
// //           print('🔴🔴 Failed to decode image: ${media.storagePath}');
// //           rotatedMedia.add(media); // Add unmodified if decoding fails
// //           continue;
// //         }
// //         print('🔴🔴🔴🔴🔴Image decoded successfully. Dimensions: ${image.width}x${image.height}');
// //
// //         File rotatedImageFile = await FlutterExifRotation.rotateImage(path: media.storagePath);
// // //
// // //       // Step 2: Load the rotated image from the file
// //       final rotatedBytes = await rotatedImageFile.readAsBytes();
// //       img.Image? rotatedImage = img.decodeImage(rotatedBytes);
// // //
// //         // Rotate based on EXIF orientation
// //         // img.Image rotatedImage = image;
// //
// //
// //         // Re-encode the rotated image
// //         print('Re-encoding rotated image: ${media.storagePath}');
// //         print('Image re-encoded successfully: ${media.storagePath}');
// //
// //         // Replace the media bytes with the rotated version
// //         rotatedMedia.add(
// //           SelectedFile(
// //             storagePath: media.storagePath,
// //             bytes: rotatedBytes,
// //             dimensions: MediaDimensions(
// //               width: rotatedImage?.width.toDouble(),
// //               height: rotatedImage?.height.toDouble(),
// //             ),
// //             blurHash: media.blurHash,
// //           ),
// //         );
// //         print('Processed and rotated image added to list: ${media.storagePath}');
// //       } else {
// //         // If no EXIF orientation tag, add media as-is
// //         print('No EXIF orientation found. Adding unmodified file: ${media.storagePath}');
// //         rotatedMedia.add(media);
// //       }
// //     } catch (e) {
// //       print('Error processing image: ${media.storagePath}, Error: $e');
// //       rotatedMedia.add(media); // Add unmodified if an error occurs
// //     }
// //   }
// //
// //   print('All files processed. Total files: ${rotatedMedia.length}');
// //   return rotatedMedia;
// // }
// //
//
// // Future<List<SelectedFile>> processAndRotateMedia(List<SelectedFile> selectedMedia) async {
// //   List<SelectedFile> rotatedMedia = [];
// //
// //   for (var media in selectedMedia) {
// //     // Read the bytes of the media file
// //     Uint8List? bytes = media.bytes;
// //     if (bytes == null) {
// //       print('🔴 No bytes found for file: ${media.storagePath}');
// //       continue;
// //     }
// //
// //     // Read EXIF metadata to determine the orientation
// //     print('🔴 Reading EXIF metadata for file: ${media.storagePath}');
// //     final tags = await readExifFromBytes(bytes);
// //     final orientation = tags['Image Orientation'];
// //     print('🔴 EXIF metadata read. Orientation: ${orientation?.values ?? "Not found"}');
// //
// //     // Check if EXIF orientation is found and valid
// //     if (orientation != null) {
// //       final orientationValue = orientation.values.firstAsInt();
// //
// //       // Decode the image
// //       print('🔴 Decoding image: ${media.storagePath}');
// //       img.Image? image = img.decodeImage(bytes);
// //       if (image == null) {
// //         print('🔴 Failed to decode image: ${media.storagePath}');
// //         rotatedMedia.add(media); // Add unmodified if decoding fails
// //         continue;
// //       }
// //       print('🔴 Image decoded successfully. Dimensions: ${image.width}x${image.height}');
// //
// //       // Correct the image orientation based on EXIF data
// //       File rotatedImageFile = await FlutterExifRotation.rotateImage(path: media.storagePath);
// //
// //       // Step 2: Load the rotated image from the file
// //       final rotatedBytes = await rotatedImageFile.readAsBytes();
// //       img.Image? rotatedImage = img.decodeImage(rotatedBytes);
// //
// //       if (rotatedImage == null) {
// //         print('🔴 Failed to decode rotated image: ${media.storagePath}');
// //         rotatedMedia.add(media); // Add unmodified if decoding fails
// //         continue;
// //       }
// //
// //       // Step 3: Re-encode the rotated image as JPEG
// //       print('🔴 Re-encoding rotated image: ${media.storagePath}');
// //       Uint8List rotatedImageBytes = Uint8List.fromList(img.encodeJpg(rotatedImage));
// //
// //       // Step 4: Save the re-encoded image (optional)
// //       File savedImage = File(media.storagePath)..writeAsBytesSync(rotatedImageBytes);
// //       print('🔴 Saved rotated image at: ${savedImage.path}');
// //
// //       // Step 5: Add the rotated image to the list with updated bytes
// //       rotatedMedia.add(
// //         SelectedFile(
// //           storagePath: media.storagePath,
// //           bytes: rotatedImageBytes,
// //           dimensions: MediaDimensions(
// //             width: rotatedImage.width.toDouble(),
// //             height: rotatedImage.height.toDouble(),
// //           ),
// //           blurHash: media.blurHash,
// //         ),
// //       );
// //
// //       print('🔴 Processed and rotated image added to list: ${media.storagePath}');
// //     } else {
// //       print('🔴 No EXIF orientation found for file: ${media.storagePath}');
// //     }
// //   }
// //
// //   return rotatedMedia;
// // }
//
// //
// // Future<List<SelectedFile>> processAndRotateMedia(List<SelectedFile> selectedMedia) async {
// //   // List to store the processed and rotated media files
// //   List<SelectedFile> rotatedMedia = [];
// //
// //   // Loop through each media file in the input list
// //   for (var media in selectedMedia) {
// //     // Attempt to rotate the image using FlutterExifRotation
// //     File rotatedImage =
// //     await FlutterExifRotation.rotateAndSaveImage(path: media.storagePath);
// //
// //     try {
// //       print('🔴 Processing file: ${media.storagePath}');
// //
// //       // Retrieve the bytes of the media file
// //       Uint8List? bytes = media.bytes;
// //       if (bytes == null) {
// //         // Skip processing if bytes are not available
// //         print('🔴 No bytes found for file: ${media.storagePath}');
// //         continue;
// //       }
// //
// //       // Read EXIF metadata from the image bytes
// //       // print('🔴 Reading EXIF metadata for file: ${media.storagePath}');
// //       // final tags = await readExifFromBytes(bytes);
// //       // final orientation = tags['Image Orientation'];
// //       // print('🔴 EXIF metadata read. Orientation: ${orientation?.values ?? "Not found"}');
// //        // Extract the orientation value from the metadata
// //          print('🔴 Decoding image: ${media.storagePath}');
// //         img.Image? image = img.decodeImage(bytes);
// //         if (image == null) {
// //           // If decoding fails, add the original file to the rotated list
// //           print('🔴🔴 Failed to decode image: ${media.storagePath}');
// //           rotatedMedia.add(media);
// //           continue;
// //         }
// //         print('🔴🔴🔴🔴🔴Image decoded successfully. Dimensions: ${image.width}x${image.height}');
// //
// //         // Rotate the image file using FlutterExifRotation
// //         File rotatedImageFile = await FlutterExifRotation.rotateAndSaveImage(path: media.storagePath);
// //
// //         // Read the rotated image bytes
// //         final rotatedBytes = await rotatedImageFile.readAsBytes();
// //         img.Image? rotatedImage = img.decodeImage(rotatedBytes);
// //
// //         // Re-encode the rotated image if needed
// //         print('Re-encoding rotated image: ${media.storagePath}');
// //         print('Image re-encoded successfully: ${media.storagePath}');
// //
// //         // Replace the original media file details with the rotated version
// //         rotatedMedia.add(
// //           SelectedFile(
// //             storagePath: media.storagePath,
// //             bytes: rotatedBytes,
// //             dimensions: MediaDimensions(
// //               width: rotatedImage?.width.toDouble(),
// //               height: rotatedImage?.height.toDouble(),
// //             ),
// //             blurHash: media.blurHash,
// //           ),
// //         );
// //         print('Processed and rotated image added to list: ${media.storagePath}');
// //
// //     } catch (e) {
// //       // Handle any errors during processing
// //       print('Error processing image: ${media.storagePath}, Error: $e');
// //       rotatedMedia.add(media); // Add the original file to the rotated list if an error occurs
// //     }
// //   }
// //
// //   // Log the completion of processing for all files
// //   print('All files processed. Total files: ${rotatedMedia.length}');
// //   return rotatedMedia; // Return the list of processed and rotated media
// // }
//
// // Future<List<SelectedFile>> processAndRotateMedia(List<SelectedFile> selectedMedia) async {
// //   // 🟡 List to store processed and rotated media files
// //   List<SelectedFile> rotatedMedia = [];
// //
// //   // 🟡 Process each media file in the input list
// //   for (var media in selectedMedia) {
// //     try {
// //       print('🟡 Processing file: ${media.storagePath}');
// //
// //       // 🟡 Retrieve the bytes of the media file
// //       Uint8List? bytes = media.bytes;
// //       if (bytes == null) {
// //         print('🔴 No bytes found for file: ${media.storagePath}');
// //         rotatedMedia.add(media); // Add original file if bytes are missing
// //         continue;
// //       }
// //
// //       // 🟡 Decode the image
// //       print('🟡 Decoding image: ${media.storagePath}');
// //       img.Image? image = img.decodeImage(bytes);
// //       if (image == null) {
// //         print('🔴 Failed to decode image: ${media.storagePath}');
// //         rotatedMedia.add(media); // Add original file if decoding fails
// //         continue;
// //       }
// //       print('🟡 Image decoded successfully. Dimensions: ${image.width}x${image.height}');
// //
// //       // 🟡 Rotate the image using FlutterExifRotation
// //       File rotatedImageFile = await FlutterExifRotation.rotateAndSaveImage(path: media.storagePath);
// //       print('🟡 Image rotated and saved: ${rotatedImageFile.path}');
// //
// //       // 🟡 Read the rotated image bytes
// //       final rotatedBytes = await rotatedImageFile.readAsBytes();
// //       img.Image? rotatedImage = img.decodeImage(rotatedBytes);
// //
// //       // 🟡 Ensure the rotated image is valid
// //       if (rotatedImage == null) {
// //         print('🔴 Failed to decode rotated image: ${rotatedImageFile.path}');
// //         rotatedMedia.add(media); // Add original file if rotation fails
// //         continue;
// //       }
// //       print('🟡 Rotated image decoded successfully. Dimensions: ${rotatedImage.width}x${rotatedImage.height}');
// //
// //       // 🟡 Create a temporary file for re-encoded image
// //       String tempPath = '${rotatedImageFile.parent.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
// //       File tempFile = File(tempPath);
// //
// //       // 🟡 Re-encode the image and save it to the temporary file
// //       await tempFile.writeAsBytes(img.encodeJpg(rotatedImage));
// //       print('🟡 Rotated image re-encoded and saved to temp file: $tempPath');
// //
// //       // 🟡 Replace the original media file details with the rotated version
// //       rotatedMedia.add(
// //         SelectedFile(
// //           storagePath: tempPath,
// //           bytes: await tempFile.readAsBytes(),
// //           dimensions: MediaDimensions(
// //             width: rotatedImage.width.toDouble(),
// //             height: rotatedImage.height.toDouble(),
// //           ),
// //           blurHash: media.blurHash,
// //         ),
// //       );
// //       print('🟡 Processed and rotated image added to list: $tempPath');
// //
// //     } catch (e) {
// //       print('🔴 Error processing image: ${media.storagePath}, Error: $e');
// //       // 🟡 Add original file to the rotated list in case of errors
// //       rotatedMedia.add(media);
// //     }
// //   }
// //
// //   // 🟡 Log completion of processing
// //   print('🟡 All files processed. Total files: ${rotatedMedia.length}');
// //   return rotatedMedia; // Return the list of processed and rotated media
// // }
//
// //
// // Future<List<SelectedFile>> processAndRotateMedia(List<SelectedFile> selectedMedia) async {
// //
// //   List<SelectedFile> rotatedMedia = [];
// //
// //   for (var media in selectedMedia) {
// //
// //     try {
// //       print('🟡 Checking file path: ${media.filePath}');
// //
// //       if (media.filePath == null || media.filePath!.isEmpty) {
// //
// //         print('🔴 File path is null or empty. Skipping this file.');
// //
// //         continue;
// //       }
// //
// //       final file = File(media.filePath!);
// //
// //       if (!file.existsSync()) {
// //
// //         print('🔴 File does not exist at path: ${media.filePath}. Skipping this file.');
// //
// //         continue;
// //
// //       }
// //
// //       print('🟡 File found. Starting rotation process: ${media.filePath!}');
// //
// //       File rotatedImageFile = await FlutterExifRotation.rotateImage(path: media.filePath!);
// //
// //       final rotatedBytes = await rotatedImageFile.readAsBytes();
// //
// //       img.Image? rotatedImage = img.decodeImage(rotatedBytes);
// //
// //       if (rotatedImage == null) {
// //
// //         print('🔴 Failed to decode rotated image: ${rotatedImageFile.path}');
// //
// //         rotatedMedia.add(media); // Add original file if rotation fails
// //
// //         continue;
// //       }
// //
// //       print('🟡 Rotated image processed successfully. Dimensions: ${rotatedImage.width}x${rotatedImage.height}');
// //
// //       rotatedMedia.add(
// //
// //         SelectedFile(
// //
// //           storagePath: rotatedImageFile.path,
// //
// //           bytes: rotatedBytes,
// //
// //           dimensions: MediaDimensions(
// //
// //             width: rotatedImage.width.toDouble(),
// //
// //             height: rotatedImage.height.toDouble(),
// //
// //           ),
// //
// //           blurHash: media.blurHash,
// //
// //         ),
// //
// //       );
// //     }
// //     catch (e) {
// //
// //       print('🔴 Error processing image: ${media.filePath!}, Error: $e');
// //
// //       rotatedMedia.add(media);
// //
// //     }
// //   }
// //
// //   print('🟡 All files processed. Total files: ${rotatedMedia.length}');
// //
// //   return rotatedMedia;
// // }
//
// class LoadingDialog {
//
//   static void show(BuildContext context, {String message = "Creating PDF..."}) {
//
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(),
//                 const SizedBox(width: 16),
//                 Text(message, style: const TextStyle(fontSize: 16)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   static void hide(BuildContext context) {
//     Navigator.of(context, rootNavigator: true).pop(); // Closes the dialog
//   }
// }
//
// // Future<List<SelectedFile>> processAndRotateMedia(List<SelectedFile> selectedMedia) async {
// //
// //   List<SelectedFile> rotatedMedia = [];
// //
// //   for (var media in selectedMedia) {
// //     // try {
// //       // print('🔴 Processing file: ${media.filePath}');
// //
// //       Uint8List? bytes = media.bytes;
// //       if (bytes == null) {
// //         // print('🔴 No bytes found for file: ${media.storagePath}');
// //         continue;
// //       }
// //
// //       // Read EXIF metadata
// //       // print('🔴 Reading EXIF metadata for file: ${media.storagePath}');
// //       // final tags = await readExifFromBytes(bytes);
// //       // final orientation = tags['Image Orientation'];
// //       // print('🔴 EXIF metadata read. Orientation: ${orientation?.values ?? "Not found"}');
// //
// //       // if (orientation != null) {
// //       //   final orientationValue = orientation.values.firstAsInt();
// //
// //         // Decode the image
// //         // print('🔴🟢 Tags image: ${tags}');
// //         // print('🔴 Decoding image: ${media.storagePath}');
// //         // print('🔴🔴🔴🔴---🔴 Decoding Orientation: ${orientationValue}');
// //         // img.Image? image = img.decodeImage(bytes);
// //
// //
// //         final img.Image? capturedImage = img.decodeImage(bytes);
// //         // final img.Image rotatedImage = img.bakeOrientation(capturedImage!);
// //         // await File(media.storagePath).writeAsBytes(img.encodeJpg(rotatedImage));
// //         //
// //         // if (image == null) {
// //         //   print('🔴🔴 Failed to decode image: ${media.storagePath}');
// //         //   rotatedMedia.add(media); // Add unmodified if decoding fails
// //         //   continue;
// //         // }
// //
// //         // print('🔴🔴🔴🔴🔴Image decoded successfully. Dimensions: ${image.width}x${image.height}');
// //
// //         // Rotate based on EXIF orientation
// //         // img.Image rotatedImage = image;
// //         // switch (orientationValue) {
// //         //   case 3: // Upside down (180°)
// //         //     print('🔴🔴🔴🔴🔴🔴Rotating image 180°: ${media.storagePath}');
// //         //     rotatedImage = img.copyRotate(image, angle: 180);
// //         //     break;
// //         //   case 8: // 90° clockwise
// //         //     print('🔴🔴🔴🔴🔴🔴Rotating image 90° clockwise: ${media.storagePath}');
// //         //     rotatedImage = img.copyRotate(image, angle: -90);  // -90 for clockwise rotation
// //         //     break;
// //         //   case 6: // 90° counterclockwise
// //         //     print('🔴🔴🔴🔴🔴🔴Rotating image 90° counterclockwise: ${media.storagePath}');
// //         //     rotatedImage = img.copyRotate(image, angle: 90);  // 90 for counterclockwise rotation
// //         //     break;
// //         //   default:
// //         //     print('🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴Image is already in normal orientation: ${media.storagePath}');
// //         // }
// //
// //         // Re-encode the rotated image
// //         print('🔴🔴🔴Re-encoding rotated image: ${media.storagePath}');
// //         Uint8List rotatedBytes = Uint8List.fromList(img.encodeJpg(capturedImage!));
// //         print('🔴🔴🔴🔴Image re-encoded successfully: ${media.filePath} ${capturedImage}');
// //         //
// //         // Replace the media bytes with the rotated version
// //         rotatedMedia.add(
// //           SelectedFile(
// //             storagePath: media.storagePath,
// //             bytes: media.bytes,
// //             dimensions: MediaDimensions(
// //               width: 500,
// //               height:500,
// //             ),
// //             blurHash: media.blurHash,
// //           ),
// //         );
// //         print('🔴🔴🔴Processed and rotated image added to list: ${media.filePath}');
// //       // } else {
// //       //   // If no EXIF orientation tag, add media as-is
// //       //   print('🔴🔴🔴No EXIF orientation found. Adding unmodified file: ${media.storagePath}');
// //       //   rotatedMedia.add(media);
// //       // }
// //     // } catch (e) {
// //     //   print('🔴🔴🔴Error processing image: ${media.storagePath}, Error: $e');
// //     //   rotatedMedia.add(media); // Add unmodified if an error occurs
// //     // }
// //   }
// //
// //   print('All files processed. Total files: ${rotatedMedia.length}');
// //
// //   return rotatedMedia;
// // }