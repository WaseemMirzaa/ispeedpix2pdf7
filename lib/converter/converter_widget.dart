import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:ispeedpix2pdf7/helper/shared_preference_service.dart';
import 'package:ispeedpix2pdf7/screens/preview_pdf_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:http/http.dart' as http;

import '../custom_code/actions/pdf_multi_img.dart';
import '../helper/log_helper.dart';
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

  late SharedPreferenceService preferenceService;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Offerings? offerings;
  bool _isSubscribed = true;
  bool _is7DaysPassed = false;
  CustomerInfo? _customerInfo;

  bool _isFocused = false;
  bool _hasBackSlash = false;

  final animationsMap = <String, AnimationInfo>{};

  // final l10n = AppLocalizations.of(context)!;
  List<SelectedFile>? selectedMedia;

  @override
  void initState() {
    super.initState();

    preferenceService = SharedPreferenceService();
    preferenceService.resetPdfCreatedCount();

    _model = createModel(context, () => ConverterModel());

    _model.filenameTextController = TextEditingController();

    _model.filenameFocusNode = FocusNode();

    _model.filenameFocusNode!.addListener(() {
      if (_isFocused && selectedMedia != null) {
        LoadingDialog.show(context);

        createPDF();
      }
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

    checkSubscriptionStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeSetState(() {});

      // Ensure that no text field is focused when the app starts
      FocusScope.of(context).requestFocus(FocusNode());
    });

    initRateMyApp();
  }

  @override
  void dispose() {
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
        appBar: AppBar(
          backgroundColor: Color(0xFF173F5A),
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 10.0, 0.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          // Flutter's default refresh icon
                          color: Colors.white,
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
                                color: Colors.white,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation']!),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                _model = createModel(context, () => ConverterModel());

                _model.clearAllValues();

                _model.filenameTextController = TextEditingController();

                _selectedOrientation = 'DEFAULT - Mixed Orientation';

                _model.filenameTextController = TextEditingController();

                selectedMedia = null;

                _model.filenameDefault = '';

                safeSetState(() {});

                setState(() {});
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4.0, 0.0, 4.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        var pdfCreatedCount =
                                            await preferenceService
                                                .getPdfCreatedCount();

                                        LogHelper.logMessage(
                                            'pdfCreatedCount', pdfCreatedCount);

                                        if (pdfCreatedCount > 5 &&
                                            !_isSubscribed) {
                                          //
                                          showTrialLimitDialog(context);

                                          return;
                                        }

                                        Timer(Duration(seconds: 1), () {
                                          LoadingDialog.show(context);
                                        });

                                        LoadingDialog.isImagePickerCalled =
                                            true;
                                        LoadingDialog.isAlreadyCancelled =
                                            false;

                                        try {
                                          var media = await selectMedia(
                                            maxWidth: (Platform.isAndroid)
                                                ? 880.00 * 2
                                                : 880.00,
                                            maxHeight: (Platform.isAndroid)
                                                ? 660.00 * 2
                                                : 660.00,
                                            imageQuality:
                                                (Platform.isAndroid) ? 90 : 81,
                                            includeDimensions: true,
                                            mediaSource:
                                                MediaSource.photoGallery,
                                            multiImage: true,
                                            isSubscribed: _isSubscribed,
                                            are7DaysPassed: _is7DaysPassed,
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
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
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
                                          alignment: const AlignmentDirectional(
                                              0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        4.0, 0.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 100.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF173F5A),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  child: Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: AutoSizeText(
                                                          'Choose Files',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                          minFontSize: 8,
                                                          maxLines: 1,
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        8.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    _model.fname,
                                                    'no files selected',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                    (!_isSubscribed && _is7DaysPassed)
                                        ? '*You can select up to 3 Images in free version'
                                        : '*You can select up to 60 Images',
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
                      // Padding(
                      //   padding: const EdgeInsetsDirectional.fromSTEB(
                      //       8.0, 16.0, 8.0, 16.0),
                      //   child: TextFormField(
                      //     controller: _model.filenameTextController,
                      //     focusNode: _model
                      //         .filenameFocusNode, // Use the FocusNode here
                      //     autofocus: true,
                      //     obscureText: false,
                      //     decoration: InputDecoration(
                      //       labelText:
                      //           _isFocused ? 'Filename' : 'Filename (Optional)',
                      //       labelStyle: FlutterFlowTheme.of(context)
                      //           .labelMedium
                      //           .override(
                      //             fontFamily: 'Inter',
                      //             letterSpacing: 0.0,
                      //           ),
                      //       hintText: 'Enter custom file name (optional)',
                      //       hintStyle: FlutterFlowTheme.of(context)
                      //           .labelMedium
                      //           .override(
                      //             fontFamily: 'Inter',
                      //             letterSpacing: 0.0,
                      //           ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: FlutterFlowTheme.of(context).alternate,
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: const BorderSide(
                      //           color: Color(0xFF173F5A),
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       errorBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Colors.red,
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       focusedErrorBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color:  Colors.red,
                      //           width: 2.0,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       filled: true,
                      //     ),
                      //     style:
                      //         FlutterFlowTheme.of(context).bodyMedium.override(
                      //               fontFamily: 'Inter',
                      //               letterSpacing: 0.0,
                      //             ),
                      //     validator: _model.filenameTextControllerValidator
                      //         .asValidator(context),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            8.0, 16.0, 8.0, (_hasBackSlash ? 6.0 : 16.0)),
                        child: TextFormField(
                          controller: _model.filenameTextController,
                          focusNode: _model.filenameFocusNode,
                          onChanged: (value) {
                            _hasBackSlash = false;

                            setState(() {
                              const invalidCharacters = r'\/:*?"<>|';

                              for (var char in invalidCharacters.runes) {
                                if (value.contains(String.fromCharCode(char))) {
                                  _hasBackSlash = true;
                                }
                              }
                            });
                          },
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText:
                                _isFocused ? 'Filename' : 'Filename (Optional)',
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: 'Enter custom file name (optional)',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
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
                              borderSide: const BorderSide(
                                color: Color(0xFF173F5A),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model
                              .filenameTextControllerValidator, // Assign the validator here
                        ),
                      ),
                      if (_hasBackSlash)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 0, 8.0, 16.0),
                          child: Text(
                            'Filename cannot contain any of the following characters: \\ / : * ? " < > |',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: Colors.red),
                          ),
                        ),

                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (_model.pdfFile != null &&
                              (_model.pdfFile?.bytes?.isNotEmpty ?? false))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 4.0, 8.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_hasBackSlash) {
                                    showFilenameErrorDialog(context);
                                  } else {
                                    var isPermissionEnabled =
                                        await _requestStoragePermission(
                                            context);

                                    if (!isPermissionEnabled) {
                                      return;
                                    }

                                    _model.filenameDefaultDown = await actions
                                        .generateFormattedDateTime();

                                    _model.download =
                                        await actions.downloadFFUploadedFile(
                                      _model.pdfFile!,
                                      _model.filenameTextController.text != ''
                                          ? _model.filenameTextController.text
                                          : _model.filenameDefaultDown!,
                                    );

                                    safeSetState(() {});
                                  }
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
                                  color: Color(0xFF173F5A),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF173F5A),
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
                                  8.0, 4.0, 8.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_hasBackSlash) {
                                    showFilenameErrorDialog(context);
                                  } else {
                                    if (_model.filenameTextController.text
                                        .isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewerScreen(
                                            pdfBytes: _model.pdfFile!.bytes,
                                            title: _model
                                                .filenameTextController.text,
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
                                    }
                                    safeSetState(() {});
                                  }
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
                                  color: Color(0xFF173F5A),
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
                                    color: Color(0xFF173F5A),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 4, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed('Mainmenu');
                              },
                              text: 'About',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF173F5A),
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
                                  color: Color(0xFF173F5A),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          // if( !_isSubscribed )
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8.0, 4.0, 8.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed('Subscription').then((_) {
                                  checkSubscriptionStatus();
                                  setState(
                                      () {}); // This will trigger a rebuild, calling initState if necessary
                                });
                              },
                              text: !_isSubscribed
                                  ? 'Get Full Lifetime Access in 4.99\$'
                                  : 'View Purchase Details',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFF173F5A),
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
                                  color: Color(0xFF173F5A),
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
                                color: const Color(0xFF8ca9cf),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
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
                                                fontSize: 12.0,
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
      LoadingDialog.hide(context);

      return;
    }

    if (selectedMedia != null &&
        selectedMedia!
            .every((m) => validateFileFormat(m.storagePath, context))) {
      if (!_isSubscribed) {
        preferenceService.incrementAndReturnPdfCreatedCount();
      }

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
      final pileupList = _model.uploadedLocalFiles.map((file) {
        return SerializableFile(file.bytes!, file.name!).toMap();
      }).toList();

      print('🔴🔴🔴🔴🔴 ${_model.filenameTextController.text}');

      final params = PdfMultiImgParams(
        fileupList: pileupList,
        filename: valueOrDefault<String>(
          _model.filenameTextController.text,
          'file',
        ),
        notes: _model.filenameTextController.text,
        isFirstPageSelected: true,
        fit: 'contain',
        selectedIndex: _orientationOptions.indexOf(_selectedOrientation),
      );

      _model.pdf2 = await pdfMultiImgWithIsolate(params);

      _model.pdfFile = _model.pdf2;

      _model.landscapeExists = _model.checkLandscapeGallery;

      safeSetState(() {});
    } else {
      final pileupList = _model.uploadedLocalFiles.map((file) {
        return SerializableFile(file.bytes!, file.name!).toMap();
      }).toList();

      print('🔴🔴🔴🔴🔴 ${_model.filenameTextController.text}');

      final params = PdfMultiImgParams(
        fileupList: pileupList,
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

      _model.pdfFile = _model.pdf2;
      _model.landscapeExists = _model.checkLandscapeGallery;

      safeSetState(() {});
    }

    safeSetState(() {});
    LoadingDialog.hide(context);
  }

  Future<bool> checkPreviousAppPurchase() async {
    if (!Platform.isIOS) {
      LogHelper.logMessage('Platform Check', 'Not iOS platform');
      return false;
    }

    try {
      final client = http.Client();

      // Try up to 3 times to get the receipt
      for (int i = 0; i < 3; i++) {
        try {
          final receipt = await const MethodChannel('app_store_receipt')
              .invokeMethod<String>('getReceipt');

          if (receipt != null) {
            // isPurchased = true;
            setState(() {
              // isPurchased = true;
              _isSubscribed = true;
            });
            LogHelper.logMessage('Receipt Status', 'Receipt found on device');
            LogHelper.logMessage('Receipt Data',
                '${receipt.substring(0, min(50, receipt.length))}...');

            // First try production URL
            final prodResponse = await _verifyReceipt(receipt, false);
            if (prodResponse != null && prodResponse['status'] == 0) {
              setState(() {
                // isPurchased = true;
                _isSubscribed = true;
              });
              LogHelper.logSuccessMessage(
                  'Purchase Verification', 'Valid production receipt found');
              return true;
            }

            // If production fails, try sandbox
            final sandboxResponse = await _verifyReceipt(receipt, true);
            if (sandboxResponse != null && sandboxResponse['status'] == 0) {
              LogHelper.logSuccessMessage(
                  'Purchase Verification', 'Valid sandbox receipt found');
              return true;
            }
          }

          LogHelper.logMessage(
              'Receipt Attempt', 'Attempt ${i + 1} failed, retrying...');
          await Future.delayed(const Duration(seconds: 1));
        } catch (e) {
          LogHelper.logErrorMessage('Receipt Fetch Error', e);
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      LogHelper.logErrorMessage(
          'Receipt Status', 'Failed to verify receipt after 3 attempts');
      return false;
    } catch (e) {
      LogHelper.logErrorMessage('Receipt Validation', e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> _verifyReceipt(
      String receipt, bool sandbox) async {
    try {
      // In debug mode, always try sandbox endpoint first
      final url = 'https://sandbox.itunes.apple.com/verifyReceipt';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'receipt-data': receipt,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      LogHelper.logErrorMessage('Receipt Verification Error', e);
    }
    return null;
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      PermissionStatus status;

      if (int.parse(Platform.version.split('.')[0]) >= 13) {
        // For Android 13+ (API 33+)
        status = await Permission.photos.request();
      } else if (int.parse(Platform.version.split('.')[0]) >= 11) {
        // For Android 11 and 12 (API 30, 31, 32)
        status = await Permission.storage.request();
      } else {
        // For Android 10 and below
        status = await Permission.storage.request();
      }

      if (status.isDenied) {
        _showPermissionDialog(
          context,
          'This app needs storage permission to save PDFs',
          // AppLocalizations.of(context)!.storagePermissionMessageRequired
        );
        return false;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDialog(
            context, 'This app needs storage permission to save PDFs',
            openSettings: true);
        return false;
      }
    }
    return true;
  }

  Future<void> checkSubscriptionStatus() async {
    _is7DaysPassed =
        await SharedPreferenceService().isFirstOpenDateOlderThan7Days();

    LogHelper.logErrorMessage('7DaysPassed', _is7DaysPassed);

    _customerInfo = await Purchases.getCustomerInfo();

    offerings = await Purchases.getOfferings();

    LogHelper.logSuccessMessage('Customer Info', _customerInfo);

    LogHelper.logSuccessMessage('Offerings', offerings);

    if (_customerInfo?.entitlements.all['sub_lifetime'] != null &&
        _customerInfo?.entitlements.all['sub_lifetime']?.isActive == true) {
      // User has subscription, show them the feature
      setState(() {
        _isSubscribed = true;
      });
    } else {
      _isSubscribed = false;

      setState(() {});
      checkPreviousAppPurchase();
    }
  }

  void initRateMyApp() {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 7,
      minLaunches: 7,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: 'com.mycompany.ispeedpix2pdf7',
      appStoreIdentifier: '6667115897',
    );

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message:
              'If you enjoy using this app, we’d really appreciate it if you could take a minute to leave a review! Your feedback helps us improve and won’t take more than a minute of your time.', // The dialog message.
          rateButton: 'RATE', // The dialog "rate" button text.
          noButton: 'NO THANKS', // The dialog "no" button text.
          laterButton: 'MAYBE LATER', // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreNativeDialog:
              false, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: const DialogStyle(), // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // contentBuilder: (co/ntext, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );
      }
    });
  }
}

class LoadingDialog {
  static bool isShowing = false;
  static bool isImagePickerCalled = false;
  static bool isAlreadyCancelled = false;

  static void show(BuildContext context, {String message = "Creating PDF..."}) {
    if (isAlreadyCancelled) {
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
    Navigator.of(context, rootNavigator: true).pop(); // Closes the dialog
  }
}

// Function to show an AlertDialog for permissions
void _showPermissionDialog(BuildContext context, String message,
    {bool openSettings = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (openSettings)
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
        ],
      );
    },
  );
}

void showTrialLimitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            textAlign: TextAlign.center,
            "FREE TRIAL EXPIRED or FREE FEATURES EXHAUSTED",
            style: FlutterFlowTheme.of(context).displayMedium.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF173F5A),
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/premium.png',
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.justify,
              "FREE FEATURES RENEW EVERY 7 DAYS",
              // textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.justify,
              'UPGRADE NOW WITH A ONE TIME PURCHASE & UNLOCK THE FULL POWER OF iSpeedPix2PDF 🚀.',
              // textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).displayMedium.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF173F5A),
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel",
                style: FlutterFlowTheme.of(context).displayMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    )),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to subscription page
              Navigator.pop(context);
              context.pushNamed('Subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF173F5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Upgrade Now",
                style: FlutterFlowTheme.of(context).displayMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    )),
          ),
        ],
      );
    },
  );
}

void showFilenameErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invalid Filename'),
        content: Text(
            'Filename cannot contain any of the following characters: \\ / : * ? " < > |'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
