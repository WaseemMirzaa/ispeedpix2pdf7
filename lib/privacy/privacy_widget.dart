import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'privacy_model.dart';
export 'privacy_model.dart';

class PrivacyWidget extends StatefulWidget {
  const PrivacyWidget({super.key});

  @override
  State<PrivacyWidget> createState() => _PrivacyWidgetState();
}

class _PrivacyWidgetState extends State<PrivacyWidget>
    with TickerProviderStateMixin {
  late PrivacyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  var point0 = 'Welcome to iSpeedPix2PDF. We are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use the iSpeedPix2PDF app on mobile devices.';
  var point1 = '1. Information Collection and Use - iSpeedPix2PDF is a client-side app; all data processed by the app remains local to your device, with no data sent to external servers for processing.\n-Photo Gallery Access: iSpeedPix2PDF requires access to your device’s photo gallery to allow you to select images for conversion into PDFs.\n-Once a PDF is generated, the app does not store or retain any files. Users have full control over their PDFs and can choose to share, email, save, or upload them as they prefer.';
  var point2= '2. No Data Transmission - As a client-side app, iSpeedPix2PDF ensures that none of your data, including personal information or generated PDFs, is transmitted to external servers or third-party services. Every step of the process—from selecting images to generating PDFs—happens entirely on your device, guaranteeing the highest level of privacy and security.';
  var point3= '3. One-Time Lifetime Subscription - iSpeedPix2PDF operates on a one-time lifetime subscription model, meaning you only need to pay once for full access to all features—no recurring charges, no hidden fees. Payment processing is handled securely through a service to verify and manage purchases. Once purchased, the app remains fully functional without requiring additional payments.';
  var point4= '4. No Advertisements - We do not display ads or sell your data. iSpeedPix2PDF is designed to provide a seamless and efficient user experience without interruptions from advertisements. Our focus is on ensuring a simple and secure method for creating and sharing PDFs, completely under your control.';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrivacyModel());

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(-74.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

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
        appBar: AppBar(
          backgroundColor: const Color(0xFF173F5A),
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.safePop();
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 30.0,
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 0.0),
                        child: Text(
                          'Privacy and Security',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20.0, 20.0, 20.0, 0.0),
                        child: Text(
                          '$point0\n\n$point1\n\n$point2\n\n$point3\n\n$point4',
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 12.5,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation']!),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // context.pushReplacement('Mainmenu');
                    },
                    text: 'Main Menu',
                    options: FFButtonOptions(
                      height: 40.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: const Color(0xFF173F5A),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                      elevation: 3.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
