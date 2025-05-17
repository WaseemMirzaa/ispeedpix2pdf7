// import 'package:flutter/material.dart';
// import 'package:ispeedpix2pdf7/widgets/language_selector.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class MainMenuScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context) ?? _FallbackLocalizations();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(l10n.mainMenuTitle),
//         actions: [
//         //   LanguageSelector(),
//         ],
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: Icon(Icons.image),
//             title: Text(l10n.selectImages),
//             onTap: () => Navigator.pushNamed(context, '/select-images'),
//           ),
//           ListTile(
//             leading: Icon(Icons.picture_as_pdf),
//             title: Text(l10n.createPDF),
//             onTap: () => Navigator.pushNamed(context, '/create-pdf'),
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text(l10n.settings),
//             onTap: () => Navigator.pushNamed(context, '/settings'),
//           ),
//           ListTile(
//             leading: Icon(Icons.card_membership),
//             title: Text(l10n.subscription),
//             onTap: () => Navigator.pushNamed(context, '/subscription'),
//           ),
//           ListTile(
//             leading: Icon(Icons.help),
//             title: Text(l10n.howTo),
//             onTap: () => Navigator.pushNamed(context, '/how-to'),
//           ),
//           ListTile(
//             leading: Icon(Icons.privacy_tip),
//             title: Text(l10n.privacy),
//             onTap: () => Navigator.pushNamed(context, '/privacy'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FallbackLocalizations implements AppLocalizations {
//   @override
//   String get mainMenuTitle => 'Main Menu';
  
//   @override
//   String get selectImages => 'Select Images';
  
//   @override
//   String get createPDF => 'Create PDF';
  
//   @override
//   String get settings => 'Settings';
  
//   @override
//   String get subscription => 'Subscription';
  
//   @override
//   String get howTo => 'How To';
  
//   @override
//   String get privacy => 'Privacy';
  
//   // Implement other required methods with fallback strings
//   // You'll need to implement all methods from AppLocalizations
//   // This is just a temporary solution
  
//   @override
//   noSuchMethod(Invocation invocation) => 'Missing translation';
// }
