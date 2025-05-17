import 'package:flutter/material.dart';
import 'package:ispeedpix2pdf7/helper/language_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ispeedpix2pdf7/flutter_flow/flutter_flow_theme.dart';
import 'package:ispeedpix2pdf7/main.dart';

class LanguageSelectionScreen extends StatelessWidget {
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
      // backgroundColor:  Color(0xFF173F5A),
      appBar: AppBar(
        backgroundColor: Color(0xFF173F5A),
        title: Text(
          l10n.chooseLanguage,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: Colors.white,
              ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 2,
      ),
      body: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final languageCode = languages.keys.elementAt(index);
                    final languageName = languages[languageCode]!;

                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x3416202A),
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          languageName,
                          style: FlutterFlowTheme.of(context).bodyLarge,
                        ),
                        trailing: FutureBuilder<Locale>(
                          future: LanguageService.getLocale(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.languageCode == languageCode) {
                              return Icon(
                                Icons.check_circle,
                                color:  Color(0xFF173F5A),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        onTap: () async {
                          // Change the language in SharedPreferences
                          await LanguageService.changeLanguage(languageCode);

                          // Get the new locale
                          final newLocale = Locale(languageCode, '');

                          // Update the app's locale
                          if (context.mounted) {
                            MyApp.of(context).setLocale(newLocale);
                          }

                          // Return true to indicate language changed
                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
