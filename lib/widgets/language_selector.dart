// import 'package:flutter/material.dart';
// import 'package:ispeedpix2pdf7/helper/language_service.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class LanguageSelector extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!; // Get the localization instance

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Reset button using localized text
//         TextButton(
//           onPressed: () {
//             // Your reset logic here
//           },
//           child: Text(l10n.reset), // Using localized 'reset' text
//         ),
//         // Existing language selector
//         PopupMenuButton<String>(
//           onSelected: (String languageCode) async {
//             await LanguageService.changeLanguage(languageCode);
//             // Restart app or update locale
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             const PopupMenuItem<String>(
//               value: 'en',
//               child: Text('English'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'es',
//               child: Text('Español'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'zh',
//               child: Text('中文'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'fr',
//               child: Text('Français'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'de',
//               child: Text('Deutsch'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'pt',
//               child: Text('Português'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'ar',
//               child: Text('العربية'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'hi',
//               child: Text('हिंदी'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'ja',
//               child: Text('日本語'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'ko',
//               child: Text('한국어'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'ru',
//               child: Text('Русский'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'it',
//               child: Text('Italiano'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'tr',
//               child: Text('Türkçe'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'vi',
//               child: Text('Tiếng Việt'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'th',
//               child: Text('ไทย'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
