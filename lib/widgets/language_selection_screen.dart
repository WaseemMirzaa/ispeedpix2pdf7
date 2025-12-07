import 'package:flutter/material.dart';
import 'package:ispeedpix2pdf7/converter/converter_widget.dart';
import 'package:ispeedpix2pdf7/helper/language_service.dart';
import 'package:ispeedpix2pdf7/l10n/app_localizations.dart';
import 'package:ispeedpix2pdf7/flutter_flow/flutter_flow_theme.dart';
import 'package:ispeedpix2pdf7/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';

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
      'he': 'עברית',
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
          padding:
              const EdgeInsets.only(left: 8.0, right: 8, top: 16, bottom: 8),
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
                      margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
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
                                color: Color(0xFF173F5A),
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

                          // Update the app's locale first
                          if (context.mounted) {
                            MyApp.of(context).setLocale(newLocale);
                          }

                          // Log analytics event
                          try {
                            final analytics = FirebaseAnalytics.instance;
                            await analytics.logEvent(
                              name: 'event_on_language_changed',
                              parameters: {
                                'previous_language': currentLocale.languageCode,
                                'new_language': languageCode,
                                'timestamp': DateTime.now().toIso8601String(),
                              },
                            );
                          } catch (e) {
                            print('Failed to log language change event: $e');
                          }

                          // Use GoRouter to navigate and clear the stack
                          if (context.mounted) {
                            // Navigate to the converter route which is already defined in your nav.dart
                            try {
                              // This will replace the entire navigation stack with just the converter route
                              context.pushReplacement('/converter');
                            } catch (e) {
                              print('Navigation error: $e');

                              // Fallback approach if the route isn't working
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => ConverterWidget(),
                                ),
                                (route) => false, // Remove all previous routes
                              );
                            }
                          }
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
