import 'package:flutter/material.dart';
import 'package:ispeedpix2pdf7/helper/language_service.dart';
import 'package:ispeedpix2pdf7/helper/orientation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ispeedpix2pdf7/flutter_flow/flutter_flow_theme.dart';
import 'package:ispeedpix2pdf7/main.dart';
import 'package:ispeedpix2pdf7/converter/converter_widget.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    // Get current language code
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locale = await LanguageService.getLocale();
      setState(() {
        _selectedLanguageCode = locale.languageCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Map of language codes to their display names
    final Map<String, String> languages = {
      'en': 'English',
      'es': 'Español',
      'zh': '中文',
      'fr': 'Français',
      'de': 'Deutsch',
      'pt': 'Português',
      'ar': 'العربية',
      'hi': 'हिंदी',
      'ja': '日本語',
      'ko': '한국어',
      'ru': 'Русский',
      'it': 'Italiano',
      'tr': 'Türkçe',
      'vi': 'Tiếng Việt',
      'th': 'ไทย',
    };

    // Get current locale
    final currentLocale = Localizations.localeOf(context);
    final isRtl = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF173F5A),
        title: Text(
          l10n.chooseLanguage,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: Colors.white,
              ),
        ),
        centerTitle: false,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            size: 30.0,
          ),
        ),
        elevation: 2,
      ),
      body: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16.0),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final languageCode = languages.keys.elementAt(index);
                  final languageName = languages[languageCode]!;

                  return Container(
                    margin:
                        EdgeInsets.only(bottom: 4, left: 16, right: 16, top: 8),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Color(0x3416202A),
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: ListTile(
                      title: Text(
                        languageName,
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                      trailing: _selectedLanguageCode == languageCode
                          ? Icon(
                              Icons.check_circle,
                              color: Color(0xFF173F5A),
                            )
                          : SizedBox.shrink(),
                      onTap: () {
                        setState(() {
                          _selectedLanguageCode = languageCode;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // Save button at the bottom
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _selectedLanguageCode == null
                    ? null
                    : () async {
                        // Change the language
                        await LanguageService.changeLanguage(
                            _selectedLanguageCode!);

                        // Get the new locale
                        final newLocale = Locale(_selectedLanguageCode!, '');

                        // Update the app's locale
                        // if (context.mounted) {
                        MyApp.of(context).setLocale(newLocale);
// MyApp(context).set(newLocale);

                        // Preserve the current orientation index
                        final currentIndex =
                            OrientationService.selectedOrientationIndex;

                        Navigator.of(context).pop(true);
                        // Navigator.of(context).pop(true);

                        // }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF173F5A),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.save ?? "Save",
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
