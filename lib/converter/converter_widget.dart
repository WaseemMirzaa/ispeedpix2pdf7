import 'dart:async';

import 'package:ispeedpix2pdf7/screens/preview_pdf_screen.dart';

import '../custom_code/actions/pdf_multi_img.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'converter_model.dart';
export 'converter_model.dart';

class ConverterWidget extends StatefulWidget {
  const ConverterWidget({super.key});

  @override
  State<ConverterWidget> createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<ConverterWidget>
    with TickerProviderStateMixin {
  late ConverterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // late FocusNode _filenameFocusNode;
  bool _isFocused = false;

  final animationsMap = <String, AnimationInfo>{};

  List<SelectedFile>? selectedMedia;

  @override
  void initState() {
    super.initState();


    _model = createModel(context, () => ConverterModel());

    _model.filenameTextController ??= TextEditingController();

    _model.filenameFocusNode = FocusNode();

    _model.filenameFocusNode!.addListener(() {
      setState(() {
        _isFocused = _model.filenameFocusNode!.hasFocus;
      });
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(3.0, 3.0),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }


  @override
  void dispose() {
    // Don't forget to dispose of the FocusNode
    _model.dispose();

    super.dispose();
  }

  String _selectedOrientation =
      'DEFAULT - Mixed Orientation'; // Default selection

  // List of options for the dropdown
  final List<String> _orientationOptions = [
    'DEFAULT - Mixed Orientation',
    'Pages Fixed - Portrait',
    'Landscape Photos - Top Aligned for easy viewing'
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 3.0, 0.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    // Flutter's default refresh icon
                                    color: const Color(0xFF4A90E2),
                                    // Match icon color with text
                                    size: 24.0, // Adjust size to fit the text
                                  ),
                                  const SizedBox(width: 5.0),
                                  // Add spacing between icon and text
                                  Text(
                                    'Reset',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .displayMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: const Color(0xFF4A90E2),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ).animateOnPageLoad(animationsMap[
                                      'textOnPageLoadAnimation']!),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _selectedOrientation = 'DEFAULT - Mixed Orientation';

                          _model.filenameTextController.text = '';

                          _model.clearAllValues();

                          selectedMedia = null;

                          safeSetState(() {});
                        },
                      ),
                      Container(
                        width: 120.0,
                        height: 120.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/70769789-ECA9-4E75-AE97-86FF559889DF.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            3.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'iSpeedPix2PDF',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .displayMedium
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation']!),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            4, 0, 4.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                            ),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                3.0, 0.0, 0.0, 0.0),
                            child: DropdownButton<String>(
                              underline: Container(),
                              value: _selectedOrientation,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOrientation = newValue!;

                                  LoadingDialog.show(context);

                                  createPDF();

                                });
                              },
                              items: _orientationOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                );
                              }).toList(),
                              isExpanded:
                                  true, // Makes the dropdown button fill the available width
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 0.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 4.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        Timer(Duration(seconds: 1), () {

                                          // if(!LoadingDialog.isAlreadyCancelled) {
                                            LoadingDialog.show(context);
                                          // }
                                        });

                                        LoadingDialog.isImagePickerCalled = true;
                                        LoadingDialog.isAlreadyCancelled  = false;

                                        try {
                                          var media = await selectMedia(
                                            maxWidth: 880.00,
                                            maxHeight: 660.00,
                                            imageQuality: 80,
                                            includeDimensions: true,
                                            mediaSource: MediaSource.photoGallery,
                                            multiImage: true,
                                          );

                                          if (media != null) {
                                            selectedMedia = media;
                                          }


                                          Timer(Duration(seconds: 1), () {

                                            createPDF();

                                          });


                                        } catch (e) {
                                          print(
                                              '🔴🔴🔴Error While Creating PDF: $e');
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width * 1.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(0.0),
                                            topRight: Radius.circular(0.0),
                                          ),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Align(
                                          alignment:
                                              const AlignmentDirectional(0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 100.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        FlutterFlowTheme.of(context)
                                                            .secondaryText,
                                                    borderRadius:
                                                        BorderRadius.circular(30.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      'Choose Files',
                                                      style: FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            color:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    _model.fname,
                                                    'no files selected',
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, left: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '*You can select up to 60 Images.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 0.0),
                        child: TextFormField(
                          controller: _model.filenameTextController,
                          focusNode: _model.filenameFocusNode, // Use the FocusNode here
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: _isFocused ? 'Filename' : 'Filename (Optional)',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            hintText: 'Enter custom file name (optional)',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                          validator: _model.filenameTextControllerValidator.asValidator(context),
                        ),
                      )
,
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (_model.pdfFile != null &&
                              (_model.pdfFile?.bytes?.isNotEmpty ?? false))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 12.0, 8.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  _model.filenameDefaultDown =
                                      await actions.generateFormattedDateTime();
                                  _model.download =
                                      await actions.downloadFFUploadedFile(
                                    _model.pdfFile!,
                                    _model.filenameTextController.text != ''
                                        ? _model.filenameTextController.text
                                        : _model.filenameDefaultDown!,
                                  );

                                  safeSetState(() {});
                                },
                                text: 'Download PDF',
                                icon: const Icon(
                                  Icons.sim_card_download_sharp,
                                  size: 20.0,
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFF4A90E2),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          if (_model.pdfFile != null &&
                              (_model.pdfFile?.bytes?.isNotEmpty ?? false))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_model.filenameTextController.text !=
                                      '') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewerScreen(
                                          pdfBytes: _model.pdfFile!.bytes,
                                          title: _model.filenameDefault!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    _model.filenameDefault = await actions
                                        .generateFormattedDateTime();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewerScreen(
                                            pdfBytes: _model.pdfFile!.bytes,
                                            title: _model.filenameDefault!),
                                      ),
                                    );
                                    // await showModalBottomSheet(
                                    //   isScrollControlled: true,
                                    //   backgroundColor: Colors.transparent,
                                    //   useSafeArea: true,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return GestureDetector(
                                    //       onTap: () {
                                    //         FocusScope.of(context).unfocus();
                                    //         FocusManager.instance.primaryFocus
                                    //             ?.unfocus();
                                    //       },
                                    //       child: Padding(
                                    //         padding: MediaQuery.viewInsetsOf(
                                    //             context),
                                    //         child: Container(
                                    //           height: PdfDimensionsHelper.calculateA4Height(MediaQuery.sizeOf(context).width * 0.95) + 100,
                                    //
                                    //           child: ViewPdfWidget(
                                    //             pdf: _model.pdfFile!,
                                    //             filename:
                                    //                 _model.filenameDefault!,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // ).then((value) => safeSetState(() {}));
                                  }

                                  safeSetState(() {});
                                },
                                text: 'View PDF',
                                icon: const Icon(
                                  Icons.visibility,
                                  size: 20.0,
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0xFF4A90E2),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 16.0, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed('Mainmenu');
                              },
                              text: 'Main Menu',
                              // icon: const Icon(
                              //   Icons.men,
                              //   size: 20.0,
                              // ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: const Color(0xFF4A90E2),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsetsDirectional.fromSTEB(
                          //       0.0, 20.0, 0.0, 0.0),
                          //   child: FFButtonWidget(
                          //     onPressed: () async {
                          //       context.pushNamed('Mainmenu');
                          //     },
                          //     text: 'Main Menu',
                          //     options: FFButtonOptions(
                          //       height: 40.0,
                          //       padding: const EdgeInsetsDirectional.fromSTEB(
                          //           24.0, 0.0, 24.0, 0.0),
                          //       iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          //           0.0, 0.0, 0.0, 0.0),
                          //       color: const Color(0xFF4A90E2),
                          //       textStyle: FlutterFlowTheme.of(context)
                          //           .titleSmall
                          //           .override(
                          //             fontFamily: 'Inter',
                          //             color: Colors.white,
                          //             letterSpacing: 0.0,
                          //           ),
                          //       elevation: 3.0,
                          //       borderSide: const BorderSide(
                          //         color: Colors.transparent,
                          //         width: 1.0,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF094300),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RichText(
                                        textScaler:
                                            MediaQuery.of(context).textScaler,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Data Collection:',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  ' We do not collect, store, or process any personal data from users. All data is handled locally on your device. This means:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  '\n- No images are uploaded to a server.\n- No personal data is collected, stored, or shared by our mobile app.',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(height: 12.0)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createPDF() async {
    if (selectedMedia == null) {

      // Timer(Duration(seconds: 1), () {
        LoadingDialog.hide(context);
      // });

      return;
    }

    if (selectedMedia != null &&
        selectedMedia!
            .every((m) => validateFileFormat(m.storagePath, context))) {
      safeSetState(() => _model.isDataUploading = true);
      var selectedUploadedFiles = <FFUploadedFile>[];

      try {
        selectedUploadedFiles = selectedMedia!
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                ))
            .toList();
      } finally {
        _model.isDataUploading = false;
      }
      if (selectedUploadedFiles.length == selectedMedia!.length) {
        safeSetState(() {
          _model.uploadedLocalFiles = selectedUploadedFiles;
        });
      } else {
        safeSetState(() {});
        return;
      }
    }

    if (_model.uploadedLocalFiles.length > 1) {
      _model.fname =
          '${_model.uploadedLocalFiles.length.toString()} Files Selected';
      safeSetState(() {});
    } else {
      _model.name = await actions.filename(
        _model.uploadedLocalFiles.firstOrNull!,
      );
      _model.fname = _model.name;
      safeSetState(() {});
    }

    _model.checkLandscapeGallery = await actions.checkIfLandscape(
      _model.uploadedLocalFiles.toList(),
    );
    if (_model.checkLandscapeGallery!) {
      final fileupList = _model.uploadedLocalFiles.map((file) {
        return SerializableFile(file.bytes!, file.name!).toMap();
      }).toList();

      final params = PdfMultiImgParams(
        fileupList: fileupList,
        filename: valueOrDefault<String>(
          _model.filenameTextController.text,
          'file',
        ),
        notes: _model.filenameTextController.text,
        isFirstPageSelected: true,
        // Hardcoded 'true' as per the example
        fit: 'contain',
        // Hardcoded 'contain' as per the example
        selectedIndex: _orientationOptions.indexOf(
            _selectedOrientation), // Get the index of the selected orientation
      );

      // LoadingDialog.hide(context);

      _model.pdf2 = await pdfMultiImgWithIsolate(params);
      _model.pdfFile = _model.pdf2;

      _model.landscapeExists = _model.checkLandscapeGallery;

      safeSetState(() {});
    } else {
      final fileupList = _model.uploadedLocalFiles.map((file) {
        return SerializableFile(file.bytes!, file.name!).toMap();
      }).toList();

      final params = PdfMultiImgParams(
        fileupList: fileupList,
        filename: valueOrDefault<String>(
          _model.filenameTextController.text,
          'file',
        ),
        notes: _model.filenameTextController.text,
        isFirstPageSelected: true,
        // Pass 'true' as specified
        fit: 'contain',
        // Pass 'contain' as specified
        selectedIndex: _orientationOptions.indexOf(
            _selectedOrientation), // Use the index of the selected orientation
      );

      _model.pdf2 = await pdfMultiImgWithIsolate(params);

      // LoadingDialog.hide(context);

      _model.pdfFile = _model.pdf2;
      _model.landscapeExists = _model.checkLandscapeGallery;

      safeSetState(() {});
    }
    safeSetState(() {});
    LoadingDialog.hide(context);
  }
}

class LoadingDialog {
  static bool isShowing = false;
  static bool isImagePickerCalled = false;
  static bool isAlreadyCancelled = false;

  static void show(BuildContext context, {String message = "Creating PDF..."}) {
    if(isAlreadyCancelled)
    {
      isAlreadyCancelled = false;
      return;
    }

    isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(message, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context, {bool isImagePickerCalled = false}) {

    // isShowing = false?

    // Timer(Duration(seconds: 1), () {

      Navigator.of(context, rootNavigator: true).pop(); // Closes the dialog
    // });


  }
}
